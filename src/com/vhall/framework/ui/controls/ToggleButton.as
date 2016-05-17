package com.vhall.framework.ui.controls
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * 开关按钮 
	 * @author Sol
	 * @date 2016-05-17
	 */	
	[Event(name="select", type="flash.events.Event")]
	public class ToggleButton extends Button implements ISelectable
	{
		public function ToggleButton(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
		}
		
		private var _selected:Boolean = false;
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		override protected function onMouse(e:MouseEvent):void
		{
			if(e.type == MouseEvent.CLICK)
			{
				this.selected = !this.selected;
				//根据选中当前选中状态设定按钮点按的状态
				// 若此时为选中状态，点击过后，鼠标仍然在按钮内，则将状态设置为 划过状态，否则设置为移出状态
				//	若为未选中状态，点击过后，鼠标状态设置为按下状态
				state = this.selected ? stateMap["mouseDown"] : getBounds(this).containsPoint(new Point(e.localX,e.localY)) ? stateMap["rollOver"] :  stateMap["rollOut"];
				dispatchEvent(new Event(Event.SELECT));
			}
			else if(!this.selected)
			{
				// 当没有选中的时候， 鼠标划过状态设定
				state = stateMap[e.type];
			}
		}
	}
}