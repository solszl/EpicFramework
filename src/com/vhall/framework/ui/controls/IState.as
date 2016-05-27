package com.vhall.framework.ui.controls
{

	/**
	 * 状态接口
	 * @author Sol
	 *
	 */
	public interface IState
	{
		function set state(vallue:int):void;
		/**
		 *	获取当前状态
		 * @return
		 *
		 */
		function get state():int;
	}
}
