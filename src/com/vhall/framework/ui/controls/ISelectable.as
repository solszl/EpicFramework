package com.vhall.framework.ui.controls
{

	/**
	 * 可选择接口
	 * @author Sol
	 * @date 2016-05-16
	 */
	public interface ISelectable
	{

		function set selected(value:Boolean):void;
		
		/**
		 *	返回当前选中状态
		 * @return
		 *
		 */
		function get selected():Boolean;

	}
}
