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
	import com.wagerfield.events.ExternalMouseEvent;
	import com.wagerfield.events.StaticEventDispatcher;

	import flash.external.ExternalInterface;
	import flash.geom.Point;



	/**
	 * @author Matthew Wagerfield
	 */
	public class ExternalMouse extends StaticEventDispatcher
	{
		private static const JS_PREFIX:String = "externalmouse.";
		
		private static var _initialised:Boolean;
		private static var _docMouse:Point;
		private static var _swfMouse:Point;



		/**
		 * Utility for capturing MouseEvents from JavaScript. The externalmouse.js must be both referenced and initialised in order for this class to work.
		 */
		public static function init():void
		{
			if (ExternalInterface.available && !_initialised)
			{
				_docMouse = new Point();
				_swfMouse = new Point();

				ExternalInterface.addCallback("onMouseInit", onMouseInit);
				ExternalInterface.call(JS_PREFIX + "isInitialised");
			}
		}
		private static function onMouseInit(initialised:Boolean):void
		{
			if (_initialised = initialised) dispatchStaticEvent(new ExternalMouseEvent(ExternalMouseEvent.INIT));
		}
		private static function onMouseMove(docMouseX:int, docMouseY:int, swfMouseX:int, swfMouseY:int):void
		{
			_docMouse.x = docMouseX;
			_docMouse.y = docMouseY;
			_swfMouse.x = swfMouseX;
			_swfMouse.y = swfMouseY;

			dispatchStaticEvent(new ExternalMouseEvent(ExternalMouseEvent.MOUSE_MOVE, _swfMouse.x, _swfMouse.y, _docMouse.x, _docMouse.y));
		}
		private static function onMouseWheel(delta:Number, ctrlKey:Boolean, altKey:Boolean, shiftKey:Boolean):void
		{
			dispatchStaticEvent(new ExternalMouseEvent(ExternalMouseEvent.MOUSE_WHEEL, _swfMouse.x, _swfMouse.y, _docMouse.x, _docMouse.y, ctrlKey, altKey, shiftKey, delta));
		}
	
	
	
		/**
		 * Adds an Event Listener to the static EventDispatcher.
		 * 
		 * @param type The type of event.
		 * @param listener The listener function that processes the event.
		 */
		public static function addEventListener(type:String = null, listener:Function = null):void
		{
			if (ExternalInterface.available)
			{
				switch (type)
				{
					case ExternalMouseEvent.MOUSE_MOVE:
						ExternalInterface.addCallback("onMouseMove", onMouseMove);
						break;
					case ExternalMouseEvent.MOUSE_WHEEL:
						ExternalInterface.addCallback("onMouseWheel", onMouseWheel);
						break;
				}
				addStaticEventListener(type, listener);
			}
		}
		/**
		 * Removes an Event Listener from the static EventDispatcher.
		 * 
		 * @param type The type of event.
		 * @param listener The listener function that processes the event.
		 */
		public static function removeEventListener(type:String = null, listener:Function = null):void
		{
			removeStaticEventListener(type, listener);
		}
		
		
		
		/** Returns a Boolean value that specifies whether or not all conditions have been satisfied. */
		public static function get initialised():Boolean
		{
			return _initialised;
		}
	}
}