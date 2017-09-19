package com.vhall.framework.app.net.http
{
	/**
	 * @ClassName HttpRequest.as
	 * @Description socket模拟http请求
	 * All rights Reserved, Designed By Video++
	 * CopyRight Copyright(C) 2015
	 * Company www.videojj.com
	 * @author Dennis
	 * @version V1.0
	 * @Date 2015-11-26 21:13:27
	 */
	import com.vhall.framework.utils.StringUtil;
	import com.vhall.framework.app.net.http.HTTPLoader;
	import com.vhall.framework.app.net.http.HTTPResponse;

	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;

	public class HttpRequest
	{
		private var _url:String;
		private var _method:String;

		private var _request:URLRequest;
		private var loader:HTTPLoader;

		public var sucCallbackFun:Function;
		public var failedCallbackFun:Function;

		/**
		 * @Title: HttpRequest
		 * @Description 构造函数
		 * @param url
		 * @param method urlrequestmethod.GET OR POST
		 * @throws
		 */
		public function HttpRequest()
		{
			loader = new HTTPLoader();
			loader.addEventListener(Event.COMPLETE, completeHandler);
			loader.addEventListener(Event.OPEN, openHandler);
			loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}

		private function completeHandler(event:Event):void
		{
			var loader:HTTPLoader = HTTPLoader(event.target);
			var response:HTTPResponse = loader.response;

			if(sucCallbackFun != null)
			{
				sucCallbackFun(response);
			}
		}

		private function openHandler(event:Event):void
		{
			trace("acc openHandler: " + event);
		}

		private function progressHandler(event:ProgressEvent):void
		{
			trace("acc progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
		}

		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			if(failedCallbackFun != null)
			{
				failedCallbackFun(event);
			}
		}

		private function httpStatusHandler(event:HTTPStatusEvent):void
		{
			trace("acc httpStatusHandler: " + event);
		}

		private function ioErrorHandler(event:IOErrorEvent):void
		{
			if(failedCallbackFun != null)
			{
				failedCallbackFun(event);
			}
		}

		public function addHeader(header:URLRequestHeader):void
		{
			_request.requestHeaders.push(header);
		}

		public function request():void
		{
			_request = new URLRequest(url);
			_request.method = method;

			if(StringUtil.isNullOrEmpty(this.url))
			{
				return;
			}

			loader.load(_request);
		}

		public function set data(value:Object):void
		{
			_request.data = value;
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}

		public function get method():String
		{
			if(StringUtil.isNullOrEmpty(this._method))
			{
				this._method = URLRequestMethod.POST;
			}
			return _method;
		}

		public function set method(value:String):void
		{
			_method = value;
		}


	}
}
