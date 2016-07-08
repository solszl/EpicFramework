/**
 * ===================================
 * Author:	iDzeir
 * Email:	qiyanlong@wozine.com
 * Company:	http://www.vhall.com
 * Created:	Jul 8, 2016 10:08:52 AM
 * ===================================
 */

package com.vhall.framework.media.provider
{
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;

	CONFIG::LOGGING{
		import org.mangui.hls.utils.Log;
	}

	public class UniquePublishKeeper
	{
		private var _lc:LocalConnection = new LocalConnection();

		private static var _instance:UniquePublishKeeper;

		public function UniquePublishKeeper()
		{
			if(!_instance)
			{
				_lc.addEventListener(StatusEvent.STATUS,function(e:StatusEvent):void
				{
					CONFIG::LOGGING{
						Log.info("UniquePublishKeeper:" + e);
					}
				});

				_instance = this;
			}else{
				throw new Error("单例 UniquePublishKeeper");
			}
		}

		public function set client(value:*):void
		{
			_lc.client = value;
		}

		public static function get keeper():UniquePublishKeeper
		{
			return _instance ||= new UniquePublishKeeper();
		}

		public function add(tag:String):Boolean
		{
			try{
				_lc.connect(tag);
			}catch(e:Error){
				return false;
			}
			return true;
		}

		public function send(tag:String,methodName:String,...arg):void
		{
			try{
				_lc.send(tag,methodName,arg);
			}catch(e:Error){}
		}

		public function close():void
		{
			try{
				_lc.close();
				_lc.client = null;
			}catch(e:Error){}
		}
	}
}

