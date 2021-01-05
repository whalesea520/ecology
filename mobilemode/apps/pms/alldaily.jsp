<%@page import="java.net.URLDecoder"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.prj.util.PermissionUtil"%>
<%@page import="weaver.prj.util.ResourceUtil"%>
<%@page import="weaver.prj.util.CommonTransUtil"%>
<%@page import="weaver.prj.domain.PrjBase"%>
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

//User user = HrmUserVarify.getUser(request, response);
int _userid = Util.getIntValue(request.getParameter("userid"));
UserManager userManager = new UserManager();
User user = userManager.getUserByUserIdAndLoginType(_userid, "1");

String userid=""+user.getUID();

String creater = Util.fromScreen3(request.getParameter("creater"), user.getLanguage());
if(false){
	userid = "2";//user.getUID()+"";
	creater = "2";//Util.fromScreen3(request.getParameter("creater"), user.getLanguage());
}
int maintype = Util.getIntValue((String)request.getSession().getAttribute("CRM_MAINTYPE"),1);
String subject = Util.fromScreen3(request.getParameter("subject"), user.getLanguage());
String creatertype = Util.fromScreen3(request.getParameter("creatertype"), user.getLanguage());
String createDateFrom = Util.fromScreen3(request.getParameter("createDateFrom"), user.getLanguage());
String createDateTo = Util.fromScreen3(request.getParameter("createDateTo"), user.getLanguage());
String type = Util.fromScreen3(request.getParameter("type"), user.getLanguage());
String statusid = Util.fromScreen3(Util.null2String(request.getParameter("statusid")), user.getLanguage());
String statusid2 = Util.fromScreen3(request.getParameter("statusid2"), user.getLanguage());
String attention=Util.null2String(request.getParameter("attention"));
String subcompanyId = Util.fromScreen3(request.getParameter("subcompanyId"), user.getLanguage());
String departmentId = Util.fromScreen3(request.getParameter("deptId"), user.getLanguage());

String desc = Util.fromScreen3(request.getParameter("desc"), user.getLanguage());
String size = Util.fromScreen3(request.getParameter("size"), user.getLanguage());
String sector = Util.fromScreen3(request.getParameter("sector"), user.getLanguage());
String source = Util.fromScreen3(request.getParameter("source"), user.getLanguage());

String province = Util.fromScreen3(request.getParameter("province"), user.getLanguage());
String city = Util.fromScreen3(request.getParameter("city"), user.getLanguage());

String nocontact = Util.fromScreen3(request.getParameter("nocontact"), user.getLanguage());
String contacttype = Util.fromScreen3(request.getParameter("contacttype"), user.getLanguage());
String keyname = URLDecoder.decode(Util.null2String(request.getParameter("keyname")),"utf-8");


String remind = Util.fromScreen3(request.getParameter("remind"), user.getLanguage());
String isnew = Util.fromScreen3(request.getParameter("isnew"), user.getLanguage()); 

String manyd = URLDecoder.decode(Util.null2String(request.getParameter("manyd")),"utf-8");/*满意度*/
String kehulxr = URLDecoder.decode(Util.null2String(request.getParameter("kehulxr")),"utf-8");/*客户联系人*/
String jieduan = URLDecoder.decode(Util.null2String(request.getParameter("jieduan")),"utf-8");/*阶段*/
String ribao = URLDecoder.decode(Util.null2String(request.getParameter("ribao")),"utf-8");/*日报*/

String customerid1 = URLDecoder.decode(Util.null2String(request.getParameter("customerid1")),"utf-8");/*具体某一个项目的id*/

String orderBy1 = Util.fromScreen3(request.getParameter("orderBy1"), user.getLanguage());
String orderBy1_text = Util.fromScreen3(request.getParameter("orderBy1_text"), user.getLanguage());

if(ribao.length() > 0){/*如果是title上的日报传过来的过滤条件则，自动过滤掉，左侧菜单的日报过滤条件*/
	statusid = "30007";
	nocontact = ribao;
}

String currentdate = TimeUtil.getCurrentDateString();

if(!creater.equals(userid)){
	userid = creater;
}

Random random = new Random();
int randomInt = random.nextInt();
if(randomInt < 0){
	randomInt *= -1;
}


/*
if(!HrmUserVarify.checkUserRight("xxxxx:yyyyy",user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
*/
StringBuffer sqlsb = new StringBuffer();

if((statusid!=null && statusid.trim().length()>0) || 
		(keyname!=null && keyname.trim().length()>0)){
	request.getSession().removeAttribute("isFromProjectReport_ids");
	request.getSession().removeAttribute("isFromProjectReport_p1");
	request.getSession().removeAttribute("isFromProjectReport_p2");
	request.getSession().removeAttribute("isFromProjectReport_p3");
}

String isFromProjectReport_ids = Util.null2String((String)request.getSession().getAttribute("isFromProjectReport_ids"));
String isFromProjectReport_p1 = Util.null2String((String)request.getSession().getAttribute("isFromProjectReport_p1"));
String isFromProjectReport_p2 = Util.null2String((String)request.getSession().getAttribute("isFromProjectReport_p2"));
String isFromProjectReport_p3 = Util.null2String((String)request.getSession().getAttribute("isFromProjectReport_p3"));

//String sqlwhere1 = PrjCardUtil.getPrjIdList(userid, statusid, manyd, nocontact, user, kehulxr, jieduan, sqlsb, customerid1, keyname, "cbi", orderBy1_text);
String sqlwhere1 = PrjCardUtil.getPrjIdList(userid, statusid, manyd, nocontact, user, kehulxr, jieduan, sqlsb, customerid1, keyname, "cbi", orderBy1_text, 
			isFromProjectReport_ids, isFromProjectReport_p1, isFromProjectReport_p2, isFromProjectReport_p3);



