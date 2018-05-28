package com.vhall.framework.app.net
{
	import com.vhall.framework.log.Logger;

	import flash.external.ExternalInterface;

	/**
	 * 消息管理器，包括注册，接受，发送
	 * @author Sol
	 * @date 2016-05-24
	 */
	public class MessageManager
	{
		private static var _instance:MessageManager;

		public static function getInstance():MessageManager
		{
			if(!_instance)
			{
				_instance = new MessageManager()
			}

			return _instance;
		}

		public function MessageManager()
		{
			if(!_instance)
			{
				_instance = this;
					//				initSomeThing();
			}
		}

		/**	socket 消息收发器*/
		private var sb:AbsBridge;

		/**	web 消息 收发器*/
		private var wb:AbsBridge;

		/**
		 * 添加webJS回调
		 * @param name
		 *
		 */
		public function addWebCallBack(name:String):void
		{
			if(!ExternalInterface.available)
			{
				Logger.getLogger().info("ExternalInterface unsupport!");
				return;
			}
			if(wb == null)
			{
				initWebBridge();
			}

			try
			{
				ExternalInterface.addCallback(name, wb.handle);
			}
			catch(e:Error)
			{
				Logger.getLogger().info("add web callback error:" + e.message);
			}
		}

		/**
		 * 拿到收发器，为了下一部的发消息用
		 * @param type 类型 WEB 为 webBridge 否则为socketBridge
		 * @return
		 *
		 */
		public function getBridge(type:String = "WEB"):*
		{
			return type == "WEB" ? wb : sb;
		}

		public function initSocket(sb:SocketBridge = null):void
		{
			if(sb == null)
			{
				this.sb = new SocketBridge();
				SocketBridge(this.sb).ip = "127.0.0.1";
				SocketBridge(this.sb).port = 966;
				SocketBridge(this.sb).connect();
				return;
			}

			this.sb = sb;
			SocketBridge(this.sb).connect();
		}

		public function initWebBridge(wb:WebBridge = null):void
		{
			if(wb == null)
			{
				this.wb = new WebBridge();
				return;
			}

			this.wb = wb;
		}

		/**
		 * 注册消息到收发器中
		 * @param bridge	消息收发器
		 * @param msg	消息
		 *
		 */
		public function registMessage(msg:AbsMsgReceiver, bridgeType:String = "WEB"):void
		{
			(getBridge(bridgeType) as AbsBridge).registMsgReceiver(msg);
		}

		/**
		 * 从收发器中卸载消息
		 * @param bridge	消息收发器
		 * @param msg	消息内容
		 *
		 */
		public function unregistMessage(msg:AbsMsgReceiver, bridgeType:String = "WEB"):void
		{
			(getBridge(bridgeType) as AbsBridge).unregistMsgReceiver(msg);
		}

		/**@private 初始化一些必要的东西*/
		private function initSomeThing():void
		{
			wb = new WebBridge();
			sb = new SocketBridge("127.0.0.1", 966);
		}
	}
}


