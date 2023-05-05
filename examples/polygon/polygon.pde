# Prepare
size(500, 500);

# Center the map on San Francisco and place in middle of sketch
float centerLongitude = -122.418343;
float centerLatitude = 37.761842;
float centerX = 250;
float centerY = 250;
float mapScale = 1000;

# Use the tool
ArrayList<GeoPoint> points = new ArrayList<>();
points.add(new GeoPoint(-122, 38));
points.add(new GeoPoint(-121, 38));
points.add(new GeoPoint(-121, 37));
points.add(new GeoPoint(-122, 37));

GeoPolygon polygon = new GeoPolygon(points);

GeoTransformation transformation = new GeoTransformation(
  new GeoPoint(centerLongitude, centerLatitude),
  new PVector(centerX, centerY),
  mapScale
);

# Draw
fill(#A0A0A0);
noStroke();
polygon.draw(transformation);