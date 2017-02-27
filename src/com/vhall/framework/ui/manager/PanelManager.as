package com.vhall.framework.ui.manager
{
	import com.vhall.framework.log.Logger;
	import com.vhall.framework.ui.panel.IPanel;

	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;

	/**
	 *	面板管理器
	 * @author Sol
	 * @2016-07-26 16:06:02
	 */
	public class PanelManager
	{

		private static var _instance:PanelManager;

		public static function getInstance():PanelManager
		{
			if(!_instance)
			{
				_instance = new PanelManager();
			}

			return _instance;
		}

		public function PanelManager()
		{
			if(_instance)
			{
				throw new IllegalOperationError("PanelManager is singlton");
			}

			_instance = this;
			panelMap = new Dictionary();
			openMap = new Dictionary();
		}

		public var panelMap:Dictionary;

		public var openMap:Dictionary;

		/**
		 * 打开一个面板
		 * @param id
		 * @param args
		 *
		 */
		public function show(id:int, ... args):void
		{
			if(id < 0)
			{
				return;
			}

			// 关闭已打开的
			for(var key:* in openMap)
			{
				// 如果非互斥
				if(IPanel(openMap[key]).isMutex == false)
				{
					continue;
				}

				hide(key);
			}

			var p:IPanel = getPanel(id);

			if(p == null)
			{
				Logger.getLogger("Panel").info("can't open panel, id:", id);
				return;
			}

			p.show.apply(null, args);
			openMap[id] = p;
		}

		/**
		 * 关闭一个面板
		 * @param id
		 *
		 */
		public function hide(id:int):void
		{
			if(id in openMap)
			{
				IPanel(openMap[id]).hide();
				delete openMap[id];
			}
		}

		/**
		 * 关闭所有面板
		 *
		 */
		public function closeAll():void
		{
			for(var id:* in openMap)
			{
				hide(id);
			}
		}

		public function registPanel(id:int, panel:*):void
		{
			panelMap[id] = panel;
		}

		/**	根据PanelType 找到相对应的面板类*/
		private function getPanel(id:int):*
		{
			if(panelMap[id] != null)
			{
				var p:* = panelMap[id];

				if(p is Class)
				{
					p = new p();
					panelMap[id] = p;
				}

				if(p is IPanel)
				{
					IPanel(p).id = id;
				}

				return p;
			}

			return null;
		}

		public function togglePanel(id:int):void
		{
			var p:IPanel = getPanel(id);
			if(!p)
				return;

			// 打开就关上，关上就打开
			p.isOpen ? hide(id) : show(id);
		}
	}
}
