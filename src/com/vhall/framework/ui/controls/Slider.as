package com.vhall.framework.ui.controls
{
	import com.vhall.framework.app.manager.RenderManager;
	import com.vhall.framework.app.manager.StageManager;
	import com.vhall.framework.ui.utils.ComponentUtils;
	import com.vhall.framework.utils.MathUtil;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * 滑块
	 * @author Sol
	 * @date 2016-07-31 16:07:55
	 */
	[Event(name = "change", type = "flash.events.Event")]
	internal class Slider extends UIComponent
	{
		public static const HORIZONTAL:String = "horizontal";

		public static const VERTICAL:String = "vertical";

		/**	默认方向*/
		protected var _direction:String;

		/**	默认函数*/
		protected var _defaultHandler:Function;

		/**	背景图*/
		protected var imgBackground:Image;

		/**	滑块*/
		protected var imgQuad:Button;

		/** 背景是否可以点击*/
		protected var _backgroudClickable:Boolean = true;

		public function Slider(parent:DisplayObjectContainer = null, handler:Function = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);

			if(handler != null)
			{
				this.defaultHandler = handler;
				this.addEventListener(Event.CHANGE, handler);
			}
		}

		override protected function createChildren():void
		{
			super.createChildren();

			imgBackground = new Image(this);
			imgBackground.mouseEnabled = true;
			imgBackground.rect = new Rectangle(2, 2, 2, 2);
			backgroundSkin = ComponentUtils.genInteractiveRect(width, height, null, 0, 0, 0x535353, 0.6);

			imgQuad = new Button(this);
			quadSkin = ComponentUtils.genInteractiveRect(10, 10, null, 0, 0, 0xE7E7E7);
			imgQuad.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
		}

		override public function destory():void
		{
			super.destory();

			// 如果存在默认处理函数，移除
			if(this._defaultHandler != null)
			{
				this.removeEventListener(Event.CHANGE, this._defaultHandler);
				this._defaultHandler = null;
			}
		}

		override protected function sizeChanged():void
		{
			backgroundImage.setSize(width, height);
			super.sizeChanged();
		}

		public function setSliderParam(value:Number, min:Number, max:Number, tick:Number):void
		{
			this.value = value;
			this.min = min;
			this.max = max;
			this.tick = tick;
			RenderManager.getInstance().invalidate(invalidate);
		}

		protected function onDrag(e:MouseEvent):void
		{
			StageManager.stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);
			StageManager.stage.addEventListener(MouseEvent.MOUSE_MOVE, onSlide);
		}

		protected function onDrop(event:MouseEvent):void
		{
			StageManager.stage.removeEventListener(MouseEvent.MOUSE_UP, onDrop);
			StageManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSlide);
			stopDrag();
		}

		protected function onSlide(event:MouseEvent):void
		{

		}

		protected function onBackgroundClick(e:MouseEvent):void
		{

		}

		/**	验证value， 确保value在区间内*/
		protected function validValue():void
		{
			_value = MathUtil.limitIn(_value, _min, _max);
		}

		protected function adjustQuadPosition():void
		{

		}

		public function get backgroudClickable():Boolean
		{
			return this._backgroudClickable;
		}

		public function set backgroudClickable(b:Boolean):void
		{
			if(b)
			{
				this.imgBackground.addEventListener(MouseEvent.MOUSE_DOWN, onBackgroundClick);
			}
			else
			{
				this.imgBackground.removeEventListener(MouseEvent.MOUSE_DOWN, onBackgroundClick);
			}
		}

		/** 设置默认函数*/
		public function set defaultHandler(handler:Function):void
		{
			if(this._defaultHandler != null)
			{
				this.removeEventListener(Event.CHANGE, this._defaultHandler);
			}

			this._defaultHandler = handler;
			this.addEventListener(Event.CHANGE, this._defaultHandler);
		}

		/**	方向，横向还是纵向*/
		public function get direction():String
		{
			return this._direction;
		}

		public function set backgroundSkin(value:Object):void
		{
			imgBackground.source = value;
		}

		public function set quadSkin(value:Object):void
		{
			imgQuad.skin = value;
		}

		protected var _value:Number = 0;

		protected var _rawValue:Number = 0;

		protected var _min:Number = 0;

		protected var _max:Number = 100;

		protected var _tick:Number = 1;

		/**	取整的value*/
		public function get value():Number
		{

			return Math.round(isNaN(_value) ? 0 : _value / _tick) * _tick;
		}

		public function set value(value:Number):void
		{
			if(value == _value)
				return;

			_value = value;
			validValue();
			adjustQuadPosition();
		}

		/**	未取整的value，原始值*/
		public function get rawValue():Number
		{
			return _value;
		}

		/**	最小值*/
		public function get min():Number
		{
			return _min;
		}

		public function set min(value:Number):void
		{
			if(min == value)
				return;

			_min = value;
			validValue();
			adjustQuadPosition();
		}

		/**	最大值*/
		public function get max():Number
		{
			return _max;
		}

		public function set max(value:Number):void
		{
			if(max == value)
				return;

			_max = value;
			validValue();
			adjustQuadPosition();
		}

		/**	步长*/
		public function get tick():Number
		{
			return _tick;
		}

		public function set tick(value:Number):void
		{
			this._tick = value;
		}

		/**	背景图*/
		public function get backgroundImage():Image
		{
			return imgBackground;
		}

		/**	滑块按钮*/
		public function get quadButton():Button
		{
			return imgQuad;
		}
	}
}
