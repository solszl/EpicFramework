package com.vhall.framework.log
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class LoggerClip extends Sprite implements ILoggerClip
	{
		/**	内容最大行数*/
		private static var MAX_LINES:Number = 100; //单屏19条，存留3屏
		/**	当前行数*/
		private var curLines:int = 0;
		private var mcOutput:TextField;
		private var closeBtn:TextField;
		private var clearBtn:TextField;

		private var _root:Sprite;
		private var _stage:Stage;

		public function LoggerClip(root:Sprite, stage:Stage = null):void
		{
			this._root = root;
			if(!_stage)
			{
				_stage = root.stage;
			}

			mcOutput = new TextField();

			mcOutput.multiline = true;
			mcOutput.wordWrap = true;

			addChild(mcOutput);

			closeBtn = new TextField;
			closeBtn.autoSize = TextFieldAutoSize.RIGHT;
			closeBtn.htmlText = "<a href='event:link'>关闭</a>";
			closeBtn.mouseEnabled = true;
			var _styleSheet:StyleSheet = new StyleSheet();
			_styleSheet.setStyle("a:hover", {color:"#FFFFFF", textDecoration:"none"});
			_styleSheet.setStyle("a:link", {color:"#ffff00", textDecoration:"none"});
			_styleSheet.setStyle("a:active", {color:"#FF0000", textDecoration:"none"});
			closeBtn.styleSheet = _styleSheet;
			addChild(closeBtn);
			closeBtn.addEventListener(TextEvent.LINK, onClose);

			clearBtn = new TextField();
			clearBtn.autoSize = TextFieldAutoSize.RIGHT;
			clearBtn.htmlText = "<a href='event:link'>清空</a>";
			closeBtn.mouseEnabled = true;
			clearBtn.styleSheet = _styleSheet;
			addChild(clearBtn);
			clearBtn.addEventListener(TextEvent.LINK, clearOutput);
		}

		private function onClose(e:TextEvent):void
		{
			toggle();
		}

		public function toggle():void
		{
			if(this.parent)
			{
				parent.removeChild(this);
				_stage.removeEventListener(Event.RESIZE, onStageResize);
			}
			else
			{
				_stage.addChild(this);
				_stage.addEventListener(Event.RESIZE, onStageResize);
				onStageResize();
			}
		}

		public function output(msg:String):void
		{
			if(this.curLines > MAX_LINES)
			{
				clearOutput();
			}
			this.curLines++;
			var today_date:Date = new Date();
			var date_str:String = today_date.getHours() + ":" + today_date.getMinutes() + ":" + today_date.getSeconds();
			this.mcOutput.htmlText += "</br><font color='#FFFFFF'>" + date_str + " " + msg + "</font>";
			this.mcOutput.scrollV = this.mcOutput.maxScrollV;
		}

		public function clearOutput(e:Event = null):void
		{
			this.mcOutput.text = "";
			this.curLines = 0;
			this.mcOutput.scrollV = this.mcOutput.maxScrollV;
		}

		private function onStageResize(e:Event = null):void
		{
			updateDisplay();
		}

		private function updateDisplay():void
		{
			graphics.clear();
			graphics.lineStyle(2, 0);
			graphics.beginFill(0, .6);
			graphics.drawRoundRect(0, 0, _stage.stageWidth, _stage.stageHeight, 5);
			graphics.endFill();

			mcOutput.width = _stage.stageWidth - 20;
			mcOutput.height = _stage.stageHeight - 20;
			mcOutput.x = (_stage.stageWidth - mcOutput.width) >> 1;
			mcOutput.y = (_stage.stageHeight - mcOutput.height) >> 1;

			closeBtn.x = mcOutput.width - closeBtn.textWidth;
			closeBtn.y = 5;

			clearBtn.x = closeBtn.x - clearBtn.textWidth - 10;
			clearBtn.y = 5;

			x = (_stage.stageWidth - this.width) >> 1;
			y = (_stage.stageHeight - this.height) >> 1;
		}
	}
}
