/**
 * Some simple pieces of code for projecting points.
 *
 * <p>
 * Some simple pieces of code for geospatial visualizations in Processing that
 * use a web mercator projection to project points from lat / lng to x / y
 * and visa-versa. Short of a full library, this snippet helps jumpstart
 * Processing developers' efforts in working with geospatial data.
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

package org.dse.geopoint;


/**
 * A latitude / longitude point that an be converted to x / y coordinates.
 */
public class GeoPoint {
  
  private final static double RADIUS_MAJOR = 6378137.0;
  private final static double RADIUS_MINOR = 6356752.3142;
  private final static double BASE_SCALE = 0.0001;

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
    float geoOffsetX = transformation.getGeoOffset().getX();
    float pixelOffsetX = transformation.getPixelOffset().getX();
    float scale = transformation.getScale();
    double result = (getX() - geoOffsetX) * scale + pixelOffsetX;
    return (float) result;
  }
  
  /**
   * Get the vertical location of this point in pixel space.
   *
   * @param transformation The transformation to apply (pan and zoom).
   * @return The y position of this point after having panned and zoomed.
   */
  public float getY(GeoTransformation transformation) {
    float geoOffsetY = transformation.getGeoOffset().getY();
    float pixelOffsetY = transformation.getPixelOffset().getY();
    float scale = transformation.getScale();
    double result = (getY() - geoOffsetY) * scale + pixelOffsetY;
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
    return -1 * Math.log(Math.tan(
        Math.PI / 4 + Math.toRadians(latitude) / 2
    )) * RADIUS_MAJOR;
  }
  
}
