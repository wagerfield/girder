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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.utils.getTimer;



	/**
	 * @author Matthew Wagerfield
	 */
	public class Statistics extends Sprite
	{
		private static const WIDTH:uint = 100;
		private static const HEIGHT:uint = 100;

		private var _data:XML;

		private var _textField:TextField;
		private var _styleSheet:StyleSheet;

		private var _timer:uint;
		private var _fps:uint;
		private var _milliseconds:uint;
		private var _prevMilliseconds:uint;
		private var _memory:Number;
		private var _memoryMax:Number;

		private var _graph:Bitmap;
		private var _rectangle:Rectangle;

		private var _fpsGraph:uint;
		private var _memoryGraph:uint;
		private var _memoryMaxGraph:uint;

		private var _theme:Object = {background:0x000033, fps:0xffff00, milliseconds:0x00ff00, memory:0x00ffff, memoryMax:0xff0070};



		/**
		 * <b>Statistics</b> FPS, MS and MEM, all in one.
		 * 
		 * @param theme Example: {background:0x202020, fps:0xC0C0C0, milliseconds:0x505050, memory:0x707070, memoryMax:0xA0A0A0} 
		 */
		public function Statistics(theme:Object = null):void
		{
			if (theme)
			{
				if (theme.background) _theme.background = theme.background;
				if (theme.fps) _theme.fps = theme.fps;
				if (theme.milliseconds) _theme.milliseconds = theme.milliseconds;
				if (theme.memory) _theme.memory = theme.memory;
				if (theme.memoryMax) _theme.memoryMax = theme.memoryMax;
			}
			_memoryMax = 0;

			_data = <data><fps>FPS:</fps><milliseconds>MS:</milliseconds><memory>MEM:</memory><memoryMax>MAX:</memoryMax></data>;

			_styleSheet = new StyleSheet();
			_styleSheet.setStyle("data", {fontSize:'9px', fontFamily:'_sans', leading:'-2px'});
			_styleSheet.setStyle("fps", {color:hexToCSS(_theme.fps)});
			_styleSheet.setStyle("milliseconds", {color:hexToCSS(_theme.milliseconds)});
			_styleSheet.setStyle("memory", {color:hexToCSS(_theme.memory)});
			_styleSheet.setStyle("memoryMax", {color:hexToCSS(_theme.memoryMax)});

			_textField = new TextField();
			_textField.width = WIDTH;
			_textField.height = 50;
			_textField.styleSheet = _styleSheet;
			_textField.condenseWhite = true;
			_textField.selectable = false;
			_textField.mouseEnabled = false;

			_graph = new Bitmap();
			_graph.y = 50;

			_rectangle = new Rectangle(WIDTH - 1, 0, 1, HEIGHT - 50);

			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
		}
		private function init(e:Event):void
		{
			with (this.graphics)
			{				
				beginFill(_theme.background);
				drawRect(0, 0, WIDTH, HEIGHT);
				endFill();
			}
			_graph.bitmapData = new BitmapData(WIDTH, HEIGHT - 50, false, _theme.background);
			
			addChild(_textField);
			addChild(_graph);

			addEventListener(Event.ENTER_FRAME, update);
		}
		private function destroy(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, update);

			this.graphics.clear();

			while (numChildren > 0)
			{
				removeChildAt(0);
			}
			_graph.bitmapData.dispose();
		}
		private function update(e:Event):void
		{
			_timer = getTimer();

			if (_timer - 1000 > _prevMilliseconds)
			{
				_prevMilliseconds = _timer;
				_memory = Number((System.totalMemory * 0.000000954).toFixed(3));
				_memoryMax = Math.min(_memoryMax, _memory);

				_fpsGraph = Math.min(_graph.height, ( _fps / stage.frameRate ) * _graph.height);
				_memoryGraph = Math.min(_graph.height, Math.sqrt(Math.sqrt(_memory * 5000))) - 2;
				_memoryMaxGraph = Math.min(_graph.height, Math.sqrt(Math.sqrt(_memoryMax * 5000))) - 2;

				_graph.bitmapData.scroll(-1, 0);

				_graph.bitmapData.fillRect(_rectangle, _theme.background);
				_graph.bitmapData.setPixel(_graph.width - 1, _graph.height - _fpsGraph, _theme.fps);
				_graph.bitmapData.setPixel(_graph.width - 1, _graph.height - ((_timer - _milliseconds) >> 1), _theme.milliseconds);
				_graph.bitmapData.setPixel(_graph.width - 1, _graph.height - _memoryGraph, _theme.memory);
				_graph.bitmapData.setPixel(_graph.width - 1, _graph.height - _memoryMaxGraph, _theme.memoryMax);

				_data.fps = "FPS: " + _fps + " / " + stage.frameRate;
				_data.memory = "MEM: " + _memory;
				_data.memoryMax = "MAX: " + _memoryMax;

				_fps = 0;
			}
			_fps++;

			_data.milliseconds = "MS: " + (_timer - _milliseconds);
			_milliseconds = _timer;

			_textField.htmlText = _data;
		}
		private function hexToCSS(colour:int):String
		{
			return "#" + colour.toString(16);
		}
	}
}