/**
 * Some simple pieces of code for representing a map view transformation.
 *
 * <p>
 * Some simple pieces of code for geospatial visualizations in Processing that
 * allow manipulation of a web mercator projection by modifying the pan and
 * zoom to be applied. Short of a full library, this snippet helps jumpstart
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
 * A transformation to use in projecting a GeoPoint with a pan and zoom.
 *
 * <p>
 * A record of a desired transformation to use in projecting a GeoPoint with a
 * pan and zoom such that this record can be passed to a GeoPoint when
 * requesting its pixel-space position.
 * </p>
 */
public class GeoTransformation {
  
  private final GeoPoint geoOffset;
  private final PixelOffset pixelOffset;
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
  public GeoTransformation(GeoPoint newGeoOffset, PixelOffset newPixelOffset,
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
  public PixelOffset getPixelOffset() {
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