package com.vhall.framework.load
{

	/**
	 * 加载策略接口
	 * @author Sol
	 * @date 2016-05-10
	 */
	internal interface ILoadStrategy
	{
		/**
		 * 加载函数，需要注意的是 item 数据格式至少有以下2个参数，1：type, 2:url 这俩个参数构成加载文件的文件信息。
		 * @param item {type:1|2|3|4|5,url:"abc.xyz"} 1：swf，2：图片（jpg，png等），3：文本（xml，text），4：压缩的二进制，5：未压缩的二进制，-1：位置文件压缩类型
		 * @param onComplete
		 * @param onProgress
		 * @param onFailed
		 *
		 */		
		function load(item:Object, onComplete:Function = null, onProgress:Function = null, onFailed:Function = null):void;
		
		/**
		 * 析构 
		 * 
		 */		
		function deinitLoader():void;
		
		/**
		 *	是否正在加载 
		 * @return 
		 * 
		 */		
		function get isLoading():Boolean;
		
		/**
		 *	是否将加载进来的数据进行缓存 
		 * @return 
		 * 
		 */		
		function get cache():Boolean;
		
		function set cache(value:Boolean):void;
	}
}
