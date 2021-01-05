
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
		<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
		<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

		<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
		<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
	</HEAD>

<%
	if(!HrmUserVarify.checkUserRight("WorkPlanMonitorSet:Set", user))
	{
	    response.sendRedirect("/notice/noright.jsp");
	    return;
	}
	
	String hrmID = Util.null2String(request.getParameter("hrmID"));
	String delHrm = Util.null2String(request.getParameter("delHrm"));
	if(!"".equals(delHrm)){
		RecordSet.executeSql("DELETE FROM WorkPlanMonitor WHERE hrmID = " + delHrm);
		SysMaintenanceLog syslog=new SysMaintenanceLog();
	    syslog.resetParameter();
		syslog.insSysLogInfo(user,Util.getIntValue(delHrm),ResourceComInfo.getLastname(delHrm)+"-删除日程监控","日程监控设置","213","4",0,Util.getIpAddr(request)); 
	
	}
 
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(19792,user.getLanguage()) + SystemEnv.getHtmlLabelName(352,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>


<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:add(), _self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
	    </td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>" class="e8_btn_top middle" onclick="add()"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
	<span id="hoverBtnSpan" class="hoverBtnSpan">
			<span ><%=SystemEnv.getHtmlLabelName(19793,user.getLanguage())%></span>
	</span>
</div>
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<FORM id="frmmain" name="frmmain" method="post" action="WorkPlanMonitorStatic.jsp">
	<input type="hidden" id="delHrm" name="delHrm">
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' >
			<wea:item><%=SystemEnv.getHtmlLabelName(19794,user.getLanguage())%></wea:item>
			<wea:item>			
				<brow:browser viewType="0" name="hrmID" browserValue='<%=hrmID%>' 
				browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" 
				hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1' 
				completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
				browserSpanValue='<%= Util.toScreen(ResourceComInfo.getResourcename(hrmID),user.getLanguage()) %>'></brow:browser>
		    </wea:item> 
		</wea:group>
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button" onclick="doSearch();" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtionAVS();"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
			</wea:item>
	    </wea:group>
	</wea:layout>
	</FORM>
</div>
<TABLE width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<COLGROUP>
	<TR>
		<TD valign="top">
			<TABLE class="Shadow">
				<TR>
					<TD valign="top">
						<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WP_WorkPlanMonitorStatic%>"/>
						<%String groupby =" t.hrmID, t.dt ";
						String orderby = "t.dt";
						String backfields = "count(*) as cnt,t.hrmID,t.dt";
						String tableString = "";
						int perpage=10;       
						String fromSql  = " (SELECT hrmID, operatorDate+' '+operatorTime as dt FROM WorkPlanMonitor) t ";
						if(RecordSet.getDBType().equalsIgnoreCase("oracle")){
							fromSql= " (SELECT hrmID, operatorDate||' '||operatorTime as dt FROM WorkPlanMonitor) t ";
						}
						String sqlWhere = "";
						if(!"".equals(hrmID)){
							sqlWhere = "where t.hrmID = "+ hrmID;
						}
						tableString =   " <table instanceid=\"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WP_WorkPlanMonitorStatic,user.getUID())+"\" tabletype=\"none\">"+
										"       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\"  sqlwhere=\""+sqlWhere+"\"  sqlorderby=\""+orderby+"\" sqlgroupby=\""+groupby+"\"  sqlprimarykey=\"hrmID\" sqlsortway=\"DESC\" />"+
										"       <head>"+
										"           <col width=\"35%\"  text=\""+SystemEnv.getHtmlLabelName(19794,user.getLanguage())+"\" column=\"hrmid\" orderkey=\"hrmid\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getResourceName\" />"+
										"           <col width=\"35%\"  text=\""+SystemEnv.getHtmlLabelName(26446,user.getLanguage())+"\" column=\"dt\" orderkey=\"dt\" />"+
										"           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(19795, user.getLanguage())+"\" column=\"cnt\" orderkey=\"cnt\" />"+
										"       </head>";
						tableString +=  "		<operates>"+
										"		<popedom column=\"hrmID\"  ></popedom> "+
										"		<operate href=\"javascript:view();\" isalwaysshow=\"true\" text=\""+SystemEnv.getHtmlLabelName(18562,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
										"		<operate href=\"javascript:delMonitor();\" isalwaysshow=\"true\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
										"		</operates>";
						tableString +=  " </table>";
						%>

						<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />

					</TD>
				</TR>
			</TABLE>
		</TD>
	</TR>
	<TR>
		<TD height="10"></TD>
	</TR>
</TABLE>

</BODY>

</HTML>



<script language="JavaScript">
var diag_vote;

function closeDialog(){
	diag_vote.close();
}

function closeDlgARfsh(){
	diag_vote.close();
	window.location="/system/systemmonitor/workplan/WorkPlanMonitorStatic.jsp";
}

function delMonitor(id)
{
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		$('#delHrm').val(id);
		$('#frmmain').submit();
	});
}

function add(){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 550;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19792,user.getLanguage())%>";
	diag_vote.URL = "/system/systemmonitor/workplan/WorkPlanMonitorSet.jsp";
	diag_vote.show();
}

function view(id){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 550;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(19793,user.getLanguage())%>";
	diag_vote.URL = "/system/systemmonitor/workplan/WorkPlanMonitorSet.jsp?hrmID=" + id;
	diag_vote.show();
}

function doSearch() {
	document.frmmain.submit();
}
function resetCondtionAVS(){
	var advancedSearchDiv = "#advancedSearchDiv";

	//清空浏览按钮及对应隐藏域
	jQuery(advancedSearchDiv).find(".Browser").siblings("span").html("");
	jQuery(advancedSearchDiv).find(".Browser").siblings("input[type='hidden']").val("");
	jQuery(advancedSearchDiv).find(".e8_os").find("input[type='hidden']").val("");
	jQuery(advancedSearchDiv).find(".e8_outScroll .e8_innerShow span").html("");

	
}

function preDo(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#hoverBtnSpan").hoverBtn();
}

function onBtnSearchClick(){
	doSearch();
}
 </script>

