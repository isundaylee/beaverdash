# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  maps = {}
  myLatlon = null
  directionDisplays = {}
  directionsService = new google.maps.DirectionsService()

  isMobile =
    Android: ->
      /Android/i.test navigator.userAgent
    iOS: ->
      /iPhone|iPad|iPod/i.test navigator.userAgent

  showPosition = (position) ->
    myLatlon = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)

    $('.map-canvas').each (i, c) ->
      id = $(c).attr('id')

      latlon = new google.maps.LatLng(parseFloat($(c).parent().find(".lat").text()), parseFloat($(c).parent().find(".lon").text()))

      if isMobile.iOS() || isMobile.Android()
        $(c).parents('.event').find('.ubering_link a').attr('href', 'uber://?action=setPickup&pickup=my_location')

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

      drive_request =
        origin: myLatlon
        destination: latlon
        travelMode: google.maps.TravelMode.DRIVING
        avoidHighways: true

      directionsService.route bike_request, (result, status) ->
        duration = result.routes[0].legs[0].duration.value
        $(c).parents('.event').find('.biking_eta').text(formatDate(timeAfter(duration * 1.0 / 60)))

      directionsService.route drive_request, (result, status) ->
        duration = result.routes[0].legs[0].duration.value

        console.log "https://api.uber.com/v1/estimates/time?start_latitude=" + myLatlon.lat() + "&start_longitude=" + myLatlon.lng()

        $.ajax
          url: "https://api.uber.com/v1/estimates/time?start_latitude=" + latlon.lat() + "&start_longitude=" + latlon.lng()
          type: 'GET'
          success: (data, status, xhr) ->
            uber_eta = null
            $(data.times).each (i, t) ->
              if t['display_name'] == 'uberX'
                uber_eta = t['estimate']
            $(c).parents('.event').find('.ubering_eta').text(formatDate(timeAfter((duration + uber_eta) * 1.0 / 60)))
          beforeSend: (xhr) ->
            xhr.setRequestHeader('Authorization', "Token U8-Gh1wXD_q-TOCR86JDpxAftM1vNX6U95TIIdE3")

        $.ajax
          url: "https://api.uber.com/v1/estimates/price?start_latitude=" + myLatlon.lat() + "&start_longitude=" + myLatlon.lng() + "&end_latitude=" + latlon.lat() + "&end_longitude=" + latlon.lng()
          type: 'GET'
          success: (data, status, xhr) ->
            low = null
            high = null
            $(data.prices).each (i, t) ->
              if t['display_name'] == 'uberX'
                low = parseFloat(t['low_estimate'])
                high = parseFloat(t['high_estimate'])
            $(c).parents('.event').find('.ubering_exp').text('$' + (low + high) / 2)
          beforeSend: (xhr) ->
            xhr.setRequestHeader('Authorization', "Token U8-Gh1wXD_q-TOCR86JDpxAftM1vNX6U95TIIdE3")

      directionsService.route request, (result, status) ->
        directionDisplays[id].setDirections result if status is google.maps.DirectionsStatus.OK

      getWalkingETA();
      setPercentages()

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
      time = distance * 12.5
      $(c).parents('.event').find('.walking_eta').text(formatDate(timeAfter(time)))
      $(c).parents('.event').find('.walking-time').text(time)

  setPercentages = ->
    $('.map-canvas').each (i, c) ->
      current = new Date()
      emailTime = new Date(parseFloat($(c).parents('.event').find('.email-time').text()))
      console.log([current.getTime(),emailTime.getTime()])
      diff = current.getTime() - emailTime.getTime()
      diff = 5*60000
      predictedTime = diff / 60000 +  parseFloat($(c).parents('.event').find('.walking-time').text())
      chance = Math.pow(Math.E, -parseFloat($(c).parents('.event').find('.predators').text())/200 * (predictedTime-1)) * 100
      console.log([diff,predictedTime,chance])
      $(c).parents('.event').find('.percentage_bar').css('width', chance + '%')
      $(c).parents('.event').find('.percentage').text(Math.round(chance*100)/100)

  initializeLinks()
  initializeMap()
  getLocation()
