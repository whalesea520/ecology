
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="weaver.rdeploy.task.TaskUtil"%>
<%@page import="weaver.general.TimeUtil"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.file.FileUpload" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="iMService" class="weaver.social.rdeploy.im.IMService" scope="page" />
<jsp:useBean id="workBlogService" class="weaver.mobile.plugin.ecology.service.WorkBlogService" scope="page" />
<%
	String userid =""+user.getUID();
    FileUpload fu = new FileUpload(request);
	String operation=Util.null2String(fu.getParameter("operation"));
	
	if(operation.equals("sharetask")){		//分享任务
		String resourceids = Util.null2String(fu.getParameter("resourceids"));
		String taskid = Util.null2String(fu.getParameter("taskid"));
		String tasktitle = Util.null2String(fu.getParameter("tasktitle"));
		//发送消息
		
	}else if(operation.equals("addtask")){		//创建任务
		String tasktitle = Util.null2String(fu.getParameter("tasktitle"));
		String taskid = TaskUtil.addTask(tasktitle, Integer.parseInt(userid));
		String shareids = Util.null2String(fu.getParameter("shareids"));
		int sPos = taskid.lastIndexOf("|");
		taskid = taskid.substring(sPos+1, taskid.length());
		TaskUtil.addShare(Integer.parseInt(taskid), shareids);
		out.println(taskid);
	}else if(operation.equals("saveChatResource")){  //保存聊天资源
		String creatorid = userid;
		String targetid = Util.null2String(fu.getParameter("targetid"));
		String targettype = Util.null2String(fu.getParameter("targettype"));
		String resourceid = Util.null2String(fu.getParameter("resourceid"));
		String resourcetype = Util.null2String(fu.getParameter("resourcetype"));
		String resourcename = Util.null2String(fu.getParameter("resourcename"));
		String memberids = Util.null2String(fu.getParameter("memberids"));
		
		iMService.saveChatResource(creatorid, targetid, targettype, 
				resourceid, resourcetype, resourcename, memberids);
	}else if(operation.equals("istaskcomplete")){		//任务是否完成
		String taskid = Util.null2String(fu.getParameter("taskid"));
		boolean isComplete = TaskUtil.ifComplete(Integer.parseInt(taskid));
		out.println(isComplete); 
	}else if(operation.equals("istaskdeleted")){		//任务是否删除
		String taskid = Util.null2String(fu.getParameter("taskid"));
		boolean ifDelete = TaskUtil.ifDelete(Integer.parseInt(taskid));
		out.println(ifDelete);
	}else if(operation.equals("completeTask")){			//完成任务
		String taskid = Util.null2String(fu.getParameter("taskid"));
		String msg = "";
		try{
			msg = TaskUtil.completeTask(Integer.parseInt(taskid), "2", Integer.parseInt(userid));
		}catch(Exception e){
			e.printStackTrace();
		}
		out.println("{\"isSuccess\":"+msg.equals("")+", \"error\":\""+msg+"\"}");
	}else if(operation.equals("gettaskinfo")){			//获取任务信息
		String taskid = Util.null2String(fu.getParameter("taskid"));
		Map info = TaskUtil.getTaskInfo(Integer.parseInt(taskid));
		out.print("{\"creator\": \""+info.get("creater")+"\",\"createdate\": \""+info.get("createdate")+"\"}");
	}else if(operation.equals("sendtoblog")){		//发送到日志
		String content = Util.null2String(fu.getParameter("content"));
		String createDate = TimeUtil.getCurrentDateString();
		workBlogService.saveBlog(userid, createDate, content, "", "0", "", "1", "");
		out.print(true);
	}else if(operation.equals("sendtotask")){			//转为任务
		String content = Util.null2String(fu.getParameter("content"));
		String msg = TaskUtil.addTask(content, Integer.parseInt(userid));
		JSONObject result = new JSONObject();
		if(msg.startsWith("|")){
			result.put("issuccess",1);
		}else{
			result.put("issuccess",0);
			result.put("errormsg", msg.substring(0, msg.indexOf("|")));
		}
		out.print(result);
	}
	
%>