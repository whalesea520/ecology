
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.hrm.performance.goal.GoalUtil" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>

<%
String sql = "";
String src = "";
String iscreate = "";
int requestid = 0;
int workflowid = 0;
String workflowtype = "";
int isremark = 0;
int formid = 0;
int isbill = 0;
int billid = 0;
int nodeid = 0;
String nodetype = "";
String requestname = "";
String requestlevel = "";
String messageType = "";
String remark = "";
String redirectUrl = "";
String smsAlertsType="";
String f_weaver_belongto_userid="";
String f_weaver_belongto_usertype="";
String fromWhere = Util.null2String(request.getParameter("fromWhere"));
//从目标列表页面提交
if(fromWhere.equals("goalList")){
	src = "submit";
	iscreate = "0";
	requestid = Util.getIntValue(request.getParameter("requestid"),-1);
	sql = "SELECT * FROM workflow_requestbase WHERE requestid="+requestid+"";
	rs.executeSql(sql);
	if(rs.next()){
		workflowid = rs.getInt("workflowid");
		requestname = rs.getString("requestname");
		requestlevel = rs.getString("requestlevel");
		messageType = rs.getString("messageType");
		nodeid = rs.getInt("currentnodeid");
		nodetype = rs.getString("currentnodetype");
		smsAlertsType = rs.getString("smsAlertsType");
	}
	if(messageType.equals("1"))messageType=smsAlertsType;

	sql = "SELECT * FROM workflow_base WHERE id="+workflowid+"";
	rs.executeSql(sql);
	if(rs.next()){
		workflowtype = rs.getString("workflowtype");
		formid = rs.getInt("formid");
		isbill = rs.getInt("isbill");
		billid = formid;
	}
	RequestManager.setRequest(request);

//从流程页面提交
}else{
    FileUpload fu = new FileUpload(request);
    f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
    f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
    user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
	src = Util.null2String(fu.getParameter("src"));
	iscreate = Util.null2String(fu.getParameter("iscreate"));
	requestid = Util.getIntValue(fu.getParameter("requestid"),-1);
	workflowid = Util.getIntValue(fu.getParameter("workflowid"),-1);
	workflowtype = Util.null2String(fu.getParameter("workflowtype"));
	isremark = Util.getIntValue(fu.getParameter("isremark"),-1);
	formid = Util.getIntValue(fu.getParameter("formid"),-1);
	isbill = Util.getIntValue(fu.getParameter("isbill"),-1);
	billid = Util.getIntValue(fu.getParameter("billid"),-1);
	nodeid = Util.getIntValue(fu.getParameter("nodeid"),-1);
	nodetype = Util.null2String(fu.getParameter("nodetype"));
	requestname = Util.fromScreen(fu.getParameter("requestname"),user.getLanguage());
	requestlevel = Util.fromScreen(fu.getParameter("requestlevel"),user.getLanguage());
	messageType =  Util.fromScreen(fu.getParameter("messageType"),user.getLanguage());
	remark = Util.null2String(fu.getParameter("remark"));
	RequestManager.setRequest(fu) ;
}


if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
    //response.sendRedirect("/notice/RequestError.jsp");
	out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
    return ;
}

RequestManager.setSrc(src) ;
RequestManager.setIscreate(iscreate) ;
RequestManager.setRequestid(requestid) ;
RequestManager.setWorkflowid(workflowid) ;
RequestManager.setWorkflowtype(workflowtype) ;
RequestManager.setIsremark(isremark) ;
RequestManager.setFormid(formid) ;
RequestManager.setIsbill(isbill) ;
RequestManager.setBillid(billid) ;
RequestManager.setNodeid(nodeid) ;
RequestManager.setNodetype(nodetype) ;
RequestManager.setRequestname(requestname) ;
RequestManager.setRequestlevel(requestlevel) ;
RequestManager.setRemark(remark) ;
//RequestManager.setRequest(fu) ;
RequestManager.setUser(user) ;
//add by xhheng @ 2005/01/24 for 消息提醒 Request06
RequestManager.setMessageType(messageType) ;

boolean savestatus = RequestManager.saveRequestInfo() ;
requestid = RequestManager.getRequestid() ;
if( !savestatus ) {
    if( requestid != 0 ) {

        String message=RequestManager.getMessage();
        if(!"".equals(message)){
			out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&message="+message+"');</script>");
            return ;
        }

        //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1");
        out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1');</script>");
        return ;
    }
    else {
    	%><%@ include file="/workflow/request/RedirectPage.jsp" %> <% 
        //response.sendRedirect("/workflow/request/RequestView.jsp?message=1");
       // out.print("<script>wfforward('/workflow/request/RequestView.jsp?message=1');</script>");
        return ;
    }
}

