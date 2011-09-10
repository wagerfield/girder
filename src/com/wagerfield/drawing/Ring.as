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
	import flash.display.Sprite;



	/**
	 * @author Matthew Wagerfield
	 */
	public class Ring
	{
		/**
		 * Draws a ring within the graphics of a specified sprite using the Polygon Class.
		 * 
		 * @param sprite Sprite in which the ring is to be drawn on.
		 * @param x Central x position of the ring.
		 * @param y Central y position of the ring.
		 * @param r1 Inner radius of the ring.
		 * @param r2 Outer radius of the ring.
		 * @param startAngle Initial angle of the first point of the ring. Default is 0. 
		 * @param endAngle End angle of the final point of the ring. Default is 360. 
		 * @param curve Specifies whether or not to use the curveTo or lineTo drawing method.
		 * @param curveRatio Specifies the curvature of the polygon segments . Default is 1.
		 * @param sides Number of sides that make up the ring. Default is 30. 
		 */
		public static function draw(sprite:Sprite, x:Number, y:Number, r1:Number, r2:Number, startAngle:Number = 0, endAngle:Number = 360, curve:Boolean = true, curveRatio:Number = 1, sides:uint = 30):void
		{
			if (Math.abs(endAngle - startAngle) >= 360)
			{
				Polygon.draw(sprite, x, y, r1, sides, curve, curveRatio, startAngle, endAngle, false, true);
				Polygon.draw(sprite, x, y, r2, sides, curve, curveRatio, endAngle, startAngle, false, true);
			}
			else
			{
				Polygon.draw(sprite, x, y, r1, sides, curve, curveRatio, startAngle, endAngle, false, true);
				Polygon.draw(sprite, x, y, r2, sides, curve, curveRatio, endAngle, startAngle, true, false);
			}
		}
	}
}