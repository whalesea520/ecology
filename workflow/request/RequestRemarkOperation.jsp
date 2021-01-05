
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.net.*"%>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.FileUpload" %>
<%@page import="weaver.mobile.webservices.workflow.soa.RequestPreProcessing"%>
<%@page import="weaver.workflow.request.RequestSignRelevanceWithMe"%>
<%@page import="weaver.workflow.request.RequestOperationLogManager"%>
<%@page import="weaver.workflow.request.RequestOperationLogManager.RequestOperateEntityTableNameEnum"%>
<%@page import="weaver.workflow.request.WFLinkInfo"%>
<%@ page import="weaver.common.StringUtil" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="Requestlog" class="weaver.workflow.request.RequestLog" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="basebean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="remarkRight" class="weaver.workflow.request.RequestRemarkRight" scope="page" />
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<jsp:useBean id="requestAddShareInfo" class="weaver.workflow.request.RequestAddShareInfo" scope="page" />
<%
FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
String userid=""+user.getUID();
int usertype = (user.getLogintype()).equals("1") ? 0 : 1;
String src = Util.null2String(fu.getParameter("src"));
String iscreate = Util.null2String(fu.getParameter("iscreate"));
int requestid = Util.getIntValue(fu.getParameter("requestid"),-1);
int workflowid = Util.getIntValue(fu.getParameter("workflowid"),-1);
//解决流程重复提交
String submitTokenKey  = userid+"_"+workflowid+"_addrequest_submit_token";
String submitToKenValue = Util.null2String(fu.getParameter(submitTokenKey));
String catchTokenValue = Util.null2String(session.getAttribute(submitTokenKey));
if(!"".equals(catchTokenValue) && catchTokenValue.equals(submitToKenValue)){
	return;
}else{
	session.setAttribute(submitTokenKey,submitToKenValue);
}
String workflowtype = Util.null2String(fu.getParameter("workflowtype"));
int nodeid = Util.getIntValue(fu.getParameter("nodeid"),-1);
String nodetype = Util.null2String(fu.getParameter("nodetype"));
String needwfback = Util.null2String(fu.getParameter("needwfback"));
String remark = Util.null2String(fu.getParameter("remark"));
int formid = Util.getIntValue(fu.getParameter("formid"),-1);
int isbill = Util.getIntValue(fu.getParameter("isbill"),-1);
int billid = Util.getIntValue(fu.getParameter("billid"),-1);
String requestname = Util.fromScreen3(fu.getParameter("requestname"),user.getLanguage());
String requestlevel = Util.fromScreen(fu.getParameter("requestlevel"),user.getLanguage());
String messageType =  Util.fromScreen(fu.getParameter("messageType"),user.getLanguage());
String isFromEditDocument = Util.null2String(fu.getParameter("isFromEditDocument"));
String submitNodeId=Util.null2String(fu.getParameter("submitNodeId"));
String Intervenorid=Util.null2String(fu.getParameter("Intervenorid"));    
int isremark = Util.getIntValue(fu.getParameter("isremark"),-1);
String remarkLocation = Util.null2String(fu.getParameter("remarkLocation"));
boolean IsCanModify="true".equals(session.getAttribute(user.getUID()+"_"+requestid+"IsCanModify"))?true:false;
String ifchangstatus=Util.null2String(basebean.getPropValue(GCONST.getConfigFile() , "ecology.changestatus"));
Calendar today = Calendar.getInstance();
String currentdate = "";
String currenttime = "";
try{
	rs1.executeProc("GetDBDateAndTime", "");
	if(rs1.next()){
		currentdate = rs1.getString("dbdate");
		currenttime = rs1.getString("dbtime");
	}
}catch(Exception e){
	currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
		Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
		Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

	currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
		Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
		Util.add0(today.get(Calendar.SECOND), 2) ;
} 

