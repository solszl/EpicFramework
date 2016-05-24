package com.vhall.framework.app.mvc
{
	import appkit.responders.NResponder;

	/**
	 *	消息响应中介器 
	 * @author Sol
	 * @date 2016-05-24
	 */	
	public class ResponderMediator
	{
		private var _self:Object;

		public function ResponderMediator(self:Object)
		{
			this._self = self;
			collectCares();
		}

		/**
		 *	收集关心的事件 
		 * 
		 */		
		private function collectCares():void
		{
			var msgs:Array = (this._self as IResponder).careList();
			for each (var msg:String in msgs)
			{
				NResponder.add(msg, handleCare);
			}
		}

		/**
		 *	 
		 * @param args
		 * 
		 */		
		private function handleCare(... args):void
		{
			var res:NResponder = NResponder.currentNResponder;
			args.unshift(res.action);
			(this._self as IResponder).handleCare.apply(null,args);
		}
		
		/**
		 * 清理该界面关心的事件 
		 * 
		 */		
		public function clean():void
		{
			var msgs:Array = (this._self as IResponder).careList();
			for each (var msg:String in msgs) 
			{
				NResponder.remove(msg,handleCare);
			}
		}
	}
}