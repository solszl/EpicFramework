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
			if(key in loadedItems)
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
		 * @param forceUpdate 是否强制刷新
		 *
		 */
		public static function addToCache(key:String, content:Object, forceUpdate:Boolean = false):void
		{
			if(content == null)
			{
				return;
			}

			if(key in loadedItems)
			{
				if(forceUpdate == true)
				{
					loadedItems[key] = content;
				}

				return;
			}

			loadedItems[key] = content;
		}
	}
}
