
<%@ page language="java" contentType="text/plain; charset=UTF-8"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.workflow.request.RequestBrowser" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="crmComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>
<%!
public String convertSpecialChar(String str){
	str = str.replaceAll("\\\t|\\\r|\\\n|\\\f", "");
	str = str.replaceAll("\\\\", "\\\\\\\\");
	return str;
}
%>

<%

String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;
		String userID = String.valueOf(user.getUID());
		int userid=user.getUID();
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
String importuser=Util.null2String(request.getParameter("importuser"));
//System.out.println("--59-importuser--"+importuser);
//System.out.println("--59-userID--"+userID);
String requestname = Util.null2String(request.getParameter("requestname"));
    //System.out.println("requestname = " + requestname);
String creater = Util.null2String(request.getParameter("creater"));

if (creater.equals("")) {
    creater = user.getUID() + "";
}
if(!importuser.equals(String.valueOf(user.getUID()))){
	creater = importuser;
}

String createdatestart = Util.null2String(request.getParameter("createdatestart"));
String createdateend = Util.null2String(request.getParameter("createdateend"));
if("".equals(createdatestart)){
	Calendar calendar = Calendar.getInstance();
	calendar.setTime(new Date());
	calendar.add(Calendar.YEAR, -1);
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	createdatestart = sdf.format(calendar.getTime());
}
String isrequest = Util.null2String(request.getParameter("isrequest"));
String requestmark = Util.null2String(request.getParameter("requestmark"));
String prjids=Util.null2String(request.getParameter("prjids"));
String crmids=Util.null2String(request.getParameter("crmids"));
String workflowid=Util.null2String(request.getParameter("workflowid"));
String formid=Util.null2String(request.getParameter("formid"));
int isbill=Util.getIntValue(request.getParameter("isbill"),0);
String department =Util.null2String(request.getParameter("department"));
String status = Util.null2String(request.getParameter("status"));
String ismode = Util.null2String(request.getParameter("ismode"));
String sqlwhere = "";
if (isrequest.equals("")) isrequest = "1";

//String userid = ""+user.getUID() ;
String usertype="0";

if(user.getLogintype().equals("2")) usertype="1";

int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!requestname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.requestname like '%" + Util.fromScreen2(requestname,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and t1.requestname like '%" + Util.fromScreen2(requestname,user.getLanguage()) +"%' ";
}

if(!creater.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.creater in (" + creater +") " ;
	}
	else
		sqlwhere += " and t1.creater in (" + creater +") " ;
}

if(!createdatestart.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.createdate >='" + createdatestart +"' " ;
	}
	else
		sqlwhere += " and t1.createdate >='" + createdatestart +"' " ;
}

if(!createdateend.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.createdate <='" + createdateend +"' " ;
	}
	else
		sqlwhere += " and t1.createdate <='" + createdateend +"' " ;
}

if(status.equals("1")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.currentnodetype <> 3 " ;
	}
	else
		sqlwhere += " and t1.currentnodetype <> 3 " ;
}

if(status.equals("2")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.currentnodetype = 3 " ;
	}
	else
		sqlwhere += " and t1.currentnodetype = 3 " ;
}

if(!formid.equals("")&&!formid.equals("0")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.workflowid in (select id from workflow_base where isbill='"+isbill+"' and formid=" + formid +")";
	}
	else
		sqlwhere += " and t1.workflowid in (select id from workflow_base where isbill='"+isbill+"' and formid=" + formid +")";
}

if(!workflowid.equals("")&&!workflowid.equals("0")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.workflowid in (" + WorkflowVersion.getAllVersionStringByWFIDs(workflowid)+ ")";
	}
	else
		sqlwhere += " and t1.workflowid in (" + WorkflowVersion.getAllVersionStringByWFIDs(workflowid) + ")";
}

if(!department.equals("")&&!department.equals("0")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.creater in (select id from hrmresource where departmentid in ("+department+"))";
	}
	else
		sqlwhere += " and t1.creater in (select id from hrmresource where departmentid in ("+department+"))";
}

if(!prjids.equals("")&&!prjids.equals("0")){
	if(ishead==0){
		ishead = 1;
		if(RecordSet.getDBType().equals("oracle")){
			sqlwhere += " where (concat(concat(',' , To_char(t1.prjids)) , ',') LIKE '%,"+prjids+",%') ";
		}else{
			sqlwhere += " where (',' + CONVERT(varchar,t1.prjids) + ',' LIKE '%,"+prjids+",%') ";
		}
	}else{
		if(RecordSet.getDBType().equals("oracle")){
			sqlwhere += " and (concat(concat(',' , To_char(t1.prjids)) , ',') LIKE '%,"+prjids+",%') ";
		}else{
			sqlwhere += " and (',' + CONVERT(varchar,t1.prjids) + ',' LIKE '%,"+prjids+",%') ";
		}
	}
}

