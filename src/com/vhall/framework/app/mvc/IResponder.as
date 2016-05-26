package com.vhall.framework.app.mvc
{

	/**
	 *	MVC解耦用的相应器
	 * @author Sol
	 * @date 2016-05-24
	 */
	public interface IResponder
	{
		/**
		 *	关心的事件列表
		 * @return
		 *
		 */
		function careList():Array;

		/**
		 *	响应关心事件的函数
		 * @param msg
		 * @param args
		 *
		 */
		function handleCare(msg:String, ... args):void;
	}
}
