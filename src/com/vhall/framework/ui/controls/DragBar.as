package com.vhall.framework.ui.controls
{
	import com.vhall.framework.app.manager.RenderManager;
	import com.vhall.framework.ui.container.Box;
	import com.vhall.framework.ui.event.DragEvent;
	import com.vhall.framework.ui.utils.ComponentUtils;
	import com.vhall.framework.utils.MathUtil;

	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * 拖动控件
	 * @author Sol
	 * @date 2016-05-18
	 */
	[Event(name = "dragbar_change", type = "com.vhall.framework.ui.event.DragEvent")]
	[Event(name = "dragbar_click", type = "com.vhall.framework.ui.event.DragEvent")]
	[Event(name = "dragbar_hover", type = "com.vhall.framework.ui.event.DragEvent")]
	[Event(name = "dragbar_up", type = "com.vhall.framework.ui.event.DragEvent")]
	public class DragBar extends Box
	{
		/**	水平枚举*/
		public static const HORIZONTAL:String = "horizontal";
		/**	纵向枚举*/
		public static const VERTICAL:String = "vertical";

		public function DragBar(parent:DisplayObjectContainer = null, direction:String = HORIZONTAL, xpos:Number = 0, ypos:Number = 0)
		{
			this.direction = direction;
			super(parent, xpos, ypos);
			buttonMode = true;
		}

		protected var _h:Number;
		protected var _quadChanged:Boolean = false;

		protected var _w:Number;

		/**	背景*/
		protected var _bg:Image;

		/**	缓冲的进度*/
		protected var _buffer:Image;

		/**	方向*/
		protected var direction:String;

		protected var draging:Boolean;

		/** 已播放进度*/
		protected var _finished:Image;
		/**	滑块*/
		protected var _quad:Image;

		// 是否使用动画
		protected var useTween:Boolean;
		private var _max:Number = int.MAX_VALUE;
		private var _min:Number = 0;

		private var _percent:Number = 0;
		private var _step:Number = 0.1;
		private var _value:Number;

		/**	最大值*/
		public function get max():Number
		{
			return _max;
		}

		/**
		 * @private
		 */
		public function set max(value:Number):void
		{
			_max = value;
		}

		/**	最小值*/
		public function get min():Number
		{
			return _min;
		}

		/**
		 * @private
		 */
		public function set min(value:Number):void
		{
			_min = value;
		}

		/**	滑块位置百分比*/
		public function get percent():Number
		{
			return _percent;
		}

		/**
		 * @private
		 */
		public function set percent(value:Number):void
		{
			_percent = getRoundPercent(value);
			// 根据百分比，子类自己实现布局
			RenderManager.getInstance().invalidate(invalidate);
		}

		/**
		 *	滑块皮肤
		 * @param value 皮肤样式
		 *
		 */
		public function set quadSkin(value:Object):void
		{
			_quad.source = value;
			_quadChanged = true;
			RenderManager.getInstance().invalidate(invalidate);
		}

		/**	步长 默认 0.1*/
		public function get step():Number
		{
			return _step;
		}

		/**
		 * @private
		 */
		public function set step(value:Number):void
		{
			_step = value;
		}

		/**	当前值*/
		public function get value():Number
		{
			return _value;
		}

		/**
		 * @private
		 */
		public function set value(value:Number):void
		{
			if(_value == value)
			{
				return;
			}
			_value = value;

			percent = ((value - min) / step + 1) / ((max - min) / step + 1);
		}

		override protected function createChildren():void
		{
			super.createChildren();
			initSize();
			_bg = new Image(this);

			// alpha 设置为0 先隐藏
			_buffer = new Image(this);
			_buffer.mouseChildren = _buffer.mouseEnabled = false;
			_finished = new Image(this);
			_finished.mouseChildren = _finished.mouseEnabled = false;
			//滑块
			_quad = new Image(this);
			_quad.mouseChildren = _quad.mouseEnabled = false;

			initSkin();

			addEventListener(MouseEvent.MOUSE_MOVE, onMouseHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseHandler);
		}

		/**
		 *	封装了派发事件的函数
		 * @param e
		 * @param type
		 *
		 */
		protected function fireEvent(e:MouseEvent, type:String):void
		{
			if(!this.hasEventListener(type))
			{
				return;
			}

			// 获取当前组件 所在点
			var p:Point = this.localToGlobal(new Point());
			// 根据e.stageX 判断是否在组件横向区域内，并减去组件横坐标，计算出偏移
			var temp:Number = MathUtil.limitIn(e.stageX, p.x, p.x + width) - p.x;
			var evt:DragEvent = new DragEvent(type);
			evt.percent = getRoundPercent(temp / width);
			dispatchEvent(evt);
		}

		protected function initSize():void
		{
			if(direction == HORIZONTAL)
			{
				_w = 100;
				_h = 12;
			}
			else
			{
				_w = 12;
				_h = 100;
			}
		}

		protected function initSkin():void
		{
			_bg.source = ComponentUtils.genInteractiveRect(_w, _h, null, 0, 0, Style.DragBar_Background_Color);
			_buffer.source = ComponentUtils.genInteractiveRect(1, _h, null, 0, 0, Style.DragBar_Buffer_Color);
			_finished.source = ComponentUtils.genInteractiveRect(1, _h, null, 0, 0, Style.DragBar_Played_Color);
		}

		override protected function invalidate():void
		{
			_quad.source == null ? quadSkin = ComponentUtils.genInteractiveCircle(6, null, 0, 0, 0xFF0000) : _quad.source;
			super.invalidate();
		}

		/**
		 *	拖拽结束 ,如果包含dragbar_change事件监听，则派发
		 *
		 */
		protected function onDragDrop(e:MouseEvent = null):void
		{
			if(stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseHandler);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseHandler);
			}

			stopDrag();
			draging = false;

			fireEvent(e, DragEvent.CHANGE);
			fireEvent(e, DragEvent.DRAG_DROP);
			fireEvent(e, DragEvent.UP);
		}

		/**
		 *	拖拽开始
		 *
		 */
		protected function onDragStart(e:MouseEvent = null):void
		{
			if(stage)
			{
				// 添加这个move的作用是，如果鼠标移出dragbar 确保仍然相应拖拽，鼠标抬起的时候，移除
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseHandler);
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseHandler);
			}

			//派发开始拖拽
			fireEvent(e, DragEvent.DRAG_START);
		}

		protected function onMouseHandler(e:MouseEvent):void
		{

		}

		/**
		 *	获取取整的数
		 * @param value
		 *
		 */
		private function getRoundPercent(value:Number):Number
		{
			var temp:Number = Number(value.toFixed(6));
//			return temp > 1 ? 1 : temp < 0 ? temp : 0;
			return MathUtil.limitIn(temp, 0, 1);
		}

		public function get quadImage():Image
		{
			return this._quad;
		}

		public function get finishBGImage():Image
		{
			return this._finished;
		}

		public function get bufferBGImage():Image
		{
			return this._buffer;
		}

		public function get backgroundImage():Image
		{
			return this._bg;
		}
	}
}
