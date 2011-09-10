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
	import com.wagerfield.events.VideoStreamEvent;

	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;



	/**
	 * @author Matthew Wagerfield
	 */
	public class VideoStream extends SuperSprite
	{
		private const NAME:String = "Video";
		private var _smoothing:Boolean = true;
		private var _mute:Boolean = false;
		private var _volume:Number = 1;
		private var _videoURL:String;
		private var _storedURL:String;
		private var _autoPlay:Boolean;
		private var _autoSize:Boolean;
		private var _autoLoop:Boolean;
		private var _bufferRatio:Number;
		private var _metaSet:Boolean;
		private var _playing:Boolean;
		private var _nc:NetConnection;
		private var _ns:NetStream;
		private var _client:Object;
		private var _metaData:VideoMetaData;
		private var _cuePointData:VideoCuePointData;
		private var _video:Video;



		/**
		 * Creates a VideoStream instance for streaming and modifying the playback and properties of an FLV file.
		 * 
		 * @param videoURL The URL of the FLV file.
		 * @param autoPlay Automatically plays the FLV once it has successfully connected the stream.
		 * @param autoSize Automatically resizes the VideoStream to the width and height of the FLV Meta Data.
		 * @param autoLoop Automatically restarts the VideoStream once it has reached the end of the stream.
		 * @param bufferRatio The ratio of the FLV duration to buffer before the stream begins to play.
		 */
		public function VideoStream(videoURL:String = "", autoPlay:Boolean = false, autoSize:Boolean = false, autoLoop:Boolean = false, bufferRatio:Number = 0.1):void
		{
			_videoURL = videoURL;
			_autoPlay = autoPlay;
			_autoSize = autoSize;
			_autoLoop = autoLoop;
			_bufferRatio = bufferRatio;

			createClasses();
			configClasses();
			addEvents();
			netConnection();
		}
		private function createClasses():void
		{
			_nc = new NetConnection();
			_client = new Object();
			_metaData = new VideoMetaData();
			_cuePointData = new VideoCuePointData();
			_video = new Video();
		}
		private function configClasses():void
		{
			_video.name = NAME;

			_storedURL = "";
			_playing = false;

			_width = 400;
			_height = 225;
		}
		protected override function configDisplay():void
		{
			checkClientData();

			_video.width = _width;
			_video.height = _height;
			_video.smoothing = _smoothing;

			if (_ns)
			{
				_ns.bufferTime = _bufferRatio * _metaData.duration;
			}
			super.configDisplay();
		}
		private function addEvents():void
		{
			_nc.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
		}
		private function netConnection():void
		{
			_nc.connect(null);
		}
		private function onNetStatus(e:NetStatusEvent):void
		{
			dispatchEvent(new VideoStreamEvent(VideoStreamEvent.NET_STATUS, e.info.code));

			switch (e.info.code)
			{
				case "NetConnection.Connect.Success":
					connectStream();
					break;
				case "NetStream.Play.StreamNotFound":
					dispatchEvent(new VideoStreamEvent(VideoStreamEvent.STREAM_NOT_FOUND));
					break;
				case "NetStream.Play.Start":
					dispatchEvent(new VideoStreamEvent(VideoStreamEvent.VIDEO_START));
					break;
				case "NetStream.Play.Stop":
					if (_autoLoop) restart();
					dispatchEvent(new VideoStreamEvent(VideoStreamEvent.VIDEO_END));
					break;
				case "NetStream.Buffer.Full":
					dispatchEvent(new VideoStreamEvent(VideoStreamEvent.BUFFER_FULL));
					break;
			}
		}
		private function onAsyncError(e:AsyncErrorEvent):void
		{
			dispatchEvent(new VideoStreamEvent(VideoStreamEvent.ASYNC_ERROR, e.text));
		}
		private function connectStream():void
		{
			_ns = new NetStream(_nc);

			_ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);

			_ns.client = _client;

			_video.attachNetStream(_ns);

			checkClientData();
		}
		private function checkClientData():void
		{
			if (_storedURL != _videoURL)
			{
				close();
				play();
				pause();

				_storedURL = _videoURL;
				_metaSet = false;
				_client.onMetaData = onMetaData;
				_client.onCuePoint = onCuePointData;
			}
		}
		
		
		
		private function onMetaData(metaData:Object):void
		{
			if (!_metaSet)
			{
				_metaData.data = metaData;
				_metaSet = true;

				dispatchEvent(new VideoStreamEvent(VideoStreamEvent.META_DATA));

				if (_autoSize)
				{
					_width = _metaData.width;
					_height = _metaData.height;

					dispatchEvent(new VideoStreamEvent(VideoStreamEvent.AUTO_RESIZE));
				}
				if (_autoPlay)
				{
					play();
				}
				configDisplay();
			}
		}
		private function onCuePointData(cuePointData:Object):void
		{
			_cuePointData.data = cuePointData;

			dispatchEvent(new VideoStreamEvent(VideoStreamEvent.CUE_POINT_DATA));
		}
		
		
		
		private function set isPlaying(value:Boolean):void
		{
			_playing = value;

			dispatchEvent(new VideoStreamEvent(VideoStreamEvent.PLAYING));
		}
		
		

		/** Starts the playback of the currently set FLV specified by the videoURL. */
		public function play():void
		{
			if (_ns)
			{
				isPlaying = true;
				addBitmapChild(_video);
				_ns.play(_videoURL);
				dispatchEvent(new VideoStreamEvent(VideoStreamEvent.PLAY));
			}
		}
		/** Pauses the stream. */
		public function pause():void
		{
			if (_ns)
			{
				isPlaying = false;
				_ns.pause();
				dispatchEvent(new VideoStreamEvent(VideoStreamEvent.PAUSE));
			}
		}
		/** Resumes the stream. */
		public function resume():void
		{
			if (_ns)
			{
				isPlaying = true;
				_ns.resume();
				dispatchEvent(new VideoStreamEvent(VideoStreamEvent.RESUME));
			}
		}
		/** Toggles the playback of the video; switching between pausing and resuming the stream. */
		public function togglePause():void
		{
			if (_ns)
			{
				isPlaying = !_playing;
				_ns.togglePause();
				dispatchEvent(new VideoStreamEvent(VideoStreamEvent.TOGGLE_PAUSE));
			}
		}
		/** Pauses the the stream and resets it to the start by automatically seeking to 0. */
		public function stop():void
		{
			if (_ns)
			{
				pause();
				restart();
				dispatchEvent(new VideoStreamEvent(VideoStreamEvent.STOP));
			}
		}
		/**
		 * Seeks the stream to a specified time value.
		 * 
		 * @param value The time value to skip the stream to.
		 */
		public function seek(value:Number):void
		{
			if (_ns)
			{
				_ns.seek(value);
				dispatchEvent(new VideoStreamEvent(VideoStreamEvent.SEEK));
			}
		}
		/**
		 * Seeks the stream to a specified ratio value of the video; calculated by the input value and the meta duration.
		 * 
		 * @param value Seek ratio.
		 */
		public function seekRatio(value:Number):void
		{
			if (_ns)
			{
				if (_metaSet) seek(_metaData.duration * value);
				dispatchEvent(new VideoStreamEvent(VideoStreamEvent.SEEK_RATIO));
			}
		}
		/** Restarts the stream by seeking to 0. */
		public function restart():void
		{
			if (_ns)
			{
				seek(0);
				dispatchEvent(new VideoStreamEvent(VideoStreamEvent.RESET));
			}
		}
		/** Closes the stream. */
		public function close():void
		{
			if (_ns)
			{
				_ns.close();

				for (var i:int = 0; i < this.base.numChildren; i++)
				{
					if (getChildAt(i) == getChildByName(NAME))
					{
						removeChild(getChildByName(NAME));
					}
				}
				dispatchEvent(new VideoStreamEvent(VideoStreamEvent.CLOSE));
			}
		}
		
		
		
		/** @param value If set to true, the stream sound is muted. */
		public function set mute(value:Boolean):void
		{
			if (_ns)
			{
				_mute = _mute != value ? value : _mute;

				if (_mute) _ns.soundTransform = new SoundTransform(0);
				else _ns.soundTransform = new SoundTransform(_volume);

				dispatchEvent(new VideoStreamEvent(VideoStreamEvent.MUTE));
			}
		}
		/** @param value The volume to set the sound of the stream to. */
		public function set volume(value:Number):void
		{
			if (_ns)
			{
				_volume = value;
				_ns.soundTransform = new SoundTransform(_volume);

				dispatchEvent(new VideoStreamEvent(VideoStreamEvent.VOLUME));
			}
		}
		/** @param value Sets URL of the FLV file. */
		public function set videoURL(value:String):void
		{
			_videoURL = value;
			configDisplay();
		}
		/** @param value Specifies whether or not the video is smoothed when it is resized outside of its native dimensions. */
		public function set videoSmoothing(value:Boolean):void
		{
			_smoothing = value;
			configDisplay();
		}
		/** @param value Automatically plays the FLV once it has successfully connected the stream. */
		public function set autoPlay(value:Boolean):void
		{
			_autoPlay = value;
			configDisplay();
		}
		/** @param value Automatically resizes the VideoStream to the width and height of the FLV Meta Data. */
		public function set autoSize(value:Boolean):void
		{
			_autoSize = value;
			configDisplay();
		}
		/** @param value Automatically restarts the VideoStream once it has reached the end of the stream. */
		public function set autoLoop(value:Boolean):void
		{
			_autoLoop = value;
			configDisplay();
		}
		/** @param value Sets the ratio of the stream duration to buffer before starting the playback of the FLV. */
		public function set bufferTimeRatio(value:Number):void
		{
			_bufferRatio = value;
			configDisplay();
		}
		
		
		
		/** Returns the URL of the currently configured FLV file. */
		public function get videoURL():String
		{
			return _videoURL;
		}
		/** Returns a Boolean value specifying whether or not the video is streamed when it is resized outside of its native dimensions. */
		public function get videoSmoothing():Boolean
		{
			return _smoothing;
		}
		/** Returns the volume of the VideoStream. */
		public function get volume():Number
		{
			return _volume;
		}
		/** Returns a Boolean value specifying whether or not the VideoStream sound channel is muted. */
		public function get mute():Boolean
		{
			return _mute;
		}
		/** Returns the VideoMetaData of the currently configured FLV stream. */
		public function get metaData():VideoMetaData
		{
			return _metaData;
		}
		/** Returns the VideoCuePointData of the currently configured FLV stream. */
		public function get cuePointData():VideoCuePointData
		{
			return _cuePointData;
		}
		/** Returns a Boolean value specifying whether or not the VidoeStream is currently playing. */
		public function get playing():Boolean
		{
			return _playing;
		}
		/** Returns the current time of the stream. */
		public function get time():Number
		{
			return _ns.time;
		}
		/** Returns the ratio of the stream duration that has buffered. */
		public function get bufferRatio():Number
		{
			return _ns.bytesLoaded / _ns.bytesTotal;
		}
		/** Returns the time ratio of the video that the stream is currently sat at. */
		public function get timeRatio():Number
		{
			return _ns.time / _metaData.duration;
		}
	}
}