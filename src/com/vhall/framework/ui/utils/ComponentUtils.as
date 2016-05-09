package com.vhall.framework.ui.utils
{
	import com.vhall.framework.ui.controls.UIComponent;

	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;

	/**
	 *	技术控件工具类
	 * @author Sol
	 *
	 */
	public class ComponentUtils
	{
		/**
		 *	创建一个可交互的可显示对象
		 */
		public static function genInteractiveRect(w:Number, h:Number, fillColor:uint=0xC0C0C0, fillAlpha:Number=1, borderThickness:Number=NaN, borderColor:uint=0, borderAlpha:Number=1, ellipseWidth:Number=0, ellipseHeight:Number=0):UIComponent
		{
			var comp:UIComponent=new UIComponent();
			var temp:Number=isNaN(borderThickness) ? 0 : borderThickness / 2;
			with (comp)
			{
				if (!isNaN(borderThickness))
				{
					graphics.lineStyle(borderThickness, borderColor, borderAlpha, true);
				}
				graphics.beginFill(fillColor, fillAlpha);
				graphics.drawRoundRect(0, 0, w - 2 * temp, h - 2 * temp, ellipseWidth, ellipseHeight);
				graphics.endFill();
			}
			return comp;
		}

		/**	创建一个不可交互的可显示对象*/
//		public static function genUninteractiveRect():Shape
//		{
//			
//			return new Shape();
//		}
	}
}
