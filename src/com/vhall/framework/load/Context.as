package com.vhall.framework.load
{
	/**
	 * 加载策略上下文 
	 * @author Sol
	 * @date 2016-05-10
	 */	
	internal class Context
	{
		private var _strategy:ILoadStrategy;
		
		private var _isLoading:Boolean = false;
		
		public var loadItem:Object;
		
		// 加载完成的回调函数
		public var completeBK:Function;
		// 加载进行中回调函数
		public var progressBK:Function;
		// 加载失败回调函数
		public var failedBK:Function
		
		public function Context()
		{
		}
		
		/**	文件加载策略*/
		public function get strategy():ILoadStrategy
		{
			return _strategy;
		}
		
		public function get isLoading():Boolean
		{
			if(_strategy == null)
			{
				return false;
			}
			
			return _strategy.isLoading;
		}

		/**
		 * @private
		 */
		public function set strategy(value:ILoadStrategy):void
		{
			_strategy = value;
		}

		public function load():void
		{
			if(_strategy == null)
			{
				throw new Error("strategy is null");
			}
			
			_strategy.load(loadItem,completeBK,progressBK,failedBK);
		}
	}
}