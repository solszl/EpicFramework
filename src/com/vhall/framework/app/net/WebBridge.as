package com.vhall.framework.app.net
{
	import com.adobe.serialization.json.JSON;
	import com.hurlant.util.Base64;
	import com.vhall.framework.log.Logger;
	import com.vhall.framework.utils.JsonUtil;

	import flash.external.ExternalInterface;

	/**
	 * web 消息发送，调配
	 * @author Sol
	 * @date 2016-05-24
	 */
	public class WebBridge extends AbsBridge
	{
		public function WebBridge()
		{
		}

		/**
		 * 派发消息
		 * @param handler
		 * @param body
		 */
		public function sendMsg(handler:String,body:Object = null, useBase64:Boolean = false):void
		{
			if(!ExternalInterface.available)
			{
				Logger.getLogger("MSG").info("SWF not in broswer, can not send message!");
				return;
			}
			var s:String = com.adobe.serialization.json.JSON.encode(body);
			var result:String = useBase64?Base64.encode(s):s;
			try{
				ExternalInterface.call(handler, result);
			}catch(e:Error){};
		}

		/**
		 * 发送命令给js
		 * @param body 数据
		 *
		 */		
		public function sendCMDMsg(body:Object):void{
			if(!ExternalInterface.available)
			{
				Logger.getLogger("MSG").info("SWF not in broswer, can not send message!");
				return;
			}
			var s:String = com.adobe.serialization.json.JSON.encode(body);
			var result:String = Base64.encode(s);
			try{
				ExternalInterface.call("sendCmdMsg", result);
			}catch(e:Error){};
		}

		/**
		 * 只会在bufflength(这个比较特殊，就这个一个用，之后跟js协商解决)
		 * @param type 信息类型
		 * @param body 数据
		 *
		 */		
		public function sendBufferMsgToJs(type:String,body:Object):void{
			if(!ExternalInterface.available)
			{
				Logger.getLogger("MSG").info("SWF not in broswer, can not send message!");
				return;
			}
			try{
				Logger.getLogger("MSG").info("sendMsgToFlash",type);
				ExternalInterface.call("sendMsgToFlash", type, body);
			}catch(e:Error){};
		}

		/**
		 * 将事件消息发起JS进行处理
		 * @param body 信息
		 *
		 */		
		public function sendEventMsg(body:Object):void{
			if(!ExternalInterface.available)
			{
				Logger.getLogger("MSG").info("SWF not in broswer, can not send message!");
				return;
			}
			var s:String = com.adobe.serialization.json.JSON.encode(body);
			try{
				ExternalInterface.call("sendSocketMsg", "flashMsg", s);
			}catch(e:Error){};
		}

		/**
		 * 记录数据发送
		 * @param body 信息
		 *
		 */		
		public function sendRecordMsg(body:Object):void{
			if(!ExternalInterface.available)
			{
				Logger.getLogger("MSG").info("SWF not in broswer, can not send message!");
				return;
			}
			try{
				ExternalInterface.call("sendRecordMsg", "recordMsg", body);
			}catch(e:Error){};
		}
	}
}


