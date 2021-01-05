<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.file.FileUpload"%>
<%@ page import="weaver.workrelate.util.*"%>
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
		StringBuffer restr = new StringBuffer();
		String taskId = Util.null2String(fu.getParameter("taskId"));
		String content = Util.toHtml(fu.getParameter("content"));
		String docids = cmutil.cutString(fu.getParameter("docids"),",",3);
		String wfids = cmutil.cutString(fu.getParameter("wfids"),",",3);
		String crmids = cmutil.cutString(fu.getParameter("crmids"),",",3);
		String projectids = cmutil.cutString(fu.getParameter("projectids"),",",3);
		String meetingids = cmutil.cutString(fu.getParameter("meetingids"),",",3);
		String fileids = cmutil.cutString(fu.getParameter("fileids"),",",3);
		if(!fileids.equals("")) fileids = "," + fileids + ",";
		String replyid = Util.null2String(fu.getParameter("replyid"));
		if(!taskId.equals("") && !content.equals("")){
			String userid = user.getUID()+"";
			String currentDate = TimeUtil.getCurrentDateString();
			String currentTime = TimeUtil.getOnlyCurrentTimeString();
			String sql = "insert into TM_TaskFeedback (taskid,content,hrmid,docids,wfids,crmids,projectids,"+
						 "meetingids,fileids,createdate,createtime,replyid)"
						 +" values("+taskId+",'"+content+"',"+userid+",'"+docids+"','"+wfids+"','"+crmids+"','"+
						 projectids+"','"+meetingids+"','"+fileids+"','"+currentDate+"','"+currentTime+"','"+replyid+"')";
			rs.executeSql(sql);
			String fbid = "";
			rs.executeSql("select max(id) from TM_TaskFeedback");
			if(rs.next()) fbid = Util.null2String(rs.getString(1));
			restr.append("<tr><td><div class='feedbackshow'>"
					+"<table class='fbShowTable'><tr><td width='40%' class='date'>"
					+rc.getLastname(userid)+"</td><td width='60%' class='date' style='text-align:right;'>"
					+currentDate+" "+currentTime+"</td></tr>");
			restr.append("<tr><td colspan='2'><div class='feedbackrelate'>"
				+"<div style='width:100%'>"+Util.null2String(content)+"</div>");
			if(!"".equals(docids)){
				restr.append("<div class=1relatetitle'>相关文档："+cmutil.getDocNameForMobile(docids)+"</div>");
			}
			if(!"".equals(wfids)){
				restr.append("<div class=1relatetitle'>相关流程："+cmutil.getRequestNameForMobile(wfids)+"</div>");
			}
			if(!"".equals(crmids)){
				restr.append("<div class=1relatetitle'>相关客户："+cmutil.getCustomerForMobile(crmids)+"</div>");
			}
			if(!"".equals(projectids)){
				restr.append("<div class=1relatetitle'>相关项目："+cmutil.getProjectForMobile(projectids)+"</div>");
			}
			if(!"".equals(fileids)){
				restr.append("<div class=1relatetitle'>相关附件："+cmutil.getFileNameForMobile(fileids)+"</div>");
			}
			if(!replyid.equals("")){
				rs2.executeSql("select id,content,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime,replyid from TM_TaskFeedback where id="+replyid);
				if(rs2.next()){
					restr.append("<div class='fbreply'>");
					restr.append("<div class='feedbackinfo2'>@ "+rc.getLastname(rs2.getString("hrmid"))+" "+Util.null2String(rs2.getString("createdate"))+" "+Util.null2String(rs2.getString("createtime"))+"</div>");
					restr.append("<div class='feedbackrelate2'>");
					restr.append("<div>"+Util.null2String(rs2.getString("content"))+"</div>");
					if(!"".equals(rs2.getString("docids"))){
						restr.append("<div class='relatetitle2'>相关文档："+cmutil.getDocNameForMobile(rs2.getString("docids"))+"</div>");
					}
					if(!"".equals(rs2.getString("wfids"))){
						restr.append("<div class='relatetitle2'>相关流程："+cmutil.getRequestNameForMobile(rs2.getString("wfids"))+"</div>");
					}
					if(!"".equals(rs2.getString("crmids"))){
						restr.append("<div class='relatetitle2'>相关客户："+cmutil.getCustomerForMobile(rs2.getString("crmids"))+"</div>");
					} 
					if(!"".equals(rs2.getString("projectids"))){ 
						restr.append("<div class='relatetitle2'>相关项目："+cmutil.getProjectForMobile(rs2.getString("projectids"))+"</div>");
					}
					if(!"".equals(rs2.getString("fileids"))){
						restr.append("<div class='relatetitle2'>相关附件："+cmutil.getFileNameForMobile(rs2.getString("fileids"))+"</div>");
					}
					restr.append("</div>");
					restr.append("</div>");
				}
			}
			restr.append("</div></td></tr>");
			restr.append("<tr><td colspan='2' style='text-align:right;'>"+
			"<a href='javascript:doReply(\""+fbid+"\")'>回复</a>"+
			"</td></tr></table></div></td></tr>");
			//记录日志
			rs.executeSql("insert into TM_TaskLog (taskid,type,operator,operatedate,operatetime,operatefiled,operatevalue)"
				+" values("+taskId+",10,"+user.getUID()+",'"+currentDate+"','"+currentTime+"','','')");
			json.put("result",restr.toString());
			//发送消息提醒
			SendMsg.sendMsg(taskId,user.getUID()+"","newFb","",fbid,"","","","","");
			status = 0;
		}
	
	}catch(Exception e){
		e.printStackTrace();
		msg = "增加反馈失败,请稍后再试";
	}
	json.put("status",status);
	json.put("msg",msg);
	out.print(json.toString());
%>