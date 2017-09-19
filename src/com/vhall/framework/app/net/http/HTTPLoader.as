package com.vhall.framework.app.net.http
{
	/**
	 * @Script:		HTTPLoader.as
	 * @Licence:	MIT License (http://www.opensource.org/licenses/mit-license.php)
	 * @Author: 	xushengs@gmail.com
	 * @Website: 	http://code.google.com/p/fookie/
	 * @Version: 	0.1
	 * @Creation: 	Sep 27, 2010
	 * @Modified: 	Sep 27, 2010
	 * @Description:
	 *    Use socket to get HTTP headers, status and content
	 *
	 * @Usage:
	 *    see it in HTTPLoader.fla
	 *
	 * @Events:
	 *    They are the same with URLLoader, just list below:
	 *    complete:
	 *        Dispatched after all the received data is decoded
	 *        and placed in the response property of the HTTPLoader object.
	 *    httpStatus:
	 *        Dispatched if response headers have received.
	 *    ioError:
	 *        Dispatched if a call to HTTPLoader.load()
	 *        results in a fatal error that terminates the download.
	 *    open:
	 *        Dispatched when the download operation commences
	 *        following a call to the HTTPLoader.load() method.
	 *    progress:
	 *        Dispatched when data is received as the download
	 *        operation progresses.
	 *    securityError:
	 *        Dispatched if a call to HTTPLoader.load() attempts to
	 *        load data from a server outside the security sandbox.
	 *
	 */

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.utils.ByteArray;

	public class HTTPLoader extends EventDispatcher
	{
		public function get userAgent():String
		{
			return _userAgent;
		}

		public function set userAgent(value:String):void
		{
			this._userAgent = value;
		}

		public function get referer():String
		{
			return _referer;
		}

		public function set referer(value:String):void
		{
			this._referer = value;
		}

		public function get response():HTTPResponse
		{
			return this._response;
		}

		// host to connect
		private var _host:String = null;
		// port to connect
		private var _port:int = 80;
		// path to load
		private var _path:String = '/';
		// user agent of http request
		private var _userAgent:String = 'Mozilla/5.0 (Windows; U; Windows NT 6.1; zh-CN; rv:1.9.2.10) Gecko/20100914 Firefox/3.6.10';
		// referer
		private var _referer:String = null;

		private var _socket:Socket = new Socket();
		private var _request:URLRequest = null;
		private var _bytes:Array = new Array();

		//private var _dispatcher:EventDispatcher = new EventDispatcher();

		private var _encoding:String = 'utf-8';

		// progress information 
		private var _bytesLoaded:int = 0;
		private var _bytesTotal:int = 0;
		private var _headerLength:int = 0;

		// response
		private var _response:HTTPResponse = new HTTPResponse({'status': 0, 'headers': {}, 'body': ''});

		// url pattern
		//    group[1]: host
		//    group[2]: port
		//    group[3]: path
		private const URL_PATTERN:RegExp = /[http|https]:\/\/([^:\/]+)(?::(\d+))?(\/.*$)/i;

		/**
		 * constructor
		 *
		 * @param url:String
		 *    the request to load
		 * @return:
		 *    void
		 */
		public function HTTPLoader(request:URLRequest = null)
		{
			this._request = request;
		}

		/**
		 * load a request
		 *
		 * @param request:URLRequest
		 *    the request to load
		 * @return:
		 *    void
		 */
		public function load(request:URLRequest = null):void
		{
			if(request != null)
			{
				this._request = request;
			}

			if(this._request == null)
			{
				throw new Error('the request cannot be null');
			}

			// parse url
			var match:Object = URL_PATTERN.exec(this._request.url);
			if(match)
			{
				this._host = match[1];
				this._port = int(match[2]) || 80;
				this._path = match[3] || '/';
			}
			else
			{
				throw new Error('invalid url');
			}

			this._socket.addEventListener(Event.CLOSE, closeHandler);
			this._socket.addEventListener(Event.CONNECT, connectHandler, false, 0, true);
			this._socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this._socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			this._socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);

			this._socket.connect(this._host, this._port);
		}

		private function closeHandler(evt:Event):void
		{
			this._response.body = parseData();

			this._response = new HTTPResponse(this._response);
			dispatchEvent(new Event(flash.events.Event.COMPLETE));
		}

		private function connectHandler(evt:Event):void
		{
			// headers
			var headers:String = this._request.method + ' ' + this._path + ' HTTP/1.0\r\nHost: ' + this._host + '\r\nAccept: */*\r\nUser-Agent: ' + this._userAgent + '\r\nAccept-Encoding: deflate\r\nAccept-Language: zh-cn\r\nConnection: Close\r\n';
			if(this._referer)
			{
				headers += 'referer: ' + this._referer + '\r\n'
			}

			if(this._request.requestHeaders.length)
			{
				var len:int = this._request.requestHeaders.length, header:URLRequestHeader;
				for(var i:int = 0; i < len; i++)
				{
					header = this._request.requestHeaders[i];
					headers += header.name + ': ' + header.value + '\r\n';
				}
			}
			headers += '\r\n';

			// send request
			this._socket.writeUTFBytes(headers);
			this._socket.flush();

			// dispatch open event
			dispatchEvent(new Event(flash.events.Event.OPEN));
		}

		private function ioErrorHandler(evt:IOErrorEvent):void
		{
			dispatchEvent(evt);
		}

		private function securityErrorHandler(evt:SecurityErrorEvent):void
		{
			dispatchEvent(evt);
		}

		private function socketDataHandler(evt:ProgressEvent):void
		{
			var ba:ByteArray = new ByteArray()
			this._socket.readBytes(ba, 0, this._socket.bytesAvailable);
			this._bytes.push(ba);
			if(this._bytes.length == 1)
			{
				parseHeaders(ba);
				_bytesLoaded = -this._headerLength;
			}

			_bytesLoaded += ba.length;

			// dispatch progress event
			dispatchEvent(new ProgressEvent(flash.events.ProgressEvent.PROGRESS, false, false, _bytesLoaded, _bytesTotal));
		}

		private function parseHeaders(bytes:ByteArray):void
		{
			var s:String = bytes.readUTFBytes(1), headers:Array = new Array(), header:String = '', headerEnded:Boolean = false, line:int = 0;
			while(bytes.bytesAvailable)
			{
				switch(s)
				{
					case '\r':
						break;
					case '\n':
						line++;
						if(line == 2)
						{
							this._response['status'] = parseInt(headers[0].split(' ')[1]);

							// dispatch progress event
							dispatchEvent(new HTTPStatusEvent(flash.events.HTTPStatusEvent.HTTP_STATUS, false, false, this._response['status']));

							var h:Array;
							for(var i:int = 1; i < headers.length; i++)
							{
								h = headers[i].split(': ');
								this._response['headers'][h[0]] = h[1];

								switch(h[0])
								{
									case 'Content-Type':
										var encoding:Array = h[1].split('=');
										if(encoding.length > 1)
										{
											this._encoding = encoding[1];
										}
										break;
									case 'Content-Length':
										this._bytesTotal = parseInt(h[1]);
										break;
								}
							}
							this._headerLength = bytes.length - bytes.bytesAvailable;
							headerEnded = true;
						}
						else
						{
							headers.push(header);
							header = '';
						}
						break;
					default:
						line = 0;
						header += s;
						break;
				}
				if(headerEnded)
				{
					break;
				}
				else
				{
					s = bytes.readUTFBytes(1);
				}
			}
		}

		private function parseData():String
		{
			var data:String = '';
			var ba:ByteArray;
			var i = 0;
			while(ba = this._bytes[i++])
			{
				data += ba.readMultiByte(ba.bytesAvailable, this._encoding)
			}
			return data;
		}
	}
}
