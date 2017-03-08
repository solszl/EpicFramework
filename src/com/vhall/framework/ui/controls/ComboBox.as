package com.vhall.framework.ui.controls
{
	import com.vhall.framework.app.manager.RenderManager;
	import com.vhall.framework.app.manager.StageManager;
	import com.vhall.framework.ui.container.Box;
	import com.vhall.framework.ui.event.ListEvent;
	import com.vhall.framework.ui.interfaces.IData;
	import com.vhall.framework.ui.layout.VerticalLayout;
	import com.vhall.framework.ui.utils.ComponentUtils;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import spark.components.supportClasses.DisplayLayer;

	/**
	 * 下拉框
	 * @author Sol
	 * @date 2016-08-24 14:09:29
	 */
	public class ComboBox extends Box implements IData
	{
		/**	背景*/
		protected var bg:Image;

		/**	列表项*/
		protected var _list:List;

		protected var container:Box;

		protected var lbl:Label;

		protected var open:Boolean = false;

		public function ComboBox(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		}

		override protected function createChildren():void
		{
			super.createChildren();

			bg = new Image(this);
			bg.source = ComponentUtils.genInteractiveRect(45, 20, null);
			bg.buttonMode = true;
			bg.useHandCursor = true;
			bg.addEventListener(MouseEvent.CLICK, onOpenList);

			container = new Box(this);
			container.mouseEnabled = false;
			container.mouseChildren = false;

			_list = new List(null);
			_list.addEventListener(ListEvent.SelectChanged, onItemSelected);
			_list.renderCall = itemRenderCall;
			var layout:VerticalLayout = new VerticalLayout();
			layout.gap = 0;
			_list.layout = layout;
			initDisplay();
		}

		protected function onOpenList(event:MouseEvent):void
		{
			open ? hideList() : openList();
		}

		protected function openList():void
		{
			open = true;
			StageManager.stage.addEventListener(MouseEvent.CLICK, onStageClick);
			RenderManager.getInstance().invalidate(invalidate);
		}

		public function hideList():void
		{
			open = false;
			StageManager.stage.removeEventListener(MouseEvent.CLICK, onStageClick);
			RenderManager.getInstance().invalidate(invalidate);
		}

		protected function onItemSelected(event:ListEvent):void
		{
			lbl.text = _list.selectData + "";

			if(_content)
			{
				_content.data = _list.selectData;
			}
			dispatchEvent(event);
		}

		protected function initDisplay():void
		{
			_list.itemClass = ItemRender;

			lbl = new Label(container, 2);
			lbl.text = "text";
		}

		public function set itemRender(value:Class):void
		{
			_list.itemClass = value;
		}


		public function set data(value:*):void
		{
			_list.dataProvider = value as Array;
		}

		public function get data():*
		{
			return _list.dataProvider;
		}

		public function get selectData():Object
		{
			return _list.selectData;
		}

		public function set selectData(value:Object):void
		{
			if(_list.initialized)
				_list.selectData = value;
		}

		public function get selectItem():ItemRender
		{
			return _list.selectItem;
		}

		public function get selectIndex():int
		{
			return _list.selectIndex;
		}

		public function get list():List
		{
			return _list;
		}

		public function set buttonBackground(value:*):void
		{
			bg.source = value;
		}

		protected var _content:IData;

		public function set content(value:*):void
		{
			_content = value;

			if(_offset)
			{
				DisplayObject(_content).x = _offset.x;
				DisplayObject(_content).y = _offset.y;
			}
			container.addChild(_content as DisplayObject);
			lbl.visible = false;
		}

		protected var _offset:Point;

		public function set contentOffset(value:Point):void
		{
			_offset = value;

			if(_content)
			{
				DisplayObject(_content).x = value.x;
				DisplayObject(_content).y = value.y;
			}
		}

		public function set showDefaultLabel(value:Boolean):void
		{
			_list.showDefaultLabel = value;
		}

		protected function itemRenderCall(item:ItemRender, data:*):void
		{
			item.width = _itemWidth;
		}

		override protected function updateDisplay():void
		{
			super.updateDisplay();

			if(open)
			{
				setListPosition();
				StageManager.stage.addChild(_list);
			}
			else
			{
				_list.removeFromParent();
			}

			lbl.y = height - lbl.height >> 1;
		}

		private function setListPosition():void
		{
			var p:Point = this.localToGlobal(new Point());

			if((y + height + _list.height) > StageManager.stageHeight)
			{
				_listDirection = 0;
				_list.move(p.x, p.y - _list.height);
			}
			else
			{
				_listDirection = 1;
				_list.move(p.x, p.y + height);
			}
		}

		/**	显示列表的时候， 给舞台添加点击事件，控制显隐逻辑*/
		private function onStageClick(e:MouseEvent):void
		{
			if(this.hitTestPoint(e.stageX, e.stageY))
				return;

			if(new Rectangle(_list.x, _list.y, _list.width, _list.height).contains(e.stageX, e.stageY))
				return;

			hideList();
		}

		private var _itemWidth:Number = 0;

		public function set itemWidth(value:Number):void
		{
			_itemWidth = value;

			for each(var item:ItemRender in _list.getChildren())
			{
				item.width = value;
			}
		}

		private var _listDirection:int = 1;

		/**	0 向上，1向下*/
		public function get listDirection():int
		{
			return _listDirection;
		}
	}
}

