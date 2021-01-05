
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
out.clearBuffer();
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
	Map result = new HashMap();
	//未登录或登录超时
	result.put("error", "200001");
	
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	
	return;
}

response.setContentType("application/json;charset=UTF-8");
String currentUserId = user.getUID()+"";
String currentdate = TimeUtil.getCurrentDateString();
Map result = new HashMap();
String countSql = "select count(distinct t.id) total,count(distinct case when ga.id is null then t.id end) noread  from GP_AccessScore t join HrmResource h on t.userid = h.id left join GP_AccessScoreLog ga on ga.scoreid = t.id "
             +" and ga.operator = "+currentUserId+ "where t.isvalid=1 and t.status<>3  and t.startdate<='"+currentdate+"'"+" and t.enddate>='"+currentdate+"'"
		 	+" and h.status in (0,1,2,3) and h.loginid is not null "+((!"oracle".equals(rs.getDBType()))?" and h.loginid<>''":"")
			+" and (t.operator="+currentUserId+" or exists(select 1 from GP_AccessScoreAudit aa where aa.scoreid=t.id and aa.userid="+currentUserId+")) ";
int count = 0;
int unread = 0;
rs.executeSql(countSql);
if(rs.next()){
	count = rs.getInt("total");
	unread = rs.getInt("noread");
}
result.put("result", "count");
result.put("count", ""+count);
result.put("unread", ""+unread);

JSONObject jo = JSONObject.fromObject(result);
out.println(jo);
%>