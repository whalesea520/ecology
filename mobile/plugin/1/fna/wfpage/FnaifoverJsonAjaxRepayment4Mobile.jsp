<%@page import="weaver.file.FileUpload"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.HashMap"%>
<%@page import="weaver.fna.maintenance.FnaBorrowAmountControl"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.general.BaseBean"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@page import="weaver.fna.maintenance.FnaBudgetControl"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
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

if(workflowid <= 0){
    FileUpload fu = new FileUpload(request,false);
    poststr1 = Util.null2String(fu.getParameter("poststr1")).trim();
    poststr2 = Util.null2String(fu.getParameter("poststr2")).trim();
    requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
    workflowid = Util.getIntValue(fu.getParameter("workflowid"), 0);
}

poststr1 = poststr1.replaceAll(",s,", "|");
poststr2 = poststr2.replaceAll(",s,", "|");

if(!"".equals(poststr2)){
	DecimalFormat df = new DecimalFormat("#################################################0.00");
	
	FnaBudgetControl fnaBudgetControl = new FnaBudgetControl();
	Map<String, String> dataMap = new HashMap<String, String>();
	fnaBudgetControl.getFnaWfFieldInfo4Expense(workflowid, dataMap);
	int formid = Util.getIntValue(dataMap.get("formid"));
	int formidABS = Math.abs(formid);
	String dt2_fieldIdJklc_fieldName = Util.null2String(dataMap.get("dt2_fieldIdJklc_fieldName"));
	
	int jklcDbHmKey = 0;
	HashMap<String, String> jklcDbHm = new HashMap<String, String>();
	String sql = "select b."+dt2_fieldIdJklc_fieldName+" jklc \n" +
		" from formtable_main_"+formidABS+" a\n" + 
		" join formtable_main_"+formidABS+"_dt2 b on a.id = b.mainid\n" + 
		" where a.requestid = "+requestid+" \n" + 
		" order by b.id asc";
	rs.executeSql(sql);
	while(rs.next()){
		jklcDbHm.put(jklcDbHmKey+"", Util.null2String(rs.getString("jklc")));
		jklcDbHmKey++;
	}
	
	String[] poststr2Array = poststr2.split("\\|");
	int poststr2ArrayLen = poststr2Array.length;
	poststr2 = "";
	for(int i=0;i<poststr2ArrayLen;i++){
		String[] post2Array = Util.null2String(poststr2Array[i]).split(",");
		double cxje = Util.getDoubleValue(post2Array[0], 0.00);
		String jklc_str = post2Array[1];
		int jklc = Util.getIntValue(post2Array[1], -1);
		int dnxh = Util.getIntValue(post2Array[2], -1);
		if("undefined".equalsIgnoreCase(jklc_str)){
			jklc = Util.getIntValue(jklcDbHm.get(i+""), -1);
		}
		if(i>0){
			poststr2 += "|";
		}
		poststr2 += df.format(cxje)+","+jklc+","+dnxh;
	}
}



%><jsp:include page="/fna/wfPage/FnaifoverJsonAjaxRepayment.jsp" flush="true">
	<jsp:param name="poststr1" value="<%=poststr1%>" />
	<jsp:param name="poststr2" value="<%=poststr2%>" />
	<jsp:param name="requestid" value="<%=requestid%>" />
	<jsp:param name="workflowid" value="<%=workflowid%>" />
	<jsp:param name="isMobile" value="1" />
</jsp:include>