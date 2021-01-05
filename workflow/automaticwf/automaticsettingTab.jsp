
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
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
if(!HrmUserVarify.checkUserRight("intergration:automaticsetting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String isDialog = Util.null2String(request.getParameter("isdialog"));
String _fromURL = Util.null2String(request.getParameter("_fromURL"));
String viewid = Util.null2String(request.getParameter("viewid"));
int tabid = Util.getIntValue(request.getParameter("tabid"),0);
String navName = "";
String loadurl1="";
String loadurl2="";

if(_fromURL.equals("2")){
	RecordSet.executeSql("select * from outerdatawfset where id="+viewid);
	if(RecordSet.next()){
		navName = Util.null2String(RecordSet.getString("setname"));
	}
	loadurl1="/workflow/automaticwf/automaticsettingEdit.jsp?"+request.getQueryString();
	loadurl2="/workflow/automaticwf/automaticsettingAddDetail.jsp?"+request.getQueryString();
}else if(_fromURL.equals("1")){
	navName = SystemEnv.getHtmlLabelName(33720,user.getLanguage());
	loadurl1="/workflow/automaticwf/automaticsettingEdit.jsp?"+request.getQueryString();
}

%>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("integration")%>",
        staticOnLoad:true,
        notRefreshIfrm:true,
        objName:"<%=navName%>"
    });
}); 

</script>
<body scroll="no">
	<div class="e8_box demo2">
		<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
			<div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span id="objName"></span>
				</div>
				<div>
					<ul class="tab_menu">

						<li class="<%=(tabid==0?"current":"")%>">
							<a href="<%=loadurl1%>" target="tabcontentframe">
								<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%><!-- 基本信息 -->
							</a>
						</li>
					
<%if("2".equals(_fromURL)){ %>
						<li class="<%=(tabid==1?"current":"")%>">
							<a href="<%=loadurl2%>" target="tabcontentframe">
								<%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%><!-- 详细设置 -->
							</a>
						</li>
					
<%}%>
					</ul>
					<div id="rightBox" class="e8_rightBox"></div>
				</div>
			</div>
		</div>

		<div class="tab_box">
			<div>
				<iframe src="<%=(tabid==0?loadurl1:loadurl2)%>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
			</div>
		</div>
	</div>
</body>

</html>