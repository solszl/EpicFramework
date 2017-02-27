package com.vhall.framework.ui.panel
{
	import com.vhall.framework.ui.container.Box;

	import flash.display.DisplayObjectContainer;

	public class SimplePanel extends Box implements IPanel
	{
		public function SimplePanel(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		}

		/**	打开状态*/
		protected var _isOpen:Boolean = false;

		/**	面板是否互斥*/
		protected var _isMutex:Boolean = false;

		protected var _id:int = 0;

		public function show(... arg):void
		{
			_isOpen = true;
		}

		public function hide():void
		{
			_isOpen = false;
		}

		public function get isOpen():Boolean
		{
			return _isOpen;
		}

		public function get isMutex():Boolean
		{
			return _isMutex;
		}

		public function set isMutex(b:Boolean):void
		{
			_isMutex = b;
		}

		public function get id():int
		{
			return this._id;
		}

		public function set id(id:int):void
		{
			this._id = id;
		}

		/**
		 * 提升到最前面
		 *
		 */
		public function bring2top():void
		{
			if(!this.parent)
			{
				return;
			}

			var parentNum:int = this.parent.numChildren;

			this.parent.setChildIndex(this, parentNum - 1);
		}
	}
}
