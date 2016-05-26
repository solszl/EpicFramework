package com.vhall.framework.tween
{

	/**
	 *	程序缓动类
	 * @author Sol
	 * @date 2016-05-23
	 */
	public class AppTween
	{
		public static function to(target:Object, duration:Number, vars:Object):void
		{
			new TweenNano(target, duration, vars);
		}

		public static function from(target:Object, duration:Number, vars:Object):void
		{
			TweenNano.from(target, duration, vars);
		}

		public static function delayedCall(delay:Number, callback:Function, params:Array = null, useFrames:Boolean = false):void
		{
			TweenNano.delayedCall(delay, callback, params, useFrames);
		}

		public static function killTweensOf(target:Object):void
		{
			TweenNano.killTweensOf(target);
		}
	}
}
