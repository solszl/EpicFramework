package com.vhall.framework.app.net
{
	import com.adobe.serialization.json.JSON;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;

	/**
	 * socket 消息，接受，发送调度
	 * @author Sol
	 * @date 2016-05-24
	 */
	public class SocketBridge extends AbsBridge
	{
		/**	socket 实例*/
		private var socket:Socket;
		/**	ip地址*/
		private var ip:String;
		/**	端口号*/
		private var port:int;

		private var bodyBytes:ByteArray = new ByteArray();
		private var receBytes:ByteArray = new ByteArray();

		public function SocketBridge(ip:String, port:int)
		{
			socket = new Socket(ip, port);
			socket.addEventListener(Event.CONNECT, socketHandler);
			socket.addEventListener(Event.CLOSE, socketHandler);
			socket.addEventListener(IOErrorEvent.IO_ERROR, socketHandler);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, socketHandler);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, progressHandler);
		}

		protected function progressHandler(e:ProgressEvent):void
		{
			receBytes.length = 0;
			socket.readBytes(receBytes);
			var s:String = receBytes.readMultiByte(receBytes.length, "");
			var o:Object = com.adobe.serialization.json.JSON.decode(s);
			handleMap[o.type](o);
		}

		protected function socketHandler(e:Event):void
		{
			handleMap[e.type](e);
		}

		/**
		 * 派发消息
		 * @param msg
		 * @param body
		 *
		 */
		public function sendMsg(msg:*, body:Object = null,useBase64:Boolean = false):void
		{
			if(socket && socket.connected)
			{
				body = body || {};
				body.type = msg;
				var s:String = com.adobe.serialization.json.JSON.encode(body);

				bodyBytes.length = 0;
				bodyBytes.writeUTFBytes(s);
				socket.writeBytes(bodyBytes);
				socket.flush();
			}
		}
	}
}
