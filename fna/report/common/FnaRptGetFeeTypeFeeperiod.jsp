<%@page import="weaver.general.BaseBean"%>
<%@page import="org.json.JSONObject"%><%@ page language="java" contentType="text/html charset=GBK" %><%@ page import="weaver.general.Util" %><%@ page import="java.util.*,java.sql.Timestamp" %><%@ page import="weaver.general.GCONST" %><%@page import="weaver.hrm.HrmUserVarify"%><%@page import="weaver.hrm.User"%><jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" /><%
String result = "";

User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	response.sendRedirect("/notice/noright.jsp") ;
}else{
	String subjectId = Util.null2String(request.getParameter("subjectId")).trim();
	int maxFeeperiod = 1;

	String _sql = "select DISTINCT feeperiod from FnaBudgetfeeType where (archive is null or archive=0) and feelevel = 1 ";
	if(!"".equals(subjectId)){
		if("oracle".equalsIgnoreCase(rs1.getDBType())){
			_sql = "select DISTINCT feeperiod \n" +
				" from FnaBudgetfeeType \n" + 
				" start with id in ("+subjectId+") \n" + 
				" connect by prior Supsubject = id";
		}else{
			_sql = "WITH allsub(id,name,supsubject, archive, feelevel, feeperiod) \n" +
				"as ( \n" +
				"	SELECT id,name,supsubject, archive, feelevel, feeperiod FROM FnaBudgetfeeType where id in ("+subjectId+") \n" +
				"	UNION ALL SELECT a.id,a.name,a.supsubject, a.archive, a.feelevel, a.feeperiod FROM FnaBudgetfeeType a,allsub b where a.id = b.supsubject \n" +
				") select DISTINCT feeperiod from allsub \n" +
				"where (archive is null or archive=0) and feelevel = 1 ";
		}
	}
	rs1.executeSql(_sql);
	while(rs1.next()){
		int _feeperiod = Util.getIntValue(rs1.getString("feeperiod"), 0);
		if(_feeperiod > maxFeeperiod){
			maxFeeperiod=_feeperiod;
		}
	}
	result = "{\"maxFeeperiod\":"+maxFeeperiod+"}";
}
%><%=result %>
