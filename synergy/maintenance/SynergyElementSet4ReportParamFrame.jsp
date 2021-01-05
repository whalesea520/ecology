
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
	String eid = Util.null2String(request.getParameter("eid"));
	String sbaseid = Util.null2String(request.getParameter("sbaseid"));
	String varType = Util.null2String(request.getParameter("varType"));
	String wfid = Util.null2String(request.getParameter("wfid"));
	String nodeid=Util.null2String(request.getParameter("nodeid"));
	
	int labelid = "sys".equals(varType) ? 130008 : 130009;
	String navName = SystemEnv.getHtmlLabelName(labelid, user.getLanguage());
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type="text/css" />
<script type="text/javascript">
$(function() {
	attachUrl();
});


function attachUrl()
{
	$("[name='tabcontentframe']").attr("src","SynergyES4RPFrameInner.jsp?eid=<%=eid%>&sbaseid=<%=sbaseid%>&varType=<%=varType%>&wfid=<%=wfid%>&nodeid=<%=nodeid%>");
}

function onCancel(){
	var dialog = parent.getDialog(window);	
	dialog.close();
}

</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(569,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="portal"/>
   <jsp:param name="navName" value="<%=navName%>"/>  
</jsp:include>

 <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
 <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
 
 <table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td width="160px">
		</td>
		<td class="rightSearchSpan" style="text-align: right; width: 500px !important">
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div style="height:100%">
	<iframe id="tabcontentframe" onload="update();" name="tabcontentframe" class="flowFrame" frameborder="0" scrolling="no" height="100%" width="100%;"></iframe>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
	     <input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();"/>
	    </wea:item>
	</wea:group>
	</wea:layout>
</div>	
		
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</BODY>
</HTML>
