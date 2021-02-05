ActiveAdmin.register Member do

  menu priority: 2

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at
  filter :trial_interested
  filter :primary_role
  filter :last_entry

  index do
    selectable_column
    id_column
    column :user_id
    column :email
    column :gender
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    column :trial_interested
    column :primary_role
    column "Last Entry" do |member|
      "#{l member.entries.last.created_at, format: :short}" if member.entries.last.present?
    end
    column "Entries", sortable: :entries_count do |member|
      member.entries.count
    end

    actions
  end

  permit_params :user_id, :email, :password, :password_confirmation, :gender, :trial_interested, :primary_role

  form do |f|
    f.inputs "Member Details" do
      f.input :user_id
      f.input :type, as: :string
      f.input :email
      f.input :gender
      f.input :password
      f.input :password_confirmation
      f.input :trial_interested
      f.input :primary_role
    end
    f.actions
  end

end
