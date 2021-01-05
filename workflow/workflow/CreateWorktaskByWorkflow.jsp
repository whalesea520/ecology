<!DOCTYPE html>
<%@page import="weaver.workflow.workflow.WfRightManager"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.workflow.UserWFOperateLevel" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="wfrm" class="weaver.workflow.workflow.WfRightManager" scope="page" />
<STYLE TYPE="text/css">
.btn_RequestSubmitList {BORDER-RIGHT: #7b9ebd 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #7b9ebd 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 12px; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#cecfde); BORDER-LEFT: #7b9ebd 1px solid; CURSOR: hand; COLOR: black; PADDING-TOP: 2px; BORDER-BOTTOM: #7b9ebd 1px solid 
} 
</STYLE>
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />


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
    String titlename = SystemEnv.getHtmlLabelName(19332,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(22118, user.getLanguage());
    String needfav = "";
    String needhelp = "";
%>
    <HEAD>
        <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
        <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
    </HEAD>
<BODY>
<%@ include file="/workflow/workflow/addwf_checktetachable.jsp" %>
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

<FORM name="CreateWorktaskByWorkflow" method="post" action="CreateWorktaskByWorkflowOperation.jsp" >
<%
	String disabledStr = "";
	String select1Str = "";
	String select2Str = "";
	String changetimeinputValue = "1";
	int c = 0;
    //查询有效node节点
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
		c++;
	}
	//查询有效task节点
	recordSet.execute("select * from worktask_base");
	while(recordSet.next()){
		int id_tmp = Util.getIntValue(recordSet.getString("id"), 0);
		String name_tmp = Util.null2String(recordSet.getString("name"));
		if(id_tmp == 0){
			continue;
		}
		taskname_hs.put("taskname_"+id_tmp, name_tmp);
	}
 %>
<wea:layout type="twoCol">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(22125, user.getLanguage())%>' attributes="{'groupOperDisplay':'none'}">
		<wea:item type="groupHead">
			<button class="addbtn" type="button" onclick="addWTRow();" title="<%=SystemEnv.getHtmlLabelName(456, user.getLanguage())%>"></button>
			<button class="delbtn" type="button" onclick="delWTRow();" title="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"></button>
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
			<table class="ListStyle" cellspacing=0 id="oTable">
				<COLGROUP>
					<COL width="4%">
					<COL width="20%">
					<COL width="20%">
					<COL width="20%">
					<COL width="20%">
					<COL width="16%">
				</COLGROUP>
				<tr class="header">
					<th><input type="checkbox" id="checkboxall" name="checkboxall" onclick="checkboxAll(this)"></th>
					<th><%=SystemEnv.getHtmlLabelName(22121, user.getLanguage())%></th>
					<th><%=SystemEnv.getHtmlLabelName(22122, user.getLanguage())%></th>
					<th><%=SystemEnv.getHtmlLabelName(22053, user.getLanguage())%></th>
					<th><%=SystemEnv.getHtmlLabelName(18177, user.getLanguage())%></th>
					<th><%=SystemEnv.getHtmlLabelName(19342, user.getLanguage())%></th>
				</tr>
				<%
					boolean isLight = true;
					String classStr = "";
					recordSet.execute("select * from workflow_createtask where wfid="+workflowid);
					while(recordSet.next()){
						int id_tmp = Util.getIntValue(recordSet.getString("id"), 0);
						int changetime_tmp = Util.getIntValue(recordSet.getString("changetime"), 0);
						int taskid_tmp = Util.getIntValue(recordSet.getString("taskid"), 0);
						int nodeid_tmp = Util.getIntValue(recordSet.getString("nodeid"), 0);
						String nodename_tmp = Util.null2String((String)nodename_hs.get("nodename_"+nodeid_tmp));
						String taskname_tmp = Util.null2String((String)taskname_hs.get("taskname_"+taskid_tmp));
						String changetimeStr = "";
						if(changetime_tmp == 1){
							changetimeStr = SystemEnv.getHtmlLabelName(22123, user.getLanguage());//到达节点
						}else if(changetime_tmp == 2){
							changetimeStr = SystemEnv.getHtmlLabelName(22124, user.getLanguage());//离开节点
						}
						int changemode_tmp = Util.getIntValue(recordSet.getString("changemode"), 0);
						String changemodeStr_tmp = "";
						if(changetime_tmp == 1){
							if(changemode_tmp == 1){
								changemodeStr_tmp = SystemEnv.getHtmlLabelName(25361, user.getLanguage());
							}else if(changemode_tmp == 2){
								changemodeStr_tmp = SystemEnv.getHtmlLabelName(25362, user.getLanguage());
							}
						}else{
							if(changemode_tmp == 1){
								changemodeStr_tmp = SystemEnv.getHtmlLabelName(142, user.getLanguage());
							}else if(changemode_tmp == 2){
								changemodeStr_tmp = SystemEnv.getHtmlLabelName(236, user.getLanguage());
							}
						}
						if("".equals(nodename_tmp.trim()) || "".equals(taskname_tmp.trim())){
							//清空冗余数据，如果该节点已不属于该流程或计划任务类型已不存在
							//rs.execute("delete from workflow_createtask where id="+id_tmp);
							continue;
						}
						if("".equals(changemodeStr_tmp)) changemodeStr_tmp ="&nbsp;";
						out.println("<tr"+classStr+">");
						out.println("<td><input type=\"checkbox\" id=\"checkbox1\" name=\"checkbox1\" value=\""+id_tmp+"\"></td>");
						out.println("<td>"+nodename_tmp+"</td>");
						out.println("<td>"+changetimeStr+"</td>");
						out.println("<td>"+changemodeStr_tmp+"</td>");
						out.println("<td>"+taskname_tmp+"</td>");
						out.println("<td><a href=\"#\" onClick=\"detailConfig_wt("+id_tmp+", "+workflowid+")\" >"+SystemEnv.getHtmlLabelName(19342, user.getLanguage())+"</a></td>");
						out.println("</tr>"); 
				%>
				<tr class='Spacing' style="height:1px!important;"><td colspan=6 class='paddingLeft18'><div class='intervalDivClass'></div></td></tr>
				<%}%>
			</table>   				
		</wea:item>
	</wea:group>    
