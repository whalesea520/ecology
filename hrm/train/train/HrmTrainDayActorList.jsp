<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.hrm.train.TrainLayoutComInfo" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<html>
<%	
String id = request.getParameter("id");
String qname = Util.null2String(request.getParameter("flowTitle"));
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#weaver").submit();
}
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(678,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(2211,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=frmMain action="TrainDayOperation.jsp" method=post>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="dosave();" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"></input>
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%
String backfields = " HrmTrainActor.id, resourceid, subcompanyid1, departmentid, isattend "; 
String fromSql  = " from HrmTrainActor, hrmresource ";
String sqlWhere = " where HrmTrainActor.resourceid = hrmresource.id and HrmTrainActor.traindayid = "+id;
String tableString = "";

if(!qname.equals("")){
	sqlWhere += " and  lastname like '%"+qname+"%'";
}		
 
tableString =" <table instanceid=\"HrmTrainDayActorListTable\" tabletype=\"checkbox\" pagesize=\"10\" >"+
		" <checkboxpopedom showmethod=\"weaver.hrm.HrmTransMethod.getAlawayTrueCheckbox\"  id=\"checkbox\"  popedompara=\"column:id\" />"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlprimarykey=\"resourceid\" sqlsortway=\"Asc\" />"+
    "			<head>"+
    "				<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(2187,user.getLanguage())+"\" column=\"isattend\" orderkey=\"isattend\" transmethod=\"weaver.hrm.HrmTransMethod.getIsattendName\"  otherpara=\""+user.getLanguage()+"\" />"+
    "				<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"resourceid\" orderkey=\"resourceid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\"/>"+
    "				<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"departmentid\" orderkey=\"departmentid\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\"/>"+
    "				<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(141,user.getLanguage())+"\" column=\"subcompanyid1\" orderkey=\"subcompanyid1\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\"/>"+
    "			</head>"+
    " </table>";
%>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="false" /> 
<input type="hidden" name=operation> 
<input type=hidden name=id value=<%=id%>>
<input type=hidden id="actor" name="actor">
 </form>
<script language=javascript>
var parentWin = parent.parent.getParentWindow(parent);
function dosave(){      
	var id = _xtable_CheckedCheckboxId();
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	jQuery("#actor").val(id);
  document.frmMain.operation.value="editActorList";
  document.frmMain.submit();
  parentWin.onBtnSearchClick();
}  
 </script>
 </BODY>
 </HTML>
