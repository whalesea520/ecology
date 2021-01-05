
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.system.code.CodeBuild"%>
<%@ page import="weaver.system.code.CoderBean"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

boolean canEdit=false;
if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
	canEdit=true;
}

int design = Util.getIntValue(request.getParameter("design"),0);

int workflowId = Util.getIntValue(request.getParameter("workflowId"),0);
int formId = Util.getIntValue(request.getParameter("formId"),0);
String isBill = Util.null2String(request.getParameter("isBill"));
int yearId = Util.getIntValue(request.getParameter("yearId"),0);
int monthId = Util.getIntValue(request.getParameter("monthId"),0);
int dateId = Util.getIntValue(request.getParameter("dateId"),0);
int fieldId = Util.getIntValue(request.getParameter("fieldId"),0);
int fieldValue = Util.getIntValue(request.getParameter("fieldValue"),0);
int supSubCompanyId = Util.getIntValue(request.getParameter("supSubCompanyId"),0);
int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),0);
int departmentId = Util.getIntValue(request.getParameter("departmentId"),0);

int recordId = Util.getIntValue(request.getParameter("recordId"),0);
int sequenceId=1;
if(recordId<=0){
	int tempWorkflowId=-1;
	int tempFormId=-1;
	String tempIsBill="0";
	int tempYearId=-1;
	int tempMonthId=-1;
	int tempDateId=-1;
	
	int tempFieldId=-1;
	int tempFieldValue=-1;
	
	int tempSupSubCompanyId=-1;
	int tempSubCompanyId=-1;
	int tempDepartmentId=-1;
	
	int tempRecordId=-1;
	int tempSequenceId=1;
	
	CodeBuild cbuild = new CodeBuild(formId,isBill,workflowId);	
	CoderBean cb = cbuild.getFlowCBuild();
	
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
		tempYearId=yearId;
	}else if("1".equals(dateSeqAlone)&&"2".equals(dateSeqSelect)){
		tempYearId=yearId;
		tempMonthId=monthId;						
	}else if("1".equals(dateSeqAlone)&&"3".equals(dateSeqSelect)){
		tempYearId=yearId;						
		tempMonthId=monthId;	
		tempDateId=dateId;							
	}
					
	if("1".equals(fieldSequenceAlone)&&fieldId>0 ){
		tempFieldId=fieldId;
		tempFieldValue=fieldValue;
	}
					
	if("1".equals(struSeqAlone)&&"1".equals(struSeqSelect)){
		tempSupSubCompanyId=supSubCompanyId;
		tempSubCompanyId=-1;
		tempDepartmentId=-1;						
	}
	if("1".equals(struSeqAlone)&&"2".equals(struSeqSelect)){
		tempSupSubCompanyId=-1;
		tempSubCompanyId=subCompanyId;
		tempDepartmentId=-1;						
	}
	if("1".equals(struSeqAlone)&&"3".equals(struSeqSelect)){
		tempSupSubCompanyId=-1;
		tempSubCompanyId=-1;
		tempDepartmentId=departmentId;						
	}

	RecordSet.executeSql("select id,sequenceId from workflow_codeSeq where workflowId="+tempWorkflowId+" and formId="+tempFormId+" and isBill='"+tempIsBill+"' and yearId="+tempYearId+" and monthId="+tempMonthId+" and dateId="+tempDateId+" and fieldId="+tempFieldId+" and fieldValue="+tempFieldValue+" and supSubCompanyId="+tempSupSubCompanyId+" and subCompanyId="+tempSubCompanyId+" and departmentId="+tempDepartmentId);

	if(RecordSet.next()){
		tempRecordId=Util.getIntValue(RecordSet.getString("id"),-1);
		tempSequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);						
	}

    if(tempRecordId>0){
		recordId = tempRecordId;
		sequenceId = tempSequenceId;
	}
}else{
	RecordSet.executeSql("select sequenceId from workflow_codeSeq where id="+recordId);

	if(RecordSet.next()){
		sequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);						
	}
}

String src = Util.null2String(request.getParameter("src"));

if(src.equals("delete")){
	String[] checkids = request.getParameterValues("check_node");
	if(checkids!=null){
		for(int i=0;i<checkids.length;i++){
			RecordSet.executeSql("update workflow_codeSeqReserved set hasDeleted=1  where id="+checkids[i]);
		}
	}
}

%>
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(22782,user.getLanguage()) ;
    String needfav = "";
    String needhelp = "";
%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

</HEAD>
<body>

<%
if(design==0) {
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
}
%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canEdit){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
}
if(design==1) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:designOnClose(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
else {
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
<div class="zDialog_div_content">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="showViewReservedCodeOperate.jsp" method="post">

<input type="hidden" value="" name="src">
<input type="hidden" value="<%=design%>" name="design">
<input type="hidden" value="<%=workflowId%>" name="workflowId">
<input type="hidden" value="<%=formId%>" name="formId">
<input type="hidden" value="<%=isBill%>" name="isBill">
<input type="hidden" value="<%=recordId%>" name="recordId">

<wea:layout type="twoCol">
<wea:group context='<%=SystemEnv.getHtmlLabelName(22782,user.getLanguage())%>'>

<wea:item attributes="{'colspan':'full','isTableList':'true'}">

<table class=liststyle cellspacing=1   cols=2 width="100%">
            <COLGROUP>
  	        <COL width="10%">
  	        <COL width="40%">
  	        <COL width="50%">
  	        <tr class=header>
  	           <td></td>
  	           <td><%=SystemEnv.getHtmlLabelName(22779,user.getLanguage())%></td>
  	           <td><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td>
  	        </tr>
  	        <tr class="Line"><td colspan="3"> </td></tr>
<%
    String trClass="DataLight";

    int id=-1;
	int reservedId=-1;
	String reservedCode=null;
	String reservedDesc=null;
	StringBuffer codeSeqReservedSb=new StringBuffer();
	codeSeqReservedSb.append(" select * ")
	                 .append("   from workflow_codeSeqReserved  ")
					 .append("  where codeSeqId= ").append(recordId)
					 .append("    and (hasUsed is null or hasUsed='0') ")
					 .append("    and (hasDeleted is null or hasDeleted='0') ")
					 .append("  order by reservedId asc,id asc ")
					 ;
    RecordSet.executeSql(codeSeqReservedSb.toString());
    while(RecordSet.next()){
		id=Util.getIntValue(RecordSet.getString("id"),-1);
		reservedId=Util.getIntValue(RecordSet.getString("reservedId"),-1);
		reservedCode=Util.null2String(RecordSet.getString("reservedCode"));
		reservedDesc=Util.null2String(RecordSet.getString("reservedDesc"));
%>
	    <tr  class="<%=trClass%>">
            <td  height="23" align="left"><input type='checkbox' name='check_node' value="<%=id%>" ></td>
            <td  height="23" align="left"><%=reservedCode%></td>
            <td  height="23" align="left"><%=reservedDesc%></td>
	    </tr>
<%
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

</form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()" style="width: 60px!important;">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</body>
</html>

<script language=javascript>
var parentWin = window.parent.parent.getParentWindow(parent);
var dialog = window.parent.parent.getDialog(parent);

function onClose(){
if(dialog){
    dialog.close();
}else{  
    window.parent.close();
}
//window.parent.close();
}

function onDelete(){
	document.all("src").value="delete";
	document.SearchForm.submit();
}

//function onClose(){
//	window.parent.close();
//}

//工作流图形化确定
function designOnClose() {
	window.parent.design_callback('showViewReservedCodeOperate');
}
</script>


