package com.vhall.framework.ui.layout
{
	import com.vhall.framework.ui.controls.UIComponent;

	import flash.display.DisplayObject;

	/**
	 * 纵向布局
	 * @author Sol
	 * @date 2016-11-10 18:06:11
	 */
	public class VerticalLayout extends HorizontalLayout
	{
		private var calcH:Number = 0;

		public var marginTop:Number = 0;

		public var marginBottom:Number = 0;

		private var maxWidth:Number = 0;

		public function VerticalLayout()
		{
			super();
			type = "VerticalLayout";
		}

		override protected function layoutChildren():void
		{
			calcH = 0;
			var numChild:int = target.numChildren;
			var child:DisplayObject;
			var ypos:Number = marginTop;
			// vbox内，显示的元素总数
			var showChildrenCount:int = 0;

			for(var i:int = 0; i < numChild; i++)
			{
				child = target.getChildAt(i);

				if(child is UIComponent && (child as UIComponent).visible == false)
				{
					continue;
				}

				child.y = ypos;
				ypos += child.height;
				ypos += gap;
				calcH += child.height;
				showChildrenCount++;
				maxWidth = child.width > maxWidth ? child.width : maxWidth;
			}

			maxWidth = maxWidth > target.width ? maxWidth : target.width;
			calcH += (showChildrenCount - 1) * gap;
			this._measureHeight = calcH + marginBottom;
			this._measureWidth = maxWidth;
		}

		override protected function layoutVertical():void
		{
			if(_verticalAlign == "top")
				return;

			var acH:Number = isNaN(target.explicitHeight) ? _measureHeight : target.explicitHeight;
			var deltaX:Number = acH - calcH;
			var child:DisplayObject;
			var i:int = 0;

			for(i = 0; i < target.numChildren; i++)
			{
				child = target.getChildAt(i);

				switch(_verticalAlign)
				{
					case "middle":
						child.y += deltaX / 2;
						break;
					case "bottom":
						child.y += deltaX;
						break;
				}
			}
		}

		override protected function layoutHorizontal():void
		{
			var numChild:int = target.numChildren;
			var child:DisplayObject;

			for(var i:int = 0; i < numChild; i++)
			{
				child = target.getChildAt(i);

				switch(_horizontalAlign)
				{
					case "left":
						child.x = 0;
						break;
					case "center":
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
	}
}
