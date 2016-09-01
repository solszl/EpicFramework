package com.vhall.framework.utils
{
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	/**
	 * 浏览器工具类
	 * @author Sol
	 * @date 2016-08-29 16:09:52
	 */
	public class BrowserUtil
	{
		private static var regWebkit:RegExp = new RegExp("(webkit)[ \\/]([\\w.]+)", "i");

		/**
		 * 获取浏览器信息（UserAgent）
		 */
		public static function get userAgent():String
		{
			if(!ExternalInterface.available)
			{
				return "external interface is not available";
			}
			var returnValue:String = ExternalInterface.call("function BrowserAgent(){return navigator.userAgent;}");
			return (returnValue ? returnValue : "");
		}

		/**
		 * 打开一个新的URL
		 * @param url 地址
		 * @param newTab 是否在新页签打开、单页签的浏览器打开一个新窗口，否则打开一个新页签
		 *
		 */
		public static function openURL(url:String, newTab:Boolean = true):void
		{
			var method:String = newTab ? "_blank" : "_self";
			navigateToURL(new URLRequest(url), method);
		}
	}
}
