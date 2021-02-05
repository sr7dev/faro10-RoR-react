class Api::V1::ObserverEntriesController < Api::Controller
  def create
    observer_entry = ObserverEntry.new(observer_entry_params)

    if observer_entry.save
      respond_with observer_entry
    else
      render json: { errors: observer_entry.errors.full_messages, status: :unprocessable_entity }
    end
  end

  private

  def observer_entry_params
    params.require(:observer_entry).permit(:emotion, :feeling, :journal, :observation_id, :observed_at, :social_interaction,
    :delusional, :hallucination, :hyperactive, :energy, :activity, :zest, :work_life, :family_life, :dangerous_behavior, :substance_abuse )
  end
end
