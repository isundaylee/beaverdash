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

      circles = $.parseJSON($(c).parent().find('.router_points').text())
      $(circles).each (i, c) ->
        options =
          strokeColor: '#255AA7',
          strokeOpacity: 0,
          strokeWeight: 2,
          fillColor: '#ED2626',
          fillOpacity: 0.2 + 2 * c[2],
          map: maps[id],
          center: new google.maps.LatLng(c[0], c[1]),
          radius: 10 + 100 * c[2]

        new google.maps.Circle(options)

  display_email = (ev) ->
    $(ev.target).parents('.event').find('.email_overlay').show()

  initializeLinks = ->
    $('.title a').click(display_email)

    $('.email_overlay').click ->
      $('.email_overlay').hide()

  initializeLinks()
  initializeMap()
  getLocation()
