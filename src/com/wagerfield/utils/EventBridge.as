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
	import com.wagerfield.events.StaticEventDispatcher;

	import flash.events.Event;



	/**
	 * @author Matthew Wagerfield
	 */
	public class EventBridge extends StaticEventDispatcher
	{
		/**
		 * Adds an Event Listener to the static EventDispatcher.
		 * 
		 * @param type The type of event.
		 * @param listener The listener function that processes the event.
		 */
		public static function addEventListener(type:String = null, listener:Function = null):void
		{
			addStaticEventListener(type, listener);
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
		/**
		 * Dispatches an Event from the static EventDispatcher.
		 * 
		 * @param event The Event object that is dispatched into the event flow.
		 */
		public static function dispatchEvent(event:Event):void
		{
			dispatchStaticEvent(event);
		}
	}
}