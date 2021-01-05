<%@page import="weaver.proj.util.PrjGenWfRunner"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.util.UUID"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="ProjTypeUtil" class="weaver.proj.ProjTypeUtil" scope="page" />
<jsp:useBean id="sysWF" class="weaver.system.SysCreateWF" scope="page"/>
<jsp:useBean id="PrjFieldManager" class="weaver.proj.util.PrjFieldManager" scope="page"/>
<jsp:useBean id="ApproveParameter" class="weaver.workflow.request.ApproveParameter" scope="session"/>
<jsp:useBean id="PrjWfUtil" class="weaver.proj.util.PrjWfUtil" scope="page" />
<%

User user=HrmUserVarify.getUser(request, response);
if(user==null){
	return;
}
JSONObject jsonInfo=new JSONObject();

String method = request.getParameter("method");
String id = request.getParameter("id");
String type = Util.fromScreen(request.getParameter("type"),user.getLanguage());
String desc = Util.fromScreen(request.getParameter("desc"),user.getLanguage());
String wfid = request.getParameter("approvewfid");
String typeCode = Util.null2String(request.getParameter("txtTypeCode"));
String insertWorkPlan = Util.null2String(request.getParameter("insertWorkPlan"));
String dsporder = ""+Util.getIntValue(request.getParameter("dsporder"),0);

String[] projTemplateStatusNew = Util.TokenizerString2(Util.null2String(request.getParameter("projTemplateStatusNew")),",");
String[] projTemplateStatusOld = Util.TokenizerString2(Util.null2String(request.getParameter("projTemplateStatusOld")),",");
String[] projTemplateIDs = Util.TokenizerString2(Util.null2String(request.getParameter("projTemplateIDs")),",");


