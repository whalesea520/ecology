
<%@ page language="java" contentType="application/json;charset=UTF-8" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.*,weaver.conn.*,org.json.*,java.math.*,java.text.*,java.util.*"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager,
                 weaver.docs.docs.FieldParam,
                 weaver.systeminfo.SystemEnv" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="taskManager" class="weaver.worktask.request.TaskManager" scope="page"/>

<%
out.clearBuffer();
User user = HrmUserVarify.getUser (request , response) ;
char flag=Util.getSeparator();
int userid=user.getUID();
request.setCharacterEncoding("UTF-8");
//任务清单id
String tasklistid = request.getParameter("tasklistid");
String iscomplete = request.getParameter("iscomplete");
SimpleDateFormat format=new SimpleDateFormat("yyyy-MM-dd");
//操作日期
String opdate=format.format(new Date());
format = new SimpleDateFormat("HH:mm:ss");
//操作时间
String optime=format.format(new Date());
try{
    //更新任务清单状态
    String sql = "update worktask_list set complete='"+iscomplete+"',completedate='"+opdate+"',completetime='"+optime+"' where id='"+tasklistid+"'";
	//System.out.println("sqlitem==================>"+sql);
	rs.execute(sql);
	
	if("1".equals(iscomplete)){
		//模拟当前操作人 发一条交流信息。标志完成
		//获取requestid
		String requestid = "";
		String taskname = "";
		sql = " select * from worktask_list where id='"+tasklistid+"'";
		rs.execute(sql);
		while(rs.next()){
			requestid = rs.getString("requestid");
			taskname = rs.getString("name") +"-----"+SystemEnv.getHtmlLabelName(555, user.getLanguage())+" !";
		}
		String id = UUID.randomUUID().toString();
		format = new SimpleDateFormat("HH:mm");
		optime=format.format(new Date());
		sql = "insert into worktask_discuss(id,reqeustid,userid,datetime,content)  values('"+id+"',"+requestid+","+user.getUID()+",'"+opdate+" "+optime+"','"+taskname+"')";
		rs.execute(sql);
		
		//添加操作日志
		sql = "  select status from worktask_requestbase where requestid="+requestid;
		rs.execute(sql);
		String status="";
		while(rs.next()){
			status = rs.getString("status");
		}
		taskManager.doSaveOperateLog(requestid,user.getUID()+"",status,status,"16",tasklistid);
	}
	out.println("{\"success\":\"1\"}");
}catch(Exception e){
	out.println("{\"success\":\"0\"}");
}

%>