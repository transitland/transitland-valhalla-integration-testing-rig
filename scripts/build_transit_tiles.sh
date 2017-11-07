#!/bin/sh

# build transit tiles using Transitland API

# clean up from previous runs
if [ -d "${TRANSIT_TILE_DIR}" ]; then
  echo "[INFO] Removing contents of prior run in ${TRANSIT_TILE_DIR}/*..."
  rm -rf "${TRANSIT_TILE_DIR}"
fi

# create dirs
mkdir -p "${DATA_DIR}"
mkdir -p "${TRANSIT_TILE_DIR}"

# for now....build the timezones.
echo "[INFO] Building timezones... "
valhalla_build_timezones $CONF_DIR/valhalla.json

echo "Action: ${1}"

if [ "convert" = $1 ]; then
  echo "[INFO] Building tiles... ${TRANSIT_TILE_DIR}"
  cwd=`pwd`
  cd /Users/irees/mapzen/transitland-datastore && bundle exec rails runner lib/proto/tile_export.rb $TRANSIT_TILE_DIR && cd $cwd

  echo "[INFO] Converting tiles... "
  valhalla_convert_transit \
    $CONF_DIR/valhalla.json \
    ${TRANSITLAND_URL} \
    ${TRANSITLAND_PER_PAGE} \
    ${TRANSIT_TILE_DIR} \
    ${TRANSITLAND_API_KEY} \
    ${TRANSITLAND_LEVELS} \
    ${TRANSITLAND_FEED}
fi

if [ "build" = $1 ]; then
  # build transit tiles
  echo "[INFO] Building tiles... "
  valhalla_build_transit \
    $CONF_DIR/valhalla.json \
    ${TRANSITLAND_URL} \
    ${TRANSITLAND_PER_PAGE} \
    ${TRANSIT_TILE_DIR} \
    ${TRANSITLAND_API_KEY} \
    ${TRANSITLAND_LEVELS} \
    ${TRANSITLAND_FEED}
fi

echo "[SUCCESS] valhalla_build_transit completed!"
