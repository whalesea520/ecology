<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@page import="weaver.general.MouldIDConst"%>
<%@page import="org.json.JSONObject"%>
<%@ page import="weaver.file.Prop" %>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.general.TimeUtil"%>
<%@page import="java.text.DecimalFormat"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
DecimalFormat df = new DecimalFormat("##########################################0.00");
String _guid1 = UUID.randomUUID().toString();
int requestId = Util.getIntValue(Util.null2String(request.getParameter("requestid")), -1);
int workflowid = 0;
int creater = 0;

if(requestId <= 0){
	return;
}

User user = HrmUserVarify.getUser(request, response);
//out.println("user="+user+"<br />");
if(user==null){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

RecordSet rs1 = new RecordSet();
String sql1 = "select a.workflowid, a.creater from workflow_requestbase a where a.requestid = "+requestId+" "+
	" and exists (select 1 from workflow_currentoperator wc where wc.requestid = a.requestid and wc.userid="+user.getUID()+" and wc.usertype=0)";
//out.println("sql1="+sql1+"<br />");
rs1.executeSql(sql1);
if(rs1.next()){
	workflowid = rs1.getInt("workflowid");
	creater = rs1.getInt("creater");
}else{
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
//out.println("sql1 done<br />");


String guid1_fnaBudgetAssistant = "";
int grjk = 0;
int bxxx = 0;
int bxtb = 0;
sql1 = "select * from fnaBudgetAssistant a where a.eid = "+eidInt;
//out.println("sql1="+sql1+"<br />");
rs1.executeSql(sql1);
if(rs1.next()){
	guid1_fnaBudgetAssistant = Util.null2String(rs1.getString("guid1")).trim();
	grjk = rs1.getInt("grjk");
	bxxx = rs1.getInt("bxxx");
	bxtb = rs1.getInt("bxtb");
}else{
	return ;
}

String currentDate = TimeUtil.getCurrentDateString();
String[] currentDateArray = currentDate.split("-");
String currentYYYY = currentDateArray[0];
String currentMM = currentDateArray[1];
String currentDD = currentDateArray[2];
String currentLastYYYY = currentYYYY;
String currentLastMM = currentMM;
if(Util.getIntValue(currentMM)==1){
	currentLastYYYY = (Util.getIntValue(currentYYYY)-1)+"";
	currentLastMM = "12";
}else{
	currentLastMM = (Util.getIntValue(currentMM)-1)+"";
}
if(Util.getIntValue(currentLastMM)<10){
	currentLastMM = "0"+Util.getIntValue(currentLastMM);
}

Map<String, String> dataMap = new HashMap<String, String>();
String fnaWfType = FnaCommon.getFnaWfFieldInfo4Expense(workflowid, dataMap);
//out.println("workflowid="+workflowid+";fnaWfType="+fnaWfType+"<br />");
if(!"fnaFeeWf".equals(fnaWfType) && !"borrow".equals(fnaWfType) && !"repayment".equals(fnaWfType)){
	return;
}
int formid = Util.getIntValue(dataMap.get("formid"), 0);
int formidABS = Math.abs(formid);
String main_fieldIdSqr_fieldName = Util.null2String(dataMap.get("main_fieldIdSqr_fieldName")).trim();//三条流程的申请人数据库字段
//out.println("main_fieldIdSqr_fieldName="+main_fieldIdSqr_fieldName+"<br />");

request.getSession().setAttribute("fnaBudgetAssistant_View.jsp_dataMap_"+_guid1, dataMap);
request.getSession().setAttribute("fnaBudgetAssistant_View.jsp_requestId_"+_guid1, requestId+"");
request.getSession().setAttribute("fnaBudgetAssistant_View.jsp_workflowid_"+_guid1, workflowid+"");
request.getSession().setAttribute("fnaBudgetAssistant_View.jsp_fnaWfType_"+_guid1, fnaWfType+"");

request.getSession().setAttribute("fnaBudgetAssistant_View.jsp_currentDate_"+_guid1, currentDate+"");
request.getSession().setAttribute("fnaBudgetAssistant_View.jsp_currentYYYY_"+_guid1, currentYYYY+"");
request.getSession().setAttribute("fnaBudgetAssistant_View.jsp_currentMM_"+_guid1, currentMM+"");
request.getSession().setAttribute("fnaBudgetAssistant_View.jsp_currentDD_"+_guid1, currentDD+"");
request.getSession().setAttribute("fnaBudgetAssistant_View.jsp_currentLastYYYY_"+_guid1, currentLastYYYY+"");
request.getSession().setAttribute("fnaBudgetAssistant_View.jsp_currentLastMM_"+_guid1, currentLastMM+"");

int applicantid = 0;//申请人
if(!"".equals(main_fieldIdSqr_fieldName)){
	sql1 = "select a."+main_fieldIdSqr_fieldName+" sqr from formtable_main_"+formidABS+" a where a.requestid = "+requestId;
	//out.println(sql1);
	rs1.executeSql(sql1);
	if(rs1.next()){
		applicantid = rs1.getInt("sqr");
	}else{
		return;
	}
}else{
	applicantid = creater;
}

double personalLoanAmountALL = 0.00;//个人借款未还金额
double personalLoanAmountYYYY = 0.00;//本年借款未还金额
double personalLoanAmountMM = 0.00;//本月借款未还金额
double personalLoanAmountLastMM = 0.00;//上月借款未还金额

if(grjk==1 && applicantid > 0){
	personalLoanAmountALL = FnaCommon.getPersonalLoanAmount(applicantid, "", "");
	personalLoanAmountYYYY = FnaCommon.getPersonalLoanAmount(applicantid, currentYYYY+"-01-01", currentYYYY+"-12-31");
	personalLoanAmountMM = FnaCommon.getPersonalLoanAmount(applicantid, currentYYYY+"-"+currentMM+"-01", currentYYYY+"-"+currentMM+"-31");
	personalLoanAmountLastMM = FnaCommon.getPersonalLoanAmount(applicantid, currentLastYYYY+"-"+currentLastMM+"-01", currentLastYYYY+"-"+currentLastMM+"-31");
}


double defaultHeight = 334 + 21 + 171;

String url_FnaExpenseInfo_gr = "/page/element/fnaBudgetAssistant/FnaExpenseInfo.jsp?_guid1="+_guid1;
%>
<div style="width:100%;overflow:hidden;table-layout:fixed;">
	<wea:layout type="2col">
<%
if(grjk==1){
%>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(126751,user.getLanguage())%>'><!-- 个人借款未还金额 -->
<%
if(grjk==1 && (bxxx==1 || bxtb==1)){
%>
			<wea:item>
<table id="personalData" name="personalData" style="height:auto;width:100%;" cellspacing="0" cellpadding="0">
	<tr style='background-color:#ADC7EF;color:white;padding:0;height:27px'>
		<td><%=SystemEnv.getHtmlLabelName(126824,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(15279,user.getLanguage())+")"%></td><!-- 未还总计 -->
		<td><%=SystemEnv.getHtmlLabelName(126758,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(15279,user.getLanguage())+")"%></td><!-- 本月 -->
		<td><%=SystemEnv.getHtmlLabelName(126759,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(15279,user.getLanguage())+")"%></td><!-- 上月 -->
		<td><%=SystemEnv.getHtmlLabelName(126760,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(15279,user.getLanguage())+")"%></td><!-- 本年 -->
	</tr>
	<tr style="height:18px" >
		<td>
			<%=df.format(personalLoanAmountALL) %>
		</td>
		<td>
			<%=df.format(personalLoanAmountMM) %>
		</td>
		<td>
			<%=df.format(personalLoanAmountLastMM) %>
		</td>
		<td>
			<%=df.format(personalLoanAmountYYYY) %>
		</td>
	</tr>
</table>
			</wea:item>
<%
}else if(grjk==1 && bxxx==0 && bxtb==0){
	%>
	<wea:item><%=SystemEnv.getHtmlLabelName(126824,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(15279,user.getLanguage())+")"%></wea:item><!-- 未还总计 -->
	<wea:item><%=df.format(personalLoanAmountALL) %></wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(126758,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(15279,user.getLanguage())+")"%></wea:item><!-- 本月 -->
	<wea:item><%=df.format(personalLoanAmountMM) %></wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(126759,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(15279,user.getLanguage())+")"%></wea:item><!-- 上月 -->
	<wea:item><%=df.format(personalLoanAmountLastMM) %></wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(126760,user.getLanguage())+"("+SystemEnv.getHtmlLabelName(15279,user.getLanguage())+")"%></wea:item><!-- 本年 -->
	<wea:item><%=df.format(personalLoanAmountYYYY) %></wea:item>
	<%
}
%>
		</wea:group>
<%
}
%>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(21078,user.getLanguage())%>'><!-- 费用情况 -->
			<wea:item>
<iframe src="<%=url_FnaExpenseInfo_gr %>"  scrolling="no" id="tabcontentframe_<%=_guid1%>" name="tabcontentframe_<%=_guid1%>" class="flowFrame" height="<%=defaultHeight%>" frameborder="0"  width="100%"></iframe>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<style type="text/css">
	td{
		cursor:pointer;
		text-align: center;
	}
</style>

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    