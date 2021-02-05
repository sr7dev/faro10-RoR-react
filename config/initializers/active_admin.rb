ActiveAdmin.setup do |config|
  config.comments = false
  config.site_title = "Admin | Faro10"

  # config.site_title_link = "/"
  # config.site_title_image = "logo.png"
  # config.default_namespace = :admin
  config.authentication_method = :authenticate_admin!
  config.skip_before_action :authenticate_user!
  # config.authorization_adapter = ActiveAdmin::CanCanAdapter
  # config.pundit_default_policy = "MyDefaultPunditPolicy"
  # config.cancan_ability_class = "Ability"
  # config.on_unauthorized_access = :access_denied
  config.current_user_method = :current_admin
  config.logout_link_path = :destroy_admin_session_path
  # config.logout_link_method = :get
  # config.root_to = 'dashboard#index'

  # == Admin Comments
  # config.comments = false
  # config.comments_registration_name = 'AdminComment'
  # config.comments_order = 'created_at ASC'
  # config.comments_menu = false
  # config.comments_menu = { parent: 'Admin', priority: 1 }

  config.batch_actions = true
  # config.before_action :do_something_awesome
  config.localize_format = :long
  # config.favicon = 'favicon.ico'
  # config.meta_tags = { author: 'My Company' }
  # config.meta_tags_for_logged_out_pages = {}
  # config.breadcrumb = false
  # config.create_another = true
  #   config.register_stylesheet 'my_stylesheet.css'
  #   config.register_stylesheet 'my_print_stylesheet.css', media: :print
  #   config.register_javascript 'my_javascript.js'
  # config.csv_options = { col_sep: ';' }
  # config.csv_options = { force_quotes: true }
  #   config.namespace :admin do |admin|
  #     admin.build_menu :utility_navigation do |menu|
  #       menu.add label: "My Great Website", url: "http://www.mygreatwebsite.com", html_options: { target: :blank }
  #       admin.add_logout_button_to_menu menu
  #     end
  #   end
  #   config.namespace :admin do |admin|
  #     admin.build_menu :default do |menu|
  #       menu.add label: "My Great Website", url: "http://www.mygreatwebsite.com", html_options: { target: :blank }
  #     end
  #   end

  #   config.namespace :admin do |admin|
  #     admin.download_links = false
  #     admin.download_links = [:xml, :pdf]
  #     admin.download_links = proc { can?(:view_download_links) }
  #   end
  # config.default_per_page = 30
  # config.max_per_page = 10_000
  # config.filters = true
  # config.include_default_association_filters = true
  # config.footer = 'my custom footer text'
  # config.order_clause = MyOrderClause
end
