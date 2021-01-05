
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.net.URLDecoder,weaver.hrm.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	String sessionId = request.getParameter("sid");
	weaver.messager.SessionContext myc= weaver.messager.SessionContext.getInstance();
	HttpSession sess = myc.getSession(sessionId);
	if(sess!=null){
		//session = sess;
		if(!sess.getId().equals(session.getId())){
			User usertemp = (User)sess.getAttribute("weaver_user@bean");
			session.setAttribute("weaver_user@bean",usertemp);
		}
	}
	User user = (User)session.getAttribute("weaver_user@bean");
	if(user==null){
		out.print("null");
		return;
	}
	String wfType = request.getParameter("wfType");
	int userid = user.getUID();
	String select = " select distinct ";
	String fields = " t1.createdate,t1.createtime,t1.creater,t1.currentnodeid,t1.currentnodetype,t1.lastoperator,t1.creatertype,t1.lastoperatortype,t1.lastoperatedate,t1.lastoperatetime,t1.requestid,t1.requestname,t1.requestlevel,t1.workflowid,t2.receivedate,t2.receivetime ";
	String from = " from workflow_requestbase t1,workflow_currentoperator t2 ";
	String where = "";
	if(userid!=0&&wfType!=null){
		if(wfType.equals("1")){//待办
			where = " where t1.requestid=t2.requestid ";
			where += " and t2.usertype = 0 and t2.userid = " + userid;
			where += " and t2.isremark in( '0','1','5','7','8','9') and t2.islasttimes=1 and t1.workflowid in (select id from workflow_base where (isvalid='1' or isvalid='3'))";
		}else if(wfType.equals("2")){
			where = " where t1.requestid=t2.requestid ";
			where += " and t2.usertype = 0 and t2.userid = " + userid;
			where += " and t2.isremark ='2' and t2.iscomplete=0  and  t2.islasttimes=1 ";
		}else if(wfType.equals("3")){
			where = " where t1.requestid=t2.requestid ";
			where += " and t2.usertype = 0 and t2.userid = " + userid;
			where += " and t2.isremark in('2','4') and t1.currentnodetype = '3' and iscomplete=1 and islasttimes=1 ";
		}else if(wfType.equals("4")){
			where = " where t1.requestid=t2.requestid ";
			where += " and t2.usertype = 0 and t2.userid = " + userid;
			where += " and t1.creater = " + userid + " and t1.creatertype = 0 and (t1.deleted=0 or t1.deleted is null) and t2.islasttimes=1 ";
		}else{
			out.print("null");
			return;
		}
		String sqlstr = " select count(*) my_count from ( " + select + fields + from + where +  "  and t2.viewtype = 0 ) tableA ";
		System.out.println(sqlstr);
		rs.executeSql(sqlstr);
		//out.print("sqlstr:"+sqlstr+"<br>");
		if(rs.next()){
			out.print(wfType+":"+rs.getInt("my_count"));
			out.print(":"+session.getId());
		}
		
	}else{
		out.print("null");
	}
       
%>

	

