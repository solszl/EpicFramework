package com.vhall.framework.load
{

	/**
	 *
	 * @author Sol
	 * @date 2016-05-10
	 */
	public class ResourceLoader
	{
		// 加载器上下文，负责具体加载
		private var context:Context;
		// 是否启用缓存
		private var useCache:Boolean;
		// 当前加载项
		private var currentItem:Object;

		public function ResourceLoader()
		{
			context = new Context();
		}

		/**
		 * 加载函数，需要注意的是 item数据格式至少有以下2个参数，1：type, 2:url 这俩个参数构成加载文件的文件信息。
		 * @param item {type:1|2|3|4|5,url:"abc.xyz"} 1：swf，2：图片（jpg，png等），3：文本（xml，text），4：压缩的二进制，5：未压缩的二进制，-1：位置文件压缩类型
		 * @param onComplete
		 * @param onProgress
		 * @param onFailed
		 * @param useCache
		 *
		 */
		public function load(item:Object, onComplete:Function = null, onProgress:Function = null, onFailed:Function = null, useCache:Boolean = true):void
		{
			// 如果当前加载器正在加载，则不继续进行加载
			if (context.isLoading)
			{
				return;
			}

			this.useCache = useCache;

			//检测缓存是否有

			context.loadItem = item;
			// 设置回调函数
			context.completeBK = onComplete;
			context.progressBK = onProgress;
			context.failedBK = onFailed;
			switch (item.type)
			{
				case 1:
					context.strategy = new LoaderStrategy();
					break;
				case 2:
				case 3:
				case 4:
				case 5:
					context.strategy = new URLLoaderStrategy();
					break;
				default:
					context.strategy = new LoaderStrategy();
					break;
			}
			context.strategy.cache = this.useCache;
			context.load();
		}
	}
}
