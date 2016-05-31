package com.vhall.framework.app.net
{
	import flash.utils.Dictionary;
	
	import appkit.responders.NResponder;

	/**
	 * 抽象消息接收器
	 * @author Sol
	 *
	 */
	public class AbsMsgReceiver
	{
		private var hasCollected:Boolean = false;

		private var _dic:Dictionary = new Dictionary();

		public function AbsMsgReceiver()
		{
		}

		protected function collectionObservers():void
		{
			throw new Error("implement by subclass");
		}

		public function getObservers():Dictionary
		{
			if(!hasCollected)
			{
				collectionObservers();
				hasCollected = true;
			}

			return _dic;
		}

		protected function register(cmd:String, excuter:Function):void
		{
			if(cmd in _dic)
			{
				trace("[warning]" + cmd + "has already been registed");
			}

			if(excuter == null)
			{
				throw new Error("message excuter is null");
			}

			_dic[cmd] = excuter;
		}
		
		protected function dispatch(action:String = null, params:Array = null, toTarget:Object = null):void
		{
			NResponder.dispatch(action,params,toTarget)
		}
	}
}
