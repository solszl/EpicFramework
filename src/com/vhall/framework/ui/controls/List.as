package com.vhall.framework.ui.controls
{
	import com.vhall.framework.app.manager.RenderManager;
	import com.vhall.framework.ui.container.Box;
	import com.vhall.framework.ui.container.HBox;
	import com.vhall.framework.ui.container.VBox;
	import com.vhall.framework.ui.event.ListEvent;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.engine.RenderingMode;

	/**
	 * 列表文件
	 * @author Sol
	 * @date 2016-06-03 16:49:45
	 */
	[Event(name = "select", type = "flash.events.Event")]
	public class List extends Box
	{
		/**	水平*/
		public static const HORIZONTAL:String = "horizontal";
		/**	纵向*/
		public static const VERTICAL:String = "vertical";

		private var direction:String = VERTICAL;

		/**	真正的承载容器*/
		private var con:Box;

		private var _dataProvider:Array;
		private var _selectIndex:int = -1;
		private var _selectData:Object;
		private var _selectItem:ItemRender;

		/** 数据源是否发生变化*/
		private var dataProviderChanged:Boolean = false;

		private var itemPool:Array;

		public var itemClass:Class;

		public var isSelectSame:Boolean = false;

		public var renderCall:Function = null;

		/**	列表项间距*/
		private var gap:Number;

		public function List(direction:String = VERTICAL, parent:DisplayObjectContainer = null, gap:Number = 2, xpos:Number = 0, ypos:Number = 0)
		{
			this.direction = direction;
			this.gap = gap;
			super(parent, xpos, ypos);
		}

		override protected function init():void
		{
			super.init();
			itemPool = [];
		}

		override protected function createChildren():void
		{
			super.createChildren();
			if(direction == VERTICAL)
			{
				con = new VBox(this);
				VBox(con).gap = gap;
			}
			else
			{
				con = new HBox(this);
				HBox(con).gap = gap;
			}
		}

		override protected function invalidate():void
		{
			if(dataProviderChanged)
			{
				var item:ItemRender;
				// 数据发生变化的时候， 将数据项全部移除
				while(con.numChildren)
				{
					item = con.removeChildAt(0) as ItemRender;
					item.destory();
					removeEvents(item);
					itemPool.push(item);
				}

				if(dataProvider)
				{
					var len:int = dataProvider.length;
					for(var i:int = 0; i < len; i++)
					{
						item = createItem(dataProvider[i]);
						item.index = i;
						con.addChild(item);
						item.selected = false;
					}
				}
				dataProviderChanged = false;
			}

			super.invalidate();
		}

		override public function destory():void
		{
			renderCall = null;
			itemClass = null;
			itemPool = [];
			con.removeAllChild();

			_selectIndex = -1;
			_selectData = {};
			_selectItem = null;
		}

		override public function getChildren():Vector.<DisplayObject>
		{
			var childs:Vector.<DisplayObject> = con.getChildren();
			return childs;
		}

		/**	鼠标事件集合*/
		protected function onMouseHandler(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			if(e.target is ItemRender)
			{
				switch(e.type)
				{
					case MouseEvent.ROLL_OVER:
						ItemRender(e.target).onMouseOver();
						break;
					case MouseEvent.ROLL_OUT:
						ItemRender(e.target).onMouseOut();
						break;
					case MouseEvent.CLICK:
						if(ItemRender(e.target).selected && !isSelectSame)
						{
							return;
						}
						ItemRender(e.target).onMouseClick();
						selectItem = e.target as ItemRender;
						break;
					default:
						break;
				}
			}
		}

		/**
		 *	不派发事件的设置选中项
		 * @param value 索引
		 *
		 */
		public function setSelectIndex(value:int):void
		{
			if(value == selectIndex)
			{
				return;
			}

			if(selectIndex < con.numChildren && selectIndex >= 0)
			{
				(con.getChildAt(selectIndex) as ItemRender).selected = false;
			}

			_selectIndex = value;

			if(selectIndex >= 0 && dataProvider != null && dataProvider.length > selectIndex)
			{
				(con.getChildAt(selectIndex) as ItemRender).selected = true;
			}
			else
			{
				_selectIndex = -1;
			}
		}

		private function removeEvents(item:ItemRender):void
		{
			item.removeEventListener(MouseEvent.ROLL_OVER, onMouseHandler);
			item.removeEventListener(MouseEvent.ROLL_OUT, onMouseHandler);
			item.removeEventListener(MouseEvent.CLICK, onMouseHandler);
		}

		private function addEvents(item:ItemRender):void
		{
			item.addEventListener(MouseEvent.ROLL_OVER, onMouseHandler);
			item.addEventListener(MouseEvent.ROLL_OUT, onMouseHandler);
			item.addEventListener(MouseEvent.CLICK, onMouseHandler);
		}

		private function createItem(data:*):ItemRender
		{
			var item:ItemRender = itemPool.length > 0 ? itemPool.pop() : itemClass == null ? new ItemRender() : new itemClass();
			item.data = data;
			item.showDefaultLabel = showDefaultLabel;
			addEvents(item);
			// 如果设定了渲染设置数据的回调
			if(renderCall != null)
			{
				renderCall(item, data);
			}

			return item;
		}

		/**	数据源*/
		public function get dataProvider():Array
		{
			return _dataProvider;
		}

		public function set dataProvider(value:Array):void
		{
			if(value == _dataProvider)
			{
				return;
			}

			_dataProvider = value;
			dataProviderChanged = true;
			dispatchEvent(new ListEvent(ListEvent.DataChanged));
			RenderManager.getInstance().invalidate(invalidate);
		}

		/**	当前选中项*/
		public function get selectIndex():int
		{
			return _selectIndex;
		}

		public function set selectIndex(value:int):void
		{
			setSelectIndex(value);
			fireEvent(ListEvent.IndexChanged)
			fireEvent(ListEvent.SelectChanged);
		}

		/**	当前选中数据*/
		public function get selectData():Object
		{
			if(_dataProvider == null)
			{
				return null;
			}

			if(selectIndex >= 0 && selectIndex < _dataProvider.length)
			{
				return _dataProvider[selectIndex];
			}
			return null;
		}

		public function set selectData(value:Object):void
		{
			var index:int = _dataProvider.indexOf(value);
			selectIndex = index;
			fireEvent(ListEvent.DataChanged);
		}

		/**	当前选中渲染器*/
		public function get selectItem():ItemRender
		{
			if(_dataProvider == null)
			{
				return null;
			}

			if(selectIndex >= 0 && selectIndex < _dataProvider.length)
			{
				return con.getChildAt(selectIndex) as ItemRender;
			}

			return null;
		}

		public function set selectItem(value:ItemRender):void
		{
			var idx:int = con.getChildIndex(value);
			selectIndex = idx;
			fireEvent(ListEvent.ItemChanged);
		}

		private var _showDefaultLabel:Boolean = false;

		public function set showDefaultLabel(value:Boolean):void
		{
			_showDefaultLabel = value;
		}

		public function get showDefaultLabel():Boolean
		{
			return _showDefaultLabel;
		}

		public function fireEvent(type:String):void
		{
			if(hasEventListener(type))
			{
				var e:ListEvent = new ListEvent(type);
				e.data = selectData;
				e.index = selectIndex;
				dispatchEvent(e);
			}
		}
	}
}


