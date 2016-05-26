package com.vhall.framework.ui.container
{
	import com.vhall.framework.app.manager.RenderManager;
	import com.vhall.framework.ui.controls.UIComponent;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 *	容器基类
	 * @author Sol
	 *	@date 2016-05-17
	 */
	public class Box extends UIComponent
	{
		protected var children:Vector.<DisplayObject>;

		public function Box(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		}

		override protected function createChildren():void
		{
			super.createChildren();
			children = new Vector.<DisplayObject>();
		}

		override public function addChild(child:DisplayObject):DisplayObject
		{
			children.push(child);
			var obj:DisplayObject = super.addChild(child);
			RenderManager.getInstance().invalidate(invalidate);
			return obj;
		}

		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			if(index > children.length)
			{
				index = children.length;
			}
			children.splice(index, 0, child);
			var obj:DisplayObject = super.addChildAt(child, index);
			RenderManager.getInstance().invalidate(invalidate);
			return obj;
		}

		override public function removeChild(child:DisplayObject):DisplayObject
		{
			var chIndex:int = children.indexOf(child)
			if(chIndex > -1)
			{
				children.splice(chIndex, 1);
			}

			var obj:DisplayObject = super.removeChild(child);
			RenderManager.getInstance().invalidate(invalidate);
			return obj;
		}

		override public function removeChildAt(index:int):DisplayObject
		{
			if(index > children.length || index < 0 || children.length == 0)
			{
				return null;
			}

			children.splice(index, 1);
			var obj:DisplayObject = super.removeChildAt(index);
			RenderManager.getInstance().invalidate(invalidate);
			return obj;
		}

		/**
		 *	半开半闭区间  [bengin, end)
		 * @param beginIndex
		 * @param endIndex
		 *
		 */
		override public function removeChildren(beginIndex:int = 0, endIndex:int = int.MAX_VALUE):void
		{
			if(beginIndex > children.length || beginIndex < 0)
			{
				return;
			}

			if(endIndex < beginIndex || endIndex < 0)
			{
				return;
			}

			endIndex = endIndex >= children.length ? children.length - 1 : endIndex;

			children.splice(beginIndex, endIndex - beginIndex + 1);
			super.removeChildren(beginIndex, endIndex);
			RenderManager.getInstance().invalidate(invalidate);
		}

		override public function get numChildren():int
		{
			return children.length;
		}

		override public function getChildAt(index:int):DisplayObject
		{
			return children[index];
		}

		override protected function invalidate():void
		{
			layoutChildren();

			super.invalidate();
		}

		public function removeAllChild():void
		{
			while(numChildren)
			{
				removeChildAt(0);
			}
		}

		public function getChildren():Vector.<DisplayObject>
		{
			return children;
		}

		/**
		 *	布局
		 *
		 */
		protected function layoutChildren():void
		{
			var child:DisplayObject;
			var num:int = numChildren;
			var comp:UIComponent;
			var calcW:Number = 0;
			var calcH:Number = 0;

			var i:int = 0;
			//计算预估关高
			for(i = 0; i < num; i++)
			{
				child = this.getChildAt(i);
				var w:Number = child.width + child.x;
				var h:Number = child.height + child.y;
				calcW = w > calcW ? w : calcW;
				calcH = h > calcH ? h : calcH;
			}

			var explicitw:Number = width > calcW ? width : calcW;
			var explicith:Number = height > calcH ? height : calcH;

			// 先算一个 预估的宽高

			// 根据预估的宽高进行布局
			for(i = 0; i < num; i++)
			{
				child = this.getChildAt(i);
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

			this._width = explicitw;
			this._height = explicith;
		}
	}
}
