package com.vhall.framework.ui.controls
{
	import com.vhall.framework.utils.StringUtil;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * Tooltip
	 * @author Sol
	 * @2016-05-26 15:28:38
	 */
	public class ToolTip extends Sprite
	{

		private var bg:Shape;

		private var tf:TextField;

		private static const PADDING:Number = 6;
		
		private static const MSG:String = "<font color='#FF0000'>{0}</font>";
		
		private static const MAX_WIDTH:Number = 200;
		
		private var _w:Number = 0;
		private var _h:Number = 0;
		public function ToolTip()
		{
			super();
			bg = new Shape();
			addChild(bg);
		}

		private var _content:String;
		public function setContent(value:String):void
		{
			if(_content == value)
			{
				return;
			}
			
			_content = value;
			initTextField();
			
			tf.wordWrap = false;
			tf.multiline = false;
			tf.htmlText = StringUtil.substitute(MSG,_content);
			tf.width = 0;
			tf.height = 20;
			
			var fmt:TextFormat = tf.defaultTextFormat;
			fmt.leading = 2;
			tf.defaultTextFormat = fmt;
			
			if (tf.textWidth > MAX_WIDTH)
			{
				tf.wordWrap=true;
				tf.multiline=true;
				tf.width=MAX_WIDTH;
			}
			else
			{
				tf.width=tf.textWidth + 6;
			}
			
			tf.height=tf.textHeight + 6;
			
			_w=tf.textWidth + 6 + PADDING * 2;
			_h=tf.textHeight + 6 + PADDING * 2;
			
			drawBackground();
		}


		/**
		 *	@private 初始化文本 
		 * 
		 */		
		private function initTextField():void
		{
			if (tf != null)
			{
				return;
			}
			
			tf = new TextField();
			tf.selectable = false;
			tf.textColor = 0xFFFFFF;
			tf.x = PADDING;
			tf.y = PADDING;
			addChild(tf);
		}
		
		/**
		 * @private 画背景 
		 * 
		 */		
		private function drawBackground():void
		{
			with (bg)
			{
				graphics.clear();
				//边框颜色
				graphics.lineStyle(1.6, 0xa0cc99, 1, true);
				//填充颜色
				graphics.beginFill(0xC0C0C0, .2);
				graphics.drawRoundRect(0, 0, _w - 2 * 1.6, _h - 2 * 1.6, 8, 8);
				graphics.endFill();
			}
		}
	}
}
