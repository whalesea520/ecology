
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
String flag = request.getParameter("flag");
String orderclause="";
String orderclause2="";
String requestids = "-10000";
String usertype = "";
if("1".equals(user.getLogintype())){
usertype = "0";
}
else{
usertype = "1";
}
    
    int userid=user.getUID();  
	String userID = String.valueOf(user.getUID());
		//int userid=user.getUID();
		String belongtoshow = "";				
		RecordSet.executeSql("select * from HrmUserSetting where resourceId = "+userID);
		if(RecordSet.next()){
			belongtoshow = RecordSet.getString("belongtoshow");
		}
		String userIDAll = String.valueOf(user.getUID());	
String Belongtoids =user.getBelongtoids();
int Belongtoid=0;
String[] arr2 = null;
ArrayList<String> userlist = new ArrayList();
userlist.add(userid + "");
if(!"".equals(Belongtoids)){
userIDAll = userID+","+Belongtoids;
arr2 = Belongtoids.split(",");
for(int i=0;i<arr2.length;i++){
Belongtoid = Util.getIntValue(arr2[i]);
userlist.add(Belongtoid + "");
}
}

SearchClause.resetClause();
if("1".equals(belongtoshow)){
if(flag.equals("newWf")){
RecordSet.executeSql("select requestid from SysPoppupRemindInfoNew where   userid in (" + userIDAll + ") and usertype = '" +usertype+ "' and type = 0");
}else if(flag.equals("birthWf")){ //生日提醒
RecordSet.executeSql("select requestid from SysPoppupRemindInfoNew where   userid in (" + userIDAll + ") and usertype = '" +usertype+ "' and type = 2");
}else if(flag.equals("chgPassWf")){ //密码变更提醒
RecordSet.executeSql("select requestid from SysPoppupRemindInfoNew where   userid in (" + userIDAll + ") and usertype = '" +usertype+ "' and type = 6");
}else if(flag.equals("contractExpWf")){ //合同到期提醒
RecordSet.executeSql("select requestid from SysPoppupRemindInfoNew where   userid in (" + userIDAll + ") and usertype = '" +usertype+ "' and  type = 7");
}else if(flag.equals("newWorkerWf")){ //人员入职提醒
RecordSet.executeSql("select requestid from SysPoppupRemindInfoNew where   userid in (" + userIDAll + ") and usertype = '" +usertype+ "' and type = 8");
}else if(flag.equals("ovettime")){ //超时提醒
RecordSet.executeSql("select requestid from SysPoppupRemindInfoNew where   userid in (" + userIDAll + ") and usertype = '" +usertype+ "' and type = 10");
}else if(flag.equals("rejectWf")){
RecordSet.executeSql("select requestid from SysPoppupRemindInfoNew where   userid in (" + userIDAll + ") and usertype = '" +usertype+ "' and type = 14");
}else if(flag.equals("newEmail")){
RecordSet.executeSql("select requestid from SysPoppupRemindInfoNew where   userid in (" + userIDAll + ") and usertype = '" +usertype+ "' and type = 15");
}else{
RecordSet.executeSql("select requestid from SysPoppupRemindInfoNew where   userid in (" + userIDAll + ") and usertype = '" +usertype+ "' and type = 1");
}
}else{
if(flag.equals("newWf")){
RecordSet.executeSql("select requestid from SysPoppupRemindInfoNew where   userid in (" + user.getUID() + ") and usertype = '" +usertype+ "' and type = 0");
}else if(flag.equals("birthWf")){ //生日提醒
RecordSet.executeSql("select requestid from SysPoppupRemindInfoNew where   userid = " + user.getUID() + " and usertype = '" +usertype+ "' and type = 2");
}else if(flag.equals("chgPassWf")){ //密码变更提醒
RecordSet.executeSql("select requestid from SysPoppupRemindInfoNew where   userid = " + user.getUID() + " and usertype = '" +usertype+ "' and type = 6");
}else if(flag.equals("contractExpWf")){ //合同到期提醒
RecordSet.executeSql("select requestid from SysPoppupRemindInfoNew where   userid = " + user.getUID() + " and usertype = '" +usertype+ "' and  type = 7");
}else if(flag.equals("newWorkerWf")){ //人员入职提醒
RecordSet.executeSql("select requestid from SysPoppupRemindInfoNew where   userid = " + user.getUID() + " and usertype = '" +usertype+ "' and type = 8");
}else if(flag.equals("ovettime")){ //超时提醒
RecordSet.executeSql("select requestid from SysPoppupRemindInfoNew where   userid = " + user.getUID() + " and usertype = '" +usertype+ "' and type = 10");
}else if(flag.equals("rejectWf")){
RecordSet.executeSql("select requestid from SysPoppupRemindInfoNew where   userid = " + user.getUID() + " and usertype = '" +usertype+ "' and type = 14");
}else if(flag.equals("newEmail")){
RecordSet.executeSql("select requestid from SysPoppupRemindInfoNew where   userid = " + user.getUID() + " and usertype = '" +usertype+ "' and type = 15");
}else{
RecordSet.executeSql("select requestid from SysPoppupRemindInfoNew where   userid = " + user.getUID() + " and usertype = '" +usertype+ "' and type = 1");
}
}
while(RecordSet.next()){

	requestids = requestids+","+RecordSet.getString("requestid");
	
}


//新的工作流到达

