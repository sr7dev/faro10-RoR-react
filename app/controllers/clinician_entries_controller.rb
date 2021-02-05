class ClinicianEntriesController < ApplicationController
  def create
    entry = current_user.clinician_entries.new(clinician_entry_params)

    if entry.save
      flash[:success] = "Successfully created entry."
    else
      flash[:danger] = "Failed to save entry."
    end
    redirect_back fallback_location: root_path
  end

  private

  def clinician_entry_params
    params.require(:clinician_entry).permit(:emotion, :feeling, :journal, :observed_at, :social_interaction,
                                            :member_id, :suicide_behavior, :dangerous)
  end
end