package com.vhall.framework.ui.controls
{
	import com.vhall.framework.app.manager.RenderManager;
	import com.vhall.framework.ui.manager.TooltipManager;
	import com.vhall.framework.utils.StringUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;

	/**
	 *	组件基类
	 * @author Sol
	 *
	 */
	public class UIComponent extends Sprite implements IToolTip,IRelative
	{
		/**
		 *	构建基类
		 * @param parent 是否有父容器，当存在父容器的时候，该组件自动添加到父容器
		 * @param xpos	默认横坐标位置
		 * @param ypos	默认纵坐标位置
		 *
		 */
		public function UIComponent(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super();

			move(xpos, ypos);

			if(parent != null)
			{
				parent.addChild(this);
			}

			init();
		}

		protected function init():void
		{
			// subclass overwrite
			createChildren();
		}

		protected function createChildren():void
		{

		}

		protected function invalidate():void
		{
			sizeChanged();
			updateDisplay();
		}

		protected function updateDisplay():void
		{

		}
		
		protected function sizeChanged():void
		{
			
		}

		protected function destory():void
		{

		}
		
		protected function parentInvalidate():void
		{
			if(parent && parent is UIComponent)
			{
				(parent as UIComponent).invalidate();
			}
		}

		override public function set alpha(value:Number):void
		{
			super.alpha = value;
			value == 0 ? visible = false : true;
		}

		protected var _width:Number = 0;

		override public function set width(value:Number):void
		{
			if(_width == value)
			{
				return;
			}
			_width = value;
			RenderManager.getInstance().invalidate(invalidate);
		}

		override public function get width():Number
		{
			return _width == 0 ? super.width : _width;
		}

		protected var _height:Number = 0;

		override public function set height(value:Number):void
		{
			if(_height == value)
			{
				return;
			}
			_height = value;
			RenderManager.getInstance().invalidate(invalidate);
		}

		override public function get height():Number
		{
			return _height == 0 ? super.height : _height;
		}

		/**
		 * 移动
		 * @param xpos 横坐标
		 * @param ypos 纵坐标
		 *
		 */
		public function move(xpos:Number, ypos:Number):void
		{
			this.x = Math.round(xpos);
			this.y = Math.round(ypos);
			RenderManager.getInstance().invalidate(invalidate);
		}

		/**
		 *	设置宽高
		 * @param w 宽
		 * @param h 高
		 *
		 */
		public function setSize(w:Number, h:Number):void
		{
			this._width = Math.round(w);
			this._height = Math.round(h);
			RenderManager.getInstance().invalidate(invalidate);
		}

		/**
		 * 如果有父容器，则讲自己从父容器中移除
		 *
		 */
		public function removeFromParent():void
		{
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}
		
		public function validateNow():void
		{
			sizeChanged();
			updateDisplay();
		}

		/**显示边框*/
		public function showBorder(color:uint = 0xff0000):void
		{
			RenderManager.getInstance().validateNow();
			with(this)
			{
				graphics.clear();
				graphics.lineStyle(1, color);
				graphics.drawRect(0, 0, width, height);
			}
		}

		private static const info:String = "[{0}] width: {1} , height: {2} , x: {3} , y: {4} , haveParent, {5}, onStage: {6}";

		/**
		 *	拿到组件的宽,高,X,Y,以及反射出来的名字
		 * @return
		 *
		 */
		public function get selfInfo():String
		{
			return StringUtil.substitute(info, getQualifiedClassName(this), width, height, x, y, this.parent != null, this.stage != null);
		}

		private var _tooltip:Object;
		private var _left:Object;
		private var _right:Object;
		private var _top:Object;
		private var _bottom:Object;
		private var _horizontalCenter:Number;
		private var _verticalCenter:Number;
		private var _callOut:String = "none";

		/**
		 *	tips 出现的位置， 上下左右，或者随鼠标而动， <b>top, left, right, bottom, none</b>
		 */
		[Inspectable(category = "General", enumeration = "top,left,right,bottom,none", defaultValue = "none")]
		public function get callOut():String
		{
			return _callOut;
		}

		public function set callOut(value:String):void
		{
			_callOut = value;
		}

		public function get tooltip():Object
		{
			return _tooltip;
		}

		public function set tooltip(value:Object):void
		{
			if(_tooltip == value)
			{
				return;
			}

			_tooltip = value;
			TooltipManager.getInstance().registTooltip(this, value);
		}

		public function get left():Object
		{
			return _left;
		}

		public function set left(value:Object):void
		{
			_left = value;
		}

		public function get right():Object
		{
			return _right;
		}

		public function set right(value:Object):void
		{
			_right = value;
		}

		public function get top():Object
		{
			return _top;
		}

		public function set top(value:Object):void
		{
			_top = value;
		}

		public function get bottom():Object
		{
			return _bottom;
		}

		public function set bottom(value:Object):void
		{
			_bottom = value;
		}

		public function get horizontalCenter():Number
		{
			return _horizontalCenter;
		}

		public function set horizontalCenter(value:Number):void
		{
			_horizontalCenter = value;
		}

		public function get verticalCenter():Number
		{
			return _verticalCenter;
		}

		public function set verticalCenter(value:Number):void
		{
			_verticalCenter = value;
		}
	}
}
