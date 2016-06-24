package com.vhall.framework.ui.container
{
	import com.vhall.framework.app.manager.RenderManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * 导航布局器 
	 * @author Sol
	 * @date 2016-06-20 14:33:28
	 * 
	 */	
	public class ViewStack extends Box
	{
		public function ViewStack(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}
		
		private var _selectedIndex:int=-1;
		private var selectedIndexChanged:Boolean=false;
		
		//当前选中的视窗
		private var currentChild:DisplayObject;
		
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:int):void
		{
			value= 0 > value ? 0 : value;
			if (_selectedIndex == value || value > this.numChildren)
				return;
			_selectedIndex=value;
			selectedIndexChanged=true;
			
			RenderManager.getInstance().invalidate(invalidate);
		}
		
		public function get selectedChild():DisplayObject
		{
			return getChildAt(_selectedIndex);
		}
		
		public function set selectedChild(value:DisplayObject):void
		{
			selectedIndex=getChildIndex(value);
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			child.visible = false;
			selectedIndexChanged=true;
			return super.addChild(child);
		}
		
		override protected function invalidate():void
		{
			if(selectedIndexChanged)
			{
				var child:DisplayObject=getChildAt(selectedIndex);
				if (currentChild && currentChild != child)
				{
					currentChild.visible=false;
				}
				child.visible=true;
				currentChild=child;
				selectedIndexChanged = false;
			}
			super.invalidate();
		}
		
		override protected function sizeChanged():void
		{
			super.sizeChanged();
			currentChild.width = width;
			currentChild.height = height;
		}
	}
}