class StaticPagesController < ApplicationController
	require 'net/http'
	require 'json'

  DEFAULT_WEIGHT = 150

  def homepage
    @events = Event.active.all

    js_events = @events.map do |e|
      {
        lat: e.lat,
        lon: e.lon,
        claimed: e.claimed,
        router_points: e.estimated_predators[1],
        email_time: e.raw_datetime,
        predators: e.estimated_predators[0].round(2)
      }
    end

    gon.weight = DEFAULT_WEIGHT
    gon.events = js_events

    if session[:fitbit_token].nil?
      @fitbit_link = "javascript: void(0); "
    else
      gon.has_fitbit = true
    end
  end
end
