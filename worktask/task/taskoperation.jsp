
<%@ page language="java" contentType="application/json;charset=UTF-8" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.FileUpload" %>
<jsp:useBean id="taskManager" class="weaver.worktask.request.TaskManager" scope="page"/>
<jsp:useBean id="requestManager" class="weaver.worktask.request.RequestManager" scope="page" />

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
out.clearBuffer();
User user = HrmUserVarify.getUser (request , response) ;

//执行哪个方法
String method = Util.null2String(request.getParameter("method"));
//任务requestids
String requestids = Util.null2String(request.getParameter("requestids"));
FileUpload fu = new FileUpload(request);

try{
    if("gettasklistdata".equals(method)){//获取任务列表
    	
    	//任务类型
    	String tasktype = Util.null2String(request.getParameter("tasktype"));
    	//任务对象
    	String taskuser = Util.null2String(request.getParameter("taskuser"));
    	//任务状态
    	String taskstatus = Util.null2String(request.getParameter("taskstatus"));
    	//排序字段
    	String orderstyle = Util.null2String(request.getParameter("orderstyle"));
    	//搜索 任务名称 taskname
    	String taskname = Util.null2String(request.getParameter("taskname"));
    	//System.out.println("taskname=========="+taskname);
    	String tasklist = taskManager.getTaskListData(tasktype,taskstatus,taskuser, orderstyle,rs, request);
    	out.println(tasklist);
    }
    
    
    if("viewtask".equals(method)){//查看任务
    	//任务requestid
    	String requestid = Util.null2String(request.getParameter("requestid"));
	   	if(!"".equals(requestid) && requestid != null){
	   		taskManager.doSaveOperateLogForView(requestid,user.getUID()+"");
	   		
	   		//確認當前 任务是否 是 @我的，如果是前端 需要减一
	   		rs.execute("select * from worktask_atinfo where userid="+user.getUID()+" and requestid="+requestid);
	   		String atid = "";
	   		if(rs.next()){
	   			atid = rs.getString("id");
	   			if(!"".equals(atid)){
	   				rs.execute("delete from worktask_atinfo where id='"+atid+"'");
	   			    out.println("14");//标志需要删除 前端 @me 减一
	   			}
	   		}else{
			  out.println("1");
	   		}
	   	}
    }
    
   if("addattention".equals(method)){//添加关注
    	
    	//任务requestid
    	String requestid = Util.null2String(request.getParameter("requestid"));
    	if(!"".equals(requestid) && requestid != null){
    		taskManager.doSaveOperateLog(requestid,user.getUID()+"","17","");
    		rs.execute("insert into worktask_attention(userid,requestid) values("+user.getUID()+","+requestid+")");
    		out.println("1");
    	}
    }
   
    if("delattention".equals(method)){//取消关注
   	
	   	//任务requestid
	   	String requestid = Util.null2String(request.getParameter("requestid"));
	   	if(!"".equals(requestid) && requestid != null){
	   		taskManager.doSaveOperateLog(requestid,user.getUID()+"","18","");
	   		rs.execute("delete from worktask_attention where userid="+user.getUID()+" and requestid="+requestid);
	   		out.println("1");
	   	}
    }
    
    if("deltask".equals(method)){//删除任务
	   	
	   	if(!"".equals(requestids) && requestids != null){
	   		requestManager.setFu(fu);
			requestManager.setIsCreate(0);
			requestManager.setWtid(0);//默认为0
			requestManager.setSrc("multidelete");
			requestManager.setUser(user);
			taskManager.doSaveOperateLog(requestids,user.getUID()+"","11","");
			boolean flag = requestManager.deleteMultiRequest(requestids);
			if(flag){
				out.println("1");
			}
	   	}
    }
    
    if("submittask".equals(method)){//提交任务
	   	if(!"".equals(requestids) && requestids != null){
	   		requestManager.setFu(fu);
	   		requestManager.setIsCreate(0);//非创建
	   		requestManager.setWtid(0);//
	   		requestManager.setSrc("multisubmit");
	   		requestManager.setUser(user);
	   		taskManager.doSaveOperateLogForSubmit(requestids,user.getUID()+"");
	   		boolean flag = requestManager.submitMultiRequest(requestids);
			if(flag){
				out.println("1");
			}
	   	}
    }
    
    if("approvetask".equals(method)){//批准任务
	   	if(!"".equals(requestids) && requestids != null){
	   		requestManager.setFu(fu);
	   		requestManager.setIsCreate(0);//非创建
	   		requestManager.setWtid(0);//
	   		requestManager.setSrc("multiapprove");
	   		requestManager.setUser(user);
	   		taskManager.doSaveOperateLog(requestids,user.getUID()+"","2","6","6","");
	   		boolean flag = requestManager.approveMultiRequest(requestids);
			if(flag){
				out.println("1");
			}
	   	}
    }
    
    if("rejecttask".equals(method)){//退回任务
	   	if(!"".equals(requestids) && requestids != null){
	   		requestManager.setFu(fu);
	   		requestManager.setIsCreate(0);//非创建
	   		requestManager.setWtid(0);//
	   		requestManager.setSrc("multiback");
	   		requestManager.setUser(user);
	   		taskManager.doSaveOperateLog(requestids,user.getUID()+"","2","3","3","");
	   		boolean flag = requestManager.approveMultiRequest(requestids);
			if(flag){
				out.println("1");
			}
	   	}
    }
    
    if("canceltask".equals(method)){//取消任务
	   	if(!"".equals(requestids) && requestids != null){
	   		requestManager.setFu(fu);
	   		requestManager.setIsCreate(0);//非创建
	   		requestManager.setWtid(0);//
	   		requestManager.setSrc("multicancel");
	   		requestManager.setUser(user);
	   		taskManager.doSaveOperateLog(requestids,user.getUID()+"","2","4","4","");
	   		boolean flag = requestManager.approveMultiRequest(requestids);
			if(flag){
				out.println("1");
			}
	   	}
    }
}catch(Exception e){
	out.println("0");
	//e.printStackTrace();
}



%>