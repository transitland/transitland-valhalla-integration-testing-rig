#!/bin/bash

# build using Transitland API, validate, run valhalla_route_service

cwd="$(cd "$(dirname "$0")"; pwd)"
source $cwd/tiles_env.sh

echo "[INFO] Building transit tiles: ${1}"
$cwd/build_transit_tiles.sh $1
$cwd/validate_transit_tiles.sh

echo "[INFO] Downloading extract"
mkdir -p $DATA_DIR/extracts
wget https://s3.amazonaws.com/metro-extracts.mapzen.com/san-francisco-bay_california.osm.pbf -O $DATA_DIR/extracts/extract.osm.pbf

echo "[INFO] Building Valhalla routing tiles"
valhalla_build_tiles --conf $CONF_DIR/valhalla.json $DATA_DIR/extracts/extract.osm.pbf

echo "[INFO] Starting valhalla_route_service"
valhalla_route_service $CONF_DIR/valhalla.json
