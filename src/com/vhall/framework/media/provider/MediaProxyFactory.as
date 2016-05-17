/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.vhall.com		
 * Created:	May 16, 2016 11:51:48 AM
 * ===================================
 */

package com.vhall.framework.media.provider
{
	import com.vhall.framework.media.interfaces.IMediaProxy;

	public class MediaProxyFactory
	{
		public static function create(proxyType:String):IMediaProxy
		{
			var proxy:IMediaProxy;
			
			switch(proxyType)
			{
				case MediaProxyType.HLS:
					proxy = new HLSProxy();
					break;
				case MediaProxyType.HTTP:
					proxy = new HttpProxy();
					break;
				case MediaProxyType.PUBLISH:
					proxy = new PublishProxy();
					break;
				case MediaProxyType.RTMP:
					proxy = new RtmpProxy();
					break;
			}
			
			return proxy;
		}
	}
}