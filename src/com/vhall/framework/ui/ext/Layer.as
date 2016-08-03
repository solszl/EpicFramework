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
		public function Layer(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			new ResponderMediator(this);
		}

		public function careList():Array
		{
			return [];
		}

		public function handleCare(msg:String, ... args):void
		{

		}
	}
}
