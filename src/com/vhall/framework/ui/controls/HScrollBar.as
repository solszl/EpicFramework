package com.vhall.framework.ui.controls
{
	import flash.display.DisplayObjectContainer;

	/**
	 *
	 * @author Sol
	 *
	 */
	public class HScrollBar extends ScrollBar
	{
		public function HScrollBar(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, defaultHandler:Function = null)
		{
			super(ScrollBar.HORIZONTAL, parent, xpos, ypos, defaultHandler);
		}

		override protected function createChildren():void
		{
			super.createChildren();
			slider = new HSlider(this);
		}

		override protected function updateDisplay():void
		{
			super.updateDisplay();
			slider.x = upBtn.height;
			slider.y = 0;
			slider.width = _width - upBtn.height - downBtn.height;
			slider.height = upBtn.height;
			downBtn.x = _width - downBtn.width;
			downBtn.y = 0;
			upBtn.x = upBtn.width - upBtn.height;
			upBtn.y = 0;
		}

		override public function set thumbPercent(value:Number):void
		{
			super.thumbPercent = value;
			slider.quadButton.width = Math.max(int(slider.width * value), 28);
		}
	}
}
