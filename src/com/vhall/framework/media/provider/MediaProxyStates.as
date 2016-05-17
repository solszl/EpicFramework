/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.vhall.com		
 * Created:	May 16, 2016 11:32:08 AM
 * ===================================
 */

package com.vhall.framework.media.provider
{
	public class MediaProxyStates
	{
		public static const CONNECT_NOTIFY:String = "connectNotify";
		
		public static const CONNECT_FAILED:String = "connectFailed";
		
		public static const SEEK_NOTIFY:String = "seekNotify";
		
		public static const SEEK_FAILED:String = "seekFailed";
		
		public static const PUBLISH_NOTIFY:String = "publishNotify";
		
		public static const UN_PUBLISH_NOTIFY:String = "unPublishNotify";
		
		public static const PUBLISH_BAD_NAME:String = "publishBadName";
		
		public static const UN_PUBLISH_SUCCESS:String = "unPublishSuccess";
		
		public static const DURATION_NOTIFY:String = "durationUpdate";
		
		public static const STREAM_SIZE_NOTIFY:String = "streamSizeNotify";
		
		public static const STREAM_PLAYING:String = "streamPlay";
		
		public static const STREAM_LOADING:String = "streamLoading";
		
		public static const STREAM_START:String = "streamStart";
		
		public static const STREAM_STOP:String = "streamStop";
		
		public static const STREAM_NOT_FOUND:String = "streamNotFound";
		
	}
}