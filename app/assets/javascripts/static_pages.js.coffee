# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  maps = {}
  myLatlon = null
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

      bike_request =
        origin: myLatlon
        destination: latlon
        travelMode: google.maps.TravelMode.BICYCLING
        avoidHighways: true

      directionsService.route bike_request, (result, status) ->
        duration = result.routes[0].legs[0].duration.value
        $(c).parents('.event').find('.biking_eta').text(formatDate(timeAfter(duration * 1.0 / 60)))

      directionsService.route request, (result, status) ->
        directionDisplays[id].setDirections result if status is google.maps.DirectionsStatus.OK

      getWalkingETA();

  getLocation = ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition showPosition
    else
      console.log 'Upgrade browser!! '

  initializeMap = ->
    $('.map-canvas').each (i, c) ->
      id = $(c).attr('id')
      $(c).css('height', $(c).css('width'))
      latlon = new google.maps.LatLng(parseFloat($(c).parent().find(".lat").text()), parseFloat($(c).parent().find(".lon").text()))
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

  getDistance = (from, to) ->
    dlat = 111.321 * (to.lat() - from.lat())
    console.og
    dlng = 85 * (to.lng() - from.lng())
    return Math.sqrt(dlat * dlat + dlng * dlng)

  formatTime = (time) ->
    min = parseInt(time)
    sec = parseInt((time - min) * 60)
    return min + ':' + sec

  formatDate = (d) ->
    hr = d.getHours()
    min = d.getMinutes()
    min = "0" + min  if min < 10
    ampm = (if hr < 12 then "am" else "pm")
    hr + ":" + min + " " + ampm

  timeAfter = (time) ->
    current = new Date()
    then_time = new Date(current.getTime() + time * 60000)
    return then_time

  getWalkingETA = ->
    $('.map-canvas').each (i, c) ->
      latlon = new google.maps.LatLng(parseFloat($(c).parent().find(".lat").text()), parseFloat($(c).parent().find(".lon").text()))
      distance = getDistance(myLatlon, latlon)
      time = distance * 10
      $(c).parents('.event').find('.walking_eta').text(formatDate(timeAfter(time)))

  setPercentages = ->
    $('.map-canvas').each (i, c) ->
      $(c).parents('.event').find('.percentage_bar').css('width', $(c).parents('.event').find('.percentage').text() + '%')

  setPercentages()
  initializeLinks()
  initializeMap()
  getLocation()

  $.ajax
    url: "https://api.uber.com/v1/estimates/price?start_latitude=37.0&start_longitude=-122.0&end_latitude=38.0&end_longitude=-123.0"
    success: (data, status, xhr) ->
      console.log data
    type: 'GET'
    beforeSend: (xhr) ->
      xhr.setRequestHeader('Authorization', "Token U8-Gh1wXD_q-TOCR86JDpxAftM1vNX6U95TIIdE3")
