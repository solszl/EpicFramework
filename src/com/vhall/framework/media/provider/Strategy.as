/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.vhall.com		
 * Created:	May 27, 2016 10:40:20 AM
 * ===================================
 */

package com.vhall.framework.media.provider
{
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.net.NetStream;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	/**
	 *  视频质量制动平衡机制，需要优化算法
	 */	
	internal final class Strategy
	{
		private static var _instance:Strategy;
		
		private var _ns:NetStream;
		private var _cam:Camera;
		private var _mic:Microphone;
		
		private var _id:int;
		
		public static function get():Strategy
		{
			return _instance ||= new Strategy();
		}
		
		
		/**
		 * 根据推流网络状况动态平衡采集质量
		 * @param ns 推流netstream
		 * @param cam 推流使用的Camera，平衡范围30~100
		 * @param mic 暂时未对音频采集使用策略
		 */		
		public function blance(ns:NetStream,cam:Camera,mic:Microphone = null):void
		{
			unBlance();
			
			_ns = ns;
			_cam = cam;
			_mic = mic;
			
			_id = setInterval(function():void
			{
				if(_ns && _ns.info)
				{
					blanceVideoWithBuffer(_ns.info.videoBufferByteLength);
					blanceAudioWithBuffer(_ns.info.audioBufferByteLength);
				}
			},2000);
		}
		
		private function blanceVideoWithBuffer(buffer:int):void
		{
			if(!_cam) return;
			if(buffer == 0) 
				_cam.quality < 100 && _cam.setQuality(_cam.bandwidth,Math.min(100,_cam.quality + 4));
			else
				_cam.quality > 30 && _cam.setQuality(_cam.bandwidth,Math.max(30,_cam.quality - 10));
		}
		
		private function blanceAudioWithBuffer(buffer:int):void
		{
			
		}
		
		public function unBlance():void
		{
			_ns = null;
			_cam = null;
			_mic = null;
			clearInterval(_id);
		}
	}
}