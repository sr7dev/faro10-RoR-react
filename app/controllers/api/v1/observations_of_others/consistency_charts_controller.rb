class Api::V1::ObservationsOfOthers::ConsistencyChartsController < Api::Controller
  def show
    chart = ObserveePrescriptionConsistencyChart.new(current_user)
    respond_with chart.full_chart_mobile(weeks)
  end

  private
  
  def weeks
    params[:weeks] ? params[:weeks].to_i : 2
  end
end
