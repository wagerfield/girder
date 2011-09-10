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
	public class TextBoxEvent extends Event
	{
		/** Event thrown when the text exceeds the height bounds of a TextBox instance. */
		public static const OVERFLOW:String = "TextBoxOverflow";
		
		/** Event thrown when the TextBox instance automatically expands vertically to accomodate the new text. */
		public static const AUTO_EXPAND:String = "TextBoxAutoExpand";
		
		private var _excess:Number;



		/**
		 * Event thrown by a TextBox instance.
		 * 
		 * @param type Event type.
		 */
		public function TextBoxEvent(type:String, excess:uint = 0):void
		{
			super(type);

			_excess = excess;
		}
		/** Returns the excess pixel height difference between the LimitsHeight and the UnitHeight. */
		public function get excess():uint
		{
			return _excess;
		}
	}
}