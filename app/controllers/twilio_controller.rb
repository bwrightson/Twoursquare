class TwilioController < ApplicationController
  def call
    response = Twilio::TwiML::Response.new do |r|
      r.Say 'Please say venue name in city name, then press pound', :voice => 'woman'
      r.Record :action => '/hangup', :maxLength => '60', :transcribeCallback => '/incoming/transcript'
    end
    render :text => response.text
  end
  def hangup
    response = Twilio::TwiML::Response.new do |r|
      r.Hangup
    end
    render :text => response.text
  end
end
