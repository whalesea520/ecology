<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.User,weaver.hrm.HrmUserVarify" %>

<!DOCTYPE html>
<html lang="en">
<head>
	<title>文档详情</title>
	
	<%
		User user = HrmUserVarify.getUser (request , response) ;
		if(user == null)  return ;
		
		int docid = Util.getIntValue(request.getParameter("docid"),0);
		String sessionkey = Util.null2String(request.getParameter("sessionkey"));
		String module = Util.null2String(request.getParameter("module"));
		String scope = Util.null2String(request.getParameter("scope"));
		String isFromNews = Util.null2String(request.getParameter("isFromNews"));
	%>
 <script type="text/javascript" src="/cloudstore/resource/mobile/react/react-with-addons.min.js" charset="utf-8"></script>
 <script type="text/javascript" src="/cloudstore/resource/mobile/react/react-dom.min.js" charset="utf-8"></script>
 
 <script type="text/javascript" src="/mobile/plugin/fullsearch/js/promise.min.js" charset="utf-8"></script>
 <script type="text/javascript" src="/mobile/plugin/fullsearch/js/fetch.min.js" charset="utf-8"></script>
 <script type='text/javascript' src='/mobile/plugin/js/jquery/jquery_wev8.js'></script>
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
      var dpr = 1;
      var scale = 1 / dpr;

	  window._androidX5 = window.innerWidth <= 600 ? true : false;

      var metaEl = doc.querySelector('meta[name="viewport"]');
      if (!metaEl) {
        metaEl = doc.createElement('meta');
        metaEl.setAttribute('name', 'viewport');
        doc.head.appendChild(metaEl);
      }

      metaEl.setAttribute('content', 'width=device-width,user-scalable=no,initial-scale=' + scale + ',maximum-scale=' + scale + ',minimum-scale=' + scale);
      doc.documentElement.style.fontSize = _baseFontSize / 2 * dpr * _fontscale + 'px';
      window.viewportScale = dpr;

	 if(parent.window._CLOUDY_INDEX == 1 && parent.window.viewportScale != 1){
		 var pmetaEl = parent.window.document.querySelector('meta[name="viewport"]');
		 pmetaEl.setAttribute('content', 'width=device-width,user-scalable=no,initial-scale=' + scale + ',maximum-scale=' + scale + ',minimum-scale=' + scale);
	 }

    })();
  </script>
 <script type="text/javascript">
 	var docid = "<%=docid%>";
 	var sessionkey = "<%=sessionkey%>";
 	var moduleid = "<%=module%>";
  	var scope = "<%=scope%>";
 	var FontList = {
 		loadingFont : ''
 	}
 	this._hasParentWindow = parent.window._CLOUDY_INDEX == 1 ? true : false;
 	
 		
 	function doLeftButton(){
		if(attrDetail.className == "show"){
			attrDetail.className = "";
			setTimeout(function(){
				attrDetail.childNodes[0].style.display = "none";
			},500);
			return "0";
		}else if(docReply.className == "show"){
			docReply.className = "";
			setTimeout(function(){
				docReply.childNodes[0].style.display = "none";
			},500);
			return "0";
		}
		
  	     return "close";
  	}
  	
  	function toOpenFile(param,readOnLine){
  		location = "/download.do?" + param+"&module=<%=module%>&scope=<%=scope%>" + (readOnLine ? "&file2pdf=1" : "");
  		return;
		if(readOnLine){
			attrDetail.className = "show";
			setTimeout(function(){
				attrDetail.childNodes[0].src = "/mobile/plugin/2/pdfview/mobile-viewer/viewer.jsp?" + param + "&module=<%=module%>&scope=<%=scope%>"
			},500);
		}else{
			location = "/download.do?" + param+"&module=<%=module%>&scope=<%=scope%>";
		}
	}
 	
 		//系统文档分享
	function toShareDoc(dataMap){
		var data = {
			"func" : "shareDocument",
			"params" : {
						docid : dataMap.docid,
						title : dataMap.docTitle
					}
		}
		location = "emobile:" + JSON.stringify(data);
	}
	
	function deleteDoc(docid){
		try{
			if(_hasParentWindow){
				parent.deleteSystemDoc(docid);
			}else{
				
			}
		}catch(e){}
	}
	
	function componentDidUpdate(){
		var _h1 = window.innerHeight;
		var _h2 = document.getElementsByClassName("operate")[0].clientHeight;
		document.getElementsByClassName("am-list-view-scrollview")[0].style.height = _h1 - _h2 + "px";
		document.getElementById("content").style.height = _h1 - _h2 + "px";  
		return;
		resizeFontSize(document.getElementById("docContent"));
	}
	
	function resizeFontSize($obj){
		try{
			var _fontSize = $obj.style.fontSize;
			if(_fontSize != ""){
				_fontSize = _fontSize.replace("px","").replace("pt","");
				_fontSize = 32 + parseInt(_fontSize) - 12;
				$obj.style.fontSize = _fontSize/100 + "rem";
			}
			for(var i = 0;i < $obj.childNodes.length;i++){
				resizeFontSize($obj.childNodes[i]);
			}
		}catch(e){}
	}
	
	function getRequestTitle(){
		if("1" == "<%=isFromNews%>"){	
			return "新闻详情";
		}else if(!this._hasParentWindow){
			return "文档详情";
		}
	}

 </script>		
 <link rel="stylesheet" href="/mobile/plugin/networkdisk/css/content.css?version=3"/>
  <script>
		if(window._androidX5){
			document.write('<link rel="stylesheet" href="/mobile/plugin/networkdisk/css/android_x5.css?version=13"/>');
		}
  </script>
 <style>
 	#docContent img{
 		max-width:100%;
 	}
	#docReply{
		 -webkit-overflow-scrolling: touch; 
	}
	iframe{
		border:0;
	}
	.docContent{
		margin:0px;
	}

 </style>
</head>
<body>
	<div id="root">
		
	</div>
	<script src="/mobile/plugin/networkdisk/js/content.js?version=5" type="text/javascript"></script>
</body>
</html>