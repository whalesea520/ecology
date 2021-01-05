
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.system.code.CodeBuild"%>
<%@ page import="weaver.system.code.CoderBean"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />


<html>
<%

boolean canEdit=false;
if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
	canEdit=true;
}

int workflowId=Util.getIntValue(Util.null2String(request.getParameter("workflowId")),0);
int formId=Util.getIntValue(Util.null2String(request.getParameter("formId")),0);
String isBill=Util.null2String(request.getParameter("isBill"));
if(!isBill.equals("1")){
	isBill="0";
}

String recordId = "";
String sequenceId = "";
ArrayList coderMemberList = null;

CodeBuild cbuild = new CodeBuild(formId,isBill,workflowId);	
CoderBean cb = cbuild.getFlowCBuild();
coderMemberList = cb.getMemberList();
String fieldIdSelect = "";
String fieldValue = "";
String departmentFieldId = "";
String subCompanyFieldId = "";
String supSubCompanyFieldId = "";
String yearFieldId = "";
String monthFieldId = "";
String dateFieldId = "";

for (int i=0;i<coderMemberList.size();i++){
	String[] codeMembers = (String[])coderMemberList.get(i);
	String codeMemberName = codeMembers[0];
	String codeMemberValue = codeMembers[1];
	String codeMemberType = codeMembers[2];
	String concreteField = codeMembers[3];
	String enablecode = codeMembers[4];
	if(codeMemberType.equals("5") && concreteField.equals("0")){
		fieldIdSelect = String.valueOf(Util.getIntValue(codeMemberValue, -1));
	}else if(codeMemberType.equals("5") && concreteField.equals("1")){
		departmentFieldId = String.valueOf(Util.getIntValue(codeMemberValue, -1));
		//departmentFieldId = Util.getIntValue(codeMemberValue, -1);
	}else if(codeMemberType.equals("5") && concreteField.equals("2")){
		subCompanyFieldId = String.valueOf(Util.getIntValue(codeMemberValue, -1));
		//subCompanyFieldId = Util.getIntValue(codeMemberValue, -1);
	}else if(codeMemberType.equals("5") && concreteField.equals("3")){
		supSubCompanyFieldId = String.valueOf(Util.getIntValue(codeMemberValue, -1));
		//supSubCompanyFieldId = Util.getIntValue(codeMemberValue, -1);
	}else if(codeMemberType.equals("5") && concreteField.equals("4")){
		yearFieldId = String.valueOf(Util.getIntValue(codeMemberValue, -1));
		//yearFieldId = Util.getIntValue(codeMemberValue, -1);
	}else if(codeMemberType.equals("5") && concreteField.equals("5")){
		monthFieldId = String.valueOf(Util.getIntValue(codeMemberValue, -1));
		//monthFieldId = Util.getIntValue(codeMemberValue, -1);
	}else if(codeMemberType.equals("5") && concreteField.equals("6")){
		dateFieldId = String.valueOf(Util.getIntValue(codeMemberValue, -1));
		//dateFieldId = Util.getIntValue(codeMemberValue, -1);
	}
}


