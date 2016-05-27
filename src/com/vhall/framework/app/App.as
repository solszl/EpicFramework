package com.vhall.framework.app
{
	import com.vhall.framework.app.manager.StageManager;
	import com.vhall.framework.keyboard.KeyboardMapper;
	import com.vhall.framework.log.Logger;
	import com.vhall.framework.log.LoggerClip;

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
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

		public function App()
		{
			super();
			app = this;

			initApp();
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
			//加载loading皮肤
			loadLoadingSkin();
		}

		private var l:Loader;

		private function loadLoadingSkin():void
		{
			l = new Loader();
			var ctx:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			var req:URLRequest = new URLRequest("loading.swf");
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			l.load(req, ctx);
		}

		private function onLoadComplete(event:Event):void
		{
			deinitLoader();
			//派发初始化完成事件
			//外部接收到该事件后加载代码模块，UI皮肤等
			dispatchEvent(new Event(Event.COMPLETE));
		}

		/**
		 *	@private loader 销毁
		 *
		 */
		private function deinitLoader():void
		{
			l.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			l.unload();
			l = null;
		}

		/**
		 *	@private 初始化日志
		 *
		 */
		private function initLog():void
		{
			var clip:LoggerClip = new LoggerClip(this);
			Logger.mcOutputClip = clip;
			Logger.getLogger().info("Logger inited since start:" + getTimer() + "ms");
		}

		/**
		 *	@private 初始化键盘管理器
		 *
		 */
		private function initKeyboard():void
		{
			var km:KeyboardMapper = new KeyboardMapper(StageManager.stage);
			km.mapListener(showHideLog, Keyboard.CONTROL, Keyboard.ALTERNATE, Keyboard.SHIFT, Keyboard.L);
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
