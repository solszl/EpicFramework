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
	import com.vhall.framework.media.interfaces.IProgress;
	
	CONFIG::LOGGING{
		import org.mangui.hls.utils.Log;
	}
	
	/**
	 * http协议或者本地视频代理
	 */		
	public class HttpProxy extends RtmpProxy implements IProgress
	{
		public function HttpProxy()
		{
			super();
			_type = MediaProxyType.HTTP;
		}
		
		override public function connect(uri:String, streamUrl:String=null, handler:Function=null, autoPlay:Boolean=true):void
		{
			_autoPlay = autoPlay;
			_uri = uri;
			_streamUrl = streamUrl;
			_handler = handler;
			
			try{
				_conn.connect(null);
			}catch(e:Error){
				CONFIG::LOGGING{
					Log.error("netConnection 建立链接失败:"+_uri);
				}
			}
		}
		
		override public function start():void
		{
			_ns&&_ns.play(_uri);
		}
		
		public function get bytesLoaded():int
		{
			if(_ns) _ns.bytesLoaded;
			return 0;
		}
		
		override public function get time():Number
		{
			if(_ns) _ns.time;
			return 0;
		}
		
		override public function set time(value:Number):void
		{
			if(_ns) _ns.seek(value);
		}
		
		public function get bytesTotal():int
		{
			if(_ns) _ns.bytesTotal;
			return 0;
		}
		
		public function loaded():Number
		{
			if(!_ns) return 0;
			return bytesLoaded / bytesTotal;
		}
	}
}