if( src.equals("") || workflowid == -1 ||  nodeid == -1 || nodetype.equals("")) {
    //response.sendRedirect("/notice/RequestError.jsp");
    out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
    return ;
}
if(StringUtil.isNull(Util.null2String(session.getAttribute(user.getUID()+"_"+requestid+"IsCanSubmit")))
        ||StringUtil.isNull(Util.null2String(session.getAttribute(user.getUID()+"_"+requestid+"coadCanSubmit")))) {
    response.sendRedirect("/notice/noright.jsp");
    return;
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
    RequestManager.setSubmitNodeId(submitNodeId);
    RequestManager.setIntervenorid(Intervenorid);
    RequestManager.setRemarkLocation(remarkLocation);
    //add by xhheng @ 2005/01/24 for 消息提醒 Request06
    RequestManager.setMessageType(messageType) ;
    //System.out.println("messageType===="+messageType);
    RequestManager.setIsFromEditDocument(isFromEditDocument) ;
    RequestManager.setUser(user) ;
    RequestManager.setCanModify(IsCanModify);
    boolean savestatus = RequestManager.saveRequestInfo() ;
    requestid = RequestManager.getRequestid() ;
    if( !savestatus ) {
        if( requestid != 0 ) {
            String message=RequestManager.getMessage();
            if(!"".equals(message)){
				out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&requestid="+requestid+"&message="+message+"');</script>");
                return ;
            }
			out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&requestid="+requestid+"&message=1');</script>");
            return ;
        }
        else {
			out.print("<script>wfforward('/workflow/request/RequestView.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&message=1');</script>");
            return ;
        }
    }
    
    RequestOperationLogManager rolm = new RequestOperationLogManager(requestid);
    int optLogid = -1;
    //强制收回
    int wfcuroptid = -1;
    if (isremark == 9) {
        RecordSet.executeSql("select id from workflow_currentoperator where requestid=" + requestid + " and userid=" + userid + " and usertype=" + usertype + " and isremark=9");
        if (RecordSet.next()) {
            wfcuroptid = Util.getIntValue(RecordSet.getString(1));
            optLogid = rolm.getOptLogID(RequestOperationLogManager.RequestOperateEntityTableNameEnum.CURRENTOPERATOR.getId(), wfcuroptid, 0);
        }
    }
    
char flag = Util.getSeparator();
//提交
if (isremark==1){
	if(!"0".equals(needwfback)){
		RecordSet.execute("update workflow_currentoperator set isremark = 2, operatedate = '"+currentdate+"', operatetime = '"+currenttime+"' where requestid = "+requestid+" and userid = "+userid+" and usertype = "+usertype+" and (isremark = 1 or isremark = 8 or isremark = 9)");
	}else{
		RecordSet.execute("update workflow_currentoperator set isremark = 2, operatedate = '"+currentdate+"', operatetime = '"+currenttime+"',needwfback  = '0' where requestid = "+requestid+" and userid = "+userid+" and usertype = "+usertype+" and (isremark = 1 or isremark = 8 or isremark = 9)");
	}
}else{
	if(!"0".equals(needwfback)){
		RecordSet.execute("update workflow_currentoperator set isremark = 2, operatedate = '"+currentdate+"', operatetime = '"+currenttime+"' where requestid = "+requestid+" and userid = "+userid+" and usertype = "+usertype+" and isremark = " + isremark);
	}else{
		RecordSet.execute("update workflow_currentoperator set isremark = 2, operatedate = '"+currentdate+"', operatetime = '"+currenttime+"',needwfback  = '0' where requestid = "+requestid+" and userid = "+userid+" and usertype = "+usertype+" and isremark = " + isremark);
	}
}

//推送处理start
new Thread(new RequestPreProcessing(workflowid, isbill, formid, requestid, requestname, "", nodeid, 0, false, "", user, true)).start();

String isfeedback="";
String isnullnotfeedback="";    
RecordSet.executeSql("select isfeedback,isnullnotfeedback from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
	isfeedback=Util.null2String(RecordSet.getString("isfeedback"));
    isnullnotfeedback=Util.null2String(RecordSet.getString("isnullnotfeedback"));
}
if (!ifchangstatus.equals("")&&isfeedback.equals("1")&&((isnullnotfeedback.equals("1")&&!Util.replace(remark, "\\<script\\>initFlashVideo\\(\\)\\;\\<\\/script\\>", "", 0, false).equals(""))||!isnullnotfeedback.equals("1"))){
    RecordSet.executeSql("update workflow_currentoperator set viewtype =-1  where needwfback='1' and requestid=" + requestid + " and userid<>" + userid + " and viewtype=-2");

}
String curnodetype = "";
int currentnodeid = 0;
RecordSet.executeSql("select currentnodetype,currentnodeid from workflow_Requestbase where requestid="+requestid);
if(RecordSet.next()){
	curnodetype = Util.null2String(RecordSet.getString(1));
	currentnodeid = RecordSet.getInt(2);
}
if(curnodetype.equals("3"))//归档流程转发后，转发人或抄送人提交后到办结事宜。

	RecordSet.executeSql("update workflow_currentoperator set iscomplete=1 where userid="+userid+" and usertype="+usertype+" and requestid="+requestid);        

Requestlog.setRequest(fu) ;
Requestlog.setCurrentdate(currentdate);
Requestlog.setCurrenttime(currenttime);
int takisremark = -1;
int handleforwardid = -1;
String zsql = "select * from workflow_currentoperator where requestid= "+ requestid + "and islasttimes=1 and nodeid = "+ nodeid +" and userid = "+ userid;
RecordSet.executeSql(zsql);
while(RecordSet.next()){
takisremark = Util.getIntValue(RecordSet.getString("takisremark"));
handleforwardid = Util.getIntValue(RecordSet.getString("handleforwardid"));
if(takisremark == 2){
	break;
}
}

String currentString = "";
if(takisremark==2){
	currentString = Requestlog.saveLog2(workflowid,requestid,nodeid,"b",remark,user,"0",0,0,"",remarkLocation) ;  //意见征询
}else if(handleforwardid>0){
    currentString = Requestlog.saveLog2(workflowid,requestid,nodeid,"j",remark,user,"0",0,0,"",remarkLocation) ;  //转办
}else{
	currentString = Requestlog.saveLog2(workflowid,requestid,nodeid,"9",remark,user,"0",0,0,"",remarkLocation) ;
	//抄送需要提交  时， 添加 强制收回支持
	if (isremark == 9) {
	    RecordSet.executeSql("select logid from workflow_requestlog where requestid = " + requestid + " and nodeid = " + nodeid + " and operator=" + user.getUID() + " and operatortype=" + usertype + " and logtype = '9' order by operatedate, operatetime");
	    if (RecordSet.next()) {
	        int newlogid = RecordSet.getInt(1);
	        if (newlogid > 0) {
	            //向之前的日志中添加本条提交的记录， 方便在强制收回的时候能够收回
	            rolm.addDetailLog(optLogid, RequestOperateEntityTableNameEnum.REQUESTLOG.getId(), newlogid, 0, "", "", "");
	        }
	    }
	}
}
int nodeattr = WFLinkInfo.getNodeAttribute(nodeid);
Set<String> branchNodeSet = new HashSet<String>();
if(nodeattr == 2){   //分支中间节点
	String branchnodes = "";
	branchnodes = WFLinkInfo.getNowNodeids(requestid);
	if(!"".equals(branchnodes)){
		String [] strs = branchnodes.split(",");
		for(int k = 0; k < strs.length; k++){
			String nodestr = strs[k];
			if(!"-1".equals(nodestr)){
				branchNodeSet.add(nodestr);
			}
		}
	}
}

/**日志权限的处理，非归档节点，且提交时的节点，跟流程当前节点相同才需要权限控制*/
if(!"".equals(currentString) && currentString.indexOf("~~current~~") > -1 && !"3".equals(curnodetype) && (nodeid == currentnodeid || branchNodeSet.contains(nodeid+""))){
	int wfcurrrid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"wfcurrrid"), 0);
	if (wfcurrrid == 0) {
	    RecordSet.executeSql("select isremark,isreminded,preisremark,id,groupdetailid,nodeid from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and usertype="+usertype+" order by isremark,id");
	    boolean istoManagePage=false;
	    while(RecordSet.next())	{
	        String isremark_tmp = Util.null2String(RecordSet.getString("isremark")) ;
	        wfcurrrid=Util.getIntValue(RecordSet.getString("id"));
	        int tmpnodeid=Util.getIntValue(RecordSet.getString("nodeid"));
	        //转发特殊处理，转发信息本人未处理一直需要处理即使流程已归档
	        if( isremark_tmp.equals("1")||isremark_tmp.equals("5") || isremark_tmp.equals("7")|| isremark_tmp.equals("9") ||(isremark_tmp.equals("0")  && !nodetype.equals("3")) ) {
	          break;
	        }
	        if(isremark_tmp.equals("8")){
	            break;
	        }
	    }
	}
	
	remarkRight.setRequestid(requestid);
    remarkRight.setNodeid(nodeid);
    remarkRight.setWorkflow_currentid(wfcurrrid);
    String logtype = "7";
    if(takisremark == 2){   //征询
    	logtype = "b";
    }else if(handleforwardid > 0){  //转办
    	logtype = "j";
    }else{  //转发
    	logtype = "9";
    }
    String rightSql = " select logid from workflow_requestlog where workflowid = " + workflowid 
    		        + " and nodeid = " + nodeid + " and logtype = '" + logtype + "' and requestid = " + requestid
    		        + " and operatedate = '" + currentdate + "' and operatetime = '" + currenttime + "' and operator = " + userid;
    RecordSet.executeSql(rightSql);
    int logid = -1;
    if(RecordSet.next()){
    	logid = RecordSet.getInt("logid");
    }
    String userids = "";
    remarkRight.saveRemarkRight(logid,userids);
}

