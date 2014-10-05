class OauthController < ApplicationController
  def oauth
    client = Fitbit::Client.new({:consumer_key => APP_CONFIG[:fitbit][:key], :consumer_secret => APP_CONFIG[:fitbit][:secret]})
    token = params[:oauth_token].strip
    verifier = params[:oauth_verifier].strip

    access_token = client.authorize(token, session[:request_secret], {oauth_verifier: verifier})

    session[:fitbit_token] = access_token.token
    session[:fitbit_secret] = access_token.secret

    redirect_to root_url
  end

  def log_activity
    client = Fitbit::Client.new({:consumer_key => APP_CONFIG[:fitbit][:key], :consumer_secret => APP_CONFIG[:fitbit][:secret], :token => session[:fitbit_token], :secret => session[:fitbit_secret]})
    access_token = client.reconnect(session[:fitbit_token], session[:fitbit_secret])

    puts client.log_activity({
      activityName: params[:activity].capitalize,
      durationMillis: (params[:duration].to_f * 1000).to_i,
      startTime: DateTime.now.strftime('%H:%M'),
      date: DateTime.now.strftime('%Y-%m-%d'),
      distance: params[:distance].to_f / 1600.0,
      manualCalories: params[:calories],
    })

    flash[:success] = 'You have successfully logged your ' + params[:activity] + ' activity. '
    redirect_to root_url
  end
end
