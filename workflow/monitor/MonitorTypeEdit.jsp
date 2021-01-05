<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
if (!HrmUserVarify.checkUserRight("WorkflowMonitor:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>

<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
	</head>
	<%
		int msgid = Util.getIntValue(request.getParameter("msgid"), -1);
		String dialog = Util.null2String(request.getParameter("dialog"));
		String isclose = Util.null2String(request.getParameter("isclose"));

		String imagefilename = "/images/hdHRMCard_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(2239, user.getLanguage());
		String needfav = "1";
		String needhelp = "";

		String id = Util.null2String(request.getParameter("id"));
		RecordSet.executeSql("select * from Workflow_MonitorType where id = " + id);
		RecordSet.next();

		String typename = Util.toScreen(RecordSet.getString("typename"), user.getLanguage());
		String typedesc = Util.toScreen(RecordSet.getString("typedesc"), user.getLanguage());
		String typeorder = Util.null2String(RecordSet.getString("typeorder"));

		RecordSet.executeSql("SELECT count(*) FROM workflow_monitor_info where monitortype=" + id);
		int typecount = 0;
		if (RecordSet.next())
		{
			typecount = RecordSet.getInt(1);
		}
		//boolean isedit = false;
		//if(user.getUID()==1) isedit = true;
		boolean isedit = true;
	%>
	<BODY style="overflow:hidden;">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		//if(!"1".equals(dialog)){
			//if(user.getUID()==1){
				RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:submitData(),_self} ";
				RCMenuHeight += RCMenuHeightStep;
				
				//RCMenu += "{" + SystemEnv.getHtmlLabelName(82, user.getLanguage()) + ",MonitorTypeAdd.jsp,_self} ";
				//RCMenuHeight += RCMenuHeightStep;
				
				//if (typecount == 0)
				//{
					RCMenu += "{" + SystemEnv.getHtmlLabelName(201, user.getLanguage()) + ",javascript:btn_cancle(),_self} ";
					RCMenuHeight += RCMenuHeightStep;
				//}				
			//}
			//RCMenu += "{" + SystemEnv.getHtmlLabelName(1290, user.getLanguage()) + ",/workflow/monitor/CustomMonitorType.jsp,_self} ";
			//RCMenuHeight += RCMenuHeightStep;
		//}
		%>

		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if("1".equals(dialog)){ %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
<%}%>		
<FORM id=weaver name=frmMain action="MonitorTypeOperation.jsp" method=post>
<%
if (msgid != -1){
%>
<DIV>
	<font color=red size=2> <%=SystemEnv.getErrorMsgName(msgid, user.getLanguage())%>
	</font>
</DIV>
<%}%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
	<td class="rightSearchSpan" style="text-align:right; width:500px!important">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="submitData()">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(32694 ,user.getLanguage())%>" id="zd_btn_cancle"  class="e8_btn_top" onclick="btn_cancle()">				
			<span title="<%=SystemEnv.getHtmlLabelName(83721 ,user.getLanguage())%>" class="cornerMenu"></span>
		</td>												  
	</tr>
</table>
<wea:layout type="twoCol">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(81711 ,user.getLanguage())%>'>	 
    	<wea:item><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></wea:item>
	    <wea:item>
	    	<wea:required id="typenameimage" required="true" value='<%=typename%>'>
	    		<%if(isedit){ %><input type=text class=Inputstyle size=30 name="typename" onchange='checkinput("typename","typenameimage")' value="<%=typename%>"><%}else{ %><%=typename%><%} %>
	    	</wea:required>
	    </wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
    	<wea:item><%if(isedit){ %><input type=text class=Inputstyle size=60 name="typedesc" value='<%=typedesc%>'><%}else{ %><%=typedesc%><%} %></wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(15513, user.getLanguage())%></wea:item>
    	<wea:item>
    		<%if(isedit){ %><input type=text size=10 class=inputstyle id="typeorder" name="typeorder" maxlength=3 value="<%=typeorder%>" onKeyPress="ItemNum_KeyPress()" onBlur="checknumber1(this);"><%}else{ %><%=typeorder%><%} %>
    	</wea:item>
    </wea:group>
</wea:layout>

<input type="hidden" name=operation value=edit>
<input type="hidden" name=id value=<%=id%>>
<input type="hidden" name="dialog" value="<%=dialog%>">
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
<script>
var dialog = parent.getDialog(window);
var parentWin = parent.getParentWindow(window);
function btn_cancle(){
	parentWin.closeDialog();
}

if("<%=isclose%>"==1){
	var dialog = parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	parentWin.location="/workflow/monitor/CustomMonitorTypeTab.jsp";
	parentWin.closeDialog();	
}
function onDelete()
{
	if(confirm("<%=SystemEnv.getHtmlNoteName(7, user.getLanguage())%>")) 
	{
		document.frmMain.operation.value="delete";
		document.frmMain.submit();
	}
}
function submitData()
{
	if (check_form(weaver,'typename'))
		weaver.submit();
}
</script>
</BODY>
</HTML>