if(!"".equals(currentString) && currentString.indexOf("~~current~~") > -1){
    String logtype = "7";
    if(takisremark == 2){   //征询
    	logtype = "b";
    }else if(handleforwardid > 0){  //转办
    	logtype = "j";
    }else{  //转发
    	logtype = "9";
    }
	RequestSignRelevanceWithMe reqsignwm = new RequestSignRelevanceWithMe();
    reqsignwm.inertRelevanceInfo(workflowid+"", requestid+"", currentnodeid+"", logtype, currentdate, currenttime, userid, remark);
}

if(takisremark==2) {
	ArrayList resourceids = new ArrayList();
	resourceids.add(userid);
	requestAddShareInfo.addShareInfo("" + requestid, resourceids, "false", true, false, true); // 收回被征询人的文档编辑权限
	
    //多个分叉中间点意见征询给同一人时， 需要找到当前所有的节点，判断是否存在意见征询动作
    WFLinkInfo wfLinkinfo = new WFLinkInfo();
    String takNodeIds = wfLinkinfo.getNowNodeids(requestid);
    String taksql = "select id, nodeid from workflow_currentoperator where requestid= "+ requestid + " and nodeid in ( "+ takNodeIds +") and userid = "+ userid +" and preisremark='1' and takisremark = 2";
    RecordSet.executeSql(taksql);
    while(RecordSet.next()){
        int beforwardid = Util.getIntValue(RecordSet.getString("id"));
        int beforwardNodeId = Util.getIntValue(RecordSet.getString("nodeid"));
        rs1.executeSql("select forwardid from workflow_forward where requestid = "+requestid+" and beforwardid = "+beforwardid);
        if(rs1.next()){     //找到征询人
            int forwardid = Util.getIntValue(rs1.getString("forwardid"));
            String sumBeforWardSql = "select * from workflow_currentoperator where requestid= "+ requestid + " and nodeid = "+ beforwardNodeId +" and isremark=1 and preisremark='1' and takisremark = 2 and id in (select beforwardid from workflow_forward where requestid="+requestid+" and forwardid="+forwardid+" and beforwardid<>"+beforwardid+")";
            rs1.executeSql(sumBeforWardSql);
            if(!rs1.next()){    //判断是否所有被征询人都已回复
                String uptaksql2 = "update workflow_currentoperator set takisremark=0 where requestid= "+ requestid + " and nodeid = "+ beforwardNodeId +" and isremark = 0 and takisremark = -2 and id="+forwardid;
                rs1.executeSql(uptaksql2);      //更改征询人状态从-2改为0
            }
        }
    }
}

