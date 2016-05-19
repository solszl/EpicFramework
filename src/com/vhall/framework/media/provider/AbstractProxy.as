/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.vhall.com		
 * Created:	May 16, 2016 10:30:07 AM
 * ===================================
 */

package com.vhall.framework.media.provider
{
	import com.vhall.framework.media.interfaces.IMediaProxy;
	
	import flash.net.NetStream;
	
	CONFIG::LOGGING{
		import org.mangui.hls.utils.Log;
	}
	
	/**
	 * 视频播放推拉流抽象类
	 */
	public class AbstractProxy implements IMediaProxy
	{
		protected var _type:String;
		
		protected var _playing:Boolean = false;
		
		protected var _autoPlay:Boolean = false;
		
		protected var _volume:Number = .6;
		
		protected var _duration:Number = 0;
		
		protected var _streamUrl:String;
		
		protected var _uri:String;
		
		protected var _handler:Function = null;

		private var _bufferTimeMax:Number;

		private var _bufferTime:Number;

		private var _inBufferSeek:Boolean;
		
		public function AbstractProxy(type:String)
		{
			_type = type;
		}
		
		/**
		 * 创建流方法，需子类重写
		 */		
		protected function createStream():void
		{
			
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function get isPlaying():Boolean
		{
			return _playing;
		}
		
		public function get autoPlay():Boolean
		{
			return _autoPlay;
		}
		
		public function connect(uri:String, streamUrl:String=null, handler:Function=null, autoPlay:Boolean = true):void
		{
			_autoPlay = autoPlay;
			_uri = uri;
			_streamUrl = streamUrl;
			_handler = handler;
			
			valid();
		}
		
		public function changeVideoUrl(uri:String, streamUrl:String, autoPlay:Boolean = true):void
		{
			_autoPlay = autoPlay;
			_uri = uri;
			_streamUrl = streamUrl;
			
			valid();
		}
		
		protected function valid():void
		{
			//简单验证协议和代理是否匹配
			if(_type == MediaProxyType.HLS)
			{
				const p:String = uri.replace(/\?.+/ig,"");
				const exName:String = ".m3u8";
				const lastIndexExName:int = p.length - exName.length;
				if(lastIndexExName >= 0 && lastIndexExName == p.indexOf(exName)){
					return;
				}
				CONFIG::LOGGING{
					Log.warn("代理和协议地址不匹配："+_type+"类型代理不能播放"+uri);
				}
			}else if(_type == MediaProxyType.RTMP && uri.indexOf("rtmp://") != 0){
				CONFIG::LOGGING{
					Log.warn("代理和协议地址不匹配："+_type+"类型代理不能播放"+uri);
				}
			}
		}
		
		public function start():void
		{
			_playing = true;
		}
		
		/**
		 * 回收资源
		 */		
		protected function gc():void
		{
			_playing = false;
		}
		
		/**
		 * 处理回调
		 * @param type 状态码MediaProxyType
		 * @param data 可选参数0到多个
		 */		
		protected function excute(type:String, ...data):void
		{
			if(_handler!=null&&_handler is Function)
			{
				var args:Array = data.length != 0 ? [type].concat(data):[type];
				_handler&&_handler.apply(null,args);
			}
		}
		
		public function set bufferTimeMax(value:Number):void
		{
			_bufferTimeMax = value;
			stream && (stream.bufferTimeMax = value);
		}
		
		public function set bufferTime(value:Number):void
		{
			_bufferTime = value;
			stream && (stream.bufferTime = value);
		}
		
		public function set inBufferSeek(bool:Boolean):void
		{
			_inBufferSeek = bool;
			stream && (stream.inBufferSeek = bool);
		}
		
		public function get volume():Number
		{
			return _volume;
		}
		
		public function set volume(value:Number):void
		{
			_volume = value;
		}
		
		public function get streamUrl():String
		{
			return _streamUrl;
		}
		
		public function get uri():String
		{
			return _uri;
		}
		
		public function get duration():Number
		{
			return _duration;
		}
		
		public function get time():Number
		{
			return 0;
		}
		
		public function set time(value:Number):void
		{
		}
		
		public function get stream():NetStream
		{
			return null;
		}
		
		public function stop():void
		{
			_playing = false;
		}
		
		public function pause():void
		{
			_playing = false;
		}
		
		public function resume():void
		{
			_playing = true;
		}
		
		public function toggle():void
		{
			_playing = !_playing;
		}
	}
}