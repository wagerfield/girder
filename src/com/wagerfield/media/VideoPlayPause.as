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

package com.wagerfield.media
{
	import com.wagerfield.display.SuperSprite;
	import com.wagerfield.events.ModMouseEvent;
	import com.wagerfield.events.VideoStreamEvent;

	import flash.display.Sprite;



	/**
	 * @author Matthew Wagerfield
	 */
	public class VideoPlayPause extends SuperSprite
	{
		private var _hotspotBorder:Number = 0;
		private var _fillColour:uint = 0x000000;
		private var _fillAlpha:Number = 1;
		private var _strokeColour:uint = 0x000000;
		private var _strokeAlpha:Number = 1;
		private var _bgRadius:Number = 0;
		private var _bgColour:uint = 0xDDDDDD;
		private var _bgAlpha:Number = 1;
		private var _playWidth:uint = 8;
		private var _playHeight:uint = 8;
		private var _playStroke:Number = 1.5;
		private var _playOffsetX:Number = 0;
		private var _pauseWidth:uint = 10;
		private var _pauseHeight:uint = 10;
		private var _pauseSpacing:uint = 2;
		private var _pauseStroke:Number = 0;
		private var _video:VideoStream;
		private var _bg:Sprite;
		private var _symbols:Sprite;
		private var _play:Sprite;
		private var _pause:Sprite;
		private var _hotspot:Sprite;



		/**
		 * Creates an instance of a VideoPlayPause unit for toggling the playback of an attached VideoStream instance.
		 * 
		 * @param videoStream An instance of the VideoStream class that the VideoPlayPause will react to and modify.
		 */
		public function VideoPlayPause(videoStream:VideoStream):void
		{
			_video = videoStream;

			createClasses();
			configClasses();
			configDisplay();
			drawGraphics();
			addEvents();
			addChildren();
		}
		private function createClasses():void
		{
			_bg = new Sprite();
			_symbols = new Sprite();
			_play = new Sprite();
			_pause = new Sprite();
			_hotspot = new Sprite();
		}
		private function configClasses():void
		{
			_width = 20;
			_height = 20;

			_hotspot.buttonMode = true;
		}
		protected override function configDisplay():void
		{
			drawGraphics();

			_symbols.x = _width * 0.5;
			_symbols.y = _height * 0.5;

			_play.x = _playOffsetX;

			super.configDisplay();
		}
		private function drawGraphics():void
		{
			with (_bg.graphics)
			{
				clear();
				beginFill(_bgColour, _bgAlpha);
				drawRoundRect(0, 0, _width, _height, _bgRadius);
				endFill();
			}
			with (_play.graphics)
			{
				clear();
				if (_playStroke > 0) lineStyle(_playStroke, _strokeColour, _strokeAlpha);
				beginFill(_fillColour, _fillAlpha);
				moveTo(-_playWidth / 2, -_playHeight / 2);
				lineTo(_playWidth / 2, 0);
				lineTo(-_playWidth / 2, _playHeight / 2);
				endFill();
			}
			with (_pause.graphics)
			{
				clear();
				if (_pauseStroke > 0) lineStyle(_pauseStroke, _strokeColour, _strokeAlpha);
				beginFill(_fillColour, _fillAlpha);
				drawRect(-_pauseWidth / 2, -_pauseHeight / 2, (_pauseWidth - _pauseSpacing) / 2, _pauseHeight);
				drawRect(_pauseSpacing / 2, -_pauseHeight / 2, (_pauseWidth - _pauseSpacing) / 2, _pauseHeight);
				endFill();
			}
			with (_hotspot.graphics)
			{
				clear();
				beginFill(0xFF0000, 0);
				drawRoundRect(-_hotspotBorder, -_hotspotBorder, _width + _hotspotBorder * 2, _height + _hotspotBorder * 2, _bgRadius + _hotspotBorder);
				endFill();
			}
		}
		private function addEvents():void
		{
			_video.addEventListener(VideoStreamEvent.PLAYING, onPlaying);
			_hotspot.addEventListener(ModMouseEvent.CLICK, onMouseClick);
		}
		private function addChildren():void
		{
			addBitmapChild(_bg);
			addBitmapChild(_symbols);
			_symbols.addChild(_pause);
			_symbols.addChild(_play);
			addChild(_hotspot);
		}
		
		
		
		private function onMouseClick(e:ModMouseEvent):void
		{
			_video.togglePause();
		}
		private function onPlaying(e:VideoStreamEvent):void
		{
			_play.visible = !_video.playing;
			_pause.visible = _video.playing;

			configDisplay();
		}



		/** @param value Sets the width of the play symbol. */
		public function set playWidth(value:uint):void
		{
			_playWidth = value;
			configDisplay();
		}
		/** @param value Sets the height of the play symbol. */
		public function set playHeight(value:uint):void
		{
			_playHeight = value;
			configDisplay();
		}
		/** @param value Sets the x offset of the play symbol. */
		public function set playOffsetX(value:Number):void
		{
			_playOffsetX = value;
			configDisplay();
		}
		/** @param value Sets the stroke thickness around the perimeter of the play symbol. */
		public function set playStroke(value:Number):void
		{
			_playStroke = value;
			configDisplay();
		}
		/** @param value Sets the width of the pause symbol. */
		public function set pauseWidth(value:uint):void
		{
			_pauseWidth = value;
			configDisplay();
		}
		/** @param value Sets the height of the pause symbol. */
		public function set pauseHeight(value:uint):void
		{
			_pauseHeight = value;
			configDisplay();
		}
		/** @param value Sets the spacing between the two rectangles of the pause symbol. */
		public function set pauseSpacing(value:uint):void
		{
			_pauseSpacing = value;
			configDisplay();
		}
		/** @param value Sets the stroke thickness around the perimeter of the pause symbol. */
		public function set pauseStroke(value:Number):void
		{
			_pauseStroke = value;
			configDisplay();
		}
		/** @param value Sets the fill colour value of the symbols. */
		public function set fillColour(value:uint):void
		{
			_fillColour = value;
			configDisplay();
		}
		/** @param value Sets the fill alpha value of the symbols. */
		public function set fillAlpha(value:Number):void
		{
			_fillAlpha = value;
			configDisplay();
		}
		/** @param value Sets the stroke colour value of the symbols. */
		public function set strokeColour(value:uint):void
		{
			_strokeColour = value;
			configDisplay();
		}
		/** @param value Sets the stroke alpha value of the symbols. */
		public function set strokeAlpha(value:Number):void
		{
			_strokeAlpha = value;
			configDisplay();
		}
		/** @param value Sets the radius value of the background rectangle. */
		public function set bgRadius(value:Number):void
		{
			_bgRadius = value;
			configDisplay();
		}
		/** @param value Sets the colour value of the background. */
		public function set bgColour(value:uint):void
		{
			_bgColour = value;
			configDisplay();
		}
		/** @param value Sets the alpha value of the background. */
		public function set bgAlpha(value:Number):void
		{
			_bgAlpha = value;
			configDisplay();
		}
		/** @param value Modifies the invisible padding around the perimeter of the unit to increase or decrease the hotspot surface area. */
		public function set hotspotBorder(value:uint):void
		{
			_hotspotBorder = value;
			configDisplay();
		}



		/** Returns the width of the play symbol. */
		public function get playWidth():uint
		{
			return _playWidth;
		}
		/** Returns the height of the play symbol. */
		public function get playHeight():uint
		{
			return _playHeight;
		}
		/** Returns the x offset of the play symbol. */
		public function get playOffsetX():Number
		{
			return _playOffsetX;
		}
		/** Returns the stroke thickness of the play symbol. */
		public function get playStroke():Number
		{
			return _playStroke;
		}
		/** Returns the width of the pause symbol. */
		public function get pauseWidth():uint
		{
			return _pauseWidth;
		}
		/** Returns the height of the pause symbol. */
		public function get pauseHeight():uint
		{
			return _pauseHeight;
		}
		/** Returns the spacing between the two rectangles of the pause symbol. */
		public function get pauseSpacing():uint
		{
			return _pauseSpacing;
		}
		/** Returns the stroke thickness of the pause symbol. */
		public function get pauseStroke():Number
		{
			return _pauseStroke;
		}
		/** Returns the fill colour of the symbols. */
		public function get fillColour():uint
		{
			return _fillColour;
		}
		/** Returns the fill alpha of the symbols. */
		public function get fillAlpha():Number
		{
			return _fillAlpha;
		}
		/** Returns the stroke colour of the symbols. */
		public function get strokeColour():uint
		{
			return _strokeColour;
		}
		/** Returns the stroke alpha of the symbols. */
		public function get strokeAlpha():Number
		{
			return _strokeAlpha;
		}
		/** Returns the radius of the background rectangle. */
		public function get bgRadius():Number
		{
			return _bgRadius;
		}
		/** Returns the colour value of the background. */
		public function get bgColour():uint
		{
			return _bgColour;
		}
		/** Returns the alpha value of the background. */
		public function get bgAlpha():Number
		{
			return _bgAlpha;
		}
		/** Returns the value of the invisible hotspot border. */
		public function get hotspotBorder():uint
		{
			return _hotspotBorder;
		}
		/** Returns the symbols Sprite. */
		public function get symbols():Sprite
		{
			return _symbols;
		}
		/** Returns the play Sprite. */
		public function get play():Sprite
		{
			return _play;
		}
		/** Returns the pause Sprite. */
		public function get pause():Sprite
		{
			return _pause;
		}
		/** Returns the background Sprite. */
		public function get bg():Sprite
		{
			return _bg;
		}
	}
}