if(recordId.equals("")){
	int tempWorkflowId=-1;
	int tempFormId=-1;
	String tempIsBill="0";
	String tempYearId="-1";
	String tempMonthId="-1";
	String tempDateId="-1";
	
	String tempFieldId="-1";
	String tempFieldValue="-1";
	
	String tempSupSubCompanyId="-1";
	String tempSubCompanyId="-1";
	String tempDepartmentId="-1";
	
	int tempRecordId=-1;
	int tempSequenceId=1;
	
	String workflowSeqAlone=cb.getWorkflowSeqAlone();
	String dateSeqAlone=cb.getDateSeqAlone();
	String dateSeqSelect=cb.getDateSeqSelect();
	String fieldSequenceAlone=cb.getFieldSequenceAlone();
	String struSeqAlone=cb.getStruSeqAlone();
	String struSeqSelect=cb.getStruSeqSelect();
	
	if("1".equals(workflowSeqAlone)){
		tempWorkflowId=workflowId;
	}else{
		tempFormId=formId;
	    tempIsBill=isBill;
	}
	
	if("1".equals(dateSeqAlone)&&"1".equals(dateSeqSelect)){
		tempYearId=yearFieldId;
	}else if("1".equals(dateSeqAlone)&&"2".equals(dateSeqSelect)){
		tempYearId=yearFieldId;
		tempMonthId=monthFieldId;						
	}else if("1".equals(dateSeqAlone)&&"3".equals(dateSeqSelect)){
		tempYearId=yearFieldId;						
		tempMonthId=monthFieldId;	
		tempDateId=dateFieldId;							
	}
					
	if("1".equals(fieldSequenceAlone)&&!fieldIdSelect.equals("-1") ){
		tempFieldId=fieldIdSelect;
		tempFieldValue=fieldValue;
	}
					
	if("1".equals(struSeqAlone)&&"1".equals(struSeqSelect)){
		tempSupSubCompanyId=supSubCompanyFieldId;
		tempSubCompanyId="-1";
		tempDepartmentId="-1";						
	}
	if("1".equals(struSeqAlone)&&"2".equals(struSeqSelect)){
		tempSupSubCompanyId="-1";
		tempSubCompanyId=subCompanyFieldId;
		tempDepartmentId="-1";						
	}
	if("1".equals(struSeqAlone)&&"3".equals(struSeqSelect)){
		tempSupSubCompanyId="-1";
		tempSubCompanyId="-1";
		tempDepartmentId=departmentFieldId;						
	}

	RecordSet.executeSql("select id,sequenceId from workflow_codeSeq where workflowId="+tempWorkflowId+" and formId="+tempFormId+" and isBill='"+tempIsBill+"' and yearId="+tempYearId+" and monthId="+tempMonthId+" and dateId="+tempDateId+" and fieldId="+tempFieldId+" and fieldValue="+tempFieldValue+" and supSubCompanyId="+tempSupSubCompanyId+" and subCompanyId="+tempSubCompanyId+" and departmentId="+tempDepartmentId);

	if(RecordSet.next()){
		tempRecordId=Util.getIntValue(RecordSet.getString("id"),-1);
		tempSequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);						
	}
    if(tempRecordId>0){
		recordId = tempRecordId+"";
		sequenceId = tempSequenceId+"";
	}else{
	    RecordSet.executeSql("select id,sequenceId from workflow_codeSeq where workflowId="+tempWorkflowId+" and formId="+tempFormId+" and isBill='"+tempIsBill+"' and yearId="+tempYearId+" and monthId="+tempMonthId+" and dateId="+tempDateId+" and fieldId="+tempFieldId+" and fieldValue="+tempFieldValue+" and supSubCompanyId="+tempSupSubCompanyId+" and subCompanyId="+tempSubCompanyId+" and departmentId="+tempDepartmentId);

	    if(RecordSet.next()){
		    tempRecordId=Util.getIntValue(RecordSet.getString("id"),-1);
		    tempSequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),-1);
	    }
        if(tempRecordId>0){
		    recordId = tempRecordId+"";
		    sequenceId = tempSequenceId+"";
	    }
	}
}

if(recordId.equals("")){
	recordId = String.valueOf(workflowId);
}


 %>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var dialog = parent.getDialog(window);
