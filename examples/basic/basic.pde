import org.dse.geopoint.*;

void setup() {
  // Prepare
  size(500, 500);
  background(#FFFFFF);
  translate(1500, -400);

  // Position of UC Berkeley
  float longitude = -122.262938; 
  float latitude = 37.873139;

  // Use the tool
  GeoPoint point = new GeoPoint(longitude, latitude);

  // Draw
  float xPosition = point.getX(); // Note there is also longitudeToX
  float yPosition = point.getY(); // Note there is also latitudeToY
  noStroke();
  fill(#333333);
  ellipse(xPosition, yPosition, 100, 100);

  // Save
  save("basic.png");
}

void draw() {
  exit();
}