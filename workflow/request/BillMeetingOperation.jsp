<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.workflow.WFManager"%>
<%@page import="weaver.meeting.defined.MeetingWFUtil"%>
<%@page import="weaver.meeting.defined.MeetingCreateWFUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util"%>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.workflow.request.RequestInfo" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="MeetingComInfo" class="weaver.meeting.Maint.MeetingComInfo" scope="page"/>
<jsp:useBean id="meetingLog" class="weaver.meeting.MeetingLog" scope="page" />
<%@ page import="weaver.file.FileUpload" %>
<%

FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();  
String src = Util.null2String(fu.getParameter("src"));
String iscreate = Util.null2String(fu.getParameter("iscreate"));
int requestid = Util.getIntValue(fu.getParameter("requestid"),-1);
int workflowid = Util.getIntValue(fu.getParameter("workflowid"),-1);
String workflowtype = Util.null2String(fu.getParameter("workflowtype"));
int isremark = Util.getIntValue(fu.getParameter("isremark"),-1);
int formid = Util.getIntValue(fu.getParameter("formid"),-1);
int isbill = Util.getIntValue(fu.getParameter("isbill"),-1);
int billid = Util.getIntValue(fu.getParameter("billid"),-1);
int nodeid = Util.getIntValue(fu.getParameter("nodeid"),-1);
String nodetype = Util.null2String(fu.getParameter("nodetype"));
String requestname = Util.fromScreen3(fu.getParameter("requestname"),user.getLanguage());
String requestlevel = Util.fromScreen(fu.getParameter("requestlevel"),user.getLanguage());
String messageType =  Util.fromScreen(fu.getParameter("messageType"),user.getLanguage());
String remark = Util.null2String(fu.getParameter("remark"));

String isfrommeeting = Util.null2String(fu.getParameter("isfrommeeting"));
String viewmeeting = Util.null2String(fu.getParameter("viewmeeting"));
//int isfromdoc = Util.getIntValue(fu.getParameter("isfromdoc"),-1);         //是否从文档显示页面提交审批过来的
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);
//int userid = user.getUID();

String MeetingID = Util.null2String(fu.getParameter("MeetingID"));
String approvewfid = Util.null2String(fu.getParameter("approvewfid"));
if(!approvewfid.equals(""))
        workflowid = Integer.valueOf(approvewfid).intValue();

String meetingname = "";

String saveSql ="";
String sqlstr = "";
isbill=1;

