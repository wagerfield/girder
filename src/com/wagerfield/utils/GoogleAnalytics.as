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
	import com.google.analytics.GATracker;
	import com.wagerfield.events.GoogleAnalyticsEvent;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;



	/**
	 * @author Matthew Wagerfield
	 */
	public class GoogleAnalytics extends EventDispatcher
	{
		private var _gaTracker:GATracker;
		private var _trackingCode:String;
		private var _display:DisplayObject;
		private var _language:String;
		private var _visible:Boolean;
		private var _devMode:Boolean;
		private var _dataArr:Array;



		/**
		 * Simple class for tracking messages with Google Analytics.
		 * 
		 * @param trackingCode Google analytics Urchin tracking code. Tracking code should be formatted UA-00000000-0.
		 * @param display DisplayObject in which the visual tracking panel will become a child of.
		 * @param visible Boolean value that specifies whether or not the visual tracking panel is visible or not. Default is false.
		 * @param devMode Boolean value that specifies whether or not any messages are outputted through the GATracker.
		 * @param language Actionscript language of the application. Default is AS3.
		 */
		public function GoogleAnalytics(trackingCode:String, display:DisplayObject, visible:Boolean = false, devMode:Boolean = false, language:String = "AS3"):void
		{
			_trackingCode = trackingCode;
			_display = display;
			_visible = visible;
			_devMode = devMode;
			_language = language;
			_dataArr = [];

			_display.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void
		{
			_display.removeEventListener(Event.ADDED_TO_STAGE, init);

			_gaTracker = new GATracker(_display, _trackingCode, _language, _visible);

			unload();
		}
		
		
		
		/**
		 * Tracks data through the GATracker to the Google Analytics account specified by the Urchin tracking code.
		 * 
		 * @param data Message to be tracked. All message Objects are type casted to Strings.
		 */
		public function track(data:Object):void
		{
			_dataArr.push(String(data));

			unload();
		}
		private function unload():void
		{
			if (_gaTracker)
			{
				for (var i:uint = 0; i < _dataArr.length; i++)
				{
					if (_devMode)
					{
						trace("GoogleAnalytics.track: " + _dataArr[i]);
					}
					else
					{
						_gaTracker.trackPageview(_dataArr[i]);
					}
					dispatchEvent(new GoogleAnalyticsEvent(GoogleAnalyticsEvent.TRACK, _dataArr[i]));
				}
				_dataArr.length = 0;
			}
		}
	
	
	
		/** @param value Sets whether or not the GoogleAnalytics intance tracks any messages. */
		public function set devMode(value:Boolean):void
		{
			_devMode = value;
		}
	}
}