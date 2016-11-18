package com.vhall.framework.load
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	/**
	 * 队列加载
	 * @author Sol
	 *
	 */
	public class QueueLoader
	{
		private var loadList:Array = [];
		private var urlLoader:URLLoader;
		private var loader:Loader;

		private var currentItem:Object;
		private var loadedCount:int = 0;

		private var onItemCompleteCallBack:Function;
		private var onAllCompleteCallBack:Function;
		private var onProgressCallBack:Function;
		private var onItemFailedCallBack:Function;

		private static const _swfContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);

		public function QueueLoader()
		{
		}

		public function startQueue(loadList:Array, onItemComplete:Function = null, onAllComplete:Function = null, onProgress:Function = null, onItemFailed:Function = null):void
		{
			initLoaders();

			this.loadList = this.loadList.concat(loadList);
			this.onItemCompleteCallBack = onItemComplete;
			this.onAllCompleteCallBack = onAllComplete;
			this.onProgressCallBack = onProgress;
			this.onItemFailedCallBack = onItemFailed;
			loadNext();
		}

		private function loadNext():void
		{
			if(loadList.length == 0)
			{
				onAllComplete();
				return;
			}
			currentItem = loadList.shift();
			loadedCount++;

			if(currentItem.hasOwnProperty("type"))
			{
				switch(currentItem.type)
				{
					case 1:
						urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
						break;
					case 2:
						urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
						break;
					default:
						urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
						break;
				}
			}
			else
			{
				currentItem.type = 1;
			}
			var request:URLRequest = new URLRequest(currentItem.url);
			request.method = URLRequestMethod.GET;
			urlLoader.load(request);
		}

		public function stopQueueLoad():void
		{
			loadList = [];
		}

		private function loaderCompleteHandler(e:Event):void
		{
			switch(currentItem.type)
			{
				case 2:
					var data:ByteArray = urlLoader.data;
					if(data.length > 0)
					{
						loader.loadBytes(data, _swfContext);
					}
					break;
				case 1:
					if(onItemCompleteCallBack != null)
					{
						onItemCompleteCallBack(currentItem, urlLoader.data, null);
					}
					loadNext();
				default:
					break;
			}

		}

		private function progressHandler(e:ProgressEvent):void
		{
			onProgress(loadedCount + this.loadList.length, loadedCount, e.bytesTotal, e.bytesLoaded);
		}

		protected function onComplete(item:Object, content:Object, domain:ApplicationDomain):void
		{
			if(onItemCompleteCallBack != null)
			{
				onItemCompleteCallBack(item, content, domain);
			}
		}

		protected function onProgress(totalCount:int, loadedCount:int, bytesTotal:int, bytesLoaded:int):void
		{
			if(onProgressCallBack != null)
			{
				onProgressCallBack(totalCount, loadedCount, bytesTotal, bytesLoaded, currentItem)
			}
		}

		protected function onAllComplete():void
		{
			if(onAllCompleteCallBack != null)
			{
				onAllCompleteCallBack();
			}
		}

		protected function onIO_Error(e:IOErrorEvent):void
		{
			if(onItemFailedCallBack == null)
			{
			}
			else
			{
				onItemFailedCallBack(currentItem, e.text);
			}
			loadNext();
		}

		private function onLoaderLoaded(e:Event):void
		{
			if(e.target is URLLoader)
			{
				var data:ByteArray = urlLoader.data;
				onComplete(currentItem, data, null);
			}
			else
			{
				onComplete(currentItem, loader.content, loader.contentLoaderInfo.applicationDomain);
			}
			loadNext();
		}

		private function initLoaders():void
		{
			if(!urlLoader)
			{
				urlLoader = new URLLoader();
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIO_Error);
				urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler)
				urlLoader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			}
			else
			{
				try
				{
					urlLoader.close()
				}
				catch(e:Error)
				{
				}
			}
			if(!loader)
			{
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderLoaded);
			}
			else
			{
				try
				{
					loader.close()
				}
				catch(e:Error)
				{
				}
			}
		}
	}
}
