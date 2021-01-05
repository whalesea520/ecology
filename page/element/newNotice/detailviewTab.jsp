<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.conn.RecordSet"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<%
int userid=user.getUID(); 
int usertype = 0 ;

int eid = Util.getIntValue(Util.null2String(request.getParameter("eid")));
int id = Util.getIntValue(Util.null2String(request.getParameter("id")), -1);
int isfromlist = Util.getIntValue(Util.null2String(request.getParameter("isfromlist")), -1);

String hpid = Util.null2String(request.getParameter("hpid"));
int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"), -1);

String noticetitle = "";
String noticeconent = "";
String noticeimgsrc = "";
if (id > 0) {
	RecordSet rs = new RecordSet();
	rs.executeSql("select * from hpElement_notice where id=" + id);
    if (rs.next()) {
        noticeimgsrc = Util.null2String(rs.getString("imgsrc"));
	    noticetitle = Util.null2String(rs.getString("title"));
	    noticeconent = Util.null2String(rs.getString("content"));
	    noticetitle= noticetitle.replaceAll("\"", "\\\\\"");
    }
}
%>

<script type="text/javascript">
var dialog = parent.getDialog(window);
var parentWin = parent.getParentWindow(window);
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        /*mouldID:"<%= MouldIDConst.getID("offical")%>",*/
        staticOnLoad:true,
        iframe:"tabcontentframe",
        objName:"<%=noticetitle %>"
    });
}); 

$(function () {
	
	
	
});
</script>

</head>
<BODY scroll="no">
	
	
	<div class="e8_box demo2">
	 <div class="e8_boxhead">
	    <div class="div_e8_xtree" id="div_e8_xtree"></div>
        <div class="e8_tablogo" id="e8_tablogo"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName"></span>
			</div>
		<div>
	    
		
		 <div id="rightBox" class="e8_rightBox">
	    </div>
	    	</div>
		</div>
	</div>
		<div class="tab_box">
		<iframe src="/page/element/newNotice/detailview.jsp?eid=<%=eid %>&id=<%=id %>&isfromlist=<%=isfromlist %>&subCompanyId=<%=subCompanyId %>&hpid=<%=hpid %>" id="tabcontentframe" onload="" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	</div>
	</div>
	</div>
</body>
</html>