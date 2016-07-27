package com.vhall.framework.ui.controls
{
	import com.vhall.framework.ui.event.DragEvent;
	import com.vhall.framework.utils.MathUtil;

	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 横向拖拽条
	 * @author Sol
	 * @date 2016-05-18
	 */
	public class VDragBar extends DragBar
	{
		public function VDragBar(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, VERTICAL, xpos, ypos);
		}

		override public function set height(value:Number):void
		{
			super.height = value;
			_bg.height = value;
		}

		override protected function onDragStart(e:MouseEvent = null):void
		{
			super.onDragStart(e);
			_quad.startDrag(false, new Rectangle(3, -_quad.height / 2, 0, height - _quad.height / 2));
			draging = true;
		}

		/**
		 *	封装了派发事件的函数
		 * @param e
		 * @param type
		 *
		 */
		override protected function fireEvent(e:MouseEvent, type:String):void
		{
			if(!this.hasEventListener(type))
			{
				return;
			}

			// 获取当前组件 所在点
			var p:Point = this.localToGlobal(new Point());
			// 根据e.stageX 判断是否在组件横向区域内，并减去组件横坐标，计算出偏移
			var temp:Number = MathUtil.limitIn(e.stageY, p.y, p.y + height) - p.y;
			var evt:DragEvent = new DragEvent(type);
			evt.percent = getRoundPercent(temp / height);
			dispatchEvent(evt);
		}

		override protected function onMouseHandler(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.CLICK:
					percent = e.localX / height;
					fireEvent(e, DragEvent.CLICK);
					break;
				case MouseEvent.MOUSE_DOWN:
					if(e.target != _quad)
					{
						percent = e.localY / height;
					}
					onDragStart(e);
					break;
				case MouseEvent.MOUSE_UP:
//					_finished.width = Math.max(_quad.x - _quad.width / 2, 1);
					percent = _finished.height / height;
					onDragDrop(e);
					break;
				case MouseEvent.MOUSE_MOVE:
					fireEvent(e, DragEvent.HOVER);
					_finished.height = Math.max(_quad.y + _quad.height / 2, 1);
					percent = _finished.height / height;
					break;
			}
		}

		override protected function updateDisplay():void
		{
			super.updateDisplay();

			//重新布局
			if(_quadChanged)
			{
				_quad.x = (width - _quad.width) >> 1;
				_quadChanged = false;
			}
			_quad.y = height * percent - _quad.height / 2;

			_finished.height = Math.max(height * percent, 1);
		}
	}
}


