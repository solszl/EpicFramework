package com.vhall.framework.load
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	/**
	 *	URLLoader加载策略
	 * @author Sol
	 *	@date 2016-05-11
	 */
	internal class URLLoaderStrategy extends AbstractLoader implements ILoadStrategy
	{
		/**	加载器*/
		private var urlLoader:URLLoader;

		public function URLLoaderStrategy()
		{
			// 初始化加载器等信息
			initLoader();
		}

		override public function load(item:Object, onComplete:Function = null, onProgress:Function = null, onFailed:Function = null):void
		{
			if (urlLoader == null)
			{
				initLoader();
			}

			this.currentItem = item;
			this.complete = onComplete;
			this.progress = onProgress;
			this.failed = onFailed;

			urlLoader.dataFormat = judgeFormmat(item.type);
			urlRequest.url = item.url;
			urlLoader.load(urlRequest);
			_isLoading = true;
		}

		/**	初始化加载器*/
		override protected function initLoader():void
		{
			if (urlLoader != null)
			{
				return;
			}

			// 初始化加载器
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onCompleteHandler);
			urlLoader.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onStatusHandler);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			// 初始化请求
			urlRequest = new URLRequest();
		}

		/**	加载完成回调*/
		override protected function onCompleteHandler(event:Event):void
		{
			_isLoading = false;
			if (this.complete == null)
			{
				return;
			}

			var content:* = null;
			switch (currentItem.type)
			{
				case 2:
					// 图片
					initInnerLoader();
					innerLoader.loadBytes(urlLoader.data);
					break;
				case 3:
					//文本
					content = urlLoader.data
					followWork(content);
					break;
				case 4:
					//压缩后的二进制
					var bytes:ByteArray = urlLoader.data as ByteArray;
					bytes.uncompress();
					content = bytes.readObject();
					followWork(content);
					break;
				case 5:
					//未压缩的二进制
					content = urlLoader.data as ByteArray;
					followWork(content);
					break;
				default:
					break;
			}
		}

		override public function deinitLoader():void
		{
			this.currentItem = null;
			this.complete = null;
			this.progress = null;
			this.failed = null;

			this.urlRequest = null
			this.urlLoader.data = null;
			this.urlLoader.close()
			this.urlLoader.removeEventListener(Event.COMPLETE, onCompleteHandler);
			this.urlLoader.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			this.urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
			this.urlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onStatusHandler);
			this.urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			this.urlLoader = null;
		}

		/** 根据文件类型返回加载格式需求*/
		private function judgeFormmat(type:int):String
		{
			// 3为 txt/xml 文件格式
			switch (type)
			{
				case 3:
					return URLLoaderDataFormat.TEXT;
				default:
					return URLLoaderDataFormat.BINARY;
			}
		}
		
		private function followWork(content:*):void
		{
			this.complete(currentItem, content, null);
			deinitLoader();
		}

		//-------------------------------------------------------------------
		//			内部使用，加载图片二进制用，别无它用
		//-------------------------------------------------------------------
		private var innerLoader:Loader;

		private function initInnerLoader():void
		{
			innerLoader = new Loader();
			innerLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onInnerLoaderCompleteHandler);
		}

		/**	销毁内部图片加载器*/
		private function destoryInnerLoader():void
		{
			innerLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onInnerLoaderCompleteHandler);
			innerLoader.unloadAndStop();
			innerLoader = null;
		}

		private function onInnerLoaderCompleteHandler(event:Event):void
		{
			var bm:Bitmap = Bitmap(innerLoader.content);
			destoryInnerLoader();
			if (this.complete == null)
			{
				return;
			}

			followWork(bm);
		}
	}
}
