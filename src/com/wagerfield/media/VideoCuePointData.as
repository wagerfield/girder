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
	public class VideoCuePointData
	{
		private var _length:Number;
		private var _name:String;
		private var _parameters:Object;
		private var _time:Number;



		/** @param value Sets the Cue Point Data from the FLV file to assigned variables. */
		public function set data(cuePointData:Object):void
		{
			_length = cuePointData.length || null;
			_name = cuePointData.name || null;
			_parameters = cuePointData.parameters || null;
			_time = cuePointData.time || null;
		}
		
		

		/** Returns a String value containing all of the Cue Point Data in a formatted block. */
		public function get dataBlock():String
		{
			const INSET:String = "\n   ";

			var dataBlock:String = "\n------ CUE POINT DATA ------\n";

			dataBlock = dataBlock.concat(INSET + "Length: " + _length);
			dataBlock = dataBlock.concat(INSET + "Name: " + _name);
			dataBlock = dataBlock.concat(INSET + "Time: " + _time);
			dataBlock = dataBlock.concat("\n");
			dataBlock = dataBlock.concat(INSET + "Parameters: ");
			dataBlock = dataBlock.concat("\n");

			for (var p:String in _parameters)
			{
				dataBlock = dataBlock.concat(INSET + "•   " + p + ": " + _parameters[p]);
			}

			dataBlock = dataBlock.concat("\n----------------------------");

			return dataBlock;
		}
		/** Returns the length. */
		public function get length():Number
		{
			return _length;
		}
		/** Returns the name of the cue point. */
		public function get name():String
		{
			return _name;
		}
		/** Returns the cue point parameters. */
		public function get parameters():Object
		{
			return _parameters;
		}
		/** Returns the time of the cue point. */
		public function get time():Number
		{
			return _time;
		}
	}
}