<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@page import="weaver.fna.maintenance.FnaCostCenter"%><jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	StringBuffer result = new StringBuffer();
	
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null){
		result.append("{\"flag\":false,\"errorInfo\":\"error！\"}");
	}else{
		
		int budgetfeetype = Util.getIntValue(request.getParameter("budgetfeetype"), -1);//科目id
		int orgtype = Util.getIntValue(request.getParameter("orgtype"), -1);//单位类型
		int orgid = Util.getIntValue(request.getParameter("orgid"), -1);//单位id
		if(orgtype == 0){//当为个人时
			ResourceComInfo rci = new ResourceComInfo();
			orgid = Util.getIntValue(rci.getDepartmentID(orgid+""));
		}
		String sql="select * from FnabudgetfeetypeRuleSet where mainid="+budgetfeetype;
		
		String change="";
		if(orgtype==0 || orgtype==1){
			sql+=" and type=2";
		}else if(orgtype ==2){
			sql+=" and type=1";
		}else{
			sql+=" and type="+FnaCostCenter.ORGANIZATION_TYPE;
		}
		rs.executeSql(sql);
		if(rs.getCounts()==0){
			change = "1";
		}else{
			String sql2 = "select * from FnabudgetfeetypeRuleSet where mainid="+budgetfeetype+" and orgid="+orgid;
			if(orgtype==0 || orgtype==1){
				sql2+=" and type=2";
			}else if(orgtype ==2){
				sql2+=" and type=1";
			}else{
				sql2+=" and type="+FnaCostCenter.ORGANIZATION_TYPE;
			}
			rs.executeSql(sql2);
			if(rs.getCounts()==0){
				change = "2";
			}else{
				change = "1";
			}
		}
		result.append("{\"flag\":true,\"errorInfo\":"+JSONObject.quote("")+""+
				",\"change\":"+JSONObject.quote(change)+""+
				"}");
	}
%><%=result.toString() %>