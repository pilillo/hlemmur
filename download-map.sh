#! /bin/sh

set -e

if [[ ! -f "$FILE" ]]; then
    echo "Downloading ${MAP_URL}"
    curl ${MAP_URL} --output "/data/map.osm.pbf"
fi