if (method.equals("add")){
	char flag=2;
	String guid1=UUID.randomUUID().toString();
	RecordSet.executeProc("Prj_ProjectType_Insert",type+flag+desc+flag+wfid+flag+typeCode+flag+insertWorkPlan+flag+dsporder+flag+guid1);
	RecordSet.execute("select id from prj_projecttype where guid1='"+guid1+"' ");
	if(RecordSet.next()){
		String newid=Util.null2String( RecordSet.getString("id"));
		PrjFieldManager.syncDefinedFields(Util.getIntValue(newid,0));//同步通用字段信息
		jsonInfo.put("newid", newid);
	}

	ProjectTypeComInfo.removeProjectTypeCache();
	
	out.print(jsonInfo.toString());
}
else if (method.equals("edit")){
	char flag=2;
	RecordSet.executeProc("Prj_ProjectType_Update",id+flag+type+flag+desc+flag+typeCode+flag+wfid+flag+insertWorkPlan+flag+dsporder);


	String sql11="update prj_prjwfconf set isopen='0' where prjtype='"+id+"' and wfid not in("+Util.getIntValue( wfid,0)+")";
	RecordSet.executeSql(sql11);

	ProjectTypeComInfo.removeProjectTypeCache();
	
	out.print(jsonInfo.toString());

	
}
else if("approvetemplate".equalsIgnoreCase(method)){//模板审批
	
	String templetId=Util.null2String(request.getParameter("templetId"));
	String templeteStatusOld="1";
	if(Util.getIntValue(templetId,0)>0){
		rs.executeSql("select status from Prj_Template where id="+templetId);
		if(rs.next()){
			templeteStatusOld=rs.getString("status");
		}
	}

	projTemplateIDs=new String[]{templetId};
	projTemplateStatusOld=new String[]{templeteStatusOld};
	projTemplateStatusNew=new String[]{"1"};
	//=====================================================================
		//模板审批
		//added by hubo,20060226
		String sqlT = "";
		String sqlApprove = "";
		String status = "";
		int projTemplateWFID = 0;
		String projTemplateWFName = "";
		int projTemplateRequestID = 0;
		int formid=0;
		boolean isApprove = false;
		//项目模板是否需要审批
		sqlApprove = "SELECT t1.isNeedAppr,t1.wfid,t2.formid FROM ProjTemplateMaint t1 left outer join workflow_base t2 on t2.id=t1.wfid";
		rs.executeSql(sqlApprove);
		if(rs.next()){
			if(rs.getString("isNeedAppr").equals("1")){
				projTemplateWFID = rs.getInt("wfid");
				formid=rs.getInt("formid");
				isApprove = true;
			}
		}
		for(int i=0;i<projTemplateIDs.length;i++){
			//模板从草稿状态变为正常状态
			if((projTemplateStatusOld[i].equals("0") || projTemplateStatusOld[i].equals("3")) && projTemplateStatusNew[i].equals("1")){	
				if(isApprove){
					if(formid==152){//系统表单流程审批
						status = "2";
						//是退回草稿模板，同时提交退回流程
						if(projTemplateStatusOld[i].equals("3")){
							sqlApprove = "SELECT requestid FROM BillProjTemplateApprove WHERE projTemplateId="+projTemplateIDs[i]+" ORDER BY requestid DESC";
							rs.executeSql(sqlApprove);
							if(rs.next()){
								flowNextNode(rs.getInt("requestid"),user,request,response);
							}
						}else{//如果不是退回草稿模板，触发新的审批流程
							sqlApprove = "SELECT templetName FROM Prj_Template WHERE id="+Util.getIntValue(projTemplateIDs[i])+"";
							rs.executeSql(sqlApprove);
							if(rs.next()){
								projTemplateWFName = Util.null2String(rs.getString("templetName"));
							}
							projTemplateWFName = SystemEnv.getHtmlLabelName(18392,user.getLanguage())+":"+projTemplateWFName;
							requestM("submit","1",Util.getIntValue(projTemplateIDs[i]),projTemplateWFID,"0",projTemplateWFName,user,request,response);
						}
					}else{//自定义表单流程审批
						try{
							String sql11 = "SELECT templetName FROM Prj_Template WHERE id="+Util.getIntValue(projTemplateIDs[i])+"";
							rs.executeSql(sql11);
							if(rs.next()){
								projTemplateWFName = Util.null2String(rs.getString("templetName"));
							}
							String requestname=SystemEnv.getHtmlLabelName(18392,user.getLanguage())+":"+projTemplateWFName;
							String xmmb= projTemplateIDs[i];
							
							JSONObject wfObj= PrjWfUtil.getPrjwfInfo(""+projTemplateWFID, "3");
							if(wfObj!=null&& wfObj.length()>0){
								String tmpsql = "update Prj_Template set status ='2' where id = "+ xmmb;
								RecordSet.executeSql(tmpsql);
								JSONObject fieldInfo=new JSONObject();
								fieldInfo.put(wfObj.getString("xmmbname"),xmmb );
								new Thread( new PrjGenWfRunner(projTemplateWFID,"3",requestname,user,fieldInfo)).start();
							}
							
						}catch(Exception e){
							
						}
					}
					
					
				}else{
					status = "1";
					sqlT = "UPDATE Prj_Template SET status='"+status+"' WHERE id="+projTemplateIDs[i]+"";
					RecordSet.executeSql(sqlT);
				}
			}else{
				status = projTemplateStatusNew[i];
				sqlT = "UPDATE Prj_Template SET status='"+status+"' WHERE id="+projTemplateIDs[i]+"";
				RecordSet.executeSql(sqlT);
			}
		}
		//=====================================================================
	
}