</wea:layout>

<INPUT type=hidden id='workflowid' name='workflowid' value=<%=workflowid%>>
<INPUT type=hidden id="wfid" name="wfid" value=<%=workflowid%>>
<INPUT type=hidden id='formID' name='formID' value=<%=formID%>>
<INPUT type=hidden id='isbill' name='isbill' value=<%=isbill%>>
<input type="hidden" id="operationType" name="operationType">
<input type="hidden" name="subCompanyID" value="<%=subCompanyID %>">
   
</FORM>
<script type="text/javascript">
jQuery(document).ready(function(){
	jQuery("#oTable").find("tr[class=Spacing]:last").find("td").removeClass("paddingLeft18").addClass("paddingLeft0");
});

function addWTRow(id){
	var title = "";
	var url = "";
	title = "<%=SystemEnv.getHtmlLabelNames("611,33526",user.getLanguage())%>";
	url="/docs/tabs/DocCommonTab.jsp?dialog=1&_fromURL=81&wfid=<%=workflowid %>&id="+id+"&subCompanyID=<%=subCompanyID%>";
	
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 500;
	if(id){
		diag_vote.Height = 400;
	}else{
		diag_vote.Height = 400;
	}
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL = url;
	diag_vote.show();
}

function delWTRow(){
	if(isdel()){
		CreateWorktaskByWorkflow.operationType.value = "del";
		CreateWorktaskByWorkflow.submit();
	}
}

function detailConfig_wt(id_ct, workflowid){
	var title = "";
	var url = "";
	title = "<%=SystemEnv.getHtmlLabelNames("19342",user.getLanguage())%>";
	url="/docs/tabs/DocCommonTab.jsp?dialog=1&_fromURL=82&id="+id_ct+"&wfid="+workflowid+"&subCompanyID=<%=subCompanyID%>";;	
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 500;
	diag_vote.maxiumnable = true;
	diag_vote.Height = 600;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL = url;
	diag_vote.show();
}
function checkboxAll(obj){
	if(obj.checked){
		$("input[name='checkbox1']").each(function(){
			var ck = $(this);
			    ck.attr("checked",true);
			    $(ck).next().addClass("jNiceChecked");
		});
	}else{
		$("input[name='checkbox1']").each(function(){
			var ck = $(this);
			    ck.attr("checked",false);
			    $(ck).next().removeClass("jNiceChecked")
		});	
	}
}
</script>
</BODY>
</HTML>
