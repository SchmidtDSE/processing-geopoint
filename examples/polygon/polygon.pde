void setup() {
  // Prepare
  size(500, 500);

  // Center the map on San Francisco and place in middle of sketch
  float centerLongitude = -122.418343;
  float centerLatitude = 37.761842;
  float centerX = 250;
  float centerY = 250;
  float mapScale = 100;

  // Use the tool
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

  // Draw
  fill(#333333);
  noStroke();
  polygon.draw(transformation);
  save("polygon.png");
}


void draw() {
  exit();
}
