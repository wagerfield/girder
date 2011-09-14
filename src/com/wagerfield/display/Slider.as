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
	import com.wagerfield.events.ModMouseEvent;
	import com.wagerfield.events.SliderEvent;
	import com.wagerfield.utils.Physics;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;



	/**
	 * @author Matthew Wagerfield
	 */
	public class Slider extends SuperSprite
	{
		protected var _stage:Stage;

		private var _vertical:Boolean;
		private var _enabled:Boolean;
		private var _mouseDown:Boolean;
		private var _consume:Boolean;
		private var _paint:Boolean;
		private var _updateRatio:Boolean;
		private var _radius:Number = 0;
		private var _bgColour:uint = 0xDDDDDD;
		private var _bgAlpha:Number = 1;
		private var _handleSize:uint = 100;
		private var _handleColour:uint = 0x000000;
		private var _handleAlpha:Number = 1;
		private var _hotspotBorder:uint = 5;
		private var _incs:uint = 10;
		private var _friction:Number = 0.65;
		private var _inertia:Number = 0;
		private var _limits:uint = 0;
		private var _setRatio:Number = 0;
		private var _getRatio:Number = 0;
		private var _handlePos:Number = 0;
		private var _offsetPos:Number = 0;
		private var _display:Sprite;
		private var _bg:Sprite;
		private var _insert:Sprite;
		private var _offset:Sprite;
		private var _handle:Sprite;
		private var _hotspot:Sprite;
		private var _physics:Physics;
		private var _target:int;



		/**
		 * Creates a Slider component for easily modifying a ratio value from 0 - 1 using an interactive drag handle.
		 *
		 * @param vertical Specifies the orientation of the Slider. Can be configured either vertically or horizontally.
		 * @param enabled Enables the Slider; allowing both interaction with the drag handle and control over Slider ratio property.
		 */
		public function Slider(vertical:Boolean = true, enabled:Boolean = true):void
		{
			_vertical = vertical;
			_enabled = enabled;

			createClasses();
			configClasses();
			configDisplay();
			drawGraphics();
			addChildren();

			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			_stage = stage;
			enabled = _enabled;
		}
		private function createClasses():void
		{
			_display = new Sprite();
			_bg = new Sprite();
			_insert = new Sprite();
			_offset = new Sprite();
			_handle = new Sprite();
			_hotspot = new Sprite();
			_physics = new Physics(_handle);
			_target = 0;
		}
		private function configClasses():void
		{
			_width = _vertical ? 10 : 400;
			_height = _vertical ? 400 : 10;
			_consume = true;

			mouseDown = false;
		}
		protected override function configDisplay():void
		{
			_setRatio = _setRatio < 0 ? 0 : _setRatio;
			_setRatio = _setRatio > 1 ? 1 : _setRatio;
			_offsetPos = _handleSize / 2;
			_offset.x = _vertical ? 0 : _offsetPos;
			_offset.y = _vertical ? _offsetPos : 0;
			_limits = _vertical ? _height - _handleSize : _width - _handleSize;
			_target = _mouseDown ? _target : _setRatio * _limits;
			_updateRatio = false;

			if ((_vertical && (_bg.height != _height)) || (!_vertical && (_bg.width != _width)))
			{
				updateProperty(_handle, _vertical ? "y" : "x", _target);
			}
			if (_consume) ModMouseEvent.removeGhost(_hotspot);
			else ModMouseEvent.addGhost(_hotspot, [ModMouseEvent.MOUSE_DOWN]);

			if (_stage) paint = true;
			else update(false);

			drawGraphics();

			super.configDisplay();
		}
		private function drawGraphics():void
		{
			with (_bg.graphics)
			{
				clear();
				beginFill(_bgColour, _bgAlpha);
				drawRoundRect(0, 0, _width, _height, _radius);
				endFill();
			}
			with (_handle.graphics)
			{
				clear();
				beginFill(_handleColour, _handleAlpha);
				drawRoundRect(_vertical ? 0 : -_handleSize / 2, _vertical ? -_handleSize / 2 : 0, _vertical ? _width : _handleSize, _vertical ? _handleSize : _height, _radius);
				endFill();
			}
			with (_hotspot.graphics)
			{
				clear();
				beginFill(0x0000FF, 0);
				drawRect(_vertical ? -_hotspotBorder : 0, _vertical ? 0 : -_hotspotBorder, _vertical ? _width + _hotspotBorder * 2 : _width, _vertical ? _height : _height + _hotspotBorder * 2);
				endFill();
			}
		}
		private function addChildren():void
		{
			addChild(_display);
			_display.addChild(_bg);
			_display.addChild(_insert);
			_display.addChild(_offset);
			_offset.addChild(_handle);
			addChild(_hotspot);
		}



		private function update(physics:Boolean):void
		{
			if (physics)
			{
				_target = _mouseDown ? _vertical ? _offset.mouseY : _offset.mouseX : _target;
				_target = _target < 0 ? 0 : _target;
				_target = _target > _limits ? _limits : _target;
				_target = _enabled ? _target : 0;

				if (_vertical) _physics.chase({y:_target}, _friction, _inertia);
				else _physics.chase({x:_target}, _friction, _inertia);

				var hanPos:Number = _vertical ? _handle.y : _handle.x;

				_getRatio = hanPos / _limits;

				if (_updateRatio) _setRatio = _getRatio;
				if (_handlePos != hanPos)
				{
					_handlePos = hanPos;
					dispatchEvent(new SliderEvent(SliderEvent.CHANGE, sliding));
				}
				else if (!_mouseDown || (!_enabled && (_handlePos == 0)))
				{
					paint = false;
					dispatchEvent(new SliderEvent(SliderEvent.STATIC, sliding));
				}
			}
			else
			{
				if (_vertical) _handle.y = _target;
				else _handle.x = _target;

				_handlePos = _target;
				_getRatio = _setRatio;
			}
		}



		private function onPaint(e:Event):void
		{
			update(true);
		}
		private function onMouseDown(e:ModMouseEvent):void
		{
			mouseDown = true;
		}
		private function onMouseUp(e:ModMouseEvent):void
		{
			mouseDown = false;
		}



		private function set paint(value:Boolean):void
		{
			if (_stage)
			{
				if (_paint = value)
				{
					_stage.addEventListener(Event.ENTER_FRAME, onPaint);
				}
				else
				{
					_stage.removeEventListener(Event.ENTER_FRAME, onPaint);
				}
			}
		}
		private function set mouseDown(value:Boolean):void
		{
			if (_mouseDown != value)
			{
				_mouseDown = value;
				dispatchEvent(new SliderEvent(SliderEvent.SLIDING, sliding));
			}
			if (_mouseDown)
			{
				_updateRatio = true;
				paint = true;
			}
		}



		/**
		 * Adds a DisplayObject to the Internal Insert Sprite that is located between the Handle and the Background Sprites.
		 *
		 * @param child DisplayObject to add to the Internal Insert Sprite.
		 */
		public function insertChild(child:DisplayObject):void
		{
			_insert.addChild(child);
		}
		/** Shifts the Slider drag handle up by the value of 1 increment. */
		public function incUp():void
		{
			_setRatio -= 1 / _incs;
			configDisplay();
		}
		/** Shifts the Slider drag handle down by the value of 1 increment. */
		public function incDown():void
		{
			_setRatio += 1 / _incs;
			configDisplay();
		}



		/** @param value Enables the Slider allowing both interaction with the drag handle and control over Slider ratio property. */
		public function set enabled(value:Boolean):void
		{
			if (_stage)
			{
				if (_enabled = _handle.buttonMode = value)
				{
					_stage.addEventListener(ModMouseEvent.MOUSE_UP, onMouseUp);
					_hotspot.addEventListener(ModMouseEvent.MOUSE_DOWN, onMouseDown);
				}
				else
				{
					_stage.removeEventListener(ModMouseEvent.MOUSE_UP, onMouseUp);
					_hotspot.removeEventListener(ModMouseEvent.MOUSE_DOWN, onMouseDown);
				}
			}
		}
		/** @param value Sets the ratio position of the drag handle. */
		public function set ratio(value:Number):void
		{
			_setRatio = value;
			configDisplay();
		}
		/** @param value Specifies the number of increments that the drag handle jumps between 0 and 1 when using the incUp() and incDown functions. */
		public function set increments(value:uint):void
		{
			_incs = value;
			configDisplay();
		}
		/** @param value Sets the global radius for both the Slider background bar and the drag handle. */
		public function set radius(value:Number):void
		{
			_radius = value;
			configDisplay();
		}
		/** @param value Sets the size of the Slider drag handle. */
		public function set handleSize(value:uint):void
		{
			_handleSize = value;
			configDisplay();
		}
		/** @param value Sets the colour value of the Slider drag handle. */
		public function set handleColour(value:uint):void
		{
			_handleColour = value;
			configDisplay();
		}
		/** @param value Sets the alpha value of the Slider drag handle. */
		public function set handleAlpha(value:Number):void
		{
			_handleAlpha = value;
			configDisplay();
		}
		/** @param value Sets the colour value of the background Slider bar. */
		public function set bgColour(value:uint):void
		{
			_bgColour = value;
			configDisplay();
		}
		/** @param value Sets the alpha value of the background Slider bar. */
		public function set bgAlpha(value:Number):void
		{
			_bgAlpha = value;
			configDisplay();
		}
		/** @param value Adds additional invisible padding on either side of the Slider background bar to increase the hotspot surface. */
		public function set hotspotBorder(value:uint):void
		{
			_hotspotBorder = value;
			configDisplay();
		}
		/** @param value Specifies whether or not the Slider consumes Mouse Events. */
		public function set consume(value:Boolean):void
		{
			_consume = value;
			configDisplay();
		}
		/** @param value Specifies the friction value that is used in the internal Physics class to affect the movement of the drag handle when sliding. */
		public function set friction(value:Number):void
		{
			_friction = value;
		}
		/** @param value Specifies the inertia value that is used in the internal Physics class to affect the movement of the drag handle when sliding. */
		public function set inertia(value:Number):void
		{
			_inertia = value;
		}



		/** Returns a Boolean value specifying whether or not the Slider is currently enabled. */
		public function get enabled():Boolean
		{
			return _enabled;
		}
		/** Returns a Boolean value specifying whether or not the Slider handle is currently being dragged. */
		public function get sliding():Boolean
		{
			return _mouseDown;
		}
		/** Returns the friction value that is used by the internal Physics class. */
		public function get friction():Number
		{
			return _friction;
		}
		/** Returns the inertia value that is used by the internal Physics class. */
		public function get inertia():Number
		{
			return _inertia;
		}
		/** Returns the current ratio position of the drag handle. */
		public function get ratio():Number
		{
			return _getRatio;
		}
		/** Returns the number of increments that the handle will jump between 0 - 1 when using the incUp and incDown functions. */
		public function get increments():uint
		{
			return _incs;
		}
		/** Returns the global radius of the Slider. */
		public function get radius():Number
		{
			return _radius;
		}
		/** Returns the size of the Slider drag handle. */
		public function get handleSize():uint
		{
			return _handleSize;
		}
		/** Returns the colour value of the handle. */
		public function get handleColour():uint
		{
			return _handleColour;
		}
		/** Returns the alpha value of the handle. */
		public function get handleAlpha():Number
		{
			return _handleAlpha;
		}
		/** Returns the position of the Slider drag handle. */
		public function get handlePosition():uint
		{
			return _offsetPos + _handlePos;
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
		/** Returns a Boolean value specifying whether or not the Slider consumes Mouse Events. */
		public function get consume():Boolean
		{
			return _consume;
		}
		/** Returns the graphics Sprite. */
		public function get display():Sprite
		{
			return _display;
		}
		/** Returns the handle Sprite. */
		public function get handle():Sprite
		{
			return _handle;
		}
		/** Returns the background Sprite. */
		public function get bg():Sprite
		{
			return _bg;
		}
	}
}