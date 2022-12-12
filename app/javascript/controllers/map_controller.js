// map_controller.js
import { Controller } from "@hotwired/stimulus"
import "leaflet-css"


export default class extends Controller {
  static targets = [ "placeholder" ]

  connect(){
    import("leaflet").then( L => {
      const person = JSON.parse(this.data.get("person"))
      this.map = L.map(this.placeholderTarget,{zoomDelta:0.5,zoomSnap:0.5}).setView([ person.lat, person.lng ], 16);

      L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
      }).addTo(this.map);
      var MarkerIcon = L.Icon.extend({
        options: {
           iconSize: [42, 42],
        }
      });
      alert(this.data.get("cars"))
      const array = JSON.parse(this.data.get("cars"))
      alert(array.length)

      var carIcon = new MarkerIcon({
        iconUrl: 'https://cdn-icons-png.flaticon.com/512/744/744465.png'
      })
      var personIcon = new MarkerIcon({
        iconUrl: 'https://cdn-icons-png.flaticon.com/512/805/805404.png'
      })

      const url = this.data.get("url")
      const personMarker = L.marker([person.lat, person.lng], {icon: personIcon}).addTo(this.map);

      for (let i = 0; i < array.length; i++) {
        const car = array[i];
        alert(getDistanceFromLatLonInKm(person.lat, person.lng, car.lat, car.lng).toFixed(2) + "KM")
        if (!car.is_rented && getDistanceFromLatLonInKm(person.lat, person.lng, car.lat, car.lng).toFixed(2)<=0.5){
          const marker = L.marker([car.lat, car.lng], {icon: carIcon}).addTo(this.map);
          marker.addEventListener('click', function() { window.open(url + car.id, "_self") }); 
          var popup = L.popup({
            offset: [0, -15]
          })
          .setContent(car.brand.toUpperCase() + " " + car.model.toUpperCase())
          marker.bindPopup(popup);

          marker.on('mouseover', function (e) {
            this.openPopup();
          });
          marker.on('mouseout', function (e) {
              this.closePopup();
          });
        }

      }


      });

      function getDistanceFromLatLonInKm(lat1,lon1,lat2,lon2) {
        var R = 6371; // Radius of the earth in km
        var dLat = deg2rad(lat2-lat1);  // deg2rad below
        var dLon = deg2rad(lon2-lon1); 
        var a = 
          Math.sin(dLat/2) * Math.sin(dLat/2) +
          Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * 
          Math.sin(dLon/2) * Math.sin(dLon/2)
          ; 
        var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
        var d = R * c; // Distance in km
        return d;
      }
      
      function deg2rad(deg) {
        return deg * (Math.PI/180)
      }

  }






  disconnect(){
    this.map.remove()
  }

}