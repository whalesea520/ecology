<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.system.code.CodeBuild"%>
<%@ page import="weaver.system.code.CoderBean"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<html>
<%
	boolean canEdit=false;
	if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		canEdit=true;
	}

    String ajax=Util.null2String(request.getParameter("ajax"));
	int workflowId=Util.getIntValue(Util.null2String(request.getParameter("workflowId")),0);
	int formId=Util.getIntValue(Util.null2String(request.getParameter("formId")),0);
	String isBill=Util.null2String(request.getParameter("isBill"));
	int fieldId=Util.getIntValue(request.getParameter("fieldId"),0);
	String isclose=Util.null2String(request.getParameter("isclose"));

    CodeBuild codeBuild = new CodeBuild(formId,isBill,workflowId);
	boolean isWorkflowSeqAlone=codeBuild.isWorkflowSeqAlone(RecordSet,workflowId);
	int rowNum=0;
%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(33872,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(690,user.getLanguage());

String needfav ="";
String needhelp ="";
%>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>

<script type="text/javascript">
var dialog = parent.getDialog(window);
var parentWin = parent.getParentWindow(window);

function onSaveShortNameSetting(obj) {
	obj.disabled = true;
	formShortNameSetting.action="WorkflowShortNameSettingOperation.jsp" ;
	formShortNameSetting.submit();
}

if("<%=isclose%>"==1){
	parentWin.location="WFCode.jsp?ajax=<%=ajax%>&wfid=<%=workflowId%>";
	dialog.close();	
}

function onCancelShortNameSetting(obj){
	//window.location="/workflow/workflow/WFCode.jsp?ajax=1&wfid=<%=workflowId%>";
	dialog.close();	
}
</script>
</head>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

if(canEdit){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSaveShortNameSetting(this),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
}

if(ajax.equals("1")){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onCancelShortNameSetting(this),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
}

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
<form id="formShortNameSetting" name="formShortNameSetting" method=post action="WorkflowShortNameSettingOperation.jsp" >
<input name=ajax type=hidden value="<%=ajax%>">
<input name=workflowId type=hidden value="<%=workflowId%>">
<input name=formId type=hidden value="<%=formId%>">
<input name=isBill type=hidden value="<%=isBill%>">
<input name=fieldId type=hidden value="<%=fieldId%>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<%if(canEdit){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" id="zd_btn_cancle"  class="e8_btn_top" onclick="onSaveShortNameSetting(this)">
		<%} %>
			<%--<input type="text" class="searchInput" name="flowTitle" value=""/> --%>
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(22216,user.getLanguage())%>'>
		<wea:item attributes="{'isTableList':'true'}">
			<table class=ListStyle cellspacing=1   cols=2 >
			<colgroup>
				<col width="50%">
				<col width="50%">
			</colgroup>
		    <tr class=header>
			    <td><%=SystemEnv.getHtmlLabelName(22217,user.getLanguage())%></td>
			    <td><%=SystemEnv.getHtmlLabelName(22216,user.getLanguage())%></td>
		    </tr>
	  		
			<%
			
			String trClass="DataLight";
			
			int tempFieldValue=0;
			String tempFieldValueName=null;
			int tempRecordId=0;
			String tempShortNameSetting =null;
			
			String shortNameSettingSql=null;
			StringBuffer shortNameSettingSb=new StringBuffer();
			if(isWorkflowSeqAlone){
			   shortNameSettingSb.append(" select workflow_selectitem.selectValue as fieldValue,selectName as fieldValueName ,workflow_shortNameSetting.id as recordId,workflow_shortNameSetting.shortNameSetting ")
						         .append(" from workflow_selectitem ")
						         .append("      left join (select * from workflow_shortNameSetting ")
						         .append(" 	             where fieldId=").append(fieldId)
						         .append(" 				 and workflowId=").append(workflowId)
						         .append(" 			    )workflow_shortNameSetting ")
						         .append("   on	workflow_selectitem.selectValue=workflow_shortNameSetting.fieldValue  ")
						         .append(" 	    where workflow_selectitem.fieldId=").append(fieldId)
						         .append(" 	      and workflow_selectitem.isBill='").append(isBill).append("'")
						         .append(" order by listOrder,workflow_selectitem.id  ");
			}else{
			   shortNameSettingSb.append(" select workflow_selectitem.selectValue as fieldValue,selectName as fieldValueName ,workflow_shortNameSetting.id as recordId,workflow_shortNameSetting.shortNameSetting ")
						         .append(" from workflow_selectitem ")
						         .append("      left join (select * from workflow_shortNameSetting ")
						         .append(" 	             where fieldId=").append(fieldId)
						         .append(" 				   and formId=").append(formId)
						         .append(" 				   and isBill='").append(isBill).append("' ")
						         .append(" 			    )workflow_shortNameSetting ")
						         .append("   on	workflow_selectitem.selectValue=workflow_shortNameSetting.fieldValue  ")
						         .append(" 	    where workflow_selectitem.fieldId=").append(fieldId)
						         .append(" 	      and workflow_selectitem.isBill='").append(isBill).append("'")
						         .append(" order by listOrder,workflow_selectitem.id  ");
			}
			shortNameSettingSql=shortNameSettingSb.toString();
			RecordSet.executeSql(shortNameSettingSql);
			while(RecordSet.next()){
				tempFieldValue     =Util.getIntValue(RecordSet.getString("fieldValue"),0);
				tempFieldValueName   =Util.null2String(RecordSet.getString("fieldValueName"));
				tempRecordId  =Util.getIntValue(RecordSet.getString("recordId"),0);
				tempShortNameSetting=Util.null2String(RecordSet.getString("shortNameSetting"));
			
			%>
			<tr class="<%=trClass%>">
			    <td  height="23" align="left"><%=tempFieldValueName%>
			      <input type="hidden" name="shortNameSetting<%=rowNum%>_fieldValue" value="<%=tempFieldValue%>">
			    </td>
			      <input type="hidden" name="shortNameSetting<%=rowNum%>_recordId" value="<%=tempRecordId%>">
			    <td  height="23" align="left">
			<%if(canEdit){%>
					<input class=Inputstyle type="text" name="shortNameSetting<%=rowNum%>_shortNameSetting" value="<%=tempShortNameSetting%>" maxlength=20 >
			<%}else{%>
					<%=tempShortNameSetting%>
			<%}%>
				</td>
			</tr>
<%
    rowNum+=1;
    if(trClass.equals("DataLight")){
		trClass="DataDark";
	}else{
		trClass="DataLight";
	}
  }

%>
</table>		
		</wea:item>
	</wea:group>
</wea:layout>

<input type="hidden" value="<%=rowNum%>" name="rowNumShortNameSetting">
</form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes='{\"groupDisplay\":\"none\"}'>
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</body>
</html>
