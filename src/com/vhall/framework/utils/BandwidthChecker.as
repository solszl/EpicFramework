package com.vhall.framework.utils
{
	import com.vhall.framework.log.Logger;
	import com.vhall.framework.tween.AppTween;

	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * 带宽检测
	 * @author Sol
	 * @date 2017-02-14 11:35:10
	 */
	public class BandwidthChecker extends EventDispatcher
	{
		public static const TEST_COMPLETE:String = "bandwidth.checker.complete";
		/**	加载器，用这个东西来加载资源进行测速*/
		private var loader:Loader;
		/** 测试文件链接*/
		private var url:String;
		private var timer:Timer;

		/**	解析DNS耗时*/
		private var resolveDNS:Number = 0;
		private var tempResolveDNS:Number = 0;

		/**	采样间隔*/
		public var samplingDelay:int = 100;
		/**	采样次数*/
		public var samplingCount:int = 5;

		/**	修正参数*/
		public var magicNumber:Number = 2;

		public var bindwidth:Number = 0;

		public function BandwidthChecker()
		{
			super(null);
		}

		/**
		 * 开始进行测速
		 * @param url 测试链接
		 *
		 */
		public function start(url:String):void
		{
			dispose();
			this.url = url + "?v=" + Math.random().toFixed(2);
			createLoader();
			createTimer();
			startLoad();
		}

		private function createLoader():void
		{
			if(loader == null)
			{
				loader = new Loader();
			}
			loader.contentLoaderInfo.addEventListener(Event.OPEN, loaderOpenHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loaderProgressHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
		}

		private function createTimer():void
		{
			timer = new Timer(samplingDelay, samplingCount);
			timer.addEventListener(TimerEvent.TIMER, onTimerCheck);
		}

		private function loaderOpenHandler(e:Event):void
		{
			resolveDNS = getTimer() - tempResolveDNS;
			trace("open，解析DNS耗时", resolveDNS);
			timer.start();
		}

		private function loaderCompleteHandler(e:Event):void
		{
			var loadCost:Number = getTimer() - startReceived;
			var total:Number = loader.contentLoaderInfo.bytesTotal;
			var calcSpeed:Number = total / 1024 / loadCost * 1000;
			bindwidth = calcSpeed;
			trace("加载耗时：", loadCost, "测算速度：", calcSpeed);
			trace("complete");
			dispatchEvent(new Event(TEST_COMPLETE));
		}

		private function loaderIOErrorHandler(e:IOErrorEvent):void
		{
			trace("ioerror");
			Logger.getLogger().info("IOError, 加载文件出错，设置默认带宽100Kb,错误url：", this.url);
			bindwidth = 100;
			dispatchEvent(new Event(TEST_COMPLETE));
		}

		private var startReceived:Number = 0;

		private function loaderProgressHandler(e:ProgressEvent):void
		{
			if(startReceived != 0)
			{
				return;
			}

			startReceived = getTimer();
		}

		private var totalLoad:Number = 0;
		private var result:Array = [];

		private function onTimerCheck(e:TimerEvent = null):void
		{
			var loaded:Number = loader.contentLoaderInfo.bytesLoaded;
			var total:Number = loader.contentLoaderInfo.bytesTotal;
			var speed:Number = loaded / timer.currentCount / 1024 * 1000 / timer.delay;

			trace("已加载：", loaded, "共：", total, "次数：", timer.currentCount, "实时速度：", speed);
			result.push(speed);
			if(timer.currentCount == timer.repeatCount)
			{
				bindwidth = ArrayUtil.average(result) / magicNumber;
				dispatchEvent(new Event(TEST_COMPLETE));
			}
		}

		private function startLoad():void
		{
			var req:URLRequest = new URLRequest();
			req.url = this.url;
			loader.load(req);
			tempResolveDNS = getTimer();
		}

		/**	清理所有的加载器，计时器，相关参数*/
		public function dispose():void
		{
			if(loader)
			{
				loader.contentLoaderInfo.removeEventListener(Event.OPEN, loaderOpenHandler);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loaderProgressHandler);
				try
				{
					loader.close();
					loader.unloadAndStop();
				}
				catch(e:Error)
				{
				}

				loader = null;
			}

			if(timer)
			{
				timer.reset();
				timer.removeEventListener(TimerEvent.TIMER, onTimerCheck);
				timer = null;
			}

			totalLoad = 0;
			tempResolveDNS = 0;
			resolveDNS = 0;
			bindwidth = 0;
			startReceived = 0;
		}
	}
}
