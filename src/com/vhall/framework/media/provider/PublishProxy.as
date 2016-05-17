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
	
	import flash.events.ActivityEvent;
	import flash.events.NetStatusEvent;
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	
	public class PublishProxy extends RtmpProxy implements IPublish
	{
		private var _cam:Camera;
		private var _mic:Microphone;
		
		public function PublishProxy()
		{
			super();
			
			_type = MediaProxyType.PUBLISH;
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
					break;
				case InfoCode.NetStream_Unpublish_Success:
					break;
				case InfoCode.NetStream_Play_UnpublishNotify:
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
			
			if(_cam.muted)
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
				cam.setMode(800,600,60);
				cam.setQuality(0,100);
				return cam;
			}
			return null;
		}
		
		private function getMicrophoneByName(name:String):Microphone
		{
			if(Microphone.isSupported)
			{
				return Microphone.getMicrophone(Microphone.names.indexOf(name));
			}
			return null;
		}
		
		public function get usedCam():Camera
		{
			return _cam;
		}
	}
}