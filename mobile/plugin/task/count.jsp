<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ps" class="weaver.mobile.plugin.ecology.service.PluginServiceImpl" scope="page" />
<%
response.setContentType("application/json;charset=UTF-8");

String module = Util.null2String(request.getParameter("module"));
String scope = Util.null2String(request.getParameter("scope"));
String sessionkey = Util.null2String(request.getParameter("sessionkey"));
		
if(ps.verify(sessionkey)) {
	
	String countSql = "select count(t1.id) as amount ";
	
	String func1 = "";
	String operatedt = "";
	String createdt = "";
	if(!"oracle".equals(rs.getDBType())){
		func1 = "isnull";
		operatedt = "max(operatedate+' '+operatetime)";
		createdt = "max(createdate+' '+createtime)";
	}else{
		func1 = "nvl";
		operatedt = "max(CONCAT(CONCAT(operatedate,' '),operatetime))";
		createdt = "max(CONCAT(CONCAT(createdate,' '),createtime))";
	}
	
	int userid = user.getUID();
	String sql1 = "from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null) and t1.creater<>"+userid
			+" and (t1.principalid = "+userid
			+" or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+")"
			//+" or exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+userid+")"
			+")"
			+" and not exists (select 1 from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+")";
		
	String sql2 = "from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null)"	
			+" and (t1.creater = "+userid+" or t1.principalid = "+userid
			+" or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+")"
			+" or exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+userid+")"
			+")"
			+" and "+func1+"((select "+createdt+"  from TM_TaskFeedback t3 where t3.taskid=t1.id and t3.hrmid<>"+userid+"),'')"
			+" > "+func1+"((select "+operatedt+" from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+"),'')";
	int newcount = 0;
	int fbcount = 0;
	rs.executeSql(countSql+sql1);
	if(rs.next()){
		newcount = rs.getInt(1);
	}
	//System.out.println("newcount======"+newcount);
	rs.executeSql(countSql+sql2);
	if(rs.next()){
		fbcount = rs.getInt(1);
	}
	//System.out.println("fbcount======"+fbcount);
	Map result = new HashMap();
	result.put("count",0);
	result.put("unread",newcount+fbcount);
	
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
}
%>