package com.vhall.framework.ui.controls
{
	import com.vhall.framework.app.manager.RenderManager;
	import com.vhall.framework.ui.interfaces.IState;
	import com.vhall.framework.utils.ColorUtil;

	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * 按钮类
	 * @author Sol
	 * @date 2016-05-16
	 */
	public class Button extends UIComponent implements IState
	{
		/** 背景*/
		private var bg:Image;

		/**	文本*/
		protected var btnLabel:Label;

		private var _skin:Object;

		private var _label:String;

		private var _labelColor:Object;

		private var _labelSize:Object;

		private var _labelChanged:Boolean = false;

		private var _labelColorChanged:Boolean = false;

		public function Button(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			propertiesDic["skin"] = [];
			propertiesDic["label"] = [];
			propertiesDic["labelColor"] = [];
			super(parent, xpos, ypos);
			this.btnLabel.text = "";
			this.btnLabel.validateNow();
			labelColor = Style.Button_Label_Color;
		}

		override protected function createChildren():void
		{
			super.createChildren();

			// 背景
			bg = new Image(this);
			// 文本
			btnLabel = new Label(this);
			btnLabel.multiline = false;
			btnLabel.wordWrap = false;
			btnLabel.align = "center";
			btnLabel.height = 24;

			mouseChildren = false;
			buttonMode = true;
			useHandCursor = true;
			addEventListener(MouseEvent.CLICK, onIntercept, false, 999);
			addEventListener(MouseEvent.ROLL_OVER, onMouse);
			addEventListener(MouseEvent.ROLL_OUT, onMouse);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
			addEventListener(MouseEvent.MOUSE_UP, onMouse);
			addEventListener(MouseEvent.CLICK, onMouse);
		}

		protected var stateMap:Object = {"rollOver": 1, "rollOut": 0, "mouseDown": 2, "mouseUp": 1, "selected": 2};

		private var _state:int = -1;

		private var _stateChanged:Boolean = false;

		private var lastState:int = -1;

		public function set state(value:int):void
		{
			if(_state == value)
			{
				return;
			}
			// 状态发生变化， 刷新UI
			_state = value;
			_stateChanged = true;
			RenderManager.getInstance().invalidate(invalidate);
		}

		public function get state():int
		{
			return _state;
		}

		protected function onMouse(e:MouseEvent):void
		{
			if(e.type == MouseEvent.CLICK)
			{
				return;
			}
			// 根据状态刷新展示
			state = stateMap[e.type];
		}

		override protected function invalidate():void
		{
			if(_labelColorChanged)
			{
				btnLabel.color = getProperty("labelColor", state);
				_labelColorChanged = false;
			}

			super.invalidate();
		}

		public function get skin():Object
		{
			return _skin;
		}

		public function set skin(value:Object):void
		{
			if(_skin == value)
			{
				return;
			}
			_skin = value;
			propertiesDic["skin"][0] = value;
			state = stateMap["rollOut"];
		}

		private var _overSkin:Object;

		public function set overSkin(value:Object):void
		{
			if(_overSkin == value)
			{
				return;
			}

			_overSkin = value;
			propertiesDic["skin"][1] = value;
		}

		public function get overSkin():Object
		{
			return _overSkin;
		}

		private var _downSkin:Object;

		public function set downSkin(value:Object):void
		{
			if(_downSkin == value)
			{
				return;
			}

			_downSkin = value;
			propertiesDic["skin"][2] = value;
		}

		public function get downSkin():Object
		{
			return _downSkin;
		}


		public function get label():String
		{
			return _label;
		}

		public function set label(value:String):void
		{
			if(_label == value)
			{
				return;
			}

			_label = value;
			_labelChanged = true;
			splitPropertyString("label", value);
			RenderManager.getInstance().invalidate(invalidate);
		}

		public function get labelColor():Object
		{
			return _labelColor;
		}

		public function set labelColor(value:Object):void
		{
			if(_labelColor == value)
			{
				return;
			}

			_labelColor = value;
			_labelColorChanged = true;
			splitPropertyString("labelColor", value.toString());
			RenderManager.getInstance().invalidate(invalidate);
		}

		public function set labelSize(value:Object):void
		{
			if(_labelSize == value)
			{
				return;
			}

			_labelSize = value;
			btnLabel.fontSize = labelSize;
			RenderManager.getInstance().invalidate(invalidate);
		}

		public function get labelSize():Object
		{
			return _labelSize;
		}

		/**	设置按钮皮肤，即时刷新样式*/
		public function setSkin(value:Object):void
		{
			propertiesDic["skin"][0] = value;
			bg.source = getProperty("skin", state);
			RenderManager.getInstance().invalidate(invalidate);
		}

		private var propertiesDic:Dictionary = new Dictionary();

		/**
		 * 平分属性
		 * @param property
		 * @param value
		 *
		 */
		private function splitPropertyString(property:String, value:String):void
		{
			var arr:Array = value.split('~');
			propertiesDic[property] = arr;
		}

		/**
		 * 拿到属性
		 * @param name
		 * @param index
		 * @return
		 *
		 */
		private function getProperty(name:String, index:int):Object
		{
			if(propertiesDic[name][index] == null)
			{
				propertiesDic[name][index] = propertiesDic[name][0];
			}

			return propertiesDic[name][index];
		}

		override protected function sizeChanged():void
		{
			super.sizeChanged();

			// 如果和上一个状态相同，return
			if(_stateChanged)
			{
				if(lastState == state)
				{
					return
				}

				bg.setBitmapDataCallBK = updateDisplay;
				bg.source = getProperty("skin", state);
				btnLabel.text = getProperty("label", state) == null ? "" : getProperty("label", state).toString();
				btnLabel.color = getProperty("labelColor", state) == null ? Style.Button_Label_Color : getProperty("labelColor", state);
				lastState = state;
				_stateChanged = false;
			}

			if(_labelChanged)
			{
				btnLabel.text = getProperty("label", state).toString();
				_labelChanged = false;
			}

//			bg.width = _width;
//			bg.height = _height;
			width = bg.width;
			height = bg.height;
			btnLabel.width = width;
			if(!useFilter)
				return;
			switch(state)
			{
				case 0:
					ColorUtil.removeAllFilter(bg);
					break;
				case 1:
					ColorUtil.addColor(bg, 50, 0, 20);
					break;
				case 2:
					ColorUtil.addColor(bg, 50, 0, 20);
//					ColorUtil.addColor(bg, -34, 0, -20);
					break;
			}
		}

		override protected function updateDisplay():void
		{
			super.updateDisplay();
			btnLabel.y = bg.height - btnLabel.height >> 1;
		}

		private var interval:uint = 300;
		private var lastClick:Number = getTimer();

		private function onIntercept(event:MouseEvent):void
		{
			if(false == useClickDelay)
			{
				return;
			}
			var t:Number = getTimer();
			if(t - lastClick < clickDelay)
			{
				event.stopImmediatePropagation();
			}
			lastClick = t;
		}

		/**	是否使用双击间隔机制*/
		public function get useClickDelay():Boolean
		{
			return _useClickDelay;
		}

		public function set useClickDelay(value:Boolean):void
		{
			_useClickDelay = value;
		}

		/**	鼠标双击间隔，默认为300毫秒*/
		public function get clickDelay():Number
		{
			return _clickDelay;
		}

		public function set clickDelay(value:Number):void
		{
			_clickDelay = value;
		}


		private var _clickDelay:Number = 350;
		private var _useClickDelay:Boolean = false;

		public var useFilter:Boolean = true;
	}
}
