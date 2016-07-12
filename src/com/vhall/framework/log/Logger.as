package com.vhall.framework.log
{
	import com.vhall.framework.utils.StringUtil;

	public class Logger
	{
		private var category:String = "ROOT";
		private static var loggers:Array = [];
		public static var mcOutputClip:ILoggerClip;

		public static function getLogger(category:String = "ROOT"):Logger
		{
			var logger:Logger
			category = "["+category.toLowerCase()+"]";
			var length:Number = Logger.loggers.length;
			for(var i:Number = 0; i < length; i++)
			{
				logger = Logger.loggers[i];
				if(logger.category == category)
				{
					return logger;
				}
			}

			logger = new Logger(category);
			Logger.loggers.push(logger);

			return logger;
		}

		public function Logger(category:String)
		{
			this.category = category;
		}

		public function info(... arg):void
		{
			output(o(arg.join(",")));
		}

		public function toggle():void
		{
			mcOutputClip.toggle();
		}

		private function o(message:String):String
		{
			var msg:String = "{1} {0}";
			return StringUtil.substitute(msg, message, this.category.toUpperCase());
		}

		private function output(message:String):void
		{
			if(mcOutputClip != null)
			{
				mcOutputClip.output(message);
			}
			else
			{
				trace(message);
			}
		}
	}
}


