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
	public class FitObject
	{
		/** Matches the DisplayObject to the specified width limit. */
		public static const MATCH_WIDTH:uint = 0;
		
		/** Matches the DisplayObject to the specified height limit. */
		public static const MATCH_HEIGHT:uint = 1;
		
		/** Fits the DisplayObject inside the smallest available limit. */
		public static const LETTERBOX:uint = 2;
		
		/** Stretches the DisplayObject to the largest available limit. */
		public static const CROP:uint = 3;



		/**
		 * Fits an Object within a pair of width and height limits using a specified fit method.
		 * 
		 * @param object Object to fit within the specified width and height limits.
		 * @param fitWidth Width limit to fit the Object to.
		 * @param fitHeight Height limit to fit the Object to.
		 * @param method Method to use when fitting the Object within the specified width and height limits. Default is CROP
		 * @param round Modifies the resultant width and height of the Object to sit on whole pixels. Default is true.
		 */
		public static function fit(object:Object, fitWidth:Number, fitHeight:Number, method:uint = CROP, round:Boolean = true):void
		{
			var fitScale:Number = 1;

			switch(method)
			{
				case MATCH_WIDTH:
					fitScale = fitWidth / object.width;
					break;
				case MATCH_HEIGHT:
					fitScale = fitHeight / object.height;
					break;
				case LETTERBOX:
					fitScale = fitWidth / object.width < fitHeight / object.height ? fitWidth / object.width : fitHeight / object.height;
					break;
				case CROP:
					fitScale = fitWidth / object.width < fitHeight / object.height ? fitHeight / object.height : fitWidth / object.width;
					break;
			}
			object.width *= fitScale;
			object.height *= fitScale;

			if (round)
			{
				object.width = Math.round(object.width);
				object.height = Math.round(object.height);
			}
		}
	}
}