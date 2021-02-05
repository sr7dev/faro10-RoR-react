class PdfEmailsController < ApplicationController

  def create
    type = params[:pdf_email][:type]
    address = params[:pdf_email][:address]

    if PdfMailer.delay.send(type, current_user, address)
      flash[:success] = "Successfully emailed your PDF to #{address}"
      redirect_to dashboard_path
    end
  end
end
