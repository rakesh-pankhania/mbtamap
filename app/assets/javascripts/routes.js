var markerStore = [];
var map;

function syncVehicles(url) {
  $.ajax({
    url: url,
    context: document.body,
    success: function(rv){
      resolveVehicles(rv);
    },
    error: function() {
      // TODO: Color an indicator or something here
      console.log("Error connecting");
    }
  });
}

function resolveVehicles(vehicles) {
  //
  // Remove any vehicles that have terminated
  //

  var activeVehicleIds = new Set(vehicles.map(function(vehicle) {
    return vehicle.id;
  }));

  var idsToRemove = new Set(
    Object.keys(markerStore).filter(function(key) {
      return !activeVehicleIds.has(key);
    })
  );

  idsToRemove.forEach(function(vehicleId) {
    var marker = markerStore[vehicleId];
    marker.setMap(null);
    removeMarkerFromStore(vehicleId)
  });

  vehicles.forEach(function(vehicle) {
    var marker = markerStore[vehicle.id];

    if (marker == null) {
      addVehicle(vehicle);
    } else {
      marker.setPosition({
        lat: vehicle.attributes.latitude,
        lng: vehicle.attributes.longitude
      });
      var icon = marker.getIcon();
      icon.rotation = vehicle.attributes.bearing;
      marker.setIcon(icon);
    }
  });
}

function addVehicle(vehicle) {
  var marker = new google.maps.Marker({
    position: {
      lat: vehicle.attributes.latitude,
      lng: vehicle.attributes.longitude
    },
    icon: {
      path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW,
      scale: 4,
      strokeWeight: 2,
      fillColor: '#FFFFFF',
      fillOpacity: 0.75,
      rotation: vehicle.attributes.bearing
    },
    map: map
  });

  addMarkerToStore(vehicle.id, marker);
}

//
// Vehicle store methods
//

function addMarkerToStore(id, marker) {
  markerStore[id] = marker;
}

function removeMarkerFromStore(id) {
  delete markerStore[id]
}


// TODO: Dump this somewhere
function initMap() {
  var bounds = new google.maps.LatLngBounds();

  map = new google.maps.Map(
    document.getElementById('map'),
    { mapTypeId: google.maps.MapTypeId.ROADMAP }
  );

  mapSpec.shapes.forEach(function(shape) {
    var tripPath = new google.maps.Polyline({
      path: shape,
      geodesic: true,
      strokeColor: mapSpec.color,
      strokeOpacity: 1.0,
      strokeWeight: 4,
      map: map
    });
  });

  mapSpec.stops.forEach(function(stop) {
    var marker = new google.maps.Marker({
      position: {lat: stop.lattitude, lng: stop.longitude},
      title: stop.name,
      icon: {
        path: google.maps.SymbolPath.CIRCLE,
        scale: 4,
        strokeWeight: 2,
        fillColor: '#FFFFFF',
        fillOpacity: 1
      },
      map: map
    });

    bounds.extend(marker.position);
  });

  mapSpec.vehicles.forEach(addVehicle);

  map.fitBounds(bounds);

  // Try HTML5 geolocation.
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      var marker = new google.maps.Marker({
        position: {lat: position.coords.latitude, lng: position.coords.longitude},
        title: 'You are here',
        icon: {
          path: google.maps.SymbolPath.CIRCLE,
          scale: 4,
          strokeWeight: 2,
          fillColor: 'blue',
          fillOpacity: 1
        },
        map: map
      });
    });
  }
}
