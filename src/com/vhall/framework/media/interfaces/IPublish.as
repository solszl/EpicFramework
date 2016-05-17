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
		function publish(cam:*,mic:*):void;
		
		function get usedCam():Camera;
		
		function get usedMic():Microphone;
	}
}