/*
被转发人和被抄送人均不是流程中的实际操作者，不用更新流程的最后操作人和操作时间；
在检查流程数据是否已更改时（两个流程操作者同时打开流程，并对流程做修改，先提交的修改会被覆盖，该功能是判断如果已经有修改提交，会提醒流程数据已更改，请核对后再处理），
在提交流程时用最后操作人和操作时间与打开流程时的最后操作人和操作时间作比较，

对于被转发人和被抄送人提交，如果也更改流程的最后操作人和操作时间，则真正的流程操作者提交时被检查出流程数据已更改。

Calendar today = Calendar.getInstance();
String CurrentDate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                      Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                      Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String CurrentTime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                      Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                      Util.add0(today.get(Calendar.SECOND), 2) ;
//RecordSet.executeSql("update workflow_requestbase set lastoperator="+userid+",lastoperatortype="+usertype+",lastoperatedate='"+CurrentDate+"',lastoperatetime='"+CurrentTime+"' where requestid="+requestid);     
if(curnodetype.equals("3"))
    RecordSet.executeSql("update workflow_requestbase set lastoperator="+userid+",lastoperatortype="+usertype+" where requestid="+requestid);     
else
    RecordSet.executeSql("update workflow_requestbase set lastoperator="+userid+",lastoperatortype="+usertype+",lastoperatedate='"+CurrentDate+"',lastoperatetime='"+CurrentTime+"' where requestid="+requestid);     
*/

String isShowPrompt="true";
String docFlags=(String)session.getAttribute("requestAdd"+requestid);
if(docFlags ==null || docFlags.equals("")) docFlags = "-1";
if (docFlags.equals("1"))
			{%>
			<SCRIPT LANGUAGE="JavaScript">
             parent.document.location.href="/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&nodetypedoc=<%=nodetype%>&requestid=<%=requestid%>&fromoperation=1&updatePoppupFlag=1&isShowPrompt=<%=isShowPrompt%>&src=<%=src%>";
            </SCRIPT>
			<%}else{
//response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&fromoperation=1&updatePoppupFlag=1&isShowPrompt="+isShowPrompt+"&src="+src);
out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&requestid="+requestid+"&fromoperation=1&updatePoppupFlag=1&isShowPrompt="+isShowPrompt+"&src="+src+"');</script>");
}

%>