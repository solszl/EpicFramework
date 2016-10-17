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

	/** 代理外发状态码*/
	public class MediaProxyStates
	{
		/**	通道链接成功，stream创建完成派发*/
		public static const CONNECT_NOTIFY:String = "connectNotify";

		/** 通道创建失败，可选参数为失败状态码*/
		public static const CONNECT_FAILED:String = "connectFailed";
		/**
		 *因为长时间empty 所以进行切线处理
		 */
		public static const STREAM_EMPTY_4CHANGELINE:String = "stream_empty_4changeline";

		/**
		 *因为长时间没连接上 所以进行切线处理
		 */
		public static const STREAM_CONN_TIMEOUT:String = "stream_conn_timeout";

		/** seek通知，禁止操作*/
		public static const SEEK_NOTIFY:String = "seekNotify";

		/** seek跳转失败*/
		public static const SEEK_FAILED:String = "seekFailed";

		/** seek完成*/
		public static const SEEK_COMPLETE:String = "seekComplete";

		/** 推流开始直播端*/
		public static const PUBLISH_START:String = "publishStart";

		/** 推流通知*/
		public static const PUBLISH_NOTIFY:String = "publishNotify";

		/** 停止推流通知*/
		public static const UN_PUBLISH_NOTIFY:String = "unPublishNotify";

		/** 服务器已经存在推流名称*/
		public static const PUBLISH_BAD_NAME:String = "publishBadName";

		/** 停止推流成功*/
		public static const UN_PUBLISH_SUCCESS:String = "unPublishSuccess";

		/** 视频时长通知*/
		public static const DURATION_NOTIFY:String = "durationUpdate";

		/** 视频流宽高尺寸改变通知*/
		public static const STREAM_SIZE_NOTIFY:String = "streamSizeNotify";

		/** 视频缓冲区满通知*/
		public static const STREAM_FULL:String = "streamFull";

		/** 视频填充缓冲区通知*/
		public static const STREAM_LOADING:String = "streamLoading";

		/** 开始播放通知,之后可以seek*/
		public static const STREAM_START:String = "streamStart";

		/** 播放结束通知*/
		public static const STREAM_STOP:String = "streamStop";

		/** 视频流暂停通知*/
		public static const STREAM_PAUSE:String = "streamPause";

		/** 视频流暂停恢复*/
		public static const STREAM_UNPAUSE:String = "streamUnpause";

		/** 未找到指定名称的流文件*/
		public static const STREAM_NOT_FOUND:String = "streamNotFound";

		public static const STREAM_TRANSITION:String = "streamTransition";

		/** 未找到硬件设备,参数为字符串说明 */
		public static const NO_HARD_WARE:String = "noHardWare";

		/** 推流摄像头被占用请检查设备*/
		public static const CAMERA_IS_USING:String = "cameraIsUsing";

		/** 出错，参数为错误说明*/
		public static const PROXY_ERROR:String = "proxyError";
	}
}

