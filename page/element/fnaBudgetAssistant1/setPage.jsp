<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.budget.FnaWfSet"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%--以下为支持JBOSS应用服务器校验语法，作出如下改动，将<wea:layout>和<wea:group>标签头移入此页面保证标签有始有终--%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ include file="/page/element/settingCommon_params.jsp"%>
<wea:layout type="2Col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
<%@ include file="/page/element/settingCommon_dom.jsp"%>

<%--以上，为支持JBOSS应用服务器校验语法，作出如下改动，将<wea:layout>和<wea:group>标签头移入此页面保证标签有始有终--%>
<%
RecordSet rs = new RecordSet();

int hrm = 0;
int dep = 0;
int subCmp = 0;
int fcc = 0;

String sql = "select * from fnaBudgetAssistant1 where eid = "+eid+" and hpid = "+hpid+" ";
if("".equals(ebaseid)){
	sql += " and ebaseid is NULL ";
}else{
	sql += " and ebaseid = '"+StringEscapeUtils.escapeSql(ebaseid)+"' ";
}
rs.executeSql(sql);
if(rs.next()){
	hrm = rs.getInt("hrm");
	dep = rs.getInt("dep");
	subCmp = rs.getInt("subCmp");
	fcc = rs.getInt("fcc");
}
%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.conn.RecordSet"%>
		<wea:item><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></wea:item>
		<wea:item>
   			<input id="hrm" name="hrm" value="1" type="checkbox" tzCheckbox="true" <%=(hrm==1)?"checked":"" %> />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
		<wea:item>
   			<input id="dep" name="dep" value="1" type="checkbox" tzCheckbox="true" <%=(dep==1)?"checked":"" %> />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
		<wea:item>
   			<input id="subCmp" name="subCmp" value="1" type="checkbox" tzCheckbox="true" <%=(subCmp==1)?"checked":"" %> />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></wea:item>
		<wea:item>
   			<input id="fcc" name="fcc" value="1" type="checkbox" tzCheckbox="true" <%=(fcc==1)?"checked":"" %> />
		</wea:item>
	</wea:group>
</wea:layout>
