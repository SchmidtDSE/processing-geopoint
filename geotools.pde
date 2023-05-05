/**
 * Some simple pieces of code for geospatial visualizations in Processing.
 *
 * <p>
 * Some simple pieces of code for geospatial visualizations in Processing that
 * use a web mercator projection. Short of a full library, this snippet helps
 * jumpstart Processing developers' efforts in working with geospatial data.
 * </p>
 *
 * <p>
 * (c) 2023 Regents of University of California / The Eric and Wendy Schmidt
 * Center for Data Science and the Environment at UC Berkeley. This file is
 * part of afscgap released under the BSD 3-Clause License. See LICENSE.md.
 * </p>
 *
 * @license BSD
 */

import java.util.List;


/**
 * A latitude / longitude point that an be converted to x / y coordinates.
 */
class GeoPoint {
  
  private final static double RADIUS_MAJOR = 6378137.0;
  private final static double RADIUS_MINOR = 6356752.3142;
  private final static double BASE_SCALE = 0.00001;

  private final float longitude;
  private final float latitude;
  private final double x;
  private final double y;
  
  /**
   * Create a new point in geospatial space.
   *
   * @param newLongitude The longitude (horizontal component) of the point.
   * @param newLatitude The latitude (vertical component) of the point.
   */
  public GeoPoint(float newLongitude, float newLatitude) {
    longitude = newLongitude;
    latitude = newLatitude;
    x = longitudeToX(longitude);
    y = latitudeToY(latitude);
  }
  
  /**
   * Get the horizontal location of this point in pixel space.
   *
   * @return The x position of this point without transformation.
   */
  public float getX() {
    double xScaled = x * BASE_SCALE;
    return (float) xScaled;
  }
  
  /**
   * Get the vertical location of this point in pixel space.
   *
   * @return The y position of this point without transformation.
   */
  public float getY() {
    double yScaled = y * BASE_SCALE;
    return (float) yScaled;
  }
  
  /**
   * Get the horizontal location of this point in pixel space.
   *
   * @param transformation The transformation to apply (pan and zoom).
   * @return The x position of this point after having panned and zoomed.
   */
  public float getX(GeoTransformation transformation) {
    float pixelX = transformation.getGeoOffset().getX();
    float offsetX = pixelX + transformation.getPixelOffset().x;
    float scale = transformation.getScale();
    double result = (x - offsetX) * scale * BASE_SCALE;
    return (float) result;
  }
  
  /**
   * Get the vertical location of this point in pixel space.
   *
   * @param transformation The transformation to apply (pan and zoom).
   * @return The y position of this point after having panned and zoomed.
   */
  public float getY(GeoTransformation transformation) {
    float pixelY = transformation.getGeoOffset().getY();
    float offsetY = pixelY + transformation.getPixelOffset().y;
    float scale = transformation.getScale();
    double result = (y - offsetY) * scale * BASE_SCALE;
    return (float) result;
  }
  
  /**
   * Get the horizontal position of this point in geo-space.
   *
   * @return The x coordinate (longitude) of this point in geographic space.
   */
  public float getLongitude() {
    return longitude;
  }
  
  /**
   * Get the vertical position of this point in geo-space.
   *
   * @return The y coordinate (latitude) of this point in geographic space.
   */
  public float getLatitude() {
    return latitude;
  }
  
  /**
   * Convert a longitude to an x coordinate.
   *
   * @author Eugen Paraschiv
   * @license MIT
   * @param longitude The longitude to convert to a horizontal coordinate.
   * @return Un-transformed x coordinate.
   */
  private double longitudeToX(float longitude) {
    return Math.toRadians(longitude) * RADIUS_MAJOR;
  }
  
  /**
   * Convert a latitude to an x coordinate.
   *
   * @author Eugen Paraschiv
   * @license MIT
   * @param latitude The latitude to convert to a vertical coordinate.
   * @return Un-transformed y coordinate.
   */
  private double latitudeToY(float latitude) {
    return Math.log(Math.tan(
        Math.PI / 4 + Math.toRadians(latitude) / 2
    )) * RADIUS_MAJOR;
  }
  
}


/**
 * A transformation to use in projecting a GeoPoint with a pan and zoom.
 *
 * <p>
 * A record of a desired transformation to use in projecting a GeoPoint with a
 * pan and zoom such that this record can be passed to a GeoPoint when
 * requesting its pixel-space position.
 * </p>
 */
class GeoTransformation {
  
  private final GeoPoint geoOffset;
  private final PVector pixelOffset;
  private final float scale;
  
  /**
   * Create a new transformation.
   *
   * @param newGeoOffset Where in geo-space (latitude and longitude) the
   *    display should be centered.
   * @param newPixelOffset Where in pixel space (x and y coordinates) the
   *    display should be centered.
   * @param newScale The zoom level that should be used when projecting a
   *    GeoPoint.
   */
  public GeoTransformation(GeoPoint newGeoOffset, PVector newPixelOffset,
    float newScale) {
    geoOffset = newGeoOffset;
    pixelOffset = newPixelOffset;
    scale = newScale;
  }
  
  /**
   * Get the center of the display in geo-space.
   *
   * @return Geospatical coordinates that should be the center of the
   *    projection.
   */
  public GeoPoint getGeoOffset() {
    return geoOffset;
  }
  
  /**
   * Get the center of the display in pixel-space.
   *
   * @return Pixel coordinates that should be the center of the projection.
   */
  public PVector getPixelOffset() {
    return pixelOffset;
  }
  
  /**
   * Get the scaling factor for this transformation.
   *
   * @return Scale or zoom factor.
   */
  public float getScale() {
    return scale;
  }
  
}


/**
 * A collection of GeoPoints which can be drawn in a group as a polygon.
 */
class GeoPolygon {

  private final List<GeoPoint> points;
  
  /**
   * Create a new polygon.
   *
   * @param newPoints The points of the polygon in order that they should
   *    be drawn.
   */
  public GeoPolygon(List<GeoPoint> newPoints) {
    points = newPoints;
  }
  
  /**
   * Get the points that make up this polygon.
   *
   * @return Iterable over the points in this polygon in drawing order.
   */
  public Iterable<GeoPoint> getPoints() {
    return points;
  }
  
  /**
   * Draw this polygon without panning or zooming.
   */
  public void draw() {
    beginShape();
    for (GeoPoint point : getPoints()) {
      vertex(point.getX(), point.getY());
    }
    endShape();
  }
  
  /**
   * Draw this polygon with a transformation applied.
   *
   * @param transformation The pan / zoom to be applied when drawing.
   */
  public void draw(GeoTransformation transformation) {
    beginShape();
    for (GeoPoint point : getPoints()) {
      vertex(point.getX(transformation), point.getY(transformation));
    }
    endShape();
  }
  
}