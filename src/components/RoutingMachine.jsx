import L from "leaflet";
import { createControlComponent } from "@react-leaflet/core";
import "leaflet-routing-machine";
import "leaflet-control-geocoder";
import {useMapEvents} from "react-leaflet";

const RoutingMachine = createControlComponent(function(props) {

    function createButton(label, container) {
        var btn = L.DomUtil.create('button', '', container);
        btn.setAttribute('type', 'button');
        btn.innerHTML = label;
        return btn;
    }
    

    const map = useMapEvents({
        click(e) {
            var container = L.DomUtil.create('div'),
            startBtn = createButton('Start from this location', container),
            destBtn = createButton('Go to this location', container);
    
            L.popup()
                .setContent(container)
                .setLatLng(e.latlng)
                .openOn(map);
            
            
            L.DomEvent.on(startBtn, 'click', function() {
                //control.spliceWaypoints(0, 1, e.latlng);
                map.closePopup();
            });
            L.DomEvent.on(destBtn, 'click', function() {
                //control.spliceWaypoints(control.getWaypoints().length - 1, 1, e.latlng);
                map.closePopup();
            });
            
        },
      })
      

    const geocoder = L.Control.Geocoder.nominatim();
    
    const instance = L.Routing.control({
        // https://www.liedman.net/leaflet-routing-machine/tutorials/alternative-routers/
        //router: L.routing.valhalla("http://localhost:8002/route"),
        waypoints: [
            //L.latLng(64.131259, -21.896194),
            //L.latLng( e.latlng.lat, e.latlng.lng),
            //L.latLng(" string address"),
            //L.latLng(64.110963, -21.908017),
        ],
        lineOptions: {
            styles: [{ color: "blue", weight: 4, opacity: 0.6 }]
        },
        show: true,
        addWaypoints: true,
        routeWhileDragging: true,
        draggableWaypoints: true,
        fitSelectedRoutes: true,
        showAlternatives: true,
        
        // ---
        language: 'en',
        geocoder: geocoder,
        autoRoute: true 
    });

    /*
    var ReversablePlan = L.Routing.Plan.extend({
        createGeocoders: function() {
            var container = L.Routing.Plan.prototype.createGeocoders.call(this),
                reverseButton = createButton('↑↓', container);
            return container;
        }
    });

    var plan = new ReversablePlan([
        L.latLng(57.74, 11.94),
        L.latLng(57.6792, 11.949)
    ], {
        geocoder: geocoder,
        routeWhileDragging: true
    }),

    control = L.Routing.control({
        routeWhileDragging: true,
        plan: plan
    })
    return control;
    */

    return instance;
});

export default RoutingMachine;