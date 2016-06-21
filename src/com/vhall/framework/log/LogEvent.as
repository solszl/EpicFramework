package com.vhall.framework.log
{
	import flash.events.Event;
	
	/**
	 *	日志事件 
	 * @author Sol
	 * @2016-06-21 12:18:28
	 */	
	public class LogEvent extends Event
	{
		public static const Changed:String = "log_changed";
		public var time:String;
		
		public var content:String;
		
		public function LogEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			super.clone();
			var e:LogEvent = new LogEvent(Changed);
			e.time = time;
			e.content = content;
			return e;
		}
	}
}