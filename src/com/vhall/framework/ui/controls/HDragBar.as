package com.vhall.framework.ui.controls
{
	import com.vhall.framework.app.manager.RenderManager;
	import com.vhall.framework.ui.event.DragEvent;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * 横向拖拽条
	 * @author Sol
	 * @date 2016-05-18
	 */
	public class HDragBar extends DragBar
	{
		public function HDragBar(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, HORIZONTAL, xpos, ypos);
		}

		override public function set width(value:Number):void
		{
			super.width = value;
			_bg.width = value;
		}

		override protected function onDragStart(e:MouseEvent = null):void
		{
			super.onDragStart(e);
			_quad.startDrag(false, new Rectangle(-_quad.width / 2, _quad.y, width - _quad.width / 2, 0));
			draging = true;
		}

		override protected function onMouseHandler(e:MouseEvent):void
		{
			switch(e.type)
			{
				case MouseEvent.CLICK:
					percent = e.localX / width;
					fireEvent(e, DragEvent.CLICK);
					break;
				case MouseEvent.MOUSE_DOWN:
					if(e.target != _quad)
					{
						percent = e.localX / width;
					}
					onDragStart(e);
					break;
				case MouseEvent.MOUSE_UP:
					onDragDrop(e);
					percent = _finished.width / width;
					break;
				case MouseEvent.MOUSE_MOVE:
					fireEvent(e, DragEvent.HOVER);
					_finished.width = Math.max(_quad.x + _quad.width / 2, 1);
					percent = _finished.width / width;
					break;
			}
		}

		override protected function updateDisplay():void
		{
			super.updateDisplay();

			//重新布局
			if(_quadChanged)
			{
				_quad.y = (height - _quad.height) >> 1;
				_quadChanged = false;
			}

			_quad.x = width * percent - _quad.width / 2;
			_finished.width = Math.max(width * percent, 1);
		}
	}
}


