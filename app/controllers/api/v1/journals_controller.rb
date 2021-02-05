class Api::V1::JournalsController < Api::Controller
  def index
    if entries
      respond_with entries, each_serializer: JournalSerializer
    else
      render json: { status: :not_found }
    end
  end

  def show
    entry = entries.find_by(id: params[:id])
    if entry
      authorize! :read, Entry
      respond_with entry, serializer: JournalSerializer
    else
      render json: { status: :not_found }
    end
  end

  private
    def entries
      current_user.entries.with_journals.select(:id, :created_at, :journal)
    end
end
