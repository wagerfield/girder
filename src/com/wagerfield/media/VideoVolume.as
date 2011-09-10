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
	import com.wagerfield.display.Slider;
	import com.wagerfield.events.SliderEvent;
	import com.wagerfield.events.VideoStreamEvent;

	import flash.display.Sprite;



	/**
	 * @author Matthew Wagerfield
	 */
	public class VideoVolume extends Slider
	{
		private var _video:VideoStream;
		private var _modify:Boolean;
		private var _volume:Sprite;
		private var _volumeColour:uint = 0x000000;
		private var _volumeAlpha:Number = 1;



		/**
		 * Extends the Slider class to create a fully interactive VideoVolume control that modifies the volume of an attached VideoStream instance.
		 * 
		 * @param videoStream An instance of the VideoStream class that the VideoVolume will modify the volume of.
		 */
		public function VideoVolume(videoStream:VideoStream):void
		{
			_video = videoStream;

			createClasses();

			super(false, false);

			configClasses();
			configDisplay();
			drawGraphics();
			addEvents();
			addChildren();
		}
		private function createClasses():void
		{
			_volume = new Sprite();
		}
		private function configClasses():void
		{
			this.handleSize = 0;
			this.ratio = 1;
			this.width = 40;
		}
		protected override function configDisplay():void
		{
			drawGraphics();
			super.configDisplay();
		}
		private function drawGraphics():void
		{
			with (_volume.graphics)
			{
				clear();
				beginFill(_volumeColour, _volumeAlpha);
				drawRect(0, 0, _width, _height);
				endFill();
			}
		}
		private function addEvents():void
		{
			this.addEventListener(SliderEvent.SLIDING, onSliding);
			this.addEventListener(SliderEvent.CHANGE, onChange);
			this.addEventListener(SliderEvent.STATIC, onStatic);
			_video.addEventListener(VideoStreamEvent.VIDEO_START, onStart);
			_video.addEventListener(VideoStreamEvent.STREAM_NOT_FOUND, onStreamNotFound);
			_video.addEventListener(VideoStreamEvent.VOLUME, onVolume);
		}
		private function addChildren():void
		{
			this.insertChild(_volume);
		}
		
		

		private function onSliding(e:SliderEvent):void
		{
			if (this.sliding)
			{
				_modify = true;
			}
		}
		private function onChange(e:SliderEvent):void
		{
			_video.volume = this.ratio;
			_volume.scaleX = this.ratio;
		}
		private function onStatic(e:SliderEvent):void
		{
			if (_modify)
			{
				_modify = false;
			}
		}
		private function onVolume(e:VideoStreamEvent):void
		{
			if (!_modify)
			{
				this.ratio = _video.volume;
			}
		}
		private function onStart(e:VideoStreamEvent):void
		{
			this.enabled = true;
		}
		private function onStreamNotFound(e:VideoStreamEvent):void
		{
			this.enabled = false;
		}
		
		

		/** @param value The colour value of the vlume bar. */
		public function set volumeColour(value:uint):void
		{
			_volumeColour = value;
			configDisplay();
		}
		/** @param value The alpha value of the volume bar. */
		public function set volumeAlpha(value:Number):void
		{
			_volumeAlpha = value;
			configDisplay();
		}
		
		
		
		/** Returns the volume Sprite. */
		public function get volume():Sprite
		{
			return _volume;
		}
		/** Returns the colour value of the volume bar. */
		public function get volumeColour():uint
		{
			return _volumeColour;
		}
		/** Returns the alpha value of the volume bar. */
		public function get volumeAlpha():Number
		{
			return _volumeAlpha;
		}
	}
}