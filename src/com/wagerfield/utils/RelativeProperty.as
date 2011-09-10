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

package com.wagerfield.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Point;



	/**
	 * @author Matthew Wagerfield
	 */
	public class RelativeProperty
	{
		/**
		 * Compares the coordinates of 2 DisplayObjects relative to the Stage and returns the x and y difference as a Point.
		 * 
		 * @param displayObjectA The first DisplayObject.
		 * @param displayObjectB The second DisplayObject. If this is null, the position of DisplayObject A is returned relative to the Stage.
		 */
		public static function position(displayObjectA:DisplayObject, displayObjectB:DisplayObject = null):Point
		{
			var positionA:Point = new Point();
			var positionB:Point = new Point();

			do
			{
				positionA.x += displayObjectA.x;
				positionA.y += displayObjectA.y;
			}
			while ((displayObjectA = displayObjectA.parent) != null);

			if (displayObjectB != null)
			{
				do
				{
					positionB.x += displayObjectB.x;
					positionB.y += displayObjectB.y;
				}
				while ((displayObjectB = displayObjectB.parent) != null);
			}
			return positionA.add(positionB);
		}
		/**
		 * Compares the scales of 2 DisplayObjects relative to the Stage and returns the scaleX and scaleY difference as a Point.
		 * 
		 * @param displayObjectA The first DisplayObject.
		 * @param displayObjectB The second DisplayObject. If this is null, the scale of DisplayObject A is returned relative to the Stage.
		 */
		public static function scale(displayObjectA:DisplayObject, displayObjectB:DisplayObject = null):Point
		{
			var scaleA:Point = new Point(1, 1);
			var scaleB:Point = new Point(1, 1);

			do
			{				
				scaleA.x *= displayObjectA.scaleX;
				scaleA.y *= displayObjectA.scaleY;
			}
			while ((displayObjectA = displayObjectA.parent) != null);

			if (displayObjectB != null)
			{
				do
				{
					scaleB.x *= displayObjectA.scaleX;
					scaleB.y *= displayObjectB.scaleY;
				}
				while ((displayObjectB = displayObjectB.parent) != null);
			}
			return scaleA.add(scaleB).subtract(new Point(1, 1));
		}
	}
}