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
	import flash.events.MouseEvent;



	/**
	 * @author Matthew Wagerfield
	 */
	public class ExternalMouseEvent extends MouseEvent
	{
		/** Event thrown when the ExternalMouse is Initialised. */
		public static const INIT:String = "ExternalMouseInitialised";
		
		/** Event thrown when the ExternalMouse moves. */
		public static const MOUSE_MOVE:String = "ExternalMouseMove";
		
		/** Event thrown when the ExternalMouse wheel is rotated. */
		public static const MOUSE_WHEEL:String = "ExternalMouseWheel";
		
		private var _swfMouseX:int;
		private var _swfMouseY:int;
		private var _docMouseX:int;
		private var _docMouseY:int;



		/**
		 * ExternalMouseEvent that captures the ExternalMouse's events and properties through JavaScript.
		 * 
		 * @param type ExternalMouseEvent type.
		 * @param swfMouseX The horizontal coordinate at which the event occurred relative to SWF.
		 * @param swfMouseY The vertical coordinate at which the event occurred relative to the SWF.
		 * @param docMouseX The horizontal coordinate at which the event occurred relative to the Document.
		 * @param docMouseY The vertical coordinate at which the event occurred relative to the Document.
		 * @param ctrlKey On Windows, indicates whether the Ctrl key is active (true) or inactive (false).
		 * @param altKey Indicates whether the Alt key is active (true) or inactive (false).
		 * @param shiftKey Indicates whether the Shift key is active (true) or inactive (false).
		 * @param delta Indicates how many lines should be scrolled for each unit the user rotates the mouse wheel.
		 */
		public function ExternalMouseEvent(type:String = null, swfMouseX:int = 0, swfMouseY:int = 0, docMouseX:int = 0, docMouseY:int = 0, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false, delta:int = 0):void
		{
			super(type, true, false, swfMouseX, swfMouseY, null, ctrlKey, altKey, shiftKey, false, delta);

			_swfMouseX = swfMouseX;
			_swfMouseY = swfMouseY;
			_docMouseX = docMouseX;
			_docMouseY = docMouseY;
		}
		/** Returns the x position of the ExternalMouse relative to SWF. */
		public function get swfMouseX():int
		{
			return _swfMouseX;
		}
		/** Returns the y position of the ExternalMouse relative to SWF. */
		public function get swfMouseY():int
		{
			return _swfMouseY;
		}
		/** Returns the x position of the ExternalMouse relative to Document. */
		public function get docMouseX():int
		{
			return _docMouseX;
		}
		/** Returns the y position of the ExternalMouse relative to Document. */
		public function get docMouseY():int
		{
			return _docMouseY;
		}
	}
}