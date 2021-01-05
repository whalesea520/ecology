
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ page import="weaver.system.code.CodeBuild"%>
<%@ page import="weaver.system.code.CoderBean"%>
<%@ taglib uri="/browser" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowCodeSeqReservedManager" class="weaver.workflow.workflow.WorkflowCodeSeqReservedManager" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML><HEAD>

<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<body>
<%
Calendar today = Calendar.getInstance();
int yearIdToday = today.get(Calendar.YEAR);
int monthIdToday = today.get(Calendar.MONTH) + 1;  
int dateIdToday = today.get(Calendar.DAY_OF_MONTH);

int design = Util.getIntValue(request.getParameter("design"),0);
int workflowId = Util.getIntValue(request.getParameter("workflowId"),0);
int formId = Util.getIntValue(request.getParameter("formId"),0);
String isBill = Util.null2String(request.getParameter("isBill"));
String postValue = Util.null2String(request.getParameter("postValue"));
String flowingwater = Util.null2String(request.getParameter("flowingwater"));

String rtnflowingwater = "";

/*if(reservedId>0){
	if(Util.getIntValue(codeMemberValue)<=(""+reservedId).length())
		returnCodeStr += reservedId;
	else{
		for(int j=0;j<(Util.getIntValue(codeMemberValue)-(""+reservedId).length());j++){
			returnCodeStr += "0";
		}
		returnCodeStr += reservedId;
	}
}else{
	for(int j=0;j<Util.getIntValue(codeMemberValue);j++){
		returnCodeStr += "*";
	}						
}*/
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
	

String recordId = Util.null2String(request.getParameter("recordId"));

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
	}else{
	    RecordSet.executeSql("select id,sequenceId from workflow_codeSeq where workflowId="+tempWorkflowId+" and formId="+tempFormId+" and isBill='"+tempIsBill+"' and yearId="+tempYearId+" and monthId="+tempMonthId+" and dateId="+tempDateId+" and fieldId="+tempFieldId+" and fieldValue="+tempFieldValue+" and supSubCompanyId="+tempSupSubCompanyId+" and subCompanyId="+tempSubCompanyId+" and departmentId="+tempDepartmentId);

	    if(RecordSet.next()){
		    tempRecordId=Util.getIntValue(RecordSet.getString("id"),-1);
	    }
        if(tempRecordId>0){
		    recordId = tempRecordId+"";
	    }
	}
}

if(recordId.equals("")){
	recordId = String.valueOf(workflowId);
}
String SQL = null;

if("1".equals(isBill)){
	SQL = "select formField.id,fieldLable.labelName as fieldLable "
               + "from HtmlLabelInfo  fieldLable ,workflow_billfield  formField "
               + "where fieldLable.indexId=formField.fieldLabel "
               + "  and formField.billId= " + formId
               + "  and formField.viewType=0 "
               + "  and fieldLable.languageid =" + user.getLanguage();
}else{
	SQL = "select formDict.ID, fieldLable.fieldLable "
               + "from workflow_fieldLable fieldLable, workflow_formField formField, workflow_formdict formDict "
               + "where fieldLable.formid = formField.formid and fieldLable.fieldid = formField.fieldid and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "
               + "and formField.formid = " + formId
               + " and fieldLable.langurageid = " + user.getLanguage();
}

String selectFieldSql=null;//选择框

if("1".equals(isBill)){
	selectFieldSql = SQL + " and formField.fieldHtmlType = '5' order by formField.dspOrder";
}else{
    selectFieldSql = SQL + " and formDict.fieldHtmlType = '5' order by formField.fieldorder";
}

String isclose = "";
int sequenceId = 0;

RecordSet.executeSql("select sequenceId from workflow_codeSeq where id="+recordId);

if(RecordSet.next()){
	sequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);						
}


