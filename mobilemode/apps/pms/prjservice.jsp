<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.regex.*" %>
<%
String opt = request.getParameter("opt");
int prjid = Util.getIntValue(request.getParameter("prjid"));

//User user = HrmUserVarify.getUser (request , response) ;
int userid = Util.getIntValue(request.getParameter("userid"));
UserManager userManager = new UserManager();
User user = userManager.getUserByUserIdAndLoginType(userid, "1");

ResourceComInfo rci = new ResourceComInfo();
RecordSet rs = new RecordSet();
String sql = "";

if("getRemindByPrj".equals(opt)){
	String lastTime = "2001-01-01 00:00:00";
	int countNewDaily = 0;
	int countNewDailyReply = 0;

	//某用户最后一次访问该项目的时间
	sql = "select top 1 opdate+' '+optime as lastTime from proj_visitInfo where cbi_id="+prjid+" and uid="+userid+" order by opdate desc, optime desc";
	rs.executeSql(sql);
	if(rs.next()){
		lastTime = rs.getString("lastTime");
	}
	
	//该项目新日报数量
	sql = "select count(id) as c from proj_dailyCommunication a where cbie_id="+prjid+" and (opdate+' '+optime)>'"+lastTime+"'";
	rs.executeSql(sql);
	if(rs.next()){
		countNewDaily = Util.getIntValue(rs.getString("c"), 0);
	}
	
	//该项目新日报回复数量
	sql = "select count(id) as c from uf_proj_dailyreply a where prjid="+prjid+" and (opdate+' '+optime2)>'"+lastTime+"'";
	rs.executeSql(sql);
	if(rs.next()){
		countNewDailyReply = Util.getIntValue(rs.getString("c"), 0);
	}

	out.print(countNewDaily + countNewDailyReply);

}else if("getDailyReplies".equals(opt)){
	response.setContentType("text/plain");
	String callbackFunName = request.getParameter("callbackparam");

	int dailyid = Util.getIntValue(request.getParameter("dailyid"));
	int replyid = 0;
	String opusername = "";
	String opdate = "";
	String optime = "";
	String opcontent = "";
	String htmlReply = callbackFunName + "({htmlReply:\"";
	sql = "select id, opuser, opdate, optime2, opcontent from uf_proj_dailyreply where dailyid="+dailyid+" order by opdate desc, optime2 desc";
	rs.executeSql(sql);
	while(rs.next()){
		opdate = Util.null2String(rs.getString("opdate"));
		optime = Util.null2String(rs.getString("optime2"));
		if(optime.length()>=8){
			optime = optime.substring(0,5);
		}
		opcontent = Util.null2String(rs.getString("opcontent"));
		opusername = rci.getLastname(Util.null2String(rs.getString("opuser")));
		htmlReply += "<div class='divReply'><div class='divReplyCreator'>"+opusername+" "+opdate+" "+optime+"</div><div class='divReplyContent'>"+delHTMLTag(opcontent)+"</div></div>";
	}
	htmlReply += "\"})";
	out.print(htmlReply);

}else if("getMyDailyReplies".equals(opt)){
	int beginNum = Util.getIntValue(request.getParameter("beginNum"), 1);
	int pageNum = Util.getIntValue(request.getParameter("pageNum"), 1);
	beginNum = (beginNum - 1) * pageNum + 1;
	int total = 0;
	StringBuffer sbJSON = new StringBuffer("");
	int replyid = 0;
	String opusername = "";
	String opdate = "";
	String optime = "";
	String _opYear = "";
	String _opDay = "";
	String opcontent = "";

	sql = "select b.projname, a.opuser, a.opdate, a.optime2, a.opcontent from uf_proj_dailyreply a left join proj_CardBaseInfo b on a.prjid=b.id where a.dailycreator="+userid+" order by a.opdate desc, a.optime2 desc";
	rs.executeSql(sql);
	total = rs.getCounts();

	sbJSON.append("{\"totalSize\":\""+total+"\", \"datas\":[");
	
	sql = "select * from (";
	sql+= "select ROW_NUMBER() OVER(order by a.opdate desc, a.optime2 desc, a.id desc) as rownum, b.projname, a.prjid, a.opuser, a.opdate, a.optime2, a.opcontent ";
	sql+= "from uf_proj_dailyreply a ";
	sql+= "left join proj_CardBaseInfo b on a.prjid=b.id where a.dailycreator="+userid+") as t ";
	sql+= "where rownum between "+beginNum+" and "+(beginNum+pageNum-1)+" ";
	//out.println(sql);
	rs.executeSql(sql);

	while(rs.next()){
		opdate = Util.null2String(rs.getString("opdate"));		
		if(opdate.length()>=10){
			_opYear = opdate.substring(0,4);
			_opDay = opdate.substring(5,10);
		}
		optime = Util.null2String(rs.getString("optime2"));
		if(optime.length()>=8){
			optime = optime.substring(0,5);
		}
		opcontent = Util.null2String(rs.getString("opcontent"));
		opusername = rci.getLastname(Util.null2String(rs.getString("opuser")));

		sbJSON.append("{\"prjid\":\""+rs.getString("prjid")+"\", \"projname\":\""+rs.getString("projname")+"\", \"opuser\":\""+opusername+"\", \"opyear\":\""+_opYear+"\", \"opday\":\""+_opDay+"\", \"opdate\":\""+opdate+"\", \"optime\":\""+optime+"\", \"opcontent\":\""+delHTMLTag(opcontent)+"\"},");
	}
	String strJSON = sbJSON.toString();
	if(strJSON.endsWith(",")){
		strJSON = strJSON.substring(0, strJSON.length()-1);
	}
	strJSON += "]}";
	out.println(strJSON);

}else if("setVisitInfo".equals(opt)){
	sql = "insert into proj_visitInfo (cbi_id, uid, opDate, opTime) values ("+prjid+", "+userid+", '"+TimeUtil.getCurrentDateString()+"', '"+TimeUtil.getOnlyCurrentTimeString()+"')";
	rs.executeSql(sql);

}else if("setMsgInfo".equals(opt)){
	sql = "insert into uf_proj_msg (mtype, userid, lastdate, lasttime) values (1, "+userid+", '"+TimeUtil.getCurrentDateString()+"', '"+TimeUtil.getOnlyCurrentTimeString()+"')";
	//out.print(sql);
	rs.executeSql(sql);
}
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