package com.vhall.framework.ui.event
{
	import com.vhall.framework.ui.controls.ItemRender;
	import com.vhall.framework.ui.interfaces.IItemRenderer;

	import flash.events.Event;

	/**
	 *
	 * @author Sol
	 * @date 2016-06-20 14:08:15
	 *
	 */
	public class ListEvent extends Event
	{
		public static const SelectChanged:String = "list_select_changed";

		public static const IndexChanged:String = "list_index_changed";

		public static const ItemChanged:String = "list_item_changed";

		public static const DataChanged:String = "list_data_changed";

		/**	数据*/
		public var data:*;

		/**	索引*/
		public var index:int;

		public var item:ItemRender;

		public function ListEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			var e:ListEvent = new ListEvent(type, bubbles, cancelable);
			e.data = data;
			e.index = index;
			e.item = item;
			return e;
		}
	}
}
