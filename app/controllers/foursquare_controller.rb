class FoursquareController < ApplicationController
  def checkin
    message = params["TranscriptionText"]
    phone = params["Caller"]
    phone = phone.gsub('+1', '')
    user = User.find_by_phone(phone)
    chunks = message.split(' in ')
    raw_query = chunks[0].downcase
    query = URI.escape(raw_query)
    city = URI.escape(chunks[1])
    url = "http://where.yahooapis.com/geocode?q=" + city + "&appid=pi5fY574"
    location = Curl::Easy.perform(url).body_str
    @xml_doc = Nokogiri::XML(location)
    lat = URI.escape(@xml_doc.at_css("Result latitude").inner_text())
    lon = URI.escape(@xml_doc.at_css("Result longitude").inner_text())
    url = "https://api.foursquare.com/v2/venues/search?ll="
    url += lat + "," + lon + "&query=" + query
    url += "&oauth_token=" + user.token + "&v=20120322"
    venue_list = JSON.parse(Curl::Easy.perform(url).body_str)
    venue_id = ""
    venue_list["response"]["venues"].each do |venue|
      if venue["name"].downcase == raw_query
        venue_id = venue["id"]
      end
    end
    if venue_id != ""
       url = "https://api.foursquare.com/v2/checkins/add"
       post_params = [
         Curl::PostField.content('venueId', venue_id),
	 Curl::PostField.content('oauth_token', user.token),
       	 Curl::PostField.content('v', 20120322)
       ]
       checkin_response = JSON.parse(Curl::Easy.http_post(url, *post_params).body_str)
    end
    binding.pry
  end
end
