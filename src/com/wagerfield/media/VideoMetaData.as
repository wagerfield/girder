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
	/**
	 * @author Matthew Wagerfield
	 */
	public class VideoMetaData
	{
		private var _metaData:Object = {};



		/** @param value Sets the Meta Data from the FLV file to assigned variables. */
		public function set data(metaData:Object):void
		{
			_metaData = metaData;
		}



		/** Returns a String value containing all of the Meta Data in a formatted block. */
		public function get dataBlock():String
		{
			const INSET:String = "\n   ";

			var dataBlock:String = "\n-------- META  DATA --------\n";

			dataBlock = dataBlock.concat(INSET + "Audio Codec Id: " + this.audioCodecId);
			dataBlock = dataBlock.concat(INSET + "Audio Data Rate: " + this.audioDataRate);
			dataBlock = dataBlock.concat(INSET + "Audio Delay: " + this.audioDelay);
			dataBlock = dataBlock.concat(INSET + "Can Seek To End: " + this.canSeekToEnd);
			dataBlock = dataBlock.concat(INSET + "Duration: " + this.duration);
			dataBlock = dataBlock.concat(INSET + "Framerate: " + this.framerate);
			dataBlock = dataBlock.concat(INSET + "Height: " + this.height);
			dataBlock = dataBlock.concat(INSET + "Length: " + this.length);
			dataBlock = dataBlock.concat(INSET + "Video Codec Id: " + this.videoCodecId);
			dataBlock = dataBlock.concat(INSET + "Video Data Rate: " + this.videoDataRate);
			dataBlock = dataBlock.concat(INSET + "Width: " + this.width);
			dataBlock = dataBlock.concat("\n----------------------------");

			return dataBlock;
		}
		/** Returns the audio codec id. */
		public function get audioCodecId():Number
		{
			return _metaData.audiocodecid || null;
		}
		/** Returns the audio data rate. */
		public function get audioDataRate():Number
		{
			return _metaData.audiodatarate || null;
		}
		/** Returns the audio delay. */
		public function get audioDelay():Number
		{
			return _metaData.audiodelay || null;
		}
		/** Returns a Boolean value specifying whether or not the FLV can seek to the end of the stream. */
		public function get canSeekToEnd():Boolean
		{
			return _metaData.canSeekToEnd || null;
		}
		/** Returns the duration of the FLV. */
		public function get duration():Number
		{
			return _metaData.duration || null;
		}
		/** Returns the framerate of the FLV. */
		public function get framerate():Number
		{
			return _metaData.framerate || null;
		}
		/** Returns the native height of the FLV. */
		public function get height():Number
		{
			return _metaData.height || null;
		}
		/** Returns the length of the FLV. */
		public function get length():Number
		{
			return _metaData.length || null;
		}
		/** Returns the ratio between the width and the height of the FLV. */
		public function get ratio():Number
		{
			return this.height / this.width || null;
		}
		/** Returns the video codec id. */
		public function get videoCodecId():Number
		{
			return _metaData.videocodecid || null;
		}
		/** Returns the video data rate. */
		public function get videoDataRate():Number
		{
			return _metaData.videodatarate || null;
		}
		/** Returns the native width of the FLV. */
		public function get width():Number
		{
			return _metaData.width || null;
		}
	}
}