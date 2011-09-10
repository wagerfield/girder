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
	import flash.geom.Point;



	/**
	 * @author Matthew Wagerfield
	 */
	public class Polygon
	{
		private static var _sprite:Sprite;
		private static var _x:Number;
		private static var _y:Number;
		private static var _radius:Number;
		private static var _sides:Number;
		private static var _startAngle:Number;
		private static var _endAngle:Number;
		private static var _curve:Boolean;
		private static var _curveRatio:Number;
		private static var _anchor:Point;
		private static var _control:Point;
		private static var _segment:Number;
		private static var _cap:Boolean;
		private static var _center:Boolean;



		/**
		 * Draws a polygon within the graphics of a specified sprite.
		 * 
		 * @param sprite Sprite in which the polygon is to be drawn on.
		 * @param x Central x position of the polygon.
		 * @param y Central y position of the polygon.
		 * @param radius Radius of the polygon.
		 * @param sides Number of sides of the polygon. Minimum of 3 sides to make a triangle. 
		 * @param curve Specifies whether or not to use the curveTo or lineTo drawing method.
		 * @param curveRatio Amount of curvature applied to each segment. Default is 0. 1 creates perfect tangents between segments.
		 * @param startAngle Initial angle of the first point of the polygon. Default is 0. 
		 * @param endAngle End angle of the final point of the polygon. Default is 360. 
		 * @param cap Cap the ploygon loop. Default is false. 
		 * @param center Starts and ends the drawing loop at the center of the polygon (specified by x and y). Default is true. 
		 */
		public static function draw(sprite:Sprite, x:Number, y:Number, radius:Number, sides:uint, curve:Boolean = false, curveRatio:Number = 0, startAngle:Number = 0, endAngle:Number = 360, cap:Boolean = false, center:Boolean = true):void
		{
			_sprite = sprite;
			_x = x;
			_y = y;
			_radius = radius;
			_sides = sides < 3 ? 3 : sides;
			_curve = curve;
			_curveRatio = curveRatio;
			_startAngle = startAngle;
			_endAngle = endAngle;
			_cap = cap;
			_center = center;
			_anchor = calculateAnchor(_startAngle);
			_segment = (_endAngle - _startAngle) / _sides;

			if (_center) _sprite.graphics.moveTo(_x, _y);
			if (_cap) _sprite.graphics.lineTo(_anchor.x, _anchor.y);
			else _sprite.graphics.moveTo(_anchor.x, _anchor.y);

			for (var i:int = 1; i <= sides; i++) drawLine(i);

			if (_cap && _center) _sprite.graphics.lineTo(_x, _y);
		}
		private static function drawLine(index:int):void
		{
			var degrees:Number = _startAngle + _segment * index;
			_anchor = calculateAnchor(degrees);
			_control = calculateControl(degrees);

			if (_curve)
			{
				_sprite.graphics.curveTo(_control.x, _control.y, _anchor.x, _anchor.y);
			}
			else
			{
				_sprite.graphics.lineTo(_control.x, _control.y);
				_sprite.graphics.lineTo(_anchor.x, _anchor.y);
			}
		}
		private static function calculateAnchor(degrees:Number):Point
		{
			return calculatePoint(_radius, degrees);
		}
		private static function calculateControl(degrees:Number):Point
		{
			var angle:Number = _segment / 2;
			var halfSide:Number = _radius * Math.sin(MathHelper.toRadians(angle));
			var inner:Number = _radius * Math.cos(MathHelper.toRadians(angle));
			var outer:Number = halfSide * Math.tan(MathHelper.toRadians(angle));
			var radius:Number = inner + outer * _curveRatio;

			return calculatePoint(radius, degrees - angle);
		}
		private static function calculatePoint(radius:Number, degrees:Number):Point
		{
			var point:Point = new Point();

			point.x = _x + radius * Math.cos(MathHelper.toRadians(degrees));
			point.y = _y + radius * Math.sin(MathHelper.toRadians(degrees));

			return point;
		}
	}
}