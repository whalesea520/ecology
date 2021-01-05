<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String nameQuery=Util.null2String(request.getParameter("flowTitle"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.parent.getParentWindow(parent.window);
}
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</HEAD>
<%
char flag = 2;
String ProcPara = "";
String ProjID = Util.null2String(request.getParameter("ProjID"));
String log = Util.null2String(request.getParameter("log"));
RecordSet.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
RecordSet.first();

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage())+"-"+"<a href='/proj/data/ViewProject.jsp?log="+log+"&ProjID="+RecordSet.getString("id")+"'>"+Util.toScreen(RecordSet.getString("name"),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-2),_top} " ;
//RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="weaver" id="weaver">
<input type="hidden" name="ProjID" value="<%=ProjID%>">
<input type="hidden" name="isdialog" value="<%=isDialog %>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important;display:none;">
			<input type="text" class="searchInput"  name="flowTitle"  value="<%=nameQuery %>" />
			<span id="advancedSearch" class="advancedSearch" style="display:none"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>

<%

String CurrentUser = ""+user.getUID();
String logintype = ""+user.getLogintype();
int usertype = 0;
if(logintype.equals("2")) usertype= 1;


String sqlWhere = " where t1.requestid = t2.requestid and t2.userid = "+CurrentUser+" and t2.usertype=" + usertype + " and t1.requestid = t3.requestid  and t3.prjid = "+ProjID+" ";

if(!"".equals(nameQuery)){
	sqlWhere+=" and t1.requestname like '%"+nameQuery+"%' ";
}



String orderby =" t1.createdate ";
String tableString = "";
int perpage=10;                                 
String backfields = " t3.id,t1.requestid, t1.createdate, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t1.status ";
String fromSql  = " workflow_requestbase t1,workflow_currentoperator t2, Prj_Request t3 ";

tableString =   " <table instanceid=\"CptCapitalAssortmentTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
				//" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.cpt.util.CapitalTransUtil.getCanDelCptAssortmentShare' />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t3.id\" sqlsortway=\"DESC\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"createdate\" orderkey=\"createdate\"  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"creater\" transmethod='weaver.hrm.resource.ResourceComInfo.getResourcename'  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(259,user.getLanguage())+"\" column=\"workflowid\" orderkey=\"workflowid\"  transmethod='weaver.workflow.workflow.WorkflowComInfo.getWorkflowname' />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(1334,user.getLanguage())+"\" column=\"requestname\" orderkey=\"requestname\" href='/workflow/request/ViewRequest.jsp' linkkey='requestid' linkvaluecolumn='requestid'  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(740,user.getLanguage())+"\" column=\"createdate\" orderkey=\"createdate\"  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(1335,user.getLanguage())+"\" column=\"status\" orderkey=\"status\"   />"+
                "       </head>"+
                /**"		<operates>"+
					"		<operate href=\"javascript:onDetail();\" text=\""+SystemEnv.getHtmlLabelName(1293,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"		</operates>"+ **/                
                " </table>";
%>

<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />

<%
if("1".equals(isDialog)){
	%>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentWin.closeDialog();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>	
	
	<%
}
%>

<script type="text/javascript">
function onBtnSearchClick(){
	weaver.submit();
}
$(function(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
});
</script>
</BODY>
</HTML>
