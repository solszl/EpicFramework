package com.vhall.framework.ui.manager
{
	import com.vhall.framework.app.App;
	
	import flash.display.DisplayObject;

	/**
	 * 模态控制器 
	 * @author Sol
	 * 
	 */	
	public class ModalController
	{
		
		private var _modaling:Boolean;
		
		private var target:DisplayObject;
		
		public function ModalController()
		{
		}
		
		public function setTarget(value:DisplayObject):void
		{
			this.target = value;
		}
		
		public function setModal():void
		{
			if(target)
			{
				_modaling = true;
				target.alpha = 0.3;
				App.app.stage.focus = null;
			}
		}
		
		public function removeModal():void
		{
			if(target)
			{
				_modaling = false;
				target.alpha = 1;
			}
		}
		
		public function get modaling():Boolean
		{
			return _modaling;
		}
	}
}