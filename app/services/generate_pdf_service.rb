class GeneratePdfService

  def initialize(options = {})
    @options = options
    @template = @options[:template]
    @layout = @options[:layout] || 'layouts/pdf.html.erb'
    @locals = @options[:locals] || {}
    @page_size = @options[:page_size] || 'Letter'
  end

  def perform
    pdf_from_options
  end

  private

  def pdf_from_options
    # create an instance of ActionView, so we can use the render method outside of a controller
    action_view = ActionView::Base.new()
    action_view.view_paths = ActionController::Base.view_paths

    # need these in case view constructs any links or references any helper methods.
    action_view.class_eval do
      include Rails.application.routes.url_helpers
      include ApplicationHelper
    end

    pdf_html = action_view.render template: @template, layout: @layout, locals: @locals

    pdf = WickedPdf.new.pdf_from_string pdf_html, page_size: @page_size
  end

end
