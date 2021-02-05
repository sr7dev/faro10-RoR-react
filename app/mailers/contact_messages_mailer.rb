class ContactMessagesMailer < ApplicationMailer
  def contact(params)
    @name = params[:name] 
    @msg  = params[:message]
    @email = params[:email]

    mail to: 'jroberto@apptio.com', subject: params[:subject]
  end
end
