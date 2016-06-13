package com.vhall.framework.ui.manager
{
	import com.vhall.framework.app.manager.StageManager;
	import com.vhall.framework.ui.controls.ToolTip;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 * tooltip管理类的实现
	 * @author Sol
	 * @date 2016-05-26
	 */
	public class TooltipManagerImpl
	{
		private static var instance:TooltipManagerImpl;

		// 所有含有tips的对象的字典
		private static var targetMap:Dictionary;

		private var stage:Stage;
		// 承载tips的容器
		private var holder:Sprite;

		public static function getInstance():TooltipManagerImpl
		{
			if (!instance)
			{
				instance = new TooltipManagerImpl();
			}

			return instance;
		}

		public function TooltipManagerImpl()
		{
			if (instance)
			{
				throw new IllegalOperationError("TooltipManagerImpl is singlton");
			}

			instance = this;
			targetMap = new Dictionary(true);
			stage = StageManager.stage;
			holder = new Sprite();
			tipsPool = [];
		}

		// tips具体内容
		private var tooltip:Object;
		// 当前操作对象
		private var currentTarget:DisplayObject;
		// 用与比对tip对象变更的变量
		private var previousTarget:DisplayObject;

		/**
		 *	注册tooltip
		 * @param target 接收鼠标事件的可显示对象
		 * @param tooltip	tips
		 */
		public function registTooltip(target:DisplayObject, tooltip:Object):void
		{
			// 新旧tooltip一样的时候。 返回
			if (this.tooltip == tooltip)
			{
				return;
			}

			// 将tooltip缓存到 tooltip对象池中
			targetMap[target] = tooltip;

			if (tooltip)
			{
				// 添加tooltip
				addTooltip(target);
			}
			else
			{
				// 移除tooltip
				removeTooltip(target);
			}
		}


		/**
		 * @private 添加tooltip给currentTarget对象
		 *
		 */
		private function addTooltip(target:DisplayObject):void
		{
			target.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler);
			target.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
			target.addEventListener(Event.REMOVED_FROM_STAGE, onMouseOutHandler);

			if (checkIfOver(target))
			{
				this.previousTarget = null;
				showHideTip(target);
			}
		}

		/**
		 *	移除currentTarget对对象的事件监听
		 *
		 */
		private function removeTooltip(target:DisplayObject):void
		{
			target.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOverHandler);
			target.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutHandler);
			target.removeEventListener(Event.REMOVED_FROM_STAGE, onMouseOutHandler);

			if (target in targetMap)
			{
				delete targetMap[target]
			}

			if (checkIfOver(target))
			{
				showHideTip();
			}
		}

		/**
		 *	检测鼠标是否在target对象中
		 * @param target
		 * @return
		 *
		 */
		private function checkIfOver(target:DisplayObject):Boolean
		{
			if (!target)
			{
				return false;
			}

			if (target.stage == null)
			{
				return false;
			}

			if (target.stage.mouseX == 0 && target.stage.mouseY == 0)
			{
				return false;
			}
			// 像素检测
			return target.hitTestPoint(target.stage.mouseX, target.stage.mouseY, true);
		}

		/**
		 *	显隐tooltip， 当target对象不为空的时候， 则是显示tip 否则隐藏tip
		 * @param target
		 *
		 */
		private function showHideTip(target:DisplayObject = null):void
		{
			this.currentTarget = target;
			if (target == null)
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMoveHandler);
				previousTarget = null;
				// 隐藏
				holder.visible = false;
				return;
			}

			if (target.stage == null || target.visible == false)
			{
				return;
			}

			if (previousTarget != target)
			{
				previousTarget = target;
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMoveHandler);
				// 显示
				targetChanged();
				holder.visible = true;
			}
		}


		private function onMouseOverHandler(e:MouseEvent):void
		{
			showHideTip(DisplayObject(e.currentTarget));
		}

		private function onMouseOutHandler(e:Event):void
		{
			showHideTip();
		}

		private function onStageMoveHandler(e:MouseEvent):void
		{
			// update tooltip position
			updatePosition();
		}

		private function targetChanged():void
		{
			// 把tips容器放到舞台的最上方，或者修改为跟target.parent 一个层级
			if (holder.parent == null)
			{
				holder.mouseChildren = holder.mouseEnabled = false;
				stage.addChild(holder);
			}

			// holder 处在父容器层的最上方
			holder.parent.setChildIndex(holder, holder.parent.numChildren - 1);
			var content:Object = targetMap[currentTarget];

			while (holder.numChildren)
			{
				tipsPool.push(holder.removeChildAt(0));
			}

			var tip:ToolTip = tipsPool.length > 0 ? tipsPool.pop() : new ToolTip;
			tip.setContent(targetMap[currentTarget].toString());
			holder.addChild(tip);
			updatePosition();
		}

		private function updatePosition():void
		{
			if (!currentTarget.hasOwnProperty("callOut"))
			{
				showHideTip();
				return;
			}

			// stage point
			var sp:Point = currentTarget.localToGlobal(new Point());
			switch (currentTarget["callOut"])
			{
				case "left":
					holder.x = sp.x - holder.width - 2;
					holder.y = sp.y + (currentTarget.height - holder.height >> 1);
					break;
				case "right":
					holder.x = sp.x + currentTarget.width + 2;
					holder.y = sp.y + (currentTarget.height - holder.height >> 1);
					break;
				case "top":
					holder.x = sp.x + (currentTarget.width - holder.width >> 1);
					holder.y = sp.y - holder.height;
					break;
				case "bottom":
					holder.x = sp.x + (currentTarget.width - holder.width >> 1);
					holder.y = sp.y + currentTarget.height + 2;
					break;
				default:
					useStageMousePosition();
					break;
			}
		}

		private function useStageMousePosition():void
		{
			var target:DisplayObject = currentTarget as DisplayObject
			var x:int = stage.mouseX + 20; //point.x;
			var y:int = stage.mouseY + 20; //point.y;
			//边界检测
			if (x + holder.width > stage.stageWidth)
			{
				x = stage.mouseX - holder.width;
			}
			if (y + holder.height > stage.stageHeight)
			{
				y = stage.mouseY - holder.height;
			}

			holder.x = x;
			holder.y = y;
		}

		private var tipsPool:Array;
	}
}
