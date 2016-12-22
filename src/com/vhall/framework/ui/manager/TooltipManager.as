package com.vhall.framework.ui.manager
{
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;

	/**
	 * tooltip 管理器
	 * @author Sol
	 * @date 2016-05-26
	 */
	public class TooltipManager
	{

		private static var instance:TooltipManager;

		public static function getInstance():TooltipManager
		{
			if(!instance)
			{
				instance = new TooltipManager();
			}

			return instance;
		}

		public function TooltipManager()
		{
			if(instance)
			{
				throw new IllegalOperationError("Tooltip Manager is singlton");
			}

			instance = this;
		}

		public function registTooltip(target:DisplayObject, tooltip:Object):void
		{
			TooltipManagerImpl.getInstance().registTooltip(target, tooltip);
		}

		public function showHideTooltips(target:DisplayObject, value:Boolean):void
		{
			target = value ? target : null;
			TooltipManagerImpl.getInstance().showHideTip(target);
		}
	}
}
