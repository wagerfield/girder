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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;



	/**
	 * @author Matthew Wagerfield
	 */
	public class BitmapClone extends Sprite
	{
		private const MIN_SIZE:uint = 10;
		
		private var _bitmap:Bitmap;
		private var _bitmapData:BitmapData;
		private var _matrix:Matrix;
		private var _capture:Rectangle;



		/**
		 * Creates a bitmap clone from a specified source DisplayObject. 
		 * 
		 * @param source DisplayObject that is to be cloned.
		 * @param capture Bounds and offset of the source capture area.
		 */
		public function BitmapClone(source:DisplayObject = null, capture:Rectangle = null):void
		{
			_bitmap = new Bitmap();
			_matrix = new Matrix();

			addChild(_bitmap);

			if (source != null) clone(source, capture);
		}
		
		
		
		/**
		 * Creates a bitmap clone from a specified source DisplayObject. 
		 * 
		 * @param source DisplayObject that is to be cloned.
		 * @param capture Bounds and offset of the source capture area.
		 * @param transparent Specifies whether or not the BitmapData is transparent or not.
		 * @param fillColour The fill colour of the BitmapData.
		 */
		public function clone(source:DisplayObject, capture:Rectangle = null, transparent:Boolean = true, fillColour:uint = 0):void
		{
			_capture = capture || new Rectangle(0, 0, source.width, source.height);

			_capture.width = _capture.width < MIN_SIZE ? MIN_SIZE : _capture.width;
			_capture.height = _capture.height < MIN_SIZE ? MIN_SIZE : _capture.height;

			_bitmapData = new BitmapData(_capture.width, _capture.height, transparent, fillColour);

			_matrix.tx = -_capture.x;
			_matrix.ty = -_capture.y;

			_bitmapData.lock();
			_bitmapData.fillRect(_bitmapData.rect, 0x00);
			_bitmapData.draw(source, _matrix);
			_bitmapData.unlock();

			_bitmap.bitmapData = _bitmapData;
			_bitmap.smoothing = true;
			_bitmap.x = _capture.x;
			_bitmap.y = _capture.y;
		}
		
		

		/** Returns the BitmapData of the captured source DisplayObject. */
		public function get bitmapData():BitmapData
		{
			return _bitmap.bitmapData;
		}
	}
}