
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.system.code.CodeBuild"%>
<%@ page import="weaver.system.code.CoderBean"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
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

    String isFromSubCompanyTree = Util.null2String(request.getParameter("isFromSubCompanyTree")); 

    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= Util.getIntValue(request.getParameter("subCompanyId"),-1);;
    int operatelevel=0;

    if(detachable==1){  
        if(request.getParameter("subCompanyId")==null){
            subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("WorkflowCodeSeqReserved_subCompanyId")),-1);
        }else{
            subCompanyId=Util.getIntValue(request.getParameter("subCompanyId"),-1);
        }
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        session.setAttribute("WorkflowCodeSeqReserved_subCompanyId",String.valueOf(subCompanyId));
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"ReservedCode:Maintenance",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("ReservedCode:Maintenance", user))
            operatelevel=2;
    }
	
	if(operatelevel>=1){
		canEdit=true;
	}

    String ajax=Util.null2String(request.getParameter("ajax"));
	int workflowId=Util.getIntValue(Util.null2String(request.getParameter("workflowId")),0);
	int formId=Util.getIntValue(Util.null2String(request.getParameter("formId")),0);
	String isBill=Util.null2String(request.getParameter("isBill"));
	if(!isBill.equals("1")){
		isBill="0";
	}

    CodeBuild cbuild = new CodeBuild(formId,isBill,workflowId);

    CoderBean cbean = cbuild.getFlowCBuild();
    ArrayList coderMemberList = cbean.getMemberList();

    boolean isWorkflowSeqAlone =  "1".equals(cbean.getWorkflowSeqAlone())?true:false;

    String fieldSequenceAlone =  cbean.getFieldSequenceAlone();
	String dateSeqAlone =  cbean.getDateSeqAlone();
	String dateSeqSelect =  cbean.getDateSeqSelect();
	String struSeqAlone=cbean.getStruSeqAlone();
	String struSeqSelect=cbean.getStruSeqSelect();

	int fieldId=-1;
	for (int i=0;i<coderMemberList.size();i++){
		String[] codeMembers = (String[])coderMemberList.get(i);
		String codeMemberName = codeMembers[0];
		String codeMemberValue = codeMembers[1];
		//if("22755".equals(codeMemberName)){
		//	fieldId=Util.getIntValue(codeMemberValue,-1);
		//}
		String concreteField = "";
		if(codeMembers.length >= 4){
			concreteField = codeMembers[3];
		}
		if(concreteField.equals("0")){
			fieldId=Util.getIntValue(codeMemberValue,-1);
		}
	}
	
	int selectCorrespondField = Util.getIntValue(cbean.getSelectCorrespondField());
    if (selectCorrespondField > 0) {
        fieldId = selectCorrespondField;
    }
    
	if(!"1".equals(fieldSequenceAlone)){
		fieldId=-1;
	}
    String selectValueAndNameSql="select selectValue as fieldValue,selectName as fieldValueName from workflow_selectitem where fieldId="+fieldId+" and isBill="+isBill+" order by listOrder,id";
	List selectValueAndNameList=new ArrayList();
	Map selectValueAndNameMap=null;

    String departmentNameOfSearch =null;
    String subCompanyIds = null;
	String subCompanyNames=null;

    String subCompanyNameOfSearch = null;
	if("1".equals(struSeqAlone)&&"3".equals(struSeqSelect)){//按部门做机构单独流水
        departmentNameOfSearch = Util.null2String(request.getParameter("departmentNameOfSearch"));
        subCompanyIds = Util.null2String(request.getParameter("subCompanyIds"));
	    if(subCompanyIds.equals("")){
		    //int[] subCompanyIdArray=CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),"WorkflowManage:All");
		    int[] subCompanyIdArray;
			if(isFromSubCompanyTree.equals("true")){
				subCompanyIdArray=CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),"ReservedCode:Maintenance");
			}else{
				subCompanyIdArray=CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),"WorkflowManage:All");
			}

            for(int i=0;i<subCompanyIdArray.length;i++){
                subCompanyIds+=","+subCompanyIdArray[i];
            }
            if(subCompanyIds.length()>1){
                subCompanyIds=subCompanyIds.substring(1);
            }
			if(!subCompanyIds.equals("")){//为提高效率  以系统管理员登录初始时只显示一个id最小的分部
				RecordSet.executeSql("select min(id) from HrmSubCompany where id in("+subCompanyIds+")");
                if(RecordSet.next()){
					subCompanyIds=Util.null2String(RecordSet.getString(1));
				}
			}
	    }
	    if(subCompanyIds.equals("")){
		    subCompanyIds="0";
	    }
	    subCompanyNames="";
        ArrayList subCompanyIdList=Util.TokenizerString(subCompanyIds,",");
	    for(int i=0;i<subCompanyIdList.size();i++){
		    subCompanyNames+=" "+SubCompanyComInfo.getSubCompanyname((String)subCompanyIdList.get(i));
	    }
	    if(subCompanyNames.equals("")){
		    subCompanyNames=subCompanyNames.substring(1);
	    }
    }else if("1".equals(struSeqAlone)&&("1".equals(struSeqSelect)||"2".equals(struSeqSelect))){
	//按上级分部、分部做机构单独流水
	    subCompanyNameOfSearch = Util.null2String(request.getParameter("subCompanyNameOfSearch"));
    }
 %>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<script language="javascript">
<%if(detachable==1&&isFromSubCompanyTree.equals("true")){%>
if(parent.parent.oTd1.style.display!="none"){
	parent.parent.oTd1.style.display="none";
}
<%}%>
</script>
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

if("1".equals(dateSeqAlone)||"1".equals(fieldSequenceAlone)||"1".equals(struSeqAlone)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearchCodeSeqReservedSet(this),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
}

if(canEdit){
    //RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSaveCodeSeqReservedSet(this),_self} " ;
    //RCMenuHeight += RCMenuHeightStep;
}

//if(ajax.equals("1")){
//    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onCancelCodeSeqSet(this),_self} " ;
//    RCMenuHeight += RCMenuHeightStep;
//}

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%

int yearIdCodeSeqSet=Util.getIntValue(request.getParameter("yearIdCodeSeqSet"),0);
int yearIdBeginCodeSeqSet=Util.getIntValue(request.getParameter("yearIdBeginCodeSeqSet"),0);
int yearIdEndCodeSeqSet=Util.getIntValue(request.getParameter("yearIdEndCodeSeqSet"),0);
int monthIdCodeSeqSet=Util.getIntValue(request.getParameter("monthIdCodeSeqSet"),0);
int monthIdBeginCodeSeqSet=Util.getIntValue(request.getParameter("monthIdBeginCodeSeqSet"),0);
int monthIdEndCodeSeqSet=Util.getIntValue(request.getParameter("monthIdEndCodeSeqSet"),0);
int dateIdBeginCodeSeqSet=Util.getIntValue(request.getParameter("dateIdBeginCodeSeqSet"),0);
int dateIdEndCodeSeqSet=Util.getIntValue(request.getParameter("dateIdEndCodeSeqSet"),0);

int fieldValueCodeSeqSet=Util.getIntValue(request.getParameter("fieldValueCodeSeqSet"),-1);

Calendar today = Calendar.getInstance() ; 
String currentYear = Util.add0(today.get(Calendar.YEAR) , 4) ; 
String currentMonth = Util.add0(today.get(Calendar.MONTH) + 1, 2) ; 
String currentDate = Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ; 

if(yearIdCodeSeqSet<=0){
	yearIdCodeSeqSet=Util.getIntValue(currentYear,2008);
}
if(yearIdBeginCodeSeqSet<=0){
	yearIdBeginCodeSeqSet=Util.getIntValue(currentYear,2008);
}
if(yearIdEndCodeSeqSet<=0){
	yearIdEndCodeSeqSet=Util.getIntValue(currentYear,2008);
}
if(monthIdCodeSeqSet<=0){
	monthIdCodeSeqSet=Util.getIntValue(currentMonth,1);
}
if(monthIdBeginCodeSeqSet<=0){
	monthIdBeginCodeSeqSet=Util.getIntValue(currentMonth,1);
}
if(monthIdEndCodeSeqSet<=0){
	monthIdEndCodeSeqSet=Util.getIntValue(currentMonth,1);
}
if(dateIdBeginCodeSeqSet<=0){
	dateIdBeginCodeSeqSet=Util.getIntValue(currentDate,1);
}
if(dateIdEndCodeSeqSet<=0){
	dateIdEndCodeSeqSet=Util.getIntValue(currentDate,1);
}

%>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(125090,user.getLanguage()) %>"/>
</jsp:include>
<form id="formCodeSeqSet" name="formCodeSeqSet" method=post action="WorkflowCodeSeqSetOperation.jsp" >
<input name=ajax type=hidden value="<%=ajax%>">
<input name=workflowId type=hidden value="<%=workflowId%>">
<input name=formId type=hidden value="<%=formId%>">
<input name=isBill type=hidden value="<%=isBill%>">

