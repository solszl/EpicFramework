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
	import flash.media.SoundTransform;
	import flash.net.NetStream;
	
	import org.mangui.hls.HLS;
	import org.mangui.hls.constant.HLSPlayStates;
	import org.mangui.hls.event.HLSEvent;
	import org.mangui.hls.event.HLSLoadMetrics;
	import org.mangui.hls.event.HLSPlayMetrics;
	import org.mangui.hls.utils.Log;

	/** HLS视频播放代理*/
	public class HLSProxy extends AbstractProxy
	{
		private var _hls:HLS;
		
		private var _playMetrics:HLSPlayMetrics;
		
		private var _loadMetrics:HLSLoadMetrics;
		
		private var _durationReady:Boolean = false;
		
		public function HLSProxy()
		{
			super(MediaProxyType.HLS);
		}
		
		override public function connect(uri:String, streamUrl:String=null, handler:Function=null, autoPlay:Boolean=true):void
		{
			super.connect(uri,streamUrl,handler,autoPlay);
			
			_hls ||= new HLS();
			_hls.addEventListener(HLSEvent.MANIFEST_LOADED,onHLSHandler);
			_hls.addEventListener(HLSEvent.MEDIA_TIME,onHLSHandler);
			_hls.addEventListener(HLSEvent.PLAYBACK_COMPLETE,onHLSHandler);
			_hls.addEventListener(HLSEvent.PLAYLIST_DURATION_UPDATED,onHLSHandler);
			_hls.addEventListener(HLSEvent.PLAYBACK_STATE,onHLSHandler);
			_hls.addEventListener(HLSEvent.MANIFEST_PARSED,onHLSHandler);
			_hls.addEventListener(HLSEvent.SEEK_STATE,onHLSHandler);
			_hls.addEventListener(HLSEvent.FRAGMENT_LOADED,onHLSHandler);
			_hls.addEventListener(HLSEvent.FRAGMENT_PLAYING,onHLSHandler);
			
			_hls.addEventListener(HLSEvent.FRAGMENT_SKIPPED,onHLSHandler);
			_hls.addEventListener(HLSEvent.TAGS_LOADED,onHLSHandler);
			_hls.addEventListener(HLSEvent.FRAGMENT_LOADED,onHLSHandler);
			_hls.addEventListener(HLSEvent.FRAGMENT_LOAD_EMERGENCY_ABORTED,onHLSHandler);
			_hls.addEventListener(HLSEvent.LEVEL_LOADED,onHLSHandler);
			_hls.addEventListener(HLSEvent.AUDIO_LEVEL_LOADED,onHLSHandler);
			
			_hls.addEventListener(HLSEvent.WARNING,onHLSHandler);
			_hls.addEventListener(HLSEvent.ERROR,onHLSHandler);
			
			_hls.load(_uri);
		}
		
		override public function start():void
		{
			super.start();
			stream && stream.play();
		}
		
		override public function stop():void
		{
			super.stop();
			stream && stream.dispose();
		}
		
		override public function pause():void
		{
			super.pause();
			
			stream && stream.pause();
		}
		
		override public function resume():void
		{
			super.resume();
			stream && stream.resume();
		}
		
		override public function toggle():void
		{
			super.toggle();
			
			if(_playing)
				stream && stream.resume();
			else
				stream && stream.pause();
		}
		
		protected function onHLSHandler(e:HLSEvent):void
		{
			/*CONFIG::LOGGING{
				Log.info(e.duration+" "+ e.type+" "+e.state);
			}*/
			switch(e.type)
			{
				case HLSEvent.MANIFEST_LOADED:
					break;
				case HLSEvent.MANIFEST_PARSED:
					CONFIG::LOGGING{
						Log.info(e);
					}
					volume = _volume;
					excute(MediaProxyStates.CONNECT_NOTIFY);
					_autoPlay&&start();
					break;
				case HLSEvent.PLAYBACK_STATE:
					CONFIG::LOGGING{
						Log.info("HLS state:"+e.state)
					}
					switch(e.state)
					{
						case HLSPlayStates.PAUSED:
							break;
						case HLSPlayStates.PLAYING:
							break;
					}
					break;
				case HLSEvent.TAGS_LOADED:
				case HLSEvent.FRAGMENT_LOADED:
				case HLSEvent.FRAGMENT_LOAD_EMERGENCY_ABORTED:
				case HLSEvent.LEVEL_LOADED:
				case HLSEvent.AUDIO_LEVEL_LOADED:
					loadMetrics = e.loadMetrics;
					break;
				case HLSEvent.MEDIA_TIME:
					_time = e.mediatime.position;
					break;
				case HLSEvent.PLAYBACK_COMPLETE:
					excute(MediaProxyStates.STREAM_STOP);
					break;
				case HLSEvent.PLAYLIST_DURATION_UPDATED:
				case HLSEvent.FRAGMENT_SKIPPED:
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
					break;
				case HLSEvent.WARNING:
					CONFIG::LOGGING{
						Log.warn(e.error.msg);
					}
					break;
				case HLSEvent.ERROR:
					CONFIG::LOGGING{
						Log.error(e.error.msg);
					}
					break;
			}
		}
		
		override protected function gc():void
		{
			if(_hls)
			{
				_hls.removeEventListener(HLSEvent.MANIFEST_LOADED,onHLSHandler);
				_hls.removeEventListener(HLSEvent.MEDIA_TIME,onHLSHandler);
				_hls.removeEventListener(HLSEvent.PLAYBACK_COMPLETE,onHLSHandler);
				_hls.removeEventListener(HLSEvent.PLAYLIST_DURATION_UPDATED,onHLSHandler);
				_hls.removeEventListener(HLSEvent.PLAYBACK_STATE,onHLSHandler);
				_hls.removeEventListener(HLSEvent.MANIFEST_PARSED,onHLSHandler);
				_hls.removeEventListener(HLSEvent.SEEK_STATE,onHLSHandler);
				_hls.removeEventListener(HLSEvent.FRAGMENT_LOADED,onHLSHandler);
				_hls.removeEventListener(HLSEvent.FRAGMENT_PLAYING,onHLSHandler);
				
				_hls.removeEventListener(HLSEvent.FRAGMENT_SKIPPED,onHLSHandler);
				_hls.removeEventListener(HLSEvent.TAGS_LOADED,onHLSHandler);
				_hls.removeEventListener(HLSEvent.FRAGMENT_LOADED,onHLSHandler);
				_hls.removeEventListener(HLSEvent.FRAGMENT_LOAD_EMERGENCY_ABORTED,onHLSHandler);
				_hls.removeEventListener(HLSEvent.LEVEL_LOADED,onHLSHandler);
				_hls.removeEventListener(HLSEvent.AUDIO_LEVEL_LOADED,onHLSHandler);
				
				_hls.removeEventListener(HLSEvent.WARNING,onHLSHandler);
				_hls.removeEventListener(HLSEvent.ERROR,onHLSHandler);
			}
			
			_durationReady = false;
			this._playMetrics = null;
			this._loadMetrics = null;
			_hls.dispose();
			_hls = null;
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
				excute(MediaProxyStates.DURATION_NOTIFY,_duration);
			}
		}
		
		override public function get time():Number
		{
			if(_hls) return _hls.position;
			return 0;
		}
		
		override public function set time(value:Number):void
		{
			if(stream) stream.seek(value);
		}
			
		/**
		 * 视频加载相关信息初始化
		 */		
		private function set loadMetrics(value:HLSLoadMetrics):void
		{
			if(value&&!_loadMetrics)
			{
				_loadMetrics = value;
			}
		}
		
		/**
		 * 视频播放相关信息初始化
		 */		
		private function set playMetrics(value:HLSPlayMetrics):void
		{
			if(value&&!_playMetrics)
			{
				_playMetrics = value;
				//trace("视频宽高：",_playMetrics.duration,_playMetrics.video_width,_playMetrics.video_height);
			}
		}
		
		override public function set volume(value:Number):void
		{
			super.volume = value;
			if(stream){
				var st:SoundTransform = stream.soundTransform;
				st.volume = _volume;
				stream.soundTransform = st;
			}
		}
		
		override public function get stream():NetStream
		{
			if(!_hls) return null;
			return _hls.stream;
		}
	}
}