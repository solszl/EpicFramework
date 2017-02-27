package com.vhall.framework.ui.panel
{
	import com.vhall.framework.ui.controls.Button;
	import com.vhall.framework.ui.controls.Image;
	import com.vhall.framework.ui.manager.PanelManager;
	import com.vhall.framework.ui.utils.ComponentUtils;

	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;

	/**
	 * 面板基类
	 * @author Sol
	 * @date 2016-07-26 14:13:28
	 *
	 */
	public class BasePanel extends SimplePanel
	{
		public function BasePanel(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		}

		protected var autoCenter:Boolean = true;

		/**	关闭按钮*/
		protected var btnClose:Button;

		protected var _showCloseButton:Boolean;

		protected var _backgroundImage:Image;

		override protected function createChildren():void
		{
			super.createChildren();

			_backgroundImage = new Image(this);
		}

		public function set backgroundImage(img:Image):void
		{
			if(img == null)
			{
				_backgroundImage.source = ComponentUtils.genInteractiveRect(width, height);
			}
			else
			{
				_backgroundImage = img;
			}
		}

		public function get backgroundImage():Image
		{
			return _backgroundImage;
		}

		public function set showCloseButton(b:Boolean):void
		{
			_showCloseButton = b;
			if(btnClose)
			{
				btnClose.visible = _showCloseButton;
			}
			else
			{
				if(_showCloseButton)
				{
					btnClose = new Button(this);
					addChild(btnClose);
					btnClose.skin = ComponentUtils.genInteractiveRect(20, 20);
					btnClose.label = "X";
					btnClose.addEventListener(MouseEvent.CLICK, onCloseHandler);
				}
			}
		}

		/**	关闭该窗口*/
		protected function onCloseHandler(event:MouseEvent):void
		{
			PanelManager.getInstance().hide(this.id);
		}

		override protected function sizeChanged():void
		{
			super.sizeChanged();
		}

		override protected function updateDisplay():void
		{
			btnClose.move(width - 20 - 4, 4);
			super.updateDisplay();
		}
	}
}
