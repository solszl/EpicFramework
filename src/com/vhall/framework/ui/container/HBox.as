package com.vhall.framework.ui.container
{
	import com.adobe.tvsdk.mediacore.ABRControlParameters;
	import com.vhall.framework.ui.controls.UIComponent;
	import com.vhall.framework.ui.layout.HorizontalLayout;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 *	横向布局容器
	 * @author Sol
	 *	@date 2016-05-17
	 */
	public class HBox extends Box
	{
		public var _gap:Number = 0;

		private var _verticalAlign:String = "center";

		private var _horizontalAlign:String = "left";

		public function HBox(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			_layout = new HorizontalLayout();
			gap = 5;
		}

		public function set gap(value:Number):void
		{
			HorizontalLayout(_layout).gap = value;
		}

		public function get gap():Number
		{
			return HorizontalLayout(_layout).gap;
		}

		[Inspectable(category = "General", enumeration = "left,right,center", defaultValue = "left")]
		public function get horizontalAlign():String
		{
			return HorizontalLayout(_layout).horizontalAlign;
		}

		/**
		 *  @private
		 */
		public function set horizontalAlign(value:String):void
		{
			HorizontalLayout(_layout).horizontalAlign = value;
		}

		[Inspectable(category = "General", enumeration = "top,center,bottom", defaultValue = "top")]
		public function get verticalAlign():String
		{
			return HorizontalLayout(_layout).verticalAlign;
		}

		public function set verticalAlign(value:String):void
		{
			HorizontalLayout(_layout).verticalAlign = value;
		}
	}
}
