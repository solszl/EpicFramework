package com.vhall.framework.ui.controls
{
	import com.vhall.framework.app.manager.RenderManager;
	import com.vhall.framework.utils.StringUtil;

	import flash.display.DisplayObjectContainer;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * 文本组件
	 * @author Sol
	 *
	 */
	public class Label extends UIComponent
	{
		protected var htmlFormat:String = "<font align='{2}' color='#{0}' size='{4}' face='{3}'>{1}</font>";
		/**	文本内容*/
		protected var _text:String;
		/**	默认承载文本的容器*/
		protected var _tf:TextField;
		/**	文本格式化*/
		protected var _formmat:TextFormat;
		/**	文本格式发生变化的变量*/
		protected var _textformmatChanged:Boolean = false;

		public var html:Boolean = false;

		public function Label(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			_text = "";
			super(parent, xpos, ypos);
		}

		override protected function createChildren():void
		{
			super.createChildren();

			_tf = new TextField();
			_tf.defaultTextFormat = new TextFormat("Microsoft YaHei", 12, 0x383838);
			_tf.selectable = false;
			_formmat = _tf.defaultTextFormat;
			addChild(_tf);

			font = "Microsoft YaHei";
		}

		override public function set width(value:Number):void
		{
			super.width = value;
			_tf.width = value;
		}

		override public function set height(value:Number):void
		{
			super.height = value;
			_tf.height = value;
		}

		override public function setSize(w:Number, h:Number):void
		{
			super.setSize(w, h);
			_tf.width = w;
			_tf.height = h;
		}

		/**	@private*/
		public function set text(value:String):void
		{
			if(_text == value)
			{
				return;
			}

			_text = value;

			if(StringUtil.isNullOrEmpty(value))
			{
				_text = "";
			}

			if(html)
			{
				this._tf.htmlText = StringUtil.substitute(htmlFormat, color, _text, align, font, fontSize);
			}
			else
			{
				this._tf.text = _text;
			}

			RenderManager.getInstance().invalidate(invalidate);
		}

		/**
		 *	获取文本内容
		 * @return
		 *
		 */
		public function get text():String
		{
			return _text;
		}

		/**
		 *	获取textfield
		 * @return
		 *
		 */
		public function get textField():TextField
		{
			return this._tf;
		}

		/**	@private */
		public function set color(value:Object):void
		{
			if(color == value)
			{
				return;
			}

			this._tf.textColor = uint(value);
			this._formmat.color = value;
			_textformmatChanged = true;
			RenderManager.getInstance().invalidate(invalidate);
		}

		/**	获取文本颜色*/
		public function get color():Object
		{
			return this._formmat.color;
		}

		/**	@private*/
		public function set font(value:String):void
		{
			if(flash.system.Capabilities.manufacturer == "Google Pepper" && _formmat.font == "Microsoft YaHei")
			{
				_formmat.font = "微软雅黑";
			}
			else
			{
				_formmat.font = value;
			}

			_textformmatChanged = true;
			RenderManager.getInstance().invalidate(invalidate);
		}

		/**
		 *	获取当前Label的字体
		 * @return
		 *
		 */
		public function get font():String
		{
			return this._formmat.font;
		}

		/**	@private*/
		public function set fontSize(value:Object):void
		{
			if(fontSize == value)
			{
				return;
			}

			this._formmat.size = value;

			_textformmatChanged = true;
			RenderManager.getInstance().invalidate(invalidate);
		}

		/**
		 *	获取当前Label字号
		 * @return
		 *
		 */
		public function get fontSize():Object
		{
			return this._formmat.size;
		}

		/**	@private*/
		public function set align(value:String):void
		{
			if(align == value)
				return;

			this._formmat.align = value;
			_textformmatChanged = true;
			RenderManager.getInstance().invalidate(invalidate);
		}

		/**
		 *	获取当前Label的对其方式
		 * @return
		 *
		 */
		public function get align():String
		{
			return this._formmat.align;
		}

		/**	@private*/
		public function set bold(value:Boolean):void
		{
			if(bold == value)
			{
				return;
			}

			this._formmat.bold = value;
			_textformmatChanged = true;
			RenderManager.getInstance().invalidate(invalidate);
		}

		/**
		 *	获取当前Label是否为粗体
		 * @return
		 *
		 */
		public function get bold():Boolean
		{
			return this._formmat.bold;
		}

		/**	@private*/
		public function set underline(value:Boolean):void
		{
			if(underline == value)
			{
				return;
			}

			this._formmat.underline = value;
			_textformmatChanged = true;
			RenderManager.getInstance().invalidate(invalidate);
		}

		/**
		 *	获取当前Label是否有下划线
		 * @return
		 *
		 */
		public function get underline():Boolean
		{
			return this._formmat.underline;
		}

		/**	@private*/
		public function set multiline(value:Boolean):void
		{
			if(multiline == value)
			{
				return;
			}

			this._tf.multiline = value;
			_textformmatChanged = true;
			RenderManager.getInstance().invalidate(invalidate);
		}

		/**
		 *	获取当前Label是否为多行
		 * @return
		 *
		 */
		public function get multiline():Boolean
		{
			return this._tf.multiline;
		}

		/**	@private*/
		public function set wordWrap(value:Boolean):void
		{
			if(wordWrap == value)
			{
				return;
			}

			this._tf.wordWrap = value;
			_textformmatChanged = true;
			RenderManager.getInstance().invalidate(invalidate);
		}

		/**
		 *	获取当前Label是否自动换行
		 * @return
		 *
		 */
		public function get wordWrap():Boolean
		{
			return this._tf.wordWrap;
		}

		/**	@private*/
		public function set selectable(value:Boolean):void
		{
			if(selectable == value)
			{
				return;
			}

			this._tf.selectable = value;
			_textformmatChanged = true;
			RenderManager.getInstance().invalidate(invalidate);
		}

		/**
		 *	获取当前Label是否可选择
		 * @return
		 *
		 */
		public function get selectable():Boolean
		{
			return this._tf.selectable;
		}

		override protected function sizeChanged():void
		{
			super.sizeChanged();

			_tf.height = Math.max(_tf.textHeight + 4, 20);

			if(!html)
			{
				if(align == "left")
				{
					_tf.width = _tf.textWidth + 4 + _formmat.indent;
				}

				if(_textformmatChanged)
				{
					this._tf.setTextFormat(this._formmat);
					_textformmatChanged = false;
				}
			}

		}

		override protected function updateDisplay():void
		{
			super.updateDisplay();
			_tf.y = height - _tf.height >> 1;
		}
	}
}