String approve=Util.null2String((String)fu.getParameter("approve"));
if(approve.equals("1")){
    response.sendRedirect("/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid);
    //out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"');</script>");
   return;
}
if(formid==-1){//没有传递formid,获取formid进行判断
	if(workflowid!=-1){
		rs.executeProc("workflow_Workflowbase_SByID",workflowid+"");
		if(rs.next()){
			formid=rs.getInt("formid");
		}
	}
}
if(formid!=-1&&formid!=85){
	//会议自定义表单,肯定是从会议卡片来

	String errmsg="";
	if("submit".equals(src)){//提交下一结点
		if(requestid==-1){//创建
			if(workflowid != -1){
				errmsg=MeetingCreateWFUtil.createWF(MeetingID,user,""+workflowid,Util.getIpAddr(request));
			}
		}else{//流转
			errmsg=MeetingCreateWFUtil.nextNodeBySubmit(requestid,MeetingID,user,""+formid,Util.getIpAddr(request));
		}
	}else if("reject".equals(src)){//退回
		errmsg=MeetingCreateWFUtil.nextNodeByReject(requestid,MeetingID,user,Util.getIpAddr(request));
	}
	errmsg=errmsg.replaceAll("</?[^>]+>","");
	if(!errmsg.isEmpty()){
		out.print("<script>window.top.Dialog.alert('"+errmsg+"');</script>");
	}
	out.print("<script>wfforward('/meeting/data/ViewMeetingTab.jsp?tab=1&meetingid="+MeetingID+"');</script>");
    return;
}
/***会议模块新建的会议通过流程审批，不需跳转到流程页面，直接审批通过开始***/
String approvemeeting = Util.null2String((String)fu.getParameter("approvemeeting"));
if("1".equals(approvemeeting) && requestid > -1) {//会议模板直接审批通过,不进入流程页面


	RequestInfo rqInfo = new RequestInfo(requestid,user);
	src = "submit";
	iscreate = "0";
	formid = rqInfo.getFormid();
	billid = rqInfo.getBillid();
}
/***会议模块新建的会议通过流程审批，不需跳转到流程页面，直接审批通过结束***/


//提交审批时,存在会议ID.
if(src.equals("submit")&&!MeetingID.equals("")) {//新建request时


	 if(workflowid!=-1){
		rs.executeProc("workflow_Workflowbase_SByID",workflowid+"");
		if(rs.next()){
			formid=rs.getInt("formid");
		}
		if (nodeid == -1){
				rs.executeProc("workflow_CreateNode_Select",workflowid+"");
				if(rs.next())
					nodeid=rs.getInt(1);
		
				nodetype="0";
		}		
	}
    RecordSet.executeSql("Select * From Meeting WHERE ID="+MeetingID);
	if(RecordSet.next()){
		meetingname = Util.null2String(RecordSet.getString("name"));
    }
	meetingLog.resetParameter();
	meetingLog.insSysLogInfo(user,Util.getIntValue(MeetingID),meetingname,""+SystemEnv.getHtmlLabelName(84488,user.getLanguage()),"303","2",1,Util.getIpAddr(request));
    
    requestname=SystemEnv.getHtmlLabelName(16419,user.getLanguage())+"-"+meetingname;
}


//请求参数出错
if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
    if(isfrommeeting.equals("1") || viewmeeting.equals("1")){
	//response.sendRedirect("/notice/RequestError.jsp");
	out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
	return;
    }else 
    out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
    return ;
}

if(remark.equals("")){
	remark = ResourceComInfo.getResourcename(""+user.getUID())+" "+CurrentDate+" "+CurrentTime ;
}
if(src.equals("delete")){
	/*删除工作流*/
    RecordSet.executeSql("Select * From Bill_Meeting where requestid="+requestid);
	if(RecordSet.next())
		MeetingID = RecordSet.getString("approveid");
	
	MeetingWFUtil.deleteMeeting(MeetingID);

}

//提交
if(isremark == -1){
    RecordSet.executeSql("select min(isremark) from workflow_currentoperator where requestid = " + requestid + " and userid = "+user.getUID());
    if(RecordSet.next()){
    int isremarkCheck = RecordSet.getInt(1);
    if(isremarkCheck==1){
       src = "save";
       isremark = 1;
    } else {
		isremark = isremarkCheck;
	} 
  }
}
if(viewmeeting.equals("1")){
	WFManager wfManager = new WFManager();
	wfManager.setWfid(workflowid);
	wfManager.getWfInfo();
	messageType = wfManager.getMessageType();
	if(messageType.equals("1")){
		messageType = wfManager.getSmsAlertsType();
	}
}
RequestManager.setSrc(src) ;
RequestManager.setIscreate(iscreate) ;
RequestManager.setRequestid(requestid) ;
RequestManager.setWorkflowid(workflowid) ;
RequestManager.setWorkflowtype(workflowtype) ;
RequestManager.setIsremark(isremark) ;
RequestManager.setFormid(formid) ;
RequestManager.setIsbill(isbill) ;
RequestManager.setBillid(billid) ;
RequestManager.setNodeid(nodeid) ;
RequestManager.setNodetype(nodetype) ;
RequestManager.setRequestname(requestname) ;
RequestManager.setRequestlevel(requestlevel) ;
RequestManager.setRemark(remark) ;
RequestManager.setRequest(fu) ;
RequestManager.setUser(user) ;
//add by chengfeng.han 2011-7-28 td20647 
int isagentCreater = Util.getIntValue((String)session.getAttribute(workflowid+"isagent"+user.getUID()));
int beagenter = Util.getIntValue((String)session.getAttribute(workflowid+"beagenter"+user.getUID()),0);
RequestManager.setIsagentCreater(isagentCreater);
RequestManager.setBeAgenter(beagenter);
//end
//add by xhheng @ 2005/01/24 for 消息提醒 Request06
RequestManager.setMessageType(messageType) ;

