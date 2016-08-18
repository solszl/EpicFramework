package com.vhall.framework.keyboard
{
	import com.vhall.framework.app.vhall_internal;

	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	use namespace vhall_internal;

	/**
	 * @author Sol
	 */
	public class KeyboardMapper
	{
		private var _keyboardFocus:DisplayObject;
		private var _combination:Vector.<int>;
		private var _listeners:Vector.<KeyMap>;
		private var _keysHeld:int;
		private var _keysDown:int;

		public function KeyboardMapper(focus:DisplayObject)
		{
			init(focus);
		}

		private function init(focus:DisplayObject):void
		{
			_keysHeld = 0;
			_keysDown = 0;
			_listeners = new Vector.<KeyMap>();
			_combination = new Vector.<int>();
			_keyboardFocus = focus;
			_keyboardFocus.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, int.MAX_VALUE);
			_keyboardFocus.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, int.MAX_VALUE);
		}

		private function onKeyDown(e:KeyboardEvent):void
		{
			if(_combination.indexOf(e.keyCode) == -1)
			{
				_combination.push(e.keyCode);
				_combination = _combination.sort(compareInt);
			}
		}

		private function compareInt(first:int, second:int):Number
		{
			if(first < second)
				return -1;
			else if(second < first)
				return 1;
			else
				return 0;
		}

		private function checkCombo():void
		{

			var hits:Vector.<KeyMap> = _listeners.filter(onFilter);
			for each(var map:KeyMap in hits)
			{
				map.execute();
			}
		}

		private function onFilter(item:KeyMap, index:int, vector:Vector.<KeyMap>):Boolean
		{
			if(_combination.join() == item.toString())
			{
				return true;
			}
			return false;
		}

		private function onKeyUp(e:KeyboardEvent):void
		{
			checkCombo();
			var position:int = _combination.indexOf(e.keyCode);
			_combination.splice(position, 1);
		}


		public function mapListener(listener:Function, ... toKeys):void
		{
			var keys:Vector.<int> = new Vector.<int>(toKeys.length);
			for(var i:int = 0; i < keys.length; i++)
			{
				keys[i] = toKeys[i];
			}

			var str:String = vhall_internal::normalized(keys);
			_listeners.push(new KeyMap(listener, str));
		}

		public function destroy():void
		{
			_keyboardFocus.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_keyboardFocus.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}

		public function normalized(... toKeys):String
		{
			var keys:Vector.<int> = new Vector.<int>(toKeys.length);
			for(var i:int = 0; i < keys.length; i++)
			{
				keys[i] = toKeys[i];
			}

			return vhall_internal::normalized(keys);
		}

		vhall_internal function normalized(keys:Vector.<int>):String
		{
			keys = keys.sort(compareInt);
			return keys.join();
		}
	}
}
