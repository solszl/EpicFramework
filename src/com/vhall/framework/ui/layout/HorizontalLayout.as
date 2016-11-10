package com.vhall.framework.ui.layout
{
	import com.vhall.framework.ui.container.Box;
	import com.vhall.framework.ui.controls.UIComponent;

	import flash.display.DisplayObject;

	/**
	 * 水平布局
	 * @author Sol
	 * @date 2016-11-07 00:05:54
	 */
	public class HorizontalLayout extends Layout
	{
		public function HorizontalLayout()
		{
			super();
			type = "HorizontalLayout";
		}

		private var calcW:Number = 0;

		/**	初始化的时候， 距离左边距多少*/
		public var marginLeft:Number = 0;

		public var marginRight:Number = 0;

		private var maxHeight:Number = 0;

		protected var _gap:Number = 5;

		public function set gap(s:Number):void
		{
			if(_gap == s)
			{
				return;
			}

			_gap = s;
			if(target)
			{
				doLayout(target);
			}
		}

		public function get gap():Number
		{
			return _gap;
		}

		protected var _horizontalAlign:String = "left";
		protected var _verticalAlign:String = "top";

		/**
		 * 横向布局对齐，默认：<b>left</b>
		 * <li/><b> left </b> 左对齐</br>
		 * <li/><b> middle </b> 中间对齐</br>
		 * <li/><b> right </b> 右对奇</br>
		 */
		[Inspectable(category = "General", enumeration = "left,right,center", defaultValue = "left")]
		public function get horizontalAlign():String
		{
			return _horizontalAlign;
		}

		/**
		 *  @private
		 */
		public function set horizontalAlign(value:String):void
		{
			if(value == _horizontalAlign)
				return;

			_horizontalAlign = value;

			if(target)
				target.validateNextFrame();
		}

		/**
		 * 纵向布局对齐，默认：<b>top</b>
		 * <li/><b> top </b> 顶端对齐</br>
		 * <li/><b> center </b> 中间对齐</br>
		 * <li/><b> bottom </b> 底部对齐</br>
		 */
		[Inspectable(category = "General", enumeration = "top,middle,bottom", defaultValue = "top")]
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}

		public function set verticalAlign(value:String):void
		{
			if(value == _verticalAlign)
				return;

			_verticalAlign = value;

			if(target)
				target.validateNextFrame();
		}

		override public function doLayout(target:Box):void
		{
			if(!target)
				return;
			this.target = target;

			layoutChildren();
			// 纵向布局
			layoutVertical();
			// 横向布局，左中右
			layoutHorizontal();
		}

		protected function layoutChildren():void
		{
			calcW = 0;
			var numChild:int = target.numChildren;
			var child:DisplayObject;
			var xpos:Number = marginLeft;
			// hbox内，显示的元素总数
			var showChildrenCount:int = 0;
			for(var i:int = 0; i < numChild; i++)
			{
				child = target.getChildAt(i);

				if(child is UIComponent && (child as UIComponent).visible == false)
				{
					continue;
				}

				child.x = xpos;
				xpos += child.width;
				xpos += gap;
				calcW += child.width;
				showChildrenCount++;
				//取出来最高的，以便纵向布局使用
				maxHeight = child.height > maxHeight ? child.height : maxHeight;
			}

			maxHeight = maxHeight > target.height ? maxHeight : target.height;
			calcW += (showChildrenCount - 1) * gap;
			_measureWidth = calcW + marginRight;
			_measureHeight = maxHeight;
		}

		protected function layoutVertical():void
		{
			var numChild:int = target.numChildren;
			var child:DisplayObject;
			for(var i:int = 0; i < numChild; i++)
			{
				child = target.getChildAt(i);
				switch(verticalAlign)
				{
					case "top":
						child.y = 0;
						break;
					case "middle":
						child.y = (maxHeight - child.height) / 2;
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

		protected function layoutHorizontal():void
		{
			if(_horizontalAlign == "left")
			{
				return;
			}
			var acH:Number = isNaN(target.explicitHeight) ? _measureHeight : target.explicitHeight;
			var deltaX:Number = acH - calcW;
			var child:DisplayObject;
			var i:int = 0;
			for(i = 0; i < target.numChildren; i++)
			{
				child = target.getChildAt(i);
				switch(_horizontalAlign)
				{
					case "center":
						child.x += deltaX >> 1;
						break;
					case "right":
						child.x += deltaX;
						break;
				}
			}
		}
	}
}
