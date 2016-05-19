package com.vhall.framework.ui.controls
{
	import com.vhall.framework.app.manager.RenderManager;
	import com.vhall.framework.app.manager.StageManager;
	import com.vhall.framework.ui.container.Box;
	import com.vhall.framework.ui.event.DragEvent;
	import com.vhall.framework.ui.utils.ComponentUtils;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
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
	public class DragBar extends Box
	{
		/**	水平枚举*/
		public static const HORIZONTAL:String = "horizontal";
		/**	纵向枚举*/
		public static const VERTICAL:String = "vertical";

		/**	方向*/
		protected var direction:String;

		/**	背景*/
		protected var bg:Image;

		/** 已播放进度*/
		protected var finished:Image;

		/**	缓冲的进度*/
		protected var buffer:Image;
		/**	滑块*/
		protected var quad:Image;
		protected var _quadChanged:Boolean = false;

		// 是否使用动画
		protected var useTween:Boolean;

		private var _percent:Number;
		private var _min:Number = 0;
		private var _max:Number = int.MAX_VALUE;
		private var _value:Number;
		private var _step:Number = 0.1;

		protected var draging:Boolean;

		public function DragBar(parent:DisplayObjectContainer = null, direction:String = HORIZONTAL, xpos:Number = 0, ypos:Number = 0)
		{
			this.direction = direction;
			super(parent, xpos, ypos);
			buttonMode = true;
		}

		override protected function createChildren():void
		{
			super.createChildren();
			var _w:Number, _h:Number;
			if (direction == HORIZONTAL)
			{
				_w = 100;
				_h = 12;
			}
			else
			{
				_w = 12;
				_h = 100;
			}
			bg = new Image(this);
			bg.source = ComponentUtils.genInteractiveRect(_w, _h, this, 0, 0, Style.DragBar_Background_Color);
			// alpha 设置为0 先隐藏
			buffer = new Image(this);
			buffer.mouseChildren = buffer.mouseEnabled = false;
			buffer.source = ComponentUtils.genInteractiveRect(1, _h, this, 0, 0, Style.DragBar_Buffer_Color);
			finished = new Image(this);
			finished.source = ComponentUtils.genInteractiveRect(1, _h, this, 0, 0, Style.DragBar_Played_Color);
			finished.mouseChildren = finished.mouseEnabled = false;
			//滑块
			quad = new Image(this);
			quad.mouseChildren = quad.mouseEnabled = false;

			addEventListener(MouseEvent.MOUSE_MOVE, onMouseHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseHandler);
		}

		override protected function invalidate():void
		{
			quad.source == null ? quadSkin = ComponentUtils.genInteractiveCircle(6, null, 0, 0, 0xFF0000) : quad.source;
			super.invalidate();
			updateDisplay();
		}

		protected function onMouseHandler(e:MouseEvent):void
		{

		}

		/**
		 *	拖拽开始
		 *
		 */
		protected function onDragStart(e:MouseEvent = null):void
		{
			if (stage)
			{
				// 添加这个move的作用是，如果鼠标移出dragbar 确保仍然相应拖拽，鼠标抬起的时候，移除
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseHandler);
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseHandler);
			}

			//派发开始拖拽
			fireEvent(e, DragEvent.DRAG_START);
		}

		/**
		 *	拖拽结束 ,如果包含dragbar_change事件监听，则派发
		 *
		 */
		protected function onDragDrop(e:MouseEvent = null):void
		{
			if (stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseHandler);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseHandler);
			}

			stopDrag();
			draging = false;

			fireEvent(e, DragEvent.CHANGE);
			fireEvent(e, DragEvent.DRAG_DROP);
		}

		/**
		 *	封装了派发事件的函数
		 * @param e
		 * @param type
		 *
		 */
		protected function fireEvent(e:MouseEvent, type:String):void
		{
			if (!this.hasEventListener(type))
			{
				return;
			}

			var evt:DragEvent = new DragEvent(type);
			evt.percent = getRoundPercent(e.localX / width);
			dispatchEvent(evt);
		}

		/**
		 *	获取取整的数
		 * @param value
		 *
		 */
		private function getRoundPercent(value:Number):Number
		{
			var temp:Number = Number(value.toFixed(6));
			return temp > 1 ? 1 : temp;
		}

		/**
		 *	滑块皮肤
		 * @param value 皮肤样式
		 *
		 */
		public function set quadSkin(value:Object):void
		{
			quad.source = value;
			_quadChanged = true;
			RenderManager.getInstance().invalidate(invalidate);
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
			if (_value == value)
			{
				return;
			}
			_value = value;

			percent = ((value - min) / step + 1) / ((max - min) / step + 1);
		}
	}
}
