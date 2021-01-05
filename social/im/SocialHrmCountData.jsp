<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.hrm.*" %>
<%@page import="weaver.workflow.search.WorkflowRequestUtil"%>
<%@ page import="weaver.workflow.workflow.TestWorkflowCheck" %>
<%@ page import="weaver.blog.BlogDao" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="net.sf.json.*"%>
<jsp:useBean id="SocialIMService" class="weaver.social.service.SocialIMService" scope="page" />

<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null){
		return;
	}
	//问题1
	TestWorkflowCheck twc=new TestWorkflowCheck();
	if(twc.checkURI(session,request.getRequestURI(),request.getQueryString())){
	  return;
	}
	int navtype = Util.getIntValue(request.getParameter("navtype"), -1);
	String sysicoids = request.getParameter("sysicoids");
	String resourceid = request.getParameter("resourceid");
	String userid = "" + user.getUID();
	int count = -1;
	if(sysicoids != null && !sysicoids.equals("")){
		String[] ids = sysicoids.split(",");
		JSONObject ret = new JSONObject();
		for(int i = 0; i < ids.length; ++i){
			if(ids[i].equals("2")){ //待办事宜
				try{
					int wf_count = new WorkflowRequestUtil().getRequestCount(user,resourceid);
					ret.put("2", wf_count+"");
				}catch(Exception e){
					ret.put("2", count+"");
				}
			}
			if(ids[i].equals("4")){ //日志
				try{
					String weiboCount = new BlogDao().getRemindUnReadCount(userid, "update");
					ret.put("4", weiboCount);
				}catch(Exception e){
					ret.put("4", count+"");
				}
			}
			if(ids[i].equals("5")){ //邮件
				HashMap<String, String> params = new HashMap<String, String>();
				params.put("resourceid", resourceid);
				params.put("status", "0");
				params.put("folderid", "0");
				try{
					List<String> mailInfo = SocialIMService.getMailInfo(params);
					ret.put("5", mailInfo.get(0));
				}catch(Exception e){
					ret.put("5", count+"");
				}
			}
		}
		out.print(ret);
		return;
	}
	if(navtype == 1){
		//流程
		try{
			int wf_count = new WorkflowRequestUtil().getRequestCount(user,resourceid);
			count = wf_count;
		}catch(Exception e){
			count = -1;
		}
	}else if(navtype == 3){
		//微博
		try{
			String weiboCount = new BlogDao().getRemindUnReadCount(userid, "update");
			count = Integer.parseInt(weiboCount);
		}catch(Exception e){
			count = -1;
		}
	}else if(navtype == 4){
		//邮件
		HashMap<String, String> params = new HashMap<String, String>();
		params.put("resourceid", resourceid);
		params.put("status", "0");
		params.put("folderid", "0");
		try{
			List<String> mailInfo = SocialIMService.getMailInfo(params);
			count = Integer.parseInt(mailInfo.get(0));
		}catch(Exception e){
			count = -1;
		}
	}
	
	out.print(count);
%>