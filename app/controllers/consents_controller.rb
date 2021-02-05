class ConsentsController < ApplicationController
  before_action :set_consent, only: [:show]

  def show
    respond_to do |format|
      format.pdf do
        render pdf: 'consent_form', template: 'consents/show.html.erb'
      end
    end
  end

  private

    def set_consent
      @consent = Consent.find(params[:id])
    end
end
