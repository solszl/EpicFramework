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
	
	public class AbstractProxy implements IMediaProxy
	{
		protected var _type:String;
		
		protected var _playing:Boolean = false;
		
		protected var _autoPlay:Boolean = false;
		
		protected var _volume:Number = .6;
		
		protected var _duration:Number = 0;
		
		protected var _streamUrl:String;
		
		protected var _uri:String;
		
		protected var _time:Number = 0;
		
		protected var _handler:Function = null;		
		
		public function AbstractProxy(type:String)
		{
			_type = type;
		}
		
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
		
		}
		
		protected function gc():void
		{
			
		}
		
		protected function excute(type:String, ...data):void
		{
			var args:Array = data.length != 0 ? [type].concat(data):[type];
			_handler&&_handler.apply(null,args);
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
			return _time;
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
		}
		
		public function pause():void
		{
		}
		
		public function resume():void
		{
		}
		
		public function toggle():void
		{
		}
	}
}