package com.vhall.framework.keyboard
{

	/**
	 * ...
	 * @author Sol
	 */
	public class KeyMap
	{
		private var _listener:Function;
		private var _combination:String;

		public function KeyMap(listener:Function, combination:String)
		{
			init(listener, combination);
		}

		private function init(listener:Function, combination:String):void
		{
			_listener = listener;
			_combination = combination;
		}

		public function equals(other:KeyMap):Boolean
		{
			return (other._listener == _listener && other._combination == _combination);
		}

		public function execute():void
		{
			_listener();
		}

		public function toString():String
		{
			return _combination;
		}
	}
}
