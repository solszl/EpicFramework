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
		 *发送到js带msgType
		 * @param cmdType cmd类型
		 * @param msgtype 消息类型
		 * @param body 消息数据
		 * @param encodeJson 是否json
		 * @param base64 是否base64
		 * 
		 */		
		public function sendMsg4Type(cmdType:String,msgType:String,body:Object,encodeJson:Boolean = false,base64:Boolean = false):void{
			if(!ExternalInterface.available)
			{
				Logger.getLogger("MSG").info("SWF not in broswer, can not send message!");
				return;
			}
			try{
				Logger.getLogger("WebBridge").info("cmdType:" + cmdType + " msgType:" + msgType);
				var msgStr:String;
				if(encodeJson){
					msgStr = com.adobe.serialization.json.JSON.encode(body);
					if(base64){
						msgStr  = Base64.encode(msgStr);
					}
					ExternalInterface.call(cmdType, msgType, msgStr);
				}else{
					ExternalInterface.call(cmdType, msgType, body);
				}
			}catch(e:Error){
				Logger.getLogger("WebBridge").info("Error: cmdType:" + cmdType + " msgType:" + msgType);
			};
		}
		
		/**
		 *发送到js
		 * @param cmdType cmd类型
		 * @param msgtype 消息类型
		 * @param body 消息数据
		 * @param encodeJson 是否json
		 * @param base64 是否base64
		 * 
		 */		
		public function sendMsg(cmdType:String,body:Object,encodeJson:Boolean = false,base64:Boolean = false):void{
			if(!ExternalInterface.available)
			{
				Logger.getLogger("MSG").info("SWF not in broswer, can not send message!");
				return;
			}
			try{
				Logger.getLogger("WebBridge").info("cmdType:" + cmdType );
				var msgStr:String;
				if(encodeJson){
					msgStr = com.adobe.serialization.json.JSON.encode(body);
					if(base64){
						msgStr = Base64.encode(msgStr);
					}
					ExternalInterface.call(cmdType, msgStr);
				}else{
					ExternalInterface.call(cmdType, body);
				}
				
			}catch(e:Error){
				Logger.getLogger("WebBridge").info("Error: cmdType:" + cmdType);
			};
		}
	}
}


