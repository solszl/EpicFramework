package com.vhall.framework.ui.panel
{

	/**
	 * 面板接口
	 * @author Sol
	 *
	 */
	public interface IPanel
	{
		/**	打开窗口*/
		function show(... arg):void;
		/**	关闭窗口*/
		function hide():void;
		/**	窗口是否处于打开状态*/
		function get isOpen():Boolean;
		/** 是否跟其他窗口互斥，即打开其他窗口时，该窗口是否关闭*
		 * @default true
		 */
		function get isMutex():Boolean;
		function set isMutex(b:Boolean):void;

		/**	返回窗口id*/
		function get id():int;
		function set id(id:int):void;
	}
}
