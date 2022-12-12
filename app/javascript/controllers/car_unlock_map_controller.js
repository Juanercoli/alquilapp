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
      const car = JSON.parse(this.data.get("car"))

      var carIcon = new MarkerIcon({
        iconUrl: 'https://cdn-icons-png.flaticon.com/512/744/744465.png'
      })
      var personIcon = new MarkerIcon({
        iconUrl: 'https://cdn-icons-png.flaticon.com/512/805/805404.png'
      })

      const personMarker = L.marker([person.lat, person.lng], {icon: personIcon}).addTo(this.map);

      const marker = L.marker([car.lat, car.lng], {icon: carIcon}).addTo(this.map);
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


      });

  }

  disconnect(){
    this.map.remove()
  }

}