class FoursquareController < ApplicationController
  def checkin
    message = params["TranscriptionText"]
    phone = params["Caller"]
    phone = phone.gsub('+1', '')
    user = User.where('phone' => phone)
    chunks = message.split(' in ')
    venue = chunks[0]
    city = chunks[1]
  end
end
