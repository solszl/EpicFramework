/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.vhall.com		
 * Created:	May 16, 2016 11:23:42 AM
 * ===================================
 */

package com.vhall.framework.media.provider
{
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.H264Level;
	import flash.media.H264Profile;
	import flash.media.H264VideoStreamSettings;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	CONFIG::LOGGING {
		import org.mangui.hls.utils.Log;
	}

	/** Rtmp直播代理*/
	public class RtmpProxy extends AbstractProxy
	{
		protected var _conn:NetConnection;
		
		protected var _ns:NetStream;
		
		public function RtmpProxy()
		{
			super(MediaProxyType.RTMP);
			
			createNet();
		}
		
		/** 创建NetConnection链接*/
		protected function createNet():void
		{
			_conn ||= new NetConnection();
			_conn.client = client;
			_conn.addEventListener(NetStatusEvent.NET_STATUS,statusHandler);
			_conn.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
			_conn.addEventListener(SecurityErrorEvent.SECURITY_ERROR,errorHandler);
			_conn.addEventListener(AsyncErrorEvent.ASYNC_ERROR,errorHandler);
		}
		
		override public function connect(uri:String, streamUrl:String=null, handler:Function=null, autoPlay:Boolean=true):void
		{
			super.connect(uri,streamUrl,handler,autoPlay);

			try{
				_conn.connect(this._uri);
			}catch(e:Error){
				CONFIG::LOGGING{
					Log.error("netConnection 建立链接失败:"+_uri);
				}
			}
		}
		
		/** 通道连接建立成功，创建流对象*/
		override protected function createStream():void
		{
			_ns = new NetStream(_conn);
			_ns.client = client;

			//取消硬件解码
			_ns.useHardwareDecoder = false;
			
			var h264:H264VideoStreamSettings = new H264VideoStreamSettings();
			//设置视频编码的配置文件和级别
			h264.setProfileLevel(H264Profile.MAIN,H264Level.LEVEL_3_1);
			//设置视频的分辨率和fps，和推流端获取一致
			h264.setMode(-1,-1,-1);
			//视频I帧个camera一致
			h264.setKeyFrameInterval(-1);
			
			_ns.videoStreamSettings = h264;
			
			_ns.addEventListener(NetStatusEvent.NET_STATUS,statusHandler);
			_ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR,errorHandler);
			_ns.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
			//_ns.addEventListener(NetDataEvent.MEDIA_TYPE_DATA,mediaHandler);
			
			volume = _volume;
			
			excute(MediaProxyStates.CONNECT_NOTIFY);
			
			_autoPlay&&start();
		}
		
		/** 播放connect中传入的流名称*/
		override public function start():void
		{
			super.start();
			_ns && _ns.play(_streamUrl);
		}
		
		override public function stop():void
		{
			super.stop();
			_ns && _ns.dispose();
		}
		
		override public function pause():void
		{
			super.pause();
			
			_ns && _ns.pause();
		}
		
		override public function resume():void
		{
			super.resume();
			_ns && _ns.resume();
		}
		
		override public function toggle():void
		{
			super.toggle();
			
			if(_playing)
				_ns && _ns.resume();
			else
				_ns && _ns.pause();
		}
		
		protected function statusHandler(e:NetStatusEvent):void
		{
			CONFIG::LOGGING{
				Log.info(e.info.code);
			}
			switch(e.info.code)
			{
				case InfoCode.NetConnection_Connect_Success:
					createStream();
					break;
				case InfoCode.NetConnection_Connect_Closed:
				case InfoCode.NetConnection_Connect_Failed:
				case InfoCode.NetConnection_Connect_AppShutDown:
				case InfoCode.NetConnection_Connect_Rejected:
					excute(MediaProxyStates.CONNECT_FAILED,e.info.code);
					break;
				case InfoCode.NetStream_Buffer_Empty:
					excute(MediaProxyStates.STREAM_LOADING);
					break;
				case InfoCode.NetStream_Buffer_Full:
					excute(MediaProxyStates.STREAM_FULL);
					break;
				case InfoCode.NetStream_Play_Start:
					excute(MediaProxyStates.STREAM_START);
					break;
				case InfoCode.NetStream_Play_Stop:
					excute(MediaProxyStates.STREAM_STOP);
					break;
				case InfoCode.NetStream_Play_StreamNotFound:
					excute(MediaProxyStates.STREAM_NOT_FOUND,_streamUrl);
					break;
				case InfoCode.NetStream_Seek_Failed:
				case InfoCode.NetStream_Seek_InvalidTime:
					excute(MediaProxyStates.SEEK_FAILED,e.info.code);
					break;
				case InfoCode.NetStream_Seek_Notify:
					excute(MediaProxyStates.SEEK_NOTIFY);
					break;
				case InfoCode.NetStream_Seek_Complete:
					excute(MediaProxyStates.SEEK_COMPLETE);
					break;
				case InfoCode.NetStream_Video_DimensionChange:
					//视频源尺寸改变
					excute(MediaProxyStates.STREAM_SIZE_NOTIFY);
					break;
				default:
					break;
			}
		}
		
		/**
		 * netConnection,netstream回调client
		 * @return 
		 */		
		protected function get client():Object
		{
			return {"onCuePoint":onCurePoint,"onImageData":onImageData,"onMetaData":onMetaData,"onPlayStatus":onPlayStatus,"onSeekPoint":onSeekPoint,"onTextData":onTextData};
		}
		protected function onCurePoint(...value):void{}
		protected function onImageData(...value):void{}
		protected function onMetaData(value:* = null):void
		{
			if(value&&value["duration"])
			{
				_duration = value["duration"];
				excute(MediaProxyStates.DURATION_NOTIFY,_duration);
			}
		}
		protected function onPlayStatus(...value):void{}
		protected function onSeekPoint(...value):void{}
		protected function onTextData(...value):void{}
		
		
		override protected function gc():void
		{
			if(_ns)
			{
				_ns.removeEventListener(NetStatusEvent.NET_STATUS,statusHandler);
				_ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,errorHandler);
				_ns.removeEventListener(IOErrorEvent.IO_ERROR,errorHandler);
				//_ns.removeEventListener(NetDataEvent.MEDIA_TYPE_DATA,mediaHandler);
				_ns.dispose();
				_ns = null;
			}
			
			if(_conn)
			{
				_conn.removeEventListener(NetStatusEvent.NET_STATUS,statusHandler);
				_conn.removeEventListener(IOErrorEvent.IO_ERROR,errorHandler);
				_conn.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,errorHandler);
				_conn.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,errorHandler);
				_conn.close();
			}
			
			super.gc();
		}
		
		protected function errorHandler(event:Event):void
		{
			CONFIG::LOGGING{
				Log.error("netConnection 建立链接失败:"+event);
			}
		}
		
		override public function get stream():NetStream
		{
			return _ns;
		}
		
		override public function set volume(value:Number):void
		{
			super.volume = value;
			if(_ns)
			{
				var st:SoundTransform = _ns.soundTransform;
				st.volume = _volume;
				_ns.soundTransform = st;
			}
		}
	}
}