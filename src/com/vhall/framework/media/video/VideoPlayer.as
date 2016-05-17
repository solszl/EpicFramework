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
	import com.vhall.framework.media.provider.MediaProxyType;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	
	CONFIG::LOGGING
	{
		import org.mangui.hls.utils.Log;
	}	
	
	/**
	 * 封装视频播放video
	 */	
	public class VideoPlayer extends Sprite
	{
		private var _video:Video;
		
		private var _type:String;
		
		private var _proxy:IMediaProxy;
		
		private var _videoToW:Number;
		private var _videoToH:Number;
		
		private var _cameraView:Boolean = false;
		
		/**
		 * 推流时候使用的摄像头和麦克 
		 */		
		private var _cam:*;
		private var _mic:*;
		
		public function VideoPlayer()
		{
			this.mouseChildren = false;
			
			_video = new Video();
			_videoToW = _video.width;
			_videoToH = _video.height;
			
			addChild(_video);
		}
		
		/**
		 * 创建一个视频播放器
		 * @return 
		 */		
		public static function create():VideoPlayer
		{
			return new VideoPlayer();
		}
		
		/**
		 * 链接通道，播放流
		 * @param type 播放器播放类型
		 * @param uri 播放服务器地址
		 * @param stream 播放流名称
		 * @param handler 回调处理函数
		 * @param autoPlay 是否自动播放，直播时候忽略
		 */		
		public function connect(type:String,uri:String,stream:String = null,handler:Function = null,autoPlay:Boolean = true):void
		{
			_proxy = MediaProxyFactory.create(type);
			
			_proxy.connect(uri,stream,function(states:String,...value):void
			{
				switch(states)
				{
					case MediaProxyStates.CONNECT_NOTIFY:
						if(_proxy.type == MediaProxyType.PUBLISH){
							var iPub:IPublish = _proxy as IPublish;
							iPub.publish(_cam,_mic);
						}else{
							attachView(_proxy.stream);
						}
						break;
					case MediaProxyStates.STREAM_SIZE_NOTIFY:
						updateVideo();
						break;
					case MediaProxyStates.PUBLISH_NOTIFY:
						_video.attachCamera((_proxy as IPublish).usedCam);
						break;
				}
				
				if(handler != null){
					var args:Array = value.length != 0 ? [states].concat(value):[states];
					try{
						handler&&handler.apply(null,args);
					}catch(e:Error){
						CONFIG::LOGGING{
							Log.warn("处理播放器外部回调" + states + "业务出错：" + e.message);
						}
					}
				}
			},autoPlay);
		}
		
		/**
		 * 播放器推流
		 * @param cam 推流画面来源，Camera实例或者Camera名称，null或者空为去默认摄像头
		 * @param mic 推流音频来源，Microphone实例或者Microphone名称，null或者空为去默认麦克
		 * @param uri 推流服务器地址
		 * @param stream 推流流名称
		 * @param handler 处理回调函数
		 */		
		public function publish(cam:*, mic:*, uri:String, stream:String,handler:Function = null):void
		{
			_cam = cam;
			_mic = mic;
			_cameraView = true;
			connect(MediaProxyType.PUBLISH, uri, stream, handler)
		}
		
		/**
		 * 更新video尺寸，位置
		 */		
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
		
		/**
		 * 播放器获得视频来源
		 * @param source Camera或者netStream
		 */		
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
		
		/**
		 * 设置播放器显示矩形
		 * @param port
		 */		
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