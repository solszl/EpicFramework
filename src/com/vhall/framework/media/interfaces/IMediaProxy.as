/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.vhall.com		
 * Created:	May 16, 2016 10:22:47 AM
 * ===================================
 */

package com.vhall.framework.media.interfaces
{
	import flash.net.NetStream;

	public interface IMediaProxy
	{
		function get type():String;
		
		function get isPlaying():Boolean;
		
		function get autoPlay():Boolean;
		
		function connect(uri:String, streamUrl:String = null, handler:Function = null,autoPlay:Boolean = true):void;
		
		function start():void;
		
		function get volume():Number;
		
		function set volume(value:Number):void;
		
		function get streamUrl():String;
		
		function get uri():String;
		
		function get duration():Number;
		
		function get time():Number;
		
		function set time(value:Number):void;
		
		function get stream():NetStream;
		
		function stop():void;
		
		function pause():void;
		
		function resume():void;
		
		function toggle():void;
	}
}