boolean flowstatus = RequestManager.flowNextNode() ;
if( !flowstatus ) {
	//response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
	out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2');</script>");
    return ;
}

boolean logstatus = RequestManager.saveRequestLog() ;

//status: 0草稿 1退回 2待审批 3发布
/*退回处理*/
if( RequestManager.getNextNodetype().equals("0")) {
	rs.executeSql("UPDATE BPMGoalGroup SET status='1' WHERE requestid="+requestid+"");
	//out.println("<script type='text/javascript'>self.close();this.opener.document.location.reload();</script>");
	//out.println("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
	%><%@ include file="/workflow/request/RedirectPage.jsp" %> <% 
	return;
}

/*退回再次提交处理*/
if( RequestManager.getNextNodetype().equals("1")) {
	rs.executeSql("UPDATE BPMGoalGroup SET status='2' WHERE requestid="+requestid+"");
	if(fromWhere.equals("goalList")){
		//response.sendRedirect("/hrm/performance/goal/myGoalListIframe.jsp");
		out.print("<script>wfforward('/hrm/performance/goal/myGoalListIframe.jsp');</script>");
		return;
	}else{
		//out.println("<script type='text/javascript'>self.close();this.opener.document.location.reload();</script>");
		//out.println("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
		%><%@ include file="/workflow/request/RedirectPage.jsp" %> <% 
	}
	return;
}

/*归档处理*/
if( RequestManager.getNextNodetype().equals("3")) {
	rs.executeSql("UPDATE BPMGoalGroup SET status='3' WHERE requestid="+requestid+"");

	//==================================================================================================================================
	//TD4941
	//如果是年度目标则自动分解季、月目标
	String startdate = "";
	String enddate = "";
	String currentYear = "";
	String _startdate = "";
	String _enddate = "";
	String _goalDate = "";
	String _cycle = "";
	int goalId = 0;
	
	sql = "SELECT b.* FROM BPMGoalGroup a, HrmPerformanceGoal b WHERE a.requestid="+requestid+" AND a.id=b.groupid AND a.cycle='3'";
	rs.executeSql(sql);
	while(rs.next()){
		currentYear = rs.getString("goalDate");
		startdate = rs.getString("startdate");
		enddate = rs.getString("enddate");
		
		//分解到季目标 开始日期和结束日期都有才分解
		String[] a = Util.TokenizerString2(getSeasonString(startdate, enddate), ",");
		for(int i=0; i<a.length; i++){
			_startdate = Util.TokenizerString2(a[i], "|")[0];
			_enddate = Util.TokenizerString2(a[i], "|")[2];
			_goalDate = currentYear + Util.TokenizerString2(a[i], "|")[1];
			_cycle = "1";
			goalId = GoalUtil.getGoalMaxId();
			sql = "INSERT INTO HrmPerformanceGoal (id, goalName, objId, goalCode, parentId, goalDate, workUnit, operations, type_t, startDate, endDate, goalType, cycle, property, unit, targetValue, previewValue, memo, percent_n, status, groupId) VALUES ("+goalId+", '"+rs.getString("goalName")+"', "+rs.getInt("objId")+", '"+rs.getString("goalCode")+"', "+rs.getInt("id")+", '"+_goalDate+"', "+rs.getInt("workUnit")+", "+user.getUID()+", "+rs.getInt("type_t")+", '"+_startdate+"', '"+_enddate+"', '"+rs.getString("goalType")+"', '"+_cycle+"', '"+rs.getString("property")+"', '"+rs.getString("unit")+"', '"+rs.getString("targetValue")+"', '"+rs.getString("previewValue")+"', '"+rs.getString("memo")+"', '0', '0', "+rs.getInt("groupid")+")";
			//System.out.println(sql);
			rs2.executeSql(sql);
		}
		//分解到月目标 开始日期和结束日期都有才分解
		String[] b = Util.TokenizerString2(getMonthString(startdate, enddate), ",");
		for(int i=0; i<b.length; i++){
			_startdate = Util.TokenizerString2(b[i], "|")[0];
			_enddate = Util.TokenizerString2(b[i], "|")[2];
			_goalDate = currentYear + Util.TokenizerString2(b[i], "|")[1];
			_cycle = "0";
			goalId = GoalUtil.getGoalMaxId();
			sql = "INSERT INTO HrmPerformanceGoal (id, goalName, objId, goalCode, parentId, goalDate, workUnit, operations, type_t, startDate, endDate, goalType, cycle, property, unit, targetValue, previewValue, memo, percent_n, status, groupId) VALUES ("+goalId+", '"+rs.getString("goalName")+"', "+rs.getInt("objId")+", '"+rs.getString("goalCode")+"', "+rs.getInt("id")+", '"+_goalDate+"', "+rs.getInt("workUnit")+", "+user.getUID()+", "+rs.getInt("type_t")+", '"+_startdate+"', '"+_enddate+"', '"+rs.getString("goalType")+"', '"+_cycle+"', '"+rs.getString("property")+"', '"+rs.getString("unit")+"', '"+rs.getString("targetValue")+"', '"+rs.getString("previewValue")+"', '"+rs.getString("memo")+"', '0', '0', "+rs.getInt("groupid")+")";
			//System.out.println(sql);
			rs2.executeSql(sql);
		}
	}
	//==================================================================================================================================
%><%@ include file="/workflow/request/RedirectPage.jsp" %> <% 
	//out.println("<script type='text/javascript'>self.close();this.opener.document.location.reload();</script>");
    //out.println("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
	return;
}

