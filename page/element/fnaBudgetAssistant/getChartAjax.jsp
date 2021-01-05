<%@page import="weaver.systeminfo.SystemEnv"%><%@page import="org.apache.commons.lang.StringEscapeUtils"%><%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%><%@page import="org.json.JSONObject"%>
<%@ page import="weaver.general.*,weaver.conn.*,java.util.*" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="java.text.DecimalFormat" %>
<%
RecordSet rs1 = new RecordSet();

User user = HrmUserVarify.getUser(request , response);
if(user==null){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String _guid1 = Util.null2String(request.getParameter("_guid1")).trim();
int month = Util.getIntValue(request.getParameter("month"));

Map<String, String> dataMap = (Map<String, String>)request.getSession().getAttribute("fnaBudgetAssistant_View.jsp_dataMap_"+_guid1);
int requestId = Util.getIntValue((String)request.getSession().getAttribute("fnaBudgetAssistant_View.jsp_requestId_"+_guid1));
int workflowid = Util.getIntValue((String)request.getSession().getAttribute("fnaBudgetAssistant_View.jsp_workflowid_"+_guid1));
String fnaWfType = (String)request.getSession().getAttribute("fnaBudgetAssistant_View.jsp_fnaWfType_"+_guid1);

String currentDate = (String)request.getSession().getAttribute("fnaBudgetAssistant_View.jsp_currentDate_"+_guid1);
String currentYYYY = (String)request.getSession().getAttribute("fnaBudgetAssistant_View.jsp_currentYYYY_"+_guid1);
String currentMM = (String)request.getSession().getAttribute("fnaBudgetAssistant_View.jsp_currentMM_"+_guid1);
String currentDD = (String)request.getSession().getAttribute("fnaBudgetAssistant_View.jsp_currentDD_"+_guid1);
String currentLastYYYY = (String)request.getSession().getAttribute("fnaBudgetAssistant_View.jsp_currentLastYYYY_"+_guid1);
String currentLastMM = (String)request.getSession().getAttribute("fnaBudgetAssistant_View.jsp_currentLastMM_"+_guid1);


int formid = Util.getIntValue(dataMap.get("formid"), 0);
int formidABS = Math.abs(formid);
String main_fieldIdSqr_fieldName = Util.null2String(dataMap.get("main_fieldIdSqr_fieldName")).trim();//三条流程的申请人数据库字段
String fieldIdSubject_fieldName = Util.null2String(dataMap.get("fieldIdSubject_fieldName")).trim();//报销流程的报销明细的科目数据库字段
String fieldIdSubject_isDtl = Util.null2String(dataMap.get("fieldIdSubject_fieldId_isDtl"));


String feetypeIds = (String)request.getSession().getAttribute("fnaBudgetAssistant_View.jsp_feetypeIds_"+_guid1);
List<String> feetypeList = (List<String>)request.getSession().getAttribute("fnaBudgetAssistant_View.jsp_feetypeList_"+_guid1);
int creater = Util.getIntValue((String)request.getSession().getAttribute("fnaBudgetAssistant_View.jsp_creater_"+_guid1), 0);

String sql = "select 1 from workflow_requestbase a where a.requestid = "+requestId+" "+
	" and exists (select 1 from workflow_currentoperator wc where wc.requestid = a.requestid and wc.userid="+user.getUID()+" and wc.usertype=0)";
rs1.executeSql(sql);
if(rs1.next()){
}else{
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String returnStr = "";
DecimalFormat df = new DecimalFormat("######################################0.00");
List<Map<String,String>> drilldown_actualAmt = new ArrayList<Map<String,String>>();
List<Map<String,String>> drilldown_applyAmt = new ArrayList<Map<String,String>>();

try{
	HashMap<String, String> sum_applyAmt = new HashMap<String, String>();
	HashMap<String, String> sum_actualAmt = new HashMap<String, String>();
	
	String	categories = "[";
	String[] fromdateArray = new String[]{currentYYYY+"-01-01",currentYYYY+"-02-01",currentYYYY+"-03-01"
						,currentYYYY+"-04-01",currentYYYY+"-05-01",currentYYYY+"-06-01"
						,currentYYYY+"-07-01",currentYYYY+"-08-01",currentYYYY+"-09-01"
						,currentYYYY+"-10-01",currentYYYY+"-11-01",currentYYYY+"-12-01"};
	String[] todateArray = new String[]{currentYYYY+"-01-31",currentYYYY+"-02-31",currentYYYY+"-03-31"
						,currentYYYY+"-04-30",currentYYYY+"-05-31",currentYYYY+"-06-30"
						,currentYYYY+"-07-31",currentYYYY+"-08-31",currentYYYY+"-09-30"
						,currentYYYY+"-10-31",currentYYYY+"-11-30",currentYYYY+"-12-31"};
	int fromi = -1;
	int toi = -1;
	if(month <= 2){
		fromi = 0;
		toi = 4;
	}else if(month >= 10){
		fromi = 7;
		toi = 11;
	}else{
		fromi = month-3;
		toi = month+1;
	}

	for(int i = fromi; i <= toi; i++){
		if(i > fromi){
			categories += ",";
		}
		categories += "\""+(i+1)+SystemEnv.getHtmlLabelName(887,user.getLanguage())+"\"";//月份
		
		//预算总额、预算申请金额、实际金额
		sum_applyAmt.put(i+"", "0.00");
		sum_actualAmt.put(i+"", "0.00");
	}
	categories += "]";
	
	if(feetypeList.size() > 0){
		for(int i = fromi; i <= toi; i++){
			sql = "select a.status, SUM(a.amount) sumAmt  \n" +
				" from workflow_requestbase wr \n" +
				" join FnaExpenseInfo a on wr.requestid = a.requestid \n" +
				" where wr.currentnodetype <> 0 \n"+
				" and a.subject in ("+feetypeIds.toString()+") \n" +
				" and wr.creater = "+creater+" \n" + 
				" and (a.occurdate >= '"+StringEscapeUtils.escapeSql(fromdateArray[i])+"' and a.occurdate <= '"+StringEscapeUtils.escapeSql(todateArray[i])+"') "+
				" group by a.status ";
			//new BaseBean().writeLog(sql);
			rs1.executeSql(sql);
			while(rs1.next()){
				int status = rs1.getInt("status");
				if(status==0){
					sum_applyAmt.put(i+"", df.format(Util.getDoubleValue(rs1.getString("sumAmt"), 0.00)));
				}else if(status==1){
					sum_actualAmt.put(i+"", df.format(Util.getDoubleValue(rs1.getString("sumAmt"), 0.00)));
				}
			}
		}
	}
	
	String sum_actualAmt_str = "[";
	String sum_applyAmt_str = "[";
	for(int i = fromi; i <= toi; i++){
		if(!"[".equals(sum_actualAmt_str)){
			sum_actualAmt_str += ",";
			sum_applyAmt_str += ",";
		}
		sum_actualAmt_str += sum_actualAmt.get(i+"");
		sum_applyAmt_str += sum_applyAmt.get(i+"");
	}
	sum_actualAmt_str += "]";
	sum_applyAmt_str += "]";
	
	returnStr = "{\"categories\":"+JSONObject.quote(categories)+"," +
		"\"sum_actualAmt_str\":"+JSONObject.quote(sum_actualAmt_str)+"," +
		"\"sum_applyAmt_str\":"+JSONObject.quote(sum_applyAmt_str)+"" +
	"}";
	//new BaseBean().writeLog("returnStr:"+returnStr);
	//returnStr = "{\"aa\":1,\"bb\":2}";
}catch(Exception e ){
	new BaseBean().writeLog(e);
}
%>   
<%=returnStr%>