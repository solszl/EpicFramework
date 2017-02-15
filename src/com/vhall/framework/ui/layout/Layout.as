package com.vhall.framework.ui.layout
{
	import com.vhall.framework.ui.container.Box;
	import com.vhall.framework.ui.controls.UIComponent;
	import com.vhall.framework.ui.interfaces.ILayout;

	import flash.display.DisplayObject;

	/**
	 * 默认布局排列方式
	 * @author Sol
	 * @date 2016-11-06 23:48:25
	 */
	public class Layout implements ILayout
	{
		protected var type:String;

		protected var _measureHeight:Number;

		protected var _measureWidth:Number;

		protected var target:Box;

		public function Layout()
		{
			type = "Layout";
		}

		public function doLayout(target:Box):void
		{
			this.target = target;
			var child:DisplayObject;
			var num:int = target.numChildren;
			var comp:UIComponent;
			var calcW:Number = 0;
			var calcH:Number = 0;

			var i:int = 0;
			//计算预估关高
			//			for(i = 0; i < num; i++)
			//			{
			//				child = this.getChildAt(i);
			//				var w:Number = child.width + child.x;
			//				var h:Number = child.height + child.y;
			//				calcW = w > calcW ? w : calcW;
			//				calcH = h > calcH ? h : calcH;
			//			}
			//
			//			var explicitw:Number = _width > calcW ? _width : calcW;
			//			var explicith:Number = _height > calcH ? _height : calcH;

			var explicitw:Number = target.width;
			var explicith:Number = target.height;

			// 根据预估的宽高进行布局
			for(i = 0; i < num; i++)
			{
				child = target.getChildAt(i);

				if((child is UIComponent) == false)
				{
					continue;
				}

				comp = child as UIComponent;

				// 如果上下左右有不为空的，则进行布局
				if(comp.left != null || comp.right != null || comp.top != null || comp.bottom != null)
				{
					// 左右都有，重新计算宽
					if(comp.left != null && comp.right != null)
					{
						comp.width = explicitw - Number(comp.left) - Number(comp.right);
						comp.x = Number(comp.left);
					}
					else
					{
						if(comp.left != null)
						{
							comp.x = Number(comp.left);
						}

						if(comp.right != null)
						{
							comp.x = explicitw - Number(comp.width) - Number(comp.right);
						}
					}

					//上下都有， 重新计算高度
					if(comp.top != null && comp.bottom != null)
					{
						comp.height = explicith - Number(comp.top) - Number(comp.bottom);
						comp.y = Number(comp.top);
					}
					else
					{
						if(comp.top != null)
						{
							comp.y = Number(comp.top)
						}

						if(comp.bottom != null)
						{
							comp.y = explicith - Number(comp.height) - Number(comp.bottom);
						}
					}
				}

				if(!isNaN(comp.horizontalCenter))
				{
					UIComponent(comp).x = (explicitw - comp.width >> 1) + UIComponent(comp).horizontalCenter;
				}

				if(!isNaN(comp.verticalCenter))
				{
					UIComponent(comp).y = (explicith - comp.height >> 1) + UIComponent(comp).verticalCenter;
				}
			}

			this._measureHeight = explicitw;
			this._measureHeight = explicith;
		}

		public function get measureHeight():Number
		{
			return this._measureHeight;
		}

		public function get measureWidth():Number
		{
			return this._measureWidth;
		}

		public function toString():String
		{
			return type;
		}
	}
}
