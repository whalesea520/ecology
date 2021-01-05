
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.system.code.*"%>
<%@ page import="weaver.worktask.request.RequestShare"%>
<%@ page import="weaver.worktask.request.WorkplanCreateByRequest"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.system.SysWFLMonitor,java.text.*,java.util.*" %>
<%@ page import="weaver.sms.SMSSaveAndSend" %>
<%@ page import="weaver.system.SystemComInfo" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="requestManager" class="weaver.worktask.request.RequestManager" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WfForceOver" class="weaver.workflow.workflow.WfForceOver" scope="page"/>
<jsp:useBean id="taskManager" class="weaver.worktask.request.TaskManager" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%!
private void sendRemindSms(String taskcontent, int creater, String mobile, int reciveid, int requestid){
    try{
        taskcontent = Util.toExcelData(taskcontent);
        SMSSaveAndSend smsSaveAndSend = new SMSSaveAndSend();
        smsSaveAndSend.reset();
        smsSaveAndSend.setMessage(taskcontent);
        smsSaveAndSend.setRechrmnumber(mobile);
        smsSaveAndSend.setReccrmnumber("");
        smsSaveAndSend.setCustomernumber("");

        smsSaveAndSend.setRechrmids("" + reciveid);
        smsSaveAndSend.setReccrmids("");
        smsSaveAndSend.setSendnumber("");
        smsSaveAndSend.setRequestid(requestid);
        smsSaveAndSend.setUserid(creater);
        smsSaveAndSend.setUsertype("1");
        smsSaveAndSend.send();
    }catch(Exception e){e.printStackTrace();}
}

private void sendRemindMail(String mailtoaddress, String mailobject, String mailrequestname){
    try{
        mailobject = Util.toExcelData(mailobject);
        mailrequestname = Util.toExcelData(mailrequestname);
        //mailtoaddress = mailtoaddress.substring(0, mailtoaddress.length()-1);
        SendMail sm = new SendMail();
        SystemComInfo systemComInfo = new SystemComInfo();
        String defmailserver = systemComInfo.getDefmailserver();
        String defneedauth = systemComInfo.getDefneedauth();
        String defmailuser = systemComInfo.getDefmailuser();
        String defmailpassword = systemComInfo.getDefmailpassword();
        String defmailfrom = systemComInfo.getDefmailfrom();
        sm.setMailServer(defmailserver);
        if(defneedauth.equals("1")){
           sm.setNeedauthsend(true);
           sm.setUsername(defmailuser);
           sm.setPassword(defmailpassword);
        }else{
           sm.setNeedauthsend(false);
        }
        //mailobject邮件标题，mailrequestname邮件正文
        sm.sendhtml(defmailfrom, mailtoaddress, null, null, mailobject, mailrequestname, 3, "3");
    }catch(Exception e){
        e.printStackTrace();
    }
}
%>
<%

