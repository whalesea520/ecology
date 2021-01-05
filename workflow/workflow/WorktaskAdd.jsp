<!DOCTYPE html>
<%@ page import="weaver.workflow.workflow.WfRightManager"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.Constants"%>
<%@ page import="weaver.workflow.workflow.UserWFOperateLevel"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="wfrm" class="weaver.workflow.workflow.WfRightManager" scope="page" />
<HTML>
<%
int workflowid = Util.getIntValue(request.getParameter("wfid"),-1);
boolean haspermission = wfrm.hasPermission3(workflowid, 0, user, WfRightManager.OPERATION_CREATEDIR);
String rightStr = "WorkflowManage:All";
if (!HrmUserVarify.checkUserRight(rightStr, user) && !haspermission) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19332,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(24086, user.getLanguage());
String needfav = "";
String needhelp = "";
String dialog = Util.null2String(request.getParameter("dialog"));
String isclose = Util.null2String(request.getParameter("isclose"));
String isEntryDetail = Util.null2String(request.getParameter("isEntryDetail"));
int id = Util.getIntValue(request.getParameter("id"),-1);
if(recordSet.getDBType().equalsIgnoreCase("oracle")){
    recordSet.execute("select id from (select id from workflow_createtask where wfid="+workflowid+"  order by id desc ) where rownum = 1");
}else{
	recordSet.execute("select top 1 id from workflow_createtask where wfid="+workflowid+" order by id desc");
}
int id_ct = -1;
if(recordSet.next()){
    id_ct = Util.getIntValue(recordSet.getString("id"), 0);
}
%>
    <HEAD>
        <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
        <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
        <script type="text/javascript">
			var parentWin = null;
			var dialog = null;
			if("<%=dialog%>"==1){
				parentWin = parent.parent.getParentWindow(parent);
				dialog = parent.parent.getDialog(parent);
				function btn_cancle(){
					dialog.closeByHand();
				}
			}
			$(document).ready(function(){
			   onchangeNodeid($G("nodeid"),'CreateWorktaskByWorkflow');
			});
		
			if("<%=isclose%>"==1){
				parentWin = parent.parent.getParentWindow(parent);
				dialog = parent.parent.getDialog(parent);
				parentWin.location.reload();
				<%if(isEntryDetail.equals("1")){%>
				    try{
				        dialog.close();
					}catch(e){
					    parentWin.closeDialog(<%=id%>);
					}
					parentWin.detailConfig_wt(<%=id_ct%>,<%=Util.getIntValue(request.getParameter("wfid"),-1)%>);
				<%}else{%>
					dialog.close();
				<%}%>
			}
		</script>
    </HEAD>
