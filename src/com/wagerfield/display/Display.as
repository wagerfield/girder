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
	import com.wagerfield.events.DisplayEvent;
	import com.wagerfield.events.StaticEventDispatcher;

	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;



	/**
	 * @author Matthew Wagerfield
	 */
	public class Display extends StaticEventDispatcher
	{
		private static var _width:uint;
		private static var _height:uint;
		private static var _minWidth:uint;
		private static var _minHeight:uint;
		private static var _maxWidth:uint;
		private static var _maxHeight:uint;
		private static var _initialised:Boolean;
		private static var _fullScreen:Boolean;
		private static var _resize:Boolean;
		private static var _stageLock:Boolean;
		private static var _stage:Stage;



		/**
		 * Initialises the Display class to interact with the stage. This only needs to be done once within an application.
		 * 
		 * @param stage The application Stage instance.
		 * @param width Initial width of the Display class.
		 * @param height Initial height of the Display class.
		 * @param autoResize Updates the Display when the Stage is resized.
		 * @param stageLock Automatically modifies the Display width and height to that of the Stage width and height when resized.
		 */
		public static function init(stage:Stage, width:uint, height:uint, autoResize:Boolean = false, stageLock:Boolean = false, minWidth:uint = uint.MIN_VALUE, minHeight:uint = uint.MIN_VALUE, maxWidth:uint = uint.MAX_VALUE, maxHeight:uint = uint.MAX_VALUE):void
		{
			if (!_initialised)
			{
				_initialised = true;
				_stage = stage;
				_width = width;
				_height = height;
				_stageLock = stageLock;
				_minWidth = minWidth;
				_minHeight = minHeight;
				_maxWidth = maxWidth;
				_maxHeight = maxHeight;

				resize = autoResize;

				_stage.addEventListener(Event.ADDED, onAdded);
				_stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
			}
		}
		
		
		
		private static function onAdded(e:Event):void
		{
			if (_resize) onResize();
		}
		private static function onFullScreen(e:FullScreenEvent):void
		{
			_fullScreen = e.fullScreen;

			if (_resize) onResize();

			notify(DisplayEvent.FULLSCREEN);
		}
		private static function onResize(e:Event = null):void
		{
			if (_stageLock)
			{
				_width = _stage.stageWidth;
				_height = _stage.stageHeight;
			}
			notify(DisplayEvent.RESIZE);
		}



		private static function notify(type:String):void
		{
			_width = Math.max(_width, _minWidth);
			_width = Math.min(_width, _maxWidth);
			_height = Math.max(_height, _minHeight);
			_height = Math.min(_height, _maxHeight);
			
			dispatchStaticEvent(new DisplayEvent(type, _width, _height, _fullScreen));
		}
		
		

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
		/** Forces the Display to update and dispatch a CHANGE DisplayEvent. */
		public static function update():void
		{
			notify(DisplayEvent.RESIZE);
		}
		/** Toggles the fullscreen mode of the application. */
		public static function toggleFullScreen():void
		{
			fullScreen = !_fullScreen;
		}
		/** @param value Automatically updates the Display width and height to that of the Stage width and height when resized. */
		public static function set resize(value:Boolean):void
		{
			if (_resize = value)
			{
				_stage.addEventListener(Event.RESIZE, onResize);
			}
			else
			{
				_stage.removeEventListener(Event.RESIZE, onResize);
			}
		}
		/** @param fullscreen Sets the fullscreen mode of the application. */
		public static function set fullScreen(fullScreen:Boolean):void
		{
			if (_initialised)
			{
				if (fullScreen)
				{
					try
					{
						_stage.displayState = StageDisplayState.FULL_SCREEN;
					}
					catch (e:SecurityError)
					{
						trace("Error! Fullscreen is not enabled in the HTML embedding attributes.");
					}
				}
				else
				{
					try
					{
						_stage.displayState = StageDisplayState.NORMAL;
					}
					catch (e:SecurityError)
					{
						trace("Error!");
					}
				}
				_stage.dispatchEvent(new FullScreenEvent(FullScreenEvent.FULL_SCREEN, false, false, fullScreen));
			}
			else
			{
				trace("Display is not initialised: Reference to the stage required.");
			}
		}
		
		

		/** @param value Sets the width of the Display class. */
		public static function set width(value:uint):void
		{
			if (_width != value)
			{
				_width = value;
				notify(DisplayEvent.RESIZE);
			}
		}
		/** @param value Sets the height of the Display class. */
		public static function set height(value:uint):void
		{
			if (_height != value)
			{
				_height = value;
				notify(DisplayEvent.RESIZE);
			}
		}
		/** @param value Sets the minimum width of the Display class. */
		public static function set minWidth(value:uint):void
		{
			if (_minWidth != value)
			{
				_minWidth = value;
				notify(DisplayEvent.RESIZE);
			}
		}
		/** @param value Sets the minimum height of the Display class. */
		public static function set minHeight(value:uint):void
		{
			if (_minHeight != value)
			{
				_minHeight = value;
				notify(DisplayEvent.RESIZE);
			}
		}
		/** @param value Sets the maximum width of the Display class. */
		public static function set maxWidth(value:uint):void
		{
			if (_maxWidth != value)
			{
				_maxWidth = value;
				notify(DisplayEvent.RESIZE);
			}
		}
		/** @param value Sets the maximum height of the Display class. */
		public static function set maxHeight(value:uint):void
		{
			if (_maxHeight != value)
			{
				_maxHeight = value;
				notify(DisplayEvent.RESIZE);
			}
		}



		/** Returns the Stage. */
		public static function get stage():Stage
		{
			return _stage;
		}
		/** Returns the width of the Stage. */
		public static function get stageWidth():uint
		{
			return _stage.stageWidth;
		}
		/** Returns the height of the Stage. */
		public static function get stageHeight():uint
		{
			return _stage.stageHeight;
		}
		/** Returns the width of the Display class. */
		public static function get width():uint
		{
			return _width;
		}
		/** Returns the height of the Display class. */
		public static function get height():uint
		{
			return _height;
		}
		/** Returns the minimum width of the Display class. */
		public static function get minWidth():uint
		{
			return _minWidth;
		}
		/** Returns the minimum height of the Display class. */
		public static function get minHeight():uint
		{
			return _minHeight;
		}
		/** Returns the maximum width of the Display class. */
		public static function get maxWidth():uint
		{
			return _maxWidth;
		}
		/** Returns the maximum height of the Display class. */
		public static function get maxHeight():uint
		{
			return _maxHeight;
		}
		/** Returns the fullscreen mode of the application. */
		public static function get fullScreen():Boolean
		{
			return _fullScreen;
		}
		/** Returns whether or not the Display width and height automatically resizes to that of the Stage width and height. */
		public static function get resize():Boolean
		{
			return _resize;
		}
	}
}