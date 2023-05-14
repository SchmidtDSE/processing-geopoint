import org.dse.geopoint.*;

void setup() {
  // Prepare
  size(500, 500);
  background(#F0F0FF);

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
    new PixelOffset(centerX, centerY),
    mapScale
  );

  // Draw
  stroke(#444444);
  fill(#333333);
  beginShape();
  polygon.draw((x, y) -> vertex(x, y), transformation);
  endShape();

  save("geojson.png");
}

void draw() {
  exit();
}