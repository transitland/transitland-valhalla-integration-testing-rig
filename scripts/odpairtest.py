#!/usr/bin/python

# Test all O/D pairs (ODPAIRS) with all combinations of VALHALLA_ENDPOINTS and ROUTES
import urllib
import requests
import json

ODPAIRS = [
    ['s-9q8yt0hwpd-dalycity','s-9q8yyzcpqw-embarcadero'],
    ['s-9q9p19uwut-12thstoaklandcitycenter','s-9q8yyzcpqw-embarcadero'],
    ['s-9q8yyzcpqw-embarcadero','s-9q9p19uwut-12thstoaklandcitycenter'],
    ['s-9q9p145mkd-westoakland','s-9q8yyzcpqw-embarcadero'],
    ['s-9q8yyzcpqw-embarcadero','s-9q9p145mkd-westoakland']
]

VALHALLA_HOST = 'http://localhost:8002'

VALHALLA_ENDPOINTS = {
    'stationssp': 'http://localhost:18002',
    'master': 'http://localhost:18003',
}

TRANSITLAND_ENDPOINT = 'http://localhost:3000'

ROUTES = [
    'r-9q9-pittsburg~baypoint~sfia~millbrae', # on platform
    'r-9q8y-richmond~dalycity~millbrae' # on station
]

COORDINATES = {}
for k in reduce(lambda x,y: x|set(y), ODPAIRS, set()):
    COORDINATES[k] = requests.get('%s/api/v1/stops/%s'%(TRANSITLAND_ENDPOINT,k)).json().get('geometry_centroid', {}).get('coordinates')

for origin,destination in ODPAIRS:
    for name,endpoint in VALHALLA_ENDPOINTS.items():
        for route in ROUTES:
            print "===== %s: %s -> %s via %s ====="%(name, origin, destination, route)
            filename = "%s:%s:%s:%s.json"%(name,origin,destination,route)
            print "\t%s"%filename

            locations = [{"lat":COORDINATES[i][1],"lon":COORDINATES[i][0]} for i in [origin,destination]]
            params = {
                "locations":locations,
                "costing":"multimodal",
                "costing_options": {
                    "transit": {
                        "filters": {
                            "routes":{
                                "ids":[route],
                                "action":"include"
                            }
                        }
                    }
                },
                # "date_time":{"type":1,"value":"2017-10-11T08:00"}
            }

            status = ''
            try:
                response = requests.get(
                    '%s/route'%(endpoint),
                    params={'json': json.dumps(params, separators=(',', ':'))}
                ).json()
                status = response.get('status') or response.get('trip', {}).get('status_message')
                with open(filename, 'w') as f:
                    json.dump(response, f, sort_keys=True, indent=4, separators=(',', ': '))
            except:
                status = 'Connection failed'

            print "\t%s"%(status)
