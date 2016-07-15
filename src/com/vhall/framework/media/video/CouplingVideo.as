/**
 * ===================================
 * Author:	iDzeir
 * Email:	qiyanlong@wozine.com
 * Company:	http://www.vhall.com
 * Created:	Jul 7, 2016 10:54:14 AM
 * ===================================
 */

package com.vhall.framework.media.video
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.NetStream;

	public class CouplingVideo extends Sprite
	{
		private var _streamVideo:Video;
		private var _cameraVideo:Video;

		protected var _useVideo:Video;

		protected var _width:Number;
		protected var _height:Number;
		protected var _smoothing:Boolean;

		/**
		 * 摄像头回放和流回放组合，默认大小320*280,启用smoothing
		 */		
		public function CouplingVideo()
		{
			super();

			this.mouseChildren = false;
			_smoothing = true;
			_width = 320;
			_height = 280;
		}

		/**
		 * 获得视频来源,传入null为取消视频显示源
		 * @param source Camera或者netStream
		 */
		public function attachView(source:*):void
		{
			removeChildren();

			if(source)
			{
				if(source is Camera)
				{
					_cameraVideo ||= new Video();
					_cameraVideo.attachCamera(source as Camera);
					_useVideo = _cameraVideo;
				}else{
					_streamVideo ||= new Video();
					_streamVideo.attachNetStream(source as NetStream);
					_useVideo = _streamVideo;
				}
				addChild(_useVideo);
				update();
			}else{
				stop();
			}
		}

		/**
		 * 停止视频播放
		 */		
		public function stop():void
		{
			if(_useVideo)
			{
				switch(_useVideo)
				{
					case _cameraVideo:
						_useVideo.attachCamera(null);
						_useVideo.attachNetStream(null);
						break;
					case _streamVideo:
						_useVideo.attachCamera(null);
						_useVideo.attachNetStream(null);
						break;
				}
				_useVideo.clear();
				if(_useVideo.parent){
					_useVideo.parent.removeChild(_useVideo);
				}
				_useVideo = null;
			}
			removeChildren();
		}

		/**
		 * 清楚视频最后一帧
		 */		
		public function clear():void
		{
			if(_useVideo)
			{
				_useVideo.clear();
			}
		}

		private function update():void
		{
			if(_useVideo)
			{
				_useVideo.width = _width;
				_useVideo.height = _height;
				_useVideo.smoothing = _smoothing;
			}
		}

		override public function getBounds(targetCoordinateSpace:DisplayObject):Rectangle
		{
			var rect:Rectangle = new Rectangle(x,y,_width,_height);
			var p:Point = targetCoordinateSpace.globalToLocal(localToGlobal(new Point(0,0)));
			rect.x = p.x;
			rect.y = p.y;
			return rect;
		}

		public function set smoothing(bool:Boolean):void
		{
			_smoothing = bool;
			if(_useVideo)
			{
				_useVideo.smoothing = bool;
			}
		}

		public function get smoothing():Boolean
		{
			return _smoothing;
		}

		override public function set width(value:Number):void
		{
			_width = value;
			if(_useVideo)
			{
				_useVideo.width = value;
			}
		}

		override public function get width():Number
		{
			return _width;
		}

		override public function set height(value:Number):void
		{
			_height = value;
			if(_useVideo)
			{
				_useVideo.height = _height;
			}
		}

		override public function get height():Number
		{
			return _height;
		}

		public function get videoWidth():Number
		{
			if(_useVideo)
				return _useVideo.videoWidth;
			return 0;
		}

		public function get videoHeight():Number
		{
			if(_useVideo)
				return _useVideo.videoHeight;
			return 0;
		}

		/**
		 * 是否为摄像头捕获
		 * @return
		 */		
		public function get isCamera():Boolean
		{
			return _cameraVideo && _useVideo == _cameraVideo;
		}
	}
}

