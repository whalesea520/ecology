
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.file.*" %>
<%@ page import="weaver.hrm.common.*,weaver.common.StringUtil" %>
<%@ page import="weaver.hrm.schedule.HrmAnnualManagement"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="SptmForCowork" class="weaver.splitepage.transform.SptmForCowork" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%

int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));//分部
int departmentid = Util.getIntValue(request.getParameter("departmentid"));//部门



//取自己分部
if(subcompanyid<=0&&departmentid<=0){
	boolean isAdmin = false;
	RecordSet.executeSql("select * from hrmresourcemanager where id = "+user.getUID());
	if(RecordSet.next()){
		isAdmin = true;
	}
	if(isAdmin){
		RecordSet.executeSql("select id from hrmsubcompany WHERE (canceled IS NULL OR  canceled=0) ORDER BY showorder asc");
		if(RecordSet.next()){
			subcompanyid = RecordSet.getInt("id");
		}
	}else{
		RecordSet.executeSql("select subcompanyid1 from hrmresource where id = "+user.getUID());
		if(RecordSet.next()){
			subcompanyid = RecordSet.getInt("subcompanyid1");
		}
	}
}


StringBuffer sql = new StringBuffer(" SELECT relatedid,relatedname,operatedate,operatetime,clientaddress,operateUserId  FROM SysMaintenanceLog  WHERE 1 = 1 and operatedesc like '%年假日志%' ");
if(subcompanyid<=0){
	sql.append(" and operateitem =  'temple'");
}else{
	sql.append(" and operateitem =  '"+subcompanyid+"'");	
}
String navName =  SystemEnv.getHtmlLabelName(32940,user.getLanguage());
%>

<%    
String titlename =SystemEnv.getHtmlLabelName(32940,user.getLanguage());
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
jQuery(document).ready(function(){
<%if(navName.length()>0){%>
 parent.setTabObjName('<%=navName%>')
 <%}%>
});
</script>
</HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(32940,user.getLanguage())%>' attributes="{'groupOperDisplay':'none'}">
	<wea:item attributes="{'isTableList':'true'}">
		<wea:layout type="table" attributes="{'cols':'4','cws':'25%,25%,25%,25%'}">
			<wea:group context="" attributes="{'groupDisplay':'none'}">
			 	<wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("17482,413",user.getLanguage())%></wea:item>
			    <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(723,user.getLanguage())%></wea:item>
			    <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(26805,user.getLanguage())%></wea:item>
			    <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(32531,user.getLanguage())%></wea:item>
			  <%
			   
			    RecordSet.executeSql(sql.toString());
			    while(RecordSet.next()){
			        String relatedname = SptmForCowork.getResourceNameLink(RecordSet.getString("operateUserId"));
			        String operatedate = RecordSet.getString("operatedate");
			        String operatetime = Util.null2String(RecordSet.getString("operatetime"));
					String clientaddress = Util.null2String(RecordSet.getString("clientaddress"));
			     
			  %>
			     <wea:item><%=relatedname%></wea:item>
			     <wea:item><%=operatedate%></wea:item>
			     <wea:item><%=operatetime%></wea:item>
			     <wea:item><%=clientaddress%></wea:item>
			  <%
			    }
			  %>
			</wea:group>
		</wea:layout>
	</wea:item>
  </wea:group>
</wea:layout>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
