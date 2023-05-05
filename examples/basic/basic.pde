# Prepare
size(500, 500);

# Position of UC Berkeley
float longitude = -122.262938; 
float latitude = 37.873139;

# Use the tool
GeoPoint point = new GeoPoint(longitude, latitude);

# Draw
float xPosition = point.getX();
float yPosition = point.getY();
ellipse(xPosition, yPosition, 10, 10);