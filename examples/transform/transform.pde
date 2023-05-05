void setup() {
  // Prepare
  size(500, 500);

  // Position of UC Berkeley
  float pointLongitude = -122.262938; 
  float pointLatitude = 37.873139;

  // Center the map on San Francisco and place in middle of sketch
  float centerLongitude = -122.418343;
  float centerLatitude = 37.761842;
  float centerX = 250;
  float centerY = 250;
  float mapScale = 100;

  // Use the tool
  GeoPoint point = new GeoPoint(pointLongitude, pointLatitude);
  GeoTransformation transformation = new GeoTransformation(
    new GeoPoint(centerLongitude, centerLatitude),
    new PVector(centerX, centerY),
    mapScale
  );

  // Draw
  float xPosition = point.getX(transformation);
  float yPosition = point.getY(transformation);
  println(xPosition, yPosition);
  noStroke();
  fill(#333333);
  ellipse(xPosition, yPosition, 10, 10);

  // Save
  save("transform.png");
}

void draw() {
  exit();
}