var parentWin = parent.getParentWindow(window);
</script>
<%
String dialog = Util.null2String(request.getParameter("dialog"));
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(22779,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
</head>

<body>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearchCodeSeqReservedSet(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content" style="height: 100%!important;">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(22779,user.getLanguage()) %>"/>
</jsp:include>
<form id="formCodeSeqSet" name="formCodeSeqSet" method=post action="WorkflowCodeSeqSetOperation.jsp" >
<input name=workflowId type=hidden value="<%=workflowId%>">
<input name=formId type=hidden value="<%=formId%>">
<input name=isBill type=hidden value="<%=isBill%>">
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_WORKFLOW_WORKFLOWSUBWFSET %>"/>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>" id="zd_btn_cancle"  class="e8_btn_top" onclick="creatNewCode(<%=workflowId%>,<%=formId%>,<%=isBill%>)">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" id="zd_btn_cancle"  class="e8_btn_top" onclick="deltype()">
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<%
String sqlWhere  = " where codeSeqId ="+recordId;
String tableString = "";
int perpage=10;                                 
String backfields = " id,codeSeqId,reservedCode,reservedDesc ";
String fromSql  = " workflow_codeSeqReserved "; 
tableString =   " <table instanceid=\"workflowCodeSeqTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_WORKFLOWSUBWFSET,user.getUID())+"\" >"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlprimarykey=\"id\" sqlsortway=\"ASC\" sqlisdistinct=\"false\" />"+
                "       <head>"+
                "           <col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(22779,user.getLanguage())+"\" column=\"reservedCode\" orderkey=\"reservedCode\" />"+
                "           <col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"reservedDesc\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.system.code.CodeBuild.getWFCodeDesc\"/>"+
                "       </head>"+ 
                "		<operates>"+                
               // "		<popedom column=\"id\"></popedom> "+
				"		<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"		</operates>"+                               
                " </table>";
%>
<wea:layout type="2Col">
	<wea:group context="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>">
		<wea:item><%=SystemEnv.getHtmlLabelName(125356,user.getLanguage()) %></wea:item>
		<wea:item><%=sequenceId %></wea:item>
	</wea:group>
	<wea:group context="<%=SystemEnv.getHtmlLabelName(22779,user.getLanguage()) %>">
		<wea:item attributes="{'isTableList':'true'}">
			<TABLE width="100%" cellspacing=0>
				<tr>
			  		<td valign="top">  
			      		<wea:SplitPageTag  tableString="<%=tableString%>"  mode="run" />
			   		</td>
				</tr>
			</TABLE>
		</wea:item>
	</wea:group>
</wea:layout>
</form>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()" style="width: 60px!important;">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</div>
</body>
</html>
<Script language=javascript>
function onShowViewReservedCode(workflowId,formId,isBill,yearId,monthId,dateId,fieldId,fieldValue,supSubCompanyId,subCompanyId,departmentId,recordId){

    var url="/workflow/workflow/showViewReservedCodeOperate.jsp?workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId;	
    url = "/systeminfo/BrowserMain.jsp?url="+url;
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	//dialog.callbackfunParam = {id:"test", name:"testname"};
	dialog.URL = url;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(22779,user.getLanguage()) + SystemEnv.getHtmlLabelName(33564,user.getLanguage())%>";
	dialog.Width = 550 ;
	dialog.Height = 550 ;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.show();
}

function onShowNewReservedCode(workflowId,formId,isBill,yearId,monthId,dateId,fieldId,fieldValue,supSubCompanyId,subCompanyId,departmentId,recordId){
    var url=encode("/workflow/workflow/showNewReservedCodeOperate.jsp?workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId);	
    url = "/systeminfo/BrowserMain.jsp?url="+url;
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	//dialog.callbackfunParam = {id:"test", name:"testname"};
	dialog.URL = url;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(365,user.getLanguage()) + SystemEnv.getHtmlLabelName(22779,user.getLanguage())%>";
	dialog.Width = 550 ;
	dialog.Height = 550 ;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.show();
}

function creatNewCode(workflowId,formId,isBill){

    var url=encode("/workflow/workflow/WFCodeReserved.jsp?workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill);	
    url = "/systeminfo/BrowserMain.jsp?url="+url;
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	//dialog.callbackfunParam = {id:"test", name:"testname"};
	dialog.URL = url;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(365,user.getLanguage()) + SystemEnv.getHtmlLabelName(22779,user.getLanguage())%>";
	dialog.Width = 550 ;
	dialog.Height = 550 ;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.show();
}

function onDel(id){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		window.location = "/workflow/workflow/WorkflowCodeSeqSetOperation.jsp?id="+id+"&actionKey=del&workflowId=<%=workflowId%>&formId=<%=formId%>&isBill=<%=isBill%>";
	}, function () {}, 320, 90,true);
}

function deltype(){
	var ids = "";
	$("input[name='chkInTableTag']").each(function(){
		if($(this).attr("checked")){
			ids = ids +$(this).attr("checkboxId")+",";
		}
	});
	if(ids==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
		return false;
	}
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		window.location = "/workflow/workflow/WorkflowCodeSeqSetOperation.jsp?ids="+ids+"&actionKey=deleteAll&workflowId=<%=workflowId%>&formId=<%=formId%>&isBill=<%=isBill%>";
	}, function () {}, 320, 90,true);
}

function encode(str){
    return escape(str);
}
</script>