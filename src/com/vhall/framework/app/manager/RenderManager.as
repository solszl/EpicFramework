package com.vhall.framework.app.manager
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * 渲染管理器
	 * @author Sol
	 *
	 */
	public class RenderManager
	{
		private static var _instance:RenderManager;

		private var renders:Dictionary;

		public static function getInstance():RenderManager
		{
			if(!_instance)
			{
				_instance = new RenderManager();
			}

			return _instance;
		}

		public function RenderManager()
		{
			if(_instance)
			{
				throw new IllegalOperationError("RenderManager is singleton");
			}

			_instance = this;
			renders = new Dictionary();
		}

		private function invalide():void
		{
			if(!StageManager.stage)
			{
				return;
			}

			StageManager.stage.addEventListener(Event.ENTER_FRAME, onValide);
			StageManager.stage.addEventListener(Event.RENDER, onValide);
			StageManager.stage.invalidate();
		}

		private function onValide(e:Event):void
		{
			StageManager.stage.removeEventListener(Event.ENTER_FRAME, onValide);
			StageManager.stage.removeEventListener(Event.RENDER, onValide);
			validateNow();
		}

		public function validateNow():void
		{
			for(var func:Object in renders)
			{
				validate(func as Function);
			}

			for each(func in renders)
			{
				return validateNow();
			}
		}

		public function invalidate(func:Function, args:Array = null):void
		{
			renders[func] = args || [];
			invalide();
		}

		public function validate(func:Function):void
		{
			if(renders[func] != null)
			{
				var args:Array = renders[func];
				delete renders[func];
				func.apply(null, args);
			}
		}
	}
}
