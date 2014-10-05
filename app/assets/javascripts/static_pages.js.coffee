# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  maps = {}
  directionDisplays = {}
  directionsService = new google.maps.DirectionsService()

  showPosition = (position) ->
    myLatlon = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)

    $('.map-canvas').each (i, c) ->
      id = $(c).attr('id')

      latlon = new google.maps.LatLng(parseFloat($(c).parent().find(".lat").text()), parseFloat($(c).parent().find(".lon").text()))

      request =
        origin: myLatlon
        destination: latlon
        travelMode: google.maps.TravelMode.WALKING
        avoidHighways: true

      directionsService.route request, (result, status) ->
        directionDisplays[id].setDirections result if status is google.maps.DirectionsStatus.OK

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
      maps[id] = new google.maps.Map(c)
      directionDisplays[id] = new google.maps.DirectionsRenderer()
      directionDisplays[id].setMap maps[id]

  initializeMap()
  getLocation()
