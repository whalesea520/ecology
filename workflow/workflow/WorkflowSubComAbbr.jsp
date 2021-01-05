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
	String enableSubcode="";
	if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		canEdit=true;
	}

	String isclose=Util.null2String(request.getParameter("isclose"));
    String ajax=Util.null2String(request.getParameter("ajax"));
	int workflowId=Util.getIntValue(Util.null2String(request.getParameter("workflowId")),0);
	RecordSet.executeSql("select enableSubcode from workflow_subComAbbr where workflowId="+workflowId+" and enableSubcode=1");
	if(RecordSet.next())enableSubcode="1";
	int formId=Util.getIntValue(Util.null2String(request.getParameter("formId")),0);
	String isBill=Util.null2String(request.getParameter("isBill"));
	int fieldId=Util.getIntValue(request.getParameter("fieldId"),-1);

    CodeBuild codeBuild = new CodeBuild(formId,isBill,workflowId);
	boolean isWorkflowSeqAlone=codeBuild.isWorkflowSeqAlone(RecordSet,workflowId);

    String subCompanyNameOfSearch = Util.null2String(request.getParameter("subCompanyNameOfSearch"));
    
    String attributes = "{'groupOperDisplay':'none','samePair':'abbrtable','groupDisplay':'none','itemAreaDisplay':'none'}"; 	
	String radioCheck1 = "checked";
	String radioCheck2 = "";
	String disabled = "";
	if(fieldId==-1){
		radioCheck1 = "";
		radioCheck2 = "";
		disabled = "disabled";
	}else{
		if("1".equals(enableSubcode)){
			radioCheck1 = "checked";
			radioCheck2 = "";
		}else{
			radioCheck1 = "";
			radioCheck2 = "checked";
			attributes = "{'groupOperDisplay':'none','samePair':'abbrtable','groupDisplay':'','itemAreaDisplay':''}";
		}
	} 
	int rowNum=0;   
 %>
 <%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(33872,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(141,user.getLanguage());

String needfav ="";
String needhelp ="";
%>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script type="text/javascript">
var dialog = parent.getDialog(window);
var parentWin = parent.getParentWindow(window);

function onSearchSubComAbbr(obj) {
	obj.disabled = true;
	formSubComAbbr.action="WorkflowSubComAbbr.jsp" ;
	formSubComAbbr.submit();
}

if("<%=isclose%>"==1){
	parentWin.location="WFCode.jsp?ajax=<%=ajax%>&wfid=<%=workflowId%>";
	dialog.close();	
}

function onSaveSubComAbbr(obj) {
	obj.disabled = true;
	formSubComAbbr.action="WorkflowSubComAbbrOperation.jsp" ;
	formSubComAbbr.submit();
}
function onCancelSubComAbbr(obj){
	window.location="/workflow/workflow/WFCode.jsp?ajax=1&wfid=<%=workflowId%>";
}
function enableShowOrHide(val){
	if(val=="1"){
		hideGroup("abbrtable");
	}else{
    	showGroup("abbrtable");
	}
}
</script>
</head>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

if(!"1".equals(enableSubcode)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearchSubComAbbr(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}

if(canEdit){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSaveSubComAbbr(this),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
}

if(ajax.equals("1")){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onCancelSubComAbbr(this),_self} " ;
    RCMenuHeight += RCMenuHeightStep;
}

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
<form id="formSubComAbbr" name="formSubComAbbr" method=post action="WorkflowSubComAbbrOperation.jsp" >
<input name=ajax type=hidden value="<%=ajax%>">
<input name=workflowId type=hidden value="<%=workflowId%>">
<input name=formId type=hidden value="<%=formId%>">
<input name=isBill type=hidden value="<%=isBill%>">
<input name=fieldId type=hidden value="<%=fieldId%>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<%	if(canEdit){ %>
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" id="zd_btn_cancle"  class="e8_btn_top" onclick="onSaveSubComAbbr(this)">				
		<%} %>
		<%--
			<span id="advancedSearch" class="advancedSearch">高级搜索</span>--%>
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span> 
		</td>
	</tr>
</table>

<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="fourCol">
	    <wea:group context="<%=SystemEnv.getHtmlLabelName(15774, user.getLanguage())%>">
	    	<wea:item><%=SystemEnv.getHtmlLabelName(1878, user.getLanguage())%></wea:item>
		    <wea:item><input type=text name=subCompanyNameOfSearch class=Inputstyle value='<%=subCompanyNameOfSearch%>'></wea:item>
	    </wea:group>
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onSearchSubComAbbr(this);"/>
				<span class="e8_sep_line">|</span>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
				<span class="e8_sep_line">|</span>
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
	    	</wea:item>
	    </wea:group>
	</wea:layout>
</div>


