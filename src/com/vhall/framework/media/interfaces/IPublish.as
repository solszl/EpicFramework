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
		 */	
		function publish(cam:*,mic:*):void;
		
		/**
		 * 返回推流使用的Camera
		 */		
		function get usedCam():Camera;
		
		/**
		 * 返回推流使用的麦克
		 * @return 
		 */		
		function get usedMic():Microphone;
	}
}