boolean savestatus = true ;
if(!isfrommeeting.equals("1"))
    savestatus = RequestManager.saveRequestInfo() ;    //不是从会议显示页面提交审批过来的才作saveRequestInfo否则会由于文档显示页面没有单据的字段信息而被清空
else RequestManager.setBilltablename("Bill_Meeting");

requestid = RequestManager.getRequestid() ;
 
if( !savestatus ) {//创建流程失败
    if( requestid != 0 ) {
        String message=RequestManager.getMessage();
        if(!"".equals(message)){
			if(isfrommeeting.equals("1") || viewmeeting.equals("1")){
				
				%>
					<%@ include file="/workflow/request/RedirectPage.jsp" %> 
					<%
                //response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&message="+message);
				//out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message="+message+"');</script>");
			}else out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message="+message+"');</script>");
            return ;
        }
        
        
        if(isfrommeeting.equals("1") || viewmeeting.equals("1")){
            //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1");
			out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=1');</script>");
        }else out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=1');</script>");
        return ;
    }
    else {
        if(isfrommeeting.equals("1") || viewmeeting.equals("1")){
            //response.sendRedirect("/workflow/request/RequestView.jsp?message=1");
		out.print("<script>wfforward('/workflow/request/RequestView.jsp?message=1');</script>");
        }else out.print("<script>wfforward('/workflow/request/RequestView.jsp?message=1');</script>");
        return ;
    }
}
//操作是submit且会议ID不为空,是用会议模块进入,更新数据
if(src.equals("submit")&&!MeetingID.equals("")){
	//会议卡片向表单更新数据


    MeetingWFUtil.updateMeeting2WF(MeetingID,""+formid,""+requestid,user.getUID());
    RecordSet.execute("delete meeting_sharedetail where meetingid="+MeetingID+" and sharelevel=4");
}

boolean flowstatus = RequestManager.flowNextNode() ;
if( !flowstatus ) {
	if(isfrommeeting.equals("1") || viewmeeting.equals("1")){
        //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
		out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=2');</script>");
	}else out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=2');</script>");
	return ;
}
boolean logstatus = RequestManager.saveRequestLog() ;
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +Util.add0(today.get(Calendar.MINUTE), 2) + ":" +Util.add0(today.get(Calendar.SECOND), 2);
//不是保存,肯定是流程操作,记录当前操作
if(!src.equals("save")){
	RecordSet.executeSql("select a.nodeid from workflow_flownode a,workflow_nodebase b where a.nodeid=b.id and a.workflowid="+workflowid+" and a.nodetype = 0");
	if(RecordSet.next()){
		int node_id = Util.getIntValue(RecordSet.getString("nodeid"),0);
		if(nodeid == node_id){
			RecordSet.executeSql("update workflow_currentoperator set isremark='2',operatedate='"+currentdate+"',operatetime='"+currenttime+"' where (isremark = '5' or isremark='0') and requestid=" + requestid+" and nodeid="+node_id+"");
		}
	}
}
//归档
String currentnodetypetmp = RequestManager.getNextNodetype();
RecordSet.executeSql("select currentnodetype from workflow_requestbase where requestid=" + requestid);
if(RecordSet.next())  currentnodetypetmp = RecordSet.getString("currentnodetype");
if("3".equals(currentnodetypetmp)){
    RecordSet.executeSql("update workflow_currentoperator set isremark = '2',iscomplete=1 where  requestid = "+requestid+" and nodeid = "+nodeid+" and (isremark = '9' or preisremark = '9') and userid = "+userid);
} else {
    RecordSet.executeSql("update workflow_currentoperator set isremark = '2' where  requestid = "+requestid+" and nodeid = "+nodeid+" and isremark = '9' and userid = "+userid+" and preisremark = '9'");
}
//表单提交	
if(src.equals("submit")&&MeetingID.equals("")){
	//会议表单向会议卡片同步数据

	//清楚之前审批人的权限
	MeetingID=MeetingWFUtil.updateWF2Meeting(""+requestid,""+formid,"",user.getUID());
	
}

