/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.vhall.com		
 * Created:	Jun 3, 2016 9:53:02 AM
 * ===================================
 */

package com.vhall.framework.media.video
{
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.net.NetStream;
	
	public interface IVideoPlayer
	{
		/**
		 * 推流时候获取麦克风当前的活动量
		 * @return 
		 */		
		function get micActivityLevel():Number;
		
		/**
		 * 推流时候获取摄像头当前的活动量
		 * @return 
		 */	
		function get camActivityLevel():Number;
		
		/**
		 * 获取推流摄像头，非推流状态返回null
		 * @return 
		 */		
		function get usedCam():Camera;
		
		/**
		 * 获取推流麦克风，非推流状态返回null
		 * @return 
		 */		
		function get usedMic():Microphone;
		
		/**
		 * 推流时候公开netstream，方便发送独立数据
		 * @return 
		 */		
		function get stream():NetStream;
		
		function get time():Number;
		
		/**
		 * 视频是否正在播放
		 * @return 
		 */	
		function get isPlaying():Boolean;
		
		/**
		 * 视频当前缓冲进度
		 * @return 
		 */		
		function get loaded():Number;
		/**
		 * 获取当前播放的bufferLength 
		 * @return 
		 */	
		function get bufferLength():Number;
		
		/**
		 * 视频总时长
		 * @return 
		 */		
		function get duration():Number;
		/**
		 * 视频当前播放音量
		 * @return 
		 */		
		function get volume():Number;
		/**
		 * 播放器当前类型MediaProxyType
		 * @return 
		 */		
		function get type():String;
		/**
		 * 当前播放的服务器地址或者文件路径
		 * @return 
		 */		
		function get uri():String;
		/**
		 * 直播流名称
		 * @return 
		 */		
		function get streamUrl():String;
		
		/**
		 * 当前播放状态
		 * @return 
		 */		
		function get state():String;
	}
}