String src = Util.null2String(request.getParameter("src"));
if(src.equals("save")){
String reservedIdStr=Util.null2String(request.getParameter("reservedIdStr"));//格式为：5,6-10,23,34,37,45
String reservedCode="";
String reservedDesc=Util.null2String(request.getParameter("reservedDesc"));
reservedDesc=Util.toHtml100(reservedDesc);
isclose = "1";
int reservedId=-1;
int reservedIdBegin=-1;
int reservedIdEnd=-1;	
List hisReservedIdList=new ArrayList();
StringBuffer hisReservedIdSb=new StringBuffer();
hisReservedIdSb.append(" select reservedId ")
               .append("   from workflow_codeSeqReserved ")
               .append("  where codeSeqId=").append(recordId)
               .append("    and (hasDeleted is null or hasDeleted='0') ")
               .append("  order by reservedId asc,id asc ");
RecordSet.executeSql(hisReservedIdSb.toString());
while(RecordSet.next()){
	reservedId=Util.getIntValue(RecordSet.getString("reservedId"),-1);
	if(reservedId>0&&hisReservedIdList.indexOf(""+reservedId)==-1){
		hisReservedIdList.add(Util.null2String(RecordSet.getString("reservedId")));
	}
}

RecordSet.executeSql("select distinct sequenceId from workflow_codeSeqRecord where codeSeqId="+recordId);
while(RecordSet.next()){
	reservedId=Util.getIntValue(RecordSet.getString("sequenceId"),-1);
	if(reservedId>0&&hisReservedIdList.indexOf(""+reservedId)==-1){
		hisReservedIdList.add(Util.null2String(RecordSet.getString("sequenceId")));
	}
}

List reservedIdList=Util.TokenizerString(reservedIdStr,",");
String reservedIdStrPart=null;
List reservedIdStrPartList=null;
if(reservedIdList.size() > 0){
	for(int i=0;i<reservedIdList.size();i++){
		reservedIdStrPart=Util.null2String((String)reservedIdList.get(i));
		if(reservedIdStrPart.indexOf("-") > -1){
			reservedIdStrPartList=Util.TokenizerString(reservedIdStrPart,"-");
			if(reservedIdStrPartList.size()>=2){
				reservedIdBegin=reservedId=Util.getIntValue((String)reservedIdStrPartList.get(0),-1);
				reservedIdEnd=reservedId=Util.getIntValue((String)reservedIdStrPartList.get(1),-1);
				if(reservedIdBegin>0&&reservedIdBegin<=reservedIdEnd){
					for(reservedId=reservedIdBegin;reservedId<=reservedIdEnd;reservedId++){
						if(hisReservedIdList.indexOf(""+reservedId)==-1){
							for(int j=0;j<(Util.getIntValue(flowingwater)-(""+reservedId).length());j++){
								rtnflowingwater += "0";
							}
							String scode = postValue+rtnflowingwater+reservedId; 
							hisReservedIdList.add(""+reservedId);
							//reservedCode=WorkflowCodeSeqReservedManager.getReservedCode(workflowId,formId,isBill,recordId,-1,reservedId);
							reservedCode=scode;
							reservedCode=Util.toHtml100(reservedCode);
							RecordSet.executeSql("insert into workflow_codeSeqReserved(codeSeqId,reservedId,reservedCode,reservedDesc,hasUsed,hasDeleted) values("+recordId+","+reservedId+",'"+reservedCode+"','"+reservedDesc+"','0','0')");
							rtnflowingwater = "";
						}						
					}
				}
			}
		}else{
			reservedId=Util.getIntValue(reservedIdStrPart,-1);
			if(reservedId>0&&hisReservedIdList.indexOf(""+reservedId)==-1){
				for(int j=0;j<(Util.getIntValue(flowingwater)-(""+reservedIdStrPart).length());j++){
					rtnflowingwater += "0";
				}
				String scode = postValue+rtnflowingwater+reservedIdStrPart; 
				hisReservedIdList.add(""+reservedId);
				//reservedCode=WorkflowCodeSeqReservedManager.getReservedCode(workflowId,formId,isBill,recordId,-1,reservedId);
				reservedCode=scode;
				reservedCode=Util.toHtml100(reservedCode);
				RecordSet.executeSql("insert into workflow_codeSeqReserved(codeSeqId,reservedId,reservedCode,reservedDesc,hasUsed,hasDeleted) values("+recordId+","+reservedId+",'"+reservedCode+"','"+reservedDesc+"','0','0')");
				rtnflowingwater = "";
			}
		}
	}

}else{
	reservedCode=postValue;
	reservedCode=Util.toHtml100(reservedCode);
	RecordSet.executeSql("insert into workflow_codeSeqReserved(codeSeqId,reservedId,reservedCode,reservedDesc,hasUsed,hasDeleted) values("+recordId+","+reservedId+",'"+reservedCode+"','"+reservedDesc+"','0','0')");
}
}
%>

