package com.vhall.framework.app.manager
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;

	/**
	 *	整个的舞台管理类
	 * @author Sol
	 */
	public class StageManager extends EventDispatcher
	{
		public static var stage:Stage;

		public static var root:Sprite;

		public static function init(root:Sprite):void
		{
			StageManager.root = root;
			StageManager.root.blendMode = BlendMode.NORMAL;
			StageManager.root.tabEnabled = false;
			StageManager.root.tabChildren = false;
			StageManager.stage = root.stage;
			StageManager.stage.scaleMode = StageScaleMode.NO_SCALE;
			StageManager.stage.align = StageAlign.TOP_LEFT;
			StageManager.stage.quality = StageQuality.HIGH;

			if(ApplicationDomain.currentDomain.hasDefinition("flash.evnets.UncaughtErrorEvent"))
			{
				StageManager.stage.loaderInfo["uncaughtErrorEvents"].addEventListener(ApplicationDomain.currentDomain.hasDefinition("flash.evnets.UncaughtErrorEvent")["UNCAUGHT_ERROR"], onUncaughtErrorHandler);
			}
		}

		/**
		 * 返回舞台宽度
		 * @return
		 *
		 */
		public static function get stageWidth():Number
		{
			if(stage)
				return stage.stageWidth;

			return 0;
		}

		/**
		 *	返回舞台高度
		 * @return
		 *
		 */
		public static function get stageHeight():Number
		{
			if(stage)
				return stage.stageHeight;

			return 0;
		}

		/**
		 *	监听一些未捕获的异常
		 * @param event
		 *
		 */
		private static function onUncaughtErrorHandler(event:*):void
		{
			var msg:String = event.error.getStackTrace();
			if(!msg)
			{
				if(event.error is Error)
				{
					msg = Error(event.error).message;
				}
				else if(event.error is flash.events.ErrorEvent)
				{
					msg = flash.events.ErrorEvent(event.error).text;
				}
				else
				{
					msg = event.error.toString();
				}
			}

			var content:String = "【Error】:\n It's probably a bug, please contact Sol::<a herf ='mailto:zhenliang.sun@vhall.com'</a>" + msg;
			trace(content);
		}

		public static function toggleFullscreen(e:MouseEvent = null):void
		{
			stage.displayState = stage.displayState == StageDisplayState.NORMAL ? StageDisplayState.FULL_SCREEN : StageDisplayState.NORMAL;
		}

		public static function perpareCheckObjectsUnderPoint():void
		{
			var arr:Array = [];
			stage.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				arr = [];
				var p:Point = new Point(e.stageX, e.stageY);
				check(stage, p, arr);
				trace(arr.join(","));
			});
		}

		private static function check(obj:DisplayObject, pt:Point, arr:Array):void
		{
			if(!obj.visible)
				return;
			if(obj is Stage || obj.hitTestPoint(pt.x, pt.y, true))
			{
				if(obj is InteractiveObject && InteractiveObject(obj).mouseEnabled)
					arr.push(obj);
				if(obj is DisplayObjectContainer)
				{
					var doc:DisplayObjectContainer = obj as DisplayObjectContainer;
					if(doc.mouseChildren && doc.numChildren)
					{
						var n:int = doc.numChildren;
						for(var i:int = 0; i < n; i++)
						{
							try
							{
								var child:DisplayObject = doc.getChildAt(i);
								check(child, pt, arr);
							}
							catch(e:Error)
							{
								//another sandbox?
							}
						}
					}
				}
			}
		}
	}
}
