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
	import com.wagerfield.events.SuperSpriteEvent;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;



	/**
	 * @author Matthew Wagerfield
	 */
	public class SuperSprite extends Sprite
	{
		protected var _width:int = 0;
		protected var _height:int = 0;
		protected var _bmcBorder:int = 0;
		protected var _bmcMode:Boolean = false;
		
		private var _capture:Rectangle;
		private var _base:Sprite;
		private var _source:Sprite;
		private var _bmc:BitmapClone;



		/**
		 * The SuperSprite class extends the standard Sprite class with the following features:
		 * The width and height properties are internally controlled through the standard width and height setters and getters.
		 * There is an internal instance of the BitmapClone Class that adds the functionality of flattening all BitmapChildren to a single Bitmap for optimisation.
		 */
		public function SuperSprite():void
		{
			createClasses();
			configClasses();
			addChildren();
		}
		private function createClasses():void
		{
			_base = new Sprite();
			_source = new Sprite();
			_capture = new Rectangle();
			_bmc = new BitmapClone();
		}
		private function configClasses():void
		{
			_source.visible = !_bmcMode;
			_bmc.visible = _bmcMode;
		}
		private function addChildren():void
		{
			addChild(_base);
			addChild(_source);
			addChild(_bmc);
		}
		
		
		
		/** Protected Function that is called everytime the width or height properties are modified. */
		protected function configDisplay():void
		{
			clone();
			dispatchEvent(new SuperSpriteEvent(SuperSpriteEvent.MODIFIED));
		}
		
		
		
		/**
		 * Adds a DisplayObject to the Internal Base Sprite that is located at the bottom of the Internal Dispaly Stack.
		 * 
		 * @param child DisplayObject to add to the Internal Base Sprite.
		 */
		public function addBaseChild(child:DisplayObject):void
		{
			_base.addChild(child);
		}
		/**
		 * Adds a DisplayObject to the Internal Source Sprite that is flattened and cloned to a Bitmap when the BMC Mode is set to true.
		 * 
		 * @param child DisplayObject to add to the Internal Source Sprite.
		 */
		public function addBitmapChild(child:DisplayObject):void
		{
			_source.addChild(child);
			clone();
		}
		/**
		 * Attempts to update the value of a variable. Returns whether or not the value was updated.
		 * 
		 * @param variable The variable to modify the value of.
		 * @param value The value to modify the object's property to.
		 */
		public function updateVariable(variable:Object, value:Object):Boolean
		{
			var updated:Boolean;

			if (variable != value)
			{
				variable = value;
				updated = true;
			}
			return updated;
		}
		/**
		 * Attempts to update the value of an Object's property. Returns whether or not the value was updated.
		 * 
		 * @param object The object to modify the property of.
		 * @param property The key or property to modify.
		 * @param value The value to modify the object's property to.
		 */
		public function updateProperty(object:Object, property:String, value:Object):Boolean
		{
			var updated:Boolean;

			if (object[property] != value)
			{
				object[property] = value;
				updated = true;
			}
			return updated;
		}
		/** Protected Function that clones any DisplayObjects in the Source Sprite. */
		public function clone():void
		{
			if (_bmcMode)
			{
				_capture.x = -_bmcBorder;
				_capture.y = -_bmcBorder;
				_capture.width = _width + _bmcBorder * 2;
				_capture.height = _height + _bmcBorder * 2;

				_bmc.clone(_source, _capture);
			}
		}
		
		
		
		/** @param value Sets the BitmapClone Mode of the SuperSprite. When true, all DisplayObjects in the Source Sprite are flattened to a single Bitmap. */
		public function set bmcMode(value:Boolean):void
		{
			_bmcMode = value;
			_source.visible = !value;
			_bmc.visible = value;

			configDisplay();
		}
		/** @param value Automatically updates the Display width and height to that of the Stage width and height when resized. */
		public function set bmcBorder(value:int):void
		{
			_bmcBorder = value;
			configDisplay();
		}
		/** @param value Sets the width of the SuperSprite. */
		public override function set width(value:Number):void
		{
			_width = int(value);
			configDisplay();
		}
		/** @param value Sets the height of the SuperSprite. */
		public override function set height(value:Number):void
		{
			_height = int(value);
			configDisplay();
		}
		
		
		
		/** Returns the Base Sprite. */
		public function get base():Sprite
		{
			return _base;
		}
		/** Returns the Source Sprite. */
		public function get source():Sprite
		{
			return _source;
		}
		/** Returns the BitmapClone. */
		public function get bmc():BitmapClone
		{
			return _bmc;
		}
		/** Returns the BitmapClone Mode. */
		public function get bmcMode():Boolean
		{
			return _bmcMode;
		}
		/** Returns the BitmapClone border. */
		public function get bmcBorder():int
		{
			return _bmcBorder;
		}
		/** Returns the width of the SuperSprite. */
		public override function get width():Number
		{
			return Number(_width);
		}
		/** Returns the height of the SuperSprite. */
		public override function get height():Number
		{
			return Number(_height);
		}
	}
}