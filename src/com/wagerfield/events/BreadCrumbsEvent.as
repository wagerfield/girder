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
	import com.wagerfield.utils.Crumb;

	import flash.events.Event;



	/**
	 * @author Matthew Wagerfield
	 */
	public class BreadCrumbsEvent extends Event
	{
		/** Event thrown when the BreadCrumbs history changes. */
		public static const CHANGE:String = "BreadCrumbsChange";
		
		private var _crumb:Crumb;



		/**
		 * Event thrown by the BreadCrumbs class.
		 * 
		 * @param type Event type.
		 * @param crumb BreadCrumb navigation Crumb.
		 */
		public function BreadCrumbsEvent(type:String, crumb:Crumb):void
		{
			super(type);

			_crumb = crumb;
		}
		/** Returns the BreadCrumbs navigation Crumb. */
		public function get crumb():Crumb
		{
			return _crumb;
		}
	}
}