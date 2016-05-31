package com.vhall.framework.app.net
{
	import flash.external.ExternalInterface;

	/**
	 * 消息管理器，包括注册，接受，发送
	 * @author Sol
	 * @date 2016-05-24
	 */
	public class MessageManager
	{
		private static var _instance:MessageManager;

		/**	web 消息 收发器*/
		private var wb:AbsBridge;
		/**	socket 消息收发器*/
		private var sb:AbsBridge;

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
				initSomeThing();
			}
		}

		/**@private 初始化一些必要的东西*/
		private function initSomeThing():void
		{
			wb = new WebBridge();
			sb = new SocketBridge("127.0.0.1", 966);
		}

		/**
		 *	拿到收发器，为了下一部的发消息用
		 * @param type 类型 WEB 为 webBridge 否则为socketBridge
		 * @return
		 *
		 */
		public function getBridge(type:String = "WEB"):*
		{
			return type == "WEB" ? wb : sb;
		}

		/**
		 *	注册消息到收发器中
		 * @param bridge	消息收发器
		 * @param msg	消息
		 *
		 */
		public function registMessage(msg:AbsMsgReceiver, bridgeType:String = "WEB"):void
		{
			(getBridge(bridgeType) as AbsBridge).registMsgReceiver(msg);
		}

		/**
		 *	从收发器中卸载消息
		 * @param bridge	消息收发器
		 * @param msg	消息内容
		 *
		 */
		public function unregistMessage(msg:AbsMsgReceiver, bridgeType:String = "WEB"):void
		{
			(getBridge(bridgeType) as AbsBridge).unregistMsgReceiver(msg);
		}

		/**
		 *	添加webJS回调
		 * @param name
		 *
		 */
		public function addWebCallBack(name:String):void
		{
			if(!ExternalInterface.available)
			{
				return;
			}

			ExternalInterface.addCallback(name, wb.handle);
		}
	}
}
