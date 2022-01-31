#! /bin/bash

set -e


if [ "$1" = "run" ]; then
    until test -f "/data/map.osrm"; do
        >&2 echo "Waiting for map osrm - sleeping"
        sleep 3
    done
    echo "Running OSRM"
    osrm-routed --algorithm mld /data/map.osrm
else
    until test -f "/data/map.osm.pbf"; do
        >&2 echo "Waiting for map pbf - sleeping"
        sleep 3
    done
    echo "Extracting OSRM file"
    osrm-extract -p /opt/car.lua /data/map.osm.pbf
    osrm-partition /data/map.osrm
    osrm-customize /data/map.osrm
    #osrm-extract /data/map.osm.pbf
fi