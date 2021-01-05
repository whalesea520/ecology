<?xml version="1.0" encoding="UTF-8"?><%@ page language="java" contentType="text/xml; charset=UTF-8" %><%@ page import="java.util.ArrayList,java.lang.reflect.Method" %><%@ page import="weaver.hrm.*,weaver.general.*,weaver.systeminfo.*,weaver.systeminfo.menuconfig.*" %><%@ page import="java.sql.Timestamp" %><%@ page import="java.util.Date" %><jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/><%
	User user = HrmUserVarify.getUser(request,response);
	if(user == null)  return ;
%><tree><%
	Date newdate = new Date() ;
	long datetime = newdate.getTime() ;
	Timestamp timestamp = new Timestamp(datetime) ;
	String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
	String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16);

	String s = "", sql="";

//Voting
//sql = "SELECT DISTINCT t1.id,t1.subject FROM voting t1,VotingShareDetail t2 WHERE t1.id=t2.votingid AND t2.resourceid="+user.getUID()+" AND t1.status=1 AND t1.id NOT IN (SELECT DISTINCT votingid FROM votingresource WHERE resourceid="+user.getUID()+")"+" and t1.beginDate<='"+CurrentDate+"' and (t1.beginTime is null or t1.beginTime='' or t1.beginTime<='"+CurrentTime+"') ";
	sql="SELECT DISTINCT t1.id,t1.subject  from voting t1,VotingShareDetail t2 where t1.id=t2.votingid and t2.resourceid="+user.getUID()+" and t1.status=1 "+ " and t1.id not in (select distinct votingid from votingresource where resourceid ="+user.getUID()+")"
			+" and (t1.beginDate<'"+CurrentDate+"' or (t1.beginDate='"+CurrentDate+"' and (t1.beginTime is null or t1.beginTime='' or t1.beginTime<='"+CurrentTime+"'))) ";
	rs.executeSql(sql);
	while(rs.next()){
		s += "<tree text=\""+rs.getString("subject")+"\" icon=\"/images_face/ecologyFace_2/LeftMenuIcon/level3_wev8.gif\" action=\"javascript:window.open('/voting/VotingPoll.jsp?votingid="+rs.getInt("id")+"', '','toolbar,resizable,scrollbars,dependent,height=600,width=800,top=0,left=100');void(0);\" />";
	}

	out.print(s+"</tree>");
%>