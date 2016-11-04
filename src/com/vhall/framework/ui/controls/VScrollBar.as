package com.vhall.framework.ui.controls
{
	import com.vhall.framework.app.manager.RenderManager;

	import flash.display.DisplayObjectContainer;

	/**
	 *
	 * @author Sol
	 *
	 */
	public class VScrollBar extends ScrollBar
	{
		public function VScrollBar(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, defaultHandler:Function = null)
		{
			super(ScrollBar.VERTICAL, parent, xpos, ypos, defaultHandler);
		}

		override protected function createChildren():void
		{
			super.createChildren();
			slider = new VSlider(this);
		}

		override protected function updateDisplay():void
		{
			super.updateDisplay();
			upBtn.x = 0
			slider.x = 0;
			slider.y = upBtn.height;
			slider.width = upBtn.width;
			slider.height = _height - upBtn.height - downBtn.height;
			downBtn.x = 0;
			downBtn.y = _height - downBtn.height;
		}

		override public function set thumbPercent(value:Number):void
		{
			super.thumbPercent = value;
			slider.quadButton.height = Math.max(int(slider.height * value), 28);
		}
	}
}
