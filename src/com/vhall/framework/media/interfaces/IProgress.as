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
		function get bytesLoaded():int;
		
		function get bytesTotal():int;
		
		function loaded():Number;
	}
}