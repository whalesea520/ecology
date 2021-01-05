<%@page import="weaver.hrm.finance.BankComInfo"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
StringBuffer result = new StringBuffer();

User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	result.append("{\"flag\":false,\"errorInfo\":\"error！\"}");
}else{
	String _____guid1 = Util.null2String(request.getParameter("_____guid1")).trim();
	int sqr = Util.getIntValue(request.getParameter("sqr"), -1);
	
	//boolean _flag = _____guid1.equals(Util.null2String(request.getSession().getAttribute("FnaSubmitRequestJsBorrow.jsp_____"+_____guid1+"_____"+user.getUID())).trim());

	String Khyh = "";
	String Huming = "";
	String Skzh = "";
	
	if(sqr > 0){
		RecordSet rs1 = new RecordSet();
		String _sql = "select a.* from HrmResource a where a.id = "+sqr;
		rs1.executeSql(_sql);
		if(rs1.next()){
			BankComInfo bankComInfo = new BankComInfo();
			Khyh = bankComInfo.getBankname(Util.null2String(rs1.getString("bankid1")).trim());
			Huming = Util.null2String(rs1.getString("accountname")).trim();
			Skzh = Util.null2String(rs1.getString("accountid1")).trim();
		}
	}
	
	result.append("{\"flag\":true,\"errorInfo\":"+JSONObject.quote("")+""+
		",\"Khyh\":"+JSONObject.quote(Khyh)+""+
		",\"Huming\":"+JSONObject.quote(Huming)+""+
		",\"Skzh\":"+JSONObject.quote(Skzh)+""+
		"}");
}
%><%=result.toString() %>