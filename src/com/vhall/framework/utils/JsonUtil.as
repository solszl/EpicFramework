/**
 * ===================================
 * Author:	iDzeir					
 * Email:	qiyanlong@wozine.com	
 * Company:	http://www.vhall.com		
 * Created:	Jun 1, 2016 4:27:21 PM
 * ===================================
 */

package com.vhall.framework.utils
{
	import com.adobe.serialization.json.JSON;
	
	import org.mangui.hls.utils.Log;
	
	public class JsonUtil
	{
		public static function encode(value:Object):String
		{
			try{
				var s:String = com.adobe.serialization.json.JSON.encode(value);
			}catch(e:Error){
				CONFIG::LOGGING{
					Log.warn("JsonError:"+e.message);
				}
			}
			return s;
		}
		
		public static function decode(value:String):*
		{
			try{
				var o:String = com.adobe.serialization.json.JSON.decode(value);
			}catch(e:Error){
				CONFIG::LOGGING{
					Log.warn("JsonError:"+e.message);
				}
			}
			return o;
		}
	}
}