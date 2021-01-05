<%@page import="weaver.fna.maintenance.FnaBorrowAmountControl"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*,weaver.conn.*,java.util.*" %>

<%@page import="weaver.fna.budget.FnaWfSet"%>
<%@page import="weaver.fna.general.FnaLanguage"%><jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FnaBudgetControl" class="weaver.fna.maintenance.FnaBudgetControl" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user==null){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String poststr1  = Util.null2String(request.getParameter("poststr1")).trim();
String poststr2  = Util.null2String(request.getParameter("poststr2")).trim();
int requestid  = Util.getIntValue(request.getParameter("requestid"),0);//流程id
int workflowid  = Util.getIntValue(request.getParameter("workflowid"),0);//流程id
int isMobile  = Util.getIntValue(request.getParameter("isMobile"),0);

//new BaseBean().writeLog("poststr1>>>>>>>>>>"+poststr1);
//new BaseBean().writeLog("poststr2>>>>>>>>>>"+poststr2);
//new BaseBean().writeLog("requestid>>>>>>>>>"+requestid);
//new BaseBean().writeLog("workflowid>>>>>>>>"+workflowid);
//new BaseBean().writeLog("isMobile>>>>>>>>>>"+isMobile);
//new BaseBean().writeLog("user>>>>>>>>>>"+user);

String returnStr = "";
try{
	DecimalFormat df = new DecimalFormat("#################################################0.00");
	
	//默认不控制或认为校验通过
	returnStr = "{\"flag\":true,\"errorInfo\":"+JSONObject.quote("")+"}";

	double hkjeHj = 0.00;//借款金额合计
	double cxjeHj = 0.00;//收款金额合计

	String[] poststr1Array = poststr1.split("\\|");
	String[] poststr2Array = poststr2.split("\\|");
	for(int i=0;i<poststr1Array.length;i++){
		String[] post1Array = Util.null2String(poststr1Array[i]).split(",");
		if(post1Array.length > 0){
			hkjeHj = Util.getDoubleValue(df.format(hkjeHj + Util.getDoubleValue(post1Array[0], 0.00)), 0.00);
		}
	}
	for(int i=0;i<poststr2Array.length;i++){
		String[] post2Array = Util.null2String(poststr2Array[i]).split(",");
		if(post2Array.length > 0){
			cxjeHj = Util.getDoubleValue(df.format(cxjeHj + Util.getDoubleValue(post2Array[0], 0.00)), 0.00);
		}
	}
	
	//处理历史数据：将老表结构中保存的：冲销校验逻辑设置；的数据转移到新的表结构中去
	FnaWfSet.clearOldFnaFeeWfInfoLogicReverseDataRepayment(workflowid);

	int rule1 = 1;
	int rule1Intensity = 2;
	int rule2 = 1;
	//"本次冲销金额：#amount1# 必须小于等于 未还金额：#amount2# ！";
	String promptSC = FnaLanguage.getPromptSC_FnaifoverJsonAjaxRepayment(user.getLanguage());
	String promptTC = "";
	String promptEN = "";
	
	rs.executeSql("select a.* \n" +
			" from fnaFeeWfInfoLogicReverse a \n" +
			" join fnaFeeWfInfo b on a.mainId = b.id \n" +
			" where b.fnaWfType = 'repayment' and b.workflowid = "+workflowid);
	if(rs.next()){
		rule1 = rs.getInt("rule1");
		rule1Intensity = rs.getInt("rule1Intensity");
		rule2 = rs.getInt("rule2");
		promptSC = Util.null2String(rs.getString("promptSC")).trim();
		promptTC = Util.null2String(rs.getString("promptTC")).trim();
		promptEN = Util.null2String(rs.getString("promptEN")).trim();
	}
	
	//是否有校验失败标志位
	boolean _errorFlag = false;
	
	if(!_errorFlag){
		//校验：还款金额合计 必须等于 冲销金额合计
		if(rule2 == 1){
			if(hkjeHj != cxjeHj){
				returnStr = "{\"flag\":false,\"errorType\":\"alert\","+
					"\"errorInfo\":"+JSONObject.quote(
							SystemEnv.getHtmlLabelName(83299,user.getLanguage())+"："+df.format(hkjeHj)+" "+//还款金额合计
							SystemEnv.getHtmlLabelName(83300,user.getLanguage())+"："+df.format(cxjeHj)+" "+//冲销金额合计
							SystemEnv.getHtmlLabelName(83301,user.getLanguage())//不一致！
					)+"}";
			}
		}
	}
	
	if(!_errorFlag){
		//控制：本次冲销金额：#amount1# 必须小于等于 未还金额：#amount2# ！
		if(rule1==1){
			String prompt = "";
			if(user.getLanguage() == 7){
				prompt = promptSC;
			}else if(user.getLanguage() == 8){
				prompt = promptEN;
			}else if(user.getLanguage() == 9){
				prompt = promptTC;
			}
			if("".equals(prompt)){
				prompt = promptSC;
			}
			
			StringBuffer returnStrSb = new StringBuffer();
			FnaBorrowAmountControl fnaBorrowAmountControl = new FnaBorrowAmountControl();
			if(!fnaBorrowAmountControl.verifyFnaSubmitRepayment(poststr2, rule1Intensity, prompt, requestid, returnStrSb)){
				returnStr = returnStrSb.toString();
			}
		}
	}
	
}catch(Exception ex1){
	new BaseBean().writeLog(ex1);
	returnStr = "{\"flag\":false,\"errorInfo\":"+JSONObject.quote(ex1.getMessage())+"}";
}
//new BaseBean().writeLog("returnStr>>>>>>>>>>"+returnStr);
%>
<%=returnStr%>