char flag1=Util.getSeparator() ;

//System.out.println("RequestManager.getNodetype() ="+RequestManager.getNodetype());
//System.out.println("RequestManager.getNextNodetype() ="+RequestManager.getNextNodetype());

/*下一个节点未审批节点时才给节点操作者赋予会议权限*/
if(RequestManager.getNextNodetype().equals("1")){
    sqlstr = "select distinct userid,usertype from workflow_currentoperator where isremark = '0' and requestid ="+requestid;

    //System.out.println("sqlstr ="+sqlstr);
    int theusertype=0;
    rs.executeSql(sqlstr);
    while(rs.next()){
        int userid1 = rs.getInt("userid");
        int usertype1 = rs.getInt("usertype");
         if( usertype1 == 0 ) theusertype = 1 ;
                    else theusertype = 2 ;

        int sharelevel = 4 ;
        if(!MeetingID.equals("")){
            RecordSet.executeSql(" select sharelevel from meeting_sharedetail where meetingid = " + MeetingID + " and userid = " + userid1 + " and usertype = " + theusertype + " AND shareLevel <> 2" );               
            if(RecordSet.getCounts() == 0){
                //Procpara = ""+MeetingID + flag1 + ""+userid1 + flag1 + ""+theusertype + flag1 + ""+sharelevel ;
                RecordSet.executeSql("INSERT INTO Meeting_ShareDetail(meetingid, userid, usertype, sharelevel) VALUES ("+MeetingID+","+userid1+","+theusertype+","+sharelevel+")");  //插入审批人权限


                //System.out.println("INSERT INTO Meeting_ShareDetail(meetingid, userid, usertype, sharelevel) VALUES ("+MeetingID+","+userid1+","+theusertype+","+sharelevel+")");
                //RecordSet.executeProc("MeetingShareDetail_Insert",Procpara);
            }
        }
    }
}

//Save data to Bill_ApproveProj 创建时


