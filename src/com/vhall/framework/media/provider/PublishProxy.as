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
	import flash.utils.setInterval;
	
	public class PublishProxy extends RtmpProxy implements IPublish
	{
		private var _cam:Camera;
		private var _mic:Microphone;
		
		public function PublishProxy()
		{
			super();
			
			_type = MediaProxyType.PUBLISH;
			
			scanHardware();
		}
		
		override public function start():void
		{
			//推流取消播放功能
		}
		
		override protected function statusHandler(e:NetStatusEvent):void
		{
			super.statusHandler(e);
			
			switch(e.info.code)
			{
				case InfoCode.NetStream_Play_PublishNotify:
					break;
				case InfoCode.NetStream_Publish_Start:
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
				_cam.addEventListener(StatusEvent.STATUS,function(e:StatusEvent):void
				{
					if(e.code == "Camera.Unmuted")
					{
						_ns.attachCamera(_cam);
						_ns.attachAudio(_mic);
						_ns.publish(_streamUrl);
					}
				});
				
			}else{
				_ns.attachCamera(_cam);
				_ns.attachAudio(_mic);
				_ns.publish(_streamUrl);
			}
		}
		
		private function getCameraByName(name:String):Camera
		{
			if(Camera.isSupported)
			{
				var cam:Camera = Camera.getCamera(Camera.names.indexOf(name).toString());
				
				cam.setMode(854,480,15);
				cam.setQuality(0,75);
				cam.setKeyFrameInterval(15);
				
				return cam;
			}
			return null;
		}
		
		private function getMicrophoneByName(name:String):Microphone
		{
			if(Microphone.isSupported)
			{
				var mic:Microphone = Microphone.getMicrophone(Microphone.names.indexOf(name));
				
				mic.codec = SoundCodec.SPEEX;
				mic.setSilenceLevel(0);
				mic.encodeQuality = 8;
				mic.noiseSuppressionLevel = -30;
				var micEnopt:MicrophoneEnhancedOptions = new MicrophoneEnhancedOptions();
				micEnopt.autoGain = false;
				micEnopt.nonLinearProcessing = false;
				mic.enhancedOptions = micEnopt;
				
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
		
		override public function set volume(value:Number):void
		{
			super.volume = value;
			if(_mic)
			{
				//gain 0--100
				_mic.gain = value * 100;
			}
		}
	}
}