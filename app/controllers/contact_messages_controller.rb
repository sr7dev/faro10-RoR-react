class ContactMessagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]

  def create
    ContactMessagesMailer.delay.contact(params)

    redirect_to contact_path, notice: 'Your message was sent successfully.'
  end
end
