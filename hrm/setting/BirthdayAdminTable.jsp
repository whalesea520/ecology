
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%><LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%out.clear(); %>
<wea:layout type="table" attributes="{'cols':'5','cws':'5%,20%,25%,25%,25%','formTableId':'TabBirthShare'}">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="thead"><input name="chkAll" type="checkbox" onclick="jsChkAll(this)"></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("26928,139",user.getLanguage())%></wea:item>
		<%
		String sql = "SELECT a.id,a.sharetype,a.seclevel,a.rolelevel,a.sharelevel," 
							 + "a.userid,a.subcompanyid,a.departmentid,a.roleid,a.foralluser " 
							 + "FROM HrmBirthdayShare a ";
		rs.executeSql(sql);
		while(rs.next()){
			String sharetype = "";
			String relatedshare = "";
			String rolelevel = "";
			String seclevel = "";
			String sharelevel = "";
			if(rs.getString("sharetype").equals("1")){
				sharetype=SystemEnv.getHtmlLabelName(179,user.getLanguage());
				relatedshare= ResourceComInfo.getLastname(rs.getString("userid"));
			}else if(rs.getString("sharetype").equals("2")){
				sharetype=SystemEnv.getHtmlLabelName(141,user.getLanguage());
				relatedshare=SubCompanyComInfo.getSubCompanydesc(rs.getString("subcompanyid"));
				seclevel = rs.getString("seclevel");
			}else if(rs.getString("sharetype").equals("3")){
				sharetype=SystemEnv.getHtmlLabelName(124,user.getLanguage());
				relatedshare=DepartmentComInfo.getDepartmentname(rs.getString("departmentid"));
				seclevel = rs.getString("seclevel");
			}else if(rs.getString("sharetype").equals("4")){
				sharetype=SystemEnv.getHtmlLabelName(122,user.getLanguage());
				relatedshare=RolesComInfo.getRolesRemark(rs.getString("roleid"));
				rolelevel = HrmTransMethod.getRoleLevelName(rs.getString("rolelevel"), user.getLanguage());
				seclevel = rs.getString("seclevel");
			}else if(rs.getString("sharetype").equals("5")){
				sharetype=SystemEnv.getHtmlLabelName(1340,user.getLanguage());
				seclevel = rs.getString("seclevel");
			}
			sharelevel=HrmTransMethod.getShareLevelName(rs.getString("sharelevel"), user.getLanguage());
			String strLevel = rolelevel;
			if(strLevel.length()>0)strLevel+="-";
			strLevel +=seclevel;
		%>
			<wea:item>
				<input name="chkId" type="checkbox" value="<%=rs.getString("id") %>">
			</wea:item>
			<wea:item><%=sharetype %></wea:item>
			<wea:item><%=relatedshare %>&nbsp;</wea:item>
			<wea:item><%=seclevel %>&nbsp;</wea:item>
			<wea:item><%=sharelevel %>&nbsp;</wea:item>
		<%} %>
	</wea:group>
</wea:layout>