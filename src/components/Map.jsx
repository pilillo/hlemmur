import { MapContainer, TileLayer} from 'react-leaflet'
//import {useMapEvents} from "react-leaflet";
import React, { useState } from 'react';
import RoutingMachine from './RoutingMachine';

function Map(){

    const [position, setPosition] = useState([51.51, -0.12])

    return (
        <div id="map" >
            <MapContainer 
                center={position}
                zoom={13}
                scrollWheelZoom={true}
            >
            <TileLayer
                attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
                url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
            />
            <RoutingMachine />
            
            </MapContainer>
        </div>
    )
}

export default Map