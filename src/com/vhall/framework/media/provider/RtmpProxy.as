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
	import flash.events.NetDataEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.H264Level;
	import flash.media.H264Profile;
	import flash.media.H264VideoStreamSettings;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.NetStreamPlayOptions;
	import flash.net.NetStreamPlayTransitions;
	
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
		}
		
		override public function connect(uri:String, streamUrl:String=null, handler:Function=null, autoPlay:Boolean=true,startPostion:Number = 0):void
		{
			super.connect(uri,streamUrl,handler,autoPlay,startPostion);

			addListeners();
			
			try{
				_conn.connect(this._uri);
			}catch(e:Error){
				CONFIG::LOGGING{
					Log.error("netConnection 建立链接失败:"+_uri);
				}
			}
		}
		
		protected function addListeners():void
		{
			if(!_conn.hasEventListener(NetStatusEvent.NET_STATUS))
			{
				_conn.addEventListener(NetStatusEvent.NET_STATUS,statusHandler);
				_conn.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
				_conn.addEventListener(SecurityErrorEvent.SECURITY_ERROR,errorHandler);
				_conn.addEventListener(AsyncErrorEvent.ASYNC_ERROR,errorHandler);
			}
		}		
		
		
		/** 通道连接建立成功，创建流对象*/
		override protected function createStream():void
		{
			_ns = new NetStream(_conn);
			_ns.client = client;

			//取消硬件解码
			_ns.useHardwareDecoder = false;
			_ns.videoStreamSettings = h264Video;
			
			bufferTime = 1;
			bufferTimeMax = 2;
						
			_ns.addEventListener(NetStatusEvent.NET_STATUS,statusHandler);
			_ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR,errorHandler);
			_ns.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
			_ns.addEventListener(NetDataEvent.MEDIA_TYPE_DATA,mediaHandler);
			
			volume = _volume;
			
			excute(MediaProxyStates.CONNECT_NOTIFY);
			
			_autoPlay&&start();
			
			_conn.call("checkBandwidth",null);
		}
		
		override public function changeVideoUrl(uri:String, streamUrl:String, autoPlay:Boolean=true, startPostion:Number = 0):void
		{
			var oldUri:String = this._uri;
			var oldStreamUrl:String = this._streamUrl;
			
			super.changeVideoUrl(uri, streamUrl, autoPlay, startPostion);
			
			if(oldUri == uri && oldStreamUrl != streamUrl)
			{
				var nspo:NetStreamPlayOptions = new NetStreamPlayOptions();
				nspo.oldStreamName = oldStreamUrl;
				nspo.streamName = streamUrl;
				nspo.transition = NetStreamPlayTransitions.SWITCH;
				if(_autoPlay&&_ns)
				{
					_ns.play2(nspo);
				}
			}else{
				//清除监听
				clearNsListeners();
				clearCnListeners();
				//重新链接
				this.connect(uri,streamUrl,_handler,autoPlay,startPostion);
			}
		}
		
		/**
		 * 视频的h264编码
		 * @return 
		 */		
		protected function get h264Video():H264VideoStreamSettings
		{
			var h264:H264VideoStreamSettings = new H264VideoStreamSettings();
			//设置视频编码的配置文件和级别
			h264.setProfileLevel(H264Profile.MAIN,H264Level.LEVEL_3_1);
			//设置视频的分辨率和fps，和推流端获取一致
			h264.setMode(-1,-1,-1);
			//视频I帧个camera一致
			h264.setKeyFrameInterval(-1);
			
			return h264;
		}
		
		/** 播放connect中传入的流名称*/
		override public function start():void
		{
			super.start();
			if(_ns)
			{
				_ns.play(_streamUrl);
			}
		}
		
		override public function stop():void
		{
			super.stop();
			_ns && _ns.close();
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
			_ns && _ns.togglePause();
		}
		
		protected function statusHandler(e:NetStatusEvent):void
		{
			CONFIG::LOGGING{
				trace("状态码：" + e.info.code + (e.info.description ? " 描述：" + e.info.description : ""));
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
					excute(MediaProxyStates.STREAM_NOT_FOUND,_uri,_streamUrl);
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
				case InfoCode.NetStream_Pause_Notify:
					excute(MediaProxyStates.STREAM_PAUSE);
					break;
				case InfoCode.NetStream_Unpause_Notify:
					excute(MediaProxyStates.STREAM_UNPAUSE);
					break;
				case InfoCode.NetStream_Play_PublishNotify:
					excute(MediaProxyStates.PUBLISH_NOTIFY);
					break;
				case InfoCode.NetStream_Play_UnpublishNotify:
					excute(MediaProxyStates.UN_PUBLISH_NOTIFY);
					break;
				case InfoCode.NetStream_Play_Transition:
					excute(MediaProxyStates.STREAM_TRANSITION);
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
			return {"onPublishData":onPublishData,"onBWCheck":onBWCheck,"onBWDone":onBWDone,
				"onCuePoint":onCurePoint,"onImageData":onImageData,"onMetaData":onMetaData,
				"onPlayStatus":onPlayStatus,"onSeekPoint":onSeekPoint,"onTextData":onTextData};
		}
		
		/**
		 * 推流端发送过来的网络状态信息
		 * @param value
		 */		
		protected function onPublishData(value:*):void
		{
			//trace(JSON.stringify(value))
			//value.lag为当前flash推流端延迟比较量
		}
		protected function onBWCheck(...value):Number
		{
			/*CONFIG::LOGGING{
				Log.info("onBWCheck:"+JSON.stringify(value));
			}*/
			//网速检测，返回0告诉服务器已经收到数据
			return 0;
		}
		protected function onBWDone(...value):void
		{
			/*CONFIG::LOGGING{
				Log.info("网速："+Number(value[0]/1024).toFixed(2)+" k/s"+" 延迟："+value[3]+" ms");
			}*/
		}
		protected function onCurePoint(...value):void
		{
			CONFIG::LOGGING{
				Log.info("onCurePoint:"+JSON.stringify(value));
			}
		}
		protected function onImageData(...value):void
		{
			CONFIG::LOGGING{
				Log.info("onImageData:"+JSON.stringify(value));
			}
		}
		protected function onMetaData(value:* = null):void
		{
			if(value&&value["duration"])
			{
				_duration = value["duration"];
				excute(MediaProxyStates.DURATION_NOTIFY,_duration);
			}
			
			CONFIG::LOGGING
			{
				Log.info("onMetaData:"+JSON.stringify(value));	
			}
		}
		protected function onPlayStatus(...value):void
		{
			CONFIG::LOGGING{
				Log.info("onPlayStatus:"+JSON.stringify(value));
			}
		}
		protected function onSeekPoint(...value):void
		{
			CONFIG::LOGGING{
				Log.info("onSeekPoint:"+JSON.stringify(value));
			}
		}
		protected function onTextData(...value):void
		{
			CONFIG::LOGGING{
				Log.info("onTextData:"+JSON.stringify(value));
			}
		}
		
		protected function mediaHandler(e:NetDataEvent):void
		{
			if(!this.client.hasOwnProperty(e.info["handler"]))
			{
				CONFIG::LOGGING{
					Log.info("本地回调未处理:"+JSON.stringify(e.info["handler"]));
				}
			}
		}
		
		//清除netstream的监听
		protected function clearNsListeners():void
		{
			if(_ns)
			{
				_ns.removeEventListener(NetStatusEvent.NET_STATUS,statusHandler);
				_ns.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,errorHandler);
				_ns.removeEventListener(IOErrorEvent.IO_ERROR,errorHandler);
				_ns.removeEventListener(NetDataEvent.MEDIA_TYPE_DATA,mediaHandler);
				_ns.dispose();
				_ns = null;
			}
		}
		
		//清除netconnection的监听,会导致无法播放
		protected function clearCnListeners():void
		{
			if(_conn)
			{
				_conn.removeEventListener(NetStatusEvent.NET_STATUS,statusHandler);
				_conn.removeEventListener(IOErrorEvent.IO_ERROR,errorHandler);
				_conn.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,errorHandler);
				_conn.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,errorHandler);
				_conn.close();
			}
		}
		
		override protected function gc():void
		{
			clearNsListeners();
			clearCnListeners();
			super.gc();
		}
		
		protected function errorHandler(event:Event):void
		{
			CONFIG::LOGGING{
				Log.error("netConnection 建立链接失败:"+event);
			}
		}
		
		override public function get time():Number
		{
			if(stream) return stream.time;
			return 0;
		}
		
		override public function set time(value:Number):void
		{
			stream && stream.seek(value);
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
		
		private function get bytesPerSecond():Number
		{
			if(stream) return stream.info.dataBytesPerSecond/1024;
			return 0;
		}
		
		override public function toString():String
		{
			return _type.toLocaleUpperCase() + "拉流：" + Number(bytesPerSecond/1024).toFixed(2) +" k/s";
		}
	}
}