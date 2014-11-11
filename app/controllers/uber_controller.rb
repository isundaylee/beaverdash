class UberController < ApplicationController

  require 'cgi'
  require 'uri'
  require 'json'
  require 'net/http'

  def delegate
    url = params[:url]

    uri = URI.parse(url)
    puts uri
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri.path + '?' + uri.query)
    req['Authorization'] = 'Token ' + APP_CONFIG[:uber][:token]
    puts 'Token ' + APP_CONFIG[:uber][:token]

    res = http.request(req)
    puts res.body
    render json: JSON.parse(res.body)
  end

end
