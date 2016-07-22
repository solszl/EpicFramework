package com.vhall.framework.app
{
	import com.vhall.framework.app.manager.StageManager;
	import com.vhall.framework.keyboard.KeyboardMapper;
	import com.vhall.framework.log.Logger;
	import com.vhall.framework.log.LoggerClip;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;

	/**
	 *	整个应用程序的基类
	 * @author Sol
	 *
	 */
	public class App extends Sprite
	{
		public static var app:Sprite;

		public static var baseURL:String="";

		/**	初始化开始*/
		public static var INIT_START:String="app_init_start";
		/**	初始化完毕*/
		public static var INIT_END:String="app_init_end";

		public function App()
		{
			super();
			app=this;

			initApp();
			dispatchEvent(new Event(INIT_START));
		}

		protected function initApp():void
		{
			addEventListener(Event.ENTER_FRAME, onEnter);
		}

		protected function onEnter(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, onEnter);
			StageManager.init(this);
			initLog();
			initKeyboard();
			initBaseURL();
			NetConnection.defaultObjectEncoding=ObjectEncoding.AMF0;
			dispatchEvent(new Event(INIT_END));
		}


		protected function initBaseURL():void
		{
			//"http://ccstatic01.e.vhall.com/player/"

			//"//ccstatic01.e.vhall.com/document"
			// 取消一个测试URL机制。
//			if(loaderInfo.parameters.hasOwnProperty("skinUrl"))
//			{
//				baseURL = loaderInfo.parameters["skinUrl"];
//			}
//			else if(loaderInfo.parameters.hasOwnProperty("doc_srv"))
//			{
//				var ul:String = loaderInfo.parameters["doc_srv"];
//				var str:String = ul.substr(0, ul.lastIndexOf('/') + 1);
//				baseURL = "http:" + str + "player/";
//			}
			if (loaderInfo.parameters.hasOwnProperty("skinUrl"))
			{
				var ul:String=loaderInfo.parameters["skinUrl"];

				if (ul.indexOf("//") >= 0)
				{
					ul=ul.substr(ul.indexOf("//") + 2);
				}
				var str:String=getUrlString(ul);
				if (str.indexOf("http:") >= 0)
				{
					baseURL=str + "player/";
				}
				else
				{
					baseURL="http://" + str + "/player/";
				}
			}

//			if (loaderInfo.parameters.hasOwnProperty("doc_srv"))
//			{
//				var ul:String=loaderInfo.parameters["doc_srv"];
//				var str:String=ul.substr(0, ul.lastIndexOf('/') + 1);
//				baseURL="http:" + str + "player/";
//			}

			if (loaderInfo.parameters.hasOwnProperty("resPath"))
			{
				baseURL=loaderInfo.parameters["resPath"];
			}

			if (loaderInfo.url.indexOf("file") >= 0)
			{
				baseURL="";
			}
		}

		private function getUrlString(url:String):String
		{
			var str:String=url;
			if (url.lastIndexOf("/") >= 0)
			{
				str=url.substr(0, url.lastIndexOf('/'));
				return getUrlString(str);
			}
			return str;
		}

		/**
		 *	@private 初始化日志
		 *
		 */
		private function initLog():void
		{
			var clip:LoggerClip=new LoggerClip(this);
			Logger.mcOutputClip=clip;
			Logger.getLogger().info("Logger inited since start:" + getTimer() + "ms");
		}

		/**
		 *	@private 初始化键盘管理器
		 *
		 */
		private function initKeyboard():void
		{
			var km:KeyboardMapper=new KeyboardMapper(StageManager.stage);
			km.mapListener(showHideLog, Keyboard.SHIFT, Keyboard.L);
		}

		/**
		 *	@private 显隐日志
		 *
		 */
		private function showHideLog():void
		{
			Logger.getLogger().toggle();
		}
	}
}
