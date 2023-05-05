import csv
import json
import sys

USAGE_STR = 'python polygon_to_csv.py [input geojson] [output csv]'
NUM_ARGS = 2


def main():
    if len(sys.argv) != NUM_ARGS + 1:
        print(USAGE_STR)
        return

    source_loc = sys.argv[1]
    dest_loc = sys.argv[2]

    with open(source_loc) as f:
        source = json.load(f)

    assert len(source['features']) == 1
    feature = source['features'][0]
    geometry = feature['geometry']

    assert geometry['type'] == 'Polygon'
    dicts = map(
        lambda x: {'longitude': x[0], 'latitude': x[1]},
        geometry['coordinates'][0]
    )

    with open(dest_loc, 'w') as f:
        writer = csv.DictWriter(f, fieldnames=['longitude', 'latitude'])
        writer.writeheader()
        writer.writerows(dicts)


if __name__ == '__main__':
    main()