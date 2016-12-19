package com.vhall.framework.ui.controls
{
	import com.vhall.framework.utils.StringUtil;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.text.TextFieldType;

	/**
	 * 文本输入组件
	 * @author Sol
	 * @date 2016-07-27 11:58:58
	 */
	public class TextInput extends Label
	{
		public function TextInput(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			width = 100;
			_tf.background = true;
		}

		override protected function createChildren():void
		{
			super.createChildren();
			_tf.type = TextFieldType.INPUT;
			wordWrap = false;
			multiline = false;
			selectable = true;
			_tf.mouseEnabled = true;
			_tf.addEventListener(Event.CHANGE, onTextChanged);
		}

		protected function onTextChanged(event:Event):void
		{
			text = _tf.text;
		}

		public function set restrict(str:String):void
		{
			_tf.restrict = str;
		}

		public function get restrict():String
		{
			return _tf.restrict;
		}

		public function set maxChars(max:int):void
		{
			_tf.maxChars = max;
		}

		public function get maxChars():int
		{
			return _tf.maxChars;
		}

		public function set displayAsPassword(b:Boolean):void
		{
			_tf.displayAsPassword = b;
		}

		public function get displayAsPassword():Boolean
		{
			return _tf.displayAsPassword;
		}

		override public function set backgroundColor(value:uint):void
		{
			_tf.backgroundColor = value;
		}

		public function get backgroundColor():uint
		{
			return _tf.backgroundColor;
		}

		override protected function sizeChanged():void
		{
			if(_textformmatChanged)
			{
				this._tf.setTextFormat(this._formmat);
				_textformmatChanged = false;
			}

			if(italic)
			{
				_tf.text = StringUtil.rtrim(_tf.text);
				_tf.appendText(" ");
			}

			_tf.height = Math.max(_tf.textHeight + 4, 20);
		}

		override protected function updateDisplay():void
		{
			super.updateDisplay();
			_tf.y = height - _tf.height >> 1;
		}
	}
}
