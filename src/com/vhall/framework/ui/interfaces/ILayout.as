package com.vhall.framework.ui.interfaces
{
	import com.vhall.framework.ui.container.Box;

	/**
	 * 布局接口
	 * @author Sol
	 * @date 2016-08-25 23:35:45
	 */
	public interface ILayout
	{
		function doLayout(target:Box):void;
		function get measureHeight():Number;
		function get measureWidth():Number;
		function toString():String;
	}
}
