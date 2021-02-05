Rails.application.routes.draw do

  root 'static_pages#home'

  # Static Pages
  get 'about' => 'static_pages#about'
  get 'pressroom' => 'static_pages#pressroom'
  get 'contact' => 'static_pages#contact'
  get 'Depression Stats' => 'static_pages#depression_stats'
  get 'faq' => 'static_pages#faq'
  get 'features' => 'static_pages#features'
  get 'home' => 'static_pages#home'
  get 'privacy' => 'static_pages#privacy_policy'
  get 'providers' => 'static_pages#providers'
  get 'resources' => 'static_pages#resources'
  get 'schools' => 'static_pages#schools'
  get 'sponsors' => 'static_pages#sponsors'
  get 'videos' => 'static_pages#videos'
  get 'solutions' => 'static_pages#solutions'
  get 'guardians' => 'static_pages#guardians'
  get 'substance_abuse' => 'static_pages#segmentation_substance'
  get 'employee_assistance' => 'static_pages#eap'
  get 'college_counseling' => 'static_pages#college_counseling'
  get 'integrative_care' => 'static_pages#integrative_care'
  # get 'managed_care' => 'static_pages#mcn'
  # get 'partners' => 'static_pages#partners'
  # get 'research' => 'static_pages#research'
  get 'telapeer' => 'static_pages#telapeer'
  get 'benefits' => 'static_pages#benefits'

  get :tips, to: 'users#tips'



  # App
  resources :alerts
  resources :appointments, only: [:show, :new, :create, :destroy]
  resources :assigned_exercises, only: [:index, :show, :create], controller: 'users/exercises_memberships' do
    resources :answers, only: [:create]
  end
  resource :charts
  devise_for :clinicians, skip: [:sessions, :passwords], controllers: {
    confirmations: 'users/confirmations',
    registrations: 'clinicians/registrations',
  }
  resources :clinician_entries, only: [:create]
  resources :clinicians do
    get :clinic_dashboard
    get :home, on: :collection
    get :search, on: :collection
  end


  resources :channels do
    post :follow, to: 'channels#follow', on: :member
    post :unfollow, to: 'channels#unfollow', on: :member
    resources :channel_assets
    get :channel_assets
  end

  get :my_activities, to: 'channels#my_activities'
  get :categories, to: 'meetings#categories'
  get :vet_meetings, to: 'meetings#vet_meetings'
  get :substance_meetings, to: 'meetings#substance_meetings'
  get :caregiver, to: 'meetings#caregiver'
  get :eating, to: 'meetings#eating'
  get :suicide_loss, to: 'meetings#suicide_loss'
  get :depression, to: 'meetings#depression'
  get :pregnancy_loss, to: 'meetings#pregnancy_loss'

  # resources :channel_assets

  namespace :clinicians do
    resources :members, only: [ :create, :destroy] do
      put 'approve' => 'members#approve', on: :member
    end
  end
  resources :consents, only: [:show]
  resources :contact_messages, only: [:create]
  resource :dashboard
  resources :diagnoses
  resources :entries do
    get :analysis, on: :collection
  end
  resources :exercises, only: [:show] do
    member do
      get :pdf, format: 'pdf'
    end
  end
  resources :facebook, only: [:new, :index]
  get 'auth/:provider/callback', to: 'facebook#create'
  get 'connect_to_facebook', to: 'facebook#new'
  resources :groups do
    member do
      get :add_clinician
    end
  end
  resources :facebook_posts, only: :index, defaults: { format: :json }
  resources :medical_conditions, only: [:show, :index]

  resources :meetings do
    post :join, to: 'meetings#join', on: :member
    get :invite, on: :member
    get :verify_password, on: :member
    post :verify_password_valid, on: :member

    resources :meeting_messages
  end

  get :my_meetings, to: 'meetings#my_meetings'


  resources :meeting_messages


  get 'meet_now', to: 'meetings#meet_now'
  get 'patient_meetings', to: 'patients#patient_meetings'


  devise_for :members, skip: [:sessions, :passwords], controllers: {
    registrations: 'members/registrations',
    confirmations: 'users/confirmations'
  }
  resources :members do
    get :home, on: :collection
    # post :add_journal_visible, :remove_journal_visible, on: :member
  end
  namespace :members do
    resources :observers, only: [:new, :create, :destroy, :edit, :update]
    resources :assigned_exercises, only: [:index, :show, :create, :destroy], controller: 'users/exercises_memberships'
  end
  resources :memberships, only: [:create, :update]
  resources :messages, only: [:create, :destroy] do
    post :mark_as_read, :mark_as_unread, on: :member
  end

  get 'My Dashboard' => 'dashboards#show'
  get 'My Team' => 'users#team'
  resources :observer_entries
  resources :observers do
    post :add_meds_visibility, :remove_meds_visibility, on: :member
  end
  resources :password_resets, only: [:new, :create, :edit, :update]
  get "/search-dsm5", to: "patients#search_dsm5", defaults: { format: :json }
  get "/search-icd10", to: "patients#search_icd10", defaults: { format: :json }
  resources :patients do
    resources :assigned_exercises, only: [:index, :show, :create, :destroy], controller: 'patients/exercises_memberships' do
      member do
        get :pdf, format: 'pdf'
      end
    end
    resource :scorecard, only: [:show]
    member do
      post :add_journal_visible, :remove_journal_visible
      get "collaboration"
      get "liability"
      get "medical_necessity"
      get "patient_summary"
    end
  end
  resources :pdf_emails, only: [:create]
  resources :prescriptions
  resources :pricing_plans, path: :plans, only: [:index]
  get 'Register Clinician' => 'clinicians#new'
  resources :schedules, only: [:show, :index], param: :member_id
  get 'signup' => 'members#new'
  get 'socials' => 'socials#index'

  get 'rmeetings' => 'rmeetings#index'
  get '/rmeetings/:id', to: 'rmeetings#index', as: 'id'

  resources :subscriptions, only: [:index, :create, :update]
  get 'summary' => 'dashboards#summary'
  resources :symptoms do
    post :add_tracked, on: :member
    put :remove_tracked, on: :member
    post :tracked, on: :collection
  end
  devise_for :users, skip: [:registrations], controllers: {
    confirmations: 'users/confirmations',
    invitations: 'users/invitations',
    passwords: 'users/passwords',
    sessions: 'users/sessions',
  }

  devise_scope :user do
    get "users/password_expired", to: "users/password_expired#show", as: "user_password_expired"
    put "users/password_expired", to: "users/password_expired#update", as: ""
  end

  resources :users do
    collection do
      get 'invite_clinician'
      get 'invite_member'
      get 'invite_observer'
      get 'observations'
      get 'prescription_review'
      get 'make_observation'
      get 'observee_consistency_data'
      get 'team'
    end
  end

  devise_for :admins, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # API
  namespace :api, defaults:{format: :json} do
    scope module: :v1 do
      resource :aggregate, only: [:show]
      resources :alerts, only: [:create, :index]
      scope module: :clinicians do
        resources :members, only: [:destroy]
        put 'members/:clinician_id/approve' => 'members#approve'
      end
      resource :dashboard, only: [:show]
      resources :drugs, only: [:index]
      resources :entries, only: [:create, :index]
      resources :entries_prescriptions, only: [:create, :index, :show]
      resource  :goal_center, only: [:show]
      resources :journals, only: [:index, :show]

      resources :meetings, only: [:index, :create, :update] do
        member do
          post :invite_users # /api/meetings/:id/invite_users
        end
        post :join, to: 'meetings#join', on: :member
        get :verify_password, on: :member
        post :verify_password_valid, on: :member
        get :meeting_users, to: 'meetings#meeting_user'
        get :meeting_user, to: 'meetings#get_a_meeting_user', on: :member
        resources :meeting_users do
          member do
            post :remove
          end
        end
        resources :meeting_messages, only: [:index, :create]

      end
      resources :members, only: [] do
        resources :clinicians, only: [:index], to: "members/clinicians#index"
      end
      resources :memberships, only: [:index, :update]
      resources :messages, only: [:index, :create, :destroy] do
        patch :mark_as_read, :mark_as_unread, on: :member
      end
      scope module: :members do
        resources :observers, only: [:create, :destroy, :update]
      end
      resources :observations_on_me, only: [:index, :create, :update]
      resources :observations_of_others, only: [:index]
      namespace :observations_of_others do
        resources :prescriptions, only: [:index]
        resources :entries, only: [:index]
        resources :people, only: [:index]
        resource :consistency_chart, only: [:show]
      end
      resources :observer_entries, only: [:create]
      resources :passwords, only: [:create]
      resources :prescriptions, only: [:index, :create, :update]
      resource :session, only: [:create, :destroy]
      resources :symptoms, only: [:create, :index]
      resource :tracked_symptoms, only: [:update] do
        get :index, path: ''
      end
      resource :user, only: [:show, :update]
      resources :users, only: [:create] do
        get 'time_zones', on: :collection
        get 'twilio_token'
      end
    end
  end
end
