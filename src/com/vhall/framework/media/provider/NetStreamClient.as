package com.vhall.framework.media.provider
{

	/**
	 * 为NetStream和NetConnection类的实例提供client属性，不执行任何具体工作，只是为了方便有这么一个对象
	 */
	public class NetStreamClient extends Object
	{
		public function NetStreamClient()
		{
		}

		public function onBWDone(... value):void
		{
		}

		public function onBWCheck(value:*):Number
		{
			return 0;
		}

		public function onMetaData(info:Object):void
		{
		}

		public function onCuePoint(info:Object):void
		{
		}

		public function onXMPData(info:Object):void
		{
		}
	}
}
