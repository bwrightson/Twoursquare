class FoursquareController < ApplicationController
  def checkin
    message = params["TranscriptionText"]
    phone = params["Caller"]
    phone = phone.gsub('+1', '')
    user = User.where('phone' => phone)
    chunks = message.split(' in ')
    venue = chunks[0]
    city = URI.escape(chunks[1])
    url = "http://where.yahooapis.com/geocode?q=" + city + "&appid=pi5fY574"
    location = Curl::Easy.perform(url)
    location = location.body_str
    @xml_doc = Nokogiri::XML(location)
    lat = @xml_doc.at_css("Result latitude").inner_text()
    lon = @xml_doc.at_css("Result longitude").inner_text()
  end
end