<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(22783,user.getLanguage()) ;
    String needfav = "";
    String needhelp = "";

%>

<%
if(design==0) {
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
}
%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

//if(design==1) {
//	RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:designOnClose(),_self} " ;
//	RCMenuHeight += RCMenuHeightStep;
//}
//else {
//RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:onClose(),_self} " ;
//RCMenuHeight += RCMenuHeightStep;
//}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
<div class="zDialog_div_content">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="WFCodeReserved.jsp" method="post">
<input type="hidden" value="" name="src">
<INPUT TYPE="hidden" NAME="postValue" id="postValue">
<INPUT TYPE="hidden" NAME="formId" id="formId" value="<%=formId%>">
<INPUT TYPE="hidden" NAME="isBill" id="isBill" value="<%=isBill%>">
<INPUT TYPE="hidden" NAME="workflowId" id="workflowId" value="<%=workflowId%>">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="onSave()">
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>  

<wea:layout type="3col" attributes="{'formTableId':'codeRule'}">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(22783,user.getLanguage())%>'>
    	

	<%
	int strindex = 1;//字符串字段
	int selectindex = 1;//选择框字段
	int deptindex = 1;//部门字段
	int subindex = 1;//分部字段
	int supsubindex = 1;//上级分部字段
	int yindex = 1;//年字段
	int mindex = 1;//月字段
	int dindex = 1;//日字段

	for (int i=0;i<coderMemberList.size();i++){
		String[] codeMembers = (String[])coderMemberList.get(i);
		String codeMemberName = codeMembers[0];
		String codeMemberValue = codeMembers[1];
		String codeMemberType = codeMembers[2];
		String concreteField = codeMembers[3];
		String enablecode = codeMembers[4];
		String attributes = "{'colspan':'full','trId':'TR_"+i+"','customAttrs':'member="+i+"'}";
		String attrs = "{'codevalue':'"+codeMemberName+"'}";
	%>
	<!--  -->
	<%
	//7:input字符串

	if ("2".equals(codeMemberType) && !"".equals(codeMemberValue) && codeMemberValue != null && "7".equals(concreteField)){   
	%>
	<%attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=7'}"; %>
		<wea:item attributes='<%=attrs %>'>
		<%=SystemEnv.getHtmlLabelName(27903,user.getLanguage()) + strindex%>
		</wea:item>
		<wea:item attributes='<%=attributes %>'>
			<input type=text name="inputt<%=strindex%>" onchange=proView() class=inputstyle value="<%=codeMemberValue%>" disabled >
		</wea:item>
	<%	strindex++;
		//0:选择框字段

		}else if(codeMemberType.equals("5") && concreteField.equals("0")){
		%>
		<%attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=0'}"; %>
		<wea:item attributes='<%=attrs %>'>
		<%=SystemEnv.getHtmlLabelName(22755,user.getLanguage())%>
		</wea:item>
		<wea:item attributes='<%=attributes %>'>
		<select class=inputstyle name="selectField_<%=selectindex%>" oldval="<%=codeMemberValue%>" onchange="checkselect('0',this)" style="width:100px!important;">
		<%
		RecordSet.executeSql(selectFieldSql);  
		while(RecordSet.next()){
		int sFieldId = RecordSet.getInt("ID");
		%>
		<option value=<%= sFieldId %> <% if((""+sFieldId).equals(codeMemberValue)) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>
		<%}%>
		</select>
		</wea:item>
		<%
		selectindex++;
		//1:部门
		}else if(codeMemberType.equals("5") && concreteField.equals("1")){
		%>
		<%attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=1'}"; %>
		<wea:item attributes='<%=attrs %>'>
		<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
		</wea:item>
		<% String browsername = "selectDept_"+deptindex;%>
		<wea:item attributes='<%=attributes %>'>
		<brow:browser name='<%=browsername%>' viewType="0" hasBrowser="true" hasAdd="false" browserOnClick="" 
		 	   		   browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp" 
    				   isMustInput="2" isSingle="true" hasInput="true" _callback="changeclickbrow"
     				   completeUrl="javascript:getajaxurl(1)"  width="150px" browserValue="" browserSpanValue=""/>
		
		</wea:item>
		<%
		deptindex++;
		//2:分部
		}else if(codeMemberType.equals("5") && concreteField.equals("2")){
		%>
		<%attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=2'}"; %>
		<wea:item attributes='<%=attrs %>'>
		<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
		</wea:item>
		<wea:item attributes='<%=attributes %>'>
		<% String browsername = "selectSub_"+subindex;%>
		<brow:browser name='<%=browsername%>' viewType="0" hasBrowser="true" hasAdd="false" browserOnClick=""
		 	   		   browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp" 
    				   isMustInput="2" isSingle="true" hasInput="true" _callback="changeclickbrow"
     				   completeUrl="javascript:getajaxurl(2)"  width="150px" browserValue="" browserSpanValue=""/>
		</wea:item>
		<%
		subindex++;
		//3:上级分部
		}else if(codeMemberType.equals("5") && concreteField.equals("3")){
		%>
		<%attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=3'}"; %>
		<wea:item attributes='<%=attrs %>'>
		<%=SystemEnv.getHtmlLabelName(22753,user.getLanguage())%>
		</wea:item>
		<wea:item attributes='<%=attributes %>'>
		<% String browsername = "selectSupSub_"+supsubindex;%>
		<brow:browser name='<%=browsername%>' viewType="0" hasBrowser="true" hasAdd="false" browserOnClick=""
		 	   		   browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp" 
    				   isMustInput="2" isSingle="true" hasInput="true" _callback="changeclickbrow"
     				   completeUrl="javascript:getajaxurl(2)"  width="150px" browserValue="" browserSpanValue=""/>
		</wea:item>
		<%
		supsubindex++;
		//4:年

		}else if(codeMemberType.equals("5") && concreteField.equals("4")){
		%>
		<%attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=4'}"; %>
		<wea:item attributes='<%=attrs %>'>
		<%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>
		</wea:item>
		<wea:item attributes='<%=attributes %>'>
			<wea:required id="s">
				<input type="text" name="selectYear_<%=yindex%>" class=inputstyle value="<%=yearIdToday%>" maxlength="4" size="4"  onChange='proView()'>
			</wea:required>
		</wea:item>
		<%
		yindex++;
		//5:月

		}else if(codeMemberType.equals("5") && concreteField.equals("5")){
		%>
		<%attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=5'}"; %>
		<wea:item attributes='<%=attrs %>'>
		<%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
		</wea:item>
		<wea:item attributes='<%=attributes %>'>
		<SELECT class=inputstyle name="selectMonth_<%=mindex%>" onchange="proView()">
		<%for(int q=1;q<=12;q++){%>
	     	<OPTION value=<%=q%> <%if(q==monthIdToday){%>selected<%}%>><%=q%></OPTION>
		<%}%>
		</SELECT>
		</wea:item>
		<%	
		mindex++;
		//6:日

		}else if(codeMemberType.equals("5") && concreteField.equals("6")){
		%>
		<%attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=6'}"; %>
		<wea:item attributes='<%=attrs %>'>
		<%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%>
		</wea:item>
		<wea:item attributes='<%=attributes %>'>
		<SELECT class=inputstyle name="selectDay_<%=dindex%>" onchange="proView()">
		<%for(int w=1;w<=31;w++){%>
	    <OPTION value=<%=w%> <%if(w==dateIdToday){%>selected<%}%>><%=w%></OPTION>
		<%}%>
		</SELECT>
		</wea:item>
		<%	
		dindex++;
		//8:流水号位数

		}else if(concreteField.equals("8")){
		%>
		<%attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=8'}"; %>
		<wea:item attributes="<%=attrs %>">
		<%=SystemEnv.getHtmlLabelName(18811,user.getLanguage())%>
		</wea:item>
		<wea:item attributes="<%=attributes %>">
			<input type=text name="inputt<%=i%>" maxlength="16" onchange='checkint("inputt<%=i%>");proView();' class=inputstyle   value="<%=codeMemberValue%>" >
			<input type="hidden" name="flowingwater" value="" >
		</wea:item>
		<%	
		}else if(concreteField.equals("9")){
		%>
		<%attrs = "{'codevalue':'"+codeMemberName+"','customAttrs':'concrete=9'}"; %>
		<wea:item attributes='<%=attrs %>'>
		<%=SystemEnv.getHtmlLabelName(18729,user.getLanguage())%>
		</wea:item>
		<wea:item attributes='<%=attributes %>'>
		<input type=text name="inputtdigit" class=inputstyle value="<%=codeMemberValue%>" disabled>
		</wea:item>
		<%	
		}%>
	<!--  -->
	<%}%>
    	
    	<wea:item attributes="{'customAttrs':'concrete=10'}"><%=SystemEnv.getHtmlLabelName(16318,user.getLanguage())%></wea:item>
    	<wea:item attributes="{'colspan':'full'}">
			<input type="text" class=inputstyle name="reservedIdStr" value="" maxlength="60" size="30" onChange='proView()'>&nbsp;
			<span class='e8tips' title='<%=SystemEnv.getHtmlLabelName(15191,user.getLanguage()) %>：5,6-10,23,34,37,45'><img src='/images/tooltip_wev8.png' align='absMiddle'/></span>
		</wea:item>
    	<%--
    	<wea:item><%=SystemEnv.getHtmlLabelName(15196,user.getLanguage())%></wea:item>
    	<wea:item><%=WorkflowCodeSeqReservedManager.getReservedCodeForWF(workflowId,formId,isBill,recordId,-1,-1)%></wea:item>
    	 --%>
    	<wea:item attributes="{'classTR':'notMove'}"><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></wea:item>
		<wea:item attributes="{'colspan':'full','classTR':'notMove'}">
            <table style="border:1px solid #0070C0;border-bottom:none;border-left:none;border-top:none;" cellspacing="0" cellpadding="0">
            	<tr id="TR_pro"></tr>
            </table>
		</wea:item>	
    	
    	<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
    	<wea:item attributes="{'colspan':'full'}"><input type="text" class=inputstyle name="reservedDesc" value="" maxlength="100" size="40"></wea:item>
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

