<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.file.FileUpload"%>
<%@ page import="weaver.workrelate.util.*"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%
	request.setCharacterEncoding("UTF-8");
	JSONObject json = new JSONObject();
	int status = 1;String msg = "";
	try{
		FileUpload fu = new FileUpload(request);
		String name = Util.null2String(fu.getParameter("taskName"));
		if(!name.equals("")){
			String sorttype = Util.null2String(fu.getParameter("sorttype"));
			String datetype = Util.null2String(fu.getParameter("datetype"));
			String principalid = Util.null2String(fu.getParameter("principalid"));
			if(principalid.equals("") || principalid.equals("0")){
				principalid = user.getUID()+"";
			}
			String currentDate = TimeUtil.getCurrentDateString();
			String currentTime = TimeUtil.getOnlyCurrentTimeString();
			String tomorrow = TimeUtil.dateAdd(currentDate,1);
			String enddate = Util.null2String(fu.getParameter("enddate"));
			int level = Util.getIntValue(fu.getParameter("lev"),0);
			String remark = Util.convertInput2DB(fu.getParameter("remark"));
			String partnerids = Util.null2String(fu.getParameter("partnerid"));//参与人
			String taskId = this.saveTask(name, user.getUID()+"", currentDate, currentTime,
					tomorrow, enddate, level,principalid, remark, partnerids, "", sorttype, datetype);
			//增加下级任务
			String[] subTask = fu.getParameterValues("subTask");
			String[] subMan = fu.getParameterValues("subMan");
			if(null!=subTask&&subTask.length>0){
				for(int i=0;i<subTask.length;i++){
					String subTaskName = subTask[i];
					String subTaskMan = subMan[i];
					if(null!=subTaskName&&!subTaskName.trim().equals("")){
						//subTaskName = new String(subTaskName.getBytes("ISO8859_1"),"GBK");
						this.saveTask(subTaskName,user.getUID()+"",currentDate,currentTime,tomorrow,"",0, 
								subTaskMan, "", "", taskId, "", "");
					}
				}
			}
			status = 0;
		}else{
			msg = "任务名称不能为空";
		}
	}catch(Exception e){
		e.printStackTrace();
		msg = "保存任务失败,请稍后再试";
	}
	json.put("status",status);
	json.put("msg",msg);
	out.print(json.toString());
%>

<%!public String saveTask(String name,String creater,String currentDate,String currentTime,String tomorrow,
	String enddate,int level,String principalid,String remark,String partnerids,String parentid,
	String sorttype,String datetype){
	String sql = "insert into TM_TaskInfo (name,status,creater,createdate,createtime,begindate,enddate,lev,principalid,"
	+"parentid,tag,remark,risk,difficulty,assist,taskids,goalids,docids,wfids,meetingids,crmids,projectids,fileids)"
	+" values('"+name+"',1,"+creater+",'"+currentDate+"','"+currentTime+"','','"+enddate+"',"+level+","
	+principalid+",'"+parentid+"','','"+remark+"','','','','','','','','','','','')";
	RecordSet rs = new RecordSet();
	boolean res = rs.executeSql(sql);
	String taskId = "";
	if(res){
		rs.executeSql("select max(id) from TM_TaskInfo");
		if(rs.next()) taskId = rs.getString(1);
		//记录日志
		rs.executeSql("insert into TM_TaskLog (taskid,type,operator,operatedate,operatetime,operatefiled,operatevalue)"
				+" values("+taskId+",1,"+creater+",'"+currentDate+"','"+currentTime+"','','')");
		//增加个人Todolist标记
		if(sorttype.equals("5")){
			String tododate = "";
			if(datetype.equals("1")){
				tododate = currentDate;
			}else if(datetype.equals("2")){
				tododate = tomorrow;
			}else if(datetype.equals("3")){
				tododate = TimeUtil.dateAdd(currentDate,7);
			}else if(datetype.equals("5")){
				tododate = "1";
			}
			if(!tododate.equals("")){
				sql = "insert into TM_TaskTodo (taskid,userid,tododate) values('"+taskId+"','"+principalid+"','"+tododate+"')";
				rs.executeSql(sql);
			}
		}
		//增加参与人
		List partneridList = Util.TokenizerString(partnerids,",");
		String partnerid = "";
		for(int i=0;i<partneridList.size();i++){
			partnerid = Util.null2String((String)partneridList.get(i));
			if(!partnerid.equals("")){
				rs.executeSql("insert into TM_TaskPartner (taskid,partnerid) values("+taskId+","+partnerid+")");
			}
		}
		//发送消息提醒
		SendMsg.sendMsg(taskId,creater,"newTask","","","","","","","");
	}
	return taskId;
}%>