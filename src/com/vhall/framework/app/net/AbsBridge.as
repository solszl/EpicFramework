package com.vhall.framework.app.net
{
	import com.vhall.framework.log.Logger;

	import flash.utils.Dictionary;

	/**
	 *
	 * @author Sol
	 * @date 2016-05-24
	 */
	public class AbsBridge implements IBridge
	{

		/**
		 * 抽象消息对接类
		 *
		 */
		public function AbsBridge()
		{
			handleMap = new Dictionary();
		}

		protected var handleMap:Dictionary;

		/**
		 * 消息处理函数
		 * @param msg
		 * @param msg_body
		 *
		 */
		public function handle(msg:*, msg_body:*):void
		{

			if(!(msg in handleMap))
			{
				Logger.getLogger("MSG").info("no msg: " + msg + " in handleMap");
				return;
			}

			try
			{
				if(msg_body is String)
				{
					var obj:Object = JSON.parse(String(msg_body)); //JSON.decode(msg_body);
					handleMap[msg](obj);
				}
				else
				{
					handleMap[msg](msg_body);
				}
			}
			catch(e:Error)
			{
				Logger.getLogger("AbsBridge").info("ERROR " + e.errorID + ":" + e.message, handleMap == null, msg, msg_body);
			}
		}

		/**
		 * 注册消息
		 * @param receiver
		 *
		 */
		public function registMsgReceiver(receiver:AbsMsgReceiver):void
		{
//			var key:String = getQualifiedClassName(receiver);
			var dic:Dictionary = receiver.getObservers();

			for(var key:* in dic)
			{
				handleMap[key] = dic[key];
			}
		}

		/**
		 *	卸载消息
		 * @param receiver
		 *
		 */
		public function unregistMsgReceiver(receiver:AbsMsgReceiver):void
		{
//			var key:String = "com.vhall.app.net.msg::" + msg;
			var dic:Dictionary = receiver.getObservers();
			for(var key:* in dic)
			{
				if(key in dic)
				{
					delete handleMap[key];
				}
				else
				{
					trace("can not find type:", key);
				}
			}
		}
	}
}


