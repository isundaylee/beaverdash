# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  maps = {}

  showPosition = (position) ->
    myLatlon = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)

    $('.map-canvas').each (i, c) ->
      id = $(c).attr('id')
      marker1 = new google.maps.Marker(
        position: myLatlon
        map: maps[id]
        title: "Starting Location"
      )
      # console.log(marker1)
      # marker1.setMap maps[id]

  getLocation = ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition showPosition
    else
      console.log 'Upgrade browser!! '

  initializeMap = ->
    $('.map-canvas').each (i, c) ->
      id = $(c).attr('id')
      $(c).css('height', $(c).css('width'))
      latlon = new google.maps.LatLng(parseFloat($(c).find(".lat").text()), parseFloat($(c).find(".lon").text()))
      mapOptions =
        zoom: 17
        center: latlon
      maps[id] = new google.maps.Map(c, mapOptions)

      marker2 = new google.maps.Marker(
        position: latlon
        map: maps[id]
        title: "Destination"
      )
      # marker2.setMap maps[id]

  initializeMap()
  getLocation()
