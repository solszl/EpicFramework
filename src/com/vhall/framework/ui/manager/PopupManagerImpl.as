package com.vhall.framework.ui.manager
{
	import com.vhall.framework.app.App;
	import com.vhall.framework.app.vhall_internal;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;

	import flashx.textLayout.events.ModelChange;

	/**
	 * 弹出实现类
	 * @author Sol
	 *
	 */
	internal class PopupManagerImpl
	{
		private static var _instance:PopupManagerImpl;

		private var stage:Stage;

		use namespace vhall_internal;

		private var modal:ModalController;

		private var modalList:Array;

		private var holder:DisplayObjectContainer;

		public function PopupManagerImpl()
		{
			if(_instance)
				throw new Error("PopUpManagerImpl is not allowed instnacing!");

			stage = App.app.stage;
			modal = new ModalController();
			modalList = [];
		}

		public static function getInstance():PopupManagerImpl
		{
			if(!_instance)
			{
				_instance = new PopupManagerImpl();
			}
			return _instance;
		}

		/**
		 * 添加弹出显示对象到显示列表
		 * @param obj 要显示的对象
		 * @param parent 父容器，如果没有，则添加到stage上
		 * @param center 是否居中
		 * @param modal 是否使用模态
		 *
		 */
		public function addPopup(obj:DisplayObject, parent:DisplayObjectContainer = null, center:Boolean = true, modal:Boolean = true):DisplayObject
		{
			if(obj == null)
			{
				return null;
			}

			return vhall_internal::addPopup(obj, parent, center, modal);
		}

		/**
		 * 移除弹出对象
		 * @param obj
		 *
		 */
		public function removePopup(obj:DisplayObject):DisplayObject
		{
//			if(holder && holder.contains(obj))
//			{
//				holder.removeChild(obj);
//			}

			if(obj && obj.parent)
			{
				obj.parent.removeChild(obj);
			}

			var idx:int = modalList.indexOf(obj)
			if(idx > -1)
			{
				modalList.splice(idx, 1);
			}

			if(modalList.length == 0 && modal.modaling)
			{
				App.app.mouseChildren = App.app.mouseEnabled = true;
				modal.removeModal();
			}

			return obj;
		}

		/**
		 * 将显示对象放到所在容器的最上面
		 * @param obj
		 *
		 */
		public function toTop(obj:DisplayObject):DisplayObject
		{
			if(obj.parent)
			{
				obj.parent.setChildIndex(obj, obj.parent.numChildren - 1);
			}
			return obj;
		}

		private function createHolder():DisplayObjectContainer
		{
			holder = new Sprite();
			stage.addChild(holder);
			return holder;
		}

		private function centerDisplayObject(obj:DisplayObject):void
		{
			obj.x = stage.stageWidth - obj.width >> 1;
			obj.y = stage.stageHeight - obj.height >> 1;
		}

		vhall_internal function addPopup(obj:DisplayObject, parent:DisplayObjectContainer = null, center:Boolean = true, useModal:Boolean = true):DisplayObject
		{
			// 判断当前是否有容器承载内容
			holder = parent == null ? holder == null ? createHolder() : holder : parent;

			if(holder.contains(obj))
			{
				return obj;
			}
			// 添加显示对象到容器
			holder.addChild(obj);

			// 是否居中显示
			if(center == true)
			{
				centerDisplayObject(obj);
			}

			// 如果使用模态
			if(useModal == true)
			{
				if(modalList.indexOf(obj) > -1)
				{
					return obj;
				}

				modalList.push(obj);
				App.app.mouseChildren = App.app.mouseEnabled = false;
				modal.setTarget(App.app);
				modal.setModal();
			}

			return obj;
		}
	}
}
