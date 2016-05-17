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
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	CONFIG::LOGGING {
		import org.mangui.hls.utils.Log;
	}

	public class RtmpProxy extends AbstractProxy
	{
		protected var _conn:NetConnection;
		
		protected var _ns:NetStream;
		
		public function RtmpProxy()
		{
			super(MediaProxyType.RTMP);
			
			createNet();
		}
		
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
		
		override protected function createStream():void
		{
			_ns = new NetStream(_conn);
			_ns.client = client;
			_ns.useHardwareDecoder = false;
			
			_ns.addEventListener(NetStatusEvent.NET_STATUS,statusHandler);
			_ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR,errorHandler);
			_ns.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
			//_ns.addEventListener(NetDataEvent.MEDIA_TYPE_DATA,mediaHandler);
			
			volume = _volume;
			
			excute(MediaProxyStates.CONNECT_NOTIFY);
			
			_autoPlay&&start();
		}
		
		override public function start():void
		{
			_ns&&_ns.play(_streamUrl);
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
					excute(MediaProxyStates.STREAM_PLAYING);
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
				case InfoCode.NetStream_Video_DimensionChange:
					//视频源尺寸改变
					excute(MediaProxyStates.STREAM_SIZE_NOTIFY);
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