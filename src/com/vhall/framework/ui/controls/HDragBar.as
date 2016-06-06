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
			bg.width = value;
		}

		override protected function updateDisplay():void
		{
			super.updateDisplay();

			//重新布局
			if(_quadChanged)
			{
				quad.y = (height - quad.height) >> 1;
				_quadChanged = false;
			}

			quad.x = width * percent - quad.width / 2;
			finished.width = width * percent;
		}

		override protected function onDragStart(e:MouseEvent = null):void
		{
			super.onDragStart();
			quad.startDrag(false, new Rectangle(-quad.width/2, quad.y, width - quad.width/2, 0));
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
					if(e.target != quad)
					{
						percent = e.localX / width;
					}
					onDragStart(e);
					break;
				case MouseEvent.MOUSE_UP:
					onDragDrop(e);
					break;
				case MouseEvent.MOUSE_MOVE:
					fireEvent(e, DragEvent.HOVER);
					finished.width = quad.x + quad.width / 2;
					break;
			}
		}
	}
}
