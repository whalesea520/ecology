<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.List"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.general.GCONST"%>
 <jsp:useBean id="ConfigInfo" class="com.weaver.function.ConfigInfo" scope="page"/>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.BaseBean"%>
<%@ page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@ page import="weaver.hrm.company.CompanyTreeNode"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/jsp/systeminfo/init_wev8.jsp"%> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML>
<HEAD>
<style>

</style>
</HEAD>
<%
String id = Util.null2String(request.getParameter("id"));
String Sql  = " select * from ecologypackageinfo t1 where t1.label is not null and status='0' and id="+id;
RecordSet.execute(Sql);
String name = "";
String date = "";
String tongyong = "";
String descripetion = "";
String content = "";
if(RecordSet.next()) {
	name = RecordSet.getString("name");
	date = RecordSet.getString("lastDate");
	tongyong = ((RecordSet.getString("type").equals("0")?"否":"是"));
	descripetion = RecordSet.getString("descripetion");
	content = RecordSet.getString("content");
}
//System.out.println("values:"+values); 
%>

<BODY>
<wea:layout>
<wea:group context="详情">
<wea:item>名称</wea:item>
<wea:item>
<%=name %>
</wea:item>
<wea:item>日期</wea:item>
<wea:item>
<%=date %>
</wea:item>
<wea:item>是否通用补丁包</wea:item>
<wea:item>
<%=tongyong %>
</wea:item>
<wea:item>概述</wea:item>
<wea:item>
<%=descripetion %>
</wea:item>
<wea:item>内容</wea:item>
<wea:item>
<%=content %>
</wea:item>
</wea:group>

</wea:layout>

</BODY>
</HTML>

