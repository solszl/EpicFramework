/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.vhall.com		
 * Created:	May 16, 2016 11:29:43 AM
 * ===================================
 */

package com.vhall.framework.media.provider
{
	import com.vhall.framework.media.interfaces.IPublish;
	
	import flash.events.NetStatusEvent;
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.MicrophoneEnhancedOptions;
	import flash.media.SoundCodec;
	import flash.media.scanHardware;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	CONFIG::LOGGING
	{
		import org.mangui.hls.utils.Log;
	}
	
	/**
	 * 推流代理
	 */	
	public class PublishProxy extends RtmpProxy implements IPublish
	{
		private var _cam:Camera;
		private var _mic:Microphone;
		
		/**
		 * 推流信息广播定时id 
		 */		
		private var _id:int;
		
		private var _useStrategy:Boolean = false;
		
		public function PublishProxy()
		{
			super();
			
			_type = MediaProxyType.PUBLISH;
			
			scanHardware();
		}
		
		override protected function statusHandler(e:NetStatusEvent):void
		{
			super.statusHandler(e);
			
			switch(e.info.code)
			{
				case InfoCode.NetStream_Play_PublishNotify:
					break;
				case InfoCode.NetStream_Publish_Start:
					sendMetadata();
					excute(MediaProxyStates.PUBLISH_NOTIFY);
					break;
				case InfoCode.NetStream_Publish_BadName:
					excute(MediaProxyStates.PUBLISH_BAD_NAME,_streamUrl);
					break;
				case InfoCode.NetStream_Unpublish_Success:
					excute(MediaProxyStates.UN_PUBLISH_SUCCESS);
					break;
				case InfoCode.NetStream_Play_UnpublishNotify:
					excute(MediaProxyStates.UN_PUBLISH_NOTIFY);
					break;
			}
		}
		
		/**
		 * 向流中发送统计数据
		 */		
		private function sendMetadata():void
		{
			//发送头信息
			var metaData:Object = {};
			metaData.server = "http://www.vhall.com";
			metaData.camera = _cam?_cam.name:"未找到";
			metaData.microphone = _mic?_mic.name:"未找到";
			if(_cam)
			{
				metaData.width = _cam.width;
				metaData.height = _cam.height;
			}
			stream && stream.send("@setDataFrame","onMetaData",metaData);
			
			//定时器发送推流统计信息
			clearInterval(_id);
			_id = setInterval(function():void
			{
				if(stream)
				{
					stream.send("@setDataFrame","onPublishData",{
						"lag":latency,"micActivityLevel":micActivityLevel,"camActivityLevel":camActivityLevel,
						"camMute":_cam?_cam.muted:false,"micMute":_mic?_mic.muted:false,"volume":_volume,"micRate":_mic?_mic.rate:0,
						"camQuality":_cam?_cam.quality:0
					});
				}
			},10000);
		}
		
		public function publish(cam:*, mic:*):void
		{
			if(cam is Camera)
			{
				_cam = cam as Camera;
			}else{
				_cam = getCameraByName(cam);
			}
			
			if(mic is Microphone)
			{
				_mic = mic as Microphone;
			}else{
				_mic = getMicrophoneByName(mic);
			}
			
			if(_cam.muted||_mic.muted)
			{
				flash.system.Security.showSettings(flash.system.SecurityPanel.PRIVACY);
				_cam.addEventListener(StatusEvent.STATUS,hardwareHandler);
			}else{
				attach();
			}
		}
		
		private function hardwareHandler(e:StatusEvent):void
		{
			if(e.code == "Camera.Unmuted")
				attach();
		}
		
		/**
		 * 获取硬件音视频源
		 */		
		private function attach():void
		{
			!_cam && excute(MediaProxyStates.NO_HARD_WARE,"Camera is not Found");
			!_mic && excute(MediaProxyStates.NO_HARD_WARE,"Microphone is not Found");
			
			_cam && _ns.attachCamera(_cam);
			_mic && _ns.attachAudio(_mic);
			
			_ns.publish(_streamUrl);
			
			//应用质量平衡策略
			_useStrategy && Strategy.get().blance(_ns,_cam,_mic);
		}
		
		public function set cameraMuted(bool:Boolean):void
		{
			if(_ns)
			{
				var catchCam:Camera = bool ? null: _cam;
				_ns.attachCamera(catchCam);
			}
		}
		
		public function set microphoneMuted(bool:Boolean):void
		{
			if(_ns)
			{
				var catchMic:Microphone = bool ? null: _mic;
				_ns.attachAudio(catchMic);
			}
		}
		
		override public function changeVideoUrl(uri:String, streamUrl:String, autoPlay:Boolean=true):void
		{
			var oldUri:String = this._uri;
			var oldStreamUrl:String = this._streamUrl;
			
			_autoPlay = autoPlay;
			_uri = uri;
			_streamUrl = streamUrl;
			
			valid();
			
			if(oldUri == uri && oldStreamUrl != streamUrl)
			{
				_ns && _ns.publish(_streamUrl);
			}else{
				//清除监听
				clearNsListeners();
				//重新链接
				try{
					_conn.connect(uri);
				}catch(e:Error){
					CONFIG::LOGGING{
						Log.error("netConnection 切换链接失败:"+_uri);
					}
				}
			}
		}
		
		public function set useStrategy(bool:Boolean):void
		{
			_useStrategy = bool;
			if(bool)
				Strategy.get().blance(_ns,_cam,_mic);
			else
				Strategy.get().unBlance();
		}
		
		override protected function clearNsListeners():void
		{
			super.clearNsListeners();
			_useStrategy && Strategy.get().unBlance();
		}
		
		override protected function gc():void
		{
			super.gc();
			clearInterval(_id);
			if(_cam && _cam.hasEventListener(StatusEvent.STATUS))
			{
				_cam.removeEventListener(StatusEvent.STATUS,hardwareHandler);
			}
			_cam = null;
			_mic = null;
		}
		
		override public function start():void
		{
			//推流取消播放功能
			_playing = true;
		}
		
		override public function stop():void
		{
			_playing = false;
			cameraMuted = microphoneMuted = false;
			super.stop();
		}
		
		override public function pause():void
		{
			_playing = false;
			cameraMuted = microphoneMuted = false;
		}
		
		override public function resume():void
		{
			_playing = true;
			cameraMuted = microphoneMuted = true;
		}
		
		override public function toggle():void
		{
			_playing = !_playing;
			
			cameraMuted = microphoneMuted = !_playing;
		}
		
		/**
		 * 获取可以使用的Camera
		 * @param name Camera名称，null或者空为获取默认Camera
		 * @return 
		 */		
		private function getCameraByName(name:String):Camera
		{
			if(Camera.isSupported)
			{
				var cam:Camera = Camera.getCamera(name==""||name==null?null:Camera.names.indexOf(name).toString());

				cam.setMode(854,480,15);
				cam.setQuality(0,75);
				cam.setKeyFrameInterval(15);
				cam.setMotionLevel(50);
				//本地显示回放是否使用压缩后的视频流，设置为true显示画面和用户更像是
				//cam.setLoopback(true);
				
				return cam;
			}
			return null;
		}
		
		/**
		 * 获取可以使用的麦克
		 * @param name 麦克名称，null或者空为获取默认麦克
		 * @return 
		 */		
		private function getMicrophoneByName(name:String):Microphone
		{
			if(Microphone.isSupported)
			{
				var mic:Microphone = Microphone.getMicrophone(name==""||name==null?-1:Microphone.names.indexOf(name));

				mic.codec = SoundCodec.SPEEX;
				mic.setSilenceLevel(0);
				mic.setUseEchoSuppression(true);//是否使用回音抑制功能
				mic.setLoopBack(false);//麦克声音不在本地回放
				mic.encodeQuality = 8;
				mic.noiseSuppressionLevel = -30;
				var micEnopt:MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions();
				micEnopt.autoGain = false;
				micEnopt.nonLinearProcessing = false;
				mic.enhancedOptions = micEnopt;
				mic.rate = 22;
				
				volume = _volume;
				
				return mic;
			}
			return null;
		}
		
		public function get usedCam():Camera
		{
			return _cam;
		}
		
		public function get usedMic():Microphone
		{
			return _mic;
		}
		
		override public function get isPlaying():Boolean
		{
			return _playing;
		}
		
		public function get micActivityLevel():Number
		{
			if(_cam) return _cam.activityLevel;
			return 0;
		}
		
		public function get camActivityLevel():Number
		{
			if(_mic) return _mic.activityLevel;
			return 0;
		}
		
		/**
		 * 设置麦克的音量
		 * @param value
		 */		
		override public function set volume(value:Number):void
		{
			super.volume = value;
			if(_mic)
			{
				//gain 0--100
				_mic.gain = value * 100;
			}
		}
		
		/**
		 * 推流延时，数字越大推流端网速越差，数值具体不代表任何其它意义
		 * @return 
		 */		
		private function get latency():Number
		{
			if(stream) return Number((stream.info.videoBufferByteLength + stream.info.audioBufferByteLength) / stream.info.maxBytesPerSecond);
			return 0;
		}
		
		override public function toString():String
		{
			return _type.toLocaleUpperCase() + " 推流LAG：" + latency.toFixed(2) + "s";
		}
	}
}