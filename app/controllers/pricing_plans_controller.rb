class PricingPlansController < ApplicationController
  layout :resolve_layout
  
  skip_before_action :authenticate_user!
  skip_before_action :store_location

  def index
    @pricing_plans = PricingPlan.where(name: ["Single Clinician", "Clinician Group", "Large Group"])
  end

  private

  def resolve_layout
    current_user ? "application" : "static"
  end
end
