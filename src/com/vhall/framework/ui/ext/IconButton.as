package com.vhall.framework.ui.ext
{
	import com.vhall.framework.ui.controls.Button;
	import com.vhall.framework.ui.controls.Image;

	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;

	/**
	 * 带有ICON的Button
	 * @author Sol
	 * @date 2016-07-27 11:11:27
	 */
	public class IconButton extends Button
	{
		/**	@default (0,0)*/
		private var _position:Point;

		private var _iconAlign:String = ICONAlign.CENTER;

		private var _icon:Image;

		private var _align:String = "h";

		public var useUnifiedLayout:Boolean = true;

		public var gap:int = 2;

		public function IconButton(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		}

		override protected function createChildren():void
		{
			super.createChildren();
			_icon = new Image(this);
			_position = new Point();
		}

		override protected function updateDisplay():void
		{
			if(useUnifiedLayout)
			{
				switch(align)
				{
					case "h":
						icon.x = (width - (icon.width + btnLabel.width + gap)) >> 1;
						btnLabel.x = icon.x + icon.width + gap;
						var maxH:int = Math.max(icon.height, btnLabel.height);
						icon.y = btnLabel.y = height - maxH >> 1;
						break;
					case "v":
						icon.y = (height - (icon.height + btnLabel.height + gap)) >> 1;
						btnLabel.y = icon.y + icon.height + gap;
						icon.x = width - icon.width >> 1;
						btnLabel.x = width - btnLabel.width >> 1;
						break;
					default:
						layoutICON();
						break;
				}
			}
			else
			{
				layoutICON();
			}

			super.updateDisplay();
		}

		public function get icon():Image
		{
			return this._icon;
		}

		public function set icon(value:*):void
		{
			this._icon.source = value;
		}

		/**	获取ICON对其方式*/
		public function get iconAlign():String
		{
			return this._iconAlign;
		}

		public function set iconAlign(align:String):void
		{
			this._iconAlign = align;
		}

		public function get position():Point
		{
			return this._position;
		}

		public function set position(p:Point):void
		{
			this._position = p;
		}

		public function set align(value:String):void
		{
			this._align = value;
		}

		public function get align():String
		{
			return this._align;
		}

		private function layoutICON():void
		{
			switch(iconAlign.toLowerCase())
			{
				case ICONAlign.LEFT:
					icon.x = 0;
					icon.y = height - icon.height >> 1;
					break;
				case ICONAlign.RIGHT:
					icon.x = width - icon.width;
					icon.y = height - icon.height >> 1;
					break;
				case ICONAlign.TOP:
					icon.x = width - icon.width >> 1;
					icon.y = 0;
					break;
				case ICONAlign.BOTTOM:
					icon.x = width - icon.width >> 1;
					icon.y = height - icon.height;
					break;
				case ICONAlign.TOP_LEFT:
					icon.move(0, 0);
					break;
				case ICONAlign.TOP_RIGHT:
					icon.move(width - icon.width, 0);
					break;
				case ICONAlign.BOTTOM_LEFT:
					icon.move(0, height - icon.height);
					break;
				case ICONAlign.BOTTOM_RIGHT:
					icon.move(width - icon.width, height - icon.height);
					break;
				case ICONAlign.CENTER:
					icon.x = width - icon.width >> 1;
					icon.y = height - icon.height >> 1;
					break;
				case ICONAlign.CUSTOM:
					icon.move(_position.x, _position.y);
					break;
				default:
					break;
			}
		}
	}
}

class ICONAlign
{
	/** 顶部居中*/
	public static const TOP:String = "t";
	/**	底部居中*/
	public static const BOTTOM:String = "b";
	/**	左侧居中*/
	public static const LEFT:String = "l";
	/**	右侧居中*/
	public static const RIGHT:String = "r";
	/**	左上角对齐*/
	public static const TOP_LEFT:String = "tl";
	/**	右上角对齐*/
	public static const TOP_RIGHT:String = "tr";
	/**	左下角对齐*/
	public static const BOTTOM_LEFT:String = "bl";
	/** 右下角对齐*/
	public static const BOTTOM_RIGHT:String = "br";
	/**	用户自定义位置*/
	public static const CUSTOM:String = "cus";
	/**	居中显示*/
	public static const CENTER:String = "cen";
}
