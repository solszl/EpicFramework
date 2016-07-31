package com.vhall.framework.ui.controls
{
	import com.vhall.framework.utils.MathUtil;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * 纵向滚动条
	 * @author Sol
	 * @date 2016-07-31 18:19:56
	 */
	public class VSlider extends Slider
	{
		public function VSlider(parent:DisplayObjectContainer = null, handler:Function = null, xpos:Number = 0, ypos:Number = 0)
		{
			this._direction = Slider.VERTICAL;
			super(parent, handler, xpos, ypos);
		}

		override protected function init():void
		{
			setSize(10, 100);
			super.init();
		}

		override protected function onDrag(e:MouseEvent):void
		{
			super.onDrag(e);
			quadButton.startDrag(false, new Rectangle(0, 0, 0, _height - quadButton.height));
		}

		override protected function onBackgroundClick(e:MouseEvent):void
		{
			super.onBackgroundClick(e);
			quadButton.y = MathUtil.limitIn(mouseY - _width / 2, 0, _height - _width);
			_value = (_height - _width - quadButton.y) / (height - _width) * (_max - _min) + _min;
			dispatchEvent(new Event(Event.CHANGE));
		}

		override protected function onSlide(event:MouseEvent):void
		{
			var oldValue:Number = _value;
			_value = quadButton.y / (height - quadButton.height) * (_max - _min) + _min;
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
			quadButton.y = (_value - _min) / (_max - _min) * (height - quadButton.height);
		}

	}
}
