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
end
