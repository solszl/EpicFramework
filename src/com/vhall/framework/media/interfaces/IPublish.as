/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.vhall.com		
 * Created:	May 16, 2016 11:19:22 AM
 * ===================================
 */

package com.vhall.framework.media.interfaces
{
	import flash.media.Camera;
	import flash.media.Microphone;

	public interface IPublish
	{
		/**
		 * 从cam和mic指定的硬件获取视频和音频 
		 * @param cam 摄像头名称或者摄像头实例，null或者“”时为默认摄像头
		 * @param mic 麦克风名称或者麦克风实例，null或者“”时为默认麦克
		 * @param camWidth 采集视频宽度
		 * @param camHeight 采集视频高度
		 */	
		function publish(cam:*,mic:*, camWidth:uint = 320, camHeight:uint = 280):void;
		
		/**
		 * 返回推流使用的Camera
		 */		
		function get usedCam():Camera;
		
		/**
		 * 返回推流使用的麦克
		 * @return 
		 */		
		function get usedMic():Microphone;
		
		/**
		 * 当前麦克风的活动状态量
		 * @return 
		 */		
		function get micActivityLevel():Number;
		
		/**
		 * 当前摄像头的活动状态量
		 * @return 
		 */		
		function get camActivityLevel():Number;
		
		/**
		 * 关闭摄像头采集
		 * @param bool
		 */		
		function set cameraMuted(bool:Boolean):void;
		
		/**
		 * 关闭麦克风采集
		 * @param bool
		 */		
		function set microphoneMuted(bool:Boolean):void;
		
		/**
		 * 设置推流端是否使用动态视频质量策略，默认关闭
		 * @param bool
		 */		
		function set useStrategy(bool:Boolean):void;
	}
}