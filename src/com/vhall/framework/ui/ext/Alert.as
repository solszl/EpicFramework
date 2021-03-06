package com.vhall.framework.ui.ext
{
	import com.vhall.framework.app.manager.RenderManager;
	import com.vhall.framework.app.manager.StageManager;
	import com.vhall.framework.ui.container.Box;
	import com.vhall.framework.ui.container.HBox;
	import com.vhall.framework.ui.controls.Button;
	import com.vhall.framework.ui.controls.Image;
	import com.vhall.framework.ui.controls.Label;
	import com.vhall.framework.ui.event.CloseEvent;
	import com.vhall.framework.ui.manager.PopupManager;
	import com.vhall.framework.ui.utils.ComponentUtils;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * 弹框
	 * @author Sol
	 * @date 2016-08-06 01:46:56
	 */
	public class Alert extends Box
	{
		[Embed(source = "assets/close.png")]
		private var close:Class;

		public function Alert(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		}

		private var lblTitle:Label;

		private var lblContent:Label;

		private var buttonPool:Array = [];

		private static var alertPool:Array = [];

		private static var closeHandle:Function;

		private var buttonContainer:HBox;

		private var buttons:Object = {};

		private static var okLabel:String = "确定";

		private static var cancelLabel:String = "取消";

		private static var yesLabel:String = "是";

		private static var noLabel:String = "否";

		public static const YES:uint = 0x0001;

		public static const NO:uint = 0x0002;

		public static const OK:uint = 0x0004;

		public static const CANCEL:uint = 0x0008;

		private static var flags:uint;

		private var btnClose:Button;

		override protected function createChildren():void
		{
			super.createChildren();

			lblTitle = new Label(this, 20, 8);
			lblTitle.fontSize = 13;
			lblTitle.bold = true;
			lblTitle.text = "title";

			lblContent = new Label(this, 90, 40);
			lblContent.align = "center";
			lblContent.text = "content";

			drawBackground();

			buttonContainer = new HBox(this);
			buttonContainer.gap = 10;
			btnClose = new Button(this);
			btnClose.right = 10;
			btnClose.y = 10;
			btnClose.skin = close;
			btnClose.addEventListener(MouseEvent.CLICK, onCloseHandler);
		}

		public static function show(title:String = "", content:String = "", flag:uint = Alert.OK, closeHandler:Function = null):Alert
		{
			closeHandle = closeHandler;
			flags = flag;
			var alert:Alert = alertPool.length > 0 ? alertPool.pop() : new Alert();
			alert.title = title;
			alert.content = content;
			PopupManager.addPopup(alert, StageManager.stage);
			return alert;
		}

		private var _title:String;

		private var _content:String;

		private var _icon:Object;

		public function set title(value:String):void
		{
			_title = value;
			RenderManager.getInstance().invalidate(invalidate);
		}

		public function set content(value:String):void
		{
			_content = value;
			RenderManager.getInstance().invalidate(invalidate);
		}

		override protected function invalidate():void
		{
			lblTitle.text = _title;
			lblContent.text = _content;
			generateButtons();
			super.invalidate();
		}

		override protected function sizeChanged():void
		{
			super.sizeChanged();
			lblContent.width = width;
		}

		override protected function updateDisplay():void
		{
			super.updateDisplay();
			var btnW:Number = buttonContainer.numChildren * 78 + (buttonContainer.numChildren - 1) * 10;
			buttonContainer.x = (width - buttonContainer.width) * .5;
			buttonContainer.y = height - 30 - 15 - 5;

			lblContent.y = (height - lblContent.height >> 1) - 10;
			lblContent.x = width - lblContent.width >> 1;
		}

		private function generateButtons():void
		{
			for each(var buttonItem:Button in buttons)
			{
				buttonContainer.removeChild(buttonItem);
				buttonItem.removeEventListener(MouseEvent.CLICK, clickHandler);
				buttonPool.push(buttonItem);
			}
			buttons = {};

			if(flags & Alert.OK)
			{
				buttons[Alert.OK] = createButton(Alert.okLabel, Alert.OK);
			}

			if(flags & Alert.CANCEL)
			{
				buttons[Alert.CANCEL] = createButton(Alert.cancelLabel, Alert.CANCEL);
			}

			if(flags & Alert.YES)
			{
				buttons[Alert.YES] = createButton(Alert.yesLabel, Alert.YES);
			}

			if(flags & Alert.NO)
			{
				buttons[Alert.NO] = createButton(Alert.noLabel, Alert.NO);
			}
		}

		private function clickHandler(event:MouseEvent):void
		{
			var button:Button = Button(event.currentTarget);
			PopupManager.removePopup(this);

			if(closeHandle != null)
			{
				var closeEvent:CloseEvent = new CloseEvent(CloseEvent.CLOSE, false, false, getDetailBy(button));
				closeHandle(closeEvent);
			}

			alertPool.push(this);
		}

		private function onCloseHandler(e:MouseEvent):void
		{
			PopupManager.removePopup(this);
			if(closeHandle != null)
			{
				var closeEvent:CloseEvent = new CloseEvent(CloseEvent.CLOSE, false, false, getDetailBy(null));
				closeHandle(closeEvent);
			}
			alertPool.push(this);
		}

		private function getDetailBy(button:Button):int
		{
			if(button == null)
			{
				return 0;
			}

			if((button.userData == null))
			{
				return 0;
			}

			return uint(button.userData);
		}

		private function createButton(label:String, eventKey:uint):Button
		{
			var button:Button = buttonPool.length > 0 ? buttonPool.pop() : new Button();
			switch(eventKey)
			{
				case Alert.OK:
				case Alert.YES:
					genRedSkin(button);
					break;
				case Alert.CANCEL:
				case Alert.NO:
					genNormalSkin(button);
					break;
				default:
					genNormalSkin(button);
					break;
			}

			button.labelSize = 14;
			button.buttonMode = true;
			button.label = label;
			button.useFilter = false;
			//			button.setSize(76, 30);
			button.x = buttonContainer.numChildren * (5 + 76);
			button.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			button.userData = eventKey;
//			button.validateNow();
//			button.showBorder(0xd0cdcd);

			return Button(buttonContainer.addChild(button));
		}

		private function drawBackground():void
		{
			graphics.clear();
			// 灰色背景
			graphics.beginFill(0xfc565a);
			graphics.drawRoundRect(0, 0, 300, 160, 8, 8);
			graphics.endFill();
			// 白色背景
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 5, 300, 160);
			graphics.endFill();
			// 标题背景
			//			graphics.beginFill(0xF3F3F3);
			//			graphics.drawRect(3, 3, 294, 32);
			//			graphics.endFill();

			width = 300;
		}

		private function genNormalSkin(button:Button):Button
		{
			button.overSkin = ComponentUtils.genInteractiveRect(76, 28, null, 0, 0, 0xd2d2d2, 1, 1, 0xd2d2d2, 1, 4, 4);
			button.downSkin = ComponentUtils.genInteractiveRect(76, 28, null, 0, 0, 0x999999, 1, 1, 0x999999, 1, 4, 4);
			button.skin = ComponentUtils.genInteractiveRect(76, 28, null, 0, 0, 0xffffff, 1, 1, 0x999999, 1, 4, 4);
			button.labelColor = "0x999999~0xffffff~0xffffff";
			return button;
		}

		private function genRedSkin(button:Button):Button
		{
			button.overSkin = ComponentUtils.genInteractiveRect(76, 28, null, 0, 0, 0xfc5659, 1, 1, 0xfc5659, 1, 4, 4);
			button.downSkin = ComponentUtils.genInteractiveRect(76, 28, null, 0, 0, 0xe24d4f, 1, 1, 0xe24d4f, 1, 4, 4);
			button.skin = ComponentUtils.genInteractiveRect(76, 28, null, 0, 0, 0xFFFFFF, 1, 1, 0xfc5659, 1, 4, 4);
			button.labelColor = "0xfc5659~0xffffff~0xffffff";
			return button;
		}
	}
}
