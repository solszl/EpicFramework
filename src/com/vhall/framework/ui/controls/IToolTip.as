package com.vhall.framework.ui.controls
{

	/**
	 *	tooltip 接口，所有实现该接口的显示对象， 都可以弹出tooltip
	 * @author Sol
	 * @date 2016-05-19
	 */
	internal interface IToolTip
	{
		function set tooltip(value:Object):void;
		function get tooltip():Object;
		function set callOut(value:String):void;
		function get callOut():String;
	}
}
