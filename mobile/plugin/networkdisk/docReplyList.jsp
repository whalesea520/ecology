<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.User,weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.conn.RecordSet" %>

<!DOCTYPE html>
<html lang="en">
<head>
	<title>回复</title>
	
	<%
		User user = HrmUserVarify.getUser (request , response) ;
		if(user == null)  return ;
	
		int docid = Util.getIntValue(request.getParameter("docid"),0);
		String sessionkey = Util.null2String(request.getParameter("sessionkey"));
		
		int ownerid = 0;
		int seccategory = 0;
		RecordSet rs = new RecordSet();
		rs.executeSql("select ownerid,seccategory from DocDetail where id=" + docid);
		if(rs.next()){
		   	ownerid = rs.getInt("ownerid");
		   	seccategory = rs.getInt("seccategory");
		}
		String canReply = "0";
		rs.executeSql("select replyable from DocSecCategory where id=" + seccategory);
		if(rs.next()){
		    canReply = "1".equals(rs.getString("replyable")) ? "1" : "0"; 
		}
	%>
 <script type="text/javascript" src="/cloudstore/resource/mobile/react/react-with-addons.min.js" charset="utf-8"></script>
 <script type="text/javascript" src="/cloudstore/resource/mobile/react/react-dom.min.js" charset="utf-8"></script>
 
 <script type="text/javascript" src="/mobile/plugin/fullsearch/js/promise.min.js" charset="utf-8"></script>
 <script type="text/javascript" src="/mobile/plugin/fullsearch/js/fetch.min.js" charset="utf-8"></script>
 <script type="text/javascript" src="/mobile/plugin/js/jquery/jquery_wev8.js" charset="utf-8"></script>
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

	 window._androidX5 = window.innerWidth <= 600 ? true : false;
	 dpr = window._androidX5 ? 1 : dpr;

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
  </script>
 <script type="text/javascript">
 	var docid = "<%=docid%>";
 	var ownerid = "<%=ownerid%>";
 	var sessionkey = "<%=sessionkey%>";
 	var canReply = "<%=canReply%>";
 	var FontList = {
 		loadingFont : '',
 		loadMore : '<%=SystemEnv.getHtmlLabelName(129188,user.getLanguage())%>..',//下拉加载更多
 	}
 	var pageSize = 10;
 	var childrenSize = 5;
 	var lastId = 0;
 </script>		
 <link rel="stylesheet" href="/mobile/plugin/networkdisk/css/reply.css"/>
 <script>
		if(window._androidX5){
			document.write('<link rel="stylesheet" href="/mobile/plugin/networkdisk/css/android_x5.css?version=1"/>');
		}
  </script>
</head>
<body>
	<div id="root">
		
	</div>
	<script src="/mobile/plugin/networkdisk/js/reply.js?version=1" type="text/javascript"></script>
</body>
</html>