ResourceComInfo rci = new ResourceComInfo();

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
boolean fiexdSize = Util.null2String(request.getParameter("fiexdSize")).equals("1");
int fiexdCount = 0;

String sqlwhere999 = "";
String dCreaterId = Util.null2String(request.getParameter("dCreaterId"));
if(!dCreaterId.trim().equals("")){
	sqlwhere999 += " and dc.opUid='"+dCreaterId+"' ";
}

String sql0 = "select * from ( select distinct row_number() over(ORDER BY dailydate DESC, fkid desc, prjId DESC) as rowNum, " +
		"	dailydate, prjId, projName,projManager  " +
		"	from ( " +
		" select dailydate, prjId, projName,projManager, max(fkid) as fkid from ( "+
		"  select dailydate, cbi.id as prjId, cbi.projName as projName,cbi.projManager, dc.id fkid " +
		"		from proj_dailyCommunication dc  " +
		"		join proj_CardBaseInfoExecDtl2 cbied2 on dc.cbied2_id = cbied2.id  " +
		"		join proj_CardBaseInfoExecDtl cbied on cbied.id = cbied2.cbied_id  " +
		"		join proj_CardBaseInfoExec cbie on cbie.id = cbied.cbie_id  " +
		"		join proj_CardBaseInfo cbi on cbi.id = cbie.cbi_id  " +
		"		where (dc.todayresult is not null or dc.tomorrowplan is not null) "+sqlwhere999+" "+sqlwhere1+"  " +
		"  ) as t0 group by dailydate, prjId, projName,projManager "+
		" ) as t  " +
		") as sp_t WHERE rowNum >= "+beginNum+" and rowNum < "+(beginNum+pageNum)+" ";
//out.println(sql0+"<br>");
rs0.executeSql(sql0);

if(rs0.getCounts() == 0){
	out.print("{\"totalSize\":\"0\", \"datas\":[]}");
	return;
}
List distinctList = new ArrayList();
while(rs0.next()){

	int rs0_prjId = Util.getIntValue(rs0.getString("prjId"), 0);
	String rs0_dailydate = Util.null2String(rs0.getString("dailydate")).trim();
	String rs0_projName = Util.null2String(rs0.getString("projName")).trim();
	String projManagerId = Util.null2String(rs0.getString("projManager")).trim();

	if(distinctList.contains(rs0_dailydate+"__"+rs0_prjId)){
		continue;
	}
	distinctList.add(rs0_dailydate+"__"+rs0_prjId);

	int prjId = rs0_prjId;
	String projName = rs0_projName;
	String currentDateString = rs0_dailydate;
	String[] currentDateStringArray = currentDateString.split("-");

	String sql1 = "select dc.*, cbied2.execTask, cbi.projName, cbi.id prjId "+
			" from proj_dailyCommunication dc "+
			" join proj_CardBaseInfoExecDtl2 cbied2 on dc.cbied2_id = cbied2.id "+
			" join proj_CardBaseInfoExecDtl cbied on cbied.id = cbied2.cbied_id "+
			" join proj_CardBaseInfoExec cbie on cbie.id = cbied.cbie_id "+
			" join proj_CardBaseInfo cbi on cbi.id = cbie.cbi_id "+
			" where (dc.todayresult is not null or dc.tomorrowplan is not null) and dc.dailydate = '"+rs0_dailydate+"' and cbi.id = "+rs0_prjId+" " +
			" ORDER BY dc.id desc, cbi.id desc, cbied2.execTask asc ";
	
	//out.println(sql1+"<br>");
	rs1.executeSql(sql1);


int rs1count=rs1.getCounts();
int i=0;
while(rs1.next()){
i++;
	int dc_id = rs1.getInt("id");
	
	String rs1_prjId = Util.null2String(rs1.getString("prjId")).trim();
	String cbied2_id = Util.null2String(rs1.getString("cbied2_id")).trim();
	String dailydate = rs0_dailydate;
	String yeterdayplan = Util.null2String(rs1.getString("yeterdayplan")).trim();
	String todayresult = Util.null2String(rs1.getString("todayresult")).trim();
	String costTime = Util.null2String(rs1.getString("costTime")).trim();
	costTime = new DecimalFormat("0.###").format(Util.getDoubleValue(costTime, 0.0));
	String tomorrowplan = Util.null2String(rs1.getString("tomorrowplan")).trim();
	String _docid = Util.null2String(rs1.getString("docid")).trim();
	String _docName = CommonTransUtil.getDocName(_docid, rs1_prjId);
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
	fiexdCount++;
	if(fiexdSize && fiexdCount > pageNum){
		continue;
	}
	sbJSON.append("{\"pId\":\""+rs0_prjId+"\", \"pName\":\""+rs0_projName+"\", \"dTask\":\""+execTask+"\", \"dId\":\""+dc_id+"\", \"dCreaterId\":\""+_opUid+"\", \"dCreater\":\""+rci.getLastname(_opUid)+"\", \"dYear\":\""+_opYear+"\", \"dDay\":\""+_opDay+"\",  \"dDate\":\""+_opDate+"\", \"dTime\":\""+_opTime+"\", \"dToday\":\""+delHTMLTag(todayresult)+"\", \"dTomorrow\":\""+delHTMLTag(tomorrowplan)+"\"},");
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