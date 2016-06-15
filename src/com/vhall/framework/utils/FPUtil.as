/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.vhall.com		
 * Created:	Jun 15, 2016 3:14:22 PM
 * ===================================
 */

package com.vhall.framework.utils
{
	import flash.system.Capabilities;

	/**
	 * 获取flashplayer信息
	 */	
	public class FPUtil
	{
		/**
		 * 当前flashplayer版本
		 */		
		public static function get version():Number {
			var versionString:String = Capabilities.version;
			var pattern:RegExp = /^(\w*) (\d*),(\d*),(\d*),(\d*)$/;
			var result:Object = pattern.exec(versionString);
			if (result != null) {
				//	trace("input: " + result.input);
				//	trace("platform: " + result[1]);
				//	trace("majorVersion: " + result[2]);
				//	trace("minorVersion: " + result[3]);    
				//	trace("buildNumber: " + result[4]);
				//	trace("internalBuildNumber: " + result[5]);
				return Number(result[2] + "." + result[3]);
			} else {
				//	trace("Unable to match RegExp.");
				return 0;
			}		
		}
		
		/**
		 * 验证当前flash版本是否大于指定版本
		 * @param v 比较的版本
		 * @return 大于返回true否则返回false
		 */		
		public static function vaild(v:Number):Boolean
		{
			return version >= v;
		}
	}
}