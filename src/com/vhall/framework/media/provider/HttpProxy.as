/**
 * ===================================
 * Author:	iDzeir
 * Email:	qiyanlong@wozine.com
 * Company:	http://www.vhall.com
 * Created:	May 16, 2016 11:27:33 AM
 * ===================================
 */

package com.vhall.framework.media.provider
{
	import com.vhall.framework.log.Logger;
	import com.vhall.framework.utils.StringUtil;

	import flash.events.NetStatusEvent;
	import flash.net.NetStreamPlayOptions;
	import flash.utils.getTimer;

	CONFIG::LOGGING
	{
		import org.mangui.hls.utils.Log;
	}

	/**
	 * http协议或者本地视频代理
	 */
	public class HttpProxy extends RtmpProxy
	{
		private var _startTime:uint = 0;

		public function HttpProxy()
		{
			super();
			_type = MediaProxyType.HTTP;
		}

		override public function connect(uri:String, streamUrl:String = null, handler:Function = null, autoPlay:Boolean = true, startPostion:Number = 0):void
		{
			_autoPlay = autoPlay;
			_uri = uri;
			_streamUrl = streamUrl;
			_handler = handler;
			_startPostion = startPostion;

			valid();

			!_conn && createNet();

			addListeners();

			try
			{
				_conn.connect(null);
			}
			catch(e:Error)
			{
				CONFIG::LOGGING
				{
					Log.error("netConnection 建立链接失败:" + _uri);
				}
			}

			_startTime = getTimer();
			seekTime = startPostion;
		}

		override public function changeVideoUrl(uri:String, streamUrl:String, autoPlay:Boolean = true, startPostion:Number = 0):void
		{
			this.connect(uri, streamUrl, _handler, autoPlay, startPostion);
			return;
			var oldUri:String = this._uri;
			var oldStreamUrl:String = this._streamUrl;

			_autoPlay = autoPlay;
			_uri = uri;
			_streamUrl = streamUrl;
			_startPostion = startPostion;

			valid();

			if(_conn && _conn.connected && oldUri != uri && _transition)
			{
				if(oldStreamUrl == streamUrl)
					return;
				var npo:NetStreamPlayOptions = new NetStreamPlayOptions();
				npo.oldStreamName = oldUri;
				npo.streamName = uri;
				npo.offset = startPostion;
				npo.transition = _transition;

				if(_autoPlay)
				{
					if(!_ns)
					{
						CONFIG::LOGGING
						{
							Log.warn("httpProxy不存在的netstream无法changeVideoUrl");
						}
						return;
					}
					Logger.getLogger().info("采用play2 方式切换，old: " + oldStreamUrl + " new: " + uri);
					_ns.play2(npo);
				}
			}
			else
			{
				this.connect(uri, streamUrl, _handler, autoPlay, startPostion);
			}
			_startTime = getTimer();
		}

		override protected function createStream():void
		{
			super.createStream();

			this.inBufferSeek = true;
			this.bufferTimeMax = 15;
		}

		override public function start():void
		{
			_playing = true;

			if(_ns)
			{
				_ns.seek(_startPostion);
				_ns.play(_uri);
			}
		}

		override public function get time():Number
		{
			if(_ns)
				return _startPostion + _ns.time;
			return 0;
		}

		private var seekTime:Number = 0;

		override public function set time(value:Number):void
		{
			//			if(_ns)
			//				_ns.seek(value);
			Logger.getLogger("HttpProxy").info("time:" + value);
			if(_ns)
			{
				_startPostion = value;
				var temp:String = "{0}start=";
				var char:String = "&";
				char = this.uri.indexOf("?") > -1 ? "&" : "?";
				var res:String = StringUtil.substitute(temp, char);
				_ns.play(this.uri + res + value);
			}
		}

		override public function get duration():Number
		{
			return _duration;
		}

		override public function get bytesLoaded():int
		{
			if(_ns)
				return _ns.bytesLoaded;
			return 0;
		}

		override public function get bytesTotal():int
		{
			if(_ns)
				return _ns.bytesTotal;
			return 0;
		}

		override public function toString():String
		{
			var speed:uint = (bytesLoaded / 1024) / ((getTimer() - _startTime) / 1000);
			return _type.toLocaleUpperCase() + "播放平均网速：" + speed.toFixed(2) + " k/s";
		}

		override protected function statusHandler(e:NetStatusEvent):void
		{
			switch(e.info.code)
			{
				case InfoCode.NetConnection_Connect_Success:
					stopConnFailTime();
					onBufferEmpty();
					createStream();

					time = _startPostion;
					break;
				case InfoCode.NetConnection_Connect_Closed:
				case InfoCode.NetConnection_Connect_Failed:
				case InfoCode.NetConnection_Connect_AppShutDown:
				case InfoCode.NetConnection_Connect_Rejected:
					gc();
					break;
				case InfoCode.NetStream_Buffer_Empty:
					excute(MediaProxyStates.STREAM_LOADING);
					onBufferEmpty();
					break;
				case InfoCode.NetStream_Buffer_Full:
					excute(MediaProxyStates.STREAM_FULL);
					onBufferFull();
					break;
				case InfoCode.NetStream_Play_Start:
					excute(MediaProxyStates.STREAM_START);
					break;
				case InfoCode.NetStream_Play_Stop:
					excute(MediaProxyStates.STREAM_STOP);
					break;
				case InfoCode.NetStream_Play_StreamNotFound:
					excute(MediaProxyStates.STREAM_NOT_FOUND, _uri, _streamUrl);
					break;
				case InfoCode.NetStream_Seek_Failed:
				case InfoCode.NetStream_Seek_InvalidTime:
					excute(MediaProxyStates.SEEK_FAILED, e.info.code);
					break;
				case InfoCode.NetStream_Seek_Notify:
					excute(MediaProxyStates.SEEK_NOTIFY);
					break;
				case InfoCode.NetStream_Seek_Complete:
					_playing = true;
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

		override public function dispose():void
		{
			super.dispose();
			_startPostion = 0;
		}

		override protected function onMetaData(value:* = null):void
		{
			if(value && value["duration"])
			{
				_duration = value["duration"];
				_duration = _duration + _startPostion;
				excute(MediaProxyStates.DURATION_NOTIFY, _duration);
			}
		}

		override public function toggle():void
		{
			if(_playing)
			{
				excute(MediaProxyStates.STREAM_PAUSE);
				stream && stream.pause();
			}
			else
			{
				excute(MediaProxyStates.STREAM_UNPAUSE);
				stream && stream.resume();
			}
			_playing = !_playing;
		}
	}
}

