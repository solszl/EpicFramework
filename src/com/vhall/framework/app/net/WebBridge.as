package com.vhall.framework.app.net
{
	import com.adobe.serialization.json.JSON;
	import com.hurlant.util.Base64;
	import com.vhall.framework.log.Logger;
	
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
		
		override public function sendMsg(msg:*, body:Object = null):void
		{
			if(!ExternalInterface.available)
			{
				Logger.getLogger("MSG").info("SWF not in broswer, can not send message!");
				return;
			}
			
			var s:String = com.adobe.serialization.json.JSON.encode(body);
			var result:String = Base64.encode(s)
			ExternalInterface.call(msg, result);
		}
	}
}