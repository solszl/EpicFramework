package com.vhall.framework.app.net
{
	import appkit.responders.NResponder;

	import com.vhall.framework.log.Logger;
	import com.vhall.framework.tween.AppTween;

	import flash.utils.Dictionary;

	/**
	 * 抽象消息接收器
	 * @author Sol
	 *
	 */
	public class AbsMsgReceiver
	{
		private var hasCollected:Boolean = false;

		private static var _dic:Dictionary = new Dictionary();

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
			Logger.getLogger("MSG").info("received: " + action);
			NResponder.dispatch(action, params, toTarget)
		}

		/**
		 *	延迟派发事件
		 * @param delay <font color='#FF0000'><b>秒为单位</b></font>
		 * @param action 消息号
		 * @param params 参数列表
		 * @param toTarget 接收消息的目标对象
		 *
		 */
		protected function delayCallDispatch(delay:Number, action:String = null, params:Array = null, toTarget:Object = null):void
		{
			if(delay == 0)
			{
				dispatch(action, params, toTarget);
			}
			else
			{
				AppTween.delayedCall(delay, dispatch, [action, params, toTarget]);
			}
		}
	}
}


