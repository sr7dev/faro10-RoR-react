class ChartsController < ApplicationController

  def show
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

      results = {
                 feeling: (x = @entries.average(:feeling) and x.round(2,2)),
                 activity: @entries.sum(:activity),
                 emotion: (x = @entries.average(:emotion) and x.round(2,2)),
                 energy: (x = @entries.average(:energy) and x.round(2,2)),
                 anxiety: (x = @entries.average(:anxiety) and x.round(2,2)),
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



    respond_to do |format|
      format.html
      format.json { render json: results }
    end

    # all_feelings = Entry.sum_feelings
    # my_feelings = Entry.avg_feelings


    # @user_mood_feeling = user_feelings.values
    # @user_mood_date = user_feelings.keys
  end



end
