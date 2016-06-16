package com.vhall.framework.ui.controls
{
	import com.vhall.framework.app.manager.RenderManager;
	import com.vhall.framework.ui.interfaces.IState;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

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
		private var btnLabel:Label;

		private var _skin:Object;
		private var _label:String;
		private var _labelColor:Object;
		private var _labelSize:Object;

		private var _labelChanged:Boolean = false;

		private var _labelColorChanged:Boolean = false;

		public function Button(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			this.btnLabel.text = "";
			labelColor = Style.Button_Label_Color;
			propertiesDic["skin"] = [];
			propertiesDic["label"] = [];
			propertiesDic["labelColor"] = [];
		}

		override protected function createChildren():void
		{
			super.createChildren();

			// 背景
			bg = new Image(this);
			// 文本
			btnLabel = new Label(this);

			mouseChildren = false;
			buttonMode = true;
			useHandCursor = true;

			addEventListener(MouseEvent.ROLL_OVER, onMouse);
			addEventListener(MouseEvent.ROLL_OUT, onMouse);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
			addEventListener(MouseEvent.MOUSE_UP, onMouse);
			addEventListener(MouseEvent.CLICK, onMouse);
		}

		protected var stateMap:Object = {"rollOver":1, "rollOut":0, "mouseDown":2, "mouseUp":1, "selected":2};
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
			btnLabel.fontSize = value;
			RenderManager.getInstance().invalidate(invalidate);
		}
		
		public function get labelSize():Object
		{
			return _labelSize;
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
		 *	拿到属性
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
				
				bg.source = getProperty("skin", state);
				bg.setBitmapDataCallBK = updateDisplay;
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
			
			width = bg.width;
			height = bg.height;
		}

		override protected function updateDisplay():void
		{
			super.updateDisplay();
			// 让文本居中， 此处没考虑文本宽度 大于 背景的情况
			var xpos:Number = bg.width - btnLabel.width >> 1;
			var ypos:Number = bg.height - btnLabel.height >> 1;
			btnLabel.move(xpos, ypos);
		}
	}
}