function onSave(){
	if(check_wfcode()){
		getCode();
		document.all("src").value="save";
		document.SearchForm.submit();
	}else{
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129512, user.getLanguage())%>!");
	}
}

<%if("1".equals(isclose)){%>
	parentWin.location="WFCodeReservedForDigit.jsp?workflowId=<%=workflowId%>&formId=<%=formId%>&isBill=<%=isBill%>";
	onClose();
<%}%>

function onClose(){
	if(dialog){
	    dialog.close();
	}else{  
	    window.parent.close();
	}
	//window.parent.close();
}

function onChangeResource1(){
	var url = onShowMutiDepartment();
	return url;
}

function onChangeResource2(){
	var url = onShowMutiSubcompany();
	return url;
}

function onChangeResource3(){
	var url = onShowMutiSubcompany();
	return url;
}

function onShowMutiDepartment() {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=";
	return url;
}

function onShowMutiSubcompany() {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=";
	return url;
}

function getajaxurl(obj) {
	var url = "";
	if (obj == "1") {
		url = "/data.jsp?type=4";
	}else if (obj == "2") {
		url = "/data.jsp?type=164";
	}	
	return url;
}

//工作流图形化确定
function designOnClose() {
	window.parent.design_callback('showFormSignatureOperate');
}

jQuery(document).ready(function(){
	jQuery(".e8tips").wTooltip({html:true});
	proView();
});

