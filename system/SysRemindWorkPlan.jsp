
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML>
<HEAD>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>

<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(354,user.getLanguage())+",javascript:document.planform.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(20215,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	//String workPlanString = "";
	//RecordSet.execute("SELECT * FROM WorkPlan WHERE ID IN (SELECT requestid FROM SysPoppupRemindInfoNew WHERE userID = " + user.getUID() + " AND type = 12)");
  
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="schedule"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(20215,user.getLanguage())%>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
	    </td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(354,user.getLanguage()) %>" class="e8_btn_top middle" onclick="javascript:document.planform.submit();"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			<span><%=SystemEnv.getHtmlLabelName(780,user.getLanguage()) %></span>
	</span>
</div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
</div>

<div>
<%
		//得到pageNum 与 perpage
		int perpage=10;
		//设置好搜索条件
		String backFields =" * ";
		String fromSql = " WorkPlan ";
		
		String sqlwhere = " WHERE ID IN (SELECT requestid FROM SysPoppupRemindInfoNew WHERE userID = " + user.getUID() + " AND type = 12)";
		String orderBy = "";
		String linkstr = "";
		linkstr = "";
		String tableString=""+
			"<table pagesize=\""+perpage+"\" tabletype=\"none\">"+
			"<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"id\" sqlsortway=\"desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" />"+
			"<head>"+
				"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(84,user.getLanguage())+"\" column=\"ID\" orderkey=\"ID\"  />"+
				"<col width=\"90%\"  text=\""+SystemEnv.getHtmlLabelName(2211,user.getLanguage())+"\" column=\"ID\" orderkey=\"name\" otherpara=\"column:name+column:type_n\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanName\"/>"+
			"</head>"+
			"</table>";
	%>
	<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WP_SysRemindWorkPlan%>"/>
	<wea:SplitPageTag isShowTopInfo="true" tableString='<%=tableString%>'  mode="run"/>
<FORM name="planform" method="post" action="SysRemindWorkPlan.jsp">

</FORM>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>   
</BODY>

</HTML>
<SCRIPT language="JavaScript">
function view(id, workPlanTypeID){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 600;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = true;
	diag_vote.checkDataChange = false;
	diag_vote.isIframe=false;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%>";
	if(workPlanTypeID == 6){
		diag_vote.URL = "/hrm/performance/targetPlan/PlanView.jsp?from=2&id=" + id ;
	} else {
		diag_vote.URL = "/workplan/data/WorkPlanDetail.jsp?from=1&workid=" + id ;
	}
	diag_vote.show();
	
}
</SCRIPT>
