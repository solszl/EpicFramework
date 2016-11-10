package com.vhall.framework.ui.layout
{
	import com.vhall.framework.ui.container.Box;

	import flash.display.DisplayObject;

	/**
	 * 网格布局
	 * @author Sol
	 * @date 2016-11-10 18:08:46
	 */
	public class TileLayout extends Layout
	{
		public function TileLayout()
		{
			super();
			type = "TileLayout";
		}

		private var _gapX:Number = 5;

		private var _gapY:Number = 5;

		private var _rowCount:int;

		private var _columnCount:int;

		/**
		 * 优先哪个方向排列布局
		 * horizontal, vertical
		 * @default horizontal
		 */
		public var direction:String = "horizontal";

		override public function doLayout(target:Box):void
		{
			if(!target)
				return;
			this.target = target;
			_measureHeight = _measureWidth = 0;

			switch(direction)
			{
				case "horizontal":
					priorityHorizontalLayout();
					break;
				case "vertical":
					priorityVerticalLayout();
					break;
				default:
					priorityHorizontalLayout();
					break;
			}
		}

		public function get gapX():Number
		{
			return _gapX;
		}

		public function set gapX(value:Number):void
		{
			if(this._gapX == value)
				return;
			_gapX = value;

			if(target)
				doLayout(target);
		}

		public function get gapY():Number
		{
			return _gapY;
		}

		public function set gapY(value:Number):void
		{
			if(this._gapY == value)
				return;
			_gapY = value;

			if(target)
				doLayout(target);
		}

		public function get rowCount():int
		{
			return _rowCount;
		}

		public function set rowCount(value:int):void
		{
			_rowCount = value;

			if(target)
				doLayout(target);
		}

		public function get columnCount():int
		{
			return _columnCount;
		}

		public function set columnCount(value:int):void
		{
			_columnCount = value;

			if(target)
				doLayout(target);
		}

		private function priorityHorizontalLayout():void
		{
			var xpos:Number = 0;
			var ypos:Number = 0;
			var maxH:Number = 0;
			var maxW:Number = 0;
			var c:int;
			var r:int;
			var child:DisplayObject;

			var numChildren:uint = target.numChildren;

			if(_columnCount == -1 && _rowCount == -1)
			{
				_columnCount = int(Math.sqrt(numChildren));
			}
			var totalCount:int = 0;
			_rowCount = Math.ceil(numChildren / _columnCount);

			for(r = 0; r < _rowCount; r++)
			{
				maxH = 0;
				xpos = 0;

				for(c = 0; c < _columnCount; c++)
				{
					if(totalCount < numChildren)
					{
						child = target.getChildAt(totalCount);
						child.x = xpos;
						child.y = ypos;
						xpos += child.width;

						if(_measureWidth < xpos)
						{
							_measureWidth = xpos;
						}
						xpos += _gapX;

						if(child.height > maxH)
						{
							maxH = child.height
						}

						totalCount++;
					}
				}

				ypos += maxH;
				_measureHeight = ypos
				ypos += _gapY;
			}
		}

		private function priorityVerticalLayout():void
		{
			var xpos:Number = 0;
			var ypos:Number = 0;
			var maxH:Number = 0;
			var maxW:Number = 0;
			var c:int;
			var r:int;
			var child:DisplayObject

			var numChildren:uint = target.numChildren;

			if(_columnCount == -1 && _rowCount == -1)
			{
				_columnCount = int(Math.sqrt(numChildren));
			}
			var totalCount:int = 0;
			_columnCount = Math.ceil(numChildren / _rowCount);

			for(c = 0; c < _columnCount; c++)
			{
				maxW = 0;
				ypos = 0;

				for(r = 0; r < _rowCount; r++)
				{
					if(totalCount < numChildren)
					{
						child = target.getChildAt(totalCount);
						child.x = xpos;
						child.y = ypos;
						ypos += child.height;

						if(_measureHeight < ypos)
						{
							_measureHeight = ypos;
						}
						ypos += _gapY;

						if(child.width > maxW)
						{
							maxW = child.width
						}


						totalCount++;
					}
				}

				xpos += maxW;
				_measureWidth = xpos
				xpos += _gapX;
			}
		}
	}
}