var colors= new Array ("#4F81BD","#4F81BD","#4F81BD","#4F81BD","#4F81BD");
var colors1= new Array ("#C0504D","#C0504D","#C0504D","#C0504D","#C0504D");

function proView(){
	var TR_doc =  jQuery("#TR_pro");
	jQuery(TR_doc).children("td").remove();
	jQuery("tr[customer1]").each(function(index,obj){
		var codeTitle = $(obj).find("td::eq(0)").text();
		codeTitle = jQuery.trim(codeTitle);
		var concrete = $(obj).find("td::eq(0)").attr("concrete");
		var codeValue = "";
		
		if(concrete == "0" || concrete == "5" || concrete == "6"){
			codeValue = $(obj).find("td::eq(1)").find("select").val();
		}else if(concrete == "1"){
			codeValue = $(obj).find("td::eq(1)").find("input[name^='selectDept_']").val();
		}else if(concrete == "2"){
			codeValue = $(obj).find("td::eq(1)").find("input[name^='selectSub_']").val();
		}else if(concrete == "3"){
			codeValue = $(obj).find("td::eq(1)").find("input[name^='selectSupSub_']").val();
		}else if(concrete == "4"){
			codeValue = $(obj).find("td::eq(1)").find("input[name^='selectYear_']").val();
		}else if(concrete == "7" || concrete == "9"){
			codeValue = $(obj).find("td::eq(1)").find("input[name^='inputt']").val();
		}else if(concrete == "8"){
			codeValue = $(obj).find("td::eq(1)").find("input[name^='inputt']").val();
		}else if(concrete == "10"){
			codeValue = $(obj).find("td::eq(1)").find("input[name^='reservedIdStr']").val();
			if(codeValue != "" && codeValue != null){
				if(codeValue.indexOf("-")){
					codeValue = codeValue.split("-")[0];
				}
			}
		}
	
		if(concrete != null && concrete != ""){
	        var tempTd = document.createElement("TD");
	        var tempTable = document.createElement("TABLE");
	        jQuery(tempTable).css("border","1px solid #0070C0");
	        jQuery(tempTable).css("border-right","none");
	        var newRow = tempTable.insertRow(-1);
	        var newRowMiddle = tempTable.insertRow(-1);
	        var newRow1 = tempTable.insertRow(-1);
	        
	
	        var newCol = newRow.insertCell(-1);
	        var newColMiddle=newRowMiddle.insertCell(-1);
	        var newCol1 = newRow1.insertCell(-1);
	
	        jQuery(newRowMiddle).css("height","1px");
	        jQuery(newRowMiddle).css("background-color","#0070C0");
	        jQuery(newRowMiddle).css("background-repeat","repeat-x");
	        newCol.innerHTML="<font color="+colors[index%5]+">"+codeTitle+"</font>";
	        if (codeValue=="1") {
	          codeValue="****";
	        } else if (codeValue=="0") {
	          codeValue="**";
	        }
	        newCol1.innerHTML="<font color="+colors1[index%5]+">"+codeValue+"</font>";
	        jQuery(tempTd).append(tempTable);
	        jQuery(TR_doc).append(tempTd);
		}
  })
}