if(!crmids.equals("")&&!crmids.equals("0")){
	if(ishead==0){
		ishead = 1;
		if(RecordSet.getDBType().equals("oracle")){
			sqlwhere += " where (concat(concat(',' , To_char(t1.crmids)) , ',') LIKE '%,"+crmids+",%') ";
		}else{
			sqlwhere += " where (',' + CONVERT(varchar,t1.crmids) + ',' LIKE '%,"+crmids+",%') ";
		}
	}else{
		if(RecordSet.getDBType().equals("oracle")){
			sqlwhere += " and (concat(concat(',' , To_char(t1.crmids)) , ',') LIKE '%,"+crmids+",%') ";
		}else{
			sqlwhere += " and (',' + CONVERT(varchar,t1.crmids) + ',' LIKE '%,"+crmids+",%') ";
		}
	}
}

if(!requestmark.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.requestmark like '%" + requestmark +"%' " ;
	}
	else
		sqlwhere += " and t1.requestmark like '%" + requestmark +"%' " ;
}

if (sqlwhere.equals("")){
	if("1".equals(belongtoshow)){
    sqlwhere = " where t1.requestid <> 0 and t2.requestid = t1.requestid   and t1.workflowid=t3.id and    and t2.userid in (" +importuser + ") and t2.usertype="+usertype+" and exists(select 1 from workflow_base where id=t1.workflowid and (isvalid='1' or isvalid='3'))" ;
	}else{
	 sqlwhere = " where t1.requestid <> 0 and t2.requestid = t1.requestid   and t1.workflowid=t3.id and    and t2.userid in (" +userid + ") and t2.usertype="+usertype+" and exists(select 1 from workflow_base where id=t1.workflowid and (isvalid='1' or isvalid='3'))" ;
	}
}else{
	if("1".equals(belongtoshow)){
    sqlwhere += " and t2.requestid = t1.requestid and t1.workflowid=t3.id  and t2.userid in (" +importuser + ") and t2.usertype="+usertype+" and exists(select 1 from workflow_base where id=t1.workflowid and (isvalid='1' or isvalid='3')) " ;
	}else{
	sqlwhere += " and t2.requestid = t1.requestid and t1.workflowid=t3.id  and t2.userid in (" +userid + ") and t2.usertype="+usertype+" and exists(select 1 from workflow_base where id=t1.workflowid and (isvalid='1' or isvalid='3')) " ;
	}
}

%>

<%
//String backfields = " t4.nodetype,t2.nodeid,t3.formid,t3.isbill,t1.requestid,t1.requestname,t1.creater,t1.createdate,t1.createtime ";
String backfields = " DISTINCT t3.formid,t3.isbill,t1.requestid,t1.requestname,t1.creater,t1.createdate,t1.createtime ";
String fromSql  = " workflow_requestbase t1, workFlow_CurrentOperator t2,workflow_base t3,workflow_flownode t4  ";
String tableString = "";
int perpage=10;
String sql="select "+backfields+" from "+fromSql+sqlwhere+" order by t1.createdate desc,t1.createtime desc";




//System.out.println(sql);

String creatNodeId = "";
RecordSet.executeSql("SELECT nodeid FROM workflow_flownode WHERE workflowid=" + workflowid + " AND nodetype=0");
if (RecordSet.next()) {
    creatNodeId = RecordSet.getString("nodeid");
}

RecordSet.executeSql(sql);

StringBuffer  sb=new StringBuffer("[");
StringBuffer  jsonitem;
while(RecordSet.next()){
   
     jsonitem=new StringBuffer("{");

     jsonitem.append("\"data\":\""+RecordSet.getString("requestid")).append("\",");

	 jsonitem.append("\"isbill\":\""+RecordSet.getString("isbill")).append("\",");
 
     jsonitem.append("\"formid\":\""+RecordSet.getString("formid")).append("\",");

	 jsonitem.append("\"nodeid\":\""+creatNodeId).append("\",");

	 jsonitem.append("\"nodetype\":\""+0).append("\",");
 
     jsonitem.append("\"value\":\""+convertSpecialChar(RecordSet.getString("requestname"))).append("\"},");

     sb.append(jsonitem.toString());
}
String jsonrs;
if(sb.length()>1)
{
   jsonrs=sb.substring(0,sb.length()-1)+"]";
}else
{
   jsonrs=sb.append("]").toString();
}
//System.out.println(jsonrs);
out.print(jsonrs);
%>




