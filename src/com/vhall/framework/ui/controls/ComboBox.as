package com.vhall.framework.ui.controls
{
	import com.vhall.framework.app.manager.RenderManager;
	import com.vhall.framework.app.manager.StageManager;
	import com.vhall.framework.ui.container.Box;
	import com.vhall.framework.ui.event.ListEvent;
	import com.vhall.framework.ui.interfaces.IData;
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
		protected var list:List;

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

			list = new List(List.VERTICAL, null, 0);
			list.addEventListener(ListEvent.SelectChanged, onItemSelected);
			list.renderCall = itemRenderCall;
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

		protected function hideList():void
		{
			open = false;
			StageManager.stage.removeEventListener(MouseEvent.CLICK, onStageClick);
			RenderManager.getInstance().invalidate(invalidate);
		}

		protected function onItemSelected(event:ListEvent):void
		{
			lbl.text = list.selectData + "";
			if(_content)
			{
				_content.data = list.selectData;
			}
			dispatchEvent(event);
		}

		protected function initDisplay():void
		{
			list.itemClass = ItemRender;

			lbl = new Label(container, 2);
			lbl.text = "text";
		}

		public function set itemRender(value:Class):void
		{
			list.itemClass = value;
		}


		public function set data(value:*):void
		{
			list.dataProvider = value as Array;
		}

		public function get data():*
		{
			return list.dataProvider;
		}

		public function get selectData():Object
		{
			return list.selectData;
		}

		public function get selectItem():ItemRender
		{
			return list.selectItem;
		}

		public function get selectIndex():int
		{
			return list.selectIndex;
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
			list.showDefaultLabel = value;
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
				var p:Point = this.localToGlobal(new Point(0, height));
				list.move(p.x, p.y);
				StageManager.stage.addChild(list);
			}
			else
			{
				list.removeFromParent();
			}

			lbl.y = height - lbl.height >> 1;
		}

		/**	显示列表的时候， 给舞台添加点击事件，控制显隐逻辑*/
		private function onStageClick(e:MouseEvent):void
		{
			if(this.hitTestPoint(e.stageX, e.stageY))
				return;
			if(new Rectangle(list.x, list.y, list.width, list.height).contains(e.stageX, e.stageY))
				return;

			hideList();
		}

		private var _itemWidth:Number = 0;

		public function set itemWidth(value:Number):void
		{
			_itemWidth = value;
			for each(var item:ItemRender in list.getChildren())
			{
				item.width = value;
			}
		}
	}
}