function changeclickbrow(event,datas,name,callbackParams){
	proView();
}

function check_wfcode(){
	var checkcode = true;
	var allyear = jQuery("input[name^=select]");
	allyear.each(function (i, e) {
		var continueid = $(e).attr("id")+"end";
		if(($(e).val() == "" || $(e).val() == null) && continueid.indexOf("__")==-1){
			checkcode = false;
		}
	});
	return checkcode;
}

function getCode(){
	// obj.disabled=true;
	var postValueStr="";
	jQuery("tr[customer1]").each(function(index,obj){
		var concrete = $(obj).find("td::eq(0)").attr("concrete");
		var codeValue = "";
		if(concrete == "0" || concrete == "5" || concrete == "6"){
			codeValue = $(obj).find("td::eq(1)").find("select").val();
		}else if(concrete == "1"){
			codeValue = $(obj).find("td::eq(1)").find("input[name^='selectDept_']").val();
		}else if(concrete == "2"){
			codeValue = $(obj).find("td::eq(1)").find("input[name^='selectSub_']").val();
		}else if(concrete == "3"){
			codeValue = $(obj).find("td::eq(1)").find("input[name^='selectSupSub_']").val();
		}else if(concrete == "4"){
			codeValue = $(obj).find("td::eq(1)").find("input[name^='selectYear_']").val();
		}else if(concrete == "8"){
			var flowingwater = $(obj).find("td::eq(1)").find("input[name^='inputt']").val();
			jQuery("input[name=flowingwater]").val(flowingwater);
		}else if(concrete == "7" || concrete == "9"){
			codeValue = $(obj).find("td::eq(1)").find("input[name^='inputt']").val();
		}
		if(concrete != null && concrete != ""){
		  postValueStr += codeValue;
		}
	  })
	jQuery("#postValue").val(postValueStr);
}
</script>
