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
		String taskId = Util.null2String(fu.getParameter("taskid"));
		if(cmutil.getRight(taskId,user)<1) return;
		String tstatus = Util.null2String(fu.getParameter("status"));
		
		if(!taskId.equals("") && !tstatus.equals("")){
			if(tstatus.equals("4")){//删除
				rs.executeSql("update TM_TaskInfo set deleted=1 where id="+taskId);
				rs.executeSql("update TM_TaskInfo set parentid = null where parentid="+taskId);
			}else{
				String sql = "update TM_TaskInfo set status="+tstatus+" where id="+taskId;
				rs.executeSql(sql);
			}
			int type = 0;
			if(tstatus.equals("1")){//标记进行
				type = 5;
			}else if(tstatus.equals("2")){//标记完成
				type = 6;
			}else if(tstatus.equals("3")){//撤销
				type = 7;
			}else{//删除
				type = 8;
			}
			//记录日志
			String currentDate = TimeUtil.getCurrentDateString();
			String currentTime = TimeUtil.getOnlyCurrentTimeString();
			rs.executeSql("insert into TM_TaskLog (taskid,type,operator,operatedate,operatetime,operatefiled,operatevalue)"
				+" values("+taskId+","+type+","+user.getUID()+",'"+currentDate+"','"+currentTime+"','','')");
			//更改为完成时加入反馈记录
			if(tstatus.equals("2")){
				//添加完成反馈
				String content = "已完成！";
				String sql = "insert into TM_TaskFeedback (taskid,content,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime)"
					+" values("+taskId+",'"+content+"',"+user.getUID()+",'','','','','','','"+currentDate+"','"+currentTime+"')";
				rs.executeSql(sql);
				StringBuffer restr = new StringBuffer();
				restr.append("<tr><td class='data fbdata'><div class='feedbackshow'>"
						+"<div class='feedbackinfo'>"+rc.getLastname(user.getUID()+"")+" "+currentDate+" "+currentTime+"</div>"
						+"<div class='feedbackrelate'>"
						+"<div style='width:100%'>"+Util.convertDB2Input(content)+"</div>");
				restr.append("</div></div></td></tr>");
				json.put("str",restr.toString());
			}
		}
		status = 0;
	}catch(Exception e){
		msg = "标记完成失败,请稍后再试";
	}
	json.put("status",status);
	json.put("msg",msg);
	out.print(json.toString());
%>