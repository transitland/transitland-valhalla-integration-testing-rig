#!/bin/bash
# Create a named docker container
# build_container.sh <CONTAINER NAME>

docker run \
  --name $1 \
  -e TRANSITLAND_API_KEY='transitland-dummy' \
  -e TRANSITLAND_FEED='f-9q9-bart' \
  -e TRANSITLAND_URL='http://mbp.local:3000' \
  -p 18010:8002 \
  -v `pwd`:/test_scripts \
  -t \
  -i \
  valhalla/docker:ppa-1.3.4 \
  /bin/bash /test_scripts/build_and_route.sh