<wea:layout type="2col">
<%--
	<wea:group context='<%=SystemEnv.getHtmlLabelName(19342,user.getLanguage())%>' >
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(32620,user.getLanguage())%> &nbsp;&nbsp; <input name="enableSubcode" <%=radioCheck1 %> <%=disabled %> type="radio" onclick="enableShowOrHide('1')" value="1">
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(32622,user.getLanguage())%> &nbsp;&nbsp; <input name="enableSubcode" <%=radioCheck2 %> type="radio" <%=disabled %> onclick="enableShowOrHide('2')" value="">
		</wea:item>
	</wea:group> --%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(1878,user.getLanguage())%></wea:item>
		<wea:item><input type=text name=subCompanyNameOfSearch class=Inputstyle value='<%=subCompanyNameOfSearch%>'></wea:item>
	</wea:group>	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(22216,user.getLanguage())%>'>
		<wea:item attributes="{'isTableList':'true'}">
		<div style="height:350px; overflow-y:auto">
			<table class=ListStyle cellspacing=1   cols=2 >
			    <colgroup>
			  		<col width="50%">
			  		<col width="50%">
			  	</colgroup>
			    <tr class=header>
			    	<td><%=SystemEnv.getHtmlLabelName(1878,user.getLanguage())%></td>
			    	<td><%=SystemEnv.getHtmlLabelName(22216,user.getLanguage())%></td>
			    </tr>
				<%
				if(fieldId>0||fieldId<=-2){
				int tempFieldValue=0;
				String tempAbbr =null;
				
				Map subComAbbrDefMap=new HashMap();
				RecordSet.executeSql("select * from workflow_subComAbbrDef");
				while(RecordSet.next()){
					tempFieldValue=Util.getIntValue(RecordSet.getString("subCompanyId"));
					tempAbbr=Util.null2String(RecordSet.getString("abbr"));
					subComAbbrDefMap.put(""+tempFieldValue,tempAbbr);
				}
				
				String trClass="DataLight";
				
				String tempFieldValueName=null;
				int tempRecordId=0;
				
				
				StringBuffer abbrSb=new StringBuffer();
				if(isWorkflowSeqAlone){
				   abbrSb.append(" select HrmSubCompany.id as fieldValue,HrmSubCompany.subCompanyName as fieldValueName ,workflow_subComAbbr.id as recordId,workflow_subComAbbr.abbr ")
						 .append("   from HrmSubCompany ")
						 .append("      left join (select * from workflow_subComAbbr ")
						 .append(" 	             where fieldId=").append(fieldId)
						 .append(" 				 and workflowId=").append(workflowId)
						 .append(" 			    )workflow_subComAbbr ")
						 .append("     on HrmSubCompany.id=workflow_subComAbbr.fieldValue  ")
						 .append("  where (HrmSubCompany.canceled is null or HrmSubCompany.canceled='0') ");
				    if(!subCompanyNameOfSearch.equals("")){
						abbrSb
						 .append("    and HrmSubCompany.subCompanyName like '%").append(subCompanyNameOfSearch).append("%' ");
					}
				   abbrSb.append(" order by HrmSubCompany.showOrder asc,HrmSubCompany.id asc ");
				}else{
				   abbrSb.append(" select HrmSubCompany.id as fieldValue,HrmSubCompany.subCompanyName as fieldValueName ,workflow_subComAbbr.id as recordId,workflow_subComAbbr.abbr ")
						 .append(" from HrmSubCompany ")
						 .append("      left join (select * from workflow_subComAbbr ")
						 .append(" 	             where fieldId=").append(fieldId)
						 .append(" 				   and formId=").append(formId)
						 .append(" 				   and isBill='").append(isBill).append("' ")
						 .append(" 			    )workflow_subComAbbr ")
						 .append("   on	HrmSubCompany.id=workflow_subComAbbr.fieldValue  ")
						 .append("  where (HrmSubCompany.canceled is null or HrmSubCompany.canceled='0') ");
				    if(!subCompanyNameOfSearch.equals("")){
						abbrSb
						 .append("    and HrmSubCompany.subCompanyName like '%").append(subCompanyNameOfSearch).append("%' ");
					}
				   abbrSb.append(" order by HrmSubCompany.showOrder asc,HrmSubCompany.id asc ");
				}
				
				RecordSet.executeSql(abbrSb.toString());
				while(RecordSet.next()){
				    tempFieldValue     =Util.getIntValue(RecordSet.getString("fieldValue"),0);
				    tempFieldValueName   =Util.null2String(RecordSet.getString("fieldValueName"));
				    tempRecordId  =Util.getIntValue(RecordSet.getString("recordId"),0);
				    tempAbbr=Util.null2String(RecordSet.getString("abbr"));
					if(tempAbbr.equals("")){
						tempAbbr=Util.null2String((String)subComAbbrDefMap.get(""+tempFieldValue));
					}
				
				%>
				<tr class="<%=trClass%>">			
				    <td  height="23" align="left"><%=tempFieldValueName%>
				      <input type="hidden" name="abbr<%=rowNum%>_fieldValue" value="<%=tempFieldValue%>">
				    </td>
				      <input type="hidden" name="abbr<%=rowNum%>_recordId" value="<%=tempRecordId%>">
				    <td  height="23" align="left">
				<%if(canEdit){%>
						<input class=Inputstyle <%if(enableSubcode.equals("1")){%>readonly<%} %> type="text" name="abbr<%=rowNum%>_abbr" value="<%=tempAbbr%>" maxlength=20 >
				<%}else{%>
						<%=tempAbbr%>
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
				}
				%>
			</table>
			</div>
		</wea:item>
	</wea:group>	
</wea:layout>

<input type="hidden" value="<%=rowNum%>" name="rowNum">
</form>

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
<script language="javascript">
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();		
});
</script>
</html>
