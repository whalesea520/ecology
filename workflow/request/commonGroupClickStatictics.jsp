
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util,java.sql.Timestamp"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

String groupid = Util.null2String(request.getParameter("groupid"));

weaver.conn.RecordSet sltRs = new weaver.conn.RecordSet();
weaver.conn.RecordSet rs = new weaver.conn.RecordSet();

long clickCnt = 0;
if (!"".equals(groupid)) {
	sltRs.executeSql("SELECT id, clickCnt FROM HrmUserGroupStatictics WHERE userid=" + user.getUID() + " and groupid=" + groupid);
	if (sltRs.next()) {
		clickCnt = Long.parseLong(sltRs.getString("clickCnt"));
		clickCnt++;
		rs.executeSql("UPDATE HrmUserGroupStatictics SET clickCnt=" + clickCnt + " WHERE userid=" + user.getUID() + " and groupid=" + groupid);
	} else {
			rs.executeSql("INSERT INTO HrmUserGroupStatictics(userid, groupid, clickCnt) VALUES(" + user.getUID() + " , " + groupid + ", 1)");
	}
	out.print("0");
} else {
	out.print("-1");
}
%>

