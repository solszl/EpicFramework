/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.vhall.com		
 * Created:	May 16, 2016 11:41:26 AM
 * ===================================
 */

package com.vhall.framework.media.video
{
	import com.vhall.framework.media.interfaces.IMediaProxy;
	import com.vhall.framework.media.interfaces.IPublish;
	import com.vhall.framework.media.provider.MediaProxyFactory;
	import com.vhall.framework.media.provider.MediaProxyStates;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	
	public class VideoPlayer extends Sprite
	{
		private var _video:Video;
		
		private var _type:String;
		
		private var _proxy:IMediaProxy;
		
		private var _videoToW:Number;
		private var _videoToH:Number;
		
		private var _cameraView:Boolean = false;
		
		public function VideoPlayer()
		{
			_video = new Video();
			_videoToW = _video.width;
			_videoToH = _video.height;
			
			addChild(_video);
		}
		
		public static function create():VideoPlayer
		{
			return new VideoPlayer();
		}
		
		public function connect(type:String,uri:String,stream:String = null,handler:Function = null,autoPlay:Boolean = true):void
		{
			_proxy = MediaProxyFactory.create(type);
			_proxy.connect(uri,stream,function(states:String,...value):void
			{
				switch(states)
				{
					case MediaProxyStates.CONNECT_NOTIFY:
						attachView(_proxy.stream);
						break;
					case MediaProxyStates.STREAM_SIZE_NOTIFY:
						updateVideo();
						break;
					case MediaProxyStates.PUBLISH_NOTIFY:
						_video.attachCamera((_proxy as IPublish).usedCam);
						break;
				}
			},autoPlay);
		}
		
		private function updateVideo():void
		{
			if(_cameraView)
			{
				_video.width = _videoToW;
				_video.height = _videoToH;
				_video.x = _video.y = 0;
				return;
			}
			var ratio:Number = Math.min(_videoToW/_video.videoWidth,_videoToH/_video.videoHeight);
			
			_video.width = _video.videoWidth*ratio;
			_video.height = _video.videoHeight*ratio;
			
			_video.x = _videoToW - _video.width >> 1;
			_video.y = _videoToH - _video.height >> 1;
		}
		
		public function attachView(source:*):void
		{
			if(source is Camera)
			{
				_video.attachCamera(source);
				_cameraView = true;
				updateVideo();
			}else{
				_video.attachNetStream(source);
				_cameraView = false;
			}
		}
		
		public function set viewPort(port:Rectangle):void
		{
			_videoToW = port.width;
			_videoToH = port.height;
			updateVideo();
		}
		
		override public function set width(value:Number):void
		{
			super.width = value;
		}
		
		override public function set height(value:Number):void
		{
			super.height = value;
		}
		
		override public function set x(value:Number):void
		{
			super.x = value;
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
		}
	}
}