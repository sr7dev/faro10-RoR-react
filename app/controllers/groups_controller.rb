class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :add_clinician]

  # GET /groups/
  def index
    @groups = Group.all
  end

  # GET /groups/:id
  def show
    authorize! :read, @group

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

      #if age range is present
      #calculate age range limits based on Today
      # Time.zone.now - params[:age_start].years
      # Time.zone.now - (params[:age_end]+1).years
      #entries = @entries.joins(:users).where(users: {"DOB < age_end"}).where("users.DOB > age_start").uniq

      if(params[:race])
        @entries = @entries.by_race(params[:race])
      end

      if(params[:gender])
        @entries = @entries.by_gender(params[:gender])
      end

      if(params[:diagnosis])
        @entries = @entries.by_diagnosis(params[:diagnosis])
      end

      if(params[:country])
        @entries = @entries.by_country(params[:country])
      end

      if(params[:prescription])
        @entries = @entries.by_prescription(params[:prescription])
      end

      results = {feeling: @entries.average(:feeling),
                 activity: @entries.sum(:activity),
                 emotion: @entries.average(:emotion),
                 energy: @entries.average(:energy),
                 anxiety: @entries.average(:anxiety),
                 panic_attack: @entries.sum(:panic_attack),
                 white_mood: @entries.by_race('Caucasian').average(:feeling),
                 black_mood: @entries.by_race('African American').average(:feeling),
                 hispanic_mood: @entries.by_race('Hispanic').average(:feeling),
                 asian_mood: @entries.by_race('Asian').average(:feeling),

                 charts:  {
                     feelings: {male: @entries.by_gender('Male').group('date(entries.created_at)').average(:feeling).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
                                female: @entries.by_gender('Female').group('date(entries.created_at)').average(:feeling).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
                                white: @entries.by_race('Caucasian').group('date(entries.created_at)').average(:feeling).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
                                black: @entries.by_race('African American').group('date(entries.created_at)').average(:feeling).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
                                asian: @entries.by_race('Asian').group('date(entries.created_at)').average(:feeling).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
                                hispanic: @entries.by_race('Hispanic').group('date(entries.created_at)').average(:feeling).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]}
                     },
                     hospitalizations:  {male: @entries.by_gender('Male').group('date(entries.created_at)').sum(:hospitalization).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
                                         female: @entries.by_gender('Female').group('date(entries.created_at)').sum(:hospitalization).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
                     },
                     work_life:  {male: @entries.by_gender('Male').group('date(entries.created_at)').average(:work_life).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
                                  female: @entries.by_gender('Female').group('date(entries.created_at)').average(:work_life).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
                     },
                     social_life:  {male: @entries.by_gender('Male').group('date(entries.created_at)').average(:social_life).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
                                    female: @entries.by_gender('Female').group('date(entries.created_at)').average(:social_life).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
                     },
                     family_life:  {male: @entries.by_gender('Male').group('date(entries.created_at)').average(:family_life).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
                                    female: @entries.by_gender('Female').group('date(entries.created_at)').average(:family_life).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
                     }
                 }
      }
    end

    @clinicians = Clinician.all

    respond_to do |format|
      format.html
      format.json { render json: results }
    end

    # all_feelings = Entry.sum_feelings
    # my_feelings = Entry.avg_feelings

    # @user_mood_feeling = user_feelings.values
    # @user_mood_date = user_feelings.keys
  end

  # GET /groups/new
  def new
    authorize! :create, Group
    @group = Group.new
  end

  # GET /groups/:id/edit
  def edit
    authorize! :update, @group
  end

  # POST /groups
  def create
    authorize! :create, Group
    @group = Group.new(group_params)
    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { head :no_content }
      else
        format.html { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH /groups/:id
  def update
    authorize! :update, @group
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /groups/:id/add_clinician
  def add_clinician
    authorize! :update, @group

    @clinician = Clinician.find(params[:clinician_id])
    @group.clinicians << @clinician

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Clinician was added to group.' }
        format.json { head :no_content }
      else
        format.html { render action: 'show' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end

  def set_group
    if params[:id]
      @group = Group.find(params[:id])
    else
      @group = current_user.group
    end
  end
end
