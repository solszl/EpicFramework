/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.vhall.com		
 * Created:	Jun 6, 2016 5:56:23 PM
 * ===================================
 */

﻿package com.vhall.framework.ui.utils
{
	import flash.text.Font;
	import flash.text.FontType;
	import flash.utils.Dictionary;
	
	/**
	 * 默认字体工具
	 * @author iDzeir
	 */	
	public class FontUtil
	{
		private static var _recommendFont:String = null;
		
		private static var _map:Dictionary = new Dictionary(true);
		/**
		 * 返回系统默认字体
		 * @return 
		 */		
		public static function get f():String
		{
			return "微软雅黑,Microsoft YaHei,宋体,SimSun,苹方-简,PingFang,黑体,SimHei,_sans,_serif,_typewriter";
		}
		/** 
		 * 默认推荐字体
		 */		
		public static function get recommendFont():String
		{
			if(_recommendFont!=null) return _recommendFont;
			//系统字体
			var sysFontMap:Array = Font.enumerateFonts(true);
			sysFontMap.forEach(function(e:Font,index:int,arr:Array):void
			{
				_map[e.fontName] = e.fontType == FontType.DEVICE;
			});
			//推荐字体
			var _recMap:Array = f.split(",");
			_recommendFont = (sysFontMap[0] as Font).fontName;
			for each(var i:String in _recMap)
			{
				if(_map[i]==true)
				{
					_recommendFont = i;
					break;
				}
			}
			return _recommendFont;
		}
		/**
		 * 判断系统是否有默认字体
		 * @param font
		 */		
		public static function has(font:String):Boolean
		{
			if(_recommendFont!=null)
				_recommendFont = recommendFont;
			return _map.hasOwnProperty(font)?_map.hasOwnProperty(font):false;
		}
	}
}