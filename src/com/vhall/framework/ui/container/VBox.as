package com.vhall.framework.ui.container
{
	import com.vhall.framework.ui.controls.UIComponent;
	import com.vhall.framework.ui.layout.VerticalLayout;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * 纵向布局容器
	 * @author Sol
	 * @date 2016-05-17
	 */
	public class VBox extends Box
	{
		/**
		 *	每项的间隔
		 */
		protected var _gap:Number = 0;

		private var maxWidth:Number = 0;

		private var _horizontalAlign:String = "left";

		public var marginTop:Number = 0;
		public var marginBottom:Number = 0;

		private var calcH:Number = 0;

		public function VBox(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{

			super(parent, xpos, ypos);
			_layout = new VerticalLayout();
			gap = 5;
		}

		public function set gap(value:Number):void
		{
			VerticalLayout(_layout).gap = value;
		}

		public function get gap():Number
		{
			return VerticalLayout(_layout).gap;
		}

		/**
		 * 纵向布局对齐，默认：<b>top</b>
		 * <li/><b> left </b> 左侧对齐</br>
		 * <li/><b> middle </b> 中间对齐</br>
		 * <li/><b> right </b> 底部对其</br>
		 */
		[Inspectable(category = "General", enumeration = "left,right,center", defaultValue = "left")]
		public function get horizontalAlign():String
		{
			return VerticalLayout(_layout).horizontalAlign;
		}

		/**
		 *  @private
		 */
		public function set horizontalAlign(value:String):void
		{
			VerticalLayout(_layout).horizontalAlign = value;
		}

		[Inspectable(category = "General", enumeration = "top,middle,bottom", defaultValue = "top")]
		public function get verticalAlign():String
		{
			return VerticalLayout(_layout).verticalAlign;
			;
		}

		public function set verticalAlign(value:String):void
		{
			VerticalLayout(_layout).verticalAlign = value;
		}

	}
}