<input name=dateSeqAlone type=hidden value="<%=dateSeqAlone%>">
<input name=dateSeqSelect type=hidden value="<%=dateSeqSelect%>">

<input name=fieldId type=hidden value="<%=fieldId%>">

<input name=isFromSubCompanyTree type=hidden value="<%=isFromSubCompanyTree%>">
<input name=subCompanyId type=hidden value="<%=subCompanyId%>">

<%

int rowNum=0;
//从分部机构树进来的流程，若不按机构流水则不能维护
if(!isFromSubCompanyTree.equals("true")||subCompanyId<=0||"1".equals(struSeqAlone)){ 
%>



<wea:layout type="2col">
<wea:group context='<%=SystemEnv.getHtmlLabelName(22779,user.getLanguage())%>'>
<%if("1".equals(dateSeqAlone)&&"1".equals(dateSeqSelect)){ %>
<wea:item>
<%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>
</wea:item>
<wea:item>
	  <input type="text" name="yearIdBeginCodeSeqSet" value="<%=yearIdBeginCodeSeqSet%>" maxlength="4" size="4" onKeyPress="ItemCount_KeyPress()" onChange='checknumber("yearIdBeginCodeSeqSet");checkinput("yearIdBeginCodeSeqSet","yearIdBeginCodeSeqSetImage")'>
      <SPAN id=yearIdBeginCodeSeqSetImage></SPAN>
	 -
	  <input type="text" name="yearIdEndCodeSeqSet"   value="<%=yearIdEndCodeSeqSet%>" maxlength="4" size="4" onKeyPress="ItemCount_KeyPress()" onChange='checknumber("yearIdEndCodeSeqSet");checkinput("yearIdEndCodeSeqSet","yearIdEndCodeSeqSetImage")'>
      <SPAN id=yearIdEndCodeSeqSetImage></SPAN>
</wea:item>

<%}else if("1".equals(dateSeqAlone)&&"2".equals(dateSeqSelect)){ %>
<wea:item>
<%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>
</wea:item>
<wea:item>
	  <input type="text" name="yearIdCodeSeqSet" value="<%=yearIdCodeSeqSet%>" maxlength="4" size="4"  onKeyPress="ItemCount_KeyPress()" onChange='checknumber("yearIdCodeSeqSet");checkinput("yearIdCodeSeqSet","yearIdCodeSeqSetImage")'>
      <SPAN id=yearIdCodeSeqSetImage></SPAN>
</wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></wea:item>
<wea:item>
	  <SELECT class=inputstyle name="monthIdBeginCodeSeqSet">
<%
		  for(int i=1;i<=12;i++){
%>
	          <OPTION value=<%=i%> <%if(i==monthIdBeginCodeSeqSet){%>selected<%}%>><%=i%></OPTION>
<%
		  }
%>
	  </SELECT>
	 -
	  <SELECT class=inputstyle name="monthIdEndCodeSeqSet">
<%
		  for(int i=1;i<=12;i++){
%>
	          <OPTION value=<%=i%> <%if(i==monthIdEndCodeSeqSet){%>selected<%}%>><%=i%></OPTION>
<%
		  }
%>
	  </SELECT>
</wea:item>

<%}else if("1".equals(dateSeqAlone)&&"3".equals(dateSeqSelect)){ %>
<wea:item>
<%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>
</wea:item>
<wea:item>
	  <input type="text" name="yearIdCodeSeqSet" value="<%=yearIdCodeSeqSet%>" maxlength="4" size="4"  onKeyPress="ItemCount_KeyPress()" onChange='checknumber("yearIdCodeSeqSet");checkinput("yearIdCodeSeqSet","yearIdCodeSeqSetImage");onChangeYearOrMonth()'>
      <SPAN id=yearIdCodeSeqSetImage></SPAN>
</wea:item>
<wea:item><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></wea:item>
<wea:item>
	  <SELECT class=inputstyle name="monthIdCodeSeqSet" onchange="onChangeYearOrMonth()">
<%
		  for(int i=1;i<=12;i++){
%>
	          <OPTION value=<%=i%> <%if(i==monthIdCodeSeqSet){%>selected<%}%>><%=i%></OPTION>
<%
		  }
%>
	  </SELECT>
</wea:item>
<%
int daysOfMonthIdCodeSeqSet=31;
int[] monthDays = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
boolean isLeapYear=false;
if((yearIdCodeSeqSet%4==0&&yearIdCodeSeqSet%100!=0 )|| yearIdCodeSeqSet%400 == 0){
	isLeapYear=true;
}
daysOfMonthIdCodeSeqSet=monthDays[monthIdCodeSeqSet-1];
if ( monthIdCodeSeqSet ==2 && isLeapYear){
	daysOfMonthIdCodeSeqSet++;
}

%>
<wea:item><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%></wea:item>
<wea:item>
	  <SELECT class=inputstyle name="dateIdBeginCodeSeqSet">
<%
		  for(int i=1;i<=daysOfMonthIdCodeSeqSet;i++){
%>
	          <OPTION value=<%=i%> <%if(i==dateIdBeginCodeSeqSet){%>selected<%}%>><%=i%></OPTION>
<%
		  }
%>
	  </SELECT>
	 -
	  <SELECT class=inputstyle name="dateIdEndCodeSeqSet">
<%
		  for(int i=1;i<=daysOfMonthIdCodeSeqSet;i++){
%>
	          <OPTION value=<%=i%> <%if(i==dateIdEndCodeSeqSet){%>selected<%}%>><%=i%></OPTION>
<%
		  }
%>
	  </SELECT>
</wea:item>
<%}%>

<%
if(fieldId>0&&"1".equals(fieldSequenceAlone)){
%>
<wea:item><%=SystemEnv.getHtmlLabelName(22780,user.getLanguage())%></wea:item>
<wea:item>
	    <SELECT class=inputstyle name="fieldValueCodeSeqSet" >
	        <OPTION value=-1></OPTION>
<%
	    int tempFieldValue=0;
        String tempFieldValueName=null;
	    RecordSet.executeSql(selectValueAndNameSql);
        while(RecordSet.next()){
			tempFieldValue     =Util.getIntValue(RecordSet.getString("fieldValue"),0);
			tempFieldValueName   =Util.null2String(RecordSet.getString("fieldValueName"));
			selectValueAndNameMap=new HashMap();
			selectValueAndNameMap.put("fieldValue",""+tempFieldValue);
			selectValueAndNameMap.put("fieldValueName",tempFieldValueName);
			selectValueAndNameList.add(selectValueAndNameMap);
%>
	        <OPTION value=<%= tempFieldValue %> <% if(tempFieldValue==fieldValueCodeSeqSet) { %> selected <% } %> ><%= tempFieldValueName %></OPTION>
<%
        }
%>
	    </SELECT>
</wea:item>
<%
}
	if("1".equals(struSeqAlone)&&"3".equals(struSeqSelect)){//按部门做机构单独流水
%> 
<wea:item>
<%=SystemEnv.getHtmlLabelName(15390,user.getLanguage())%>
</wea:item>
<wea:item>
<input type=text name=departmentNameOfSearch class=Inputstyle value="<%=departmentNameOfSearch%>">
</wea:item>

<%
	    if(!isFromSubCompanyTree.equals("true")||subCompanyId<=0){
%>
<wea:item>
<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
</wea:item>
<wea:item>
	<%--
	<button class=browser onClick="onShowMultiSubcompanyBrowserByDec('subCompanyIds','subCompanyIdsSpan',0)"></button>
	<span id=subCompanyIdsSpan><%=subCompanyNames%></span>
	<input name=subCompanyIds type=hidden  value="<%=subCompanyIds%>">
	 --%>
	<brow:browser viewType="0" name='subCompanyIds' 
                browserValue='<%=subCompanyIds%>' 
                browserSpanValue='<%=subCompanyNames%>' 
                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
                hasInput="true" 
                isSingle='true' 
                hasBrowser = "true" isMustInput='1' 
                completeUrl='/data.jsp?type=164'
                > 
              </brow:browser>
</wea:item>
<%
    }else if("1".equals(struSeqAlone)&&("1".equals(struSeqSelect)||"2".equals(struSeqSelect))){//按上级分部、分部做机构单独流水
%> 

<%
	    if(!isFromSubCompanyTree.equals("true")||subCompanyId<=0){
%>
<wea:item>        
<%=SystemEnv.getHtmlLabelName(1878,user.getLanguage())%>
</wea:item>
<wea:item> 
	<input type=text name=subCompanyNameOfSearch class=Inputstyle value="<%=subCompanyNameOfSearch%>">
</wea:item>
<%
	    }
    }

}else if("1".equals(struSeqAlone)){
%>

<%
	if("3".equals(struSeqSelect)){//按部门做机构单独流水
%> 
        <wea:item> <%=SystemEnv.getHtmlLabelName(15390,user.getLanguage())%></wea:item>
        <wea:item>
        	<input type=text name=departmentNameOfSearch class=Inputstyle value="<%=departmentNameOfSearch%>">
		</wea:item>
<%
	    if(!isFromSubCompanyTree.equals("true")||subCompanyId<=0){
%>
        <wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
        <wea:item>
			<%--
			<button class=browser onClick="onShowMultiSubcompanyBrowserByDec('subCompanyIds','subCompanyIdsSpan',0)"></button>
			<span id=subCompanyIdsSpan><%=subCompanyNames%></span>
			<input name=subCompanyIds type=hidden  value="<%=subCompanyIds%>">
			 --%>
			<brow:browser viewType="0" name='subCompanyIds' 
                browserValue='<%=subCompanyIds%>' 
                browserSpanValue='<%=subCompanyNames%>' 
                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
                hasInput="true" 
                isSingle='true' 
                hasBrowser = "true" isMustInput='1' 
                completeUrl='/data.jsp?type=164'
                > 
              </brow:browser>
		</wea:item>
<%
	    }
    }else if("1".equals(struSeqSelect)||"2".equals(struSeqSelect)){ //按上级分部、分部做机构单独流水
	    if(!isFromSubCompanyTree.equals("true")||subCompanyId<=0){
%> 
        <wea:item><%=SystemEnv.getHtmlLabelName(1878,user.getLanguage())%></wea:item>
        <wea:item>
        	<input type=text name=subCompanyNameOfSearch class=Inputstyle value="<%=subCompanyNameOfSearch%>">
		</wea:item>
<%
	    }
    }
%> 

<%
}
if(selectValueAndNameList.size()==0){
	selectValueAndNameMap=new HashMap();
	selectValueAndNameMap.put("fieldValue","-1");
	selectValueAndNameMap.put("fieldValueName","");
	selectValueAndNameList.add(selectValueAndNameMap);
}
%>
</wea:group>
</wea:layout>








<%

String struSql="";
String struLabelName="";
String struColumnName="departmentId";
if("1".equals(struSeqAlone)&&"1".equals(struSeqSelect)){//上级分部
    struSql=" and supSubCompanyId>0 and subCompanyId=-1 and departmentId=-1 ";
	struLabelName=SystemEnv.getHtmlLabelName(1878,user.getLanguage());
	struColumnName="supSubCompanyId";
}else if("1".equals(struSeqAlone)&&"2".equals(struSeqSelect)){//分部
    struSql=" and supSubCompanyId=-1 and subCompanyId>0 and departmentId=-1 ";
	struLabelName=SystemEnv.getHtmlLabelName(1878,user.getLanguage());
	struColumnName="subCompanyId";
}else if("1".equals(struSeqAlone)&&"3".equals(struSeqSelect)){//部门
    struSql=" and supSubCompanyId=-1 and subCompanyId=-1 and departmentId>0 ";
	struLabelName=SystemEnv.getHtmlLabelName(15390,user.getLanguage());
	struColumnName="departmentId";
}else{
    struSql=" and supSubCompanyId=-1 and subCompanyId=-1 and departmentId=-1 ";
}


List struValueAndNameList=new ArrayList();
Map struValueAndNameMap=null;
int tempStruValue=-1;
String tempStruValueName=null;
int tempSupSubCompanyId=-1;
int tempSubCompanyId=-1;
int tempDepartmentId=-1;

if("1".equals(struSeqAlone)){
	StringBuffer struSb=new StringBuffer();
	if("1".equals(struSeqSelect)||"2".equals(struSeqSelect)){
		struSb.append(" select HrmSubCompany.id as struValue,HrmSubCompany.subCompanyName as struValueName ")
			  .append("   from HrmSubcompany  ")
			  .append("  where (HrmSubCompany.canceled is null or HrmSubCompany.canceled='0') ");
        if(!subCompanyNameOfSearch.equals("")){
		    struSb
		      .append("    and HrmSubCompany.subCompanyName like '%").append(subCompanyNameOfSearch).append("%' ");
	    }
        if(isFromSubCompanyTree.equals("true")&&subCompanyId>0){
		    struSb
		      .append("    and HrmSubcompany.id=").append(subCompanyId);
	    }
		struSb.append("  order by HrmSubCompany.showOrder asc,HrmSubCompany.id asc ");
	}else if("3".equals(struSeqSelect)){
		struSb.append(" select HrmDepartment.id as struValue,HrmDepartment.departmentName as struValueName ")
			  .append("   from HrmDepartment ")
			  .append("  where (HrmDepartment.canceled is null or HrmDepartment.canceled='0') ")
			  .append("    and HrmDepartment.subCompanyId1 in(").append(subCompanyIds).append(") ");
        if(!departmentNameOfSearch.equals("")){
		    struSb
		      .append("   and HrmDepartment.departmentName like '%").append(departmentNameOfSearch).append("%' ");
	    }
        if(isFromSubCompanyTree.equals("true")&&subCompanyId>0){
		    struSb
		      .append("    and HrmDepartment.subCompanyId1=").append(subCompanyId);
	    }
		struSb.append("  order by HrmDepartment.showOrder asc,HrmDepartment.id asc ")
			;
	}
    RecordSet.executeSql(struSb.toString());
    while(RecordSet.next()){
			tempStruValue     =Util.getIntValue(RecordSet.getString("struValue"),-1);
			tempStruValueName   =Util.null2String(RecordSet.getString("struValueName"));
			struValueAndNameMap=new HashMap();
			struValueAndNameMap.put("struValue",""+tempStruValue);
			struValueAndNameMap.put("struValueName",tempStruValueName);
			struValueAndNameList.add(struValueAndNameMap);
	}
}


if(struValueAndNameList.size()==0
 &&!("1".equals(struSeqAlone))		
  ){
	struValueAndNameMap=new HashMap();
	struValueAndNameMap.put("struValue","-1");
	struValueAndNameMap.put("struValueName","");
	struValueAndNameList.add(struValueAndNameMap);
}
%>

<%if("1".equals(dateSeqAlone)&&"1".equals(dateSeqSelect)){%>

<table class=ListStyle cellspacing=1   cols=2 >
    <COLGROUP>
<%
    if(fieldId>0&&"1".equals(fieldSequenceAlone)){
	    if("1".equals(struSeqAlone)){
			if(isFromSubCompanyTree.equals("true")&&subCompanyId>0&&!"3".equals(struSeqSelect)){
%>
  	        <COL width="10%">
  	        <COL width="20%">
  	        <COL width="10%">
  	        <COL width="25%">
  	        <tr class=header>
  	           <td><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></td>
  	           <td><%=SystemEnv.getHtmlLabelName(22780,user.getLanguage())%></td>
  	           <td><%=SystemEnv.getHtmlLabelName(22781,user.getLanguage())%></td>
  	           <td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  	        </tr>
<%
			}else{
%>
  	        <COL width="10%">
  	        <COL width="15%">
  	        <COL width="30%">
  	        <COL width="10%">
  	        <COL width="15%">
  	        <tr class=header>
  	           <td><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></td>
  	           <td><%=SystemEnv.getHtmlLabelName(22780,user.getLanguage())%></td>
  	           <td><%=struLabelName%></td>
  	           <td><%=SystemEnv.getHtmlLabelName(22781,user.getLanguage())%></td>
  	           <td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  	        </tr>
<%
			}
		}else{
%>
  	        <COL width="10%">
  	        <COL width="40%">
  	        <COL width="10%">
  	        <COL width="20%">
  	        <tr class=header>
  	           <td><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></td>
  	           <td><%=SystemEnv.getHtmlLabelName(22780,user.getLanguage())%></td>
  	           <td><%=SystemEnv.getHtmlLabelName(22781,user.getLanguage())%></td>
  	           <td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  	        </tr>
<%
		}
	}else{
	    if("1".equals(struSeqAlone)){
			if(isFromSubCompanyTree.equals("true")&&subCompanyId>0&&!"3".equals(struSeqSelect)){
%>

  	        <COL width="20%">
  	        <COL width="20%">
  	        <COL width="20%">
  	        <tr class=header>
  	           <td><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></td>
  	           <td><%=SystemEnv.getHtmlLabelName(22781,user.getLanguage())%></td>
  	           <td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  	        </tr>
<%
			}else{
%>
  	        <COL width="10%">
  	        <COL width="40%">
  	        <COL width="10%">
  	        <COL width="15%">
  	        <tr class=header>
  	           <td><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></td>
  	           <td><%=struLabelName%></td>
  	           <td><%=SystemEnv.getHtmlLabelName(22781,user.getLanguage())%></td>
  	           <td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  	        </tr>
<%
			}
		}else{
%>
  	        <COL width="20%">
  	        <COL width="20%">
  	        <COL width="20%">
  	        <tr class=header>
  	          <td><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></td>
  	          <td><%=SystemEnv.getHtmlLabelName(22781,user.getLanguage())%></td>
  	          <td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  	        </tr>
<%
		}
	}
%>

<%

String trClass="DataLight";

int tempYearId=0;
int tempFieldValue=-1;
String tempFieldValueName=null;
int tempRecordId=0;
int tempSequenceId=1;


Map recordIdMap=new HashMap();
Map sequenceIdMap=new HashMap();


String codeSeqSql=null;
if(isWorkflowSeqAlone){
	codeSeqSql="select * from workflow_codeSeq where yearId>="+yearIdBeginCodeSeqSet+" and yearId<="+yearIdEndCodeSeqSet+"  and monthId=-1 and dateId=-1 and workflowId="+workflowId+" and fieldId="+fieldId+struSql;
}else{
	codeSeqSql="select * from workflow_codeSeq where yearId>="+yearIdBeginCodeSeqSet+" and yearId<="+yearIdEndCodeSeqSet+"  and monthId=-1 and dateId=-1 and formId="+formId+" and isBill='"+isBill+"' and fieldId="+fieldId+struSql;	
}

if(fieldValueCodeSeqSet>=0){
	codeSeqSql+=" and fieldValue="+fieldValueCodeSeqSet;
}

  RecordSet.executeSql(codeSeqSql);
  while(RecordSet.next()){
	tempYearId    =Util.getIntValue(RecordSet.getString("yearId"),0);
	tempFieldValue    =Util.getIntValue(RecordSet.getString("fieldValue"),-1);
	tempStruValue    =Util.getIntValue(RecordSet.getString(struColumnName),-1);
	tempRecordId  =Util.getIntValue(RecordSet.getString("id"),0);
	tempSequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);
	if(tempYearId>0){
		recordIdMap.put(""+tempYearId+"_"+tempFieldValue+"_"+tempStruValue,""+tempRecordId);
		sequenceIdMap.put(""+tempYearId+"_"+tempFieldValue+"_"+tempStruValue,""+tempSequenceId);
	}
  }

    for(tempYearId=yearIdBeginCodeSeqSet;tempYearId<=yearIdEndCodeSeqSet;tempYearId++){
	    for(int i=0;i<selectValueAndNameList.size();i++){
		    selectValueAndNameMap=(Map)selectValueAndNameList.get(i);
		    tempFieldValue=Util.getIntValue((String)selectValueAndNameMap.get("fieldValue"),-1);
		    tempFieldValueName=Util.null2String((String)selectValueAndNameMap.get("fieldValueName"));

		    if(fieldValueCodeSeqSet>=0&&fieldValueCodeSeqSet!=tempFieldValue){
			  continue;
		    }
		    for(int j=0;j<struValueAndNameList.size();j++){
		        struValueAndNameMap=(Map)struValueAndNameList.get(j);
		        tempStruValue=Util.getIntValue((String)struValueAndNameMap.get("struValue"),-1);
		        tempStruValueName=Util.null2String((String)struValueAndNameMap.get("struValueName"));
		        tempRecordId   = Util.getIntValue((String)recordIdMap.get(""+tempYearId+"_"+tempFieldValue+"_"+tempStruValue),0);
		        tempSequenceId = Util.getIntValue((String)sequenceIdMap.get(""+tempYearId+"_"+tempFieldValue+"_"+tempStruValue),1);

%>
<TR class="<%=trClass%>">

    <td  height="23" align="left"><%=tempYearId%>
      <input type="hidden" name="codeSeq<%=rowNum%>_yearId" value="<%=tempYearId%>">
      <input type="hidden" name="codeSeq<%=rowNum%>_fieldValue" value="<%=tempFieldValue%>">
    </td>
      <input type="hidden" name="codeSeq<%=rowNum%>_monthId" value="-1">
      <input type="hidden" name="codeSeq<%=rowNum%>_dateId" value="-1">
      <input type="hidden" name="codeSeq<%=rowNum%>_recordId" value="<%=tempRecordId%>">
<%if(fieldId>0&&"1".equals(fieldSequenceAlone)){%>
    <td><%=tempFieldValueName%></td>
<%}%>

<%if("1".equals(struSeqAlone)&&("3".equals(struSeqSelect)||!isFromSubCompanyTree.equals("true")||subCompanyId<=0)){%>
    <td><%=tempStruValueName%></td>
<%}%>
<%
	if("1".equals(struSeqAlone)&&"1".equals(struSeqSelect)){//上级分部
	    tempSupSubCompanyId=tempStruValue;
	    tempSubCompanyId=-1;
	    tempDepartmentId=-1;
	}else if("1".equals(struSeqAlone)&&"2".equals(struSeqSelect)){//分部
	    tempSupSubCompanyId=-1;
	    tempSubCompanyId=tempStruValue;
	    tempDepartmentId=-1;
	}else if("1".equals(struSeqAlone)&&"3".equals(struSeqSelect)){//部门
	    tempSupSubCompanyId=-1;
	    tempSubCompanyId=-1;
	    tempDepartmentId=tempStruValue;
	}else{
	    tempSupSubCompanyId=-1;
	    tempSubCompanyId=-1;
	    tempDepartmentId=-1;
	}
%>
      <input type="hidden" name="codeSeq<%=rowNum%>_supSubCompanyId" value="<%=tempSupSubCompanyId%>">
      <input type="hidden" name="codeSeq<%=rowNum%>_subCompanyId" value="<%=tempSubCompanyId%>">
      <input type="hidden" name="codeSeq<%=rowNum%>_departmentId" value="<%=tempDepartmentId%>">

    <td  height="23" align="left">
		<input class=Inputstyle type="hidden" name="codeSeq<%=rowNum%>_sequenceId" value="<%=tempSequenceId%>">
		<%=tempSequenceId%>
	</td>

    <td>
		<A HREF="#" onClick="onShowViewReservedCode(<%=workflowId%>,<%=formId%>,<%=isBill%>,<%=tempYearId%>,-1,-1,<%=fieldId%>,<%=tempFieldValue%>,<%=tempSupSubCompanyId%>,<%=tempSubCompanyId%>,<%=tempDepartmentId%>,<%=tempRecordId%>)"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></A>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<A HREF="#" onClick="onShowNewReservedCode(<%=workflowId%>,<%=formId%>,<%=isBill%>,<%=tempYearId%>,-1,-1,<%=fieldId%>,<%=tempFieldValue%>,<%=tempSupSubCompanyId%>,<%=tempSubCompanyId%>,<%=tempDepartmentId%>,<%=tempRecordId%>)"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></A>
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
	    }
    }

%>
</table>

<%}else if("1".equals(dateSeqAlone)&&"2".equals(dateSeqSelect)){%>

<table class=ListStyle cellspacing=1   cols=3 >
    <COLGROUP>
<%
	if(fieldId>0&&"1".equals(fieldSequenceAlone)){
	    if("1".equals(struSeqAlone)){
			if(isFromSubCompanyTree.equals("true")&&subCompanyId>0&&!"3".equals(struSeqSelect)){
%>
  	        <COL width="10%">
  	        <COL width="5%">
  	        <COL width="15%">
  	        <COL width="20%">
  	        <COL width="25%">
  	        <tr class=header>
  	            <td><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></td>
	            <td><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></td>
	            <td><%=SystemEnv.getHtmlLabelName(22780,user.getLanguage())%></td>
	            <td><%=SystemEnv.getHtmlLabelName(22781,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
	        </tr>
<%
			}else{
%>
  	        <COL width="10%">
  	        <COL width="5%">
  	        <COL width="15%">
  	        <COL width="30%">
  	        <COL width="10%">
  	        <COL width="15%">
  	        <tr class=header>
  	            <td><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></td>
	            <td><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></td>
	            <td><%=SystemEnv.getHtmlLabelName(22780,user.getLanguage())%></td>
	  	        <td><%=struLabelName%></td>
	            <td><%=SystemEnv.getHtmlLabelName(22781,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
	        </tr>
<%
			}
		}else{
%>
  	        <COL width="10%">
  	        <COL width="5%">
  	        <COL width="35%">
  	        <COL width="10%">
  	        <COL width="15%">
  	        <tr class=header>
  	            <td><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></td>
	            <td><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></td>
	            <td><%=SystemEnv.getHtmlLabelName(22780,user.getLanguage())%></td>
	            <td><%=SystemEnv.getHtmlLabelName(22781,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
	        </tr>
<%
		}
	}else{
	    if("1".equals(struSeqAlone)){
			if(isFromSubCompanyTree.equals("true")&&subCompanyId>0&&!"3".equals(struSeqSelect)){
%>
  	        <COL width="15%">
  	        <COL width="10%">
  	        <COL width="20%">
  	        <COL width="20%">
  	        <tr class=header>
  	            <td><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(22781,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  	        </tr>
<%
			}else{
%>
  	        <COL width="10%">
  	        <COL width="5%">
  	        <COL width="35%">
  	        <COL width="10%">
  	        <COL width="15%">
  	        <tr class=header>
  	            <td><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></td>
	  	        <td><%=struLabelName%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(22781,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  	        </tr>
<%
			}
		}else{
%>
  	        <COL width="20%">
  	        <COL width="10%">
  	        <COL width="10%">
  	        <COL width="25%">
  	        <tr class=header>
  	            <td><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(22781,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  	        </tr>
<%
		}
	}
%>

<%

String trClass="DataLight";

int tempMonthId=0;
int tempFieldValue=-1;
String tempFieldValueName=null;
int tempRecordId=0;
int tempSequenceId=1;


Map recordIdMap=new HashMap();
Map sequenceIdMap=new HashMap();


String codeSeqSql=null;
if(isWorkflowSeqAlone){
	codeSeqSql="select * from workflow_codeSeq where yearId="+yearIdCodeSeqSet+"  and monthId>="+monthIdBeginCodeSeqSet+" and monthId<="+monthIdEndCodeSeqSet+" and dateId=-1 and workflowId="+workflowId+" and fieldId="+fieldId+struSql;
}else{
	codeSeqSql="select * from workflow_codeSeq where yearId="+yearIdCodeSeqSet+"  and monthId>="+monthIdBeginCodeSeqSet+" and monthId<="+monthIdEndCodeSeqSet+" and dateId=-1 and formId="+formId+" and isBill='"+isBill+"' and fieldId="+fieldId+struSql;	
}
if(fieldValueCodeSeqSet>=0){
	codeSeqSql+=" and fieldValue="+fieldValueCodeSeqSet;
}
  RecordSet.executeSql(codeSeqSql);
  while(RecordSet.next()){
	tempMonthId    =Util.getIntValue(RecordSet.getString("monthId"),0);
	tempFieldValue    =Util.getIntValue(RecordSet.getString("fieldValue"),-1);
	tempStruValue    =Util.getIntValue(RecordSet.getString(struColumnName),-1);
	tempRecordId  =Util.getIntValue(RecordSet.getString("id"),0);
	tempSequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);
	if(tempMonthId>0){
		recordIdMap.put(""+tempMonthId+"_"+tempFieldValue+"_"+tempStruValue,""+tempRecordId);
		sequenceIdMap.put(""+tempMonthId+"_"+tempFieldValue+"_"+tempStruValue,""+tempSequenceId);
	}
  }

    for(tempMonthId=monthIdBeginCodeSeqSet;tempMonthId<=monthIdEndCodeSeqSet;tempMonthId++){
	    for(int i=0;i<selectValueAndNameList.size();i++){
		    selectValueAndNameMap=(Map)selectValueAndNameList.get(i);
		    tempFieldValue=Util.getIntValue((String)selectValueAndNameMap.get("fieldValue"),-1);
		    tempFieldValueName=Util.null2String((String)selectValueAndNameMap.get("fieldValueName"));

		    if(fieldValueCodeSeqSet>=0&&fieldValueCodeSeqSet!=tempFieldValue){
			    continue;
		    }
		    for(int j=0;j<struValueAndNameList.size();j++){
		        struValueAndNameMap=(Map)struValueAndNameList.get(j);
		        tempStruValue=Util.getIntValue((String)struValueAndNameMap.get("struValue"),-1);
		        tempStruValueName=Util.null2String((String)struValueAndNameMap.get("struValueName"));
	            tempRecordId   = Util.getIntValue((String)recordIdMap.get(""+tempMonthId+"_"+tempFieldValue+"_"+tempStruValue),0);
	            tempSequenceId = Util.getIntValue((String)sequenceIdMap.get(""+tempMonthId+"_"+tempFieldValue+"_"+tempStruValue),1);

%>
<TR class="<%=trClass%>">
	<td  height="23" align="left"><%=yearIdCodeSeqSet%>
      <input type="hidden" name="codeSeq<%=rowNum%>_yearId" value="<%=yearIdCodeSeqSet%>">
      <input type="hidden" name="codeSeq<%=rowNum%>_fieldValue" value="<%=tempFieldValue%>">
	</td>

    <td  height="23" align="left"><%=tempMonthId%>
      <input type="hidden" name="codeSeq<%=rowNum%>_monthId" value="<%=tempMonthId%>">
    </td>
      <input type="hidden" name="codeSeq<%=rowNum%>_dateId" value="-1">
      <input type="hidden" name="codeSeq<%=rowNum%>_recordId" value="<%=tempRecordId%>">
<%if(fieldId>0&&"1".equals(fieldSequenceAlone)){%>
    <td><%=tempFieldValueName%></td>
<%}%>
<%if("1".equals(struSeqAlone)&&("3".equals(struSeqSelect)||!isFromSubCompanyTree.equals("true")||subCompanyId<=0)){%>
    <td><%=tempStruValueName%></td>
<%}%>
<%
	if("1".equals(struSeqAlone)&&"1".equals(struSeqSelect)){//上级分部
	    tempSupSubCompanyId=tempStruValue;
	    tempSubCompanyId=-1;
	    tempDepartmentId=-1;
	}else if("1".equals(struSeqAlone)&&"2".equals(struSeqSelect)){//分部
	    tempSupSubCompanyId=-1;
	    tempSubCompanyId=tempStruValue;
	    tempDepartmentId=-1;
	}else if("1".equals(struSeqAlone)&&"3".equals(struSeqSelect)){//部门
	    tempSupSubCompanyId=-1;
	    tempSubCompanyId=-1;
	    tempDepartmentId=tempStruValue;
	}else{
	    tempSupSubCompanyId=-1;
	    tempSubCompanyId=-1;
	    tempDepartmentId=-1;
	}
%>
      <input type="hidden" name="codeSeq<%=rowNum%>_supSubCompanyId" value="<%=tempSupSubCompanyId%>">
      <input type="hidden" name="codeSeq<%=rowNum%>_subCompanyId" value="<%=tempSubCompanyId%>">
      <input type="hidden" name="codeSeq<%=rowNum%>_departmentId" value="<%=tempDepartmentId%>">
    <td  height="23" align="left">
		<input class=Inputstyle type="hidden" name="codeSeq<%=rowNum%>_sequenceId" value="<%=tempSequenceId%>">
		<%=tempSequenceId%>
	</td>

    <td>
		<A HREF="#" onClick="onShowViewReservedCode(<%=workflowId%>,<%=formId%>,<%=isBill%>,<%=yearIdCodeSeqSet%>,<%=tempMonthId%>,-1,<%=fieldId%>,<%=tempFieldValue%>,<%=tempSupSubCompanyId%>,<%=tempSubCompanyId%>,<%=tempDepartmentId%>,<%=tempRecordId%>)"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></A>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<A HREF="#" onClick="onShowNewReservedCode(<%=workflowId%>,<%=formId%>,<%=isBill%>,<%=yearIdCodeSeqSet%>,<%=tempMonthId%>,-1,<%=fieldId%>,<%=tempFieldValue%>,<%=tempSupSubCompanyId%>,<%=tempSubCompanyId%>,<%=tempDepartmentId%>,<%=tempRecordId%>)"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></A>
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
	    }
  }

%>
</table>

<%}else if("1".equals(dateSeqAlone)&&"3".equals(dateSeqSelect)){%>

<table class=ListStyle cellspacing=1   cols=4 >
    <COLGROUP>
<%
	if(fieldId>0&&"1".equals(fieldSequenceAlone)){
	    if("1".equals(struSeqAlone)){
			if(isFromSubCompanyTree.equals("true")&&subCompanyId>0&&!"3".equals(struSeqSelect)){
%>
  	        <COL width="10%">
  	        <COL width="5%">
  	        <COL width="10%">
  	        <COL width="20%">
  	        <COL width="12%">
  	        <COL width="20%">
  	        <tr class=header>
  	            <td><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(22780,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(22781,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  	        </tr>
<%
			}else{
%>
  	        <COL width="10%">
  	        <COL width="5%">
  	        <COL width="5%">
  	        <COL width="15%">
  	        <COL width="25%">
  	        <COL width="10%">
  	        <COL width="15%">
  	        <tr class=header>
  	            <td><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(22780,user.getLanguage())%></td>
	  	        <td><%=struLabelName%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(22781,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  	        </tr>
<%
			}
		}else{
%>
  	        <COL width="10%">
  	        <COL width="5%">
  	        <COL width="5%">
  	        <COL width="30%">
  	        <COL width="10%">
  	        <COL width="15%">
  	        <tr class=header>
  	            <td><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(22780,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(22781,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  	        </tr>
<%
		}
	}else{
	    if("1".equals(struSeqAlone)){
			if(isFromSubCompanyTree.equals("true")&&subCompanyId>0&&!"3".equals(struSeqSelect)){
%>
  	        <COL width="15%">
  	        <COL width="10%">
  	        <COL width="10%">
  	        <COL width="15%">
  	        <COL width="20%">
  	        <tr class=header>
  	            <td><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(22781,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  	        </tr>
<%
			}else{
%>
  	        <COL width="10%">
  	        <COL width="5%">
  	        <COL width="5%">
  	        <COL width="30%">
  	        <COL width="10%">
  	        <COL width="15%">
  	        <tr class=header>
  	            <td><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%></td>
	  	        <td><%=struLabelName%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(22781,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  	        </tr>
<%
			}
		}else{
%>
  	        <COL width="20%">
  	        <COL width="5%">
  	        <COL width="5%">
  	        <COL width="10%">
  	        <COL width="25%">
  	        <tr class=header>
  	            <td><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(22781,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  	        </tr>
<%
		}
	}
%>

<%

String trClass="DataLight";

int tempDateId=0;
int tempFieldValue=-1;
String tempFieldValueName=null;
int tempRecordId=0;
int tempSequenceId=1;


Map recordIdMap=new HashMap();
Map sequenceIdMap=new HashMap();


String codeSeqSql=null;
if(isWorkflowSeqAlone){
	codeSeqSql="select * from workflow_codeSeq where yearId="+yearIdCodeSeqSet+" and monthId="+monthIdCodeSeqSet+" and dateId>="+dateIdBeginCodeSeqSet+" and dateId<="+dateIdEndCodeSeqSet+" and workflowId="+workflowId+" and fieldId="+fieldId+struSql;
}else{
	codeSeqSql="select * from workflow_codeSeq where yearId="+yearIdCodeSeqSet+" and monthId="+monthIdCodeSeqSet+" and dateId>="+dateIdBeginCodeSeqSet+" and dateId<="+dateIdEndCodeSeqSet+" and formId="+formId+" and isBill='"+isBill+"' and fieldId="+fieldId+struSql;	
}

if(fieldValueCodeSeqSet>=0){
	codeSeqSql+=" and fieldValue="+fieldValueCodeSeqSet;
}
  RecordSet.executeSql(codeSeqSql);
  while(RecordSet.next()){
	tempDateId    =Util.getIntValue(RecordSet.getString("dateId"),0);
	tempFieldValue    =Util.getIntValue(RecordSet.getString("fieldValue"),-1);
	tempStruValue    =Util.getIntValue(RecordSet.getString(struColumnName),-1);
	tempRecordId  =Util.getIntValue(RecordSet.getString("id"),0);
	tempSequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);
	if(tempDateId>0){
		recordIdMap.put(""+tempDateId+"_"+tempFieldValue+"_"+tempStruValue,""+tempRecordId);
		sequenceIdMap.put(""+tempDateId+"_"+tempFieldValue+"_"+tempStruValue,""+tempSequenceId);
	}
  }

    for(tempDateId=dateIdBeginCodeSeqSet;tempDateId<=dateIdEndCodeSeqSet;tempDateId++){
	    for(int i=0;i<selectValueAndNameList.size();i++){
		    selectValueAndNameMap=(Map)selectValueAndNameList.get(i);
		    tempFieldValue=Util.getIntValue((String)selectValueAndNameMap.get("fieldValue"),-1);
		    tempFieldValueName=Util.null2String((String)selectValueAndNameMap.get("fieldValueName"));

		    if(fieldValueCodeSeqSet>=0&&fieldValueCodeSeqSet!=tempFieldValue){
			    continue;
		    }
		    for(int j=0;j<struValueAndNameList.size();j++){
		        struValueAndNameMap=(Map)struValueAndNameList.get(j);
		        tempStruValue=Util.getIntValue((String)struValueAndNameMap.get("struValue"),-1);
		        tempStruValueName=Util.null2String((String)struValueAndNameMap.get("struValueName"));

	            tempRecordId   = Util.getIntValue((String)recordIdMap.get(""+tempDateId+"_"+tempFieldValue+"_"+tempStruValue),0);
	            tempSequenceId = Util.getIntValue((String)sequenceIdMap.get(""+tempDateId+"_"+tempFieldValue+"_"+tempStruValue),1);

%>
<TR class="<%=trClass%>">
	<td  height="23" align="left"><%=yearIdCodeSeqSet%>
      <input type="hidden" name="codeSeq<%=rowNum%>_yearId" value="<%=yearIdCodeSeqSet%>">
      <input type="hidden" name="codeSeq<%=rowNum%>_fieldValue" value="<%=tempFieldValue%>">
	</td>
    <td  height="23" align="left"><%=monthIdCodeSeqSet%>
      <input type="hidden" name="codeSeq<%=rowNum%>_monthId" value="<%=monthIdCodeSeqSet%>">
    </td>
    <td  height="23" align="left"><%=tempDateId%>
      <input type="hidden" name="codeSeq<%=rowNum%>_dateId" value="<%=tempDateId%>">
    </td>
      <input type="hidden" name="codeSeq<%=rowNum%>_recordId" value="<%=tempRecordId%>">
<%if(fieldId>0&&"1".equals(fieldSequenceAlone)){%>
    <td><%=tempFieldValueName%></td>
<%}%>
<%if("1".equals(struSeqAlone)&&("3".equals(struSeqSelect)||!isFromSubCompanyTree.equals("true")||subCompanyId<=0)){%>
    <td><%=tempStruValueName%></td>
<%}%>
<%
	if("1".equals(struSeqAlone)&&"1".equals(struSeqSelect)){//上级分部
	    tempSupSubCompanyId=tempStruValue;
	    tempSubCompanyId=-1;
	    tempDepartmentId=-1;
	}else if("1".equals(struSeqAlone)&&"2".equals(struSeqSelect)){//分部
	    tempSupSubCompanyId=-1;
	    tempSubCompanyId=tempStruValue;
	    tempDepartmentId=-1;
	}else if("1".equals(struSeqAlone)&&"3".equals(struSeqSelect)){//部门
	    tempSupSubCompanyId=-1;
	    tempSubCompanyId=-1;
	    tempDepartmentId=tempStruValue;
	}else{
	    tempSupSubCompanyId=-1;
	    tempSubCompanyId=-1;
	    tempDepartmentId=-1;
	}
%>
      <input type="hidden" name="codeSeq<%=rowNum%>_supSubCompanyId" value="<%=tempSupSubCompanyId%>">
      <input type="hidden" name="codeSeq<%=rowNum%>_subCompanyId" value="<%=tempSubCompanyId%>">
      <input type="hidden" name="codeSeq<%=rowNum%>_departmentId" value="<%=tempDepartmentId%>">
    <td  height="23" align="left">
		<input class=Inputstyle type="hidden" name="codeSeq<%=rowNum%>_sequenceId" value="<%=tempSequenceId%>">
		<%=tempSequenceId%>
	</td>

    <td>
		<A HREF="#" onClick="onShowViewReservedCode(<%=workflowId%>,<%=formId%>,<%=isBill%>,<%=yearIdCodeSeqSet%>,<%=monthIdCodeSeqSet%>,<%=tempDateId%>,<%=fieldId%>,<%=tempFieldValue%>,<%=tempSupSubCompanyId%>,<%=tempSubCompanyId%>,<%=tempDepartmentId%>,<%=tempRecordId%>)"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></A>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<A HREF="#" onClick="onShowNewReservedCode(<%=workflowId%>,<%=formId%>,<%=isBill%>,<%=yearIdCodeSeqSet%>,<%=monthIdCodeSeqSet%>,<%=tempDateId%>,<%=fieldId%>,<%=tempFieldValue%>,<%=tempSupSubCompanyId%>,<%=tempSubCompanyId%>,<%=tempDepartmentId%>,<%=tempRecordId%>)"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></A>
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
	    }
    }

%>
</table>

<%}else{%>
<table class=ListStyle cellspacing=1   cols=1 >
    <COLGROUP>
<%
	if(fieldId>0&&"1".equals(fieldSequenceAlone)){
	    if("1".equals(struSeqAlone)){
			if(isFromSubCompanyTree.equals("true")&&subCompanyId>0&&!"3".equals(struSeqSelect)){
%>
  	        <COL width="25%">
  	        <COL width="15%">
  	        <COL width="30%">
  	        <tr class=header>
  	            <td><%=SystemEnv.getHtmlLabelName(22780,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(22781,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  	        </tr>
<%
			}else{
%>
  	        <COL width="20%">
  	        <COL width="30%">
  	        <COL width="10%">
  	        <COL width="20%">
  	        <tr class=header>
  	            <td><%=SystemEnv.getHtmlLabelName(22780,user.getLanguage())%></td>
	  	        <td><%=struLabelName%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(22781,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  	        </tr>
<%
			}
		}else{
%>
  	        <COL width="40%">
  	        <COL width="20%">
  	        <COL width="15%">
  	        <tr class=header>
  	            <td><%=SystemEnv.getHtmlLabelName(22780,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(22781,user.getLanguage())%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  	         </tr>
<%
		}
	}else{
	    if("1".equals(struSeqAlone)){
			if(isFromSubCompanyTree.equals("true")&&subCompanyId>0&&!"3".equals(struSeqSelect)){
%>
  	        <COL width="30%">
  	        <COL width="30%">
  	        <tr class=header>
  	            <td><%=SystemEnv.getHtmlLabelName(22781,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  	        </tr>
<%
			}else{
%>
  	        <COL width="40%">
  	        <COL width="20%">
  	        <COL width="15%">
  	        <tr class=header>
	  	        <td><%=struLabelName%></td>
  	            <td><%=SystemEnv.getHtmlLabelName(22781,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  	        </tr>
<%
			}
		}else{
%>
  	        <COL width="20%">
  	        <COL width="30%">
  	        <tr class=header>
  	            <td><%=SystemEnv.getHtmlLabelName(22781,user.getLanguage())%></td>
				<td><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></td>
  	        </tr>
<%
		}
	}
%>
<%

String trClass="DataLight";
int tempFieldValue=-1;
String tempFieldValueName=null;
int tempRecordId=0;
int tempSequenceId=1;

Map recordIdMap=new HashMap();
Map sequenceIdMap=new HashMap();

String codeSeqSql=null;
if(isWorkflowSeqAlone){
	codeSeqSql="select * from workflow_codeSeq where yearId=-1 and monthId=-1 and dateId=-1 and workflowId="+workflowId+" and fieldId="+fieldId+struSql;
}else{
	codeSeqSql="select * from workflow_codeSeq where yearId=-1 and monthId=-1 and dateId=-1 and formId="+formId+" and isBill='"+isBill+"'  and fieldId="+fieldId+struSql;	
}

if(fieldValueCodeSeqSet>=0){
	codeSeqSql+=" and fieldValue="+fieldValueCodeSeqSet;
}

  RecordSet.executeSql(codeSeqSql);
  while(RecordSet.next()){
	tempRecordId=RecordSet.getInt("id");
	tempFieldValue    =Util.getIntValue(RecordSet.getString("fieldValue"),-1);
	tempStruValue    =Util.getIntValue(RecordSet.getString(struColumnName),-1);
	tempSequenceId=Util.getIntValue(RecordSet.getString("sequenceId"),1);
	recordIdMap.put(""+tempFieldValue+"_"+tempStruValue,""+tempRecordId);
	sequenceIdMap.put(""+tempFieldValue+"_"+tempStruValue,""+tempSequenceId);
  }

	    for(int i=0;i<selectValueAndNameList.size();i++){
		    selectValueAndNameMap=(Map)selectValueAndNameList.get(i);
		    tempFieldValue=Util.getIntValue((String)selectValueAndNameMap.get("fieldValue"),-1);
		    tempFieldValueName=Util.null2String((String)selectValueAndNameMap.get("fieldValueName"));

		    if(fieldValueCodeSeqSet>=0&&fieldValueCodeSeqSet!=tempFieldValue){
			    continue;
		    }
		    for(int j=0;j<struValueAndNameList.size();j++){
		        struValueAndNameMap=(Map)struValueAndNameList.get(j);
		        tempStruValue=Util.getIntValue((String)struValueAndNameMap.get("struValue"),-1);
		        tempStruValueName=Util.null2String((String)struValueAndNameMap.get("struValueName"));
	            tempRecordId   = Util.getIntValue((String)recordIdMap.get(""+tempFieldValue+"_"+tempStruValue),0);
	            tempSequenceId = Util.getIntValue((String)sequenceIdMap.get(""+tempFieldValue+"_"+tempStruValue),1);
%>

<TR class="<%=trClass%>">
      <input type="hidden" name="codeSeq<%=rowNum%>_fieldValue" value="<%=tempFieldValue%>">
      <input type="hidden" name="codeSeq<%=rowNum%>_recordId" value="<%=tempRecordId%>">
<%if(fieldId>0&&"1".equals(fieldSequenceAlone)){%>
    <td><%=tempFieldValueName%></td>
<%}%>
<%if("1".equals(struSeqAlone)&&("3".equals(struSeqSelect)||!isFromSubCompanyTree.equals("true")||subCompanyId<=0)){%>
    <td><%=tempStruValueName%></td>
<%}%>
<%
	if("1".equals(struSeqAlone)&&"1".equals(struSeqSelect)){//上级分部
	    tempSupSubCompanyId=tempStruValue;
	    tempSubCompanyId=-1;
	    tempDepartmentId=-1;
	}else if("1".equals(struSeqAlone)&&"2".equals(struSeqSelect)){//分部
	    tempSupSubCompanyId=-1;
	    tempSubCompanyId=tempStruValue;
	    tempDepartmentId=-1;
	}else if("1".equals(struSeqAlone)&&"3".equals(struSeqSelect)){//部门
	    tempSupSubCompanyId=-1;
	    tempSubCompanyId=-1;
	    tempDepartmentId=tempStruValue;
	}else{
	    tempSupSubCompanyId=-1;
	    tempSubCompanyId=-1;
	    tempDepartmentId=-1;
	}
%>
      <input type="hidden" name="codeSeq<%=rowNum%>_supSubCompanyId" value="<%=tempSupSubCompanyId%>">
      <input type="hidden" name="codeSeq<%=rowNum%>_subCompanyId" value="<%=tempSubCompanyId%>">
      <input type="hidden" name="codeSeq<%=rowNum%>_departmentId" value="<%=tempDepartmentId%>">
    <td  height="23" align="left">
		<input class=Inputstyle type="hidden" name="codeSeq<%=rowNum%>_sequenceId" value="<%=tempSequenceId%>">
		<%=tempSequenceId%>
	</td>

    <td>
		<A HREF="#" onClick="onShowViewReservedCode(<%=workflowId%>,<%=formId%>,<%=isBill%>,-1,-1,-1,<%=fieldId%>,<%=tempFieldValue%>,<%=tempSupSubCompanyId%>,<%=tempSubCompanyId%>,<%=tempDepartmentId%>,<%=tempRecordId%>)"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></A>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<A HREF="#" onClick="onShowNewReservedCode(<%=workflowId%>,<%=formId%>,<%=isBill%>,-1,-1,-1,<%=fieldId%>,<%=tempFieldValue%>,<%=tempSupSubCompanyId%>,<%=tempSubCompanyId%>,<%=tempDepartmentId%>,<%=tempRecordId%>)"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></A>
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
	    }
%>
</table>
<%}%>

<%
}//从分部机构树进来的流程，若不按机构流水则不能维护
else{
%>
     <table class=ListStyle cellspacing=1  >
     	<COLGROUP>
     	<COL width="100%">
	        <TR class="Title">
	            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(22815,user.getLanguage())%></TH>
	        </TR>  
	        <TR><TD height="10"></TD></TR>
     </table>
<%
}
%>

<input type="hidden" value="<%=rowNum%>" name="rowNumCodeSeqReservedSet">

</form>
</div>
<%if("1".equals(dialog)){ %>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()" style="width: 60px!important;">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%} %>

</body>
</html>
<%if(!ajax.equals("1")){ %>

<Script language=javascript>
function checkValueCodeSeqSet() {
	var dateSeqAlone=formCodeSeqSet.dateSeqAlone.value;
	var dateSeqSelect=formCodeSeqSet.dateSeqSelect.value;

	if(dateSeqAlone==1){
		if(dateSeqSelect==1){
			if(!check_form(formCodeSeqSet,"yearIdBeginCodeSeqSet,yearIdEndCodeSeqSet")) return false ;
			if(formCodeSeqSet.yearIdBeginCodeSeqSet.value.length != 4 ) {
				alert("<%=SystemEnv.getHtmlNoteName(25,user.getLanguage())%>");
				return false;
			}
			if(formCodeSeqSet.yearIdEndCodeSeqSet.value.length != 4 ) {
				alert("<%=SystemEnv.getHtmlNoteName(25,user.getLanguage())%>");
				return false;
			}
			if(formCodeSeqSet.yearIdBeginCodeSeqSet.value>formCodeSeqSet.yearIdEndCodeSeqSet.value){
				alert("<%=SystemEnv.getHtmlLabelName(21190,user.getLanguage())%>");
				return false;
			}
		}else if(dateSeqSelect==2){
			if(!check_form(formCodeSeqSet,"yearIdCodeSeqSet")) return false ;
			if(formCodeSeqSet.yearIdCodeSeqSet.value.length != 4 ) {
				alert("<%=SystemEnv.getHtmlNoteName(25,user.getLanguage())%>");
				return false;
			}
			monthIdBeginCodeSeqSet=parseInt(formCodeSeqSet.monthIdBeginCodeSeqSet.value);
			monthIdEndCodeSeqSet=parseInt(formCodeSeqSet.monthIdEndCodeSeqSet.value);
			if(monthIdBeginCodeSeqSet>monthIdEndCodeSeqSet){
				alert("<%=SystemEnv.getHtmlLabelName(21191,user.getLanguage())%>");
				return false;
			}
		}else if(dateSeqSelect==3){
			if(!check_form(formCodeSeqSet,"yearIdCodeSeqSet")) return false ;
			if(formCodeSeqSet.yearIdCodeSeqSet.value.length != 4 ) {
				alert("<%=SystemEnv.getHtmlNoteName(25,user.getLanguage())%>");
				return false;
			}
			dateIdBeginCodeSeqSet=parseInt(formCodeSeqSet.dateIdBeginCodeSeqSet.value);
			dateIdEndCodeSeqSet=parseInt(formCodeSeqSet.dateIdEndCodeSeqSet.value);
			if(dateIdBeginCodeSeqSet>dateIdEndCodeSeqSet){
				alert("<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>");
				return false;
			}
		}
	}
	return true ;
}

function onSearchCodeSeqReservedSet(obj) {
	if(checkValueCodeSeqSet()){
		obj.disabled = true;
		document.formCodeSeqSet.action="WorkflowCodeSeqReservedSet.jsp" ;
		document.formCodeSeqSet.submit();
	}
}

function onSaveCodeSeqReservedSet(obj) {
	if(checkValueCodeSeqSet()){
		obj.disabled = true;
		document.formCodeSeqSet.action="WorkflowCodeSeqReservedSetOperation.jsp" ;
		document.formCodeSeqSet.submit();
	}
}

function onChangeYearOrMonth(){
	var yearIdObj=formCodeSeqSet.yearIdCodeSeqSet;
	var monthIdObj=formCodeSeqSet.monthIdCodeSeqSet;
	var dateIdBeginObj=formCodeSeqSet.dateIdBeginCodeSeqSet;
	var dateIdEndObj=formCodeSeqSet.dateIdEndCodeSeqSet;

    var yearId=yearIdObj.value;
	var monthId=monthIdObj.value;

    if(yearId.length != 4 ) {
		alert("<%=SystemEnv.getHtmlNoteName(25,user.getLanguage())%>");
		yearIdObj.focus(); 
		return;
    }

	//每个月的初始天数
	var MonDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

	var n = MonDays[monthId - 1];
	if ( monthId ==2 && isLeapYear(yearId)){
		n++;
	}

	createDayCodeSeqSet(n,dateIdBeginObj);
	createDayCodeSeqSet(n,dateIdEndObj);
}

//填充日期下拉框
function createDayCodeSeqSet(n,day){
	//清空下拉框
	clearOptionsCodeSeqSet(day);
	//几天，就写入几项
	for(var i=1; i<=n; i++){
		day.options.add(new Option(i,i));
	}
}

//删除下拉框中的所有选项
function clearOptionsCodeSeqSet(ctl)
{
	for(var i=ctl.options.length-1; i>=0; i--){
		ctl.remove(i);
	}
}

//判断是否闰年	　　
function isLeapYear(year){
	return( (year%4==0&&year%100!=0 )|| year%400 == 0);
}

function encode(str){
    return escape(str);
}

function onShowViewReservedCode(workflowId,formId,isBill,yearId,monthId,dateId,fieldId,fieldValue,supSubCompanyId,subCompanyId,departmentId,recordId){

    var url="/workflow/workflow/showViewReservedCodeOperate.jsp?workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId;	
    url = "/systeminfo/BrowserMain.jsp?url="+escape(url);
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

</script>

<script language="vbs">
sub onShowMultiSubcompanyBrowserByDec(inputename,showname,ismand)
    tmpids = document.all(inputename).value
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiSubcompanyBrowserByDec.jsp?selectedids="&document.all(inputename).value&"&selectedDepartmentIds="&tmpids)

		if (Not IsEmpty(id1)) then
            if id1(0)<> "" then
                resourceids = id1(0)
                resourcename = id1(1)
                sHtml = ""
         
                resourceids = Mid(resourceids,2,len(resourceids))
                document.all(inputename).value= resourceids
                resourcename = Mid(resourcename,2,len(resourcename))
                while InStr(resourceids,",") <> 0
                    curid = Mid(resourceids,1,InStr(resourceids,",")-1)
                    curname = Mid(resourcename,1,InStr(resourcename,",")-1)
                    resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
                    resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
                    sHtml = sHtml&curname&"&nbsp"
                wend
                sHtml = sHtml&resourcename&"&nbsp"
                document.all(showname).innerHtml = sHtml
            else
                if ismand=1 then
		            document.all(showname).innerHtml ="<img src='/images/BacoError_wev8.gif' align=absMiddle></img>"		  
		        else
		            document.all(showname).innerHtml =""		  
		        end if 
                document.all(inputename).value=""
            end if
		end if
end sub
</script>
<%}else{%>
<script type="text/javascript">
function onSaveCodeSeqReservedSet(obj) {
	obj.disabled = true;
	formCodeSeqSet.action="WorkflowCodeSeqReservedSetOperation.jsp" ;
	formCodeSeqSet.submit();
}

function onCancelCodeSeqSet(obj){
	window.location="/workflow/workflow/WFCode.jsp?ajax=1&wfid=<%=workflowId%>";
}

//function onShowViewReservedCode(workflowId,formId,isBill,yearId,monthId,dateId,fieldId,fieldValue,supSubCompanyId,subCompanyId,departmentId,recordId){
//   	var url=encode("/workflow/workflow/showViewReservedCodeOperate.jsp?workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId);	
//	var	con = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
//}

//function onShowNewReservedCode(workflowId,formId,isBill,yearId,monthId,dateId,fieldId,fieldValue,supSubCompanyId,subCompanyId,departmentId,recordId){
//	var url=encode("/workflow/workflow/showNewReservedCodeOperate.jsp?workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId);	
//	var con = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url)
//}

function onShowViewReservedCode(workflowId,formId,isBill,yearId,monthId,dateId,fieldId,fieldValue,supSubCompanyId,subCompanyId,departmentId,recordId){

    var url=encode("/workflow/workflow/WFCodeViewReserved.jsp?workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId);	
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

    var url=encode("/workflow/workflow/WFCodeReservedForPara.jsp?workflowId="+workflowId+"&formId="+formId+"&isBill="+isBill+"&yearId="+yearId+"&monthId="+monthId+"&dateId="+dateId+"&fieldId="+fieldId+"&fieldValue="+fieldValue+"&supSubCompanyId="+supSubCompanyId+"&subCompanyId="+subCompanyId+"&departmentId="+departmentId+"&recordId="+recordId);	
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
function encode(str){
    return escape(str);
}

function onSearchCodeSeqReservedSet(obj) {
	if(checkValueCodeSeqSet()){
		obj.disabled = true;
		document.formCodeSeqSet.action="WorkflowCodeSeqReservedSet.jsp" ;
		document.formCodeSeqSet.submit();
	}
}

function onSaveCodeSeqReservedSet(obj) {
	if(checkValueCodeSeqSet()){
		obj.disabled = true;
		document.formCodeSeqSet.action="WorkflowCodeSeqReservedSetOperation.jsp" ;
		document.formCodeSeqSet.submit();
	}
}
function checkValueCodeSeqSet() {
	var dateSeqAlone=formCodeSeqSet.dateSeqAlone.value;
	var dateSeqSelect=formCodeSeqSet.dateSeqSelect.value;

	if(dateSeqAlone==1){
		if(dateSeqSelect==1){
			if(!check_form(formCodeSeqSet,"yearIdBeginCodeSeqSet,yearIdEndCodeSeqSet")) return false ;
			if(formCodeSeqSet.yearIdBeginCodeSeqSet.value.length != 4 ) {
				alert("<%=SystemEnv.getHtmlNoteName(25,user.getLanguage())%>");
				return false;
			}
			if(formCodeSeqSet.yearIdEndCodeSeqSet.value.length != 4 ) {
				alert("<%=SystemEnv.getHtmlNoteName(25,user.getLanguage())%>");
				return false;
			}
			if(formCodeSeqSet.yearIdBeginCodeSeqSet.value>formCodeSeqSet.yearIdEndCodeSeqSet.value){
				alert("<%=SystemEnv.getHtmlLabelName(21190,user.getLanguage())%>");
				return false;
			}
		}else if(dateSeqSelect==2){
			if(!check_form(formCodeSeqSet,"yearIdCodeSeqSet")) return false ;
			if(formCodeSeqSet.yearIdCodeSeqSet.value.length != 4 ) {
				alert("<%=SystemEnv.getHtmlNoteName(25,user.getLanguage())%>");
				return false;
			}
			monthIdBeginCodeSeqSet=parseInt(formCodeSeqSet.monthIdBeginCodeSeqSet.value);
			monthIdEndCodeSeqSet=parseInt(formCodeSeqSet.monthIdEndCodeSeqSet.value);
			if(monthIdBeginCodeSeqSet>monthIdEndCodeSeqSet){
				alert("<%=SystemEnv.getHtmlLabelName(21191,user.getLanguage())%>");
				return false;
			}
		}else if(dateSeqSelect==3){
			if(!check_form(formCodeSeqSet,"yearIdCodeSeqSet")) return false ;
			if(formCodeSeqSet.yearIdCodeSeqSet.value.length != 4 ) {
				alert("<%=SystemEnv.getHtmlNoteName(25,user.getLanguage())%>");
				return false;
			}
			dateIdBeginCodeSeqSet=parseInt(formCodeSeqSet.dateIdBeginCodeSeqSet.value);
			dateIdEndCodeSeqSet=parseInt(formCodeSeqSet.dateIdEndCodeSeqSet.value);
			if(dateIdBeginCodeSeqSet>dateIdEndCodeSeqSet){
				alert("<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>");
				return false;
			}
		}
	}
	return true ;
}
</script>
<% } %>

