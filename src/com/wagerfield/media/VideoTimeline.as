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
	import flash.events.Event;
	import flash.utils.setTimeout;



	/**
	 * @author Matthew Wagerfield
	 */
	public class VideoTimeline extends Slider
	{
		private var _video:VideoStream;
		private var _progress:Sprite;
		private var _buffer:Sprite;
		private var _playing:Boolean = false;
		private var _seek:Boolean = false;
		private var _resumeDelay:uint = 800;
		private var _progressColour:uint = 0x000000;
		private var _progressAlpha:Number = 1;
		private var _bufferColour:uint = 0xDDDDDD;
		private var _bufferAlpha:Number = 1;



		/**
		 * Extends the Slider class to create a fully interactive VideoTimeline that reacts to and modifies the playback of an attached VideoStream instance.
		 * 
		 * @param videoStream An instance of the VideoStream class that the VideoTimeline will react to and modify.
		 */
		public function VideoTimeline(videoStream:VideoStream):void
		{
			_video = videoStream;

			createClasses();

			super(false, false);

			configClasses();
			configDisplay();
			addEvents();
			addChildren();
		}
		private function createClasses():void
		{
			_progress = new Sprite();
			_buffer = new Sprite();
		}
		private function configClasses():void
		{
			this.handleSize = 0;
		}
		protected override function configDisplay():void
		{
			drawGraphics();

			super.configDisplay();
		}
		private function drawGraphics():void
		{
			with (_progress.graphics)
			{
				clear();
				beginFill(_progressColour, _progressAlpha);
				drawRect(0, 0, _width, _height);
				endFill();
			}
			with (_buffer.graphics)
			{
				clear();
				beginFill(_bufferColour, _bufferAlpha);
				drawRect(0, 0, _width, _height);
				endFill();
			}
		}
		private function addEvents():void
		{
			this.addEventListener(SliderEvent.SLIDING, onSliding);
			this.addEventListener(SliderEvent.STATIC, onStatic);

			_video.addEventListener(VideoStreamEvent.VIDEO_START, onVideoStart);
			_video.addEventListener(VideoStreamEvent.STREAM_NOT_FOUND, onStreamNotFound);
			_video.addEventListener(VideoStreamEvent.PLAYING, onPlaying);
		}
		private function addChildren():void
		{
			this.insertChild(_buffer);
			this.insertChild(_progress);
		}
		
		

		private function set paint(value:Boolean):void
		{
			if (_stage)
			{
				if (value)
				{
					_stage.addEventListener(Event.ENTER_FRAME, onPaint);
				}
				else
				{
					_stage.removeEventListener(Event.ENTER_FRAME, onPaint);
				}
			}
		}
		
		
		
		private function onPaint(e:Event):void
		{
			if (_seek)
			{
				_video.seekRatio(ratio);
			}
			else
			{
				this.ratio = _video.timeRatio;
			}
			_progress.width = Math.ceil(_width * this.ratio);
			_buffer.width = Math.ceil(_width * _video.bufferRatio);
		}
		private function onSliding(e:SliderEvent):void
		{
			if (this.sliding)
			{
				this.paint = true;
				_seek = true;
				_playing = _video.playing;

				_video.pause();
			}
			else
			{
				if (_playing) setTimeout(_video.resume, _resumeDelay);
			}
		}
		private function onStatic(e:SliderEvent):void
		{
			if (_seek)
			{
				_seek = false;
				this.paint = _playing;
			}
		}
		private function onVideoStart(e:VideoStreamEvent):void
		{
			this.enabled = true;
		}
		private function onStreamNotFound(e:VideoStreamEvent):void
		{
			this.enabled = false;
		}
		private function onPlaying(e:VideoStreamEvent):void
		{
			if (!sliding) this.paint = _video.playing;
		}
		
		

		/** @param value The colour value of the progress bar. */
		public function set progressColour(value:uint):void
		{
			_progressColour = value;
			configDisplay();
		}
		/** @param value The alpha value of the progress bar. */
		public function set progressAlpha(value:Number):void
		{
			_progressAlpha = value;
			configDisplay();
		}
		/** @param value The colour value of the buffer bar. */
		public function set bufferColour(value:uint):void
		{
			_bufferColour = value;
			configDisplay();
		}
		/** @param value The alpha value of the buffer bar. */
		public function set bufferAlpha(value:Number):void
		{
			_bufferAlpha = value;
			configDisplay();
		}
		
		
		
		/** Returns the progres Sprite. */
		public function get progress():Sprite
		{
			return _progress;
		}
		/** Returns the colour value of the progress bar. */
		public function get progressColour():uint
		{
			return _progressColour;
		}
		/** Returns the alpha value of the progress bar. */
		public function get progressAlpha():Number
		{
			return _progressAlpha;
		}
		/** Returns the buffer Sprite. */
		public function get buffer():Sprite
		{
			return _buffer;
		}
		/** Returns the colour value of the buffer bar. */
		public function get bufferColour():uint
		{
			return _bufferColour;
		}
		/** Returns the alpha value of the buffer bar. */
		public function get bufferAlpha():Number
		{
			return _bufferAlpha;
		}
	}
}