class Clinicians::RegistrationsController < Devise::RegistrationsController
  layout 'static', only: [:new, :create]

  def new
    super do
      @plan = PricingPlan.find(params[:plan])
    end
  end

  def create
    @plan ||= PricingPlan.find(sign_up_params[:subscription_plan]) if sign_up_params[:subscription_plan].present?
    params[:clinician].delete(:subscription_plan) if sign_up_params[:subscription_plan]

    super do
      resource.subscriptions.new(pricing_plan: @plan, start: Time.current)
      if resource.save
        resource.send_admin_notification
      end
    end
  end
end
