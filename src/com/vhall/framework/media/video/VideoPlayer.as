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
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.net.NetStream;
	
	CONFIG::LOGGING
	{
		import org.mangui.hls.utils.Log;
	}	
	
	/**
	 * 封装视频播放video
	 */	
	public class VideoPlayer extends Sprite implements IVideoPlayer
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
		private var _camWidth:uint = 320;
		private var _camHeight:uint = 280;
		
		private var _videoOption:VideoOptions;
		
		private var _handler:Function;
		
		/**
		 * 默认显示大小320X240
		 */		
		public function VideoPlayer()
		{
			this.mouseChildren = false;
			
			_video = new Video();
			_video.smoothing = true;
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
		public function connect(type:String,uri:String,stream:String = null,handler:Function = null,autoPlay:Boolean = true, startPostion:Number = 0):void
		{
			if(_proxy) 
			{
				CONFIG::LOGGING{
					Log.error("重复调用connect，改变流地址使用changeVideoUrl方法");
				}
				return;
			}
			_proxy = MediaProxyFactory.create(type);
			_handler = handler;		
			_type = type;
			
			//推流之外的播放器，启用图像增强
			filters = _proxy.type != MediaProxyType.PUBLISH ? [new SharpenFilter(0.1)] : [];
			
			_proxy.connect(uri,stream,proxyHandler,autoPlay,startPostion);
			
		}
		
		private function proxyHandler(states:String,...value):void
		{
			switch(states)
			{
				case MediaProxyStates.CONNECT_NOTIFY:
					if(_proxy.type == MediaProxyType.PUBLISH){
						var iPub:IPublish = _proxy as IPublish;
						iPub.publish(_cam,_mic,_camWidth,_camHeight);
						useStrategy = _videoOption.useStrategy;
					}else{
						attachView(_proxy.stream);
					}
					volume = _videoOption.volume;
					
					break;
				case MediaProxyStates.STREAM_TRANSITION:
				case MediaProxyStates.STREAM_FULL:
				case MediaProxyStates.STREAM_SIZE_NOTIFY:
					updateVideo();
					break;
				case MediaProxyStates.PUBLISH_START:
					attachView((_proxy as IPublish).usedCam);
					break;
				case MediaProxyStates.PUBLISH_NOTIFY:
					attachView(_proxy.stream);
					break;
				case MediaProxyStates.STREAM_STOP:
				case MediaProxyStates.UN_PUBLISH_NOTIFY:
					attachView(null);
					break;
				case MediaProxyStates.UN_PUBLISH_SUCCESS:
					//if(_type==MediaProxyType.PUBLISH) stop();
					break;
			}
			
			//处理外部回调业务
			if(_handler != null){
				var args:Array = value.length != 0 ? [states].concat(value):[states];
				try{
					_handler&&_handler.apply(null,args);
				}catch(e:Error){
					CONFIG::LOGGING{
						Log.warn("处理播放器外部回调" + states + "业务出错：" + e.message);
					}
				}
			}
		}
		
		/**
		 * 切换正在播放视频的视频流 
		 * @param uri
		 * @param stream
		 * @param autoPlay
		 * @param startPostion
		 */		
		public function changeVideoUrl(uri:String,stream:String = null,autoPlay:Boolean = true, startPostion:Number = 0):void
		{
			_proxy && (_proxy.changeVideoUrl(uri, stream, autoPlay,startPostion));
		}
		
		/**
		 * 将播放器切换到别的类型
		 * @param type 新的播放器类型
		 * @param uri 新的服务器地址，非rtmp为文件路径
		 * @param stream 新的流名称或者文件名，非rtmp为null
		 * @param autoPlay 是否自动播放，默认为自动播放，rtmp时设置无效
		 * @param startPostion 当操作是切换流时候，为当前播放是时间点
		 * @param cam 推流时候使用的cam名称或者实例，默认取系统默认摄像头
		 * @param mic 推流时候使用的mic名称或实例，默认取系统默认麦克风
		 * @param camWidth 采集视频宽度
		 * @param camHeight 采集视频高度
		 */		
		public function attachType(type:String,uri:String,stream:String = null,autoPlay:Boolean = true, startPostion:Number = 0, cam:* = null,mic:* = null, camWidth:uint = 320, camHeight:uint = 280):void
		{
			if(_type == type)
			{
				changeVideoUrl(uri,stream,autoPlay,startPostion);
			}else{
				if(_proxy) dispose();
				_proxy = null;
				if(type == MediaProxyType.PUBLISH)
				{
					//重回放转到推流
					publish(cam,mic,uri,stream,_handler,camWidth,camHeight);
					return;
				}
				connect(type,uri,stream,_handler,autoPlay,startPostion);
			}
		}
		
		/**
		 * 播放器推流
		 * @param cam 推流画面来源，Camera实例或者Camera名称，null或者空为去默认摄像头
		 * @param mic 推流音频来源，Microphone实例或者Microphone名称，null或者空为去默认麦克
		 * @param uri 推流服务器地址
		 * @param stream 推流流名称
		 * @param handler 处理回调函数
		 * @param camWidth 采集视频宽度
		 * @param camHeight 采集视频高度
		 */		
		public function publish(cam:*, mic:*, uri:String, stream:String, handler:Function = null, camWidth:uint = 320, camHeight:uint = 280):void
		{
			_cam = cam;
			_mic = mic;
			_cameraView = true;
			_camWidth = camWidth;
			_camHeight = camHeight;
			
			CONFIG::LOGGING
			{
				Log.info("摄像头："+_cam +
					"\n麦克风："+_mic +
					"\n尺寸:"+_camWidth+"X"+_camHeight +
					"\n地址：" + uri +
					"\n流名称:" + stream);	
			}
			connect(MediaProxyType.PUBLISH, uri, stream, handler)
		}
		
		/**
		 * 更新video尺寸，位置
		 */		
		private function updateVideo():void
		{
			drawBackground();
			var size:Object = {width:0,height:0};
			if(_cameraView)
			{
				if(_proxy && _proxy.type == MediaProxyType.PUBLISH)
				{
					var iPub:IPublish = _proxy as IPublish;
					if(iPub.usedCam)
					{
						size.width = iPub.usedCam.width;
						size.height = iPub.usedCam.height;
					}
				}
			}else{
				size.width = _video.videoWidth;
				size.height = _video.videoHeight;
			}
			var ratio:Number = Math.min(_viewPort.width/size.width,_viewPort.height/size.height);
			_video.width = size.width * ratio;
			_video.height = size.height * ratio;
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
		 * 停止视频播放
		 */		
		public function stop():void
		{
			if(_cameraView)
			{
				_video.attachCamera(null);
			}else{
				_video.attachNetStream(null);
			}
			_cameraView = false;
			_video.clear();
		}
		
		/**
		 * 销毁播放器和代理的关系，清楚最后一帧
		 */		
		public function dispose():void
		{
			//清楚视频最后一帧
			if(_proxy) _proxy.stop();
			_proxy = null;
			_type = null;
			stop();
		}
		
		override public function get visible():Boolean
		{
			return _video.visible;
		}
		
		override public function set visible(value:Boolean):void
		{
			_video.visible = value;
		}
		
		/**
		 * 非自动播放视频，在MediaProxyStates.CONNECT_NOTIFY后播放视频
		 */		
		public function start():void
		{
			if(_proxy)
			{
				_proxy.start();
				if(_proxy.type == MediaProxyType.PUBLISH){
					var iPub:IPublish = _proxy as IPublish;
					attachView(iPub.usedCam);
				}else{
					attachView(_proxy.stream);
				}
			}
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
		 * 推流时候获取麦克风当前的活动量
		 * @return 
		 */		
		public function get micActivityLevel():Number
		{
			if(_proxy && _proxy.type == MediaProxyType.PUBLISH)
				return (_proxy as IPublish).micActivityLevel;
			return 0;
		}
		
		/**
		 * 推流时候获取摄像头当前的活动量
		 * @return 
		 */	
		public function get camActivityLevel():Number
		{
			if(_proxy && _proxy.type == MediaProxyType.PUBLISH)
				return (_proxy as IPublish).camActivityLevel;
			return 0;
		}
		
		/**
		 * 设置推流端是否使用动态视频质量策略，默认关闭
		 * @param bool
		 */
		public function set useStrategy(bool:Boolean):void
		{
			_videoOption.useStrategy = bool;
			if(_proxy && _proxy.type == MediaProxyType.PUBLISH)
			{
				(_proxy as IPublish).useStrategy = bool;
			}
		}

		/**
		 * 获取推流摄像头，非推流状态返回null
		 * @return 
		 */		
		public function get usedCam():Camera
		{
			if(_proxy && _proxy.type == MediaProxyType.PUBLISH)
				return (_proxy as IPublish).usedCam;
			return null;
		}
		
		/**
		 * 获取推流麦克风，非推流状态返回null
		 * @return 
		 */		
		public function get usedMic():Microphone
		{
			if(_proxy && _proxy.type == MediaProxyType.PUBLISH)
				return (_proxy as IPublish).usedMic;
			return null;
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
		
		/**
		 * 推流时候公开netstream，方便发送独立数据
		 * @return 
		 */		
		public function get stream():NetStream
		{
			if(_proxy && _proxy.type == MediaProxyType.PUBLISH)
				return _proxy.stream;
			return null;
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
		
		/**
		 * 获取当前播放的bufferLength 
		 * @return 
		 */		
		public function get bufferLength():Number
		{
			if(stream) return stream.bufferLength;
			return 0;
		}
		
		/**
		 * 视频总时长
		 * @return 
		 */		
		public function get duration():Number
		{
			if(_proxy) return _proxy.duration;
			return 0;
		}
		
		public function get volume():Number
		{
			return _videoOption.volume;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function get uri():String
		{
			if(!_proxy) return "";
			return _proxy.uri;
		}
		
		public function get streamUrl():String
		{
			if(!_proxy) return "";
			return _proxy.streamUrl;
		}
		
		/**
		 * 视频音量
		 * @param value
		 */		
		public function set volume(value:Number):void
		{
			_videoOption.volume = Math.max(0,Math.min(2,value));
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
import flash.filters.ConvolutionFilter;

class VideoOptions
{
	public var volume:Number = 0.68;
	
	public var useStrategy:Boolean = false;
	
	private static var _instance:VideoOptions;
	
	public static function get op():VideoOptions
	{
		return _instance ||= new VideoOptions();
	}
}

class SharpenFilter extends ConvolutionFilter {
	// Protected Properties:
	protected var _amount:Number;
	
	// Initialization:
	/**
	 * Constructs a new SharpenFilter instance.
	 **/
	public function SharpenFilter(amount:Number) {
		super(3,3,[0,0,0,0,1,0,0,0,0],1);
		this.amount = amount;
	}
	
	// Public getter / setters:
	/**
	 * A number between 0 and 1 indicating the amount of sharpening to apply.
	 **/
	public function set amount(amount:Number):void {
		_amount = amount;
		var a:Number = amount/-1;
		var b:Number = amount/-2;
		var c:Number = a*-4+b*-4+1;
		matrix = [b,a,b,
			a,c,a,
			b,a,b];
		
		//滤波值：-4，-8
		/*matrix = [0,1,0,
			1,-4,1,
			0,1,0];*/
	}
	public function get amount():Number { return _amount; }
	
}
