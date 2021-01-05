
var _wx_currentUrl = top.location.href.split('#')[0];
_wx_currentUrl = "jsapi_ticket="+_wx_jsapi_ticket+"&noncestr="+_wx_noncestr+"&timestamp="+_wx_timestamp+"&url="+_wx_currentUrl;
var _wx_signature = hex_sha1(_wx_currentUrl);// 签名
	
wx.config({
  	debug: false,
  	appId: _wx_corpid,
  	timestamp: _wx_timestamp,
  	nonceStr: _wx_noncestr,
  	signature: _wx_signature,
  	jsApiList: [
        'chooseImage',
        'previewImage',
        'uploadImage',
        'getLocation'
    ]
});

wx.error(function (res) {
    alert("微信报错： "+res.errMsg);
});

function wx_getLocation(callbackFn){
	wx.getLocation({
	    type: 'wgs84', // 默认为wgs84的gps坐标，如果要返回直接给openLocation用的火星坐标，可传入'gcj02'
	    success: callbackFn
	});
}
