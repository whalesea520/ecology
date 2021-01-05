
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="requestutil" class="weaver.workflow.request.todo.RequestUtil" scope="page" />
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%

String workflowid = Util.null2String(request.getParameter("workflowid"));
String typeid = Util.null2String(request.getParameter("typeid"));
String offical = Util.null2String(request.getParameter("offical"));
int officalType = Util.getIntValue(request.getParameter("officalType"));

String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
if (user == null ) return ;
List countArr = new ArrayList();
countArr.add("flowAll");
countArr.add("flowNew");
countArr.add("flowResponse");
countArr.add("flowOut");
countArr.add("flowSup");

if(typeid.equals("")&&workflowid.equals("") && !offical.equals("1")){
	//开始进入
String userID = String.valueOf(user.getUID());
String userIDAll = String.valueOf(user.getUID());
int userid=user.getUID();
String belongtoshow = "";				
								RecordSet.executeSql("select * from HrmUserSetting where resourceId = "+userID);
								if(RecordSet.next()){
									belongtoshow = RecordSet.getString("belongtoshow");
								}
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



	String logintype = ""+user.getLogintype();
	int usertype = 0;

	String resourceid= ""+Util.null2String((String) session.getAttribute("RequestViewResource"));
	//QC235172,如果不是查看自己的代办，主从账号统一显示不需要判断
	if(!"".equals(resourceid) && !(""+user.getUID()).equals(resourceid)) belongtoshow = "";
	
	if(resourceid.equals("")) {
		resourceid = ""+user.getUID();
		if(logintype.equals("2")) usertype= 1;
			session.removeAttribute("RequestViewResource") ;
		}
	else {
		session.setAttribute("RequestViewResource",resourceid) ;
	}

	
	
	String CurrentUser = Util.null2String((String) request.getSession().getAttribute("RequestViewResource"));
	if (logintype.equals("2"))
		usertype = 1;
	if (CurrentUser.equals("")) {
		CurrentUser = "" + user.getUID();
	}
	boolean superior = false; //是否为被查看者上级或者本身
	if ((user.getUID() + "").equals(CurrentUser)) {
		superior = true;
	} else {
		RecordSet.executeSql("SELECT * FROM HrmResource WHERE ID = " + CurrentUser + " AND managerStr LIKE '%," + user.getUID() + ",%'");

		if (RecordSet.next()) {
			superior = true;
		}
	}
	
	if (superior)
		CurrentUser = user.getUID() + "";
	
	
	//System.out.println("superior=" + superior);
	
	int  flowNew = 0;
	int flowResponse = 0;
	int flowOut = 0;
	int flowSup = 0;
	int flowAll = 0;
	for(int a=0;a<countArr.size();a++)
	{
	    StringBuffer sqlsb = new StringBuffer();
		if("1".equals(belongtoshow)){
		sqlsb.append("select count(a.requestid) wfCount ");
		}else{
		sqlsb.append("select count(distinct a.requestid) wfCount ");
		}
		sqlsb.append("	  from workflow_currentoperator a, workflow_base wb ");
		if(countArr.get(a).equals("flowOut")){
			sqlsb.append("	  where (((isremark='0' and (takisremark is null or takisremark=0 )) and isprocessed <> '1' ) or isremark = '5') ");
		}else if(countArr.get(a).equals("flowNew")){
			sqlsb.append("	  where (((isremark='0' and (takisremark is null or takisremark=0 )) and (isprocessed is null or (isprocessed <> '2' and isprocessed <> '3'))) or isremark in('1','5','8','9','7')) ");
		}else if(countArr.get(a).equals("flowSup") || countArr.get(a).equals("flowResponse")){
			sqlsb.append("    where (((isremark='0' and (takisremark is null or takisremark=0 )) or isremark in('1','5','8','9','7'))  or (isremark = '0' and isprocessed is null))");
		}else{
			sqlsb.append("	  where ((isremark='0' and (takisremark is null or takisremark=0 )) or isremark in('1','5','8','9','7')) ");
		}
		sqlsb.append("	    and islasttimes = 1 ");
		if("1".equals(belongtoshow)){
		sqlsb.append("	    and a.userid in (").append(userIDAll);
		}else{
		sqlsb.append("	    and a.userid in (").append(resourceid);
		}
		sqlsb.append("	 )   and a.usertype = ").append(usertype);
		sqlsb.append("	    and exists (select c.requestid ");
		sqlsb.append("	           from workflow_requestbase c ");
		sqlsb.append("	          where (c.deleted <> 1 or c.deleted is null or c.deleted='') and c.requestid = a.requestid");
		
		
		sqlsb.append(" and a.workflowid=wb.id ");
		sqlsb.append(" and wb.isvalid in (1, 3) ");
		if(RecordSet.getDBType().equals("oracle"))
		{
			sqlsb.append(" and (nvl(c.currentstatus,-1) = -1 or (nvl(c.currentstatus,-1)=0 and c.creater="+user.getUID()+")) ");
		}
		else
		{
			sqlsb.append(" and (isnull(c.currentstatus,-1) = -1 or (isnull(c.currentstatus,-1)=0 and c.creater="+user.getUID()+")) ");
		}
		sqlsb.append(")");
	    //SQL = "select a.viewtype, count(distinct a.requestid) workflowcount from workflow_currentoperator a  where   ((isremark='0' and (isprocessed is null or (isprocessed<>'2' and isprocessed<>'3'))) or isremark='1' or isremark='8' or isremark='9' or isremark='7') and islasttimes=1 and userid=" +  resourceid  + " and usertype= " + usertype +" and a.workflowtype="+tworkflowtype+" and a.workflowid="+tworkflowid+" and exists (select c.requestid from workflow_requestbase c where c.requestid=a.requestid) ";
	    
	    if(!superior)
		{
	    	sqlsb.append(" AND EXISTS (SELECT NULL FROM workFlow_CurrentOperator b WHERE a.workflowid = b.workflowid AND a.requestid = b.requestid AND b.userid=" + user.getUID() + " and b.usertype= " + usertype +") ");
		}
		
		if(offical.equals("1")){//发文/收文/签报
			if(officalType==1){
				sqlsb.append(" and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (1,3) and (isvalid=1 or isvalid=3))");
			}else if(officalType==2){
				sqlsb.append(" and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType=2 and (isvalid=1 or isvalid=3))");
			}
		}
	    
	    //sqlsb.append(" group by a.viewtype, a.workflowtype, a.workflowid");
		String sql=sqlsb.toString();
			if(countArr.get(a).equals("flowNew"))
				sql += " and a.viewtype = '0' and a.isremark != '5' and a.isprocessed is null ";
			else if(countArr.get(a).equals("flowResponse"))
				sql += " and a.viewtype = '-1' ";
			//else if(countArr.get(a).equals("flowOut"))
				//sql += " and a.isremark = '5' ";
			else if(countArr.get(a).equals("flowSup"))
				sql += " and a.requestid in (select requestid from workflow_requestlog where logtype='s') ";
			else 
				sql +="";
			
		//System.out.println("SLQ:::::::+++>>>>"+sql);
		RecordSet.executeSql(sql);
		
		if(RecordSet.first()){
			//System.out.println(Util.getIntValue(RecordSet.getString("wfCount")));
			if(countArr.get(a).equals("flowNew"))
				flowNew = Util.getIntValue(RecordSet.getString("wfCount"));
			else if(countArr.get(a).equals("flowResponse"))
				flowResponse = Util.getIntValue(RecordSet.getString("wfCount"));
			else if(countArr.get(a).equals("flowOut"))
				flowOut = Util.getIntValue(RecordSet.getString("wfCount"));
			else if(countArr.get(a).equals("flowSup"))
				flowSup = Util.getIntValue(RecordSet.getString("wfCount"));
			else 
				flowAll = Util.getIntValue(RecordSet.getString("wfCount"));
		}
		
	}
	
	//加上异构系统数据的数量
    if(requestutil.getOfsSetting().getIsuse()==1) {
        //全部待办
        RecordSet.executeSql("select COUNT(requestid) from ofs_todo_data where userid="+user.getUID()+" and isremark='0' and islasttimes=1");
        if (RecordSet.next()) {
            flowAll += Util.getIntValue(RecordSet.getString(1), 0);
        }

        //未查看的待办
        RecordSet.executeSql("select COUNT(requestid) from ofs_todo_data where userid="+user.getUID()+" and isremark='0' and islasttimes=1 and viewtype=0 ");
        if (RecordSet.next()) {
            flowNew += Util.getIntValue(RecordSet.getString(1), 0);
        }
    }
	
	String data="{\"flowNew\":\""+flowNew+"\",\"flowResponse\":\""+flowResponse+"\",\"flowOut\":\""+flowOut+"\",\"flowSup\":\""+flowSup+"\",\"flowAll\":\""+flowAll+"\"}";
	
	response.getWriter().write(data);
	
}
%>

