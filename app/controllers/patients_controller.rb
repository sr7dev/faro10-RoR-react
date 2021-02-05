class PatientsController < ApplicationController
  # TODO dry up calls to membership
  # before_action :set_membership, except: [:index]

  def index
    authorize! :access, PatientsController

    members = current_user.members

    @new_member = Member.new
    @membership = Membership.new
    # @observer_journal_entries = members.observer_journal_entries

    if request.xhr?
      if(params[:race])
        members = members.by_race(params[:race])
      end

      if(params[:gender])
        members = members.by_gender(params[:gender])
      end

      if(params[:diagnosis])
        members = members.by_diagnosis(params[:diagnosis])
      end

      if(params[:prescription]).present?
        drug = Drug.find_by(friendly_name: params[:prescription])
        members = members.joins(:prescriptions).where(prescriptions: {drug_id: drug.id})
      end

      if params[:age_start]
        group = [params[:age_start].to_i, params[:age_end].to_i]
        members = members.age_group(group)
      end
    end

    @memberships = Membership.where(clinician_id: current_user.id, member_id: members.pluck(:id)).ordered_by_member_name

    respond_to do |format|
      format.html
      format.js do
        render template: "patients/filter_table"
      end
    end
  end

  # GET /patients/:id/liability
  def liability
    authorize! :access, PatientsController

    @members = current_user.members #Membership.joins(:users).where(memberships: {clinician_id: current_user.id}).uniq
    @new_member = Member.new
  end

  def patient_meetings
    @meetings = Meeting.all

    @user = current_user
    @memberships = current_user.memberships
    @new_user = User.new
    @messages = current_user.messages.unarchived.sort_by(&:created_at).reverse

  end

  def collaboration
    authorize! :access, PatientsController
    @member = Member.find(params[:id])
    authorize! :read, @member
    @new_member = Member.new
    @clinician_entries = @member.clinician_entries.order(observed_at: :desc)
    @dsm_diagnoses = @member.dsm_diagnoses
    @icd_diagnoses = @member.icd_diagnoses
    @new_dsm_diagnosis = Diagnosis.new
    @new_icd_diagnosis = Diagnosis.new
  end

  def search_dsm5
    @dsm5s = MedicalCondition.search_dsm5(params[:term]).to_json

    respond_to do |format|
      format.json {
        render json: @dsm5s
      }
    end
  end

  def search_icd10
    @icd10s = MedicalCondition.search_icd10(params[:term]).to_json

    respond_to do |format|
      format.json {
        render json: @icd10s
      }
    end
  end

  def medical_necessity
    @member = Member.find(params[:id])

    authorize! :read, @member

    @members = current_user.members #Membership.joins(:users).where(memberships: {clinician_id: current_user.id}).uniq
    @new_member = Member.new
    @clinician = current_user
  end

  def patient_summary        #this is a pdf patient summary that a clinician can print before going into a session if needed or store in their records
    @member = Member.find(params[:id])

    authorize! :read, @member

    @journal_entries = @member.entries.where.not(journal: nil).order(created_at: :desc)
    @observer_journal_entries = @member.observer_journal_entries
    @clinician_entries = @member.clinician_entries.order(observed_at: :desc)
    @last_entry = @member.entries('created_at').last
    @patient_entry_total = @member.entries.distinct.count(:created_at)

    @patient_self_harm_total = @member.entries.count(:self_harm)
    @patient_attended_sessions_total = @member.entries.count(:attended_session)
    @patient_observer_entries = @member.observer_entries_on_me.count

    @prescriptions = @member.prescriptions.visible_to(current_user)
    @unexpired = @prescriptions.unexpired
    @expired = @prescriptions.expired

    respond_to do |format|
      format.pdf do
        str = render_to_string(formats: [:html], layout: "patient_summary")
        kit = PDFKit.new(str)
        send_data kit.to_pdf, type: :pdf, disposition: "inline"
      end
    end
  end

  def add_journal_visible
    @membership = Membership.find(params[:id])

    authorize! :update, @membership

    if @membership.present?
      if @membership.update(journal_visible: true)
        flash[:info] = "This Clinician can now view your Journal."
      else
        flash[:danger] = "There was an issue"
      end
    else
      flash[:danger] = "There was an issue"
    end
    redirect_back fallback_location: root_path
  end

  def remove_journal_visible
    @membership = Membership.find(params[:id])

    authorize! :update, @membership

    if @membership.present?
      if @membership.update(journal_visible: false)
        flash[:info] = "This Clinician can no longer view your Journal."
      else
        flash[:danger] = "There was an issue"
      end
    else
      flash[:danger] = "There was an issue"
    end
    redirect_back fallback_location: root_path
  end

  def show
    @member = Member.find(params[:id])

    authorize! :read, @member

    @observers = @member.observers
    @observations = @member.observations_on_me.active
    @membership = Membership.where(clinician_id: current_user.id, member_id: @member.id).take
    @consent = @membership.consents.order("created_at DESC").first
    entries = @member.entries.where("created_at <= ?", @consent.ended_at)

    authorize! :read, @membership

    @scorecard = Scorecard.new(@member)

    if @membership.journal_visible?
      @journal_entries = entries.where.not(journal: nil).order(created_at: :desc)
    end

    @observer_journal_entries = @member.observer_entries_on_me.order(observed_at: :desc)
    @clinician_entries = @member.clinician_entries.order(observed_at: :desc)
    @last_entry = entries.last
    @patient_entry_total = entries.uniq.count

    @patient_self_harm_total = entries.count(:self_harm)
    @patient_attended_sessions_total = entries.count(:attended_session)
    @patient_observer_entries = @member.observer_entries_on_me.count

    @prescriptions = @member.prescriptions.visible_to(current_user)
    @current_prescriptions = @prescriptions.current
    @unexpired = @prescriptions.unexpired
    @expired = @prescriptions.expired

    if request.xhr?
      @entries = Entry.all
      @user_entries = @member.entries.where("created_at <= ?", @consent.ended_at)
      @observer_entries = @member.observer_entries_on_me

      @start =  params[:start_date]
      @end   = params[:end_date]

      #@entries = Entry.all.where(:created_at => start_date.to_date..end_date.to_date)
      if(@start.present? and @end.present?)
        @start = Date.strptime(@start, "%m/%d/%Y").beginning_of_day
        @end = Date.strptime(@end, "%m/%d/%Y").end_of_day
      else
        @start = (Time.zone.now-2.weeks).beginning_of_day
        @end = Time.zone.now.end_of_day
      end

      @entries = @entries.where(created_at: @start..@end)
      @user_entries = @user_entries.where(created_at: @start..@end)
      @observer_entries = @observer_entries.where(observed_at: @start..@end)
      @entries_prescriptions = @member.entries_prescriptions.where(day_taken: @start..@end)
      @user_weight = @user_entries.where("weight > ?", 0)

      @user_work_life   = @user_entries.where.not(work_life: nil)
      @user_family_life = @user_entries.where.not(family_life: nil)
      @user_social_life = @user_entries.where.not(social_life: nil)

      social_life_avg   = @user_social_life.present? ? @user_social_life.average(:social_life).round(2, 2) : nil
      feeling_avg       = @user_entries.where.not(feeling: nil).any? ? @user_entries.where.not(feeling: nil).average(:feeling).round(2, 2) : nil

      #if age range is present
      #calculate age range limits based on Today
      # Time.zone.now - params[:age_start].years
      # Time.zone.now - (params[:age_end]+1).years
      #entries = @entries.joins(:users).where(users: {"DOB < age_end"}).where("users.DOB > age_start").uniq

      if(params[:race]).present?
        @entries = @entries.by_race(params[:race])
      end

      if(params[:gender]).present?
        @entries = @entries.by_gender(params[:gender])
      end

      if(params[:diagnosis]).present?
        @entries = @entries.by_diagnosis(params[:diagnosis])
      end

      if(params[:prescription]).present?
        @entries = @entries.by_prescription(params[:prescription])
      end

      # series data for patient prescription consistency chart
      @series = []
      @current_prescriptions.each do |prescription|
        series_name = "#{prescription.drug.friendly_name} (#{prescription.dosage}mg)"
        prescription_hash = {name: series_name, data: {}}

        grouped_eps = prescription.entries_prescriptions.group('date(entries_prescriptions.day_taken)')
        meds_taken = grouped_eps.sum(:times_taken).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]}

        prescription_hash["data"] = meds_taken

        @series << prescription_hash
      end

      results = {
        patient: {
          chart: {
            feeling: grouped(@user_entries, :feeling, :average), # see private methods below
            appetite: grouped(@user_entries, :appetite, :average),
            initiative: grouped(@user_entries, :initiative, :average),
            pessimism: grouped(@user_entries, :pessimism, :average),
            zest: grouped(@user_entries, :zest, :average),
            anxiety: grouped(@user_entries, :anxiety, :average),
            sleep: grouped(@user_entries, :hrs_slept, :average),
            energy: grouped(@user_entries, :energy, :average),
            concentration: grouped(@user_entries, :concentration, :average),
            # pessimism: @user_entries.group('date(entries.created_at)').average(:pessimism).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
            # zest: @user_entries.group('date(entries.created_at)').average(:zest).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
            # anxiety: @user_entries.group('date(entries.created_at)').average(:anxiety).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
            # sleep: @user_entries.group('date(entries.created_at)').average(:hrs_slept).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
            # energy: @user_entries.group('date(entries.created_at)').average(:energy).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
            # concentration: @user_entries.group('date(entries.created_at)').average(:concentration).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
            panic_attack: grouped(@user_entries, :panic_attack, :sum),
            suicide_thought: @user_entries.group('date(entries.created_at)').sum(:suicide_thought).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
            headache: @user_entries.group('date(entries.created_at)').sum(:headache).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
            nightmare: @user_entries.group('date(entries.created_at)').sum(:nightmare).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
            # social_life: @user_social_life.group('date(entries.created_at)').average(:social_life).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
            # work_life: @user_work_life.group('date(entries.created_at)').average(:work_life).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
            # family_life: @user_family_life.group('date(entries.created_at)').average(:family_life).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
            social_life: grouped(@user_entries, :social_life, :average),
            work_life: grouped(@user_entries, :work_life, :average),
            family_life: grouped(@user_entries, :family_life, :average),
            hospitalization: @user_entries.group('date(entries.created_at)').sum(:hospitalization).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
            weight: @user_weight.group('date(entries.created_at)').average(:weight).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
          },
          feeling: feeling_avg,
          activity: @user_entries.average(:activity),
          hospitalization: @user_entries.sum(:hospitalization),
          social_life: social_life_avg,
          emotion: @user_entries.average(:emotion),
          energy: @user_entries.average(:energy),
          anxiety: @user_entries.average(:anxiety),
          headache: @user_entries.sum(:headache),
          hrs_slept: @user_entries.average(:hrs_slept),
          took_meds: @user_entries.average(:took_meds),
          suicide_thought: @user_entries.sum(:suicide_thought),
          zest: @user_entries.average(:zest),
          pessimism: @user_entries.average(:pessimism),
          panic_attack: @user_entries.sum(:panic_attack),
          initiative: @user_entries.average(:initiative),
          concentration: @user_entries.average(:concentration),
          appetite: @user_entries.average(:appetite),
          reported_mood: @user_entries.average(:reported_mood),
          restlessness: @user_entries.sum(:restlessness),
          dry_mouth: @user_entries.sum(:dry_mouth),
          nausea: @user_entries.sum(:nausea),
          nightmare: @user_entries.sum(:nightmare),
          weight: @user_entries.average(:weight)
        },
        all: {
          chart: {
            feeling: @entries.group('date(entries.created_at)').average(:feeling).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]}
          },
          feeling: @entries.average(:feeling),
          activity: @entries.sum(:activity),
          emotion: @entries.average(:emotion),
          hospitalization: @entries.sum(:hospitalization),
          energy: @entries.average(:energy),
          anxiety: @entries.average(:anxiety),
          headache: @entries.average(:headache),
          hrs_slept: @entries.average(:hrs_slept),
          took_meds: @entries.average(:took_meds),
          suicide_thought: @entries.sum(:suicide_thought),
          zest: @entries.average(:zest),
          pessimism: @entries.average(:pessimism),
          panic_attack: @entries.sum(:panic_attack),
          initiative: @entries.average(:initiative),
          concentration: @entries.average(:concentration),
          appetite: @entries.average(:appetite),
          reported_mood: @entries.average(:reported_mood),
          restlessness: @entries.sum(:restlessness),
          dry_mouth: @entries.sum(:dry_mouth),
          nausea: @entries.sum(:nausea),
          nightmare: @entries.sum(:nightmare),
          weight: @entries.average(:weight)
        },
        observer: {
          chart: {
            feeling: @observer_entries.group('date(observer_entries.observed_at)').average(:feeling).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]}
          },
        },
        user_prescription: {
          chart: {
            meds_taken: @entries_prescriptions.group('date(entries_prescriptions.day_taken)').sum(:times_taken).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]}
            # suppposed_to_take: grouped_eps.map { |ep| ep.prescription.daily_doses }.sum.sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]}
          },
        },
        series: @series
      }
    end

    respond_to do |format|
      format.html
      format.json { render json: results }
    end
  end

  def my_patient
    @users = User.my_patient
  end

  def destroy
  end

  private

  def grouped(entries, metric, op)
    entries.group('date(entries.created_at)').send(op, metric).sort_by(&:first).map do |k,v| 
      [k.to_date.to_time.to_i * 1000, v.to_f]
    end
  end
end
