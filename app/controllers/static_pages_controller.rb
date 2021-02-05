class StaticPagesController < ApplicationController
  layout "static", only: [:resources, :about, :pressroom, :contact, :endorsements, :privacy_policy, :features, :faq, :depression_stats,
                          :sponsors, :providers, :videos, :eap, :telapeer, :home, :benefits]

  before_action :sanitize_flash_html, if: -> { flash[:html_safe] }
  skip_before_action :authenticate_user!
  skip_before_action :store_location

  def home
    @clinicians = Clinician.featured.near('Raleigh', 50)
    @meetings = Meeting.all
  end

  def resources
  end

  def depression_hidden_illness
  end

  def about

  end

  def pressroom
  end

  def contact
  end

  def endorsements
  end

  def providers
  end

  def privacy
  end

  def features
  end

  def faq
  end

  def sponsors
  end

  def schools
  end

  def depression_stats
  end

  def videos
  end

  def guardians
  end

  def segmentation_substance
  end

  def eap
  end

  def integrative_care
  end

  def mcn
  end

  def partners
  end

  def research
  end

  def telapeer
    @meetings = Meeting.all
  end

  def benefits
  end


  private
    def sanitize_flash_html
      key = flash[:html_safe]
      flash.now[key] = flash[key].html_safe
      flash.delete(:html_safe)
    end
end
