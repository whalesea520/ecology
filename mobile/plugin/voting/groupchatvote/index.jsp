<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="weaver.general.Util" %>
<!DOCTYPE html>
<html lang="en">
    <%
       String groupid = Util.null2String(request.getParameter("groupid"));
       String sessionkey = Util.null2String(request.getParameter("sessionkey"));
    %>
    <head>
        <meta charset="UTF-8">
        <title>投票</title>
        <script type="text/javascript"
            src="/cloudstore/resource/mobile/react/react-with-addons.min.js"
            charset="utf-8"></script>
        <script type="text/javascript"
            src="/cloudstore/resource/mobile/react/react-dom.min.js"
            charset="utf-8"></script>
        <script type="text/javascript"
            src="/mobile/plugin/fullsearch/js/promise.min.js" charset="utf-8"></script>
        <script type="text/javascript"
            src="/mobile/plugin/fullsearch/js/fetch.min.js" charset="utf-8"></script>
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
    
    
    window.__groupid = "<%=groupid%>";
    
    
    window.doUpload = function(){
        //location = "emobile:mutableUpload:callbackUpload:1:1520:clearAppendix";
        location = "emobile:upload:callbackUpload:1:1520:clearAppendix:onlyPicture";
    }
    
    function callbackUpload(name,data,index) {
        if(data) uploaddata.value = data;
        if(name) uploadname.value = name;
        try{
            if(window.__voteObj){
                window.__voteObj.showLoading();
            }
        }catch(e){}
        dataForm.submit();
    }
    function clearAppendix(){
    }

    function uploadedCallback(imagefileid){
        try{
            if(window.__voteObj){
                window.__voteObj.renderData(imagefileid);
            }
        }catch(e){}
    }
    
    function doLeftButton(){
        if(document.getElementById("voteUsers") && voteUsers.className == "show"){
            voteUsers.className = "";
            setTimeout(function(){
                voteUsers.childNodes[0].style.display = "none";
            },500);
            return "0";
        }else if(document.getElementById("voteDetail") && voteDetail.className == "show"){
            voteDetail.className = "";
            setTimeout(function(){
                voteDetail.childNodes[0].style.display = "none";
            },500);
            return "0";
        }
        
         return "close";
    }
   
	function toLoaction(href){
		location = href;
	}
  </script>
        <link rel="stylesheet"
            href="/mobile/plugin/voting/groupchatvote/css/index.css" />
    </head>

    <body>
    
       <iframe name='hidden_frame' id="hidden_frame" style="display:none"></iframe>
        <form id="dataForm" action="/mobile/plugin/voting/groupchatvote/uploadImage.jsp" enctype="multipart/form-data" method="post" target="hidden_frame">
            <input id="uploaddata" type="hidden" name="uploaddata" />
            <input id="uploadname" type="hidden" name="uploadname" />
            <input id="sessionkey" type="hidden" name="sessionkey" value="<%=sessionkey%>" />
        </form>
    
    
        <div id="root"></div>
            
        <script src="/mobile/plugin/voting/groupchatvote/js/index.js?version=7"
            type="text/javascript"></script>

    </body>
</html>