<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.fna.maintenance.FnaBorrowAmountControl"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*,weaver.conn.*,java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FnaBudgetControl" class="weaver.fna.maintenance.FnaBudgetControl" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
String poststr  = Util.null2String(request.getParameter("poststr")).trim();//科目+报销类型+报销单位+报销日期+实报金额
String poststr2  = Util.null2String(request.getParameter("poststr2")).trim();
String poststr3  = Util.null2String(request.getParameter("poststr3")).trim();
String poststr4  = Util.null2String(request.getParameter("poststr4")).trim();
int requestid  = Util.getIntValue(request.getParameter("requestid"),0);//流程id
int workflowid  = Util.getIntValue(request.getParameter("workflowid"),0);//流程id
boolean doValidateApplication = "true".equals(Util.null2String(request.getParameter("doValidateApplication")).trim());//是否是进行：预申请预算校验
String fysqlc  = Util.null2String(request.getParameter("fysqlc")).trim();//费用申请流程
String yfkZfHj  = Util.null2String(request.getParameter("yfkZfHj")).trim();
int isMobile  = Util.getIntValue(request.getParameter("isMobile"),0);

String returnStr = "";
try{
	returnStr = FnaBudgetControl.fnaWfValidator4Expense(user, poststr, poststr2, poststr3, poststr4, 
			requestid, workflowid, doValidateApplication, fysqlc, Util.getDoubleValue(yfkZfHj, 0.00), isMobile, false);
	
}catch(Exception ex1){
	new BaseBean().writeLog(ex1);
	if(!doValidateApplication){//第二次进行《预算校验》；但是，后台设置成该节点提交不需要进行校验的话
		String _returnStr_repayment = "{\"flag\":false,\"errorInfo\":"+JSONObject.quote(ex1.getMessage())+"}";
		String _returnStr_fna = "{\"flag\":false,\"errorInfo\":"+JSONObject.quote(ex1.getMessage())+"}";

		returnStr = "{\"repayment\":"+_returnStr_repayment+", "+"\"fna\":"+_returnStr_fna+"}";
		
	}else{
		returnStr = "{\"flag\":false,\"errorInfo\":"+JSONObject.quote(ex1.getMessage())+"}";
		
	}
}
//new BaseBean().writeLog("returnStr>>>>>>>>>>"+returnStr);
%>
<%=returnStr%>