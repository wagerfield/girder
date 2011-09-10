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
	import com.wagerfield.utils.ExternalMouse;

	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	
	
	/**
	 * @author Matthew Wagerfield
	 */
	public class ModMouseEvent extends MouseEvent
	{
		/** Event thrown when an InteractiveObject is clicked on. */
		public static const CLICK:String  = "ModMouseClick";
		
		/** Event thrown when an InteractiveObject is double clicked on. */
		public static const DOUBLE_CLICK:String = "ModMouseDoubleClick";
		
		/** Event thrown when the mouse button is down on an InteractiveObject. */
		public static const MOUSE_DOWN:String = "ModMouseMouseDown";
		
		/** Event thrown when the mouse button is released on an InteractiveObject. */
		public static const MOUSE_UP:String = "ModMouseMouseUp";
		
		/** Event thrown when the mouse is rolled over an InteractiveObject. */
		public static const MOUSE_OVER:String = "ModMouseMouseOver";
		
		/** Event thrown when the mouse is rolled out of an InteractiveObject. */
		public static const MOUSE_OUT:String = "ModMouseMouseOut";
		
		/** Event thrown when the mouse moves. */
		public static const MOUSE_MOVE:String = "ModMouseMouseMove";
		
		/** Event thrown when the mouse wheel is rotated. */
		public static const MOUSE_WHEEL:String = "ModMouseMouseWheel";
		
		/** Array containing all ModMouseEvent Events. */
		public static const ALL_EVENTS:Array = [];
		
		
		
		private static var _init:Boolean;
		private static var _external:Boolean;
		private static var _stage:Stage;
		
		private static var _mouse:Point;
		private static var _cursor:Sprite;
		
		private static var _intObjArr:Array;
		
		private static var _eventDict:Dictionary;
		private static var _blockDict:Dictionary;
		private static var _buttonDict:Dictionary;
		private static var _ghostDict:Dictionary;
		private static var _overDict:Dictionary;
		private static var _downDict:Dictionary;
		
		private static var _skeleton:MouseEvent;
		
		
		
		/**
		 * Modified MouseEvent that allows for complex layering of InteractiveObjects listening on the same ModMouseEvent types.
		 * 
		 * @param type ModMouseEvent type.
		 * @param bubbles Indicates whether an event is a bubbling event.
		 * @param cancelable Indicates whether the behavior associated with the event can be prevented.
		 * @param localX The horizontal coordinate at which the event occurred relative to the containing sprite.
		 * @param localY The vertical coordinate at which the event occurred relative to the containing sprite.
		 * @param relatedObject A reference to a display list object that is related to the event.
		 * @param ctrlKey On Windows, indicates whether the Ctrl key is active (true) or inactive (false).
		 * @param altKey Indicates whether the Alt key is active (true) or inactive (false).
		 * @param shiftKey Indicates whether the Shift key is active (true) or inactive (false).
		 * @param buttonDown Indicates whether the primary mouse button is pressed (true) or not (false).
		 * @param delta Indicates how many lines should be scrolled for each unit the user rotates the mouse wheel.
		 */
		public function ModMouseEvent(type:String = null, bubbles:Boolean = true, cancelable:Boolean = false, localX:Number = 0, localY:Number = 0, relatedObject:InteractiveObject = null, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false, buttonDown:Boolean = false, delta:int = 0):void
		{			
			super(type, bubbles, cancelable, localX, localY, relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta);
		}
		
		
		
		/**
		 * Initialises the ModMouseEvent to interact with the stage. This only needs to be done once within an application.
		 * 
		 * @param stage The application Stage instance.
		 * @param external Specifies whether or not to use the ExternalMouse Class that uses JS.
		 */
		public static function init(stage:Stage, external:Boolean = false):Boolean 
		{
			if (!_init)
			{
				_init = true;
				_stage = stage;
				_external = external;
								
				createClasses();
				configClasses();
				mapEvents();
				drawGraphics();
				addEvents();
				addChildren();
				
				if (_external) ExternalMouse.init();
			}	
			return _init;
		}
		private static function createClasses():void 
		{
			_cursor = new Sprite();
			_mouse = new Point();
			_intObjArr = new Array();
			_eventDict = new Dictionary();
			_blockDict = new Dictionary();
			_buttonDict = new Dictionary();
			_ghostDict = new Dictionary();
			_overDict = new Dictionary();
			_downDict = new Dictionary();
			_skeleton = new MouseEvent("SKELETON");
		}
		private static function configClasses():void 
		{
			_cursor.name = "CURSOR";
			
			ModMouseEvent.ALL_EVENTS.push(ModMouseEvent.CLICK);
			ModMouseEvent.ALL_EVENTS.push(ModMouseEvent.DOUBLE_CLICK);
			ModMouseEvent.ALL_EVENTS.push(ModMouseEvent.MOUSE_DOWN);
			ModMouseEvent.ALL_EVENTS.push(ModMouseEvent.MOUSE_UP);
			ModMouseEvent.ALL_EVENTS.push(ModMouseEvent.MOUSE_MOVE);
			ModMouseEvent.ALL_EVENTS.push(ModMouseEvent.MOUSE_WHEEL);
			ModMouseEvent.ALL_EVENTS.push(ModMouseEvent.MOUSE_OVER);
			ModMouseEvent.ALL_EVENTS.push(ModMouseEvent.MOUSE_OUT);
		}
		private static function mapEvents():void 
		{
			addDefinition(MouseEvent.CLICK, ModMouseEvent.CLICK);
			addDefinition(MouseEvent.DOUBLE_CLICK, ModMouseEvent.DOUBLE_CLICK);
			addDefinition(MouseEvent.MOUSE_DOWN, ModMouseEvent.MOUSE_DOWN);
			addDefinition(MouseEvent.MOUSE_UP, ModMouseEvent.MOUSE_UP);
			addDefinition(MouseEvent.MOUSE_MOVE, ModMouseEvent.MOUSE_MOVE);
			addDefinition(MouseEvent.MOUSE_WHEEL, ModMouseEvent.MOUSE_WHEEL);
			addDefinition(ExternalMouseEvent.MOUSE_WHEEL, ModMouseEvent.MOUSE_WHEEL);
		}
		private static function addDefinition(mouseEvent:String, modMouseEvent:String):void 
		{
			_eventDict[mouseEvent] = modMouseEvent;
		}
		private static function drawGraphics():void 
		{
			with (_cursor.graphics)
			{
				clear();
				beginFill(0, 0);
				drawCircle(0, 0, 20);
				endFill();
			}
		}
		private static function addEvents():void 
		{
			if (_external)
			{
				ExternalMouse.addEventListener(ExternalMouseEvent.INIT, onInit);
				ExternalMouse.addEventListener(ExternalMouseEvent.MOUSE_WHEEL, onMouse);
			}			
			_stage.addEventListener(MouseEvent.CLICK, onMouse);
			_stage.addEventListener(MouseEvent.DOUBLE_CLICK, onMouse);
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
			_stage.addEventListener(MouseEvent.MOUSE_UP, onMouse);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouse);
			_stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouse);			
			_stage.addEventListener(Event.ENTER_FRAME, onPaint);
		}
		private static function addChildren():void 
		{
			_stage.addChild(_cursor);
		}
				
		
		
		private static function onInit(e:ExternalMouseEvent):void 
		{
			_stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouse);
		}
		
		
		
		private static function onPaint(e:Event):void 
		{
			_stage.setChildIndex(_cursor, _stage.numChildren-1);
			
			_mouse.x = _stage.mouseX;
			_mouse.y = _stage.mouseY;
			
			_intObjArr = interactiveObjects;
						
			_cursor.x = _mouse.x;
			_cursor.y = _mouse.y;
			_cursor.buttonMode = buttonMode;
			
			checkEventListener(ModMouseEvent.MOUSE_OVER, _skeleton);				
			checkEventListener(ModMouseEvent.MOUSE_OUT, _skeleton);
		}
		
		
		private static function onMouse(e:MouseEvent):void 
		{
			if (e is ModMouseEvent) return;
						
			// Dispatches a ModMouseEvent from the stage with all MouseEvent properties included.
			dispatchEvent(_stage, _eventDict[e.type], e);
			
			// Check all InteractiveObjects under the mouse for the specified EventListener type.
			checkEventListener(_eventDict[e.type], e);
		}
		
		
		
		private static function get interactiveObjects():Array 
		{
			var object:Object = {};			
			var objectArr:Array = _stage.getObjectsUnderPoint(_mouse);
			var intObjArr:Array = new Array();			
			var intObjDict:Dictionary = new Dictionary();			
			
			// Iterate through all Objects under the mouse.
			for (var i:int = objectArr.length-1; i >= 0; i--) 
			{
				// Set object to the current Object and check that it is not the Cursor.
				if ((object = objectArr[i]) != _cursor)
				{
					// Create a new Array to hold all the parents of the current Object.
					var parentArr:Array = new Array();
					
					do // Loop up through all the current Objects parents.
					{
						// Check to see if the Object is an InteractiveObject.
						if (object is InteractiveObject)
						{
							// Check to see if the InteractiveObject is unique.
							if (intObjDict[object] == null)
							{
								// Add the InteractiveObject to the InteractiveObject Dictionary, so that it cannot be referenced again.
								intObjDict[object] = "UNDER MOUSE";
								
								// Unshift the InteractiveObject onto the beginning of the Parent Array.
								parentArr.unshift(object);
							}
							else // If the InteractiveObject has already been referenced, break out of the DoWhile loop.
							{
								break;
							}
						}
					}
					while ((object = object.parent) != null); // Set the current Object to its Parent and check that it is not null.
					
					// Iterate through all Object's Parents and push them onto the Interactive Array.
					for (var j:uint = 0; j < parentArr.length; j++) 
					{
						intObjArr.push(parentArr[j]);
					}				
				}
			}
			return intObjArr;
		}
		
		
		
		private static function get buttonMode():Boolean 
		{
			var buttonMode:Boolean = false;
			
			// Iterate through all InteractiveObjects under the mouse.
			for (var i:uint = 0; i < _intObjArr.length; i++) 
			{
				// Check to see if the InteractiveObject has the buttonMode property.
				if (_intObjArr[i].hasOwnProperty("buttonMode"))
				{
					// Check the buttonMode Dictionary to see if the InteractiveObject is set to define the cursor buttonMode.
					if (_buttonDict[_intObjArr[i]])
					{
						buttonMode = _intObjArr[i].buttonMode;
						
						break;
					}
					// ...else check that the InteractiveObject's buttonMode is set to true.
					else if (_intObjArr[i].buttonMode)
					{
						buttonMode = _intObjArr[i].buttonMode;
						
						break;
					}
				}
			}
			return buttonMode;
		}
				
		
		
		private static function checkEventListener(type:String, e:MouseEvent):void 
		{						
			// Filter out MOUSE_DOWN ModMouseEvents.
			if (type == ModMouseEvent.MOUSE_DOWN)
			{
				// Delete all InteractiveObjects from the 'down' Dictionary.
				for (var key:Object in _downDict)
				{					
					delete _downDict[key];
				}
			}
			// Check all ModMouseEvent listener types par MOUSE_OUT.
			if (type != ModMouseEvent.MOUSE_OUT)
			{				
				// Iterate through all InteractiveObjects under the mouse.
				for (var i:uint = 0; i < _intObjArr.length; i++) 
				{					
					// Filter out MOUSE_DOWN ModMouseEvents.
					if (type == ModMouseEvent.MOUSE_DOWN)
					{		
						// Check to see if the InteractiveObject is listening on the CLICK ModMouseEvent type.
						if (_intObjArr[i].hasEventListener(ModMouseEvent.CLICK))
						{	
							// Add the InteractiveObject to the 'down' Dictionary with reference to the CLICK ModMouseEvent.
							_downDict[_intObjArr[i]] = [ModMouseEvent.CLICK];
							
							// Check to see if the InteractiveObject is a ghost to the mapped ModMouseEvent.
							if (!inDict(_ghostDict, _intObjArr[i], ModMouseEvent.CLICK)) return;
						}
					}
					// Check to see if the InteractiveObject is listening on the dispatched ModMouseEvent type.
					if (_intObjArr[i].hasEventListener(type))
					{	
						// Boolean that specifies whether or not to proceed and potentially Dispatch Events.
						var proceed:Boolean;
						
						// If a Block has been set, check the current InteractiveObject to see if it is in the Child display chain of the current blockObj.
						if (blockObj)
						{		
							// Create a temporary reference to the current InteractiveObject.
							var intObj:InteractiveObject = _intObjArr[i];
							
							do
							{
								// If the current intObj is equal to the blockObj proceed within the InteractiveObject Array loop.
								if (intObj == blockObj)
								{									
									proceed = true;
									
									break;									
								}
							}					
							while ((intObj = intObj.parent) != null); // Set the intObj to its Parent and check that it is not null.
						}
						else
						{							
							proceed = true;
						}
						if (proceed)
						{							
							// Filter out MOUSE_OVER ModMouseEvents.
							if (type == ModMouseEvent.MOUSE_OVER)
							{							
								// Check to see if the current InteractiveObject is not in the 'over' Dictionary.
								if (_overDict[_intObjArr[i]] == null)
								{
									// Add the InteractiveObject to the 'over' Dictionary.
									addOver(_intObjArr[i]);
									
									// Dispatch a MOUSE_OVER ModMouseEvent from the current InteractiveObject.
									dispatchEvent(_intObjArr[i], type, e);					
								}
							}					
							// Filter out CLICK ModMouseEvents.
							else if (type == ModMouseEvent.CLICK)
							{
								// Only react to InteractiveObjects that are in the 'down' Dictionary.
								if (inDict(_downDict, _intObjArr[i], type))
								{
									// Dispatch a CLICK ModMouseEvent from the current InteractiveObject.
									dispatchEvent(_intObjArr[i], type, e);
								}
							}
							else
							{						
								// Dispatch a ModMouseEvent from the current InteractiveObject. 
								dispatchEvent(_intObjArr[i], type, e);
							}										
							// Check to see if the InteractiveObject is a ghost to the mapped ModMouseEvent.
							if (!inDict(_ghostDict, _intObjArr[i], type)) return;
						}
						else
						{
							return;
						}
					}					
					// Check to see if the InteractiveObject is blocking the mapped ModMouseEvent.
					if (inDict(_blockDict, _intObjArr[i], type))
					{						
						var blockObj:InteractiveObject = _intObjArr[i];
					}
				}
			}
			else // ...else if the ModMouseEvent type is MOUSE_OUT
			{	
				var outDict:Dictionary = new Dictionary();
				
				// Iterate through all InteractiveObjects in the 'over' Dictionary.
				for (key in _overDict)
				{					
					var consume:uint = _intObjArr.length;
					var consumed:Boolean = false;
					var over:Boolean = false;
					
					// Iterate through all InteractiveObjects under the mouse.
					for (i = 0; i < _intObjArr.length; i++) 
					{
						// Checks to see if the current InteractiveObject under the mouse is in the 'over' Dictionary.
						if (key == _intObjArr[i])
						{
							over = true;
						}
						// Checks to see if:
						// A) The InteractiveObject is listening on a MOUSE_OVER ModMouseEvent.
						// B) AND the InteractiveObject is NOT a Ghost for a MOUSE_OVER ModMouseEvent.
						// C) OR the InteractiveObject is a Block for a MOUSE_OVER ModMouseEvent.
						// D) AND the MOUSE_OVER ModMouseEvent has not yet been cosumed.
						if (((	_intObjArr[i].hasEventListener(ModMouseEvent.MOUSE_OVER) 
							&& !inDict(_ghostDict, _intObjArr[i], ModMouseEvent.MOUSE_OVER))
							|| inDict(_blockDict, _intObjArr[i], ModMouseEvent.MOUSE_OVER))
							&& !consumed)
						{
							// Specifies that the MOUSE_OVER ModMouseEvent has been cosumed.
							consumed = true;
							// Sets the index of the consuming InteractiveObject.
							consume = i; 
						}
						// Checks to see if:
						// A) The MOUSE_OVER ModMouseEvent has been cosumed.
						// B) AND the current InteractiveObject's index is GREATER THAN the cosume index.
						// C) AND the current InteractiveObject is in the 'over' Dictionary.
						if (consumed && (i > consume) && _overDict[_intObjArr[i]])
						{
							// Adds the current InteractiveObject to the 'out' Dictionary.
							outDict[_intObjArr[i]] = true; 
						}
					}
					// If the current InteractiveObject in the 'over' Dictionary is no longer under the mouse; add it to the 'out' Dictionary.
					if (!over) outDict[key] = true;
				}
				// Iterate through all InteractiveObjects in the 'out' Dictionary.
				for (key in outDict)
				{
					// Removes the InteractiveObject to the 'over' Dictionary.
					removeOver(InteractiveObject(key));
					
					// Dispatch a MOUSE_OUT ModMouseEvent from the current InteractiveObject.
					dispatchEvent(InteractiveObject(key), type, e);
				}
			}
		}
		
		
		
		private static function addOver(interactiveObject:InteractiveObject):void 
		{
			_overDict[interactiveObject] = true;
		}
		private static function removeOver(interactiveObject:InteractiveObject):void 
		{
			delete _overDict[interactiveObject];
		}
		
		
			
		private static function inDict(dictionary:Dictionary, interactiveObject:InteractiveObject, type:String):Boolean 
		{
			var inDict:Boolean;
			
			if (dictionary[interactiveObject] != null)
			{				
				for (var i:uint = 0; i < dictionary[interactiveObject].length; i++) 
				{
					if (dictionary[interactiveObject][i] == type)
					{
						inDict = true;
						
						break;
					}
				}
			}
			return inDict;
		}
				
		
		
		private static function dispatchEvent(interactiveObject:InteractiveObject, type:String, e:MouseEvent):void 
		{
			var modMouseEvent:ModMouseEvent = new ModMouseEvent(type, false, e.cancelable, interactiveObject.x, interactiveObject.y, null, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown, e.delta);			// delta			
			interactiveObject.dispatchEvent(modMouseEvent);
		}
		
		
		
		/**
		 * Adds an InteractiveObject to the ModMouseEvent 'block' Dictionary. Block InteractiveObjects block ModMouseEvents.
		 * 
		 * @param interactiveObject The InteractiveObject that is to act as a block.
		 * @param events An array of events that are to be blocked by the InteractiveObject.
		 * @param buttonMode Specifies whether to use the buttonMode of the blocking InteractiveObject.
		 */
		public static function addBlock(interactiveObject:InteractiveObject, events:Array = null, buttonMode:Boolean = true):void 
		{
			_blockDict[interactiveObject] = events;
			_buttonDict[interactiveObject] = buttonMode;
		}
		/**
		 * Removes an InteractiveObject from the ModMouseEvent 'block' Dictionary.
		 * 
		 * @param interactiveObject The InteractiveObject that is to be removed from the ModMouseEvent 'block' Dictionary.
		 */
		public static function removeBlock(interactiveObject:InteractiveObject):void 
		{
			delete _buttonDict[interactiveObject];
			delete _blockDict[interactiveObject];
		}
		
		
		
		/**
		 * Adds an InteractiveObject to the ModMouseEvent 'ghost' Dictionary. Ghost InteractiveObjects do not consume specified ModMouseEvents.
		 * 
		 * @param interactiveObject The InteractiveObject that is to act as a ghost.
		 * @param events An array of events that are NOT to be consumed by the InteractiveObject.
		 */
		public static function addGhost(interactiveObject:InteractiveObject, events:Array):void 
		{			
			_ghostDict[interactiveObject] = events;
		}
		/**
		 * Removes an InteractiveObject from the ModMouseEvent 'ghost' Dictionary.
		 * 
		 * @param interactiveObject The InteractiveObject that is to be removed from the ModMouseEvent 'ghost' Dictionary.
		 */
		public static function removeGhost(interactiveObject:InteractiveObject):void 
		{
			delete _ghostDict[interactiveObject];
		}
		
		
		
		/** @param value Sets the visibility of the cursor Sprite that is used to set the buttonMode of the Mouse cursor. */
		public static function set cursorVisible(value:Boolean):void
		{
			_cursor.visible = value;
		}		
		/** Returns the visibility of the cursor Sprite that is used to set the buttonMode of the Mouse cursor. */
		public static function get cursorVisible():Boolean
		{
			return _cursor.visible;
		}
	}
}