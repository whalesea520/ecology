
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SearchComInfo1" class="weaver.proj.search.SearchComInfo" scope="session" />
<%
String paraid = Util.null2String(request.getParameter("paraid")) ;
String from = Util.null2String(request.getParameter("from")) ;
String search_resourceid = Util.null2String(request.getParameter("search_resourceid")) ;
String optFrameSrc="";
if("MyProject".equals(from)){
	optFrameSrc="/proj/data/MyProject.jsp?from="+from;
}else if("MyManagerProject".equals(from)){
	optFrameSrc="/proj/data/MyManagerProject.jsp?from="+from+"&"+request.getQueryString();
}else if("batchshare".equals(from)){
	SearchComInfo1.resetSearchInfo();
	optFrameSrc="/proj/data/ProjectBlankTab.jsp?url=/proj/search/SearchResult.jsp?from="+from+"&"+request.getQueryString();
	
}else if("ProjectMonitor".equals(from)){
	optFrameSrc="/system/systemmonitor/proj/ProjMonitor.jsp?from="+from;
}

%>
<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<META NAME="AUTHOR" CONTENT="InetSDK">
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<script src="/proj/js/myobserver_wev8.js"></script>
<script type="text/javascript">
var evt1= function refreshLeftTree(){
	try{
		var tree= $("#leftframe");
		var src=tree.attr("src");
		tree.attr("src",src);
	}catch(e){}
};
window.top.myprjtypetreeobserver.subscribe(evt1);
</script>
</head>
<body>
<TABLE class=viewform width=100% id=oTable1  cellpadding="0px" cellspacing="0px" height="100%">
  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1 width="246px" style="padding:0px;display:none;">
<IFRAME name=leftframe id=leftframe src="/proj/Maint/PrjTypeTree.jsp?urlType=<%=from %>&search_resourceid=<%=search_resourceid %>" width="100%" height="100%" frameborder=no scrolling=no >
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
</td>
<td height=100% id=oTd2 name=oTd2 width="*" style="padding:0px">
<IFRAME name=optFrame id=optFrame src="<%=optFrameSrc %>" width="100%" height="100%" frameborder=no scrolling=yes>
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>


</body>
</HTML>
