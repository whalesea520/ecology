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

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

RecordSet rs = new RecordSet();

int grjk = 0;
int bxxx = 0;
int bxtb = 0;

String sql = "select * from fnaBudgetAssistant where eid = "+eid+" and hpid = "+hpid+" ";
if("".equals(ebaseid)){
	sql += " and ebaseid is NULL ";
}else{
	sql += " and ebaseid = '"+StringEscapeUtils.escapeSql(ebaseid)+"' ";
}
rs.executeSql(sql);
if(rs.next()){
	grjk = rs.getInt("grjk");
	bxxx = rs.getInt("bxxx");
	bxtb = rs.getInt("bxtb");
}
%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.conn.RecordSet"%>

		<wea:item><%=SystemEnv.getHtmlLabelName(126747,user.getLanguage())%></wea:item><!-- 个人借款信息 -->
		<wea:item>
   			<input id="grjk" name="grjk" value="1" type="checkbox" tzCheckbox="true" <%=(grjk==1)?"checked":"" %> />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(126748,user.getLanguage())%></wea:item><!-- 报销信息 -->
		<wea:item>
   			<input id="bxxx" name="bxxx" value="1" type="checkbox" tzCheckbox="true" <%=(bxxx==1)?"checked":"" %> />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(126750,user.getLanguage())%></wea:item><!-- 报销图表 -->
		<wea:item>
   			<input id="bxtb" name="bxtb" value="1" type="checkbox" tzCheckbox="true" <%=(bxtb==1)?"checked":"" %> />
		</wea:item>
	</wea:group>
</wea:layout>
