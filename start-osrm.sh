#! /bin/sh

set -e

OSM_FILE="/data/map.osm.pbf"
OSRM_FILE="/data/map.osrm"

OSM_FILE_LOCK="/data/osm.lock"
OSRM_FILE_LOCK="/data/osrm.lock"

if [ "$1" = "download" ]; then
    if [[ ! -f "$OSM_FILE" ]]; then
        echo "No local map file available. Downloading from ${MAP_URL}"
        touch ${OSM_FILE_LOCK}
        curl ${MAP_URL} --output "${OSM_FILE}"
        rm ${OSM_FILE_LOCK}
    fi
elif [ "$1" = "run" ]; then
    until test -f "${OSRM_FILE}" && test ! -f "${OSRM_FILE_LOCK}"; do
        >&2 echo $(ls "${OSRM_FILE}")
        >&2 echo $(ls "${OSRM_FILE_LOCK}")
        >&2 echo "Waiting for map osrm to be available - sleeping"
        sleep 3
    done
    echo "Running OSRM"
    osrm-routed --algorithm mld ${OSRM_FILE}
else
    # waiting for map file
    until test -f "${OSM_FILE}" && test ! -f "${OSM_FILE_LOCK}"; do
        >&2 echo "Waiting for map pbf to be available - sleeping"
        sleep 3
    done

    # extract any time newer than yesterday
    refdate=$(date -d "yesterday" +%s)
    filedate=$(stat -c "%W" "${OSM_FILE}")
    if [ ! -f "${OSRM_FILE}" ] || [ "$filedate" -gt "$refdate" ]; then
        echo "Extracting OSRM file"
        # lock via a lock file
        touch "${OSRM_FILE_LOCK}"
        osrm-extract -p /opt/car.lua ${OSM_FILE}
        #osrm-extract ${OSM_FILE}
        osrm-partition ${OSRM_FILE}
        osrm-customize ${OSRM_FILE}
        rm "${OSRM_FILE_LOCK}"
    fi
fi