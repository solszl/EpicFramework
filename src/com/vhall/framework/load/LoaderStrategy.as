package com.vhall.framework.load
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	/**
	 *	Loader加载策略
	 * @author Sol
	 * @date 2016-05-11
	 */
	internal class LoaderStrategy extends AbstractLoader implements ILoadStrategy
	{
		/**	加载器*/
		private var loader:Loader;
		private var _loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);

		public function LoaderStrategy()
		{
			initLoader();
		}

		override public function load(item:Object, onComplete:Function = null, onProgress:Function = null, onFailed:Function = null):void
		{
			if (loader == null)
			{
				initLoader();
			}

			this.currentItem = item;

			this.complete = onComplete;
			this.progress = onProgress;
			this.failed = onFailed;

			urlRequest.url = item.url;
			_loaderContext.applicationDomain = ApplicationDomain.currentDomain;
			loader.load(urlRequest, _loaderContext);
			_isLoading = true;
		}

		/**	初始化加载器*/
		override protected function initLoader():void
		{
			if (loader != null)
			{
				return;
			}

			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
			loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatusHandler);
			loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);

			urlRequest = new URLRequest();
		}

		override protected function onCompleteHandler(event:Event):void
		{
			if (this.complete == null)
			{
				return;
			}

			var content:* = loader.content;
			this.complete(currentItem, content, loader.contentLoaderInfo.applicationDomain);
			
			if(cache)
			{
				//将加载进来的数据进行缓存
			}
			
			deinitLoader();
		}

		override public function deinitLoader():void
		{
			this.currentItem = null;
			this.complete = null;
			this.progress = null;
			this.failed = null;

			this.urlRequest = null;

			this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteHandler);
			this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			this.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
			this.loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onStatusHandler);
			this.loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
//			this.loader.unloadAndStop();
			this.loader.unload();
			this.loader = null;
		}
	}
}
