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

package com.wagerfield.events
{
	import flash.events.Event;



	/**
	 * @author Matthew Wagerfield
	 */
	public class DisplayEvent extends Event
	{
		/** Event thrown when the Display changes. */
		public static const RESIZE:String = "DisplayResize";
		
		/** Event thrown when the Display fullscreen mode changes. */
		public static const FULLSCREEN:String = "DisplayFullscreen";
		
		private var _width:uint;
		private var _height:uint;
		private var _fullScreen:Boolean;



		/**
		 * Event thrown by the BreadCrumbs class.
		 * 
		 * @param type Event type.
		 * @param width The width of the Display class.
		 * @param height The height of the Display class.
		 * @param fullScreen The fullScreen mode of the Display class.
		 */
		public function DisplayEvent(type:String, width:uint, height:uint, fullScreen:Boolean):void
		{
			super(type);

			_width = width;
			_height = height;
			_fullScreen = fullScreen;
		}
		/** Returns the width of the Display class. */
		public function get width():uint
		{
			return _width;
		}
		/** Returns the height of the Display class. */
		public function get height():uint
		{
			return _height;
		}
		/** Returns fullscreen mode of the Display class. */
		public function get fullScreen():Boolean
		{
			return _fullScreen;
		}
	}
}