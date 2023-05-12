import org.dse.geopoint.*;

void setup() {
  // Prepare
  size(500, 500);
  background(#F0F0F0);

  // Center the map on San Francisco and place in middle of sketch
  float centerLongitude = -122.418343;
  float centerLatitude = 37.761842;
  float centerX = 250;
  float centerY = 250;
  float mapScale = 10;

  // Use the tool
  ArrayList<GeoPoint> points = new ArrayList<>();
  points.add(new GeoPoint(-122, 38));
  points.add(new GeoPoint(-121, 38));
  points.add(new GeoPoint(-121, 37));
  points.add(new GeoPoint(-122, 37));

  GeoPolygon polygon = new GeoPolygon(points);

  GeoTransformation transformation = new GeoTransformation(
    new GeoPoint(centerLongitude, centerLatitude),
    new PixelOffset(centerX, centerY),
    mapScale
  );

  // Draw
  fill(#333333);
  noStroke();
  beginShape();
  polygon.draw((x, y) -> vertex(x, y), transformation);
  endShape();
  save("polygon.png");
}


void draw() {
  exit();
}