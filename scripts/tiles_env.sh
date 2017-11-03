#!/bin/bash
set -e

catch_exception() {
  if [ $? != 0 ]; then
    echo "[FAILURE] Detected non zero exit status while processing transit tiles!"
    exit 1
  fi
}

REGION=${REGION:-"us-east-1"}
export CONF_DIR=${CONF_DIR:-"/conf"}
export DATA_DIR=${DATA_DIR:-"/data/valhalla"}

# some defaults, if needed.
export TRANSITLAND_URL=${TRANSITLAND_URL:-"http://transit.land"}
export TRANSIT_TILE_DIR=${TRANSIT_TILE_DIR:-"${DATA_DIR}/transit"}
export TRANSITLAND_PER_PAGE=${TRANSITLAND_PER_PAGE:-5000}
export TRANSITLAND_LEVELS=${TRANSITLAND_LEVELS:-"4"}
