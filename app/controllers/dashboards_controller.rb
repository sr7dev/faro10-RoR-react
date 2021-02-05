class DashboardsController < ApplicationController
  around_action :set_time_zone


  def summary
    pdf = MemberSummaryPdf.new(current_user)

    respond_to do |format|
      format.pdf do
        send_data pdf.to_pdf, type: :pdf, disposition: "inline"
      end


      # if request.xhr?
      #   @entries = Entry.all
      #
      # def avg_sort(attr, collection = @user_entries)
      #   collection.group('date(entries.created_at)').
      #       average(attr).
      #       sort_by(&:first).map do |k,v|
      #     [k.to_date.to_time.to_i * 1000, v.to_f]
      #   end
      # end
      #
      # results = {
      #     user: {
      #         chart: {
      #             feeling: avg_sort(:feeling)
      #         }
      #     }
      # }
      # end


    end
  end

  def show

    if current_user.memberships.pending.any?
      flash[:danger] = "You have a pending Clinician approval on your team page"
    end


    @observer_entry = ObserverEntry.new
    @user = current_user
    @observations = @user.observations_of_others.active.includes(:observee)

    @observer_entries = @user.observer_entries.order(observed_at: :desc)



    entries = current_user.entries
    @gc = GoalCenter.new(current_user)

    @my_journal = entries.where.not(journal: nil).order("created_at DESC")

    # @my_self_harm_total = entries.where.not(self_harm: [nil, '']).count('self_harm', :distinct => false)
    # @my_attended_sessions_total = entries.where.not(attended_session: [nil, '']).count('attended_session', :distinct => false)

    @my_observer_entries = current_user.observer_entries_on_me.count
    @my_entry_total = entries.count(:created_at)

    #Mood Card Data
    @my_mood_entry_total = entries.count(:feeling)
    @last_mood_entry = entries.where.not(feeling: nil).order("created_at DESC").first
    if @my_mood_entry_total==0
      @moodMessage = "You have not tracked your mood yet"
    else
      if @last_mood_entry.present?
        if @last_mood_entry.created_at.to_date < (Date.current - 3.days)
          @moodMessage = "You have not tracked your mood in 3 days"
        end
      end
    end

    #Journal Card Data
    @journal_entry_total = @my_journal.count
    @last_journal_entry  = entries.where.not(journal: nil).order("updated_at DESC").first
    @last_journal_entry.present?
    if @journal_entry_total==0
      @journalMessage = "You have not made any journal entries"
    else
      if @last_journal_entry.updated_at.to_date < (Date.current - 4.days)
        @journalMessage = "You have not made a journal entry in 4 days"
      end
    end

    #Observer Card Data
    @observer_entry_total = @current_user.observer_entries.count
    @observer_observee_total = @current_user.observations_of_others.active.includes(:observee).count


    @last_observer_entry = @current_user.observer_entries.order("observed_at DESC").first
    if @observer_entry_total==0 && @observer_observee_total>0
      @observerMessage = "You have not made any observations"
    else
      if @last_observer_entry.present?
        if @last_observer_entry.observed_at.to_date < (Date.current - 2.days)
          @observerMessage = "You have not observed anyone in 2 days"
        end
      end
    end

    #Prescriptions Card Data
    @my_active_prescription_count = @current_user.prescriptions.current.count
    @last_prescription_entry = @current_user.entries_prescriptions.order("day_taken DESC").first
    @my_active_prescriptions = @current_user.prescriptions.current
    @my_entry_prescriptions_count = @current_user.entries_prescriptions.count

    #Side Effects Card Data
    @last_side_effect_entry =entries.where.not(nausea: nil, headache: nil, restlessness: nil, dry_mouth: nil, hallucination: nil, pain: nil).order("created_at DESC").first

    #Symptoms Card Data
    @last_symptom_entry = entries.where.not(self_harm: nil, attended_session: nil, suicide_thought: nil).order("created_at DESC").first
    @tracked_symptoms = @current_user.tracked_symptom_symptoms
    @available_symptoms = Symptom.available_to_patient(current_user)

    #Team Card Data
    @my_active_clinician_count = @current_user.memberships.active.count
    @my_pending_clinician_count = @current_user.memberships.pending.count
    @my_observers_count = @current_user.observations_on_me.active.count
    @my_unread_messages = @current_user.messages.unarchived.unread.count

    if @current_user.memberships.pending.present?
      @teamMessage = "You have a pending clinician"
    else
      if @my_unread_messages > 0
        @teamMessage = "You have unread messages"
      end
    end

    #Exercises Card Data
    @my_complete_exercises_count = ExercisesMembership.by_member(@current_user).complete.count
    @my_incomplete_exercises_count = ExercisesMembership.by_member(@current_user).incomplete.count

    if @my_incomplete_exercises_count >0
      @exercisesMessage = "You have an assigned exercise to complete"
    end

    #Appointment Card Data
    @my_appointment_count = current_user.appointments.count
    @appointment_end_date = Date.current + 5.days
    @upcoming_appointments_count = @current_user.appointments.where(:start_time => Date.current.to_time..@appointment_end_date.to_time).count


    # @last_entry = current_user.entries('created_at').last

    if current_user.entries.present?
      @last_entry = current_user.entries.order("created_at DESC").first
    else
      @last_entry == 0
    end

    if request.xhr?
      @entries = Entry.all

      #@entries_date_filter = @entries.where(:created_at => (params[:start_date].to_date .. params[:end_date].to_date))

      @start =  params[:start_date]
      @end = params[:end_date]

      #@entries = Entry.all.where(:created_at => start_date.to_date..end_date.to_date)
      if(@start.present? and @end.present?)
        @start = Date.strptime(@start, "%m/%d/%Y").beginning_of_day
        @end = Date.strptime(@end, "%m/%d/%Y").end_of_day
      else
        @start = (Time.zone.now-2.weeks).beginning_of_day
        @end = Time.zone.now.end_of_day
      end

      @entries = @entries.where(created_at: @start..@end)
      @user_entries = current_user.entries.where(created_at: @start..@end)
      @observer_entries_for_chart = @user.observer_entries.where(observed_at: @start..@end)
      @user_weight = @user_entries.where("weight > ?", 0)                      #This one only shows weights within the period defined in the date filter
      # @user_weight = current_user.entries(:weight).where("weight > ?", 0)    #This one uses all weights entered and ignores date filter
      @user_work_life = @user_entries.where("work_life > ?", 0)
      @user_family_life = @user_entries.where("family_life > ?", 0)
      @user_social_life = @user_entries.where("social_life > ?", 0)


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


      #@users_activity = @entries.sum(:activity) #int / float
      # @users_anxiety = Entry.all.sum(:anxiety)
      # @users_feeling = Entry.all.sum(:feeling)
      # @users_energy = Entry.all.sum(:energy)

      # .group('date(created_at)').average(:feeling)
      # user_feelings = current_user.feelings_sum
      # @user_mood_feelings = user_feelings.map{|k,v| [k,v]}
      #
      # all_feelings = Entry.sum_feelings
      # @all_mood_feelings = all_feelings.map{|k,v| [k,v]}

      # sums = {}
      # @entries.each do |sums, e|
      #   sums[:took_meds] += e.took_meds ? 1 : 0
      #   sums[]
      # end
      #
      # avg_took_meds = sums[:took_meds] / @entries.size.to_f

      # this logic was being used in almost every 
      # one of the hash values below under :chart
      def avg_sort(attr, collection = @user_entries)
        collection.group('date(entries.created_at)').
          average(attr).
          sort_by(&:first).map do |k,v| 
            [k.to_date.to_time.to_i * 1000, v.to_f]
          end
      end

      def obs_entries_avg_sort(attr, collection = @observer_entries_for_chart)
        collection.group('date(observer_entries.observed_at)').
            average(attr).
            sort_by(&:first).map do |k,v|
          [k.to_date.to_time.to_i * 1000, v.to_f]
        end
      end

      results = {
        user: {
          chart: {
            feeling: avg_sort(:feeling),
            appetite:avg_sort(:appetite),
            initiative: avg_sort(:initiative),
            pessimism: avg_sort(:pessimism),
            zest: avg_sort(:zest),
            anxiety: avg_sort(:anxiety),
            sleep: avg_sort(:hrs_slept),
            energy: avg_sort(:energy),
            concentration: avg_sort(:concentration),

            # This code with the avg_sort doesnt work for the symptoms chart where it is summing the entries.
            # panic_attack: avg_sort(:panic_attack),
            # suicide_thought: avg_sort(:suicide_thought),
            # headache: avg_sort(:headache),
            # nightmare: avg_sort(:nightmare),

            panic_attack: @user_entries.group('date(entries.created_at)').sum(:panic_attack).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
            suicide_thought: @user_entries.group('date(entries.created_at)').sum(:suicide_thought).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
            headache: @user_entries.group('date(entries.created_at)').sum(:headache).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
            restlessness: @user_entries.group('date(entries.created_at)').sum(:restlessness).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
            nausea: @user_entries.group('date(entries.created_at)').sum(:nausea).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},


            nightmare: @user_entries.group('date(entries.created_at)').sum(:nightmare).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
            work_life: avg_sort(:work_life),
            social_life: avg_sort(:social_life),
            family_life: avg_sort(:family_life),
            weight: @user_weight.group('date(entries.created_at)').average(:weight).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
            # weight: avg_sort(:weight),
          },
          feeling: (x = @user_entries.average(:feeling) and x.round(2)),
          activity: @user_entries.sum(:activity),
          emotion: @user_entries.average(:emotion),
          energy: (x = @user_entries.average(:energy) and x.round(2)),
          anxiety: @user_entries.average(:anxiety),
          headache: @user_entries.sum(:headache),
          hrs_slept: (x = @user_entries.average(:hrs_slept) and x.round(2)),
          took_meds: @user_entries.sum(:took_meds),
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
          chart: { feeling: avg_sort(:feeling, @entries) },
          feeling: @entries.average(:feeling),
          activity: @entries.sum(:activity),
          emotion: @entries.average(:emotion),
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

        observations: {
            chart: {
                feeling: obs_entries_avg_sort(:feeling),
                social_interaction: obs_entries_avg_sort(:social_interaction),
                work_life: obs_entries_avg_sort(:work_life),
                family_life: obs_entries_avg_sort(:family_life),
                zest: obs_entries_avg_sort(:zest),
                delusional: obs_entries_avg_sort(:delusional),
                hallucination: obs_entries_avg_sort(:hallucination),
                hyperactive: obs_entries_avg_sort(:hyperactive),
                energy: obs_entries_avg_sort(:energy),
                activity: obs_entries_avg_sort(:activity),
                dangerous_behavior: obs_entries_avg_sort(:dangerous_behavior),
                substance_abuse: obs_entries_avg_sort(:substance_abuse)
            },
        }
      }
    end

    respond_to do |format|
      format.html
      format.json { render json: results }
    end
  end

  def set_time_zone
    Time.use_zone(current_user.time_zone) { yield }
  end

end
