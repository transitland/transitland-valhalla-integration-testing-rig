#!/bin/bash
source `dirname "$0"`/tiles_env.sh

echo "[INFO] Building transit tiles"
scripts/build_transit_tiles.sh
scripts/validate_transit_tiles.sh

echo "[INFO] Downloading extract"
cwd=`pwd`
mkdir -p $DATA_DIR/extracts && cd $DATA_DIR/extracts && wget https://s3.amazonaws.com/metro-extracts.mapzen.com/san-francisco-bay_california.osm.pbf && cd $cwd

echo "[INFO] Building Valhalla routing tiles"
valhalla_build_tiles --conf $CONF_DIR/valhalla.json $DATA_DIR/extracts/san-francisco-bay_california.osm.pbf

echo "[INFO] Starting valhalla_route_service"
valhalla_route_service $CONF_DIR/valhalla.json
