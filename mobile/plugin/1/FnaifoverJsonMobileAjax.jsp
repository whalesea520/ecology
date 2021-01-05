<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*,weaver.conn.*,java.util.*" %>

<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.fna.maintenance.FnaBudgetControl"%><jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user==null){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String poststr  = Util.null2String(request.getParameter("poststr")).trim();//科目+报销类型+报销单位+报销日期+实报金额
String poststr2  = Util.null2String(request.getParameter("poststr2")).trim();
String poststr3  = Util.null2String(request.getParameter("poststr3")).trim();
String poststr4  = Util.null2String(request.getParameter("poststr4")).trim();
int requestid  = Util.getIntValue(request.getParameter("requestid"),0);
int workflowid  = Util.getIntValue(request.getParameter("workflowid"),0);
String doValidateApplication  = Util.null2String(request.getParameter("doValidateApplication")).trim();//是否是进行：预申请预算校验
String fysqlc  = Util.null2String(request.getParameter("fysqlc")).trim();//费用申请流程
String yfkZfHj  = Util.null2String(request.getParameter("yfkZfHj")).trim();

if("".equals(poststr) && requestid <= 0 && workflowid <= 0){
    FileUpload fu = new FileUpload(request,false);
    poststr = Util.null2String(fu.getParameter("poststr")).trim();
    poststr2 = Util.null2String(fu.getParameter("poststr2")).trim();
    poststr3 = Util.null2String(fu.getParameter("poststr3")).trim();
    poststr4 = Util.null2String(fu.getParameter("poststr4")).trim();
    requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
    workflowid = Util.getIntValue(fu.getParameter("workflowid"), 0);
    doValidateApplication = Util.null2String(fu.getParameter("doValidateApplication")).trim();
    fysqlc = Util.null2String(fu.getParameter("fysqlc")).trim();
    yfkZfHj = Util.null2String(fu.getParameter("yfkZfHj")).trim();
}

//由于手机版做了特殊处理，不能使用|等字符传参，故使用了,s,替换了|进行传参，此处需要将,s,替换成|以便后续业务逻辑识别
poststr = poststr.replaceAll(",s,", "|");
poststr2 = poststr2.replaceAll(",s,", "|");
poststr3 = poststr3.replaceAll(",s,", "|");
poststr4 = poststr4.replaceAll(",s,", "|");

boolean enableRepayment = false;
boolean enableReverseAdvance = false;
int formidABS = 0;
String dt4_fieldIdYfklc_fieldName = "";
String dt2_fieldIdJklc_fieldName = "";
if(!"".equals(poststr2) || !"".equals(poststr4)){
	String sql = "select * from fnaFeeWfInfo where workflowid = "+workflowid;
	rs.executeSql(sql);
	if(rs.next()){
		int fnaFeeWfInfoId = rs.getInt("id");
		int fnaWfTypeColl = rs.getInt("fnaWfTypeColl");
		int fnaWfTypeReverse = rs.getInt("fnaWfTypeReverse");
		enableRepayment = (fnaWfTypeReverse>0 && fnaWfTypeColl>0);
		enableReverseAdvance = rs.getInt("fnaWfTypeReverseAdvance")==1;
	}
	if(enableRepayment || enableReverseAdvance){
		FnaBudgetControl fnaBudgetControl = new FnaBudgetControl();
		Map<String, String> dataMap = new HashMap<String, String>();
		fnaBudgetControl.getFnaWfFieldInfo4Expense(workflowid, dataMap);
		int formid = Util.getIntValue(dataMap.get("formid"));
		formidABS = Math.abs(formid);
		dt4_fieldIdYfklc_fieldName = Util.null2String(dataMap.get("dt4_fieldIdYfklc_fieldName"));
		dt2_fieldIdJklc_fieldName = Util.null2String(dataMap.get("dt2_fieldIdJklc_fieldName"));
	}
}

DecimalFormat df = new DecimalFormat("#################################################0.00");
String sql = "";
if(!"".equals(poststr2) && enableRepayment){
	int jklcDbHmKey = 0;
	HashMap<String, String> jklcDbHm = new HashMap<String, String>();
	sql = "select b."+dt2_fieldIdJklc_fieldName+" jklc \n" +
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

if(!"".equals(poststr4) && enableReverseAdvance){
	int YfklcDbHmKey = 0;
	HashMap<String, String> YfklcDbHm = new HashMap<String, String>();
	sql = "select b."+dt4_fieldIdYfklc_fieldName+" Yfklc \n" +
		" from formtable_main_"+formidABS+" a\n" + 
		" join formtable_main_"+formidABS+"_dt4 b on a.id = b.mainid\n" + 
		" where a.requestid = "+requestid+" \n" + 
		" order by b.id asc";
	rs.executeSql(sql);
	while(rs.next()){
		YfklcDbHm.put(YfklcDbHmKey+"", Util.null2String(rs.getString("Yfklc")));
		YfklcDbHmKey++;
	}
	
	String[] poststr4Array = poststr4.split("\\|");
	int poststr4ArrayLen = poststr4Array.length;
	poststr4 = "";
	for(int i=0;i<poststr4ArrayLen;i++){
		String[] post4Array = Util.null2String(poststr4Array[i]).split(",");
		double cxje = Util.getDoubleValue(post4Array[0], 0.00);
		String Yfklc_str = post4Array[1];
		int Yfklc = Util.getIntValue(post4Array[1], -1);
		int dnxh = Util.getIntValue(post4Array[2], -1);
		if("undefined".equalsIgnoreCase(Yfklc_str)){
			Yfklc = Util.getIntValue(YfklcDbHm.get(i+""), -1);
		}
		if(i>0){
			poststr4 += "|";
		}
		poststr4 += df.format(cxje)+","+Yfklc+","+dnxh;
	}
}

%><jsp:include page="/fna/budget/FnaifoverJsonAjax.jsp" flush="true">
	<jsp:param name="poststr" value="<%=poststr%>" />
	<jsp:param name="poststr2" value="<%=poststr2%>" />
	<jsp:param name="poststr3" value="<%=poststr3%>" />
	<jsp:param name="poststr4" value="<%=poststr4%>" />
	<jsp:param name="requestid" value="<%=requestid%>" />
	<jsp:param name="workflowid" value="<%=workflowid%>" />
	<jsp:param name="doValidateApplication" value="<%=doValidateApplication%>" />
	<jsp:param name="fysqlc" value="<%=fysqlc%>" />
	<jsp:param name="yfkZfHj" value="<%=yfkZfHj%>" />
	<jsp:param name="isMobile" value="1" />
</jsp:include>