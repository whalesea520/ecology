<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.formmode.service.ReportInfoService"%>
<%@page import="weaver.common.util.string.StringUtil"%>
<jsp:useBean id="customSearchService" class="weaver.formmode.service.CustomSearchService" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ReportShareInfo" class="weaver.formmode.report.ReportShareInfo" scope="page" />
<%
int id = Util.getIntValue(request.getParameter("id"));

ReportInfoService reportInfoService=new ReportInfoService();
Map<String,Object> map=reportInfoService.getReportInfoById(id);
String reportname = Util.null2String(map.get("reportname"));
String reportdesc = Util.null2String(map.get("reportdesc"));

boolean haveright = false;
List<User> lsUser = new ArrayList<User>();
lsUser.add(user);
for(int i=0;i<lsUser.size();i++){
	User tempUser = lsUser.get(i);
	ReportShareInfo.setUser(tempUser);
	haveright = ReportShareInfo.checkUserRight(id);
	if(haveright){
		break;
	}
}
if(!haveright) {
    //response.sendRedirect("/notice/noright.jsp");
    out.println("<script>window.location.href='/notice/noright.jsp';</script>");
    return;
}
 %>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>

<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        staticOnLoad:true,
        mouldID:"<%= MouldIDConst.getID("formmode")%>",
        objName:"<%=reportname%>"
    });
 
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
			    <ul class="tab_menu">
				    <li class="current">
						<a href="/formmode/report/ReportConditionIframe.jsp?id=<%=id %>" target="tabcontentframe" class="a_tabcontentframe">
							<%if(!"".equals(reportdesc)){%>
								<%=StringUtil.Html2Text(reportdesc).length()>60?StringUtil.Html2Text(reportdesc).substring(0, 60) + "...":StringUtil.Html2Text(reportdesc)%>
							<%}else{ %>
								<%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%><!-- 报表条件 -->
							<%}%>
						</a>
					</li>
			    </ul>
	      <div id="rightBox" class="e8_rightBox">
	    </div>
	   </div>
	  </div>
	</div>	 
	    <div class="tab_box">
	        <div>
	            <iframe src="/formmode/report/ReportConditionIframe.jsp?id=<%=id %>" id="tabcontentframe" name="tabcontentframe" onload="update()" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>
<script language="javascript">
	$(function(){
		$('.a_tabcontentframe').hover(function(){
			$('.a_tabcontentframe').attr('title', "<%=StringUtil.Html2Text(reportdesc).replaceAll("\r\n|\r|\n|\n\r", "")%>");
		});
	});
</script>