String sql = "";
FileUpload fu = new FileUpload(request);
int isRefash = Util.getIntValue(fu.getParameter("isRefash"), 0);
String years = Util.null2String(fu.getParameter("years"));
String months = Util.null2String(fu.getParameter("months"));
String quarters = Util.null2String(fu.getParameter("quarters"));
String weeks = Util.null2String(fu.getParameter("weeks"));
String days = Util.null2String(fu.getParameter("days"));
String objId = Util.null2String((String)SessionOper.getAttribute(session,"hrm.objId"));
String type = Util.null2String(fu.getParameter("type")); //周期
int type_d = Util.getIntValue((String)SessionOper.getAttribute(session,"hrm.type_d"), 0); //计划所有者类型
String objName = Util.null2String((String)SessionOper.getAttribute(session,"hrm.objName"));
String operationType = Util.null2String(fu.getParameter("operationType"));
int wtid = Util.getIntValue(fu.getParameter("wtid"), 0);
int worktaskStatus = Util.getIntValue(fu.getParameter("worktaskStatus"), 0);
int isCreate = Util.getIntValue(fu.getParameter("isCreate"), 0);
int isfromleft = Util.getIntValue(fu.getParameter("isfromleft"), 0);
String functionPage = Util.null2String(fu.getParameter("functionPage"));
if("multisave".equalsIgnoreCase(operationType)){
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setSrc("multisave");
	requestManager.setUser(user);
	boolean flag = requestManager.saveMultiRequestInfo();

	response.sendRedirect(functionPage+"?wtid="+wtid+"&worktaskStatus="+worktaskStatus+"&type="+type+"&type_d="+type_d+"&objId="+objId+"&years="+years+"&weeks="+weeks+"&months="+months+"&quarters="+quarters+"&days="+days+"&isfromleft="+isfromleft);
}else if("multidelete".equalsIgnoreCase(operationType)){
	String requestids = "";
	String[] requestids_del = fu.getParameterValues("checktask2");
	if(requestids_del != null){
		for(int i=0; i<requestids_del.length; i++){
			int requestid_del = Util.getIntValue(requestids_del[i], 0);
			requestids += (requestid_del + ",");
		}
		requestManager.setFu(fu);
		requestManager.setIsCreate(1);
		requestManager.setWtid(wtid);//
		requestManager.setSrc("multidelete");
		requestManager.setUser(user);
		boolean flag = requestManager.deleteMultiRequest(requestids);
	}
	response.sendRedirect(functionPage+"?wtid="+wtid+"&worktaskStatus="+worktaskStatus+"&type="+type+"&type_d="+type_d+"&objId="+objId+"&years="+years+"&weeks="+weeks+"&months="+months+"&quarters="+quarters+"&days="+days+"&isfromleft="+isfromleft);
}else if("multiSubmit".equalsIgnoreCase(operationType)){
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setSrc("multisubmit");
	requestManager.setUser(user);
	boolean flag = requestManager.submitMultiRequest();
	response.sendRedirect(functionPage+"?wtid="+wtid+"&worktaskStatus="+worktaskStatus+"&type="+type+"&type_d="+type_d+"&objId="+objId+"&years="+years+"&weeks="+weeks+"&months="+months+"&quarters="+quarters+"&days="+days+"&isfromleft="+isfromleft);
}else if("multiApprove".equalsIgnoreCase(operationType)){
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setSrc("multiapprove");
	requestManager.setUser(user);
	boolean flag = requestManager.approveMultiRequest();

	response.sendRedirect(functionPage+"?wtid="+wtid+"&worktaskStatus="+worktaskStatus+"&type="+type+"&type_d="+type_d+"&objId="+objId+"&years="+years+"&weeks="+weeks+"&months="+months+"&quarters="+quarters+"&days="+days+"&isfromleft="+isfromleft);
}else if("multiBack".equalsIgnoreCase(operationType)){
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setSrc("multiback");
	requestManager.setUser(user);
	boolean flag = requestManager.approveMultiRequest();

	response.sendRedirect(functionPage+"?wtid="+wtid+"&worktaskStatus="+worktaskStatus+"&type="+type+"&type_d="+type_d+"&objId="+objId+"&years="+years+"&weeks="+weeks+"&months="+months+"&quarters="+quarters+"&days="+days+"&isfromleft="+isfromleft);
}else if("multiCancel".equalsIgnoreCase(operationType)){
	//JSP中操作：审批流程强制归档；JAVA操作：计划任务被取消
	ArrayList requestidsArr = new ArrayList();
	String[] requestid_adds = fu.getParameters("checktask2");
	String requestids = "";
	if(requestid_adds != null && requestid_adds.length >= 1){
		for(int i=0; i<requestid_adds.length; i++){
			int requestid_tmp = Util.getIntValue(requestid_adds[i], 0);
			if(requestid_tmp > 0){
				requestids += (","+requestid_tmp);
			}
		}
		rs.execute("select approverequest from worktask_requestbase where requestid in (0"+requestids+")");
		while(rs.next()){
			int approverequest = Util.getIntValue(rs.getString("approverequest"), 0);
			if(approverequest != 0){
				requestidsArr.add(""+approverequest);
			}
		}
		if(requestidsArr.size() > 0){
			WfForceOver.doForceOver(requestidsArr, request, response);
		}
		requestManager.setFu(fu);
		requestManager.setIsCreate(isCreate);
		requestManager.setWtid(wtid);//
		requestManager.setSrc("multicancel");
		requestManager.setUser(user);
		boolean flag = requestManager.approveMultiRequest();
	}
	response.sendRedirect(functionPage+"?wtid="+wtid+"&worktaskStatus="+worktaskStatus+"&type="+type+"&type_d="+type_d+"&objId="+objId+"&years="+years+"&weeks="+weeks+"&months="+months+"&quarters="+quarters+"&days="+days+"&isfromleft="+isfromleft);
}else if("multiExecute".equalsIgnoreCase(operationType)){
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setSrc("multiexecute");
	requestManager.setUser(user);
	boolean flag = requestManager.executeMultiRequest();

	response.sendRedirect(functionPage+"?wtid="+wtid+"&worktaskStatus="+worktaskStatus+"&type="+type+"&type_d="+type_d+"&objId="+objId+"&years="+years+"&weeks="+weeks+"&months="+months+"&quarters="+quarters+"&days="+days+"&isfromleft="+isfromleft);
}else if("multiCheck".equalsIgnoreCase(operationType)){
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setSrc("multicheck");
	requestManager.setUser(user);
	boolean flag = requestManager.checkMultiRequest();

	response.sendRedirect(functionPage+"?wtid="+wtid+"&worktaskStatus="+worktaskStatus+"&type="+type+"&type_d="+type_d+"&objId="+objId+"&years="+years+"&weeks="+weeks+"&months="+months+"&quarters="+quarters+"&days="+days+"&isfromleft="+isfromleft);
}else if("save".equalsIgnoreCase(operationType)){
	int requestid = 0;
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setTaskid(wtid);
	requestManager.setSrc("save");
	requestManager.setUser(user);
	if(isCreate == 0){
		requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
		requestManager.setRequestid(requestid);
	}
	boolean flag = requestManager.saveRequestInfo(0);
	requestid = requestManager.getRequestid();
	//response.sendRedirect("ViewWorktask.jsp?requestid="+requestid);
	//记录 保存日志
	taskManager.doSaveOperateLog(requestid+"",user.getUID()+"","1","");
	//获取 retasklistid 值，是否新建 关联任务
	String retasklistid = Util.null2String(fu.getParameter("retasklistid"));
	
	if(!"".equals(retasklistid)){
		if("0001".equals(retasklistid)){//001 代表 编辑任务保存
		   out.println("<script>try{parent.window.WorkTaskDetailRefresh();parent.window.taskListRefresh();parent.window.childEditTaskClose();}catch(e){window.location='/worktask/pages/worktaskoperate.jsp?wtid="+wtid+"&requestid="+requestid+"';}");
		}else{
		   out.println("<script>parent.window.taskListRefresh();parent.window.WorkTaskDetailRefresh();location.href=\"/worktask/pages/worktask.jsp?wtid="+wtid+"&tasklistid="+retasklistid+"&requestid="+requestid+"\";");
		}
	}else{
		//out.println("<script>location.href=\"/worktask/pages/worktask.jsp?wtid="+wtid+"&requestid="+requestid+"\";");
		out.println("<script>parent.window.taskListRefresh();parent.window.workTaskDetailPageReload('/worktask/pages/worktask.jsp?wtid="+wtid+"&requestid="+requestid+"');");
	}
	if(isRefash == 0){
		//out.println("try{window.opener.location.reload();}catch(e){}");
	}
	out.println("</script>");
	return;
}else if("Submit".equalsIgnoreCase(operationType)){
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setTaskid(wtid);
	requestManager.setSrc("submit");
	requestManager.setUser(user);
	int requestid = 0;
	RequestShare requestShare = null;
	if(isCreate == 0){
		requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
		requestManager.setRequestid(requestid);
		boolean flag = requestManager.saveRequestInfo(0);
	}else{
		boolean flag = requestManager.saveRequestInfo(0);
		requestid = requestManager.getRequestid();
		requestShare = new RequestShare();
		requestShare.setWorktaskStatus(1);
		requestShare.setWtid(wtid);
		requestShare.setRequestid(requestid);
		requestShare.setRequestShare();
	}
	String ccuser = "";
	int creater = 0;
	String taskcontent = "";
	int approverequest = 0;//可能是被退回的提交，判断是否已挂有审批流程，如果有，则执行“提交审批(submitapprove)”操作
	
	
	//如果设置提交提醒,则需插入计划开始日期和时间
	if(Util.getIntValue(fu.getParameter("issubmitremind"), 0) == 1){
		//Calendar calendar = Calendar.getInstance();
		//calendar.set(Calendar.MINUTE, calendar.get(Calendar.MINUTE)+4);
		//Date date = calendar.getTime();
		//SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		//String planstartdate = format.format(date);
		//format = new SimpleDateFormat("HH:mm");
		//String planstarttime = format.format(date);
		//插入计划任务开始日期和时间  比当前时间晚4分钟 ，并设置提醒时间间隔
		//rs.execute("update worktask_requestbase set beforestart='1',beforestarttime='4',beforestarttype='2',beforestartper='10',planstartdate='"+planstartdate+"',planstarttime='"+planstarttime+"' where requestid="+requestid);
		//QC312386修改,在选择提交提醒的时候立即发送提醒
		String getTaskDetailSql = "select r.*, b.* from worktask_requestbase r, worktask_base b where r.taskid=b.id  and r.requestid="+requestid;
		rs.execute(getTaskDetailSql);
		if(rs.next()){
			boolean startNull = false;
			String liableperson = Util.null2String(rs.getString("liableperson"));
			String coadjutant = Util.null2String(rs.getString("coadjutant"));
			String name = Util.null2String(rs.getString("name"));
			String planstartdate = Util.null2String(rs.getString("planstartdate"));
            String planstarttime = Util.null2String(rs.getString("planstarttime"));
			String receiveids = liableperson;
			String taskName = Util.null2String(rs.getString("taskname"));//计划标题
			taskcontent = Util.null2String(rs.getString("taskcontent"));//计划内容
			if("".equals(planstarttime)){
                startNull = true;
            }
			//任务清单责任人
            StringBuffer listSb = new StringBuffer("");
            String listLiablePersons = "";
            rs3.execute("select userid  from worktask_list a inner join worktask_list_liableperson b on a.id = b.wtlistid where requestid='"+requestid+"'");
            while(rs3.next()){
                listSb.append(rs3.getString("userid")).append(",");
            }
            if(listSb.length()>0){
                listLiablePersons = listSb.substring(0, listSb.length()-1);
            }
			//添加任务责任人
            if(!"".equals(listLiablePersons)){//责任人不可能为空，协助人可能
                receiveids += (","+listLiablePersons);
            }
            if(!"".equals(coadjutant)){//责任人不可能为空，协助人可能
                receiveids += (","+coadjutant);
            }
			if(Util.getIntValue(rs.getString("remindtype"), 0) == 1){
                try{
                    taskcontent = taskcontent.substring(0, 30) + "...";
                }catch(Exception e){}
                rs2.execute("select * from hrmresource where id in ("+receiveids+")");
                while(rs2.next()){
                    int id = Util.getIntValue(rs2.getString("id"), 0);
                    String mobile = resourceComInfo.getMobile(""+id);
                    if(!"".equals(mobile.trim())){
                        int language = Util.getIntValue(rs2.getString("systemlanguage"), 7);
                        String content = SystemEnv.getHtmlLabelNames("84535,16539", language)+" "+name + ":" + taskName;
                        sendRemindSms(content, creater, mobile, id, requestid);
                    }
                }
            }else{
                try{
                    taskcontent = taskcontent.substring(0, 60) + "...";
                }catch(Exception e){}
                rs2.execute("select * from hrmresource where id in ("+receiveids+")");
                while(rs2.next()){
                    int language = Util.getIntValue(rs2.getString("systemlanguage"), 7);
                    String email = Util.null2String(rs2.getString("email"));
                    if(!"".equals(email.trim())){
                        String mailobject = SystemEnv.getHtmlLabelName(16539, language) + ":" +taskName+ SystemEnv.getHtmlLabelName(15148, language) + "(" + name + ")";
                        String mailrequestname = SystemEnv.getHtmlLabelNames("84535,16539", language)+" "+name + ":" + taskcontent;
                        sendRemindMail(email, mailobject, mailrequestname);
                    }
                }
            }
		}
		
	}
		
	rs.execute("select ccuser, taskcontent, creater, approverequest from worktask_requestbase where requestid="+requestid);
	if(rs.next()){
		ccuser = Util.null2String(rs.getString("ccuser"));
		taskcontent = Util.null2String(rs.getString("taskcontent"));
		creater = Util.getIntValue(rs.getString("creater"));
		approverequest = Util.getIntValue(rs.getString("approverequest"), 0);
	}
	requestShare = new RequestShare();
	requestShare.setWtid(wtid);
	requestShare.setRequestid(requestid);

	int approvewf_tmp = 0;
	String taskname = "";
	int workplantypeid = 0;
	int autotoplan = 0;
	int useapprovewf = 0;
	//System.out.println(wtid);
	rs.execute("select * from worktask_base where id="+wtid);
	if(rs.next()){
		useapprovewf = Util.getIntValue(rs.getString("useapprovewf"), 0);
		approvewf_tmp = Util.getIntValue(rs.getString("approvewf"), 0);
		taskname = Util.null2String(rs.getString("name"));
		autotoplan = Util.getIntValue(rs.getString("autotoplan"), 0);
		workplantypeid = Util.getIntValue(rs.getString("workplantypeid"), 0);
	}
	if(useapprovewf==1 && approvewf_tmp != 0){
		requestManager.setApprovewf(approvewf_tmp);
		requestManager.setTaskname(taskname);
		if(approverequest <= 0){
			requestManager.submitRequest();
		}else{
			requestManager.setSrc("submitapprove");
			requestManager.approveRequest(approverequest);
			rs.execute("update worktask_requestbase set status=2 where requestid="+requestid+" and taskid="+wtid);
		}
		requestShare.setWorktaskStatus(2);
	}else{
		rs.execute("update worktask_requestbase set status=6 where requestid="+requestid+" and taskid="+wtid);
		requestShare.setWorktaskStatus(6);
		requestManager.createSysRemindWF(ccuser, creater, taskcontent);
		if(autotoplan==1 && workplantypeid>=0){
			WorkplanCreateByRequest workplanCreateByRequest = new WorkplanCreateByRequest();
			workplanCreateByRequest.setTaskid(wtid);
			workplanCreateByRequest.setRequestid(requestid);
			workplanCreateByRequest.setWorkplantypeid(workplantypeid);
			workplanCreateByRequest.createWorkplan();
		}
	}
	requestShare.setWtid(wtid);
	requestShare.setRequestid(requestid);
	requestShare.setRequestShare();
	//response.sendRedirect("ViewWorktask.jsp?requestid="+requestid);
	//记录 提交日志
	taskManager.doSaveOperateLogForSubmit(requestid+"",user.getUID()+"");
	//获取 retasklistid 值，是否新建 关联任务
	String retasklistid = Util.null2String(fu.getParameter("retasklistid"));
	
	if(!"".equals(retasklistid)){
	    out.println("<script>parent.window.taskListRefresh();parent.window.WorkTaskDetailRefresh();parent.window.childEditTaskClose();");
	}else{
		out.println("<script>parent.window.taskListRefresh();location.href=\"/worktask/pages/worktaskoperate.jsp?wtid="+wtid+"&requestid="+requestid+"\";");
	}
	if(isRefash == 0){
		out.println("try{window.opener.location.reload();}catch(e){}");
	}
	out.println("</script>");
	return;
}else if("delete".equalsIgnoreCase(operationType)){
	int requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
	requestManager.setFu(fu);
	requestManager.setIsCreate(0);
	requestManager.setWtid(wtid);//
	requestManager.setSrc("multidelete");
	requestManager.setUser(user);
	boolean flag = requestManager.deleteMultiRequest(""+requestid);
	//记录 删除日志
	taskManager.doSaveOperateLog(requestid+"",user.getUID()+"","11","");
	//获取 retasklistid 值，是否新建 关联任务
	String retasklistid = Util.null2String(fu.getParameter("retasklistid"));
	
	if(!"".equals(retasklistid)){
		out.println("<script>window.top.Dialog.alert(\""+SystemEnv.getHtmlLabelName(20461, user.getLanguage())+"\");try{parent.window.taskListRefresh();parent.window.WorkTaskDetailRefresh();parent.window.childEditTaskClose();}catch(e){}");
	}else{
		out.println("<script>window.top.Dialog.alert(\""+SystemEnv.getHtmlLabelName(20461, user.getLanguage())+"\");try{parent.window.taskListRefresh();parent.window.workTaskDetailCloseForDel();}catch(e){}");
	}
	out.println("</script>");
	return;
}else if("cancel".equalsIgnoreCase(operationType)){
	int requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
	ArrayList requestidsArr = new ArrayList();
	rs.execute("select approverequest from worktask_requestbase where requestid ="+requestid);
	if(rs.next()){
		int approverequest = Util.getIntValue(rs.getString("approverequest"), 0);
		if(approverequest != 0){
			requestidsArr.add(""+approverequest);
			WfForceOver.doForceOver(requestidsArr, request, response);
		}
	}

	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setSrc("cancel");
	requestManager.setUser(user);
	requestManager.setTaskid(wtid);
	requestManager.setRequestid(requestid);
	requestManager.cancelRequest();
	//记录 取消日志
	taskManager.doSaveOperateLog(requestid+"",user.getUID()+"","2","4","4","");
	//获取 retasklistid 值，是否新建 关联任务
	String retasklistid = Util.null2String(fu.getParameter("retasklistid"));
	if(!"".equals(retasklistid)){
		out.println("<script>window.top.Dialog.alert(\""+SystemEnv.getHtmlLabelNames("201,15242",user.getLanguage())+"！\");try{parent.window.taskListRefresh();parent.window.WorkTaskDetailRefresh();parent.window.childEditTaskClose();}catch(e){}");
	}else{
		out.println("<script>window.top.Dialog.alert(\""+SystemEnv.getHtmlLabelNames("201,15242",user.getLanguage())+"！\");try{parent.window.taskListRefresh();parent.window.workTaskDetailCloseForDel();}catch(e){}");
	}
	
	out.println("</script>");
	return;
}else if("approve".equalsIgnoreCase(operationType)){
	int approverequest = Util.getIntValue(fu.getParameter("approverequest"), 0);
	int requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setTaskid(wtid);
	requestManager.setRequestid(requestid);
	requestManager.setSrc("approve");
	requestManager.setUser(user);
	requestManager.approveRequest(approverequest);
	//记录 批准日志
	taskManager.doSaveOperateLog(requestid+"",user.getUID()+"","2","6","6","");
	//获取 retasklistid 值，是否新建 关联任务
	String retasklistid = Util.null2String(fu.getParameter("retasklistid"));
	if(!"".equals(retasklistid)){
		out.println("<script>try{parent.window.WorkTaskDetailRefresh();parent.window.taskListRefresh();parent.window.childEditTaskClose();}catch(e){}");
	}else{
		out.println("<script>try{parent.window.taskListRefresh();}catch(e){}");
		out.println("location.href=\"/worktask/pages/worktaskoperate.jsp?wtid="+wtid+"&requestid="+requestid+"\";");
	}
	
	out.println("</script>");
	return;
}else if("back".equalsIgnoreCase(operationType)){
	int approverequest = Util.getIntValue(fu.getParameter("approverequest"), 0);
	int requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setTaskid(wtid);
	requestManager.setRequestid(requestid);
	requestManager.setSrc("back");
	requestManager.setUser(user);
	requestManager.approveRequest(approverequest);
	//记录 退回日志
	taskManager.doSaveOperateLog(requestid+"",user.getUID()+"","2","3","3","");
	//获取 retasklistid 值，是否新建 关联任务
	String retasklistid = Util.null2String(fu.getParameter("retasklistid"));
	if(!"".equals(retasklistid)){
		out.println("<script>try{parent.window.WorkTaskDetailRefresh();parent.window.taskListRefresh();parent.window.childEditTaskClose();}catch(e){}");
	}else{
		out.println("<script>try{parent.window.taskListRefresh();window.location.reload();}catch(e){}");
	}
	
	out.println("window.close();</script>");
	return;
}else if("Execute".equalsIgnoreCase(operationType)){

	int operatorid = Util.getIntValue(fu.getParameter("operatorid"), 0);
	int requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
	//记录 完成 执行 日志,放在 executeRequest 之前
	taskManager.doSaveOperateLogForExecute(requestid+"",user.getUID()+"");
	Hashtable field_hs = null;
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setSrc("execute");
	requestManager.setUser(user);
	requestManager.setOperatorid(operatorid);
	requestManager.setTaskid(wtid);
	requestManager.setRequestid(requestid);
	requestManager.executeRequest(field_hs);
	//获取 retasklistid 值，是否新建 关联任务
	String retasklistid = Util.null2String(fu.getParameter("retasklistid"));

	if(!"".equals(retasklistid)){
		out.println("<script>try{parent.window.WorkTaskDetailRefresh();parent.window.taskListRefresh();parent.window.childEditTaskClose();}catch(e){}");
	}else{
		out.println("<script>try{parent.window.taskListRefresh();window.opener.location.reload();}catch(e){}");
		out.println("location.href=\"/worktask/pages/worktaskoperate.jsp?wtid="+wtid+"&requestid="+requestid+"\";");
	}

	out.println("</script>");
}else if("Check".equalsIgnoreCase(operationType)){
	int operatorid = Util.getIntValue(fu.getParameter("operatorid"), 0);
	int requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
	Hashtable field_hs = null;
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setSrc("check");
	requestManager.setUser(user);
	requestManager.setOperatorid(operatorid);
	requestManager.setTaskid(wtid);
	requestManager.setRequestid(requestid);
	requestManager.checkRequest(field_hs);
	//记录 验证 日志,放在 executeRequest 之前
	taskManager.doSaveOperateLog(requestid+"",user.getUID()+"","9","10","10","");
	//获取 retasklistid 值，是否新建 关联任务
	String retasklistid = Util.null2String(fu.getParameter("retasklistid"));
	if(!"".equals(retasklistid)){
		out.println("<script>try{parent.window.WorkTaskDetailRefresh();parent.window.taskListRefresh();parent.window.childEditTaskClose();}catch(e){}");
	}else{
		out.println("<script>try{parent.window.taskListRefresh();}catch(e){}");
		out.println("location.href=\"/worktask/pages/worktaskoperate.jsp?wtid="+wtid+"&requestid="+requestid+"\";");
	}
	out.println("</script>");
}else if("savetemplate".equalsIgnoreCase(operationType)){
	int requestid = 0;
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setTaskid(wtid);
	requestManager.setSrc("save");
	requestManager.setUser(user);
	if(isCreate == 0){
		requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
		requestManager.setRequestid(requestid);
	}
	boolean flag = requestManager.saveRequestInfo(0);
	requestid = requestManager.getRequestid();
	out.println("<script>location.href=\"ViewWorktaskTemplate.jsp?requestid="+requestid+"\";");
	if(isRefash == 0){
		out.println("try{window.opener.location.reload();}catch(e){}");
	}
	out.println("</script>");
	return;
}else if("multideletetemplate".equalsIgnoreCase(operationType)){//模板批量删除，无需删除审批工作流程
	String requestids = "";
	String[] requestids_del = fu.getParameterValues("checktask2");
	if(requestids_del != null){
		for(int i=0; i<requestids_del.length; i++){
			int requestid_del = Util.getIntValue(requestids_del[i], 0);
			requestids += (requestid_del + ",");
		}
		requestids = requestids.substring(0, requestids.length()-1);
		sql = "update worktask_requestbase set deleted=1 where requestid in ( "+requestids+" ) ";
		//System.out.println(sql);
		rs.execute(sql);
	}
	String taskcontent = Util.null2String(fu.getParameter("taskcontent"));
	int wakemode = Util.getIntValue(fu.getParameter("wakemode"), 0);
	response.sendRedirect("WorktaskTemplateFrame.jsp?wtid="+wtid+"&wakemode="+wakemode+"&taskcontent="+taskcontent);
	return;
}else if("deletetemplate".equalsIgnoreCase(operationType)){//模板单个删除，无需删除审批工作流程
	int requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
	sql = "update worktask_requestbase set deleted=1 where requestid in ( "+requestid+" ) ";
	//System.out.println(sql);
	rs.execute(sql);
	out.println("<script>window.top.Dialog.alert(\""+SystemEnv.getHtmlLabelName(20461, user.getLanguage())+"\");try{window.opener.location.reload();}catch(e){}");
	out.println("window.close();</script>");
	return;
}else if("Remark".equalsIgnoreCase(operationType)){
	int operatorid = Util.getIntValue(fu.getParameter("operatorid"), 0);
	int requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
	Hashtable field_hs = null;
	requestManager.setFu(fu);
	requestManager.setIsCreate(isCreate);
	requestManager.setWtid(wtid);//
	requestManager.setSrc("remark");
	requestManager.setUser(user);
	requestManager.setOperatorid(operatorid);
	requestManager.setTaskid(wtid);
	requestManager.setRequestid(requestid);
	requestManager.remarkRequest();

	out.println("<script>");
	out.println("location.href=\"ViewWorktask.jsp?operatorid="+operatorid+"\";");
	out.println("</script>");
}
%>