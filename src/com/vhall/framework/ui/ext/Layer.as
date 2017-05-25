package com.vhall.framework.ui.ext
{
	import com.vhall.framework.app.mvc.IResponder;
	import com.vhall.framework.app.mvc.ResponderMediator;
	import com.vhall.framework.ui.container.Box;

	import flash.display.DisplayObjectContainer;

	/**
	 * 层
	 * @author Sol
	 *
	 */
	public class Layer extends Box implements IResponder
	{
		private var _rm:ResponderMediator;

		public function Layer(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			_rm = new ResponderMediator(this);
		}

		public function careList():Array
		{
			return [];
		}

		public function handleCare(msg:String, ... args):void
		{

		}

		/**
		 * 设置层级是否关心或者取消对事件的关注
		 * @param value
		 *
		 */
		public function setMediatorCare(value:Boolean):void
		{
			if(this._rm == null)
				return;
			if(value)
			{
				this._rm.collectCares();
			}
			else
			{
				this._rm.clean();
			}
		}
	}
}
