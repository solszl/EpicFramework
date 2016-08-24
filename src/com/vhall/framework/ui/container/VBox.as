package com.vhall.framework.ui.container
{
	import com.vhall.framework.ui.controls.UIComponent;

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

		private var calcH:Number = 0;

		public function VBox(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			gap = 5;
			super(parent, xpos, ypos);
		}

		override protected function updateDisplay():void
		{
			super.updateDisplay();

			layoutHorizontal();
		}

		override protected function layoutChildren():void
		{
//			super.layoutChildren();
			calcH = 0;

			var numChild:int = this.numChildren;
			var child:DisplayObject;
			var ypos:Number = marginTop;
			for(var i:int = 0; i < numChild; i++)
			{
				child = getChildAt(i);

				if(child is UIComponent && (child as UIComponent).visible == false)
				{
					continue;
				}

				child.y = ypos;
				ypos += child.height;
				ypos += gap;
				calcH += child.height;

				maxWidth = child.width > maxWidth ? child.width : maxWidth;
			}

			maxWidth = maxWidth > _width ? maxWidth : _width;
			calcH += (numChild - 1) * gap;
			height = calcH + marginBottom;
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