//response.sendRedirect(redirectUrl);
%>


<%!
String getSeasonString(String startdate, String enddate){
	int startSeason = 0;
	int endSeason = 0;
	String temp = "";
    if(startdate!=null && startdate.length()>7 && enddate!=null && enddate.length()>7){
    String y = startdate.substring(0, 4);
	startSeason = getSeason(startdate.substring(5,7));
	endSeason = getSeason(enddate.substring(5,7));

	for(int i=startSeason; i<=endSeason; i++){
		if(i==1)	temp += y+"-01-01"+ "|" + i + "|" + y+"-03-31" + ",";
		if(i==2)	temp += y+"-04-01"+ "|" + i + "|" + y+"-06-30" + ",";
		if(i==3)	temp += y+"-07-01"+ "|" + i + "|" + y+"-09-30" + ",";
		if(i==4)	temp += y+"-10-01"+ "|" + i + "|" + y+"-12-31" + ",";
	}
	temp = temp.substring(10, temp.length()-11);
	temp = startdate + temp + enddate;
    }
    return temp;
}

String getMonthString(String startdate, String enddate){
	java.util.GregorianCalendar gc = new java.util.GregorianCalendar();
	int startMonth = 0;
	int endMonth = 0;
	String temp = "";
    if(startdate!=null && startdate.length()>7 && enddate!=null && enddate.length()>7){
	    int startYear = Util.getIntValue(startdate.substring(0, 4));
		int endYear = Util.getIntValue(enddate.substring(0, 4));
		startMonth = Util.getIntValue(startdate.substring(5,7));
		endMonth = Util.getIntValue(enddate.substring(5,7));
	
		for(int y=startYear; y<=endYear; y++){
			boolean isLeapYear = false;
			isLeapYear = gc.isLeapYear(y);
			int tmpStartMonth=0;
			int tmpEndMonth=0;
			if(y==startYear){
				tmpStartMonth=startMonth;
			}else{
				tmpStartMonth=1;
			}
			if(y==endYear){
				tmpEndMonth=endMonth;
			}else{
				tmpEndMonth=12;
			}
			
			for(int i=tmpStartMonth; i<=tmpEndMonth; i++){
				if(i==1 || i==3 || i==5 || i==7 || i==8)	temp += y+"-0"+String.valueOf(i)+"-01"+ "|" + i + "|" + y+"-0"+String.valueOf(i)+"-31" + ",";
				if(i==10 || i==12)	temp += y+"-"+String.valueOf(i)+"-01"+ "|" + i + "|" + y+"-"+String.valueOf(i)+"-31" + ",";
				if(i==4 || i==6 || i==9 || i==11)	temp += y+"-"+((i<11)?"0"+String.valueOf(i):String.valueOf(i))+"-01"+ "|" + i + "|" + y+"-"+((i<11)?"0"+String.valueOf(i):String.valueOf(i))+"-30" + ",";
				if(i==2){
					if(isLeapYear){
						temp += y+"-0"+String.valueOf(i)+"-01"+ "|" + i + "|" + y+"-0"+String.valueOf(i)+"-29" + ",";
					}else{
						temp += y+"-0"+String.valueOf(i)+"-01"+ "|" + i + "|" + y+"-0"+String.valueOf(i)+"-28" + ",";
					}
				}
			}
		}
		temp = temp.substring(10, temp.length()-11);
		temp = startdate + temp + enddate;
    }
    return temp;
}

int getSeason(String m){
	int s = 0;
	if(m.equals("01") || m.equals("02") || m.equals("03")){
		s = 1;
	}else if(m.equals("04") || m.equals("05") || m.equals("06")){
		s = 2;
	}else if(m.equals("07") || m.equals("08") || m.equals("09")){
		s = 3;
	}else if(m.equals("10") || m.equals("11") || m.equals("12")){
		s = 4;
	}
	return s;
}
%>