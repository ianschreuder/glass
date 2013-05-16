class Twilio::SmsController < ApplicationController
  skip_before_action :login_required, :only => [:reply]
  skip_before_action :verify_authenticity_token, :only=>[:reply]

  def reply
    ServiceNumber.log_incoming(sms_params)
    Sms.receive(sms_params)

    render(:nothing=>true)
  end

  private

  def sms_params
    params.slice(:To, :Body, :From, :SmsSid, :FromCity, :FromCountry, :FromZip)
  end

end

# Actual Example From Twilio
{
  "AccountSid"=>"ACd51d81a47b85170ec4d1ac1c0304aa7b", 
  "Body"=>"A", 
  "ToZip"=>"80202", 
  "FromState"=>"CO", 
  "ToCity"=>"DENVER", 
  "SmsSid"=>"SM6ee791a4bc66cf72c6e1f0082c04bcbe", 
  "ToState"=>"CO", 
  "To"=>"+17204667622", 
  "ToCountry"=>"US", 
  "FromCountry"=>"US", 
  "SmsMessageSid"=>"SM6ee791a4bc66cf72c6e1f0082c04bcbe", 
  "ApiVersion"=>"2010-04-01", 
  "FromCity"=>"DENVER", 
  "SmsStatus"=>"received", 
  "From"=>"+13035135133", 
  "FromZip"=>"80204", 
  "controller"=>"twilio/sms", 
  "action"=>"reply", 
  "format"=>"json"
}

# # To Twilio
# curl -X POST 'https://api.twilio.com/2010-04-01/Accounts/ACd51d81a47b85170ec4d1ac1c0304aa7b/SMS/Messages.xml' \
# -d 'To=%2B17204667622' \
# -d 'From=%2B17204667622' \
# -d "Body=A" \
# -d "Sender=ian" \
# -u ACd51d81a47b85170ec4d1ac1c0304aa7b:e4df170b98793fcc6b5f14e54e97843b

# # To Localhost
# curl -X POST 'http://demo.grewper.com/twilio/sms/reply' \
# -d 'To=%2B17204667622' \
# -d 'From=%2B13035135133' \
# -d "Body=A" \
# -d "Sender=ian" \
# -u ACd51d81a47b85170ec4d1ac1c0304aa7b:e4df170b98793fcc6b5f14e54e97843b

