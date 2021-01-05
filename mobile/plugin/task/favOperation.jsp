<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.file.FileUpload"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<jsp:useBean id="rc" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<%
	request.setCharacterEncoding("UTF-8");
	JSONObject json = new JSONObject();
	int status = 1;String msg = "";
	try{
		FileUpload fu = new FileUpload(request);
		String taskid = Util.null2String(fu.getParameter("taskid"));
		if(cmutil.getRight(taskid,user)<1) return;
		int special = Util.getIntValue(request.getParameter("special"),0);
		//System.out.println(taskid+"-"+special);
		rs.executeSql("delete from TM_TaskSpecial where taskid="+taskid+" and userid="+user.getUID());
		if(special==0){
			rs.executeSql("insert into TM_TaskSpecial (taskid,userid) values("+taskid+","+user.getUID()+")");
		}
		//记录日志
		String currentDate = TimeUtil.getCurrentDateString();
		String currentTime = TimeUtil.getOnlyCurrentTimeString();
		rs.executeSql("insert into TM_TaskLog (taskid,type,operator,operatedate,operatetime,operatefiled,operatevalue)"
				+" values("+taskid+",12,"+user.getUID()+",'"+currentDate+"','"+currentTime+"','special','"+special+"')");
		status = 0;
	}catch(Exception e){
		msg = "增加关注失败,请稍后再试";
	}
	json.put("status",status);
	json.put("msg",msg);
	out.print(json.toString());
%>