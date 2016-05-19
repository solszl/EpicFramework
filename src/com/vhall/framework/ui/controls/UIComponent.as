package com.vhall.framework.ui.controls
{
	import com.vhall.framework.app.manager.RenderManager;
	import com.vhall.framework.utils.StringUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	
	/**
	 *	组件基类 
	 * @author Sol
	 * 
	 */	
	public class UIComponent extends Sprite
	{
		/**
		 *	构建基类 
		 * @param parent 是否有父容器，当存在父容器的时候，该组件自动添加到父容器
		 * @param xpos	默认横坐标位置
		 * @param ypos	默认纵坐标位置
		 * 
		 */		
		public function UIComponent(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super();
			
			move(xpos, ypos);
			
			if(parent!=null)
			{
				parent.addChild(this);
			}
			
			init();
		}
		
		protected function init():void
		{
			// subclass overwrite
			createChildren();
		}
		
		protected function createChildren():void
		{
			
		}
		
		protected function invalidate():void
		{
			
		}
		
		protected function updateDisplay():void
		{
			
		}
		
		protected function destory():void
		{
			
		}
		
		override public function set alpha(value:Number):void
		{
			super.alpha = value;
			value == 0 ? visible = false : true;
		}
		
		protected var _width:Number = 0;
		override public function set width(value:Number):void
		{
			if(_width == value)
			{
				return;
			}
			_width = value;
			RenderManager.getInstance().invalidate(invalidate);
		}
		
		override public function get width():Number
		{
			return _width == 0 ? super.width : _width;
		}
		
		protected var _height:Number = 0;
		override public function set height(value:Number):void
		{
			if(_height == value)
			{
				return;
			}
			_height = value;
			RenderManager.getInstance().invalidate(invalidate);
		}
		
		override public function get height():Number
		{
			return _height == 0 ? super.height : _height;
		}
		
		/**
		 * 移动 
		 * @param xpos 横坐标
		 * @param ypos 纵坐标
		 * 
		 */		
		public function move(xpos:Number, ypos:Number):void
		{
			this.x = Math.round(xpos);
			this.y = Math.round(ypos);
		}
		
		/**
		 *	设置宽高 
		 * @param w 宽
		 * @param h 高
		 * 
		 */		
		public function setSize(w:Number, h:Number):void
		{
			this._width = Math.round(w);
			this._height = Math.round(h);
		}
		
		/**显示边框*/
		public function showBorder(color:uint = 0xff0000):void
		{
			RenderManager.getInstance().validateNow();
			with (this)
			{
				graphics.clear();
				graphics.lineStyle(1, color);
				graphics.drawRect(0, 0, width, height);
			}
		}
		
		/**
		 *	拿到组件的宽,高,X,Y,以及反射出来的名字
		 * @return
		 *
		 */
		public function get selfInfo():String
		{
			return StringUtil.substitute(info,getQualifiedClassName(this),width,height,x,y,this.parent != null, this.stage != null); 
		}
		
		private static const info:String = "[{0}] width: {1} , height: {2} , x: {3} , y: {4} , haveParent, {5}, onStage: {6}";
	}
}