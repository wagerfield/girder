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
	/**
	 * @author Matthew Wagerfield
	 */
	public class MathHelper
	{
		/**
		 * Converts degrees to radians.
		 * 
		 * @param degrees Angle in degrees.
		 */
		public static function toRadians(degrees:Number):Number
		{
			return degrees * Math.PI / 180;
		}
		/**
		 * Converts radians to degrees.
		 * 
		 * @param radians Angle in radians.
		 */
		public static function toDegrees(radians:Number):Number
		{
			return radians * 180 / Math.PI;
		}
		/**
		 * Returns a Boolean value Rounds.
		 * 
		 * @param current Current value.
		 * @param target Target value to compare the Current value with.
		 * @param tolerance Tolerance to clamp the difference between the Current value and the Target value.
		 */
		public static function round(current:Number, target:Number, tolerance:Number):Boolean
		{
			return Math.abs(Math.abs(current) - Math.abs(target)) < tolerance ? true : false;
		}
		/**
		 * Converts a formatted HH:MM:SS String value to seconds.
		 * 
		 * @param time Formatted time in HH:MM:SS.
		 */
		public static function timeToSecs(time:String):Number
		{
			var seconds:Number = 0;
			var valueArr:Array = time.split(/:/);
			var power:uint = valueArr.length - 1;

			for (var i:uint = 0; i < valueArr.length; i++)
			{
				seconds += Number(valueArr[i]) * Math.pow(60, power);

				power--;
			}
			return seconds;
		}
		/**
		 * Converts seconds to a formatted HH:MM:SS String value.
		 * 
		 * @param number Number to convert.
		 * @param columns The number of integers to fix the input Number to.
		 * @param decimals The number of decimal places to fix the input Number to.
		 */
		public static function fixedNumber(number:Number, integers:uint, decimals:uint = 0):String
		{
			var numString:String = String(decimals > 0 ? number.toFixed(decimals) : uint(number));
			var splitString:String = numString.replace(".", "-");
			var splitArr:Array = splitString.split(/-/);
			var intCount:uint = String(splitArr[0]).length;
			var fillCount:uint = integers > intCount ? integers - intCount : 0;
			var fixedString:String = "";

			for (var i:uint = 0; i < fillCount; i++)
			{
				fixedString = fixedString.concat("0");
			}
			return fixedString.concat(numString);
		}
		/**
		 * Returns whether a Number is ODD or EVEN.
		 * 
		 * @param number Number to check.
		 */
		public static function oddNumber(number:Number):Boolean
		{
			return Boolean(int(number) % 2);
		}
		/**
		 * Returns a random Number that is generated between a minimum and a maximum value.
		 * 
		 * @param minNumber Minimum value of the random Number.
		 * @param maxNumber Maximum value of the random Number.
		 */
		public static function randomNumber(minNumber:Number, maxNumber:Number):Number
		{
			return minNumber + Math.random() * (maxNumber - minNumber);
		}
	}
}