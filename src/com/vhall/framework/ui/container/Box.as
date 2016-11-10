package com.vhall.framework.ui.container
{
	import com.vhall.framework.app.manager.RenderManager;
	import com.vhall.framework.ui.controls.UIComponent;
	import com.vhall.framework.ui.interfaces.ILayout;
	import com.vhall.framework.ui.layout.Layout;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * 容器基类
	 * @author Sol
	 * @date 2016-05-17
	 */
	public class Box extends UIComponent
	{
		protected var children:Vector.<DisplayObject>;

		protected var _layout:ILayout;

		public function Box(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			children = new Vector.<DisplayObject>();
			super(parent, xpos, ypos);
		}

		override public function addChild(child:DisplayObject):DisplayObject
		{
			if(children.indexOf(child) >= 0)
			{
				return child;
			}

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

			if(children.indexOf(child) >= 0)
			{
				setChildIndex(child, index);
				return child;
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
			else
			{
				return null;
			}

			var obj:DisplayObject = super.removeChild(child);
			RenderManager.getInstance().invalidate(invalidate);

			if(obj is UIComponent)
			{
				UIComponent(obj).destory();
			}

			return obj;
		}

		override public function removeChildAt(index:int):DisplayObject
		{
			if(index > children.length || index < 0 || children.length == 0)
			{
				return null;
			}

			//			children.splice(index, 1);
			//			var obj:DisplayObject = super.removeChildAt(index);
			//			RenderManager.getInstance().invalidate(invalidate);
			//			return obj;

			var obj:DisplayObject = removeChild(getChildAt(index));
			RenderManager.getInstance().invalidate(invalidate);
			return obj;
		}

		/**
		 * 半开半闭区间  [bengin, end)
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
			index = index < 0 ? 0 : index
			return children[index];
		}

		override protected function updateDisplay():void
		{
			super.updateDisplay();

			for each(var child:DisplayObject in children)
			{
				if(child is UIComponent)
				{
					UIComponent(child).validateNow();
				}
			}

			if(this._layout == null)
			{
				this._layout = new Layout();
			}

			this.layout.doLayout(this);
			this._width = this.layout.measureWidth;
			this._height = this.layout.measureHeight;
		}

		public function addChildAbove(target:DisplayObject, child:DisplayObject):void
		{
			var idx:int = getChildIndex(target);
			addChildAt(child, idx + 1);
		}

		public function addChildBelow(target:DisplayObject, child:DisplayObject):void
		{
			var idx:int = getChildIndex(target);
			addChildAt(child, Math.max(0, idx));
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

		public function set layout(value:ILayout):void
		{
			if(this._layout && this._layout.toString() == value.toString())
			{
				return;
			}

			this._layout = value;
			RenderManager.getInstance().invalidate(invalidate);
		}

		public function get layout():ILayout
		{
			return this._layout;
		}

		override public function get width():Number
		{
			return this._layout.measureWidth;
		}

		override public function get height():Number
		{
			return this._layout.measureHeight;
		}
	}
}
