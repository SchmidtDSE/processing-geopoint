/**
 * Description of the pixel center of a map view for a GeoTransformation.
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
 * Structure describing where a map view should be centered in pixel space.
 */
public class PixelOffset {

  private final float x;
  private final float y;

  /**
   * Create a new record of where the map center should be drawn on screen.
   * 
   * @param newX The x coordinate at which the map view should be centered.
   * @param newY The y coordinate at which the map view should be centered.
   */
  public PixelOffset(float newX, float newY) {
    x = newX;
    y = newY;
  }

  /**
   * Get the horizontal central coordinate of the map view.
   * 
   * @return The x coordinate at which the map view should be centered.
   */
  public float getX() {
    return x;
  }

  /**
   * Get the vertical central coordinate of the map view.
   * 
   * @return The y coordinate at which the map view should be centered.
   */
  public float getY() {
    return y;
  }

}