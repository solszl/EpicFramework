package com.vhall.framework.ui.interfaces
{

	/**
	 * 状态接口
	 * @author Sol
	 *
	 */
	public interface IState
	{
		function set state(value:int):void;
		/**
		 *	获取当前状态
		 * @return
		 *
		 */
		function get state():int;
	}
}
