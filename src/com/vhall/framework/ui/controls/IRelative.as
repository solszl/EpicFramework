package com.vhall.framework.ui.controls
{

	/**
	 * 相对布局接口
	 * @author Sol
	 *
	 */
	public interface IRelative
	{
		/** 左*/
		function set left(value:Object):void;
		function get left():Object;
		/** 右*/
		function set right(value:Object):void;
		function get right():Object;
		/** 上*/
		function set top(value:Object):void;
		function get top():Object;
		/** 下*/
		function set bottom(value:Object):void;
		function get bottom():Object;
		/** 水平，正数为右，负数为左*/
		function set horizontalCenter(value:Number):void;
		function get horizontalCenter():Number;
		/** 纵向，正数为下，负数为上*/
		function set verticalCenter(value:Number):void;
		function get verticalCenter():Number;
	}
}
