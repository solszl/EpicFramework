package com.vhall.framework.ui.manager
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class PopupManager
	{
		public function PopupManager()
		{
			throw new Error("PopupManager is static class!");
		}
		
		public static function addPopup(obj:DisplayObject, parent:DisplayObjectContainer = null, center:Boolean = true, useModal:Boolean = true):DisplayObject
		{
			return PopupManagerImpl.getInstance().addPopup(obj, parent, center, useModal);
		}
		
		public static function toTop(obj:DisplayObject):DisplayObject
		{
			return PopupManagerImpl.getInstance().toTop(obj);	
		}
		
		public static function removePopup(obj:DisplayObject):DisplayObject
		{
			return PopupManagerImpl.getInstance().removePopup(obj);			
		}
	}
}