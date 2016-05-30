## **使用VideoPlayer播放视频**

### <strong>1、播放器类型</strong>

* <strong>HTTP协议或者本地文件系统</strong>

```
var videoPlayer:VideoPlayer = VideoPlayer.create();
videoPlayer.connect(MediaProxyType.HTTP,"http://localhost/vod/1.mp4",null,handler);

function handler(states:String,...data):void
｛
	switch(states)
	{
		case MediaProxyStates.STREAM_STOP:
			//播放结束
			break;
		case MediaProxyStates.CONNECT_NOTIFY:
			setInterval(function():void
			{
				//trace("视频当前播放头：",videoPlayer.time);
			},2000);
			break;
		case MediaProxyStates.SEEK_COMPLETE:
			trace("播放seek：",videoPlayer.time);
			break;
		case MediaProxyStates.DURATION_NOTIFY:
			trace("视频时长：",data);
			break;
	}
｝
```

* <strong>HLS视频</strong>

```
videoPlayer.connect(MediaProxyType.HLS,"http://cnhlsvodhls01.e.vhall.com/vhalllive/199811626/fulllist.m3u8",null,handler);
```

* <strong>RTMP视频</strong>

```
videoPlayer.connect(MediaProxyType.RTMP, "rtmp://localhost/live", "12",handler);
```

* <strong>直播推流</strong>

```
videoPlayer.publish("9158Capture","麦克风 (USB Audio Device)","rtmp://localhost/live","12",handler);

function handler(states:String,...data):void
{
	...
	case MediaProxyStates.PUBLISH_NOTIFY:
		trace("推流成功");
		break
}		
```
### <strong>2、缩放视频窗口</strong>

```
stage.addEventListener(Event.RESIZE,function():void
{
	//VideoPlayer等比缩放视频居中显示
	videoPlayer.viewPort = new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
	//video.width = stage.stageWidth;
	//video.height = stage.stageHeight;
});
```

### <strong>3、独立使用videoPlayer播放netStream或者Camera</strong>

```
videoPlayer.attachView(Camera);
//videoPlayer.attachView(NetStream);
```

## <strong>使用原生Video播放视频</strong>

###  <strong>1、播放类型</strong>

* <strong>HTTP协议或者本地文件系统</strong>

```
var video:Video = new Video();

var _proxy:IMediaProxy = MediaProxyFactory.create(MediaProxyType.HTTP);
_proxy.connect("http://localhost/vod/1.mp4",null,handler);

function handler(states:String,...data):void
{
	switch(states)
	{
		case MediaProxyStates.CONNECT_NOTIFY:
			video.attachNetStream(_proxy.stream);
			break;
		case MediaProxyStates.STREAM_FULL:
		case MediaProxyStates.STREAM_SIZE_NOTIFY:
			video.width = video.videoWidth;
			video.height = video.videoHeight;
			break;
	}
}
```

* <strong>HLS视频</strong>

```
var _proxy:IMediaProxy = MediaProxyFactory.create(MediaProxyType.HLS);
_proxy.connect("http://cnhlsvodhls01.e.vhall.com/vhalllive/199811626/fulllist.m3u8",null,handler);
```

* <strong>RTMP视频</strong>

```
var _proxy:IMediaProxy = MediaProxyFactory.create(MediaProxyType.RTMP);
_proxy.connect( "rtmp://localhost/live", "12",handler);
```

* <strong>直播推流</strong>

```
var _proxy:IMediaProxy = MediaProxyFactory.create(MediaProxyType.PUBLISH);
videoPlayer.publish("9158Capture","麦克风 (USB Audio Device)","rtmp://localhost/live","12",handler);

function handler(states:String,...data):void
{
	...
	case  MediaProxyStates.CONNECT_NOTIFY:
		trace("推流成功");
		var iPub:IPublish = _proxy as IPublish;
		iPub.publish(camOrName,micOrName);
		break;
	case case MediaProxyStates.PUBLISH_NOTIFY:
		video.attachCamera((_proxy as IPublish).usedCam);
		break
}		
```

### <strong>2、原生video缩放</strong>

```
stage.addEventListener(Event.RESIZE,function():void
{
	//会铺满显示窗口
	video.width = stage.stageWidth;
	video.height = stage.stageHeight;
});
```