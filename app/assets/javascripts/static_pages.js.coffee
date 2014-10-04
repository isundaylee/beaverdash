# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

initialize = ->
  mapOptions =
    zoom: 17
    center: new google.maps.LatLng(parseFloat($('#lat').text()), parseFloat($('#lon').text()))

  map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)
  return
map = undefined
google.maps.event.addDomListener window, "load", initialize