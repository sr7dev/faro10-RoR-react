ActiveAdmin.register Subscription do
  
  actions :index, :show, :new, :create

  index do
    selectable_column
    id_column
    column :clinician
    column :pricing_plan
    column :amount
    column :start
    column :status
    column :canceled_at
    actions
  end

  after_create do |new_subscription|
    clinician = new_subscription.clinician
    clinician.subscriptions.active.all_except(new_subscription).cancel
  end

  permit_params :pricing_plan_id, :clinician_id, :start

  form do |f|
    f.object.start ||= DateTime.current

    f.semantic_errors *f.object.errors.keys
    f.inputs "Subscription Details" do
      f.input :pricing_plan
      f.input :clinician
      f.input :start, as: :date_select
    end
    f.actions
  end
end
