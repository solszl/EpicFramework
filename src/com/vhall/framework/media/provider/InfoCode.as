/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.vhall.com		
 * Created:	May 10, 2016 4:31:04 PM	
 * ===================================
 */

package com.vhall.framework.media.provider
{
	
	
	public class InfoCode
	{
		/** The connection attempt succeeded.*/
		public static const NetConnection_Connect_Success:String = "NetConnection.Connect.Success";
		
		/** The connection was closed successfully.*/
		public static const NetConnection_Connect_Closed:String = "NetConnection.Connect.Closed";
		
		/** The connection attempt failed.*/
		public static const NetConnection_Connect_Failed:String = "NetConnection.Connect.Failed";
		
		/** Flash Media Server disconnected the client because the client was idle longer than the configured value for <MaxIdleTime>. On Flash Media Server, <AutoCloseIdleClients> is disabled by default. When enabled, the default timeout value is 3600 seconds (1 hour). For more information, see Close idle connections.*/
		public static const NetConnection_Connect_IdleTimeout:String = "NetConnection.Connect.IdleTimeout";
		
		/** The server-side application is shutting down.*/
		public static const NetConnection_Connect_AppShutDown:String = "NetConnection.Connect.AppShutdown";
		
		/** The application name specified in the call to NetConnection.connect() is invalid.*/
		public static const NetConnection_Connect_InvalidApp:String = "NetConnection.Connect.InvalidApp";
		
		/** Flash Player has detected a network change, for example, a dropped wireless connection, a successful wireless connection,or a network cable loss.Use this event to check for a network interface change. Don't use this event to implement your NetConnection reconnect logic. Use "NetConnection.Connect.Closed" to implement your NetConnection reconnect logic.*/
		public static const NetConnection_Connect_NetworkChange:String = "NetConnection.Connect.NetworkChange";
		
		/** The connection attempt did not have permission to access the application.*/
		public static const NetConnection_Connect_Rejected:String = "NetConnection.Connect.Rejected";
		
		
		//--------------
		
		/** Flash Player is not receiving data quickly enough to fill the buffer. Data flow is interrupted until the buffer refills, at which time a NetStream.Buffer.Full message is sent and the stream begins playing again.*/
		public static const NetStream_Buffer_Empty:String = "NetStream.Buffer.Empty";
		
		/** Data has finished streaming, and the remaining buffer is emptied. Note: Not supported in AIR 3.0 for iOS.*/
		public static const NetStream_Buffer_Flush:String = "NetStream.Buffer.Flush";
		
		/** The buffer is full and the stream begins playing.*/
		public static const NetStream_Buffer_Full:String = "NetStream.Buffer.Full";
		
		/** The stream is paused.*/
		public static const NetStream_Pause_Notify:String = "NetStream.Pause.Notify";
		
		/** An error has occurred in playback for a reason other than those listed elsewhere in this table, such as the subscriber not having read access. Note: Not supported in AIR 3.0 for iOS.*/
		public static const NetStream_Play_Failed:String = "NetStream.Play.Failed";
		
		/** Playback has started.*/
		public static const NetStream_Play_Start:String = "NetStream.Play.Start";
		
		/** Playback has stopped.*/
		public static const NetStream_Play_Stop:String = "NetStream.Play.Stop";
		
		/** The file passed to the NetStream.play() method can't be found.*/
		public static const NetStream_Play_StreamNotFound:String = "NetStream.Play.StreamNotFound";
		
		/** The seek fails, which happens if the stream is not seekable.*/
		public static const NetStream_Seek_Failed:String = "NetStream.Seek.Failed";
		
		/** For video downloaded progressively, the user has tried to seek or play past the end of the video data that has downloaded thus far, or past the end of the video once the entire file has downloaded. The info.details property of the event object contains a time code that indicates the last valid position to which the user can seek.*/
		public static const NetStream_Seek_InvalidTime:String = "NetStream.Seek.InvalidTime";
		
		/** The seek operation is complete.Sent when NetStream.seek() is called on a stream in AS3 NetStream Data Generation Mode. The info object is extended to include info.seekPoint which is the same value passed to NetStream.seek().*/
		public static const NetStream_Seek_Notify:String = "NetStream.Seek.Notify";
		
		public static const NetStream_Seek_Complete:String = "NetStream.Seek.Complete";
		
		/** The stream is resumed.*/
		public static const NetStream_Unpause_Notify:String = "NetStream.Unpause.Notify";
		
		/** The initial publish to a stream is sent to all subscribers. */		
		public static const NetStream_Play_PublishNotify:String = "NetStream.Play.PublishNotify";
		
		/** An unpublish from a stream is sent to all subscribers.*/		
		public static const NetStream_Play_UnpublishNotify:String = "NetStream.Play.UnpublishNotify";
		
		/** Attempt to publish a stream which is already being published by someone else.*/
		public static const NetStream_Publish_BadName:String = "NetStream.Publish.BadName";
		
		/** The publisher of the stream is idle and not transmitting data.*/
		public static const NetStream_Publish_Idle:String = "NetStream.Publish.Idle";
		
		/** Publish was successful.*/		
		public static const NetStream_Publish_Start:String = "NetStream.Publish.Start";
		
		/** The unpublish operation was successfuul. */		
		public static const NetStream_Unpublish_Success:String = "NetStream.Unpublish.Success";
		
		/** The video dimensions are available or have changed. Use the Video or StageVideo videoWidth/videoHeight property to query the new video dimensions. New in Flash Player 11.4/AIR 3.4.*/
		public static const NetStream_Video_DimensionChange:String = "NetStream.Video.DimensionChange";
		
		public static const NetStream_Play_Transition:String = "NetStream.Play.Transition";
	}
}