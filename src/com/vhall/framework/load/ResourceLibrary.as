package com.vhall.framework.load
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	/**
	 *	资源中心,对于加载swf包 缓存用的
	 * @author Sol
	 * 
	 */	
	public class ResourceLibrary
	{
		
		/**
		 * 素材包列表，以ResourceType为key.
		 */
		private static var librayList:Dictionary=new Dictionary();
		
		/**
		 * 获取素材包中的一个 Bitmap
		 * @param key
		 * @param type
		 * @return
		 *
		 */
		public static function getBitmap(key:String, type:String=null):Bitmap
		{
			var bmd:BitmapData=getBitmapData(key, type);
			
			if (bmd)
			{
				return new Bitmap(bmd);
			}
			
			return null;
		}
		
		/**
		 * 获取素材包中的一个 BitmapData
		 * @param key
		 * @param type
		 * @return
		 *
		 */
		public static function getBitmapData(key:String, type:String=null):BitmapData
		{
			var cls:Class=getClass(key,type);
			if (cls && getQualifiedSuperclassName(cls) == getQualifiedClassName(BitmapData))
			{
				return new cls(1, 1);
			}
			
			return null;
		}
		
		/**
		 * 获取素材包中的一个类
		 * @param key
		 * @param type
		 * @return
		 *
		 */
		public static function getClass(key:String, type:String=null):Class
		{
			var lib:Object;
			if (type == null)
			{
				for (var item:String in librayList)
				{
					lib=librayList[item];
					if (key in lib)
					{
						return lib[key];
					}
				}
			}
			else
			{
				if (type in librayList)
				{
					lib=librayList[type] as Object;
					if (key in lib)
					{
						return lib[key];
					}
				}
			}
			return null;
		}
		
		/**
		 * 添加打包后的素材库
		 * @param type
		 * @param lib
		 *
		 */
		public static function addLibrary(type:String, lib:Object):void
		{
			if(type in librayList)
				trace("资源覆盖！",type);
			
			librayList[type]=lib;
		}
		
		/**
		 *	从资源库中删除资源 
		 * @param key
		 * 
		 */		
		public static function removeFromLibrary(key:String):void
		{
			if(librayList[key])
			{
				delete librayList[key];
			}
		}
	}
}