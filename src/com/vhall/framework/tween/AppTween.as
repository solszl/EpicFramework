package com.vhall.framework.tween
{
	import flash.display.DisplayObject;

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

		public static function repeat(target:DisplayObject, duration:Number, vars:Object, repeatCount:int = 1, callback:Function = null, callbackParams:Array = null):void
		{
			vars.onComplete = innerComplete;
			vars.onCompleteParams = [vars];
			vars.ease = easeNone;
			var tw:TweenNano = new TweenNano(target, duration, vars);

			function innerComplete(params:Object):void
			{
				if(repeatCount == 0)
				{
					callback && callback.apply(null, callbackParams);
					return;
				}

				if(repeatCount > 0)
				{
					repeatCount--;
				}
				vars.onComplete = innerComplete;
				vars.onCompleteParams = [vars];
				vars.ease = easeNone;
				tw = new TweenNano(target, duration, vars);
			}

			function easeNone(t:Number, b:Number, c:Number, d:Number):Number
			{
				return c * t / d + b;
			}
		}
	}
}
