class StaticPagesController < ApplicationController
	require 'net/http'
	require 'json'

  def homepage
    @events = Event.all(valid: true)
  end



  def location
  	if params['building']
  		url = URI.parse('http://m.mit.edu/apis/maps/places/?q=' + params['building'])
			req = Net::HTTP::Get.new(url.to_s)
			res = Net::HTTP.start(url.host, url.port) {|http|
			  http.request(req)
			}
			content_hash = JSON.parse(res.body)
			@latlon = [content_hash[0]['lat_wgs84'], content_hash[0]['long_wgs84']]
			# @content = "Coordinates of " + params['building'].to_s + ": " +
  	end
  end
end
