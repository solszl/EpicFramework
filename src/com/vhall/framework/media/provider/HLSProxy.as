/**
 * ===================================
 * Author:	iDzeir
 * Email:	qiyanlong@wozine.com
 * Company:	http://www.vhall.com
 * Created:	May 16, 2016 11:26:38 AM
 * ===================================
 */

package com.vhall.framework.media.provider
{
	import com.vhall.framework.media.interfaces.IProgress;

	import flash.display.Stage;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.net.NetStream;

	import org.mangui.hls.HLS;
	import org.mangui.hls.HLSSettings;
	import org.mangui.hls.constant.HLSPlayStates;
	import org.mangui.hls.event.HLSError;
	import org.mangui.hls.event.HLSEvent;
	import org.mangui.hls.event.HLSLoadMetrics;
	import org.mangui.hls.event.HLSPlayMetrics;

	CONFIG::LOGGING
	{
		import org.mangui.hls.utils.Log;
	}

	/** HLS视频播放代理*/
	public class HLSProxy extends AbstractProxy implements IProgress
	{
		private var _hls:HLS;

		private var _playMetrics:HLSPlayMetrics;

		private var _loadMetrics:HLSLoadMetrics;

		private var _durationReady:Boolean = false;

		public function HLSProxy()
		{
			super(MediaProxyType.HLS);

			HLSSettings.maxBufferLength = 30;
			HLSSettings.manifestLoadMaxRetryTimeout = 2000;
			HLSSettings.flushLiveURLCache = true;
//			HLSSettings.seekMode = HLSSeekMode.ACCURATE_SEEK;
		}

		override public function connect(uri:String, streamUrl:String = null, handler:Function = null, autoPlay:Boolean = true, startPostion:Number = 0):void
		{
			super.connect(uri, streamUrl, handler, autoPlay, startPostion);

			_hls ||= new HLS();
			_hls.addEventListener(HLSEvent.MANIFEST_LOADED, onHLSHandler);
			_hls.addEventListener(HLSEvent.MEDIA_TIME, onHLSHandler);
			_hls.addEventListener(HLSEvent.PLAYBACK_COMPLETE, onHLSHandler);
			_hls.addEventListener(HLSEvent.PLAYLIST_DURATION_UPDATED, onHLSHandler);
			_hls.addEventListener(HLSEvent.PLAYBACK_STATE, onHLSHandler);
			_hls.addEventListener(HLSEvent.MANIFEST_PARSED, onHLSHandler);
			_hls.addEventListener(HLSEvent.SEEK_STATE, onHLSHandler);
			_hls.addEventListener(HLSEvent.FRAGMENT_LOADED, onHLSHandler);
			_hls.addEventListener(HLSEvent.FRAGMENT_PLAYING, onHLSHandler);

			//_hls.addEventListener(HLSEvent.FRAGMENT_SKIPPED,onHLSHandler);
			_hls.addEventListener(HLSEvent.TAGS_LOADED, onHLSHandler);
			//_hls.addEventListener(HLSEvent.FRAGMENT_LOAD_EMERGENCY_ABORTED,onHLSHandler);
			_hls.addEventListener(HLSEvent.LEVEL_LOADED, onHLSHandler);
			//_hls.addEventListener(HLSEvent.AUDIO_LEVEL_LOADED,onHLSHandler);

			//_hls.addEventListener(HLSEvent.WARNING,onHLSHandler);
			_hls.addEventListener(HLSEvent.ERROR, onHLSHandler);

			bufferTime = ProxyConfig.BufferTime;
			stream.addEventListener(NetStatusEvent.NET_STATUS, streamNetStatusEventHandler);


			_hls.load(_uri);
			startConnFailTime();
		}

		protected function streamNetStatusEventHandler(event:NetStatusEvent):void
		{
			// TODO Auto-generated method stub
			switch(event.info.code)
			{
				case InfoCode.NetStream_Buffer_Empty:
					excute(MediaProxyStates.STREAM_LOADING, true);
					onBufferEmpty();
					break;
				case InfoCode.NetStream_Buffer_Full:
					excute(MediaProxyStates.STREAM_FULL, true);
					onBufferFull();
					break;
			}
		}

		override public function changeVideoUrl(uri:String, streamUrl:String, autoPlay:Boolean = true, startPostion:Number = 0):void
		{
			super.changeVideoUrl(uri, streamUrl, autoPlay, startPostion);

			_durationReady = false;
			this._playMetrics = null;
			this._loadMetrics = null;

			_hls.load(uri);
			startConnFailTime();
		}

		override public function start():void
		{
			super.start();
			if(stream)
			{
				stage = _stage;
				stream.play();
				time = _startPostion;
			}
		}

		override protected function onEmptyTime():void
		{
			// TODO Auto Generated method stub
			super.onEmptyTime();
			excute(MediaProxyStates.STREAM_EMPTY_4CHANGELINE);
		}

		override protected function onConnFail():void
		{
			// TODO Auto Generated method stub
			super.onConnFail();
			excute(MediaProxyStates.STREAM_CONN_TIMEOUT);
		}


		override public function set stage(value:Stage):void
		{
			super.stage = value;
			_hls && (_hls.stage = value);
		}

		override public function stop():void
		{
			super.stop();
			stream && stream.close();
			stream.removeEventListener(NetStatusEvent.NET_STATUS, streamNetStatusEventHandler);
			gc();
		}

		override public function pause():void
		{
			super.pause();
			stream && stream.pause();
			excute(MediaProxyStates.STREAM_PAUSE);
		}

		override public function resume():void
		{
			super.resume();
			stream && stream.resume();
			excute(MediaProxyStates.STREAM_UNPAUSE);
		}

		override public function toggle():void
		{
//			stream && stream.togglePause();
//			_playing ? excute(MediaProxyStates.STREAM_UNPAUSE) : excute(MediaProxyStates.STREAM_PAUSE);
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
			super.toggle();
		}

		protected function onHLSHandler(e:HLSEvent):void
		{
			CONFIG::LOGGING
			{
				Log.info(e.duration + " " + e.type + " " + e.state);
			}
			switch(e.type)
			{
				case HLSEvent.MANIFEST_LOADED:
					stopConnFailTime();
					onBufferEmpty()
					break;
				case HLSEvent.MANIFEST_PARSED:
					CONFIG::LOGGING
				{
					Log.info(e);
				}
					volume = _volume;
					mute = _mute;
					excute(MediaProxyStates.CONNECT_NOTIFY);
					_autoPlay && start();
					break;
				case HLSEvent.PLAYBACK_STATE:
					CONFIG::LOGGING
				{
					Log.info("HLS state:" + e.state)
				}
					switch(e.state)
					{
						case HLSPlayStates.PAUSED:
						case HLSPlayStates.PLAYING:
							//excute(MediaProxyStates.STREAM_FULL,e.state == HLSPlayStates.PAUSED?false:true);
							break;
						case HLSPlayStates.PAUSED_BUFFERING:
						case HLSPlayStates.PLAYING_BUFFERING:
							//excute(MediaProxyStates.STREAM_LOADING,e.state == HLSPlayStates.PAUSED_BUFFERING?false:true);
							break
					}
					break;
				case HLSEvent.TAGS_LOADED:
				case HLSEvent.FRAGMENT_LOADED:
				//case HLSEvent.FRAGMENT_LOAD_EMERGENCY_ABORTED:
				case HLSEvent.LEVEL_LOADED:
					//case HLSEvent.AUDIO_LEVEL_LOADED:
					loadMetrics = e.loadMetrics;
					break;
				case HLSEvent.MEDIA_TIME:
					//_time = e.mediatime.position;
					break;
				case HLSEvent.PLAYBACK_COMPLETE:
					excute(MediaProxyStates.STREAM_STOP);
					break;
				case HLSEvent.PLAYLIST_DURATION_UPDATED:
					//case HLSEvent.FRAGMENT_SKIPPED:
					excute(MediaProxyStates.STREAM_SIZE_NOTIFY);
					setDuration(e.duration);
					break;
				case HLSEvent.FRAGMENT_PLAYING:
					playMetrics = e.playMetrics;
					break;
				case HLSEvent.FRAGMENT_LOADED:
					loadMetrics = e.loadMetrics;
					break;
				case HLSEvent.SEEK_STATE:
					switch(e.state)
					{
						case "SEEKING":
							excute(MediaProxyStates.SEEK_NOTIFY);
							break;
						case "SEEKED":
							excute(MediaProxyStates.SEEK_COMPLETE);
							break;
					}
					CONFIG::LOGGING
				{
					Log.info(e.state);
				}
					break;
				/*case HLSEvent.WARNING:
					excute(MediaProxyStates.PROXY_ERROR,e.error.msg);
					CONFIG::LOGGING{
					Log.warn(e.error.msg);
				}
					break;*/
				case HLSEvent.ERROR:
					onHlsError(e);
					break;
			}
		}

		private function onHlsError(e:HLSEvent):void
		{
			excute(MediaProxyStates.PROXY_ERROR, e.error.msg);
			CONFIG::LOGGING
			{
				Log.error(e.error.code + ":" + e.error.msg);
			}
			if([HLSError.MANIFEST_LOADING_CROSSDOMAIN_ERROR, HLSError.MANIFEST_LOADING_IO_ERROR, HLSError.MANIFEST_PARSING_ERROR, HLSError.FRAGMENT_LOADING_CROSSDOMAIN_ERROR, HLSError.FRAGMENT_LOADING_ERROR, HLSError.FRAGMENT_PARSING_ERROR, HLSError.KEY_LOADING_CROSSDOMAIN_ERROR, HLSError.KEY_LOADING_ERROR, HLSError.KEY_PARSING_ERROR, HLSError.TAG_APPENDING_ERROR].indexOf(e.error.code) != -1)
			{
				excute(MediaProxyStates.CONNECT_FAILED, e.error.msg);
			}
		}

		override protected function gc():void
		{
			super.gc();
			if(_hls)
			{

				_hls.removeEventListener(HLSEvent.MANIFEST_LOADED, onHLSHandler);
				_hls.removeEventListener(HLSEvent.MEDIA_TIME, onHLSHandler);
				_hls.removeEventListener(HLSEvent.PLAYBACK_COMPLETE, onHLSHandler);
				_hls.removeEventListener(HLSEvent.PLAYLIST_DURATION_UPDATED, onHLSHandler);
				_hls.removeEventListener(HLSEvent.PLAYBACK_STATE, onHLSHandler);
				_hls.removeEventListener(HLSEvent.MANIFEST_PARSED, onHLSHandler);
				_hls.removeEventListener(HLSEvent.SEEK_STATE, onHLSHandler);
				_hls.removeEventListener(HLSEvent.FRAGMENT_LOADED, onHLSHandler);
				_hls.removeEventListener(HLSEvent.FRAGMENT_PLAYING, onHLSHandler);

				//_hls.removeEventListener(HLSEvent.FRAGMENT_SKIPPED,onHLSHandler);
				_hls.removeEventListener(HLSEvent.TAGS_LOADED, onHLSHandler);
				//_hls.removeEventListener(HLSEvent.FRAGMENT_LOAD_EMERGENCY_ABORTED,onHLSHandler);
				_hls.removeEventListener(HLSEvent.LEVEL_LOADED, onHLSHandler);
				//_hls.removeEventListener(HLSEvent.AUDIO_LEVEL_LOADED,onHLSHandler);

				//_hls.removeEventListener(HLSEvent.WARNING,onHLSHandler);
				_hls.removeEventListener(HLSEvent.ERROR, onHLSHandler);
				_hls.dispose();
				_hls = null;
			}
			stopConnFailTime();
			_durationReady = false;
			this._playMetrics = null;
			this._loadMetrics = null;
		}

		/**
		 * 视频时长初始化
		 */
		private function setDuration(value:Number):void
		{
			if(!_durationReady)
			{
				_duration = value;
				_durationReady = true;
				excute(MediaProxyStates.DURATION_NOTIFY, _duration);
			}
		}

		override public function get time():Number
		{
			if(_hls)
				return _hls.position;
			return 0;
		}

		override public function set time(value:Number):void
		{
			if(stream)
				stream.seek(value);
		}

		/**
		 * 视频加载相关信息初始化
		 */
		private function set loadMetrics(value:HLSLoadMetrics):void
		{
			_loadMetrics = value;
		}

		/**
		 * 视频播放相关信息初始化
		 */
		private function set playMetrics(value:HLSPlayMetrics):void
		{
			if(!_playMetrics)
				excute(MediaProxyStates.STREAM_START);
			_playMetrics = value;
			//trace("视频宽高：",_playMetrics.duration,_playMetrics.video_width,_playMetrics.video_height);
		}

		override public function set volume(value:Number):void
		{
			super.volume = value;
			if(stream)
			{
				var st:SoundTransform = stream.soundTransform;
				st.volume = _volume;
				stream.soundTransform = st;
			}
		}

		override public function set mute(bool:Boolean):void
		{
			super.mute = bool;
			if(stream)
			{
				var st:SoundTransform = stream.soundTransform;
				st.volume = bool ? 0 : _volume;
				stream.soundTransform = st;
			}
		}

		override public function get stream():NetStream
		{
			if(!_hls)
				return null;
			return _hls.stream;
		}

		override public function get loaded():Number
		{
			if(stream)
				return _hls.position + stream.bufferLength / duration;
			return 0;
		}

		override public function toString():String
		{
			return _type.toLocaleUpperCase() + " 拉流：" + Number(_loadMetrics.bandwidth / 8000).toFixed(2) + " k/s";
		}
	}
}

