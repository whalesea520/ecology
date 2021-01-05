<%@page import="weaver.prj.util.ResourceUtil"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.general.TimeUtil"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.prj.util.PrjCardUtil"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.hrm.*"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.regex.*" %>
<%
StringBuffer sbJSON = new StringBuffer("");
String opt = request.getParameter("opt");

String currentDateString = TimeUtil.getCurrentDateString();
String[] currentDateStringArray = currentDateString.split("-");
String yyyy = currentDateStringArray[0]; 
String yyyyMM = currentDateStringArray[0]+"-"+currentDateStringArray[1]; 

Random random = new Random();
int randomInt = random.nextInt();
if(randomInt < 0){
	randomInt *= -1;
}

//User user = HrmUserVarify.getUser (request , response) ;
int _userid = Util.getIntValue(request.getParameter("userid"));
UserManager userManager = new UserManager();
User user = userManager.getUserByUserIdAndLoginType(_userid, "1");

String userid = user.getUID()+"";

int customerid1 = Util.getIntValue(request.getParameter("customerid1"));/*具体某一个项目的id*/

ResourceComInfo rci = new ResourceComInfo();


String projName = "";
String prdctType = "";
String projManager = "";
String manager = "";
String planstartdate = "";
String planApprovalDate = "";
String gdrq = "";
String zjlf = "";
String deliveryModule = "";
String requirement = "";

RecordSet rs1 = new RecordSet();
String sql = "";

int beginNum = Util.getIntValue(request.getParameter("beginNum"));
int pageNum = Util.getIntValue(request.getParameter("pageNum"));

if("logOpt".equals(opt)){
	sql = "select * from ( ";
	sql+= "select distinct row_number() over(ORDER BY opdate DESC, optime DESC) as rowNum, id, opreator, opreatortype, opdate, optime from ( ";
	sql+= "select id, opreator, opreatortype, opdate, optime, max(fkid) as fkid from ( ";
	sql+= "select id, opreator, opreatortype, opdate, optime, id as fkid from proj_opreatorlog a where a.cbi_id="+customerid1+") as t0 group by id, opreator, opreatortype, opdate, optime ) as t ) as sp_t ";
	sql+= "WHERE rowNum >= "+beginNum+" and rowNum < "+(beginNum+pageNum)+" ";
	rs1.executeSql(sql);//out.println(sql);
	if(rs1.getCounts()==0){
		sbJSON.append("{\"totalSize\":\"0\", \"datas\":[");
	}else{
		sbJSON.append("{\"totalSize\":\"99999\", \"datas\":[");
	}
	while(rs1.next()){
		String _lastName = rci.getLastname(rs1.getString("opreator"));
		String _opdate = Util.null2String(rs1.getString("opdate")).trim();
		String _optime = Util.null2String(rs1.getString("opTime")).trim();
		String _opYear = "";
		String _opDay = "";
		if(_opdate.length()>=10){
			_opYear = _opdate.substring(0,4);
			_opDay = _opdate.substring(5,10);
		}
		String _opreatortype = Util.null2String(rs1.getString("opreatortype")).trim();

		sbJSON.append("{\"logId\":\""+rs1.getString("id")+"\", \"logUser\":\""+_lastName+"\", \"logDate\":\""+_opdate+"\", \"logDateYear\":\""+_opYear+"\", \"logDateDay\":\""+_opDay+"\", \"logTime\":\""+_optime+"\", \"logType\":\""+delHTMLTag(_opreatortype)+"\"},");
	}

}else if("logVisit".equals(opt)){
	sql = "select * from ( ";
	sql+= "select distinct row_number() over(ORDER BY opdate DESC, optime DESC) as rowNum, id, uid, opDate, opTime from ( ";
	sql+= "select id, uid, opDate, opTime, max(fkid) as fkid from ( ";
	sql+= "select id, uid, opDate, opTime, id as fkid from proj_visitInfo a where a.cbi_id="+customerid1+") as t0 group by id, uid, opDate, opTime ) as t ) as sp_t ";
	sql+= "WHERE rowNum >= "+beginNum+" and rowNum < "+(beginNum+pageNum)+" ";
	//out.println(sql);
	rs1.executeSql(sql);
	if(rs1.getCounts()==0){
		sbJSON.append("{\"totalSize\":\"0\", \"datas\":[");
	}else{
		sbJSON.append("{\"totalSize\":\"99999\", \"datas\":[");
	}
	while(rs1.next()){
		String _lastName = rci.getLastname(rs1.getString("uid"));
		String _opdate = Util.null2String(rs1.getString("opDate")).trim();
		String _optime = Util.null2String(rs1.getString("opTime")).trim();
		String _opYear = "";
		String _opDay = "";
		if(_opdate.length()>=10){
			_opYear = _opdate.substring(0,4);
			_opDay = _opdate.substring(5,10);
		}

		sbJSON.append("{\"logId\":\""+rs1.getString("id")+"\", \"logUser\":\""+_lastName+"\", \"logDate\":\""+_opdate+"\", \"logDateYear\":\""+_opYear+"\", \"logDateDay\":\""+_opDay+"\", \"logTime\":\""+_optime+"\"},");
	}
}
String strJSON = sbJSON.toString();
if(strJSON.endsWith(",")){
	strJSON = strJSON.substring(0, strJSON.length()-1);
}
strJSON += "]}";
out.println(strJSON);
%>


<%!
String regEx_script = "<script[^>]*?>[\\s\\S]*?<\\/script>"; // 定义script的正则表达式   
String regEx_style = "<style[^>]*?>[\\s\\S]*?<\\/style>"; // 定义style的正则表达式    
String regEx_html = "<[^>]+>"; // 定义HTML标签的正则表达式 

String delHTMLTag(String htmlStr) {        
	Pattern p_script = Pattern.compile(regEx_script, Pattern.CASE_INSENSITIVE);        
	Matcher m_script = p_script.matcher(htmlStr);        
	htmlStr = m_script.replaceAll(""); // 过滤script标签        
	Pattern p_style = Pattern.compile(regEx_style, Pattern.CASE_INSENSITIVE);        
	Matcher m_style = p_style.matcher(htmlStr);        
	htmlStr = m_style.replaceAll(""); // 过滤style标签        
	Pattern p_html = Pattern.compile(regEx_html, Pattern.CASE_INSENSITIVE);        
	Matcher m_html = p_html.matcher(htmlStr);        
	htmlStr = m_html.replaceAll(""); // 过滤html标签 
	
	htmlStr = htmlStr.replaceAll("\r\n", "");
	htmlStr = htmlStr.replaceAll("[\\t\\n\\r]", "");
	return htmlStr.trim(); // 返回文本字符串    
}
%>