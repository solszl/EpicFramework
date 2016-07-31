package com.vhall.framework.ui.controls
{
	import com.vhall.framework.utils.MathUtil;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * 水平滑块
	 * @author Sol
	 * @date 2016-07-31 16:55:50
	 */
	public class HSlider extends Slider
	{
		public function HSlider(parent:DisplayObjectContainer = null, handler:Function = null, xpos:Number = 0, ypos:Number = 0)
		{
			this._direction = Slider.HORIZONTAL;
			super(parent, handler, xpos, ypos);
		}

		override protected function init():void
		{
			setSize(100, 10);
			super.init();
		}

		override protected function onDrag(e:MouseEvent):void
		{
			super.onDrag(e);
			quadButton.startDrag(false, new Rectangle(0, 0, _width - quadButton.width, 0));
		}

		override protected function onBackgroundClick(e:MouseEvent):void
		{
			super.onBackgroundClick(e);
			quadButton.x = MathUtil.limitIn(mouseX - _height / 2, 0, _width - _height);
			_value = quadButton.x / (width - _height) * (_max - _min) + _min;
			dispatchEvent(new Event(Event.CHANGE));
		}

		override protected function onSlide(event:MouseEvent):void
		{
			var oldValue:Number = _value;
			_value = quadButton.x / (width - quadButton.width) * (_max - _min) + _min;
			_value = Math.round(_value / _tick) * _tick;

			if(_value != oldValue)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}

		override protected function adjustQuadPosition():void
		{
			super.adjustQuadPosition();
			_value = value;
			validValue();
			quadButton.x = (_value - _min) / (_max - _min) * (width - quadButton.width);
		}
	}
}
