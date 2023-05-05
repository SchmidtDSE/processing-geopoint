void setup() {
  // Prepare
  size(500, 500);
  background(#0000F0);

  // Center the map on San Francisco and place in middle of sketch
  float centerLongitude = -122.418343;
  float centerLatitude = 37.761842;
  float centerX = 250;
  float centerY = 250;
  float mapScale = 100;

  // Use the tool
  ArrayList<GeoPoint> points = new ArrayList<>();
  Table polygonTable = loadTable("bayarea.csv", "header");
  for (TableRow row : polygonTable.rows()) {
    float longitude = row.getFloat("longitude");
    float latitude = row.getFloat("latitude");
    points.add(new GeoPoint(longitude, latitude));
  }

  GeoPolygon polygon = new GeoPolygon(points);

  GeoTransformation transformation = new GeoTransformation(
    new GeoPoint(centerLongitude, centerLatitude),
    new PVector(centerX, centerY),
    mapScale
  );

  // Draw
  stroke(#333333);
  fill(#00A000);
  polygon.draw(transformation);

  save("geojson.png");
}

void draw() {
  exit();
}