if(src.equals("submit")&&iscreate.equals("1")) {
	RecordSet.executeSql("Update Meeting Set requestid ="+requestid+",meetingstatus=1 WHERE ID="+MeetingID);//更新当前会议的requestid

	//如果仅仅两个节点直接触发流程
    if(RequestManager.getNextNodetype().equals("3")){//下一节点直接是归档节点,会直接变成正常状态


		//设置会议正常,创建日程或者形成周期会议


		MeetingWFUtil.setMeetingNormal(MeetingID);
        
	 }
	
	if(isfrommeeting.equals("1") || viewmeeting.equals("1")){
	  out.print("<script>wfforward('/meeting/data/ViewMeetingTab.jsp?tab=1&meetingid="+MeetingID+"');</script>");
	  return;
	}else{ 
		//out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
		%>
		<%@ include file="/workflow/request/RedirectPage.jsp" %> 
		<%
		 return;
	}
}
/*审批通过时*/
//System.out.println("src = "+src);
//System.out.println("iscreate = "+iscreate);
if(src.equals("submit")&&iscreate.equals("0")){
    RecordSet.executeSql("Select * From Bill_Meeting where requestid="+requestid);
	if(RecordSet.next()){
		MeetingID = RecordSet.getString("approveid");
		meetingname = Util.null2String(RecordSet.getString("meetingname"));
    	/*审批退回时，重新提交，先更新会议的状态为待审批*/
		RecordSet.executeSql("Update Meeting Set meetingstatus=1 where ID ="+MeetingID);
    	/*审批退回时，重新提交*/

    	/*为审批节点时，更新审批人，和审批时间*/
	    if(nodetype.equals("1")){
	        saveSql ="Update Bill_Meeting Set approveby="+userid+",approvedate='"+CurrentDate+"' WHERE requestID="+requestid;
	        //System.out.println("saveSql =="+saveSql);
	        RecordSet.executeSql(saveSql);
	    }
    
	     if(RequestManager.getNextNodetype().equals("3")){
	      	//设置会议正常,创建日程或者形成周期会议


			MeetingWFUtil.setMeetingNormal(MeetingID); 
			
			if("1".equals(approvemeeting)) { /***会议模块新建的会议通过流程审批，不需跳转到流程页面，直接审批通过***/
		      //response.sendRedirect("/meeting/data/MeetingApproval.jsp");
			  out.print("<script>wfforward('/meeting/data/ViewMeetingTab.jsp?tab=1&meetingid="+MeetingID+"');</script>");
		      return;
		    }
	
		 
			if(isfrommeeting.equals("1") || viewmeeting.equals("1")){
	        	//response.sendRedirect("/meeting/data/ViewMeeting.jsp?tab=1&meetingid="+MeetingID);
				out.print("<script>wfforward('/meeting/data/ViewMeetingTab.jsp?tab=1&meetingid="+MeetingID+"');</script>");
			}else{// out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
			%>
			<%@ include file="/workflow/request/RedirectPage.jsp" %> 
			<%
			}
			return;
		 }
    }
	
	if("1".equals(approvemeeting)) { /***会议模块新建的会议通过流程审批，不需跳转到流程页面，直接审批通过***/
	    //response.sendRedirect("/meeting/data/MeetingApproval.jsp");
		//out.print("<script>wfforward('/meeting/search/MeetingSearchTab.jsp');</script>");
		out.print("<script>wfforward('/meeting/data/ViewMeetingTab.jsp?tab=1&meetingid="+MeetingID+"');</script>");
	    return;
	}
	
    //if(isfrommeeting.equals("1") || viewmeeting.equals("1"))
	//	response.sendRedirect("/meeting/data/ViewMeeting.jsp?meetingid="+MeetingID);
}
/*审批拒绝时*/
if(src.equals("reject")&&iscreate.equals("0")){
	billid = RequestManager.getBillid() ;
	if("".equals(MeetingID)){
		RecordSet.executeSql("Select * From Bill_Meeting where requestid="+requestid);
		if(RecordSet.next())
			MeetingID = RecordSet.getString("approveid");
	}
		
	if(RequestManager.getNextNodetype().equals("0")){
		sqlstr ="Update Meeting Set meetingstatus = 3 Where id="+MeetingID ;
		//System.out.println("sqlstr = "+sqlstr);
		RecordSet.executeSql(sqlstr);

		MeetingComInfo.removeMeetingInfoCache();
	}

	if(isfrommeeting.equals("1") || viewmeeting.equals("1")){
		//response.sendRedirect("/meeting/data/ViewMeeting.jsp?tab=1&meetingid="+MeetingID);
		out.print("<script>wfforward('/meeting/data/ViewMeetingTab.jsp?tab=1&meetingid="+MeetingID+"');</script>");
		return;
		}else{ 
			
			%>
			<%@ include file="/workflow/request/RedirectPage.jsp" %> 
			<%
		return;
		}
}

//response.sendRedirect("/workflow/request/RequestView.jsp");

if(!"".equals(approvewfid)) {  //会议通过流程审批时TD17758
   //response.sendRedirect("/workflow/request/RequestView.jsp");
    %>
	<%@ include file="/workflow/request/RedirectPage.jsp" %> 
	<%
	 return;
}
if(isfrommeeting.equals("1") || viewmeeting.equals("1")){
	 response.sendRedirect("/meeting/data/ViewMeeting.jsp?tab=1&meetingid="+MeetingID);
	return;
}else{
	%>
	<%@ include file="/workflow/request/RedirectPage.jsp" %> 
	<%
		return;
}
%>