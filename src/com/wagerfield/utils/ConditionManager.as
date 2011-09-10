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
	import com.wagerfield.events.ConditionManagerEvent;

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;



	/**
	 * @author Matthew Wagerfield
	 */
	public class ConditionManager extends EventDispatcher
	{
		private var _dict:Dictionary;
		private var _satisfied:Boolean;



		/** Utility for managing and reacting to the satisfication of multiple conditions. */
		public function ConditionManager():void
		{
			_dict = new Dictionary();
		}
		private function checkConditions():void
		{
			var loop:uint = 0;
			var success:uint = 0;

			for (var key:Object in _dict)
			{
				loop++;

				if (_dict[key].value == _dict[key].condition)
				{
					success++;
				}
			}
			if (loop > 0)
			{
				_satisfied = success == loop ? true : false;

				dispatchEvent(new ConditionManagerEvent(ConditionManagerEvent.SATISFIED, _satisfied));
			}
		}
		
		
		
		/**
		 * Adds a condition to the ConditionManager.
		 * 
		 * @param key Key to which a condition and value is attached to.
		 * @param value Current value of the key.
		 * @param condition Condition that the value needs to satisfy.
		 * @param id Optional id that can be used to help visualise satisfied and unsatisfied keys. Default is null.
		 * @param check Immediately checks whether or not all conditions have been satisfied. Default is false.
		 */
		public function addCondition(key:Object, value:Object, condition:Object, id:Object = null, check:Boolean = false):void
		{
			_dict[key] = {value:value, condition:condition, id:id};

			if (check) checkConditions();
		}
		/**
		 * Removes a key from the ConditionManager.
		 * 
		 * @param key Key to remove from the dictionary.
		 */
		public function removeCondition(key:Object):void
		{
			if (_dict[key])
			{
				delete _dict[key];

				checkConditions();
			}
		}
		/**
		 * Sets the current value of a key.
		 * 
		 * @param key Key to set the current value of.
		 * @param value New value of the key.
		 */
		public function setValue(key:Object, value:Object):void
		{
			if (_dict[key])
			{
				_dict[key].value = value;

				checkConditions();
			}
		}
		/**
		 * Sets the condition of a key.
		 * 
		 * @param key Key to set the condition of.
		 * @param condition New condition for the key.
		 */
		public function setCondition(key:Object, condition:Object):void
		{
			if (_dict[key])
			{
				_dict[key].condition = condition;

				checkConditions();
			}
		}
		/**
		 * Sets the id of a key.
		 * 
		 * @param key Key to set the id of.
		 * @param id New id for the key.
		 */
		public function setId(key:Object, id:Object):void
		{
			if (_dict[key])
			{
				_dict[key].id = id;
			}
		}
		
		
		
		/**
		 * Returns the value of a key.
		 * 
		 * @param key Key to return the value of.
		 */
		public function getValue(key:Object):Object
		{
			return _dict[key].value;
		}
		/**
		 * Returns the condition of a key.
		 * 
		 * @param key Key to return the condition of.
		 */
		public function getCondition(key:Object):Object
		{
			return _dict[key].condition;
		}
		/**
		 * Returns the id of a key.
		 * 
		 * @param key Key to return the id of.
		 */
		public function getId(key:Object):Object
		{
			return _dict[key].id;
		}
		/**
		 * Returns a Boolean value that specifies whether or not the key has satisified its condition.
		 * 
		 * @param key Key to return the condition satisification of.
		 */
		public function getSatisfied(key:Object):Boolean
		{
			return _dict[key].value == _dict[key].condition ? true : false;
		}
		
		
		
		/**
		 * Returns an Array of keys that have satisfied their condition.
		 */
		public function get allSatisfied():Array
		{
			var satisfiedArr:Array = new Array();

			for (var key:Object in _dict)
			{
				if (_dict[key].value == _dict[key].condition)
				{
					satisfiedArr.push(key);
				}
			}
			return satisfiedArr;
		}
		/**
		 * Returns an Array of keys that have not satisfied their condition.
		 */
		public function get allUnsatisfied():Array
		{
			var unsatisfiedArr:Array = new Array();

			for (var key:Object in _dict)
			{
				if (_dict[key].value != _dict[key].condition)
				{
					unsatisfiedArr.push(key);
				}
			}
			return unsatisfiedArr;
		}
		/**
		 * Returns whether or not the ConditionManager has satisfied all of its conditions.
		 */
		public function get satisfied():Boolean
		{
			return _satisfied;
		}
	}
}