else if (method.equals("delete")){
    //modify by dongping for TD694
	String referenced = "" ;
    RecordSet.executeSql("SELECT count(id) FROM Prj_ProjectInfo where prjtype = "+id);
    if (RecordSet.next()) {
        if (!RecordSet.getString(1).equals("0"))
            referenced = "yes" ;
    }
    
    if (referenced.equals("yes")) {
       response.sendRedirect("/proj/Maint/EditProjectType.jsp?id="+id+"&referenced="+referenced); 
       return ;
	} else {
	    RecordSet.executeProc("Prj_ProjectType_Delete",id);
	}
	
	ProjectTypeComInfo.removeProjectTypeCache();

    //删除与此项目类型删除时相关的模板,任务,以及其它表
    RecordSet.executeSql("select id from Prj_Template where proTypeId="+id);
    while (RecordSet.next()){
        String templetId = RecordSet.getString(1);
        //删除任务表的相关数据
        RecordSet1.executeSql("delete Prj_TemplateTask where templetId="+templetId);
        //删除模板表本身的相关数据
        RecordSet1.executeSql("delete Prj_Template where id="+templetId);        
    }
    //删除该项目类型字段配置信息
    RecordSet.executeSql("delete from prjDefineField where prjtype="+id);
    
}else if (method.equals("batchdelete")){
	
	JSONArray referencedArr = new JSONArray() ;
	
	String ids = Util.null2String(request.getParameter("id"));
	String[] arr= Util.TokenizerString2(ids, ",");
	for(int i=0;i<arr.length;i++){
		String id1 = ""+Util.getIntValue( arr[i]);
		
		
	    RecordSet.executeSql("SELECT count(id) FROM Prj_ProjectInfo where prjtype = "+id1);
	    if (RecordSet.next()) {
	        if (!RecordSet.getString(1).equals("0")){
	        	referencedArr.put(ProjectTypeComInfo.getProjectTypename(""+id1));
	        	continue;
	        }
	    }
	    
		RecordSet.executeProc("Prj_ProjectType_Delete",id1);
	    
	  //删除与此项目类型删除时相关的模板,任务,以及其它表
	    RecordSet.executeSql("select id from Prj_Template where proTypeId="+id1);
	    while (RecordSet.next()){
	        String templetId = RecordSet.getString(1);
	        //删除任务表的相关数据
	        RecordSet1.executeSql("delete Prj_TemplateTask where templetId="+templetId);
	        //删除模板表本身的相关数据
	        RecordSet1.executeSql("delete Prj_Template where id="+templetId);        
	    }
		
	}
	
	ProjectTypeComInfo.removeProjectTypeCache();
	if(referencedArr.length()>0){
		jsonInfo.put("referenced", referencedArr);
	}
	
	out.print(jsonInfo.toString());
    
}else {
	//response.sendRedirect("/CRM/DBError.jsp?type=Unknown");
	return;
}

//response.sendRedirect("/proj/Maint/ListProjectType.jsp");
%>


<%!
void requestM(String src,String iscreate,int templateId,int workflowid,String nodetype,String requestname,User user,javax.servlet.http.HttpServletRequest request,javax.servlet.http.HttpServletResponse response) throws Exception{
	weaver.workflow.request.RequestManager requestManager = new weaver.workflow.request.RequestManager();
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	weaver.conn.RecordSet rs2 = new weaver.conn.RecordSet();

	String sql = "";
	int requestid = 0;
	String workflowtype = "";
	int isremark = 0;
	int formid = 0;
	int isbill = 0;
	int billid = 0;
	int nodeid = 0;
	String requestlevel = "";
	String messageType = "";
	String remark = "";

	isbill=1;
	formid = 152;
	billid = 152;
	sql = "SELECT nodeid FROM workflow_flownode WHERE workflowid="+workflowid+" AND nodetype='0'";
	rs.executeSql(sql);
	if(rs.next()){
		nodeid = rs.getInt("nodeid");
	}
	
	if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
		 response.sendRedirect("/notice/RequestError.jsp");
		 return ;
	}

	requestManager.setSrc(src) ;
	requestManager.setIscreate(iscreate) ;
	requestManager.setRequestid(requestid) ;
	requestManager.setWorkflowid(workflowid) ;
	requestManager.setWorkflowtype(workflowtype) ;
	requestManager.setIsremark(isremark) ;
	requestManager.setFormid(formid) ;
	requestManager.setIsbill(isbill) ;
	requestManager.setBillid(billid) ;
	requestManager.setNodeid(nodeid) ;
	requestManager.setNodetype(nodetype) ;
	requestManager.setRequestname(requestname) ;
	requestManager.setRequestlevel(requestlevel) ;
	requestManager.setRemark(remark) ;
	requestManager.setRequest(request) ;
	requestManager.setUser(user) ;
	//add by xhheng @ 2005/01/24 for 消息提醒 Request06
	requestManager.setMessageType(messageType) ;

	boolean savestatus = requestManager.saveRequestInfo() ;
	requestid = requestManager.getRequestid() ;
	if( !savestatus ) {
		 if( requestid != 0 ) {
			  response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1");
			  return ;
		 }
		 else {
			  response.sendRedirect("/workflow/request/RequestView.jsp?message=1");
			  return ;
		 }
	}

	boolean flowstatus = requestManager.flowNextNode() ;
	if( !flowstatus ) {
		 response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
		 return ;
	}

	boolean logstatus = requestManager.saveRequestLog() ;


	//创建时
	if(src.equals("submit")&&iscreate.equals("1")) {
		rs2.executeSql("UPDATE BillProjTemplateApprove SET projTemplateId="+templateId+" WHERE requestid="+requestid+"");
		if( requestManager.getNextNodetype().equals("3")) {
			rs2.executeSql("UPDATE Prj_Template SET status='1' WHERE id="+templateId+"");
			return;
		}else{
			rs2.executeSql("UPDATE Prj_Template SET status='2' WHERE id="+templateId+"");
			return;
		}
	}
}


