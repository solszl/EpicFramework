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

	import flash.net.NetStreamPlayOptions;
	import flash.net.NetStreamPlayTransitions;
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
			seekTime = 0;
		}

		override public function changeVideoUrl(uri:String, streamUrl:String, autoPlay:Boolean = true, startPostion:Number = 0):void
		{
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
			this.bufferTimeMax = 60;
		}

		override public function start():void
		{
			_playing = true;

			if(_ns)
			{
				_ns.seek(startPostion);
				_ns.play(_uri);
			}
		}

		override public function get time():Number
		{
			if(_ns)
				return seekTime + _ns.time;
			return 0;
		}

		private var seekTime:Number = 0;

		override public function set time(value:Number):void
		{
			//			if(_ns)
			//				_ns.seek(value);
			if(_ns)
			{
				seekTime = value;
				_ns.play(this.uri + "?start=" + value);
			}
		}

		private var oldDuration:Number = 0;

		override public function get duration():Number
		{
			if(seekTime == 0)
			{
				oldDuration = _duration;
			}
			return oldDuration;
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
	}
}

