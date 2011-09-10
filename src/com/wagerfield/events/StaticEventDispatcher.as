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
	import flash.events.EventDispatcher;



	/**
	 * @author Matthew Wagerfield
	 */
	public class StaticEventDispatcher
	{
		private static var _dispatcher:EventDispatcher;



		/**
		 * Adds an Event Listener to the static EventDispatcher.
		 * 
		 * @param type The type of event.
		 * @param listener The listener function that processes the event.
		 * @param useCapture Determines whether the listener works in the capture phase or the target and bubbling phases.
		 * @param priority The priority level of the event listener.
		 * @param useWeakRef Determines whether the reference to the listener is strong or weak.
		 */
		protected static function addStaticEventListener(type:String = null, listener:Function = null, useCapture:Boolean = false, priority:int = 0, useWeakRef:Boolean = false):void
		{
			if (_dispatcher == null)
			{
				_dispatcher = new EventDispatcher();
			}
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakRef);
		}
		/**
		 * Removes an Event Listener from the static EventDispatcher.
		 * 
		 * @param type The type of event.
		 * @param listener The listener function that processes the event.
		 * @param useCapture Determines whether the listener works in the capture phase or the target and bubbling phases.
		 */
		protected static function removeStaticEventListener(type:String = null, listener:Function = null, useCapture:Boolean = false):void
		{
			if (_dispatcher == null)
			{
				return;
			}
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
		/**
		 * Dispatches an Event from the static EventDispatcher.
		 * 
		 * @param event The Event object that is dispatched into the event flow.
		 */
		protected static function dispatchStaticEvent(event:Event):void
		{
			if (_dispatcher == null)
			{
				return;
			}
			_dispatcher.dispatchEvent(event);
		}
	}
}