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
		
		/**
		 * 计时器id 
		 */		
		private var _id:int;
		
		/**
		 * 连续存在缓存秒数（计时器为每秒执行） 
		 */		
		private var _bufferTimes:int = 0;
		
		/**
		 * 连续空buffer秒次数（计时器为每秒执行）
		 */		
		private var _emptyTimes:int = 0;
		
		/**
		 * 触发调整画面质量的临界连续次数 
		 */		
		private const MAX:uint = 8;
		
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
			},1000);
		}
		
		private function blanceVideoWithBuffer(buffer:int):void
		{
			if(!_cam) return;
			buffer == 0 ? minus() : add();
		}
		
		private function blanceAudioWithBuffer(buffer:int):void
		{
			
		}
		
		private function add():void
		{
			//连续buffer
			if(++_bufferTimes >= MAX)
			{
				const LOW:int = 5;
				_bufferTimes = 0;
				_cam.quality > LOW && _cam.setQuality(_cam.bandwidth,Math.max(LOW,(LOW + _cam.quality)>>1))
			}
			_emptyTimes = 0;
		}
		
		private function minus():void
		{
			//连续空buffer
			if(++_emptyTimes >= MAX)
			{
				const BEST:int = 100;
				_emptyTimes = 0;
				_cam.quality < BEST && _cam.setQuality(_cam.bandwidth,Math.min(BEST,(BEST + _cam.quality)>>1));
			}
			_bufferTimes = 0;
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