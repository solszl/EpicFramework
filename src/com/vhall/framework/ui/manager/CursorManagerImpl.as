package com.vhall.framework.ui.manager
{
	import flash.display.BitmapData;
	import flash.errors.IllegalOperationError;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	import flash.utils.Dictionary;

	/**
	 * 光标管理器实现
	 * @author Sol
	 * @date 2016-08-19 12:33:33
	 */
	internal class CursorManagerImpl
	{
		private static var _instance:CursorManagerImpl;

		private var dic:Dictionary;

		public static function getInstance():CursorManagerImpl
		{
			if(!_instance)
			{
				_instance = new CursorManagerImpl();
			}

			return _instance;
		}

		public function CursorManagerImpl()
		{
			if(_instance)
			{
				throw new IllegalOperationError("CursorManagerImpl is singlton");
			}

			_instance = this;
			dic = new Dictionary(true);
		}

		public function registCursor(id:String, bmd:BitmapData):void
		{
			dic[id] = bmd;
			var mcd:MouseCursorData = new MouseCursorData();
			var vec:Vector.<BitmapData> = new Vector.<BitmapData>;
			vec.push(bmd);
			mcd.data = vec;
			Mouse.registerCursor(id, mcd);
		}

		public function unregistCursor(id:String):void
		{
			delete dic[id];
			Mouse.unregisterCursor(id);
		}

		public function useCursor(id:String):void
		{
			if(id in dic)
			{
				Mouse.cursor = id;
			}
			else
			{
				Mouse.cursor = MouseCursor.AUTO;
			}
		}

		public function unuseCursor():void
		{
			Mouse.cursor = MouseCursor.AUTO;
		}
	}
}
