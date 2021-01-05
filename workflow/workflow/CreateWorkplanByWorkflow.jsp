<!DOCTYPE html>
<%@ page import="weaver.workflow.workflow.WfRightManager"%>
<%@ page import="weaver.workflow.workflow.UserWFOperateLevel"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.Constants"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<HTML>
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(19332,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(24086, user.getLanguage());
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
		int workflowid = Util.getIntValue(request.getParameter("wfid"),-1);
		WfRightManager wfrm = new WfRightManager();
		boolean haspermission = wfrm.hasPermission3(workflowid, 0, user, WfRightManager.OPERATION_CREATEDIR);
	    int detachable = Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0);
	    int subCompanyID= Util.getIntValue(Util.null2String(session.getAttribute(workflowid+"subcompanyid")),-1);
	    int operateLevel = UserWFOperateLevel.checkUserWfOperateLevel(detachable,subCompanyID,user,haspermission,"WorkflowManage:All");
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

%>

<FORM name="CreateWorkplanByWorkflow" method="post" action="CreateWorkplanByWorkflowOperation.jsp" >
<wea:layout type="twoCol">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(22125, user.getLanguage())%>' attributes="{'groupOperDisplay':'none'}">
		<wea:item type="groupHead">
			<input class="addbtn" type="button" onclick="addWPRow();" title="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>"></input>
			<input class="delbtn" type="button" onclick="delWPRow();" title="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"></input>
		</wea:item>    			
		<wea:item attributes="{'isTableList':'true'}">
			
			<% 
			String  operateString= "";
			operateString = "<operates width=\"20%\">";
			 	       operateString+=" <popedom isalwaysshow=\"true\"></popedom> ";
			 	       operateString+="     <operate  isalwaysshow=\"true\" href=\"javascript:detailConfig_wp();\" text=\""+SystemEnv.getHtmlLabelName(19342,user.getLanguage())+"\" index=\"0\"/>";
			 	       operateString+="     <operate  isalwaysshow=\"true\" href=\"javascript:delWPRow();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
			 	       operateString+="</operates>";	
			 String tabletype="checkbox";
			 String sqlWhere = " wfid = "+ workflowid;
			String tableString=""+
			   "<table  needPage=\"false\" instanceid=\"chooseSubWorkflow\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_CREATEWORKPLANBYWORKFLOW,user.getUID())+"\" tabletype=\""+tabletype+"\">"+
			    " <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.general.KnowledgeTransMethod.getMailCheckbox\" />"+
			   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"workflow_createplan\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
			   operateString+
			   "<head>"+							 
					 "<col width=\"25%\" transmethod=\"weaver.workflow.workflow.WFNodeTransMethod.getNodeName\" text=\""+SystemEnv.getHtmlLabelNames("22121",user.getLanguage())+"\" column=\"nodeid\"/>"+
					 "<col width=\"25%\" transmethod=\"weaver.workflow.workflow.WFNodeTransMethod.getChangeTimeLabel\" column=\"changetime\"  otherpara=\""+user.getLanguage()+"\" text=\""+SystemEnv.getHtmlLabelNames("22122",user.getLanguage())+"\"/>"+
					 "<col width=\"25%\" transmethod=\"weaver.workflow.workflow.WFNodeTransMethod.getTriggerType\" column=\"changemode\" otherpara=\"column:changetime+"+user.getLanguage()+"\" text=\""+SystemEnv.getHtmlLabelNames("22053",user.getLanguage())+"\"/>"+
					 "<col width=\"25%\"  transmethod=\"weaver.workflow.workflow.WFNodeTransMethod.getPlanType\"  column=\"plantypeid\" text=\""+SystemEnv.getHtmlLabelNames("16094",user.getLanguage())+"\"/>"+
			   "</head>"+
			   "</table>";
				%>
			<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>
		</wea:item>
	</wea:group>    
</wea:layout>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_WORKFLOW_CREATEWORKPLANBYWORKFLOW %>"/>
<INPUT type="hidden" id="workflowid" name="workflowid" value="<%=workflowid%>">
<INPUT type="hidden" id="wfid" name="wfid" value="<%=workflowid%>">
<INPUT type="hidden" id="formID" name="formID" value="<%=formID%>">
<INPUT type="hidden" id="isbill" name="isbill" value="<%=isbill%>">
<input type="hidden" id="operationType" name="operationType" value="">    
<input type="hidden" name="subCompanyId" value="<%=subCompanyID %>">    
</FORM>
<script type="text/javascript">
function onchangeNodeid2(obj, tabform){
	var nodetype = obj.options.item(obj.selectedIndex).nodeType;
	//
	if(nodetype == "0"){
		//alert(nodetype);
		tabform.changetime.disabled = true;
		tabform.changetime.options[1].selected = true;
		tabform.changetimeinput.value="2";
	}else if(nodetype == "3"){
		//alert(nodetype);
		tabform.changetime.disabled = true;
		tabform.changetime.options[0].selected = true;
		tabform.changetimeinput.value="1";
	}else{
		tabform.changetime.disabled = false;
		tabform.changetime.options[0].selected = true;
		tabform.changetimeinput.value="0";
	}
}

var diag_vote = null;

function closeDialog(id){
	if(diag_vote){
		diag_vote.close();
	}
	if(id>0){
		detailConfig_wp(id);
	}
}

function addWPRow(id){
	//CreateWorkplanByWorkflow.operationType.value = "add";
	//CreateWorkplanByWorkflow.submit();
	var title = "";
	var url = "";
	title = "<%=SystemEnv.getHtmlLabelNames("611,33526",user.getLanguage())%>";
	url="/docs/tabs/DocCommonTab.jsp?dialog=1&_fromURL=68&wfid=<%=workflowid %>&id="+id;
	
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

function delWPRow(id){
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>",function(){
		jQuery.ajax({
			url:"CreateWorkplanByWorkflowOperation.jsp",
			type:"post",
			data:{
				id:id,
				operationType:"del",
				wfid:"<%=workflowid%>"
			},
			beforeSend:function(xhr){
				try{
					e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(83165,user.getLanguage())%>...",true);
				}catch(e){}
			},
			complete:function(xhr){
				e8showAjaxTips("",false);
			},
			success:function(data){
				_table.reLoad();
			}
		});
	});
}

function detailConfig_wp(id_cp){
	//window.location = "/workflow/workflow/CreateWorkplanByWorkflowDetail.jsp?ajax=1&id="+id_cp+"&wfid="+workflowid;
	var title = "";
	var url = "";
	title = "<%=SystemEnv.getHtmlLabelNames("19342",user.getLanguage())%>";
	url="/docs/tabs/DocCommonTab.jsp?ajax=1&dialog=1&_fromURL=69&wfid=<%=workflowid %>&id="+id_cp;
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
</script>
</BODY>
</HTML>
