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

package com.wagerfield.display
{
	import flash.filters.ColorMatrixFilter;



	/**
	 * @author Matthew Wagerfield
	 */
	public class ColourFilters
	{
		/** Removes all colour channels and boosts the pinks and purples. */
		public static function purple():Array
		{
			var matrix:Array = new Array();
			var filter:Array = new Array();
			// red
			matrix = matrix.concat([1.5, 0.2, 0, 0, 0]);
			// green
			matrix = matrix.concat([0.9, 0.1, 0, 0, 0]);
			// blue
			matrix = matrix.concat([1, 0, 1, 0, 0]);
			// alpha
			matrix = matrix.concat([0, 0, 0, 1, 0]);

			filter.push(new ColorMatrixFilter(matrix));

			return filter;
		}
		/** Desaturates all colours of a Bitmap to leave a greyscale representation. */
		public static function greyScale():Array
		{
			var matrix:Array = new Array();
			var filter:Array = new Array();
			// red
			matrix = matrix.concat([0.3, 0.6, 0.1, 0, 0]);
			// green
			matrix = matrix.concat([0.3, 0.6, 0.1, 0, 0]);
			// blue
			matrix = matrix.concat([0.3, 0.6, 0.1, 0, 0]);
			// alpha
			matrix = matrix.concat([0, 0, 0, 1, 0]);

			filter.push(new ColorMatrixFilter(matrix));

			return filter;
		}
		/** Desaturates all colours of a Bitmap. */
		public static function desaturate():Array
		{
			var matrix:Array = new Array();
			var filter:Array = new Array();
			// red
			matrix = matrix.concat([0.6, 0.4, 0, 0, 0]);
			// green
			matrix = matrix.concat([0.4, 0.6, 0, 0, 0]);
			// blue
			matrix = matrix.concat([0.4, 0, 0.6, 0, 0]);
			// alpha
			matrix = matrix.concat([0, 0, 0, 1, 0]);

			filter.push(new ColorMatrixFilter(matrix));

			return filter;
		}
	}
}