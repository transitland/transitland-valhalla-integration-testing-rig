#!/bin/sh
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
# don't catch_exception here: this will throw a custom error

echo "[SUCCESS] valhalla_build_transit completed!"
