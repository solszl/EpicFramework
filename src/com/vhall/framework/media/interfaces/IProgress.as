/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.vhall.com		
 * Created:	May 16, 2016 11:20:23 AM
 * ===================================
 */

package com.vhall.framework.media.interfaces
{
	public interface IProgress
	{
		/**
		 * 回放视频当前已经缓存字节
		 * @return 
		 */		
		function get bytesLoaded():int;
		
		/**
		 * 回放视频总字节
		 * @return 
		 */		
		function get bytesTotal():int;
		
		/**
		 * 当前缓存百分比
		 * @return 
		 */		
		function loaded():Number;
	}
}