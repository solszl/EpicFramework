package com.vhall.framework.ui.interfaces
{
	import com.vhall.framework.ui.interfaces.ISelectable;
	import com.vhall.framework.ui.interfaces.IState;

	/**
	 * 渲染器接口 
	 * @author Sol
	 * @2016-06-03 16:52:59
	 */	
	public interface IItemRenderer extends ISelectable, IState
	{
		function set data(value:*):void;
		function get data():*;
		
		function set index(value:int):void;
		function get index():int;
		
		function onMouseOver():void;
		function onMouseClick():void;
		function onMouseOut():void;
	}
}