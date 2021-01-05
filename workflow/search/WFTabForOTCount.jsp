
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%
User user = HrmUserVarify.getUser(request, response) ;
if (user == null ) return ;
List countArr = new ArrayList();
countArr.add("willovertime");
countArr.add("timedout");

	//开始进入
String logintype = ""+user.getLogintype();
int usertype = 0;

String resourceid= ""+Util.null2String((String) session.getAttribute("RequestViewResource"));
if(resourceid.equals("")) {
	resourceid = ""+user.getUID();
	if(logintype.equals("2")) usertype= 1;
		session.removeAttribute("RequestViewResource") ;
	}
else {
	session.setAttribute("RequestViewResource",resourceid) ;
}

if (logintype.equals("2")){
	usertype = 1;
}

int  willovertime = 0;
int timedout = 0;

for(int a=0;a<countArr.size();a++)
{
    StringBuffer sqlsb = new StringBuffer();
	sqlsb.append("SELECT count(requestid) wfCount FROM workflow_currentoperator a ")
		.append(" WHERE a.userid = ").append(resourceid)
		.append(" AND a.usertype = ").append(usertype);
	sqlsb.append(" and a.islasttimes = 1 ");
	sqlsb.append(" and exists (select 1 from workflow_currentoperator c where c.requestid = a.requestid and c.isremark = 0 ");
	if(countArr.get(a).equals("willovertime")){
		//sqlsb.append("	AND a.isremark = 0 AND a.isprocessed = 3  ");
		sqlsb.append(" and c.isreminded = '1' and (c.isreminded_csh != '1' or c.isreminded_csh is null) ");
	}else{
		//sqlsb.append("	AND a.isremark = 5 AND (a.isprocessed = 1 OR a.isprocessed = 2) ");
		sqlsb.append(" and c.isreminded_csh = '1' ");
	}
	sqlsb.append(" ) ");
	sqlsb.append(" AND EXISTS ( ").append("SELECT 1 FROM SysPoppupRemindInfoNew b")
		.append(" where   b.userid = ").append(resourceid)
		.append(" and b.usertype =").append(usertype)
		.append(" AND b.requestid = a.requestid ").append(" and b.type = 10 )");

	RecordSet.executeSql(sqlsb.toString());
	if(RecordSet.first()){
		//System.out.println(Util.getIntValue(RecordSet.getString("wfCount")));
		if(countArr.get(a).equals("willovertime")){
			willovertime = Util.getIntValue(RecordSet.getString("wfCount"));
		}
		else if(countArr.get(a).equals("timedout")){
			timedout = Util.getIntValue(RecordSet.getString("wfCount"));
		}
	}

}

String data="{\"willovertime\":\""+willovertime+"\",\"timedout\":\""+timedout+"\"}";

response.getWriter().write(data);

%>

