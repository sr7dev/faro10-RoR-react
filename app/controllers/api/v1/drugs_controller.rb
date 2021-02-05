class Api::V1::DrugsController < Api::Controller

  def index
    @drugs = Drug.all
    respond_with @drugs.order('friendly_name'), each_serializer: DrugSerializer, root: "drugs"
  end

end



