package com.vhall.framework.ui.manager
{
	import flash.display.BitmapData;
	import flash.geom.Point;

	/**
	 * 光标管理器
	 * @author Sol
	 * @date 2016-08-19 12:29:36
	 */
	public class CursorManager
	{
		/**
		 * 注册光标
		 * @param id
		 * @param bmd
		 * @param hotSpot offset
		 */
		public static function registCursor(id:String, bmd:BitmapData, hotSpot:Point = null):void
		{
			CursorManagerImpl.getInstance().registCursor(id, bmd, hotSpot);
		}

		/**
		 * 卸载光标
		 * @param id
		 *
		 */
		public static function unregistCursor(id:String):void
		{
			CursorManagerImpl.getInstance().unregistCursor(id);
		}

		/**
		 * 使用编号为id的光标，如果没有，则自动
		 * @param id
		 *
		 */
		public static function useCursor(id:String):void
		{
			CursorManagerImpl.getInstance().useCursor(id);
		}

		/**
		 * 使光标恢复正常
		 *
		 */
		public static function unuseCursor():void
		{
			CursorManagerImpl.getInstance().unuseCursor();
		}
	}
}
