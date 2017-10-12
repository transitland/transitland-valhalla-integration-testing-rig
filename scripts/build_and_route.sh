#!/bin/bash

# echo "Compiling Valhalla from source"
# /bin/bash /scripts/install_from_source.sh

echo "Building transit tiles"
/scripts/build_transit_tiles.sh

echo "Transit tiles done"
mkdir -p /data/extracts && cd /data/extracts && wget https://s3.amazonaws.com/metro-extracts.mapzen.com/san-francisco-bay_california.osm.pbf && cd /

echo "Extract done"
valhalla_build_tiles --conf /conf/valhalla.json /data/extracts/san-francisco-bay_california.osm.pbf
echo "Build tiles done"

echo "Starting Valhalla route service"
valhalla_route_service /conf/valhalla.json
