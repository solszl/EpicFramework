package com.vhall.framework.ui.controls
{
	import com.vhall.framework.app.manager.RenderManager;
	import com.vhall.framework.ui.interfaces.IGuide;
	import com.vhall.framework.ui.interfaces.IRelative;
	import com.vhall.framework.ui.interfaces.IToolTip;
	import com.vhall.framework.ui.manager.TooltipManager;
	import com.vhall.framework.utils.StringUtil;
	import com.vhall.framework.utils.UUID;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;

	/**
	 * 组件基类
	 * @author Sol
	 *
	 */
	public class UIComponent extends Sprite implements IToolTip, IRelative, IGuide
	{
		/**
		 * 构建基类
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

		/**初始化方法*/
		protected function init():void
		{
			_uuid = UUID.create();
			// subclass overwrite
			createChildren();
		}

		/**创建子对象*/
		protected function createChildren():void
		{
		}

		/**	调用渲染逻辑，第一步执行 尺寸变更函数，第二部执行显示渲染，第三部决定是否派发初始化完成事件*/
		protected function invalidate():void
		{
			sizeChanged();
			updateDisplay();

			if(initialized == false)
			{
				initialized = true;
			}
		}

		/**	渲染显示列表*/
		protected function updateDisplay():void
		{

		}

		/**	尺寸变更函数*/
		protected function sizeChanged():void
		{
		}

		/**	调用父容器进行渲染*/
		protected function parentInvalidate():void
		{
			if(parent && parent is UIComponent)
			{
				(parent as UIComponent).invalidate();
			}
		}

		/**	组件初始化完毕后执行此函数*/
		protected function componentInited(e:Event):void
		{
			removeEventListener("component_inited", componentInited);
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
				return;

			_width = value;
			_explicitWidth = value;
			RenderManager.getInstance().invalidate(invalidate);
		}

		override public function get width():Number
		{
			return !isNaN(_explicitWidth) ? _explicitWidth : _width == 0 ? super.width : _width;
		}

		protected var _height:Number = 0;

		override public function set height(value:Number):void
		{
			if(_height == value)
				return;

			_height = value;
			_explicitHeight = value;
			RenderManager.getInstance().invalidate(invalidate);
		}

		override public function get height():Number
		{
			return !isNaN(_explicitHeight) ? _explicitHeight : _height == 0 ? super.height : _height;
		}

		override public function set scaleX(value:Number):void
		{
			super.scaleX = value;
			RenderManager.getInstance().invalidate(sizeChanged);
		}

		override public function set scaleY(value:Number):void
		{
			super.scaleY = value;
			RenderManager.getInstance().invalidate(sizeChanged);
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
			RenderManager.getInstance().invalidate(updateDisplay);
		}

		/**
		 * 设置宽高
		 * @param w 宽
		 * @param h 高
		 *
		 */
		public function setSize(w:Number, h:Number):void
		{
			this._width = Math.round(w);
			this._height = Math.round(h);

			this._explicitWidth = this._width;
			this._explicitHeight = this._height;
			RenderManager.getInstance().invalidate(invalidate);
		}

		/**	销毁函数*/
		public function destory():void
		{
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

		/**	立即刷新*/
		public function validateNow():void
		{
			invalidate();
		}

		/**	延迟到下一帧渲染*/
		public function validateNextFrame():void
		{
			RenderManager.getInstance().invalidate(invalidate);
		}

		/**显示边框*/
		public function showBorder(color:uint = 0xff0000):void
		{
			graphics.clear();
			graphics.lineStyle(1, color);
			graphics.drawRect(-1, -1, width + 1, height + 1);
			graphics.endFill();
		}

		private static const info:String = "[{0}], uuid: {8}, width: {1} , height: {2} , x: {3} , y: {4} , haveParent, {5}, onStage: {6}, visibile:{7}";

		/**
		 * 拿到组件的宽,高,X,Y,以及反射出来的名字
		 * @return
		 *
		 */
		public function get selfInfo():String
		{
			return StringUtil.substitute(info, getQualifiedClassName(this), width, height, x, y, this.parent != null, this.stage != null, visible, this.uuid);
		}

		private var _uuid:String;

		private var _tooltip:Object;

		private var _left:Object;

		private var _right:Object;

		private var _top:Object;

		private var _bottom:Object;

		private var _horizontalCenter:Number;

		private var _verticalCenter:Number;

		private var _callOut:String = "none";

		private var _initialized:Boolean = false;

		private var _userData:Object;

		private var _guideName:String = "";

		private var _scale:Number = 1;

		private var _explicitWidth:Number;

		private var _explicitHeight:Number;

		/**
		 * tips 出现的位置， 上下左右，或者随鼠标而动， <b>top, left, right, bottom, none</b>
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

		/**	用户自定义数据，该数据外部维护*/
		public function get userData():Object
		{
			return _userData ||= {};
		}

		public function set userData(value:Object):void
		{
			_userData = value;
		}

		/**	组件是否初始化完毕*/
		public function get initialized():Boolean
		{
			return _initialized;
		}

		public function set initialized(value:Boolean):void
		{
			if(value == _initialized)
			{
				return;
			}

			_initialized = value;

			if(value)
			{
				addEventListener("component_inited", componentInited, false, 0, true);
				dispatchEvent(new Event("component_inited"));
			}
		}

		/**	引导名字*/
		public function set guideName(name:String):void
		{
			this._guideName = name;
		}

		public function get guideName():String
		{
			return this._guideName;
		}

		/**	设置背景色
		 * @param 正常为16进制数<br/>如果传入数据为 ‘-1’， 则清空背景色*/
		public function set backgroundColor(value:uint):void
		{
			graphics.clear();
			if(value == -1)
			{
				return;
			}
			graphics.beginFill(value, _backgroundAlpha);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
		}

		private var _backgroundAlpha:Number = 1;

		public function set backgroundAlpha(value:Number):void
		{
			this._backgroundAlpha = value;
			RenderManager.getInstance().invalidate(invalidate);
		}

		public function set scale(value:Number):void
		{
			if(_scale == value)
			{
				return;
			}
			_scale = value;
			this.scaleX = _scale;
			this.scaleY = _scale;
		}

		/**	设置缩放比*/
		public function get scale():Number
		{
			return this._scale;
		}

		/**	获取当前组件的位置*/
		public function get position():Point
		{
			return new Point(this.x, this.y);
		}

		public function set explicitWidth(value:Number):void
		{
			this._explicitWidth = value;
		}

		public function get explicitWidth():Number
		{
			return this._explicitWidth;
		}

		public function set explicitHeight(value:Number):void
		{
			this._explicitHeight = value;
		}

		public function get explicitHeight():Number
		{
			return this._explicitHeight;
		}

		public function get uuid():String
		{
			return this._uuid;
		}
	}
}
