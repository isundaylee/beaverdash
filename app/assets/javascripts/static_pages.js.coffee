# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  map = undefined
  showPosition = (position) ->
    x.innerHTML = "Current Latitude: " + position.coords.latitude + "<br>Current Longitude: " + position.coords.longitude
    myLatlng1 = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
    marker1 = new google.maps.Marker(
      position: myLatlng1
      map: map
      title: "Starting Location"
    )
    marker1.setMap map

    myLatlng2 = new google.maps.LatLng(parseFloat($("#lat").text()), parseFloat($("#lon").text()))
    marker2 = new google.maps.Marker(
      position: myLatlng2
      map: map
      title: "Destination"
    )
    marker2.setMap map
  getLocation = ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition showPosition
    else
      x.innerHTML = "Geolocation is not supported by this browser."
  initializeMap = ->
    mapOptions =
      zoom: 17
      center: new google.maps.LatLng(parseFloat($("#lat").text()), parseFloat($("#lon").text()))

    map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)


  initializeMap()
  x = document.getElementById("demo")
  getLocation()
  return