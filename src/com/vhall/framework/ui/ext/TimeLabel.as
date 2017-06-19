package com.vhall.framework.ui.ext
{
	import com.vhall.framework.ui.controls.Label;
	import com.vhall.framework.utils.StringUtil;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * 用于显示时间的文本标签
	 * @author Sol
	 *
	 */
	public class TimeLabel extends Label
	{
		/** 1 秒钟 */
		private static const ONE_SECOND:int = 1000;
		/** 1 分钟 */
		private static const ONE_MINUTE:int = 1000 * 60;
		/** 1 小时 */
		private static const ONE_HOUR:int = 1000 * 60 * 60;

		public function TimeLabel(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		}

		private var _ms:int;
		private var _autoStart:Boolean;

		/**	小于10的时候是否补全0，00:02:04 2:4*/
		private static var fillZero:Boolean = true;

		private var timer:Timer;
		private var _delay:Number = 1000;
		private var _addTime:Boolean = true;

		public function start():void
		{
			if(timer == null)
			{
				timer = new Timer(delay);
				timer.addEventListener(TimerEvent.TIMER, onTImer);
				onTImer(null);
			}

			if(!timer.running)
			{
				timer.start();
			}
		}

		public function stop():void
		{
			if(timer.running)
			{
				timer.stop();
			}
		}

		protected function onTImer(e:TimerEvent):void
		{
			if(addTime)
			{
				_ms += delay;
			}
			else
			{
				_ms -= delay;
			}

			this.text = format(_ms);
			this.textField.background = true;

			if(_ms <= 0)
			{
				stop();
			}

			if(hasEventListener(Event.CHANGE))
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}

		/**
		 * 将毫秒数格式化为 "hh:mm:ss" 字符串
		 *
		 * @param ms 毫秒时间
		 */
		public static function format(ms:int):String
		{
			if(ms < 0)
			{
				return "";
			}

			var h:int = ms / ONE_HOUR;
			ms %= ONE_HOUR;
			var m:int = ms / ONE_MINUTE;
			ms %= ONE_MINUTE;
			var s:int = ms / ONE_SECOND;

//			var h_str:String = h > 9 ? String(h) : fillZero ? "0" + h : h + "";
//			var m_str:String = m > 9 ? String(m) : fillZero ? "0" + m : m + "";
//			var s_str:String = s > 9 ? String(s) : fillZero ? "0" + s : s + "";
//			return h_str + ":" + m_str + ":" + s_str;

			return StringUtil.zero(h) + ":" + StringUtil.zero(m) + ":" + StringUtil.zero(s);
		}

		/**	毫秒值*/
		public function get ms():int
		{
			return _ms;
		}

		public function set ms(value:int):void
		{
			_ms = value;

			this.text = format(value);

			if(autoStart)
			{
				start();
			}
		}

		/**	是否自动开始*/
		public function get autoStart():Boolean
		{
			return _autoStart;
		}

		public function set autoStart(value:Boolean):void
		{
			_autoStart = value;
		}

		/**	timer的延迟*/
		public function get delay():Number
		{
			return _delay;
		}

		public function set delay(value:Number):void
		{
			_delay = value;
		}

		/**	是增加时间还是减少时间*/
		public function get addTime():Boolean
		{
			return _addTime;
		}

		public function set addTime(value:Boolean):void
		{
			_addTime = value;
		}
	}
}
