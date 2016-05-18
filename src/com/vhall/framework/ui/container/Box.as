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
			if (index > children.length)
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
			if (chIndex > -1)
			{
				children.splice(chIndex, 1);
			}

			var obj:DisplayObject = super.removeChild(child);
			RenderManager.getInstance().invalidate(invalidate);
			return obj;
		}

		override public function removeChildAt(index:int):DisplayObject
		{
			if (index > children.length || index < 0 || children.length == 0)
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
			if (beginIndex > children.length || beginIndex < 0)
			{
				return;
			}

			if (endIndex < beginIndex || endIndex < 0)
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
			super.invalidate();

			layoutChildren();
		}

		public function removeAllChild():void
		{
			while (numChildren)
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

		}
	}
}
