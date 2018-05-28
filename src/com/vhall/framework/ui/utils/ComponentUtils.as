package com.vhall.framework.ui.utils
{
	import com.vhall.framework.app.manager.StageManager;
	import com.vhall.framework.ui.controls.UIComponent;

	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.JointStyle;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;

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
		public static function genInteractiveRect(w:Number, h:Number, p:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, fillColor:uint = 0xC0C0C0, fillAlpha:Number = 1, borderThickness:Number = NaN, borderColor:uint = 0, borderAlpha:Number = 1, ellipseWidth:Number = 0, ellipseHeight:Number = 0):UIComponent
		{
			var comp:UIComponent = new UIComponent(p, xpos, ypos);
			with(comp)
			{
				if(!isNaN(borderThickness))
				{
					graphics.lineStyle(borderThickness, borderColor, borderAlpha, true);
				}
				graphics.beginFill(fillColor, fillAlpha);
				graphics.drawRoundRect(0, 0, Math.max(w - 1, 1), Math.max(h - 1, 1), ellipseWidth, ellipseHeight);
				graphics.endFill();
			}
			return comp;
		}

		/**
		 *	创建一个可交互的圆
		 * @param r	半径
		 * @param p	父容器
		 * @param xpos 横坐标
		 * @param ypos 纵坐标
		 * @param fillColor 填充颜色
		 * @param fillAlpha	填充颜色的透明度
		 * @param borderThickness	外边的半径
		 * @param borderColor	外边的颜色
		 * @param borderAplha	外边的透明度
		 * @return 一个可交互的圆
		 *
		 */
		public static function genInteractiveCircle(r:Number, p:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, fillColor:uint = 0, fillAlpha:Number = 1, borderThickness:Number = NaN, borderColor:uint = 0, borderAplha:Number = 1):UIComponent
		{
			var comp:UIComponent = new UIComponent(p, xpos, ypos);
			if(!isNaN(borderThickness))
			{
				comp.graphics.lineStyle(borderThickness, borderColor, borderAplha, false, "normal", CapsStyle.ROUND, JointStyle.ROUND);
			}

			comp.graphics.beginFill(fillColor, fillAlpha);
			comp.graphics.drawCircle(r, r, r);
			comp.graphics.endFill();

			return comp;
		}

		public static function getDisplayBmd(target:DisplayObject):BitmapData
		{
			var bmd:BitmapData = new BitmapData(target.width, target.height, true, 0xFFFFFF);
			bmd.draw(target);
			return bmd;
		}

		/**
		 *	获取指定点下的所有组件 并以array形式 返回
		 * @param obj	根容器，通常都是取stage
		 * @param pt	指定点
		 * @param arr	返回的数组
		 *
		 */
		public static function getObjectsUnderPoint(obj:DisplayObject, pt:Point, arr:Array):void
		{
			if(!obj.visible)
				return;
			if(obj is Stage || obj.hitTestPoint(pt.x, pt.y, true))
			{
				if(obj is InteractiveObject && InteractiveObject(obj).mouseEnabled)
					arr.push(obj);
				if(!(obj is DisplayObjectContainer))
				{
					return;
				}
				var doc:DisplayObjectContainer = obj as DisplayObjectContainer;
				if(!doc.mouseChildren)
				{
					return;
				}
				if(doc.numChildren)
				{
					var n:int = doc.numChildren;
					for(var i:int = 0; i < n; i++)
					{
						try
						{
							var child:DisplayObject = doc.getChildAt(i);
							getObjectsUnderPoint(child, pt, arr);
						}
						catch(e:Error)
						{
							//another sandbox?
						}
					}
				}

			}
		}

		/**
		 * 判断2个矩形相交的矩形 类似 Rectangle的intersection方法, 创建本方法的原因是因为EpicFramework 内部的scale， 组件缩放后，使用getBounds 和getRect 所返回的矩形大小不对
		 * @param fromTarget
		 * @param toTarget
		 * @return
		 *
		 */
		public static function getIntersect(fromTarget:DisplayObject, toTarget:DisplayObject):Rectangle
		{
			var fromRect:Rectangle = fromTarget.getBounds(fromTarget);
			var toRect:Rectangle = new Rectangle(toTarget.x, toTarget.y, toTarget.width * toTarget.scaleX, toTarget.height * toTarget.scaleY);
			var rect:Rectangle = fromRect.intersection(toRect);

			var x:Number, y:Number, w:Number, h:Number;
			if(rect.x <= 0 && rect.width + rect.x < StageManager.stageWidth)
			{
				x = 0;
				w = rect.width + rect.x;
			}

			if(rect.x <= 0 && rect.width + rect.x > StageManager.stageWidth)
			{
				x = 0;
				w = StageManager.stageWidth;
			}

			if(rect.x > 0 && rect.x + rect.width < StageManager.stageWidth)
			{
				x = rect.x;
				w = rect.width;
			}

			if(rect.x > 0 && rect.x + rect.width > StageManager.stageWidth)
			{
				x = rect.x;
				w = StageManager.stageWidth - rect.x;
			}

			if(rect.y <= 0 && rect.y + rect.height < StageManager.stageHeight)
			{
				y = 0;
				h = rect.height + rect.y;
			}

			if(rect.y <= 0 && rect.y + rect.height > StageManager.stageHeight)
			{
				y = 0;
				h = StageManager.stageHeight;
			}

			if(rect.y > 0 && rect.y + rect.height > StageManager.stageHeight)
			{
				y = rect.y;
				h = StageManager.stageHeight - rect.y;
			}

			if(rect.y > 0 && rect.y + rect.height < StageManager.stageHeight)
			{
				y = rect.y;
				h = rect.height;
			}

			return new Rectangle(x, y, w, h);
		}
	}
}
