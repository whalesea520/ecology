
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%><LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%out.clear(); %>
<wea:layout type="table" attributes="{'cols':'4','cws':'5%,25%,25%,25%','formTableId':'TabBirthShare'}">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="thead"><input name="chkAll" type="checkbox" onclick="jsChkAll(this)"></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("63",user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("15256,81913,15049,81914",user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("15101,261,195",user.getLanguage())%></wea:item>
		<%
		
		String sql = "SELECT a.id,a.sharetype,a.seclevel,a.seclevelend,a.reportname " 
							 + "FROM ScheduleApplicationRule a ";
		rs.executeSql(sql);
		while(rs.next()){
			String sharetype = "";
			String seclevel = "";
			String seclevelend = "";
			String reportname = "";
			String strLevel = "";
			String sharetypeName = "";
			sharetype = rs.getString("sharetype");
			if("1".equals(sharetype)){
				sharetypeName = SystemEnv.getHtmlLabelName(20081,user.getLanguage());
			}else  if("2".equals(sharetype)){
				sharetypeName = SystemEnv.getHtmlLabelName(20082,user.getLanguage());
			}
			reportname = rs.getString("reportname");
			seclevel = rs.getString("seclevel");
			seclevelend = rs.getString("seclevelend");
			if(seclevel.length() > 0 && seclevelend.length() > 0){
				strLevel = seclevel+"-"+seclevelend;
			}
		%>
			<wea:item>
				<input name="chkId" type="checkbox" value="<%=rs.getString("id") %>">
			</wea:item>
			<wea:item><%=sharetypeName %></wea:item>
			<wea:item><%=strLevel %>&nbsp;</wea:item>
			<wea:item><%=reportname %>&nbsp;</wea:item>
		<%} %>
	</wea:group>
</wea:layout>