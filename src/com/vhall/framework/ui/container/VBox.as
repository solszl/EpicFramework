package com.vhall.framework.ui.container
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * 纵向布局容器
	 * @author Sol
	 * @date 2016-05-17
	 */
	public class VBox extends Box
	{
		/**
		 *	每项的间隔
		 */
		public var gap:Number = 0;

		private var maxWidth:Number = 0;

		private var _horizontalAlign:String = "left";

		public var marginTop:Number = 0;
		public var marginBottom:Number = 0;

		public function VBox(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			gap = 5;
		}

		override protected function invalidate():void
		{
			super.invalidate();

			layoutHorizontal();
		}

		override protected function layoutChildren():void
		{
//			super.layoutChildren();
			var numChild:int = this.numChildren;
			var child:DisplayObject;
			var ypos:Number = marginTop;
			for(var i:int = 0; i < numChild; i++)
			{
				child = getChildAt(i);
				child.y = ypos;
				ypos += child.height;
				ypos += gap;

				maxWidth = child.width > maxWidth ? child.width : maxWidth;
			}

			height += marginBottom;
		}

		protected function layoutHorizontal():void
		{
			var numChild:int = this.numChildren;
			var child:DisplayObject;
			for(var i:int = 0; i < numChild; i++)
			{
				child = getChildAt(i);
				switch(horizontalAlign)
				{
					case "left":
						child.x = 0;
						break;
					case "middle":
						child.x = maxWidth - child.width >> 1;
						break;
					case "right":
						child.x = maxWidth - child.width;
						break;
					default:
						child.x = 0;
						break;
				}
			}
		}

		/**
		 * 纵向布局对齐，默认：<b>top</b>
		 * <li/><b> left </b> 左侧对齐</br>
		 * <li/><b> middle </b> 中间对齐</br>
		 * <li/><b> right </b> 底部对其</br>
		 */
		[Inspectable(category = "General", enumeration = "left, middle, right", defaultValue = "left")]
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}

		public function set horizontalAlign(value:String):void
		{
			_horizontalAlign = value;
		}

	}
}
