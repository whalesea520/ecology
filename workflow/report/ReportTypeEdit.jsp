<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
if(!HrmUserVarify.checkUserRight("WorkflowReportManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
} 
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(33664,user.getLanguage());
String needfav ="1";
String needhelp ="";

String id = Util.null2String(request.getParameter("id"));
RecordSet.executeProc("Workflow_ReportType_SelectByID",id);
RecordSet.next();

String typename = Util.toScreen(RecordSet.getString("typename"),user.getLanguage()) ;
String typedesc = Util.toScreen(RecordSet.getString("typedesc"),user.getLanguage()) ;
String typeorder = Util.null2String(RecordSet.getString("typeorder"));
String dialog = Util.null2String(request.getParameter("dialog"));
String isclose = Util.null2String(request.getParameter("isclose"));
//add by xhheng @20050206 for TD 1539
RecordSet.executeSql("SELECT count(*) FROM Workflow_Report where reporttype="+id);
int typecount=0;
if(RecordSet.next()){
    typecount= RecordSet.getInt(1);
}
%>
<BODY style="overflow-y:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(!"1".equals(dialog)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",ReportTypeAdd.jsp,_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	
	if(typecount==0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/workflow/report/ReportTypeManage.jsp,_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%if("1".equals(dialog)){ %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
<%}%>
<FORM id=weaver name=frmMain action="ReportTypeOperation.jsp" method=post >

<%
if(msgid!=-1){
%>
  <DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="submitData()">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%>" id="zd_btn_cancle"  class="e8_btn_top" onclick="btn_cancle()">				
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>  
<wea:layout type="twoCol">
    <wea:group context=  '<%=SystemEnv.getHtmlLabelName(81711,user.getLanguage())%>'>
    	<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
	    <wea:item>
	    	<wea:required id="typenameimage" required="true" value='<%=typename%>'>
    			<input type=text size=30 class=Inputstyle name="typename" onchange='checkinput("typename","typenameimage")' value="<%=typename%>" style="width: 50%;">
    		</wea:required>
	    </wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
    	<wea:item><input type=text size=60 name="typedesc" class=Inputstyle value='<%=typedesc%>' style="width: 50%;"></wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></wea:item>
    	<wea:item>
    		<input type=text size=35 class=inputstyle id="typeorder" name="typeorder" maxlength=10 onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);" value="<%=typeorder%>" style="width: 50%;">
    	</wea:item>
    </wea:group>
</wea:layout>
<input type="hidden" name=operation value=reporttypeedit>
<input type="hidden" name="dialog" value="<%=dialog%>">
<input type="hidden" name=id value=<%=id%>>
</form>
 <%if("1".equals(dialog)){ %>
 <jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%} %>
<script language="javascript">
var dialog = parent.getDialog(window);
var parentWin = parent.getParentWindow(window);
function btn_cancle(){
	parentWin.closeDialog();
}

if("<%=isclose%>"==1){
	var dialog = parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	parentWin.location="/workflow/report/ReportTypeManageTab.jsp";
	parentWin.closeDialog();	
}

function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		document.frmMain.operation.value="reporttypedelete";
		document.frmMain.submit();
	}
}

function submitData()
{
	if (check_form(weaver,'typename'))
		weaver.submit();
}
</script>
</BODY></HTML>
