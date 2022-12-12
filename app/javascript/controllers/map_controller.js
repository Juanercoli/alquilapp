// map_controller.js
import { Controller } from "@hotwired/stimulus"
import "leaflet-css"


export default class extends Controller {
  static targets = [ "placeholder" ]

  connect(){
    import("leaflet").then( L => {
      this.map = L.map(this.placeholderTarget,{zoomDelta:0.5,zoomSnap:0.5}).setView([ -34.92145, -57.95453 ], 14);

      L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
      }).addTo(this.map);
      var LeafIcon = L.Icon.extend({
        options: {
           iconSize: [42, 42],
        }
      });
      alert(this.data.get("cars"))
      const array = JSON.parse(this.data.get("cars"))
      alert(array.length)
      var greenIcon = new LeafIcon({
        iconUrl: 'https://cdn-icons-png.flaticon.com/512/744/744465.png'
      })
      const url = this.data.get("url")

      for (let i = 0; i < array.length; i++) {
        const car = array[i];
        if (!car.is_rented){
          const marker = L.marker([car.lat, car.lng], {icon: greenIcon}).addTo(this.map);
          marker.addEventListener('click', function() { window.open(url + car.id) }); 
        }

      }


      });

  }






  disconnect(){
    this.map.remove()
  }

}