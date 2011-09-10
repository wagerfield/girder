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
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;



	/**
	 * @author Matthew Wagerfield
	 */
	public class SWFLibrary
	{
		private var _swf:MovieClip;



		/**
		 * Utility for easily extracting classes from an external SWF loaded in as a MovieClip.
		 * 
		 * @param swf The reference SWF MovieClip to extract classes from.
		 */
		public function SWFLibrary(swf:MovieClip = null):void
		{
			_swf = swf;
		}
		
		
		
		/**
		 * Returns a Sprite with a specified Class Name.
		 * 
		 * @param className The class name within the SWF.
		 */
		public function getSprite(className:String):Sprite
		{
			return new (_swf.loaderInfo.applicationDomain.getDefinition(className) as Class) as Sprite;
		}
		/**
		 * Returns a MovieClip with a specified Class Name.
		 * 
		 * @param className The class name within the SWF.
		 */
		public function getMovieClip(className:String):MovieClip
		{
			return new (_swf.loaderInfo.applicationDomain.getDefinition(className) as Class) as MovieClip;
		}
		/**
		 * Returns a BitmapData Object with a specified Class Name.
		 * 
		 * @param className The class name within the SWF.
		 */
		public function getBitmapData(className:String):BitmapData
		{
			return new (_swf.loaderInfo.applicationDomain.getDefinition(className) as Class)(0, 0) as BitmapData;
		}
		/**
		 * Returns a Bitmap with a specified Class Name.
		 * 
		 * @param className The class name within the SWF.
		 */
		public function getBitmap(className:String):Bitmap
		{
			return new Bitmap(getBitmapData(className));
		}
		/**
		 * Returns a Class with a specified Class Name.
		 * 
		 * @param className The class name within the SWF.
		 */
		public function getFont(className:String):Class
		{
			return _swf.loaderInfo.applicationDomain.getDefinition(className) as Class;
		}
		
		
		
		/** @param value The reference SWF MovieClip to extract classes from. */
		public function set swf(value:MovieClip):void
		{
			_swf = value;
		}
		/** Returns the reference SWF MovieClip. */
		public function get swf():MovieClip
		{
			return _swf;
		}
	}
}