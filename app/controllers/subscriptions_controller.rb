class SubscriptionsController < ApplicationController
  def index
    @subscriptions = current_user.subscriptions.all
  end

  def create
    @subscription = Subscription.new(subscription_params)
    @subscription.start = Time.current

    respond_to do |format|
      if @subscription.save
        current_user.subscriptions.active.all_except(@subscription).cancel
        format.html { redirect_to( subscriptions_path,
                      :notice => "You have successfully subscribed to the #{@subscription.plan.name} plan.") }
      else
        format.html  { redirect_to pricing_plans_path, error: "There was a problem creating your subscription." }
      end
    end
  end

  def update
    @subscription = Subscription.find(params[:id])

    case subscription_params[:action]
    when "cancel"
      if @subscription.cancel
        redirect_to pricing_plans_path, notice: "You have succesfully canceled your subscription."
      end
    else
      redirect_to subscriptions_path, error: "Unable to cancel current subscription."
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:pricing_plan_id, :clinician_id, :action)
  end
end