void flowNextNode(int requestid,User user,javax.servlet.http.HttpServletRequest request,javax.servlet.http.HttpServletResponse response) throws Exception{
	weaver.workflow.request.RequestManager requestManager = new weaver.workflow.request.RequestManager();
	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
	weaver.conn.RecordSet rs2 = new weaver.conn.RecordSet();

	String sql = "";
	String src = "";
	String iscreate = "";
	int workflowid = 0;
	String workflowtype = "";
	int isremark = 0;
	int formid = 0;
	int isbill = 0;
	int billid = 0;
	int nodeid = 0;
	String nodetype = "";
	String requestname = "";
	String requestlevel = "";
	String messageType = "";
	String remark = "";

	src = "submit";
	iscreate = "0";
	sql = "SELECT * FROM workflow_requestbase WHERE requestid="+requestid+"";
	rs.executeSql(sql);
	if(rs.next()){
		workflowid = rs.getInt("workflowid");
		requestname = rs.getString("requestname");
		requestlevel = rs.getString("requestlevel");
		messageType = rs.getString("messageType");
		nodeid = rs.getInt("currentnodeid");
		nodetype = rs.getString("currentnodetype");
	}
	sql = "SELECT * FROM workflow_base WHERE id="+workflowid+"";
	rs.executeSql(sql);
	if(rs.next()){
		workflowtype = rs.getString("workflowtype");
		formid = rs.getInt("formid");
		isbill = rs.getInt("isbill");
		billid = formid;
	}

	if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
		response.sendRedirect("/notice/RequestError.jsp");
		return ;
	}

	requestManager.setSrc(src) ;
	requestManager.setIscreate(iscreate) ;
	requestManager.setRequestid(requestid) ;
	requestManager.setWorkflowid(workflowid) ;
	requestManager.setWorkflowtype(workflowtype) ;
	requestManager.setIsremark(isremark) ;
	requestManager.setFormid(formid) ;
	requestManager.setIsbill(isbill) ;
	requestManager.setBillid(billid) ;
	requestManager.setNodeid(nodeid) ;
	requestManager.setNodetype(nodetype) ;
	requestManager.setRequestname(requestname) ;
	requestManager.setRequestlevel(requestlevel) ;
	requestManager.setRemark(remark) ;
	requestManager.setRequest(request) ;
	requestManager.setUser(user) ;
	requestManager.setMessageType(messageType) ;

	boolean savestatus = requestManager.saveRequestInfo() ;
	requestid = requestManager.getRequestid() ;
	if( !savestatus ) {
		 if( requestid != 0 ) {
			  response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1");
			  return ;
		 }
		 else {
			  response.sendRedirect("/workflow/request/RequestView.jsp?message=1");
			  return ;
		 }
	}

	boolean flowstatus = requestManager.flowNextNode() ;
	if( !flowstatus ) {
		 response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
		 return ;
	}

	boolean logstatus = requestManager.saveRequestLog() ;

	rs.executeSql("SELECT projTemplateId FROM BillProjTemplateApprove WHERE requestid="+requestid+"");
	if(rs.next()){
		rs2.executeSql("UPDATE Prj_Template SET status='2' WHERE id="+rs.getInt("projTemplateId")+"");
	}
}
%>