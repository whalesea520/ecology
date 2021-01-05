
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.system.code.*"%>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs4" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<%
	int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0); 
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission){
		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<%@ include file="/workflow/workflow/addwf_checktetachable.jsp" %>
<html>
<%
	String ajax=Util.null2String(request.getParameter("ajax"));
	String message=Util.null2String(request.getParameter("message"));
	if(message.equals("reset")) message = SystemEnv.getHtmlLabelName(22428,user.getLanguage());
	
	String ischecked = "";
	int triggerNum = 0;
	RecordSet.executeSql("select * from Workflow_DataInput_entry where WorkFlowID="+wfid);
	while(RecordSet.next()){
		triggerNum++;
		ischecked = " checked ";
	}
%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(21848,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
	function addFieldTrigger(entryId){
		var title = "";
		var url = "";
		title = "<%=SystemEnv.getHtmlLabelNames("21848,33508",user.getLanguage())%>";
		url="/docs/tabs/DocCommonTab.jsp?dialog=1&entryID="+entryId+"&_fromURL=67&ajax=<%=ajax%>&wfid=<%=wfid %>";
		
		diag_vote = new window.top.Dialog();
		diag_vote.currentWindow = window;
		diag_vote.Width = 800;
		diag_vote.Height = 600;
		diag_vote.maxiumnable = true;
		diag_vote.Modal = true;
		diag_vote.Title = title;
		diag_vote.URL = url;
		diag_vote.show();
	}
	
	function deleteFieldTrigger(id){
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
				url:"officalwf_operation.jsp",
				type:"post",
				data:{
					entryId:id,
					operation:"deleteTriggerEntry",
					wfid:"<%=wfid%>"
				},
				beforeSend:function(xhr){
					try{
						e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(84024, user.getLanguage())%>",true);
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
</script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%

	//if(!ajax.equals("1")){
    //    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:selectall(),_self} " ;
    //}else{
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:flowTriggerSave(this),_self} " ;
    //}
	RCMenuHeight += RCMenuHeightStep;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="frmTrigger" name="frmTrigger" method=post action="triggerOperation.jsp" >
	<input type="hidden" id="triggerNum" name="triggerNum" value="<%=triggerNum%>">
	<input type="hidden" id="wfid" name="wfid" value="<%=wfid%>">
	<div style="display:none">
	<table id="hidden_tab" cellpadding='0' width=0 cellspacing='0'>
	</table>
	</div>
<%
if(ajax.equals("1")){
%>
<input type="hidden" name="ajax" value="1">
<%}%>

<div id=setting>
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("21683,320",user.getLanguage())%>'>
			<wea:item type="groupHead">
				<input type=button class=addbtn onclick="addFieldTrigger()" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
	  			<input type=button class=delbtn onclick="deleteFieldTrigger()"title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>"></input>
			</wea:item>
			<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_WORKFLOW_FIELDTRIGGER %>"/>
			<wea:item attributes="{'isTableList':'true'}">
				<% 
					String  operateString= "";
					operateString = "<operates width=\"20%\">";
					operateString+=" <popedom isalwaysshow=\"true\"></popedom> ";
		 	        operateString+="     <operate  isalwaysshow=\"true\" href=\"javascript:addFieldTrigger();\" text=\""+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+"\" index=\"0\"/>";
		 	        operateString+="     <operate  isalwaysshow=\"true\" href=\"javascript:deleteFieldTrigger()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
		 	        operateString+="</operates>";	
					String tabletype="checkbox";
					String sqlWhere = " workflowid = "+ wfid;
					String tableString=""+
					   "<table  needPage=\"false\" instanceid=\"chooseSubWorkflow\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_FIELDTRIGGER,user.getUID())+"\" tabletype=\""+tabletype+"\">"+
					    " <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.general.KnowledgeTransMethod.getMailCheckbox\" />"+
					   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"Workflow_DataInput_entry\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
					   operateString+
					   "<head>"+							 
							 "<col width=\"40%\" transmethod=\"weaver.general.KnowledgeTransMethod.getTriggerEditLink\"  otherpara=\"column:id+column:triggerFieldName+column:type+column:WorkflowID+"+user.getLanguage()+"\" text=\""+SystemEnv.getHtmlLabelNames("21805,22009",user.getLanguage())+"\" column=\"triggerName\"/>"+
							 "<col width=\"30%\" transmethod=\"weaver.general.KnowledgeTransMethod.getTriggerFieldName\" otherpara=\"column:type+column:WorkflowID+"+user.getLanguage()+"\" column=\"triggerFieldName\" text=\""+SystemEnv.getHtmlLabelNames("21805,261",user.getLanguage())+"\"/>"+
							 "<col width=\"30%\" transmethod=\"weaver.general.KnowledgeTransMethod.getTriggetTableTypeNew\" otherpara=\"column:triggerFieldName+column:WorkflowID+"+user.getLanguage()+"\" column=\"type\" text=\""+SystemEnv.getHtmlLabelNames("33507",user.getLanguage())+"\"/>"+
					   "</head>"+
					   "</table>";
				%>
				<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</form>
</body>
</html>
