package com.vhall.framework.app.net
{
	import com.vhall.framework.log.Logger;
	import com.vhall.framework.utils.JsonUtil;
	
	import flash.utils.Dictionary;

	/**
	 *
	 * @author Sol
	 * @date 2016-05-24
	 */
	public class AbsBridge implements IBridge
	{
		protected var handleMap:Dictionary;

		/**
		 * 抽象消息对接类
		 *
		 */
		public function AbsBridge()
		{
			handleMap = new Dictionary();
		}

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
				Logger.getLogger("[MSG]").info("no msg: " + msg + " in handleMap");
				return;
			}

			var obj:Object = JsonUtil.decode(msg_body);
			handleMap[msg](obj);
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