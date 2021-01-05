<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.security.*,weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="sub" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="dept" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<%
//objType:1分部 2部门 3人员
String objType = Util.null2String(request.getParameter("objType"));

String flowType = Util.null2String(request.getParameter("flowType"));
int objId = Util.getIntValue(request.getParameter("objId"));
int flowId = Util.getIntValue(request.getParameter("flowId"));
String flowField = flowType.equals("0") ? "goalFlowId" : "planFlowId";
String syc = Util.null2String(request.getParameter("syc"));
String sql = "";

if(objType.equals("1")){
	sql = "UPDATE HrmPerformanceCheckFlow SET "+flowField+"="+flowId+" WHERE objId="+objId+" AND objType='"+objType+"'";
	rs2.executeSql(sql);
	if(syc.equals("y")){
		//同步下级分部
		String subCompanyIds = sub.getSubCompanyTreeStr(String.valueOf(objId));
		if(subCompanyIds.endsWith(",")) subCompanyIds=subCompanyIds.substring(0,subCompanyIds.length()-1);
		if (!"".equals(subCompanyIds)) {
			sql = "UPDATE HrmPerformanceCheckFlow SET "+flowField+"="+flowId+" WHERE objId IN ("+subCompanyIds+") AND objType='1'";
			rs2.executeSql(sql);
		}
		//同步部门、人员
		String subDepartmentIds = "";
		String[] tmp = Util.TokenizerString2(subCompanyIds,",");
		for(int i=0;i<tmp.length;i++){
			sql = "UPDATE HrmPerformanceCheckFlow SET "+flowField+"="+flowId+" WHERE objId IN (SELECT id FROM HrmDepartment WHERE subcompanyid1="+tmp[i]+") AND (objType='2' OR objType='3')";
			rs2.executeSql(sql);
		}
		sql = "UPDATE HrmPerformanceCheckFlow SET "+flowField+"="+flowId+" WHERE objId IN (SELECT id FROM HrmDepartment WHERE subcompanyid1="+objId+") AND (objType='2' OR objType='3')";
		rs2.executeSql(sql);
	}
}else if(objType.equals("2")){
	sql = "UPDATE HrmPerformanceCheckFlow SET "+flowField+"="+flowId+" WHERE objId="+objId+" AND objType='2'";
	rs2.executeSql(sql);
	if(syc.equals("y")){
		//同步人员
		sql = "UPDATE HrmPerformanceCheckFlow SET "+flowField+"="+flowId+" WHERE objId="+objId+" AND objType='3'";
		rs2.executeSql(sql);
		//同步下级部门、人员
		String subDepartmentIds = "";
		subDepartmentIds = sub.getDepartmentTreeStr(String.valueOf(objId));
		if(subDepartmentIds.endsWith(",")) subDepartmentIds=subDepartmentIds.substring(0,subDepartmentIds.length()-1);
		if (!"".equals(subDepartmentIds)) {
			sql = "UPDATE HrmPerformanceCheckFlow SET "+flowField+"="+flowId+" WHERE objId IN ("+subDepartmentIds+") AND (objType='2' OR objType='3')";
			rs2.executeSql(sql);
		}
	}
}else if(objType.equals("3")){
	sql = "UPDATE HrmPerformanceCheckFlow SET "+flowField+"="+flowId+" WHERE objId="+objId+" AND objType='3'";
	rs2.executeSql(sql);
}else if(objType.equals("0")){
	sql = "UPDATE HrmPerformanceCheckFlow SET "+flowField+"="+flowId+" WHERE objType='0'";
	rs2.executeSql(sql);
	if(syc.equals("y")){
		sql = "UPDATE HrmPerformanceCheckFlow SET "+flowField+"="+flowId+"";
		rs2.executeSql(sql);
	}
}

response.sendRedirect("checkFlowList.jsp");
%>
