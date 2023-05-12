Processing Geopoint
===============================================================================
Some pieces of code that have been useful for geospatial visualization in [Processing](https://processing.org) under a friendly license as a micro-library.

<br>

## Purpose
Need to convert longitude / latitude to x / y coordinates in your Processing sketches?

Not inteded to be a full library, this captures and formalizes some geospatial visualization code for Processing / Java we've often used internally during prototyping within our data visualization studio. Using the [web mercator](https://en.wikipedia.org/wiki/Web_Mercator_projection) projection, it allows for quick prototyping by supporting:

 - The construction of points that can be projected between "geo-space" (latitude / longitude coordinates on the Earth) and "pixel-space" (x / y coordinates on the screen).
 - Shortcuts for common map transformations like panning and zooming.
 - Drawing geospatial polygons (using points defined in geo-space but rendered in pixel space).

Finally, this can be used to render geojson polygons with the addition of a little Python.

<br>

### Limitations / relation to other efforts
This is not meant to be a full library like [Unfolding](http://unfoldingmaps.org/) but big hat tip to [contributors working to get it to the latest Processing](https://github.com/tillnagel/unfolding/pull/119). This is not meant to achieve that level of functionality and is more of a small bit of code to include if users wish to keep all of the geospatial transformations in sketch-level code for whatever reason.

Separately, we wish to highlight that Processing developers may also consider use of [Java Geotools](https://geotools.org/) which can be used in sketches. In contrast, this is meant to be a much smaller interface simply for doing quick projections of points and geometries.

<br>

## Installation
Simply add [our jar](https://schmidtdse.github.io/processing-geopoint/geopoint.jar) to your sketch by dragging and dropping onto your sketch or putting it in the `code` folder. Additional documentation available in our JavaDoc.

<br>

## Usage
This piece of code offers multiple modalities of usage.

### Convert lat / lon to x / y
The simpliest operation is converting a point in geo-space to pixel-space like in this example which draws a dot for UC Berkeley:

```java
import org.dse.geopoint.*;

void setup() {
  // Prepare
  size(500, 500);
  background(#F0F0F0);
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
```

![Circle drawn by latitude and longitude](https://schmidtdse.github.io/processing-geopoint/basic.png "Result of basic sketch")

The order of providing parameters is horizontal position (longitude) followed by vertical position (latitude). Note that a large transformation was required because, by default, the drawing centers at 0 latitude and 0 longitude.


### Scale and transform
It is typically necessary to scale and transform like in this example which centers the map on San Francisco and zooms in.

```java
import org.dse.geopoint.*;

void setup() {
  // Prepare
  size(500, 500);
  background(#F0F0F0);

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
    new PixelOffset(centerX, centerY),
    mapScale
  );

  // Get position
  // Note there is also longitudeToX and latitudeToY for reverse projection.
  float xPosition = point.getX(transformation);
  float yPosition = point.getY(transformation);

  // Draw
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

![Circle drawn by latitude and longitude with scale / transform](https://schmidtdse.github.io/processing-geopoint/transform.png "Result of scale and transform sketch")

Note that the map has a base scale of 1e-4 and scale is multiplied by that base scale.

### Draw a polygon
Sometimes it is helpful to take a polygon defined in geo-space and draw it in pixel-space. This can be helpful for bounding boxes, for example.

```java
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
```

![Square drawn by latitude and longitude points](https://schmidtdse.github.io/processing-geopoint/polygon.png "Result of polygon sketch")

Note that this will build a polygon by calling `vertex` for each point between `beginShape` and `endShape`. For more details, see the [Processing documenation on shapes](https://processing.org/reference/vertex_.html).

### Draw a geojson
Need to draw a polygon inside a GeoJson? There is a small Python script to convert a GeoJson to a CSV of points (you'll need [Python 3](https://docs.python-guide.org/starting/installation/)).

```bash
python polygon_to_csv.py ./san_francisco.geojson ./san_francisco.csv
```

One can then use native CSV functionality in Processing to render the shape:

```java
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
  stroke(#C0C0C0);
  fill(#334433);
  beginShape();
  polygon.draw((x, y) -> vertex(x, y), transformation);
  endShape();

  save("geojson.png");
}

void draw() {
  exit();
}
```

![Map of San Francisco Bay Area](https://schmidtdse.github.io/processing-geopoint/geojson.png "Result of geojson sketch")

See the python script for more details.

<br>

Local Development Environment
-------------------------------------------------------------------------------
This project's examples simply require installation of [Processing 4](https://processing.org) though use of the `polygon_to_csv.py` script requires installation of [Python 3](https://docs.python-guide.org/starting/installation/). Developers of this micro-library itself will need an [OpenJDK](https://adoptium.net/).

<br>

Development Standards
-------------------------------------------------------------------------------
Where reasonable, please adhere to 2 spaces tabs and otherwise follow the [Java style standard conventions](https://google.github.io/styleguide/javaguide.html). All methods and classes should have [Javadoc](https://www.baeldung.com/javadoc). For Python code, please follow the [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html) where reasonable. Code should strive for 80% coverage in terms of being exercised by the automated checks in CI / CD.

<br>

Deployment
-------------------------------------------------------------------------------
This work is provided as a jar buildable via `bash build.sh`. However, note that continuous integration will run automated checks and we ask that contributors ensure their work passes those checks. Note that this also offers an open source example of using Python from inside Github Actions.

<br>

Contributing
-------------------------------------------------------------------------------
Pull requests and bug reports welcome. We do not have a formalized template but please be kind. Open source is often a labor of love done outside work hours / pay. We may decline to fulfill a bug or merge a PR in which case we politely recommend a fork.

<br>

License and open source
-------------------------------------------------------------------------------
Released under the [BSD license](https://opensource.org/license/BSD-3-clause/). See `LICENSE.md` for more details. Copyright Regents of University of California. [Sam Pottinger](https://dse.berkeley.edu/people/sam-pottinger) is the primary contact. Note that this adapts code from [Eugen's Tutorials](https://github.com/eugenp/tutorials) by Eugen Paraschiv which are released under the [MIT License](https://github.com/eugenp/tutorials/blob/master/LICENSE). Documentation uses [pandoc](https://pandoc.org/) and Jez's [pandoc-markdown-css-theme](https://jez.io/pandoc-markdown-css-theme/).
