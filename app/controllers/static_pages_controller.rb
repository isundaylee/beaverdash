class StaticPagesController < ApplicationController
	require 'net/http'
	require 'json'

  DEFAULT_WEIGHT = 150

  def homepage
    @events = Event.all(valid: true, :updated_at.gte => 6.hours.ago).sort_by { |e| e.id.generation_time }.reverse.first(3)

    @weight = DEFAULT_WEIGHT

    if session[:fitbit_token].nil?
      # client = Fitbit::Client.new({:consumer_key => APP_CONFIG[:fitbit][:key], :consumer_secret => APP_CONFIG[:fitbit][:secret]})
      # request = client.request_token
      # session[:request_secret] = request.secret
      # @fitbit_link = "http://www.fitbit.com/oauth/authorize?oauth_token=#{request.token}"
      @fitbit_link = "javascript: void(0); "
    else
      # client = Fitbit::Client.new({:consumer_key => APP_CONFIG[:fitbit][:key], :consumer_secret => APP_CONFIG[:fitbit][:secret], :token => session[:fitbit_token], :secret => session[:fitbit_secret]})
      # access_token = client.reconnect(session[:fitbit_token], session[:fitbit_secret])
      # @weight = client.user_info['user']['weight'].to_f rescue DEFAULT_WEIGHT
      @weight = DEFAULT_WEIGHT
    end
  end
end
