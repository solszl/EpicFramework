package com.vhall.framework.ui.controls
{
	import com.vhall.framework.app.manager.RenderManager;
	import com.vhall.framework.ui.container.Box;
	import com.vhall.framework.ui.manager.WorldClockManager;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	[Event(name = "change", type = "flash.events.Event")]
	public class ScrollBar extends Box
	{
		/**水平移动*/
		public static const HORIZONTAL:String = "horizontal";
		/**垂直移动*/
		public static const VERTICAL:String = "vertical";

		protected var _tick:Number = 1;
		protected var upBtn:Button;
		protected var downBtn:Button;
		protected var slider:Slider;

		private var _isUp:Boolean;
		/**	目标组件*/
		private var _target:UIComponent;
		private var _thumbPercent:Number;
		private var _touchable:Boolean = true; //GlobalConfig.SCROLLBAR_TOUCHABLE;
		private var _mouseWheelable:Boolean = true;

		private var _direction:String;

		public function ScrollBar(direction:String, parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, defaultHandler:Function = null)
		{
			_direction = direction;
			super(parent, xpos, ypos);
			mouseChildren = true;
			if(defaultHandler != null)
			{
				addEventListener(Event.CHANGE, defaultHandler);
			}
		}

		override protected function init():void
		{
			super.init();
			upBtn.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
			downBtn.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
			slider.addEventListener(Event.CHANGE, onSliderChange);
			slider.setSliderParam(0, 100, 0, 1);
		}

		protected function onSliderChange(event:Event):void
		{
			dispatchEvent(new Event(Event.CHANGE));
		}

		protected function onButtonMouseDown(event:MouseEvent):void
		{
			isUp = event.currentTarget == upBtn;
			slide();
			WorldClockManager.getInstance().doFrameOnce(1, loop);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
		}

		protected function onStageMouseUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			WorldClockManager.getInstance().clearTimer(loop);
			WorldClockManager.getInstance().clearTimer(slide);
		}

		override protected function createChildren():void
		{
			super.createChildren();
			upBtn = new Button(this);
			upBtn.skin = null;
			downBtn = new Button(this);
			downBtn.skin = null;
		}

		private function loop():void
		{
			WorldClockManager.getInstance().doFrameLoop(1, slide);
		}

		private function slide():void
		{
			if(isUp)
			{
				value -= tick;
			}
			else
			{
				value += tick;
			}
		}

		/**	设置变化量*/
		public function get tick():Number
		{
			return _tick;
		}

		public function set tick(value:Number):void
		{
			_tick = value;
		}

		/**	状态值，true的时候为，上，或左，否则为，下或右*/
		public function get isUp():Boolean
		{
			return _isUp;
		}

		public function set isUp(value:Boolean):void
		{
			_isUp = value;
		}

		public function get value():Number
		{
			return slider.value;
		}

		public function set value(value:Number):void
		{
			slider.value = value;
		}

		public function get direction():String
		{
			return slider.direction;
		}

		/**	最小值*/
		public function get min():Number
		{
			return slider.min;
		}

		public function set min(value:Number):void
		{
			slider.min = value;
		}

		/**	最大值*/
		public function get max():Number
		{
			return slider.max;
		}

		public function set max(value:Number):void
		{
			slider.max = value;
		}

		/**滚动对象*/
		public function get target():UIComponent
		{
			return _target;
		}

		public function set target(value:UIComponent):void
		{
			if(_target)
			{
				_target.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
				_target.removeEventListener(MouseEvent.MOUSE_DOWN, onTargetMouseDown);
			}
			_target = value;
			if(value)
			{
				//鼠标滚轮支持?
				if(_mouseWheelable)
				{
					_target.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
				}
				//是否可拖拽内容实现 滚动
				if(_touchable)
				{
					_target.addEventListener(MouseEvent.MOUSE_DOWN, onTargetMouseDown);
				}
			}
		}

		protected function onMouseWheel(e:MouseEvent):void
		{
			value += (e.delta < 0 ? 1 : -1) * _thumbPercent * (max - min);
			if(value < max && value > min)
			{
				e.stopPropagation();
			}
		}

		/**滑条长度比例(0-1)*/
		public function get thumbPercent():Number
		{
			return _thumbPercent;
		}

		public function set thumbPercent(value:Number):void
		{
			RenderManager.getInstance().invalidate(invalidate);
			_thumbPercent = value;
		}

		/**是否触摸滚动，默认为true*/
		public function get touchable():Boolean
		{
			return _touchable;
		}

		public function set touchable(value:Boolean):void
		{
			_touchable = value;
		}

		protected function onTargetMouseDown(e:MouseEvent):void
		{
			_target.mouseChildren = true;
			WorldClockManager.getInstance().clearTimer(tweenMove);
			if(!this.contains(e.target as DisplayObject))
			{
				stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp2);
				stage.addEventListener(Event.ENTER_FRAME, onStageEnterFrame);
				_lastPoint = new Point(stage.mouseX, stage.mouseY);
			}
		}

		protected function onStageEnterFrame(e:Event):void
		{
			_lastOffset = slider.direction == VERTICAL ? stage.mouseY - _lastPoint.y : stage.mouseX - _lastPoint.x;
			if(Math.abs(_lastOffset) >= 1)
			{
				_lastPoint.x = stage.mouseX;
				_lastPoint.y = stage.mouseY;
				_target.mouseChildren = false;
				value -= _lastOffset;
			}
		}

		protected function onStageMouseUp2(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp2);
			stage.removeEventListener(Event.ENTER_FRAME, onStageEnterFrame);
			if(Math.abs(_lastOffset) > 50)
			{
				_lastOffset = 50 * (_lastOffset > 0 ? 1 : -1);
			}
			WorldClockManager.getInstance().doFrameLoop(1, tweenMove);
		}

		private function tweenMove():void
		{
			_lastOffset = _lastOffset * 0.92;
			value -= _lastOffset;
			if(Math.abs(_lastOffset) < 0.5)
			{
				_target.mouseChildren = true;
				WorldClockManager.getInstance().clearTimer(tweenMove);
			}
		}

		protected var _lastPoint:Point;
		protected var _lastOffset:Number

		public function setSliderParams(min:Number, max:Number, value:Number):void
		{
			slider.min = min;
			slider.max = max;
			this.value = value;
		}

	}
}
