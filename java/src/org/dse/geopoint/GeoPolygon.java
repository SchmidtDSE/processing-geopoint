/**
 * Some simple pieces of code for geospatial polygons in Processing.
 *
 * <p>
 * Some simple pieces of code for geospatial visualizations in Processing that
 * use a web mercator projection for polygons. Short of a full library, this
 * snippet helps jumpstart Processing developers' efforts in working with
 * geospatial data.
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

import java.util.List;


/**
 * A collection of GeoPoints which can be drawn in a group as a polygon.
 */
public class GeoPolygon {

  private final List<GeoPoint> points;

  /**
   * Interface for how a point should be drawn in a sketch.
   */
  public interface DrawStrategy {

    /**
     * Draw a projected point.
     * 
     * @param x The x coordinate of the current point.
     * @param y The y coordinate of the current point.
     */
    public void drawPoint(float x, float y);

  }
  
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
   * 
   * @param strategy Strategy with which to draw this point.
   */
  public void draw(DrawStrategy strategy) {
    for (GeoPoint point : getPoints()) {
      strategy.drawPoint(point.getX(), point.getY());
    }
  }
  
  /**
   * Draw this polygon with a transformation applied.
   *
   * @param strategy Strategy with which to draw this point.
   * @param transformation The pan / zoom to be applied when drawing.
   */
  public void draw(DrawStrategy strategy, GeoTransformation transformation) {
    for (GeoPoint point : getPoints()) {
      strategy.drawPoint(
        point.getX(transformation),
        point.getY(transformation)
      );
    }
  }
  
}