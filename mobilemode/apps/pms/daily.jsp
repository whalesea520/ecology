<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.prj.util.PermissionUtil"%>
<%@page import="weaver.prj.util.ResourceUtil"%>
<%@page import="weaver.prj.util.CommonTransUtil"%>
<%@page import="weaver.crazydream.util.EntityService"%>
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
<jsp:useBean id="htmlUtil" class="weaver.prj.util.HtmlUtil" scope="page" />
<%
StringBuffer sbJSON = new StringBuffer("{\"totalSize\":\"99999\", \"datas\":[");


ResourceComInfo rci = new ResourceComInfo();

//User user = HrmUserVarify.getUser(request, response);
int _userid = Util.getIntValue(request.getParameter("userid"));
UserManager userManager = new UserManager();
User user = userManager.getUserByUserIdAndLoginType(_userid, "1");

String userid=""+user.getUID();

Random random = new Random();
int randomInt = random.nextInt();
if(randomInt < 0){
	randomInt *= -1;
}


String prjId = Util.null2String(request.getParameter("_customerid"));
String _cbie_id = Util.null2String(request.getParameter("_cbie_id"));
String _cbied_id = Util.null2String(request.getParameter("_cbied_id"));
String _cbied2_id = Util.null2String(request.getParameter("_cbied2_id"));
String _cbied_title = Util.null2String(request.getParameter("_cbied_title"));



boolean canEdit=false;

htmlUtil.setGlobalPrimaryTableFieldId("proj_ExecPhase");
htmlUtil.setGlobalPrimaryPkFieldId("prjId");

RecordSet rs0 = new RecordSet();
RecordSet rs1 = new RecordSet();
RecordSet rs2 = new RecordSet();
RecordSet rs3 = new RecordSet();

int beginNum = Util.getIntValue(request.getParameter("beginNum"));
int pageNum = Util.getIntValue(request.getParameter("pageNum"));

beginNum = (beginNum - 1) * pageNum + 1;

String sql0 = "select * from ( select distinct row_number() over(ORDER BY dailydate DESC, fkid desc, prjId DESC) as rowNum, " +
		"	dailydate, prjId, projName  " +
		"	from ( " +
		" select dailydate, prjId, projName, max(fkid) as fkid from ( "+
		"		select dailydate, cbi.id as prjId, cbi.projName as projName, dc.id fkid " +
		"		from proj_dailyCommunication dc  " +
		"		join proj_CardBaseInfoExecDtl2 cbied2 on dc.cbied2_id = cbied2.id  " +
		"		join proj_CardBaseInfoExecDtl cbied on cbied.id = cbied2.cbied_id  " +
		"		join proj_CardBaseInfoExec cbie on cbie.id = cbied.cbie_id  " +
		"		join proj_CardBaseInfo cbi on cbi.id = cbie.cbi_id  " +
		"		where (dc.todayresult is not null or dc.tomorrowplan is not null) and cbi.id="+Util.getIntValue(prjId, 0)+"  " +
		"		UNION " +
		"		select dailydate, cbi.id as prjId, cbi.projName as projName, dc.id fkid " +
		"		from proj_dailyDscsSbj dc  " +
		"		join proj_CardBaseInfoExecDtl2 cbied2 on dc.cbi_id = cbied2.id  " +
		"		join proj_CardBaseInfoExecDtl cbied on cbied.id = cbied2.cbied_id  " +
		"		join proj_CardBaseInfoExec cbie on cbie.id = cbied.cbie_id  " +
		"		join proj_CardBaseInfo cbi on cbi.id = cbie.cbi_id  " +
		"		where 1=1 and cbi.id="+Util.getIntValue(prjId, 0)+" " +
		"		UNION " +
		"		select dailydate, cbi.id as prjId, cbi.projName as projName, dc.id fkid " +
		"		from proj_dailyDscsSbj1 dc  " +
		"		join proj_CardBaseInfoExecDtl cbied on cbied.id = dc.cbi_id  " +
		"		join proj_CardBaseInfoExec cbie on cbie.id = cbied.cbie_id  " +
		"		join proj_CardBaseInfo cbi on cbi.id = cbie.cbi_id  " +
		"		where 1=1 and cbi.id="+Util.getIntValue(prjId, 0)+" " +
		"		UNION " +
		"		select dailydate, cbi.id as prjId, cbi.projName as projName, dc.id fkid " +
		"		from proj_dailyDscsSbj2 dc  " +
		"		join proj_CardBaseInfo cbi on cbi.id = dc.cbi_id  " +
		"		where 1=1 and cbi.id="+Util.getIntValue(prjId, 0)+" " +
		" ) as t0 group by dailydate, prjId, projName "+
		"	) as t  " +
		") as sp_t WHERE rowNum >= "+beginNum+" and rowNum < "+(beginNum+pageNum)+" ";

