class Api::V1::AggregatesController < Api::Controller
  def show
    @entries = Entry.all
    @user_entries = current_user.entries
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
    @user_entries = @user_entries.where(created_at: @start..@end)
    @user_weight = @user_entries.where("weight > ?", 0)                      #This one only shows weights within the period defined in the date filter

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

    if(params[:prescription])
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


    results = {user: {chart: {
        feeling: @user_entries.group('date(entries.created_at)').average(:feeling).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
        appetite: @user_entries.group('date(entries.created_at)').average(:appetite).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
        initiative: @user_entries.group('date(entries.created_at)').average(:initiative).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
        pessimism: @user_entries.group('date(entries.created_at)').average(:pessimism).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
        zest: @user_entries.group('date(entries.created_at)').average(:zest).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
        anxiety: @user_entries.group('date(entries.created_at)').average(:anxiety).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
        sleep: @user_entries.group('date(entries.created_at)').average(:hrs_slept).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
        energy: @user_entries.group('date(entries.created_at)').average(:energy).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
        concentration: @user_entries.group('date(entries.created_at)').average(:concentration).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
        panic_attack: @user_entries.group('date(entries.created_at)').sum(:panic_attack).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
        suicide_thought: @user_entries.group('date(entries.created_at)').sum(:suicide_thought).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
        headache: @user_entries.group('date(entries.created_at)').sum(:headache).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
        nightmare: @user_entries.group('date(entries.created_at)').sum(:nightmare).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
        work_life: @user_entries.group('date(entries.created_at)').average(:work_life).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
        social_life: @user_entries.group('date(entries.created_at)').average(:social_life).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
        family_life: @user_entries.group('date(entries.created_at)').average(:family_life).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},
        weight: @user_weight.group('date(entries.created_at)').average(:weight).sort_by(&:first).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]},


    },
                      feeling: @user_entries.average(:feeling),
                      activity: @user_entries.average(:activity),
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

               all: {chart: {
                   feeling: @entries.group('date(entries.created_at)').average(:feeling).map{|k,v| [k.to_date.to_time.to_i*1000, v.to_f]}
               },
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
               }}


    respond_to do |format|
      format.json { render json: results }
    end
  end
end