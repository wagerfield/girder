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
	public class VideoStreamEvent extends Event
	{
		/** Event thrown when the VideoStream cannot be found. */
		public static const STREAM_NOT_FOUND:String = "VideoStreamNotFound";
	
		/** Event thrown when the VideoStream starts. */
		public static const VIDEO_START:String = "VideoStreamStart";
	
		/** Event thrown when the VideoStream ends. */
		public static const VIDEO_END:String = "VideoStreamEnd";
	
		/** Event thrown when VideoStream meta data is configured. */
		public static const META_DATA:String = "VideoStreamMetaData";
	
		/** Event thrown when VideoStream cue point data is configured. */
		public static const CUE_POINT_DATA:String = "VideoStreamCuePointData";
	
		/** Event thrown when the VideoStream is automatically resized to its native meta data dimensions. */
		public static const AUTO_RESIZE:String = "VideoStreamAutoResize";
	
		/** Event thrown when the VideoStream has fully buffered. */
		public static const BUFFER_FULL:String = "VideoStreamBufferFull";
	
		/** Event thrown every time there is a net status event. */
		public static const NET_STATUS:String = "VideoStreamNetStatus";
	
		/** Event thrown every time there is a net status event. */
		public static const ASYNC_ERROR:String = "VideoStreamAsyncError";
	
		/** Event thrown every time the VideoStream playback state changes. */
		public static const PLAYING:String = "VideoStreamPlaying";
	
		/** Event thrown when the VideoStream is set to play. */
		public static const PLAY:String = "VideoStreamPlay";
	
		/** Event thrown when the VideoStream is paused. */
		public static const PAUSE:String = "VideoStreamPause";
	
		/** Event thrown when the VideoStream is resumed. */
		public static const RESUME:String = "VideoStreamResume";
	
		/** Event thrown when the VideoStream is playback is toggled between play and pause. */
		public static const TOGGLE_PAUSE:String = "VideoStreamTogglePause";
	
		/** Event thrown when the VideoStream is seeked to a new time specified by a time in seconds. */
		public static const SEEK:String = "VideoStreamSeek";
	
		/** Event thrown when the VideoStream is seeked to a new time specified by a ratio of the meta data length. */
		public static const SEEK_RATIO:String = "VideoStreamSeekRatio";
	
		/** Event thrown when the VideoStream is stopped. */
		public static const STOP:String = "VideoStreamStop";
	
		/** Event thrown when the VideoStream is closed. */
		public static const CLOSE:String = "VideoStreamClose";
	
		/** Event thrown when the VideoStream is reset. */
		public static const RESET:String = "VideoStreamReset";
	
		/** Event thrown when the VideoStream sound is muted. */
		public static const MUTE:String = "VideoStreamMute";
	
		/** Event thrown when the VideoStream volume is modified. */
		public static const VOLUME:String = "VideoStreamVolume";
		
		private var _code:String;



		/**
		 * Event thrown by a VideoStream instance.
		 * 
		 * @param type Event type.
		 * @param code Code attached to a NET_STATUS event.
		 */
		public function VideoStreamEvent(type:String, code:String = null):void
		{
			super(type);

			_code = code;
		}
		/** Returns the code attached to a NET_STATUS event. */
		public function get code():String
		{
			return _code;
		}
	}
}