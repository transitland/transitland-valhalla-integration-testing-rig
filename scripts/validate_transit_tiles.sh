#!/bin/bash
TRANSIT_TEST_FILE=${DATA_DIR}/transit_acceptance_tests.txt

# only run the tests for production.
# wget -q "https://raw.githubusercontent.com/valhalla/valhalla/master/test_requests/transit_acceptance_tests.txt" -O $TRANSIT_TEST_FILE; catch_exception
# echo "s-9q8yyugptw-sanfranciscocaltrainstation,s-9q8yycs6ku-22ndstreetcaltrainstation,r-9q9-local" > $TRANSIT_TEST_FILE
echo "s-9q9p1b9pwu-lakemerritt,s-9q8yyzcpqw-embarcadero,r-9q9n-warmsprings~southfremont~dalycity" > $TRANSIT_TEST_FILE

echo "[INFO] Valdating transit tiles... "
valhalla_validate_transit \
  --config $CONF_DIR/valhalla.json \
  validate \
  ${TRANSIT_TEST_FILE}

echo "[SUCCESS] valhalla_validate_transit completed!"
