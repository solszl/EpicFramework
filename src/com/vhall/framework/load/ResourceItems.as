package com.vhall.framework.load
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	/**
	 *	单个资源中心
	 * @author Sol
	 *
	 */
	public class ResourceItems
	{
		private static var loadedItems:Dictionary = new Dictionary();

		/**
		 * 通过路径拿到加载的内容
		 * @param key 路径
		 * @return 返回bitmap 或者 movieclip
		 *
		 */
		public static function getResource(key:String):Object
		{
			if (key in loadedItems)
			{
				return loadedItems[key];
			}

			return null;
		}

		/**
		 * 检测加载库中是否包含某路径的资源 
		 * @param key
		 * @return 
		 * 
		 */		
		public static function hasLoaded(key:String):Boolean
		{
			return key in loadedItems;
		}

		/**
		 * 添加文件到缓存中
		 * @param key 通常为路径
		 * @param content 图片为bitmap，动画为movieclip
		 * 
		 */		
		public static function addToCache(key:String, content:DisplayObject):void
		{
			if (key in loadedItems)
			{
				return;
			}

			if (content == null)
			{
				return;
			}

			loadedItems[key] = content;
		}
	}
}
