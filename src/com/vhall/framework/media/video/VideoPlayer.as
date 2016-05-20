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
	import com.vhall.framework.media.interfaces.IProgress;
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
		
		private var _viewPort:Rectangle;
		
		private var _cameraView:Boolean = false;
		
		private var _backgroundColor:int = 0x000000;
		
		/**
		 * 推流时候使用的摄像头和麦克 
		 */		
		private var _cam:*;
		private var _mic:*;
		
		private var _videoOption:VideoOptions;
		
		/**
		 * 默认显示大小320X240
		 */		
		public function VideoPlayer()
		{
			this.mouseChildren = false;
			
			_video = new Video();
			addChild(_video);
			
			_viewPort = _video.getBounds(this);
			
			_videoOption = VideoOptions.op;
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
						volume = _videoOption.volume;
						break;
					case MediaProxyStates.STREAM_SIZE_NOTIFY:
						updateVideo();
						break;
					case MediaProxyStates.PUBLISH_NOTIFY:
						_video.attachCamera((_proxy as IPublish).usedCam);
						break;
				}
				
				//处理外部回调业务
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
		 * 切换正在播放视频的视频流 
		 * @param uri
		 * @param stream
		 * @param autoPlay
		 */		
		public function changeVideoUrl(uri:String,stream:String = null,autoPlay:Boolean = true):void
		{
			_proxy && (_proxy.changeVideoUrl(uri, stream, autoPlay));
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
			drawBackground();
			
			if(_cameraView)
			{
				_video.width = _viewPort.width;
				_video.height = _viewPort.height;
				_video.x = _viewPort.left + (_viewPort.width - _video.width >> 1);
				_video.y = _viewPort.top + (_viewPort.height - _video.height >> 1);
				return;
			}
			var ratio:Number = Math.min(_viewPort.width/_video.videoWidth,_viewPort.height/_video.videoHeight);
			
			_video.width = _video.videoWidth*ratio;
			_video.height = _video.videoHeight*ratio;
			
			_video.x = _viewPort.left + (_viewPort.width - _video.width >> 1);
			_video.y = _viewPort.top + (_viewPort.height - _video.height >> 1);
		}
		
		/**
		 * 绘制视频设置区域
		 * @param alpha
		 */		
		private function drawBackground(alpha:Number = 1):void
		{
			this.graphics.clear();
			this.graphics.beginFill(_backgroundColor,alpha);
			this.graphics.drawRect(_viewPort.left,_viewPort.top,_viewPort.width,_viewPort.height);
			this.graphics.endFill();
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
		 * 非自动播放视频，在MediaProxyStates.CONNECT_NOTIFY后播放视频
		 */		
		public function start():void
		{
			_proxy && _proxy.start();
		}
		
		/**
		 * 视频暂停
		 */		
		public function pause():void
		{
			_proxy && _proxy.pause();
		}
		
		/**
		 * 视频暂停恢复
		 */		
		public function resume():void
		{
			_proxy && _proxy.resume();
		}
		
		/**
		 * 切换视频播放状态，暂停/恢复
		 */		
		public function toggle():void
		{
			_proxy && _proxy.toggle();
			
			if(this._cameraView && _proxy)
			{
				//_video.clear();
				//_video.attachCamera(this.isPlaying?((_proxy as IPublish).usedCam):null);
			}
		}
		
		/**
		 * 推流成功后开关视频采集
		 * @param bool
		 */		
		public function set cameraMuted(bool:Boolean):void
		{
			if(_proxy && _proxy.type == MediaProxyType.PUBLISH)
				(_proxy as IPublish).cameraMuted = bool;
		}
		
		/**
		 * 推流成功后开关音频采集
		 * @param bool
		 */		
		public function set microphoneMuted(bool:Boolean):void
		{
			if(_proxy && _proxy.type == MediaProxyType.PUBLISH)
				(_proxy as IPublish).microphoneMuted = bool;
		}
		
		/**
		 * 播放器背景颜色,默认为黑色0xFFFFFF
		 * @param value 0~0xFFFFFF
		 */		
		public function set backgroundColor(value:int):void
		{
			_backgroundColor = Math.min(0xFFFFFF,Math.max(0,value));
			drawBackground();
		}
		
		/**
		 * 播放器背景颜色透明度
		 * @param value 0~1
		 */		
		public function set backgroundAlpha(value:Number):void
		{
			drawBackground(Math.min(1,Math.max(0,value)));
		}
		
		/**
		 * 设置播放器显示矩形
		 * @param port
		 */		
		public function set viewPort(port:Rectangle):void
		{
			_viewPort.copyFrom(port);
			updateVideo();
		}
		
		public function get time():Number
		{
			if(_proxy) return _proxy.time;
			return 0;
		}
		/**
		 * 视频播放时间
		 * @param value
		 */		
		public function set time(value:Number):void
		{
			if(_proxy)
			{
				if([MediaProxyType.HLS,MediaProxyType.HTTP].indexOf(_proxy.type) != -1)
				{
					_proxy.time = value;
				}
			}else{
				_videoOption.time = value;
			}
		}
		
		/**
		 * 视频是否正在播放
		 * @return 
		 */		
		public function get isPlaying():Boolean
		{
			if(_proxy) return _proxy.isPlaying;
			return false;
		}
		
		public function get autoPlay():Boolean
		{
			if(_proxy) return _proxy.autoPlay;
			return false;
		}
		
		/**
		 * 视频当前缓冲进度
		 * @return 
		 */		
		public function get loaded():Number
		{
			if(_proxy.type == MediaProxyType.HTTP) return (_proxy as IProgress).loaded();
			return 0;
		}
		
		public function get volume():Number
		{
			return _videoOption.volume;
		}
		
		/**
		 * 视频音量
		 * @param value
		 */		
		public function set volume(value:Number):void
		{
			_videoOption.volume = Math.max(0,Math.min(1,value));
			if(_proxy) _proxy.volume = _videoOption.volume;
		}
		
		override public function set width(value:Number):void
		{
			_viewPort.width = value;
			updateVideo();
		}
		
		override public function get width():Number
		{
			return _viewPort.width;
		}
		
		override public function set height(value:Number):void
		{
			_viewPort.height = value;
			updateVideo();
		}
		
		override public function get height():Number
		{
			return _viewPort.height;
		}
		
		override public function set x(value:Number):void
		{
			_viewPort.x = value;
			updateVideo();
		}
		
		override public function get x():Number
		{
			return _viewPort.left;
		}
		
		override public function set y(value:Number):void
		{
			_viewPort.y = value;
			updateVideo();
		}
		
		override public function get y():Number
		{
			return _viewPort.top;
		}
		
		override public function toString():String
		{
			return "[VideoPlayer " + String(_proxy)+"]";
		}
	}
}

class VideoOptions
{
	public var volume:Number = 0.68;
	public var time:Number = 0;
	
	private static var _instance:VideoOptions;
	
	public static function get op():VideoOptions
	{
		return _instance ||= new VideoOptions();
	}
}
