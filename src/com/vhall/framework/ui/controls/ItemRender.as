package com.vhall.framework.ui.controls
{
	import com.vhall.framework.app.manager.RenderManager;
	import com.vhall.framework.ui.container.Box;
	import com.vhall.framework.ui.interfaces.IItemRenderer;
	
	import flash.display.DisplayObjectContainer;
	
	/**
	 * 渲染项 
	 * @author Sol
	 * @date 2016-06-03 17:10:32
	 */	
	public class ItemRender extends Box implements IItemRenderer
	{
		protected var _data:*;
		
		protected var _index:int;
		
		protected var _selected:Boolean;
		
		protected var _state:int;
		
		public var selectedCallBK:Function = null;
		
		public function ItemRender(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
			useHandCursor = true;
			buttonMode = true;
		}
		
		override public function destory():void
		{
			super.destory();
			
			_data = null;
			_index = -1;
			_selected = false;
			_state = -1;
			selectedCallBK = null;
		}
		
		/**	鼠标划过*/
		public function onMouseOver():void
		{
			RenderManager.getInstance().invalidate(invalidate);
		}
		
		/**	鼠标按下*/
		public function onMouseClick():void
		{
			RenderManager.getInstance().invalidate(invalidate);
		}
		
		/**	鼠标移出*/
		public function onMouseOut():void
		{
			RenderManager.getInstance().invalidate(invalidate);
		}
		
		public function setSelected(value:Boolean):void
		{
			this._selected = value;
			RenderManager.getInstance().invalidate(invalidate);
		}
		
		/**	设置数据*/
		public function set data(value:*):void
		{
			this._data = value;
			RenderManager.getInstance().invalidate(invalidate);
		}
		
		public function get data():*
		{
			return this._data;
		}
		
		/**	设置索引*/
		public function set index(value:int):void
		{
			this._index = value;
			RenderManager.getInstance().invalidate(invalidate);
		}
		
		public function get index():int
		{
			return this._index;
		}
		
		/**	设置是否选中*/
		public function set selected(value:Boolean):void
		{
			this._selected = value;
			RenderManager.getInstance().invalidate(invalidate);
		}
		
		public function get selected():Boolean
		{
			return this._selected;
		}
		
		/**	设置当前状态*/
		public function set state(value:int):void
		{
			this._state = value
		}
		
		public function get state():int
		{
			return this._state;
		}
	}
}