package com.vhall.framework.app.manager
{
	import com.vhall.framework.log.Logger;
	
	import flash.errors.IllegalOperationError;
	import flash.net.SharedObject;

	/**
	 * 本地存储管理类
	 * @author Sol
	 *
	 */
	public class SOManager
	{

		private static var _instance:SOManager;

		/**	本地存储对象*/
		private var so:SharedObject;

		private static var _name:String;

		private var invalid:Boolean = false;

		public static function getInstance(name:String = "setting"):SOManager
		{
			_name = name;
			if (_instance == null)
			{
				_instance = new SOManager();
			}
			return _instance;
		}

		public function SOManager()
		{

			if (_instance)
			{
				throw new IllegalOperationError("SOManager is singlton");
			}

			_instance = this;

			so = SharedObject.getLocal(_name, "/");
		}

		/**
		 *	返回一个非空的数据
		 * @param key
		 * @return
		 *
		 */
		public function getValue(key:String):Object
		{
			var obj:Object = so.data[key];
			return obj == null ? {} : obj;
		}

		public function setValue(key:String, value:Object):void
		{
			so.data[key] = value;
			invalid = true;
			invalidData();
		}

		/**
		 *	当前shareobject是否为空
		 * @return
		 *
		 */
		public function isEmpty():Boolean
		{
			if (so == null)
			{
				return true;
			}

			return so.size == 0;
		}

		private function invalidData():void
		{
			if (invalid == false)
			{
				return;
			}

			invalid = false;
			// 最后写入一个时间戳
			var strDate:String = (new Date()).time.toString();
			var len:int = strDate.length;
			so.data["lastupdate"] = strDate.substr(0, len - 3);
			so.flush();
			Logger.getLogger().info("write so over!");
		}


	/**
	 * vo extends Object
	 *
	 * 默认视频名称
	 * cameraName:String;
	 * 默认音频名称
	 * micName:String;
	 * 默认线路
	 * serverLine:String;
	 * 默认比例
	 * ratio:String;
	 * 默认清晰度
	 * definition:String;
	 * 自定义宽度
	 * width:int;
	 * 自定义高度
	 * height:int;
	 */
	}
}
