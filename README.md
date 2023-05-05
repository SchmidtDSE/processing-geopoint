Processing Geotools
===============================================================================
Some pieces of code that have been useful for geospatial visualization in [Processing](https://processing.org) under a friendly license.

<br>

Purpose
-------------------------------------------------------------------------------
Need to convert longitude / latitude to x / y coordinates in your Processing sketches? Not inteded to be a full library, this captures and formalizes some web mercator code for Processing / Java commonly used internally during prototyping within our data visualization studio. It allows for the construction of points that can be projected between "geo-space" (latitude / longitude coordinates on the Earth) and "pixel-space" (x / y coordinates on the screen). It also offers shortcuts for transformations like panning and zooming as well as drawing polygons using points defined in geo-space but rendered in pixel space. This can be used to render geojson polygons with the addition of a little Python script.

<br>

Installation
-------------------------------------------------------------------------------
This repository simply open sources commonly used code internally and this is not a formalized Processing library. Simply add the `geotools.pde` file to your sketch folder.

<br>

Usage
-------------------------------------------------------------------------------
This piece of code offers multiple modalities of usage.

#### Convert lat / lon to x / y
The simpliest operation is converting a point in geo-space to pixel-space like in this example which draws a dot for UC Berkeley:

```
void setup() {
  // Prepare
  size(500, 500);
  translate(-2000, 500);

  // Position of UC Berkeley
  float longitude = -122.262938; 
  float latitude = 37.873139;

  // Use the tool
  GeoPoint point = new GeoPoint(longitude, latitude);

  // Draw
  float xPosition = point.getX();
  float yPosition = point.getY();
  noStroke();
  fill(#333333);
  println(xPosition, yPosition);
  ellipse(xPosition, yPosition, 10, 10);

  // Save
  save("basic.png");
}

void draw() {
  exit();
}
```

Note that the order of providing parameters is horizontal position (longitude) followed by vertical position (latitude).


#### Scale and transform
It is typically necessary to scale and transform like in this example which centers the map on San Francisco and zooms in.

```
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
  float mapScale = 10;

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
```

Note that the map automatically has a map scale of 1e-5 applied by default.

#### Draw a polygon
Sometimes it is helpful to draw a polygon defined in geo-space in pixel-space. This can be helpful for bounding boxes, for example.

```
void setup() {
  // Prepare
  size(500, 500);

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
```

Note that `draw` will build a polygon by calling `vertex` between `beginShape` and `endShape`. For more details, see the [Processing documenation on shapes]().

#### Draw a geojson
Need to draw a polygon inside a GeoJson? There is a small Python script to convert to a CSV of points (you'll need [Python 3]()).

```
python polygon_to_csv.py ./san_francisco.geojson ./san_francisco.csv
```

One can then use native CSV functionality in Processing to render the shape:

```
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
```

<br>

Local Development Environment
-------------------------------------------------------------------------------
This project simply requires installation of [Processing 4]() though use of the `polygon_to_csv.py` script requires installation of [Python 3]().

<br>

Development Standards
-------------------------------------------------------------------------------
Please adhere to 2 spaces tabs and otherwise follow the [Java style standard conventions](). All methods and classes should have [Javadoc](). For Python code, please follow the [Google Python Style Guide]() where possible. Code should strive for 80% test coverage. See the `_test` files for more details.

<br>

Deployment
-------------------------------------------------------------------------------
This work is provided as source files. However, note that continuous integration will run automated checks and we ask that contributors ensure their work passes those checks. Note that this also offers an open source example of using Python from inside Github Actions.

<br>

Contributing
-------------------------------------------------------------------------------
Pull requests and bug reports welcome. We do not have a formalized template but please be kind. Open source is often a labor of love done outside work hours / pay. We may decline to fulfill a bug or merge a PR in which case we politely recommend a fork.

<br>

License and open source
-------------------------------------------------------------------------------
Released under the [BSD license](https://opensource.org/license/BSD-3-clause/). See `LICENSE.md` for more details. Copyright Regents of University of California. [Sam Pottinger](https://dse.berkeley.edu/people/sam-pottinger) is the primary contact. Note that this adapts code from [Eugen's Tutorials](https://github.com/eugenp/tutorials) by Eugen Paraschiv which are released under the [MIT License](https://github.com/eugenp/tutorials/blob/master/LICENSE).
