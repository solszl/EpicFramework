package com.vhall.framework.ui.container
{
	import com.vhall.framework.ui.controls.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 *	横向布局容器
	 * @author Sol
	 *	@date 2016-05-17
	 */
	public class HBox extends Box
	{
		public var gap:Number = 0;

		/**	初始化的时候， 距离左边距多少*/
		public var marginLeft:Number = 0;

		public var marginRight:Number = 0;

		private var maxHeight:Number = 0;

		private var _verticalAlign:String = "top";

		public function HBox(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			gap = 5;
		}

		override protected function invalidate():void
		{
			super.invalidate();

			// 纵向布局
			layoutVertical();
		}

		override protected function layoutChildren():void
		{
//			super.layoutChildren();
			var numChild:int = this.numChildren;
			var child:DisplayObject;
			var xpos:Number = marginLeft;
			for(var i:int = 0; i < numChild; i++)
			{
				child = getChildAt(i);
				
				if(child is UIComponent && (child as UIComponent).visible == false)
				{
					continue;
				}
				
				child.x = xpos;
				xpos += child.width;
				xpos += gap;

				//取出来最高的，以便纵向布局使用
				maxHeight = child.height > maxHeight ? child.height : maxHeight;
			}

			maxHeight = maxHeight > _height ? maxHeight : _height;
			width += marginRight;
		}

		protected function layoutVertical():void
		{
			var numChild:int = this.numChildren;
			var child:DisplayObject;
			for(var i:int = 0; i < numChild; i++)
			{
				child = getChildAt(i);
				switch(verticalAlign)
				{
					case "top":
						child.y = 0;
						break;
					case "center":
						child.y = maxHeight - child.height >> 1;
						break;
					case "bottom":
						child.y = maxHeight - child.height;
						break;
					default:
						child.y = 0;
						break;
				}
			}
		}

		/**
		 * 纵向布局对齐，默认：<b>top</b>
		 * <li/><b> top </b> 顶端对齐</br>
		 * <li/><b> center </b> 中间对齐</br>
		 * <li/><b> bottom </b> 底部对其</br>
		 */
		[Inspectable(category = "General", enumeration = "top, center, bottom", defaultValue = "top")]
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}

		/**
		 * @private
		 */
		public function set verticalAlign(value:String):void
		{
			_verticalAlign = value;
		}

	}
}
;
