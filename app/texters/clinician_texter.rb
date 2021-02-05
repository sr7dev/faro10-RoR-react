class ClinicianTexter < Textris::Base
  default from: "Faro10 <#{ENV.fetch("TWILIO_PHONE_NUMBER")}>"

  def new_alert(phone)
    text to: phone
  end
end