if(_cbied2_id.length() > 0){
	sql0 = "select * from ( select distinct row_number() over(ORDER BY dailydate DESC, fkid desc, prjId DESC) as rowNum, " +
			"	dailydate, prjId, projName  " +
			"	from ( " +
			" select dailydate, prjId, projName, max(fkid) as fkid from ( "+
			"		select dailydate, "+Util.getIntValue(prjId, 0)+" as prjId, '' as projName, dc.id fkid " +
			"		from proj_dailyCommunication dc  " +
			"		join proj_CardBaseInfoExecDtl2 cbied2 on dc.cbied2_id = cbied2.id  " +
			"		where (dc.todayresult is not null or dc.tomorrowplan is not null) and cbied2.id = "+Util.getIntValue(_cbied2_id)+"  " +
			"		UNION " +
			"		select dailydate, "+Util.getIntValue(prjId, 0)+" as prjId, '' as projName, dc.id fkid " +
			"		from proj_dailyDscsSbj dc  " +
			"		join proj_CardBaseInfoExecDtl2 cbied2 on dc.cbi_id = cbied2.id  " +
			"		where cbied2.id = "+Util.getIntValue(_cbied2_id)+" " +
			" ) as t0 group by dailydate, prjId, projName "+
			"	) as t  " +
			") as sp_t WHERE rowNum >= "+beginNum+" and rowNum < "+(beginNum+pageNum)+" ";
}else if(_cbied_id.length() > 0){
	sql0 = "select * from ( select distinct row_number() over(ORDER BY dailydate DESC, fkid desc, prjId DESC) as rowNum, " +
			"	dailydate, prjId, projName  " +
			"	from ( " +
			" select dailydate, prjId, projName, max(fkid) as fkid from ( "+
			"		select dailydate, "+Util.getIntValue(prjId, 0)+" as prjId, '' as projName, dc.id fkid " +
			"		from proj_dailyCommunication dc  " +
			"		join proj_CardBaseInfoExecDtl2 cbied2 on dc.cbied2_id = cbied2.id  " +
			"		where (dc.todayresult is not null or dc.tomorrowplan is not null) and cbied2.cbied_id = "+Util.getIntValue(_cbied_id)+"  " +
			"		UNION " +
			"		select dailydate, "+Util.getIntValue(prjId, 0)+" as prjId, '' as projName, dc.id fkid " +
			"		from proj_dailyDscsSbj dc  " +
			"		join proj_CardBaseInfoExecDtl2 cbied2 on dc.cbi_id = cbied2.id  " +
			"		where dc.cbi_id = "+Util.getIntValue(_cbie_id)+" " +
			"		UNION " +
			"		select dailydate, "+Util.getIntValue(prjId, 0)+" as prjId, '' as projName, dc.id fkid " +
			"		from proj_dailyDscsSbj1 dc  " +
			"		where dc.cbi_id = "+Util.getIntValue(_cbied_id)+" " +
			" ) as t0 group by dailydate, prjId, projName "+
			"	) as t  " +
			") as sp_t WHERE rowNum >= "+beginNum+" and rowNum < "+(beginNum+pageNum)+" ";
}else if(_cbie_id.length() > 0){
	sql0 = "select * from ( select distinct row_number() over(ORDER BY dailydate DESC, fkid desc, prjId DESC) as rowNum, " +
			"	dailydate, prjId, projName  " +
			"	from ( " +
			" select dailydate, prjId, projName, max(fkid) as fkid from ( "+
			"		select dailydate, "+Util.getIntValue(prjId, 0)+" as prjId, '' as projName, dc.id fkid " +
			"		from proj_dailyCommunication dc  " +
			"		join proj_CardBaseInfoExecDtl2 cbied2 on dc.cbied2_id = cbied2.id  " +
			"		join proj_CardBaseInfoExecDtl cbied on cbied.id = cbied2.cbied_id  " +
			"		where (dc.todayresult is not null or dc.tomorrowplan is not null) and cbied.cbie_id = "+Util.getIntValue(_cbie_id)+"  " +
			"		UNION " +
			"		select dailydate, "+Util.getIntValue(prjId, 0)+" as prjId, '' as projName, dc.id fkid " +
			"		from proj_dailyDscsSbj dc  " +
			"		join proj_CardBaseInfoExecDtl2 cbied2 on dc.cbi_id = cbied2.id  " +
			"		join proj_CardBaseInfoExecDtl cbied on cbied.id = cbied2.cbied_id  " +
			"		where cbied.cbie_id = "+Util.getIntValue(_cbie_id)+" " +
			"		UNION " +
			"		select dailydate, "+Util.getIntValue(prjId, 0)+" as prjId, '' as projName, dc.id fkid " +
			"		from proj_dailyDscsSbj1 dc  " +
			"		join proj_CardBaseInfoExecDtl cbied on cbied.id = dc.cbi_id  " +
			"		where cbied.cbie_id = "+Util.getIntValue(_cbie_id)+" " +
			"		UNION " +
			"		select dailydate, "+Util.getIntValue(prjId, 0)+" as prjId, '' as projName, dc.id fkid " +
			"		from proj_dailyDscsSbj2 dc  " +
			"		join proj_CardBaseInfoExec cbie on cbie.cbi_id = dc.cbi_id " +
			"		where cbie.id = "+Util.getIntValue(_cbie_id)+" " +
			" ) as t0 group by dailydate, prjId, projName "+
			"	) as t  " +
			") as sp_t WHERE rowNum >= "+beginNum+" and rowNum < "+(beginNum+pageNum)+" ";
}
//out.println(sql0+"<br>");
rs0.executeSql(sql0);
//out.println("rs0.getCounts()="+rs0.getCounts());
if(rs0.getCounts() == 0){
	out.print("{\"totalSize\":0, \"datas\":[]}");
	return;
}
List distinctList = new ArrayList();
while(rs0.next()){

	String rs0_dailydate = Util.null2String(rs0.getString("dailydate")).trim();
	String rs0_prjId = Util.null2String(rs0.getString("prjId")).trim();

	if(distinctList.contains(rs0_dailydate+"__"+rs0_prjId)){
		continue;
	}
	distinctList.add(rs0_dailydate+"__"+rs0_prjId);

	String currentDateString = rs0_dailydate;
	String[] currentDateStringArray = currentDateString.split("-");






//日报

String sql1 = "select dc.*,cbied2.execTask, cbied2.id cbied2_id from proj_dailyCommunication dc join proj_CardBaseInfoExecDtl2 cbied2 on dc.cbied2_id = cbied2.id "+
		" join proj_CardBaseInfoExecDtl cbied on cbied.id = cbied2.cbied_id "+
		" join proj_CardBaseInfoExec cbie on cbie.id = cbied.cbie_id "+
		//" join proj_dailyDocid dd on dd.dailydate=dc.dailydate and dd.cbi_id=dc.cbie_id "+
		" where (dc.todayresult is not null or dc.tomorrowplan is not null) and cbie.cbi_id = "+Util.getIntValue(prjId)+" and dc.dailydate = '"+currentDateString+"' order by cbied2.id ";

if(_cbied2_id.length() > 0){
	sql1 = "select dc.*, cbied2.execTask, cbied2.id cbied2_id from proj_dailyCommunication dc join proj_CardBaseInfoExecDtl2 cbied2 on dc.cbied2_id = cbied2.id "+
			" where (dc.todayresult is not null or dc.tomorrowplan is not null) and cbied2.id = "+Util.getIntValue(_cbied2_id)+" and dc.dailydate = '"+currentDateString+"' order by cbied2.id ";
}else if(_cbied_id.length() > 0){
	sql1 = "select dc.*, cbied2.execTask, cbied2.id cbied2_id from proj_dailyCommunication dc join proj_CardBaseInfoExecDtl2 cbied2 on dc.cbied2_id = cbied2.id "+
			" where (dc.todayresult is not null or dc.tomorrowplan is not null) and cbied2.cbied_id = "+Util.getIntValue(_cbied_id)+" and dc.dailydate = '"+currentDateString+"' order by cbied2.id ";
}else if(_cbie_id.length() > 0){
	sql1 = "select dc.*, cbied2.execTask, cbied2.id cbied2_id from proj_dailyCommunication dc join proj_CardBaseInfoExecDtl2 cbied2 on dc.cbied2_id = cbied2.id "+
			" join proj_CardBaseInfoExecDtl cbied on cbied.id = cbied2.cbied_id "+
			" where (dc.todayresult is not null or dc.tomorrowplan is not null) and cbied.cbie_id = "+Util.getIntValue(_cbie_id)+" and dc.dailydate = '"+currentDateString+"' order by cbied2.id ";
}
//out.println(sql1);
rs1.executeSql(sql1);


while(rs1.next()){
	
	htmlUtil.useDetail_index();
	
	String dc_id = Util.null2String(rs1.getString("id")).trim();
	String cbied2_id = Util.null2String(rs1.getString("cbied2_id")).trim();
	String dailydate = Util.null2String(rs1.getString("dailydate")).trim();
	String yeterdayplan = Util.null2String(rs1.getString("yeterdayplan")).trim();
	String todayresult = Util.null2String(rs1.getString("todayresult")).trim();
	String costTime = Util.null2String(rs1.getString("costTime")).trim();
	costTime = new DecimalFormat("0.###").format(Util.getDoubleValue(costTime, 0.0));
	String tomorrowplan = Util.null2String(rs1.getString("tomorrowplan")).trim();
	//String docid = Util.null2String(rs1.getString("docid")).trim();
	//String docName = CommonTransUtil.getDocName(docid, prjId);
	String execTask = Util.null2String(rs1.getString("execTask")).trim();
	String _opUid = Util.null2String(rs1.getString("opUid")).trim();
	String _opDate = Util.null2String(rs1.getString("opDate")).trim();
	String _opTime = Util.null2String(rs1.getString("opTime")).trim();
	String _opYear = "";
	String _opDay = "";
	if(_opDate.length()>=10){
		_opYear = _opDate.substring(0,4);
		_opDay = _opDate.substring(5,10);
	}
	if(_opTime.length() == "00:00:00".length()){
		_opTime = _opTime.substring(0, "00:00".length());
	}
	
	
	sbJSON.append("{\"pId\":\""+rs0_prjId+"\", \"pName\":\"\", \"dTask\":\""+execTask+"\", \"dId\":\""+dc_id+"\", \"dCreaterId\":\""+_opUid+"\", \"dCreater\":\""+rci.getLastname(_opUid)+"\",  \"dYear\":\""+_opYear+"\", \"dDay\":\""+_opDay+"\", \"dDate\":\""+_opDate+"\", \"dTime\":\""+_opTime+"\", \"dToday\":\""+delHTMLTag(todayresult)+"\", \"dTomorrow\":\""+delHTMLTag(tomorrowplan)+"\"},");
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