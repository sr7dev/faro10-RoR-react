ActiveAdmin.register Clinician do

  menu priority: 2
  
  index do
    selectable_column
    id_column
    column :user_id
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column :subscription do |clinician|
      clinician.subscriptions.active.any?
    end
    column :locked do |clinician|
      clinician.access_locked?
    end
    actions
  end

  show do
    default_main_content
    panel "Subscriptions" do
      table_for clinician.subscriptions.order(start: :desc) do
        column :name
        column :amount
        column :status
        column :start
        column :canceled_at
      end
    end
  end

  member_action :expire_password, method: :get do
    resource.need_change_password!
    redirect_to admin_clinician_path(resource), notice: "Clinician password expired."
  end

  member_action :lock_account, method: :get do
    resource.lock_access!
    redirect_to admin_clinician_path(resource), notice: "Clinician account locked."
  end

  member_action :unlock_account, method: :get do
    resource.unlock_access!
    redirect_to admin_clinician_path(resource), notice: "Clinician account unlocked."
  end

  action_item :expire_password, only: [:show, :edit] do
    link_to 'Expire Password', expire_password_admin_clinician_path(clinician) unless clinician.need_change_password?
  end

  action_item :lock_account, only: [:show, :edit] do
    link_to 'Lock Account', lock_account_admin_clinician_path(clinician) unless clinician.access_locked?
  end

  action_item :unlock_account, only: [:show, :edit] do
    link_to 'Unlock Account', unlock_account_admin_clinician_path(clinician) if clinician.access_locked?
  end

  permit_params :user_id, :email, :password, :password_confirmation, :featured_at,
                :clinic_name, :clinician_type, :clinic_description, :clinic_phone, :clinic_street, :clinic_city, :clinic_state, :clinic_zip

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Clinician Details" do
      f.input :user_id
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :featured_at, as: :boolean, label: "Featured?", checked_value: Time.now, unchecked_value: nil
    end
    f.inputs "Clinic Details" do
      f.input :clinic_name
      f.input :clinician_type
      f.input :clinic_description
      f.input :clinic_phone
      f.input :clinic_street
      f.input :clinic_city
      f.input :clinic_state
      f.input :clinic_zip
    end
    f.actions
  end

  controller do
    def update
      if params[:clinician][:password].blank?
        %w(password password_confirmation).each { |param| params[:clinician].delete(param) }
      end

      super
    end
  end

end