<BODY>
<%if("1".equals(dialog)){ %>
<div class="zDialog_div_content">
<%}%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<%
    int detachable = Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0);
	int subCompanyID= Util.getIntValue(Util.null2String(session.getAttribute(workflowid+"subcompanyid")),-1);
    int operateLevel = UserWFOperateLevel.checkUserWfOperateLevel(detachable,subCompanyID,user,haspermission,rightStr);
    
	if(operateLevel < 1){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
        String formID = request.getParameter("formid");
        String isbill = request.getParameter("isbill");
		int errorMessage = Util.getIntValue(request.getParameter("errorMessage"), 0);
		String errorStr = "";
		if(errorMessage == 1){
			errorStr = "<font color=\"#FF0000\">"+SystemEnv.getHtmlLabelName(22119, user.getLanguage())+"</font>";
		}

		if(formID==null||formID.trim().equals("")){
			formID=WorkflowComInfo.getFormId(""+workflowid);
		}
 		if(isbill==null||isbill.trim().equals("")){
			isbill=WorkflowComInfo.getIsBill(""+workflowid);
		}
		if(!"1".equals(isbill)){
			isbill="0";
		}

		Hashtable nodename_hs = new Hashtable();
		Hashtable taskname_hs =  new Hashtable();
%>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onSave(0);">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" class="e8_btn_top" onclick="onSave(1);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<FORM name="CreateWorktaskByWorkflow" method="post" action="CreateWorktaskByWorkflowOperation.jsp" >
<%
	String disabledStr = "";
	String select1Str = "";
	String select2Str = "";
	String changetimeinputValue = "1";
	int c = 0;
 %>
<wea:layout type="twoCol">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(22120, user.getLanguage())%>'>
    	<wea:item><%=SystemEnv.getHtmlLabelName(22121, user.getLanguage())%></wea:item>
	    <wea:item>
		<%
			out.println("<select id=\"nodeid\" name=\"nodeid\" onChange=\"onchangeNodeid(this, CreateWorktaskByWorkflow)\">");
			recordSet.execute("select n.id, n.nodename, f.nodetype from workflow_nodebase n, workflow_flownode f where (n.IsFreeNode is null or n.IsFreeNode!='1') and f.nodeid=n.id and f.workflowid="+workflowid+" order by f.nodetype,n.id");
			while(recordSet.next()){
				int id_tmp = Util.getIntValue(recordSet.getString("id"), 0);
				String nodename_tmp = Util.null2String(recordSet.getString("nodename"));
				if(id_tmp == 0){
					continue;
				}
				int nodetype_tmp = Util.getIntValue(recordSet.getString("nodetype"), 0);
				if(c==0 && (nodetype_tmp==0 || nodetype_tmp==3)){
					disabledStr = " disabled ";
					if(nodetype_tmp == 0){
						select2Str = " selected ";
						changetimeinputValue = "2";
					}else if(nodetype_tmp == 3){
						select1Str = " selected ";
						changetimeinputValue = "1";
					}
				}
				nodename_hs.put("nodename_"+id_tmp, nodename_tmp);
				out.println("<option value=\""+id_tmp+"\" nodeType=\""+nodetype_tmp+"\">"+nodename_tmp+"</option>");
				c++;
			}
			out.println("</select>");
		%>
	    </wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(22122,user.getLanguage())%></wea:item>
    	<wea:item>
			<select id="changetime" name="changetime" onchange="dochangeChangeTime(this)" <%=disabledStr%>>
				<option value="1" <%=select1Str%>><%=SystemEnv.getHtmlLabelName(22123, user.getLanguage())%></option>
				<option value="2" <%=select2Str%>><%=SystemEnv.getHtmlLabelName(22124, user.getLanguage())%></option>
			</select>
			<input type="hidden" name="changetimeinput" id="changetimeinput" value="<%=changetimeinputValue%>">
    	</wea:item>
    	<wea:item attributes="{'samePair':'changemodetr1','display':'none'}"><%=SystemEnv.getHtmlLabelName(22053, user.getLanguage())%></wea:item>
    	<wea:item attributes="{'samePair':'changemodetr1','display':'none'}">
			<select id="changemode" name="changemode">
				<option value="0" ></option>
				<option value="1" ><%=SystemEnv.getHtmlLabelName(25361, user.getLanguage())%></option>
				<option value="2" ><%=SystemEnv.getHtmlLabelName(25362, user.getLanguage())%></option>
			</select>    	
    	</wea:item>
    	<wea:item attributes="{'samePair':'changemodetr0','display':'none'}"><%=SystemEnv.getHtmlLabelName(22053, user.getLanguage())%></wea:item>
    	<wea:item attributes="{'samePair':'changemodetr0','display':'none'}">
			<select id="changemode0" name="changemode0">
				<option value="0" ></option>
				<option value="1" ><%=SystemEnv.getHtmlLabelName(142, user.getLanguage())%></option>
				<option value="2" ><%=SystemEnv.getHtmlLabelName(236, user.getLanguage())%></option>
			</select>    	
    	</wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(18177, user.getLanguage())%></wea:item>
    	<wea:item>
		<%
			out.println("<select id=\"taskid\" name=\"taskid\" >");
			recordSet.execute("select * from worktask_base");
			while(recordSet.next()){
				int id_tmp = Util.getIntValue(recordSet.getString("id"), 0);
				String name_tmp = Util.null2String(recordSet.getString("name"));
				if(id_tmp == 0){
					continue;
				}
				taskname_hs.put("taskname_"+id_tmp, name_tmp);
				out.println("<option value=\""+id_tmp+"\">"+name_tmp+"</option>");
			}
			out.println("</select>");
		%>   	
    	</wea:item>
    	<% if(errorMessage==1){ %>
    	<wea:item><span in="errorMessage" name="errorMessage" ><%=errorStr%></span></wea:item>
    	<%} %>    	
    </wea:group>
</wea:layout>

<INPUT type="hidden" id="workflowid" name="workflowid" value="<%=workflowid%>">
<INPUT type="hidden" id="wfid" name="wfid" value="<%=workflowid%>">
<INPUT type="hidden" id="formID" name="formID" value="<%=formID%>">
<INPUT type="hidden" id="isbill" name="isbill" value="<%=isbill%>">
<input type="hidden" id="operationType" name="operationType" value="<%=id<=0?"add":"edit" %>"> 
<input type="hidden" name="dialog" value="<%=dialog%>">  
<input type="hidden" name="isEntryDetail" id="isEntryDetail" value="<%=isEntryDetail%>">     
<input type="hidden" name="subCompanyID" value="<%=subCompanyID%>">     
</FORM>
<%if("1".equals(dialog)){ %>
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
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>
<%} %>
<script type="text/javascript">
jQuery(document).ready(function(){
	jQuery("#oTable").find("tr[class=Spacing]:last").find("td").removeClass("paddingLeft18").addClass("paddingLeft0");
});
function onSave(isEntryDetail){
	enableAllmenu();
    $("#changetime").removeAttr("disabled");
	jQuery("#isEntryDetail").val(isEntryDetail);
	CreateWorktaskByWorkflow.submit();
}

function onchangeNodeid(obj, tabform){
	var nodetype =obj.options[obj.selectedIndex].getAttribute("nodeType");
	if(nodetype == "0"){
		$("#changetime").selectbox("detach");
        $("#changetime").val(2);
        $("#changetime").attr("disabled","disabled");
        $("#changetime").selectbox();
        hideEle("changemodetr1");
		hideEle("changemodetr0");
		$("#changetimeinput").val("2");
	}else if(nodetype == "3"){
		$("#changetime").selectbox("detach");
        $("#changetime").val(1);
        $("#changetime").attr("disabled","disabled");
        $("#changetime").selectbox();
        hideEle("changemodetr1");
		hideEle("changemodetr0");
		$("#changetimeinput").val("1");
	}else{
		$("#changetime").selectbox("detach");
		$("#changetime").val(0);
        $("#changetime").removeAttr("disabled");
        $("#changetime").selectbox();
		$("#changetimeinput").val("0");
		dochangeChangeTime($("#changetime"));
	}
}

function dochangeChangeTime(obj){
	jQuery('#changetime').val('1');
	var changetime_tmp = $(obj).val();
	if(changetime_tmp == "1"){
		showEle("changemodetr1");
		hideEle("changemodetr0");
	}else if(changetime_tmp == "2"){
		showEle("changemodetr0");
		hideEle("changemodetr1");
	}
}

</script>
</BODY>
</HTML>
