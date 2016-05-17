/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.vhall.com		
 * Created:	May 16, 2016 11:24:04 AM
 * ===================================
 */

package com.vhall.framework.media.provider
{
	/**
	 * 播放器或者代理类型
	 */	
	public class MediaProxyType
	{
		/**
		 * hls视频回放 
		 */		
		public static const HLS:String = "hls";
		
		/**
		 * rtmp直播或者回放类型 
		 */		
		public static const RTMP:String = "rtmp";
		
		/**
		 * rtmp推流 
		 */		
		public static const PUBLISH:String = "publish";
		
		/**
		 * http或者本地视频 
		 */		
		public static const HTTP:String = "http";
	}
}