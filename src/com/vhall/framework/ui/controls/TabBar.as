package com.vhall.framework.ui.controls
{
	import com.vhall.framework.app.manager.RenderManager;
	import com.vhall.framework.ui.container.Box;
	import com.vhall.framework.ui.container.HBox;
	import com.vhall.framework.ui.container.VBox;
	import com.vhall.framework.ui.event.ListEvent;
	import com.vhall.framework.ui.interfaces.IItemRenderer;
	import com.vhall.framework.ui.interfaces.ILayout;
	import com.vhall.framework.ui.layout.HorizontalLayout;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 *
	 * @author Sol
	 * @date 2016-06-20 11:52:16
	 *
	 */
	public class TabBar extends Box
	{
		private var con:List;

		private var _itemRender:Class;

		private var _dataProvider:Array;

		public function TabBar(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		}

		override protected function createChildren():void
		{
			super.createChildren();
			// 容器
			con = new List(this);
			con.renderCall = itemRenderCall;
			con.addEventListener(ListEvent.SelectChanged, onListEventHandler);
			con.addEventListener(ListEvent.DataChanged, onListEventHandler);
			con.addEventListener(ListEvent.ItemChanged, onListEventHandler);
			con.addEventListener(ListEvent.IndexChanged, onListEventHandler);
		}

		override public function set layout(value:ILayout):void
		{
			super.layout = value;
			con.layout = value;
		}

		override public function get layout():ILayout
		{
			return con.layout;
		}

		public function set dataProvider(value:Array):void
		{
			this._dataProvider = value;
			con.dataProvider = value;
		}

		public function get dataProvider():Array
		{
			return this._dataProvider;
		}

		public function set itemRender(value:Class):void
		{
			this._itemRender = value;
			con.itemClass = value;
			RenderManager.getInstance().invalidate(invalidate);
		}

		public function get itemRender():Class
		{
			return this._itemRender;
		}

		protected function onSelectHandler(e:Event):void
		{
			if(ItemRender(e.target).selected)
			{
				ItemRender(e.target).setSelected(true);
				return;
			}
			con.selectItem = e.target as ItemRender;

			if(hasEventListener(ListEvent.SelectChanged))
			{
				var evt:ListEvent = new ListEvent(ListEvent.SelectChanged);
				evt.index = con.selectIndex;
				evt.data = con.selectData;
				dispatchEvent(evt);
			}
		}

		private function itemRenderCall(item:ItemRender, data:*):void
		{
			item.addEventListener(Event.SELECT, onSelectHandler);
		}

		public function set selectedIndex(value:int):void
		{
			con.selectIndex = value;
			RenderManager.getInstance().invalidate(invalidate);
		}

		private function onListEventHandler(e:ListEvent):void
		{
			if(hasEventListener(e.type))
			{
				dispatchEvent(e);
			}
		}
	}
}
