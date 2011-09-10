/**
 * Copyright (C) 2011 by Matthew Wagerfield
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.wagerfield.drawing
{
	import com.wagerfield.utils.MathHelper;

	import flash.display.Sprite;



	/**
	 * @author Matthew Wagerfield
	 */
	public class Capsule
	{
		/**
		 * Draws a ring within the graphics of a specified sprite using the Polygon Class.
		 * 
		 * @param sprite Sprite in which the ring is to be drawn on.
		 * @param x Central x position of the first semicircle.
		 * @param y Central y position of the first semicircle.
		 * @param length The distance between the two semicircles.
		 * @param radius The radius of the semicircle.
		 * @param angle The angle of projection for the second semicircle.
		 */
		public static function draw(sprite:Sprite, x:Number, y:Number, length:Number, radius:Number, angle:Number):void
		{
			var SIDES:uint = 12;

			var x1:Number = x;
			var y1:Number = y;
			var x2:Number = x + length * Math.cos(MathHelper.toRadians(angle));
			var y2:Number = y + length * Math.sin(MathHelper.toRadians(angle));

			Polygon.draw(sprite, x1, y1, radius, SIDES * 0.5, true, 1, angle - 180, angle - 90, true, false);
			Polygon.draw(sprite, x2, y2, radius, SIDES * 1.0, true, 1, angle - 90, angle + 90, true, false);
			Polygon.draw(sprite, x1, y1, radius, SIDES * 0.5, true, 1, angle - 270, angle - 180, true, false);
		}
	}
}