package com.vhall.framework.ui.event
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class DragEvent extends Event
	{
		/**
		 *	数据发生变更
		 */
		public static const CHANGE:String = "dragbar_change";

		/**
		 *	点击
		 */
		public static const CLICK:String = "dragbar_click";

		/**
		 *	松开鼠标，停止拖拽
		 */
		public static const DRAG_DROP:String = "dragbar_drop";

		/**
		 *	开始拖拽
		 */
		public static const DRAG_START:String = "dragbar_start";

		/**
		 *	鼠标滑动
		 */
		public static const HOVER:String = "dragbar_hover";

		/**
		 * 鼠标抬起
		 */
		public static const UP:String = "dragbar_up";

		public static const HOVER_WHILE_DRAGING:String = "dragbar_hover_while_draging";

		public function DragEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		/**
		 *	当前百分比
		 */
		public var percent:Number = 1;
	}
}
