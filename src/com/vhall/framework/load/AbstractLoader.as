package com.vhall.framework.load
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;

	/**
	 * 抽象加载器
	 * @author Sol
	 * @date 2016-05-11
	 */
	internal class AbstractLoader implements ILoadStrategy
	{

		protected var urlRequest:URLRequest;

		// 各种回调函数
		protected var complete:Function;
		protected var progress:Function;
		protected var failed:Function;

		protected var _isLoading:Boolean = false;

		protected var currentItem:Object

		protected var _cache:Boolean;

		public function AbstractLoader()
		{
		}

		public function load(item:Object, onComplete:Function = null, onProgress:Function = null, onFailed:Function = null):void
		{
		}

		protected function initLoader():void
		{

		}

		public function deinitLoader():void
		{
		}

		public function get isLoading():Boolean
		{
			return _isLoading;
		}

		protected function onCompleteHandler(event:Event):void
		{
		}

		protected function onProgressHandler(event:ProgressEvent):void
		{
			if(this.progress == null)
			{
				return;
			}

			this.progress(event.bytesTotal, event.bytesLoaded);
		}

		protected function onIOErrorHandler(event:IOErrorEvent):void
		{
			if(this.failed == null)
			{
				return;
			}

			this._isLoading = false;
			failed(currentItem, "[IOError] " + event.errorID);
			deinitLoader();
		}

		protected function onStatusHandler(event:HTTPStatusEvent):void
		{
			// 只回调[400,500)的错误
			if(event.status < 400 || event.status >= 500)
			{
				return;
			}

			if(this.failed == null)
			{
				return;
			}

			this._isLoading = false;
			failed(currentItem, "[HTTPStatus] " + event.status);
//			deinitLoader();
		}

		protected function onSecurityErrorHandler(event:SecurityErrorEvent):void
		{
			if(this.failed == null)
			{
				return;
			}

			this._isLoading = false;
			failed(currentItem, "[SecurityError] " + event.errorID);
			deinitLoader();
		}

		/** 是否缓存*/
		public function get cache():Boolean
		{
			return _cache;
		}

		/**
		 * @private
		 */
		public function set cache(value:Boolean):void
		{
			_cache = value;
		}

	}
}
