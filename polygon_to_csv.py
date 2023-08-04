"""Script to convert a polygon from geojson to a list of points in CSV.

This script can be used on geojson files containing either a polygon feature or
a MultiPolygon. If multiple polygons are present, a column is added for polygon
number.

This script can be invoked by calling python polygon_to_csv.py.

(c) 2023 Regents of University of California / The Eric and Wendy Schmidt Center
for Data Science and the Environment at UC Berkeley.

This file is part of afscgap released under the BSD 3-Clause License. See
LICENSE.md.
"""
import csv
import json
import sys

USAGE_STR = 'python polygon_to_csv.py [input geojson] [output csv]'
NUM_ARGS = 2


def main():
    """Run the script."""
    if len(sys.argv) != NUM_ARGS + 1:
        print(USAGE_STR)
        return

    source_loc = sys.argv[1]
    dest_loc = sys.argv[2]

    with open(source_loc) as f:
        source = json.load(f)

    multi_features = len(source['features']) > 1
    i = 0

    with open(dest_loc, 'w') as f:
        writer = csv.DictWriter(f, fieldnames=['longitude', 'latitude', 'polygon'])
        writer.writeheader()
        
        for feature in source['features']:
            geometry = feature['geometry']

            if geometry['type'] == 'MultiPolygon':
                shapes = geometry['coordinates'][0]
                if len(shapes) != 1:
                    raise RuntimeException('MultiPolygon must have one polygon.')
                shape = shapes[0]
            elif geometry['type'] == 'Polygon':
                shape = geometry['coordinates'][0]
            else:
                raise RuntimeException('Only support for MultiPolygon and Polygon.')
            
            dicts = map(
                lambda x: {'longitude': x[0], 'latitude': x[1], 'polygon': i},
                shape
            )
            
            writer.writerows(dicts)

            i += 1


if __name__ == '__main__':
    main()
