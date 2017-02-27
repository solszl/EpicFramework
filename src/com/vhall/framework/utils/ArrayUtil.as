package com.vhall.framework.utils
{

	/**
	 * 数组工具类
	 * @author Sol
	 *
	 */
	public class ArrayUtil
	{
		/**
		 * 取出数组中最小的
		 * @param arr
		 * @return
		 *
		 */
		public static function min(arr:Array):Number
		{
			return arr.sort(Array.NUMERIC)[0];
		}

		/**
		 * 取出数组中最大的
		 * @param arr
		 * @return
		 *
		 */
		public static function max(arr:Array):Number
		{
			return arr.sort(Array.NUMERIC).reverse()[0];
		}

		/**
		 * 数组求和
		 * @param arr
		 * @return
		 *
		 */
		public static function sum(arr:Array):Number
		{
			var result:Number = 0;
			arr.forEach(function(item:*, index:int, arr:Array):void
			{
				result += item;
			});
			return result;
		}

		/**	数组求平均数*/
		public static function average(arr:Array):Number
		{
			return sum(arr) / arr.length;
		}
	}
}
