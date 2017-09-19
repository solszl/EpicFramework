package com.vhall.framework.app.net.http
{

	/**
	 * @Script:		HTTPResponse.as
	 * @Licence:	MIT License (http://www.opensource.org/licenses/mit-license.php)
	 * @Author: 	xushengs@gmail.com
	 * @Website: 	http://code.google.com/p/fookie/
	 * @Version: 	0.1
	 * @Creation: 	Sep 27, 2010
	 * @Modified: 	Sep 27, 2010
	 * @Description:
	 *    HTTPResponse Object
	 */

	public class HTTPResponse
	{
		public function get headers():Object
		{
			return _headers;
		}

		public function get status():int
		{
			return _status;
		}

		public function set status(value:int):void
		{
			this._status = value;
		}

		public function get body():String
		{
			return _body;
		}

		public function set body(value:String):void
		{
			this._body = value;
		}

		public function get content():String
		{
			return _body;
		}

		public function set content(value:String):void
		{
			this._body = value;
		}

		private var _headers:Object = {};
		private var _status:int = 0;
		private var _body:String = '';

		public function HTTPResponse(response:Object)
		{
			this._headers = response.headers;
			this._status = response.status;
			this._body = response.body;
		}
	}
}
