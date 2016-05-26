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
		/**	默认承载文本的容器*/
		private var _tf:TextField;
		/**	文本格式化*/
		private var _formmat:TextFormat;
		/**	文本内容*/
		private var _text:String;
		/**	文本格式发生变化的变量*/
		private var _textformmatChanged:Boolean = false;

		public function Label(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		}

		override protected function createChildren():void
		{
			super.createChildren();

			_tf = new TextField();
			_tf.defaultTextFormat = new TextFormat("SimSun", 14);
			_tf.selectable = false;
			_tf.autoSize = "left";
			_formmat = _tf.defaultTextFormat;
			addChild(_tf);
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
			this._tf.text = text;
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
			if(font == value)
			{
				return;
			}

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
		public function set algin(value:String):void
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

		override protected function invalidate():void
		{
			super.invalidate();

			if(_textformmatChanged)
			{
				this._tf.setTextFormat(this._formmat);
				_textformmatChanged = false;
			}

			_tf.height = Math.max(_tf.textHeight + 4, 20);
			_tf.width = _tf.textWidth + 4 + _formmat.indent;
		}
	}
}