if(flag.equals("newWf")){
	String sqlwhere = "t2.isremark in( '0','1','5','9','8','7') and t2.islasttimes=1";
	if(requestids!=null && !"".equals(requestids)){
	sqlwhere+=" and (" + Util.getSubINClause(requestids, "t1.requestid", "in") + ")";
	//sqlwhere+="  and  t1.requestid in ("+requestids+")";
	}
	String sqlwhere2 =" and (" + Util.getSubINClause(requestids, "requestid", "in") + ") and islasttimes=1 and isremark in ('0') ";
	SearchClause.setWhereClause(sqlwhere);
    SearchClause.setWhereclauseOs(sqlwhere2);
	orderclause="t2.receivedate ,t2.receivetime ";
    orderclause2=orderclause;
	SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);
	SearchClause.setOrderclauseOs("receivedate ,receivetime");
    response.sendRedirect("/workflow/search/WFSearchResult.jsp?start=1&perpage=10&flag=newWf&isFromMessage=1");
}
//工作流完成

else if(flag.equals("endWf")){
	String sqlwhere =" t1.currentnodetype=3 and t2.islasttimes=1 ";
	if(requestids!=null && !"".equals(requestids)){
	sqlwhere+=" and (" + Util.getSubINClause(requestids, "t1.requestid", "in") + ")";
	//sqlwhere+="   and t1.requestid in ("+requestids+")";
	}
	SearchClause.setWhereClause(sqlwhere);
	SearchClause.setWhereclauseOs(" and 1=2 ");
	orderclause="t2.receivedate ,t2.receivetime ";
    orderclause2=orderclause;
    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);
	response.sendRedirect("/workflow/search/WFSearchResult.jsp?start=1&perpage=10&flag=endWf&isFromMessage=1");
}
//退回工作流
else if(flag.equals("rejectWf")){
	String sqlwhere =" t2.islasttimes=1 ";
	if(requestids!=null && !"".equals(requestids)){
		if("1".equals(belongtoshow)){
	sqlwhere+="   and exists (select sp.requestid from SysPoppupRemindInfoNew sp where sp.requestid=t1.requestid and userid in (" + userIDAll + ") and usertype = '" +usertype+ "' and type = 14) ";
		}else{
	sqlwhere+="   and exists (select sp.requestid from SysPoppupRemindInfoNew sp where sp.requestid=t1.requestid and userid = " + user.getUID() + " and usertype = '" +usertype+ "' and type = 14) ";	
		}
	}
	SearchClause.setWhereClause(sqlwhere);
	SearchClause.setWhereclauseOs(" and 1=2 ");
	orderclause="t2.receivedate ,t2.receivetime ";
    orderclause2=orderclause;
    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);
	response.sendRedirect("/workflow/search/WFSearchResult.jsp?start=1&perpage=10&flag=rejectWf&isFromMessage=1");
}

//工作流超时

else if(flag.equals("ovettime")){
	String sqlwhere =" ((t2.isremark='0' and (t2.isprocessed='2' or t2.isprocessed='3'))  or t2.isremark='5') and t2.islasttimes=1 ";
	if(requestids!=null && !"".equals(requestids)){
	sqlwhere+=" and (" + Util.getSubINClause(requestids, "t1.requestid", "in") + ")";
	//sqlwhere+="   and t1.requestid in ("+requestids+")";
	}
	SearchClause.setWhereClause(sqlwhere);
	SearchClause.setWhereclauseOs(" and 1=2 ");
	orderclause="t2.receivedate ,t2.receivetime ";
    orderclause2=orderclause;
    SearchClause.setOrderClause(orderclause);
    SearchClause.setOrderClause2(orderclause2);
	response.sendRedirect("/workflow/search/WFSearchResult.jsp?start=1&perpage=10&flag=ovettime");
}

else if(flag.equals("birthWf")){
    String birthremindids="";
    if(requestids!=null && !"".equals(requestids)){
    birthremindids+=requestids;
	}
    RequestDispatcher dispatcher=request.getRequestDispatcher("/hrm/resource/BrithRemindList.jsp") ;
    request.setAttribute("birthremindids",birthremindids);
    dispatcher.forward(request,response);
}
else if(flag.equals("chgPassWf")){

    response.sendRedirect("/hrm/HrmTab.jsp?_fromURL=HrmResourcePassword&id=" + user.getUID());
}
else if(flag.equals("contractExpWf")){
    String contractRemindIds="";
    if(requestids!=null && !"".equals(requestids)){
    contractRemindIds+=requestids;
	}
    RequestDispatcher dispatcher=request.getRequestDispatcher("/hrm/resource/ContractRemindList.jsp") ;
    request.setAttribute("contractRemindIds",contractRemindIds);
    dispatcher.forward(request,response);
}
else if(flag.equals("newWorkerWf")){
    String newWorkerRemindIds="";
    if(requestids!=null && !"".equals(requestids)){
    newWorkerRemindIds+=requestids;
	}
    RequestDispatcher dispatcher=request.getRequestDispatcher("/hrm/resource/NewWorkerRemindList.jsp") ;
    request.setAttribute("newWorkerRemindIds",newWorkerRemindIds);
    dispatcher.forward(request,response);
}else if(flag.equals("newEmail")){
    String newEmailRemindIds="";
    if(requestids!=null && !"".equals(requestids)){
    	newEmailRemindIds+=requestids;
	}
    RequestDispatcher dispatcher=request.getRequestDispatcher("/email/new/MailInBox.jsp?folderid=0&receivemail=false&clickObj=1") ;
    request.setAttribute("newEmailRemindIds",newEmailRemindIds);
    dispatcher.forward(request,response);
}
else{
}
%>

