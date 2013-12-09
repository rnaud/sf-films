// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require markerclusterer
//= require_tree .

var markers = [];
var markerCluster;
var map;
var infoWindow;

$(document).ready(function(){
  var center = new google.maps.LatLng(37.7749295, -122.4194155);
  infoWindow = $("#infoWindow");

  console.log("what?");

   map = new google.maps.Map(document.getElementById('map'), {
    zoom: 14,
    center: center,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  });

  setUpDefaultLocations();

  $("body").on("click", ".pop-close", function() {
    $(this).parents(".pop-modal").removeClass("show");
    setTimeout(function(){$(this).remove()},500);
  });

  $("body").on("click", ".filter-movie", function(e) {
    reloadLocations($(this).attr("href"));
    $('#search').typeahead('setQuery', $(this).data("title"));
    $("#disable-filter").show();
    e.preventDefault();
  });

  $("#disable-filter").click(function() {
    $(this).hide();
    $('#search').typeahead('setQuery', '');
    setUpDefaultLocations();
  });

  $('#search').typeahead([
  {
    name: 'search2',
    prefetch: {
    url: '/search.json',
    ttl: 0
    },
    template: '<p><strong>{{value}}</strong> – {{type}}</p>',
    engine: Hogan
  }
]);

  $('#search').bind('typeahead:selected', function(obj, datum, name) {
    $("#disable-filter").show();
    reloadLocations(datum.url);
  });
});


function setUpDefaultLocations() {
  reloadLocations("/locations.json");
}

function cleanMap() {
  if (markerCluster)
    markerCluster.setMap(null);

  $.each( markers, function(key, location) {
    location.setMap(null);
    console.log(location.address);
  });
  markers = [];
  markerCluster = null;
}

function reloadLocations(url) {
  console.log("relod with Map"+ url);
  cleanMap();

  $.getJSON(url, function(data) {
  $.each( data, function(key, location) {
    var latLng = new google.maps.LatLng(location.latitude, location.longitude);
    var marker = new Location({position: latLng}, location);
    google.maps.event.addListener(marker, 'click', function() {
      openLocationModal(marker.attached_object);
    });

    google.maps.event.addListener(marker, 'mouseover', function() {  
      console.log(marker.attached_object.movie_title);
      infoWindow.html(marker.attached_object.movie_title + " <span class='address'>"+marker.attached_object.full_street_address+"</span>");
      infoWindow.addClass("active");
    });

    google.maps.event.addListener(marker, 'mouseout', function() {  
      infoWindow.removeClass("active");
    });

    markers.push(marker);
  });
  markerCluster = new MarkerClusterer(map, markers, {maxZoom: 15});
});
}

function openLocationModal(location) {
  $.get( "/locations/"+location.id+".js", function( data ) {
    console.log(data);
    createPopUp(data);
});

}

function createPopUp(content){
  var template = $("#popup-template").clone().attr("id", "id-"+Math.random());
  template.find(".pop-content").prepend(content);
  template.appendTo('body');
  setTimeout(function(){template.addClass("show");},100); 
}

function Location(opts, object) { 
  this.setValues(opts); 
  this.attached_object = object;
} 

Location.prototype = new google.maps.Marker; 

Location.prototype.remove = function () { 
  this.setMap(null); 
}