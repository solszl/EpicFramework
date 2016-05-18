package com.vhall.framework.ui.event
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class DragEvent extends Event
	{
		/**
		 *	数据发生变更 
		 */		
		public  static const CHANGE:String = "dragbar_change";
		
		/**
		 *	点击 
		 */		
		public static const CLICK:String = "dragbar_click";
		
		/**
		 *	鼠标滑动 
		 */		
		public static const HOVER:String = "dragbar_hover";
		
		/**
		 *	开始拖拽 
		 */		
		public static const DRAG_START:String = "dragbar_start";
		
		/**
		 *	松开鼠标，停止拖拽 
		 */		
		public static const DRAG_DROP:String = "dragbar_drop";
		
		/**
		 *	当前百分比 
		 */		
		public var percent:Number = 1;
		
		public function DragEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}