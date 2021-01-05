<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.rtx.OrganisationCom"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.general.BaseBean"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%
String result = "";
User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	result = "";
}else{
	OrganisationCom ocObj = new OrganisationCom();
	String result_company = "";
	String result_hrm = "";


	boolean rtxOpFlag = ocObj.isRtxOpFlag();
	double _index_company = ocObj.getRtxDeptOpProcess();
	boolean _isDone_company = ocObj.isRtxDeptOpFlag();
	double _index_hrm = ocObj.getRtxHrmOpProcess();
	boolean _isDone_hrm = ocObj.isRtxHrmOpFlag();

	if(_isDone_company){
		result_company = "\"company\":\""+new java.text.DecimalFormat("##0.00").format(_index_company)+"\",\"companyFlag\":true";
	}else{
		result_company = "\"companyFlag\":false";
	}

	if(_isDone_hrm){
		result_hrm = "\"hrm\":\""+new java.text.DecimalFormat("##0.00").format(_index_hrm)+"\",\"hrmFlag\":true";
	}else{
		result_hrm = "\"hrmFlag\":false";
	}


	String result_rtxop = "\"hasComplished\":false";
	if(_isDone_company && _isDone_hrm && !rtxOpFlag){
		ocObj.setRtxDeptOpFlag(false);
		ocObj.setRtxHrmOpFlag(false);

		ocObj.setRtxDeptOpProcess(0d);
		ocObj.setRtxHrmOpProcess(0d);

		result_rtxop = "\"hasComplished\":true";
	}

	String resultOfRtxOpErrorFlag = "\"rtxOpErrorFlag\":"+ocObj.isRtxOpErrorFlag()+",\"rtxOpErrorInfo\":\""+ocObj.getRtxOpErrorInfo()+"\"";

	result = "{"+StringEscapeUtils.escapeSql(result_company)+","+StringEscapeUtils.escapeSql(result_hrm)+","+result_rtxop+","+resultOfRtxOpErrorFlag+"}";
	ocObj.setRtxOpErrorFlag(false);
	//new BaseBean().writeLog("------ajax result:"+result);
}
%><%=result %>
