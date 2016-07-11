package com.vhall.framework.ui.controls
{
	import com.vhall.framework.app.manager.RenderManager;
	import com.vhall.framework.load.ResourceItems;
	import com.vhall.framework.load.ResourceLibrary;
	import com.vhall.framework.load.ResourceLoader;
	import com.vhall.framework.ui.utils.ComponentUtils;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

	/**
	 * 图像组件
	 * @author Sol
	 * @date 2016-05-10
	 */
	public class Image extends UIComponent
	{
		private var _source:Object;

		/**	九宫格矩形*/
		private var _rect:Rectangle;
		/**	是否使用九宫格*/
		private var _useScale9Rect:Boolean;

		private var bitmap:Bitmap;

		private var _w:Number;
		private var _h:Number;

		public var setBitmapDataCallBK:Function = null;

		public function Image(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
		}

		override protected function createChildren():void
		{
			super.createChildren();
			bitmap = new Bitmap();
			addChildAt(bitmap, 0);
		}

		/**
		 *	九宫格的矩形
		 * @param value
		 *
		 */
		public function set rect(value:Rectangle):void
		{
			if(value && this.rect != null && this.rect.equals(value))
			{
				return;
			}

			this._rect = value;
			this._useScale9Rect = value != null;

			RenderManager.getInstance().invalidate(invalidate);
		}

		public function get rect():Rectangle
		{
			return this._rect;
		}

		override public function set width(value:Number):void
		{
			super.width = value;
			_w = value;
		}

		override public function set height(value:Number):void
		{
			super.height = value;
			_h = value;
		}

		override public function setSize(w:Number, h:Number):void
		{
			super.setSize(w, h);
			_w = w;
			_h = h;
		}

		/**	图像源*/
		public function get source():Object
		{
			return _source;
		}

		/**
		 * @private
		 */
		public function set source(value:Object):void
		{
			if(_source == value)
			{
				return;
			}

			_source = value;
			graphics.clear();
			bitmap.bitmapData = null;

			if(value is String)
			{
				// 从作用域内实例化或者从外部加载
				fillBySring(value as String);
			}
			else if(value is Class)
			{
				// 实例化过后，获取该类的显示对象
				fillByClass(value as Class);
			}
			else if(value is BitmapData)
			{
				//直接将该数据复制
				fillByBitmapdata(value as BitmapData);
			}
			else if(value is DisplayObject)
			{
				fillByBitmapdata(ComponentUtils.getDisplayBmd(value as DisplayObject));

			}
			else
			{
				// WTF?
			}
		}

		/**根据字符串去加载图片，获取bmd 填充给bitmap，2种方式
		 * <li/> 1：字符串为导出类，并且已经加载到当前作用域内
		 * <li/> 2：字符串为URL地址，需要加载回调显示
		 **/
		private function fillBySring(value:String):void
		{
			if(value.indexOf("assets/") == 0)
			{
				setBitmapData(ResourceLibrary.getBitmapData(String(value)));
				if(bitmap.bitmapData == null)
				{
					failed(null, "");
					return;
				}
				resizeIfNeed();
			}
			else
			{
				if(ResourceItems.hasLoaded(value))
				{
					setBitmapData(ResourceItems.getResource(value).bitmapData);

					if(bitmap.bitmapData == null)
					{
						failed(null, "");
						return;
					}
					resizeIfNeed();
				}
				else
				{
					var loader:ResourceLoader = new ResourceLoader();
					var item:Object = {type:2, url:value};
					loader.load(item, complete, null, failed)
				}
			}
		}

		/** 实例化一个显示对象类并获取其显示数据填充给bitmap*/
		private function fillByClass(value:Class):void
		{
			var bmd:BitmapData;
			if(getQualifiedSuperclassName(value) == getQualifiedClassName(BitmapData))
			{
				bmd = new value(1, 1);
			}
			else
			{
				bmd = Bitmap(new value()).bitmapData;
			}
			bitmap.bitmapData = bmd;
		}

		/**	将给定的bitmapdata 填充到bitmap*/
		private function fillByBitmapdata(value:BitmapData):void
		{
			bitmap.bitmapData = value;
		}

		private function complete(item:Object, content:Object, domain:ApplicationDomain):void
		{
			if(source != item.url)
			{
				return;
			}
			var bmd:BitmapData = (content as Bitmap).bitmapData;

			setBitmapData(bmd);
			_w = bmd.width;
			_h = bmd.height;
			resizeIfNeed();
			ResourceItems.addToCache(item.url, content as DisplayObject);
		}

		private function failed(item:Object, msg:String):void
		{
			graphics.clear();
			graphics.beginFill(0x00DEFF, 0.3);
			graphics.drawRect(0, 0, 5, 5);
			graphics.endFill();
			trace(msg);
		}

		/**
		 * @private 根据_w,_h 判断是否需要重新计算宽高
		 *
		 */
		private function resizeIfNeed():void
		{
			var sizeChange:Boolean = false;
			if(isNaN(_w))
			{
				_w = bitmap.bitmapData.width;
				sizeChange = true;
			}

			if(isNaN(_h))
			{
				_h = bitmap.bitmapData.height;
				sizeChange = true;
			}

			if(sizeChange && (!isNaN(_w) && !isNaN(_h)))
			{
				RenderManager.getInstance().invalidate(invalidate);
			}
		}

		private function setBitmapData(bmd:BitmapData):void
		{
			bitmap.bitmapData = bmd;
			RenderManager.getInstance().invalidate(invalidate);
			if(setBitmapDataCallBK == null)
			{
				return;
			}

			setBitmapDataCallBK();
		}

		override protected function sizeChanged():void
		{
			super.sizeChanged();

			if(_w == 0 || _h == 0)
			{
				return;
			}

			if(_useScale9Rect)
			{
				resizeBitmap(_w, _h);
			}
			else
			{
				bitmap.width = _w;
				bitmap.height = _h;
			}

			width = bitmap.width;
			height = bitmap.height;
		}

		/**
		 * 计算九宫格或者三宫格
		 * @param w
		 * @param h
		 *
		 */
		protected function resizeBitmap(w:Number, h:Number):void
		{
			if(isNaN(w) || isNaN(h))
			{
				return;
			}

			if(bitmap.width == w && bitmap.height == h)
			{
				return;
			}

			if(w < (rect.width +rect.x + 1) || h < (rect.height +rect.y + 1)){
				return;
			}

			var m:Matrix = new Matrix();
			var result:BitmapData = new BitmapData(w, h, true, 0x000000);
			var origin:Rectangle;
			var draw:Rectangle;
			var rows:Array = [0, rect.top, rect.bottom, bitmap.height];
			var cols:Array = [0, rect.left, rect.right, bitmap.width];
			var newRows:Array = [0, rect.top, h - (bitmap.height - rect.bottom), h];
			var newCols:Array = [0, rect.left, w - (bitmap.width - rect.right), w];
			for(var cx:int = 0; cx < 3; cx++)
			{
				for(var cy:int = 0; cy < 3; cy++)
				{
					origin = new Rectangle(cols[cx], rows[cy], cols[cx + 1] - cols[cx], rows[cy + 1] - rows[cy]);
					draw = new Rectangle(newCols[cx], newRows[cy], newCols[cx + 1] - newCols[cx], newRows[cy + 1] - newRows[cy]);
					m.identity();
					m.a = draw.width / origin.width;
					m.d = draw.height / origin.height;
					m.tx = draw.x - origin.x * m.a;
					m.ty = draw.y - origin.y * m.d;
					result.draw(bitmap, m, null, null, draw, true);
				}
			}

			bitmap.bitmapData = result;
		}
	}
}


