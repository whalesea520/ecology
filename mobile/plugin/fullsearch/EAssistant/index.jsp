<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>小e客服工作台</title>
  <script>
    (function (baseFontSize, fontscale) {
      var _baseFontSize = baseFontSize || 100;
      var _fontscale = fontscale || 1;
      var win = window;
      var doc = win.document;
      var ua = navigator.userAgent;
      var matches = ua.match(/Android[\S\s]+AppleWebkit\/(\d{3})/i);
      var UCversion = ua.match(/U3\/((\d+|\.){5,})/i);
      var isUCHd = UCversion && parseInt(UCversion[1].split('.').join(''), 10) >= 80;
      var isIos = navigator.appVersion.match(/(iphone|ipad|ipod)/gi);
      var dpr = win.devicePixelRatio || 1;
      if (!isIos && !(matches && matches[1] > 534) && !isUCHd) {
        // 如果非iOS, 非Android4.3以上, 非UC内核, 就不执行高清, dpr设为1;
        dpr = 1;
      }
      var scale = 1 / dpr;
      var metaEl = doc.querySelector('meta[name="viewport"]');
      if (!metaEl) {
        metaEl = doc.createElement('meta');
        metaEl.setAttribute('name', 'viewport');
        doc.head.appendChild(metaEl);
      }
      metaEl.setAttribute('content', 'width=device-width,user-scalable=no,initial-scale=' + scale + ',maximum-scale=' + scale + ',minimum-scale=' + scale);
      doc.documentElement.style.fontSize = _baseFontSize / 2 * dpr * _fontscale + 'px';
      window.viewportScale = dpr;
    })();
    if(!window.Promise) {
      document.writeln('<script src="https://as.alipayobjects.com/g/component/es6-promise/3.2.2/es6-promise.min.js"'+'>'+'<'+'/'+'script>');
    }
  </script>
  <link rel="stylesheet" href="/mobile/plugin/fullsearch/EAssistant/index.css"/>
  <style>
    .am-whitespace{
        height:0px !important;
    }

    .tapSlideDiv{
      -webkit-overflow-scrolling: touch;
    }

    .am-card{
      min-height:0px !important;
    }

    .operateDiv{
        line-height: 40px;
        text-align: center;
        color: blue;
    }
    .unDoDiv{
        line-height: 40px;
        text-align: center;
    }
    
    .detailDiv{
        line-height: 40px;
    }
    .am-list{
        background-color: #f3f3f3;
    }
    .am-list-body{
      background-color: #f3f3f3;
      border-top:0px;
    }
    .typeDiv .am-list-line .am-list-content{
        text-align: center;
        color: blue;
    } 
    .popup-list .am-list-body{
      background-color:#808080;
    }
    
    .flagDiv{
    	float: right;
	    border: 1px solid #bd532a;
	    padding: 3px;
	    margin-left: 10px;
    }
    
    .comefrom-e{
		border: 1px solid #3376ff;
		color: #3376ff;
    }
    
	.comefrom-ws{
		border: 1px solid #37b17c;
		color: #37b17c;
    }
  </style>
</head>
<body style="background-color: #f3f3f3;">

<div id="container"></div>
<script type="text/javascript" src="/cloudstore/resource/mobile/react/react.min.js" charset="utf-8"></script>
<script type="text/javascript" src="/cloudstore/resource/mobile/react/react-with-addons.min.js" charset="utf-8"></script>
<script type="text/javascript" src="/cloudstore/resource/mobile/react/react-dom.min.js" charset="utf-8"></script>
<script type="text/javascript" src="/mobile/plugin/fullsearch/js/promise.min.js" charset="utf-8"></script>
<script type="text/javascript" src="/mobile/plugin/fullsearch/js/fetch.min.js" charset="utf-8"></script>
<script src="/mobile/plugin/fullsearch/EAssistant/common.js"></script>
<script src="/mobile/plugin/fullsearch/EAssistant/index.js"></script>
<script>

  //返回
  //function doLeftButton() {
  //	 try{
  //	 	window.backList()
  //	 }catch(e){
  //	 	return 1;
  //	 }
  //	 //return "close";
  //}	 

</script>
</body>
</html>