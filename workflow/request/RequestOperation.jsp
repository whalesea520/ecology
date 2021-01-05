<%@page import="org.json.JSONObject"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.net.*"%>
<%@ page import="weaver.common.StringUtil" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.workflow.request.WorkflowRequestMessage" %>
<%@ page import="java.util.*,java.sql.Timestamp,weaver.system.code.*" %>
<%@ page import="weaver.cpt.util.CptWfUtil" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="Requestlog" class="weaver.workflow.request.RequestLog" scope="page"/>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RequestDoc" class="weaver.workflow.request.RequestDoc" scope="session"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="Doccoder" class="weaver.docs.docs.DocCoder" scope="page"/>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>
<jsp:useBean id="DocCheckInOutUtil" class="weaver.docs.docs.DocCheckInOutUtil" scope="page"/>
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>
<jsp:useBean id="TestWorkflowCheck" class="weaver.workflow.workflow.TestWorkflowCheck" scope="page"/>
<%
FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
String userid=""+user.getUID();
String lastloginuserid = Util.null2String(fu.getParameter("lastloginuserid")); //原流程创建用户ID
String rands[] = Util.TokenizerString2(Util.null2String(fu.getParameter("rand")),"+");
String rand = "";
boolean needout = false;
if(rands.length>0) rand = rands[0];
if(rands.length>1) needout = true;
String needoutprint = Util.null2String(fu.getParameter("needoutprint"));//等于1，代表点的正文


String src = Util.null2String(fu.getParameter("src"));
String iscreate = Util.null2String(fu.getParameter("iscreate"));
int requestid = Util.getIntValue(fu.getParameter("requestid"),-1);
int workflowid = Util.getIntValue(fu.getParameter("workflowid"),-1);

%>
	<script>
function setDocUrl(url){
	
	var bodyiframediv = parent.parent.document.getElementById("divWfText");
	if(parent.parent.tempcurrentTab == "WfText"){
		var _document = jQuery("#bodyiframe",window.parent.parent.document)[0].contentWindow.document;
		jQuery(_document).find("input[name='<%=userid%>_<%=workflowid %>_addrequest_submit_token']").val(new Date().getTime());
		parent.parent.readdocurlNew(url);
	}
}
	</script>
	<%
//解决流程重复创建
String submitTokenKey  = userid+"_"+workflowid+"_addrequest_submit_token";
String submitToKenValue = Util.null2String(fu.getParameter(submitTokenKey));
String catchTokenValue = Util.null2String(session.getAttribute(submitTokenKey));
if(!"".equals(catchTokenValue) && catchTokenValue.equals(submitToKenValue)){
	String toDocUrl = Util.null2String(session.getAttribute(requestid+"_wfdoc"));
	if(!toDocUrl.equals("")){
		out.print("<script>setDocUrl('"+toDocUrl+"')</script>");
	}
	return;
}else{
	session.setAttribute(submitTokenKey,submitToKenValue);
}

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
String chatsType =  Util.fromScreen(fu.getParameter("chatsType"),user.getLanguage());//微信提醒(QC:98106)
String isFromEditDocument = Util.null2String(fu.getParameter("isFromEditDocument"));
String remark = Util.null2String(fu.getParameter("remark"));
String method = Util.fromScreen(fu.getParameter("method"),user.getLanguage()); // 作为新建文档时候的参数传递
String remarkLocation = Util.null2String(fu.getParameter("remarkLocation"));   //签字意见添加位置
String topage=URLDecoder.decode(Util.null2String(fu.getParameter("topage")));  //返回的页面

String submitNodeId=Util.null2String(fu.getParameter("submitNodeId"));

String isFirstSubmit=Util.null2String(fu.getParameter("isFirstSubmit"));
String prefix = "";
if("0".equals(isFirstSubmit)){
    prefix="parent.";
}

String Intervenorid=Util.null2String(fu.getParameter("Intervenorid"));
int SignType = Util.getIntValue(fu.getParameter("SignType"),0);
int enableIntervenor = Util.getIntValue(fu.getParameter("enableIntervenor"),1);//是否启用节点及出口附加操作



int isovertime = Util.getIntValue(fu.getParameter("isovertime"),0);
int isagentCreater = Util.getIntValue((String)session.getAttribute(workflowid+"isagent"+user.getUID()));
int beagenter = Util.getIntValue((String)session.getAttribute(workflowid+"beagenter"+user.getUID()),0);
boolean docFlag=RequestDoc.haveDocFiled(""+workflowid,""+nodeid);
int urger=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"urger"),0);
String isintervenor=Util.null2String((String)session.getAttribute(user.getUID()+"_"+requestid+"isintervenor"));
if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
    //response.sendRedirect("/notice/RequestError.jsp");
	if(needoutprint.equals("")) out.print("<script>"+prefix+"wfforward('/notice/RequestError.jsp');</script>");
    return ;
}
boolean IsCanSubmit="true".equals(session.getAttribute(user.getUID()+"_"+requestid+"IsCanSubmit"))?true:false;
boolean coadCanSubmit="true".equals(session.getAttribute(user.getUID()+"_"+requestid+"coadCanSubmit"))?true:false;
boolean IsCanModify="true".equals(session.getAttribute(user.getUID()+"_"+requestid+"IsCanModify"))?true:false;
String IsBeForwardPending=Util.null2String((String)session.getAttribute(user.getUID()+"_"+requestid+"IsBeForwardPending"));
String coadispending=Util.null2String((String)session.getAttribute(user.getUID()+"_"+requestid+"coadispending"));
String coadsigntype=Util.null2String((String)session.getAttribute(user.getUID()+"_"+requestid+"coadsigntype"));
int ispending=-1;
if(isremark==7&&coadispending.equals("1")){
    if(IsBeForwardPending.equals("1")){
        ispending=2;
    }else{
        ispending=1;
    }
}else if(IsBeForwardPending.equals("1")){
    ispending=0;
}
int wfcurrrid=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"wfcurrrid"),0);
int intervenorright = Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"intervenorright"),0);
if(src.equals("supervise") || (src.equals("submit") && isremark==5) || (src.equals("intervenor") && intervenorright>0)){
	IsCanSubmit=true;
}
session.removeAttribute("errormsgid_"+user.getUID()+"_"+requestid);
session.removeAttribute("errormsg_"+user.getUID()+"_"+requestid);
//创建
if(requestid == -1 && !"".equals(lastloginuserid) && !userid.equals(lastloginuserid)){
    out.print("<script>"+prefix+"wfforward('/workflow/request/AddRequest.jsp?workflowid="+workflowid+"');</script>");
    return;
}
//session  中IsCanSubmit coadCanSubmit 丢失 不能判断是否可以提交，提示流程提交超时，请重新提交
if(requestid > 0 && (StringUtil.isNull(Util.null2String(session.getAttribute(user.getUID()+"_"+requestid+"IsCanSubmit")))
        ||StringUtil.isNull(Util.null2String(session.getAttribute(user.getUID()+"_"+requestid+"coadCanSubmit"))))){
    out.print("<script>"+prefix+"wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message="+WorkflowRequestMessage.WF_REQUEST_ERROR_CODE_03+"');</script>");
    return;
}

if((requestid>0&&(!IsCanSubmit&&!coadCanSubmit)) || RequestManager.checkNodeOperatorComment(requestid,user.getUID(),nodeid)){
    if(needoutprint.equals("")){
    	out.print("<script>"+prefix+"wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message="+WorkflowRequestMessage.WF_REQUEST_ERROR_CODE_02+"');</script>");
    }
    if(method.indexOf("crenew_") > -1){
    	String docId = Util.null2String(fu.getParameter("docValue"));
		session.setAttribute(requestid+"_wfdoc","/docs/docs/DocEditExt.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&fromFlowDoc=1&topage="+topage+"&id="+docId+"&requestid="+requestid+"&isintervenor="+isintervenor);
		session.setAttribute(rand+"_wfdoc","/docs/docs/DocEditExt.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&fromFlowDoc=1&topage="+topage+"&id="+docId+"&requestid="+requestid+"&isintervenor="+isintervenor);
    }
    return;
}
String isMultiDoc = Util.null2String(fu.getParameter("isMultiDoc")); //多文档新建


RequestManager.setIsMultiDoc(isMultiDoc) ;
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
RequestManager.setSignType(SignType);
//System.out.println("messageType===="+messageType);
RequestManager.setIsFromEditDocument(isFromEditDocument) ;
RequestManager.setUser(user) ;
RequestManager.setIsagentCreater(isagentCreater);
RequestManager.setBeAgenter(beagenter);
RequestManager.setIsPending(ispending);
RequestManager.setRequestKey(wfcurrrid);
RequestManager.setCanModify(IsCanModify);
RequestManager.setCoadsigntype(coadsigntype);   
RequestManager.setEnableIntervenor(enableIntervenor);//是否启用节点及出口附加操作
RequestManager.setRemarkLocation(remarkLocation);
RequestManager.setIsFirstSubmit(isFirstSubmit);





boolean havaChage=false;
if(docFlag) 
{
 RequestDoc.setUser(user);
 havaChage=RequestDoc.haveChage(""+workflowid,""+requestid,fu);  //如果改变了发文目录

}
//TD8715 获取工作流信息，是否显示流程图

WFManager.setWfid(workflowid);
WFManager.getWfInfo();
String isShowChart = Util.null2String(WFManager.getIsShowChart());
if("".equals(Util.null2String(messageType))){
	if("1".equals(WFManager.getMessageType())){
 		messageType=WFManager.getSmsAlertsType() ;
	}else{
 		messageType = "0";
	} 
}
//微信提醒(QC:98106)
if("".equals(Util.null2String(chatsType))){
	 if("1".equals(WFManager.getChatsType())){
	 	chatsType=WFManager.getChatsAlertType() ;
	 }else{
	 	chatsType = "0";
	 } 
	}
//add by xhheng @ 2005/01/24 for 消息提醒 Request06
RequestManager.setMessageType(messageType) ;
RequestManager.setChatsType(chatsType) ; //微信提醒(QC:98106)

boolean savestatus = true;
if(!"1".equals(isFirstSubmit)){
    savestatus = RequestManager.saveRequestInfo() ;
}

requestid = RequestManager.getRequestid() ;




if("save".equals(src)){
	session.setAttribute("needwfback_"+user.getUID()+"_"+requestid, (String)fu.getParameter("needwfback"));
}else if("submit".equals(src)){
	String needwfback = Util.null2String((String)fu.getParameter("needwfback"));
	String needwfback_s = Util.null2String((String)session.getAttribute("needwfback_"+user.getUID()+"_"+requestid));
	if("1".equals(needwfback) && "0".equals(needwfback_s)){
		RequestManager.setNeedwfback("0");
	}
	session.removeAttribute("needwfback_"+user.getUID()+"_"+requestid);
}
if( !savestatus ) {
    if( requestid != 0 ) {
        String message=RequestManager.getMessage();
        if(!"".equals(message)){
            
            if(StringUtil.isNotNull(RequestManager.getMessagecontent())){
	        	 session.setAttribute("errormsg_"+user.getUID()+"_"+requestid, RequestManager.getMessagecontent());
            }
            //response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&message="+message+"&isintervenor="+isintervenor);
            if(needoutprint.equals("")) out.print("<script>"+prefix+"wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message="+message+"&isintervenor="+isintervenor+"');</script>");
            session.setAttribute(requestid+"_wfdoc","error/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message="+message+"&isintervenor="+isintervenor);
		    session.setAttribute(rand+"_wfdoc","error/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message="+message+"&isintervenor="+isintervenor);
            return ;
        }

		//System.out.println("&&&&&&&&&209&&&&&&&&&&&&&&&&&&&&user="+user.getUID());
        //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1");
        if(needoutprint.equals("")) out.print("<script>"+prefix+"wfforward('/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=1');</script>");
        session.setAttribute(requestid+"_wfdoc","error/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=1");
	    session.setAttribute(rand+"_wfdoc","error/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=1");
        return ;
    }
    else {
		//System.out.println("&&&&&&&&&&218&&&&&&&&&&&&&&&&&&&user="+user.getUID());
        if(needoutprint.equals("")) out.print("<script>"+prefix+"wfforward('/workflow/request/RequestView.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&message=1');</script>");
        //response.sendRedirect("/workflow/request/RequestView.jsp?message=1");
        session.setAttribute(requestid+"_wfdoc","error/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=1");
	    session.setAttribute(rand+"_wfdoc","error/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=1");
        return ;
    }
}

//System.out.println("&&&&&&&&&&227&&&&&&&&&&&&&&&&&&&user="+user.getUID());
//System.out.println("isShowChart = " + isShowChart);
/**Save the detail info of the request**/
	//move this part to do in the class of RequestManager
String messageid = RequestManager.getMessageid();
String messagecontent = RequestManager.getMessagecontent();
if(!messageid.equals("")&&!messagecontent.equals("")){
	session.setAttribute(requestid+"_"+messageid,messagecontent);
	//System.out.println("&&&&&&&&&&233&&&&&&&&&&&&&&&&&&&user="+user.getUID());
	if(needoutprint.equals("")) out.print("<script>"+prefix+"wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message="+messageid+"');</script>");
	return;
}
	
/**Save Detail end**/
boolean flowstatus = true;
if(!"save".equals(src)||isremark!=1){
	String eh_setoperator = Util.null2String(fu.getParameter("eh_setoperator"));
	if("n".equals(eh_setoperator)){		//异常处理窗口未选择操作者，以提交失败处理
		flowstatus = false;
		RequestManager.setMessage(WorkflowRequestMessage.WF_REQUEST_ERROR_CODE_07);
		JSONObject msgjson = new JSONObject();
		String bottom = "<span>"+SystemEnv.getHtmlLabelName(126560,user.getLanguage())+"，"+SystemEnv.getHtmlLabelName(126554,user.getLanguage())+"<a href=\"javascript:rechoseoperator()\"> "+SystemEnv.getHtmlLabelName(126555,user.getLanguage())+" </a>"+SystemEnv.getHtmlLabelName(126561,user.getLanguage())+"</span>";
		msgjson.put("details",bottom);
		RequestManager.setMessagecontent(msgjson.toString());
	}else{
		if("y".equals(eh_setoperator))	//异常处理选择了操作者，拼装操作者信息
			RequestManager.createEh_operatorMap_pc();
			flowstatus = RequestManager.flowNextNode() ;
		
		if(!flowstatus && (WorkflowRequestMessage.WF_CUSTOM_LINK_TIP).equals(RequestManager.getMessage())){
            String ismode = Util.null2String(fu.getParameter("ismode"));
            String divcontent = Util.null2String(fu.getParameter("divcontent"));
            String content = Util.null2String(fu.getParameter("content"));
            
            RequestManager.removeErrorMsg();
            %>
            <script language="javascript">
            	var _document = $("#bodyiframe",window.parent.parent.document)[0].contentWindow.document;
    			jQuery("#lastOperateDate", _document).val("<%=RequestManager.getCurrentDate() %>");
    			jQuery("#lastOperateTime", _document).val("<%=RequestManager.getCurrentTime() %>");
    			jQuery("#lastOperator",_document).val("<%=RequestManager.getLastoperator()%>");
	            try{
					if(jQuery("#isFirstSubmit",_document).length <= 0){
						var frmmain = jQuery("form[name='frmmain']",_document);
						jQuery(frmmain).append("<input type='hidden' name='isFirstSubmit' id='isFirstSubmit' value =''>");	
					}
				}catch(e){console.log(e);}
    			jQuery("#isFirstSubmit",_document).val("1");
    			jQuery("input[name='<%=submitTokenKey%>']",_document).val(new Date().getTime());
    			<%
    			Set<String> keyset = RequestManager.getNewAddDetailRowPerInfo().keySet();
                Iterator<String> it1=keyset.iterator();
                while (it1.hasNext()) {
    			    String rowid = it1.next();
    			    int rowno = RequestManager.getNewAddDetailRowPerInfo().get(rowid);
    			    %>
                    jQuery("input[name='<%=rowid %>']", _document).val("<%=rowno %>");
    			    <%
    			    it1.remove();
    			    //RequestManager.getNewAddDetailRowPerInfo().remove(rowid);
    			}
    			%>
    			
            	window.parent.showtipsinfoReturn("<%=RequestManager.getMessagecontent()%>","<%=src%>","<%=ismode%>","<%=divcontent%>","<%=content%>","<%="" %>");
            </script>
            
            <%
            return;
		}
		
		if(!flowstatus && RequestManager.isNeedChooseOperator()){		//流转异常处理，找不到操作者且后台设置了提交至指定人员
			out.println("<script>");
			out.println(prefix+"wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&needChooseOperator=y');");
			out.println("</script>");
			return;
		}
	}
}else {
      //被转发人保存
      Requestlog.setRequest(fu) ;
      Requestlog.saveLog(workflowid,requestid,nodeid,"1",remark,user) ;
}


//add by fanggsh 20060718 for TD4531 begin
String triggerStatus=(String)session.getAttribute("triggerStatus"); 
session.removeAttribute("triggerStatus");

//下一节点操作者找不到时， 不能跳转到登陆页面

if (!flowstatus && "1".equals(session.getAttribute("istest"))) {
    session.setAttribute("currequestid", ""+requestid);
    if (!src.equals("delete")) {
	  	//将流程的状态更改为可变出状态， 以便在流程测试删除中找到它
	    TestWorkflowCheck.updateTestWFDeletedStatus(session, iscreate, workflowid, requestid);
    }
}

if( !flowstatus&&triggerStatus!=null&&triggerStatus.equals("1") ) {
	//System.out.println("&&&&&&&&&&261&&&&&&&&&&&&&&&&&&&user="+user.getUID());
    //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=3");
    if(needoutprint.equals("")) out.print("<script>"+prefix+"wfforward('/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=3');</script>");
    return ;
}
//add by fanggsh 20060718 for TD4531 end
if( !flowstatus ) {
    String message=RequestManager.getMessage();
    if(!message.equals("")){
        if(StringUtil.isNotNull(RequestManager.getMessagecontent())){
        	 session.setAttribute("errormsg_"+user.getUID()+"_"+requestid, RequestManager.getMessagecontent());
        }
		//System.out.println("-vf--269-2222222-f_weaver_belongto_userid------"+f_weaver_belongto_userid);
    	//response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&message="+message+"&isintervenor="+isintervenor);
    	if(needoutprint.equals("")) out.print("<script>"+prefix+"wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message="+message+"&isintervenor="+isintervenor+"');</script>");
    }else{
    	//System.out.println("-vf--269-2222222-f_weaver_belongto_userid------"+f_weaver_belongto_userid);
    	//response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
    	if(needoutprint.equals("")) out.print("<script>"+prefix+"wfforward('/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=2');</script>");
    }
    return ;
}

//執行資產凍結處理
if(!"save".equals(src)){
	new Thread(new CptWfUtil(RequestManager,"freezeCptnum")).start();
}
	//System.out.println("-vf--322-2222222-f_weaver_belongto_userid------"+f_weaver_belongto_userid);
boolean logstatus = RequestManager.saveRequestLog() ;
out.write(TestWorkflowCheck.gotoNextNode(session,src,user, iscreate, workflowid,requestid,RequestManager.getNextNodeid(),prefix));

String fromPDA=Util.null2String((String)session.getAttribute("loginPAD"));
if(method.equals("")){  
	  //如果是测试流程，则不向下执行，防止跳转到非流程页面，导致流程测试退出到登录页面
	  //目前测试流程不能测试公文及新建文档，所以暂不考虑其相关的跳转
	  if ("1".equals(session.getAttribute("istest"))) {
	      return;
	  }
		//System.out.println("-vf--327-2222222-f_weaver_belongto_userid------"+f_weaver_belongto_userid);
	
	if (docFlag){
        DocCheckInOutUtil.docCheckInWhenRequestOperation(user,requestid,request);
		RequestDoc.changeDocFiled(""+workflowid,""+requestid,fu,user.getLanguage(),havaChage); //如果改变了发文目录

	}
	if(!topage.equals("")){
        	if(topage.indexOf("?")!=-1){
					//System.out.println("-vf--335-2222222-f_weaver_belongto_userid------"+f_weaver_belongto_userid);
        		//response.sendRedirect(topage+"&requestid="+requestid);
        		if(needoutprint.equals("")) out.print("<script>"+prefix+"wfforward('"+topage+"&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"');</script>");
    		}else{
					//System.out.println("-vf--339-2222222-f_weaver_belongto_userid------"+f_weaver_belongto_userid);
				//response.sendRedirect(topage+"?requestid="+requestid);
				if(needoutprint.equals("")) out.print("<script>"+prefix+"wfforward('"+topage+"?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"');</script>");
			}	
		}
    else {
	 
        if(iscreate.equals("1")){
        
            if (docFlag)
            {%>
		
				<%if("1".equals(isShowChart)&&!src.equals("save")){%>
			     <SCRIPT LANGUAGE="JavaScript">
                  <%=prefix%>parent.document.location.href="/workflow/request/WorkflowDirection.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&workflowid=<%=workflowid%>&isbill=<%=isbill%>&formid=<%=formid%>";
			     </SCRIPT>
			    <%}else{
				     if(!src.equals("save")){
				      %>
					  	<%@ include file="/workflow/request/RedirectPage.jsp" %> 
					 <%}else{
					 %>
					  <SCRIPT LANGUAGE="JavaScript">
					// System.out.println("-vf--353-2222222-f_weaver_belongto_userid------"+f_weaver_belongto_userid);
					   <%=prefix%>parent.document.location.href="/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&fromoperation=1&updatePoppupFlag=1&src=<%=src%>&isovertime=<%=isovertime%>&urger=<%=urger%>&isintervenor=<%=isintervenor%>";
					   </SCRIPT>
					<% 
					 }
				 } 
			} else
			{
			if (fromPDA.equals("1")){
				//response.sendRedirect("/workflow/search/WFSearchResultPDA.jsp?workflowid="+workflowid);
				if(needoutprint.equals("")) out.print("<script>"+prefix+"wfforward('/workflow/search/WFSearchResultPDA.jsp?workflowid="+workflowid+"');</script>");
			}else{
				if("1".equals(isShowChart)&&!src.equals("save")){
			        //response.sendRedirect("/workflow/request/WorkflowDirection.jsp?requestid="+requestid+"&workflowid="+workflowid+"&isbill="+isbill+"&formid="+formid);
					if(needoutprint.equals("")) out.print("<script>"+prefix+"wfforward('/workflow/request/WorkflowDirection.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&workflowid="+workflowid+"&isbill="+isbill+"&formid="+formid+"');</script>");
				}else{
					if(!src.equals("save")){
						%>
						<%@ include file="/workflow/request/RedirectPage.jsp" %> 
						<%
					}else{
						//System.out.println("&&&&&&&&&&391&&&&&&&&&&&&&&&&&&&user="+user.getUID());
					 if(needoutprint.equals(""))  out.print("<script>"+prefix+"wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&fromoperation=1&updatePoppupFlag=1&src="+src+"&isovertime="+isovertime+"&urger="+urger+"&isintervenor="+isintervenor+"');</script>");
                    }
				}
			}
			}
        }
        else{
		  
		
            if("delete".equals(src) && savestatus && flowstatus){%>
            <SCRIPT LANGUAGE="JavaScript">
            alert("<%=SystemEnv.getHtmlLabelName(20461,user.getLanguage())%>");
            //window.close();
<%if(docFlag){%>
	try{
	    parent.window.close();
	}catch(e){}
<%}else{%>
	try{
	    window.close();
	}catch(e){}
	try{
	    parent.window.close();
	}catch(e){}
            //window.history.go(-2);
<%}%>
<%
boolean isUseOldWfMode = sysInfo.isUseOldWfMode();
%>
		try{	
			parent.window.opener.btnWfCenterReload.onclick();
		}catch(e){}
		try{
			<%if(isUseOldWfMode){%>
			parent.window.opener._table.reLoad();
			<%}else{%>
			parent.window.opener.reLoad();
			<%}%>
		}catch(e){}


            </SCRIPT>
            <%
            	return;
            }
            else{

            //TD4262 增加提示信息  开始

            //response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&fromoperation=1&updatePoppupFlag=1");//td3450 xwj 20060207
            String docFlags=Util.null2String((String)session.getAttribute("requestAdd"+requestid));  //流程建文档相关

            
			String isShowPrompt="true";
			if (docFlags.equals("1"))
			{
				//System.out.println("&&&&&&&&&&&&450&&&&&&&&&&&&&&&&&user="+user.getUID());
				//System.out.println("/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&?nodetypedoc="+nodetype+"&requestid="+requestid+"&fromoperation=1&updatePoppupFlag=1&isShowPrompt="+isShowPrompt+"src="+src+"&isovertime="+isovertime+"&urger=<"+urger+"&isintervenor="+isintervenor);
				%>
			<SCRIPT LANGUAGE="JavaScript">
             <%=prefix%>parent.document.location.href="/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&?nodetypedoc=<%=nodetype%>&requestid=<%=requestid%>&fromoperation=1&updatePoppupFlag=1&isShowPrompt=<%=isShowPrompt%>&src=<%=src%>&isovertime=<%=isovertime%>&urger=<%=urger%>&isintervenor=<%=isintervenor%>&uselessFlag=1";
            </SCRIPT>
			<%}
			else
           	{
				
			if (fromPDA.equals("1")){
				//response.sendRedirect("/workflow/search/WFSearchResultPDA.jsp?workflowid="+workflowid);
				if(needoutprint.equals("")) out.print("<script>"+prefix+"wfforward('/workflow/search/WFSearchResultPDA.jsp?workflowid="+workflowid+"');</script>");
			}else{	
				//System.out.println("&&&&&&&&&&&&463&&&&&&&&&&&&&&&&&user="+user.getUID());
				//response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&fromoperation=1&updatePoppupFlag=1&isShowPrompt="+isShowPrompt+"&src="+src+"&isovertime="+isovertime+"&urger="+urger+"&isintervenor="+isintervenor);//td3450 xwj 20060207
				if(needoutprint.equals("")) out.print("<script>"+prefix+"wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&fromoperation=1&updatePoppupFlag=1&isShowPrompt="+isShowPrompt+"&src="+src+"&isovertime="+isovertime+"&urger="+urger+"&isintervenor="+isintervenor+"');</script>");
            }
            //TD4262 增加提示信息  结束
             }
            }
        }
    }
}
else {
    String adddocfieldid = method.substring(7) ;
    String addMethod=method.substring(0,7) ;
    if(adddocfieldid.indexOf("_")>0)
    {
    	String docrowindex = Util.null2String(RequestManager.getDocrowindex());
    	if(!docrowindex.equals(""))
    		adddocfieldid = adddocfieldid.substring(0,adddocfieldid.indexOf("_"))+"_"+docrowindex;
    }
    //新建流程的时候创建文档要返回流程页面，所以此处要设置SESSION

     session.setAttribute(userid+"_"+requestid+"status","");
    session.setAttribute(userid+"_"+requestid+"requestname",requestname);
    session.setAttribute(userid+"_"+requestid+"requestlevel",requestlevel);
    session.setAttribute(userid+"_"+requestid+"creater",""+userid);
    session.setAttribute(userid+"_"+requestid+"workflowid",""+workflowid);
    session.setAttribute(userid+"_"+requestid+"nodeid",""+nodeid);
    session.setAttribute(userid+"_"+requestid+"nodetype",nodetype);
    session.setAttribute(userid+"_"+requestid+"workflowtype",workflowtype);
    session.setAttribute(userid+"_"+requestid+"formid",""+formid);
    session.setAttribute(userid+"_"+requestid+"billid",""+billid);
    session.setAttribute(userid+"_"+requestid+"isbill",""+isbill);
 // System.out.println("&&&&&&&&&&&&495&&&&&&&&&&&&&&&&&user="+user.getUID());
    //topage = URLEncoder.encode("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&docfileid="+adddocfieldid+"&topage="+topage);
    String notencoderToPage = "/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&docfileid="+adddocfieldid+"&topage="+topage+"&urger="+urger+"&isintervenor="+isintervenor;
    topage = URLEncoder.encode(notencoderToPage);
    if (addMethod.equals("docnew_")){
        //解决流程中同时存在正文与多文档时， 先新建正在，在新建多文档时，新建的文档会覆盖正文的问题
        session.removeAttribute("doc_topage");
		//response.sendRedirect("/docs/docs/DocList.jsp?topage="+topage);
		//response.sendRedirect("/docs/docs/DocList.jsp?isOpenNewWind=0&topage="+topage);
		
    	if(needoutprint.equals("")) out.print("<script>"+prefix+"wfforward('/docs/docs/DocList.jsp?hasTab=1&workflowid="+workflowid+"&isOpenNewWind=0&topage="+topage+"');</script>");
    }else{
        topage += "&fromFlowDoc=1";
        topage = URLEncoder.encode(notencoderToPage);
//add by fanggsh 2007-03-23  for TD6247  调整为：在流程中以TAB页形式打开相关文档时才保存流程与模板对应数据  开始


		if (docFlag) RequestDoc.changeDocFiled(""+workflowid,""+requestid,fu,user.getLanguage(),havaChage);  //如果改变了发文目录

		String docCodeForRequestOperation=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"docCodeForRequestOperation"));
		String docSubjectForRequestOperation=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"docSubjectForRequestOperation"));
		session.removeAttribute(userid+"_"+requestid+"docCodeForRequestOperation");
		session.removeAttribute(userid+"_"+requestid+"docSubjectForRequestOperation");
		session.removeAttribute("docCodeForRequestOperation");
		session.removeAttribute("docSubjectForRequestOperation");

//add by fanggsh 2007-03-23  for TD6247  调整为：在流程中以TAB页形式打开相关文档时才保存流程与模板对应数据  结束

		session.removeAttribute("doc_topage"); 
		String docId=Util.null2String(fu.getParameter("docValue"));
		ArrayList flowDocs=RequestDoc.getDocFiled(""+workflowid);
		//RequestDoc.setRequestToModul(""+workflowid,""+requestid,user.getLanguage());
		String mainid="";
		String secid="";
		String subid="";
		ArrayList flowViewDocs=RequestDoc.getSelectItemValue(""+workflowid,""+requestid);
		if (flowDocs!=null&&flowDocs.size()>0){
			ArrayList   TempAyyay=Util.TokenizerString(""+flowDocs.get(2),"||");
			//String codeFiled=""+flowDocs.get(0);
           //String fieldName="x";
           //RecordSet.execute("select fieldname from workflow_formdict where id="+codeFiled);
           //if(RecordSet.next()){
               //fieldName=RecordSet.getString(1);
               //RecordSet.execute("select "+fieldName+" from workflow_form where requestid="+requestid);
               //if(RecordSet.next()){
			   //}
           //}
           
           if (TempAyyay!=null&&TempAyyay.size()>0)
              {
                 mainid=""+TempAyyay.get(0);
                 subid=""+TempAyyay.get(1);
                 secid=""+TempAyyay.get(2);
              }
      }
      if(flowViewDocs!=null&&flowViewDocs.size()>0){
        if(flowViewDocs.size() == 1){
	             mainid="-1";
                 subid="-1";
                 secid=""+flowViewDocs.get(0);
        }else{
	             mainid=""+flowViewDocs.get(0);
                 subid=""+flowViewDocs.get(1);
                 secid=""+flowViewDocs.get(2);
        }
      }
      //session.setAttribute("requestname"+userid,requestname);
      //String docsubject="";
      //String docsubject1="";
      String docsubject1=docSubjectForRequestOperation;
      //if (havaChage) docsubject=docCodeForRequestOperation;
      //docsubject1=docCodeForRequestOperation;
      //if (docsubject1.equals("")){
	  //    docsubject1=docCodeForRequestOperation;
      //}
      if (docsubject1.equals("")){
	      docsubject1=requestname;
      }
      //else
      //{
      // if (havaChage) RequestDoc.setCodeToRequest(""+workflowid,""+requestid,docsubject);
      //}

      docsubject1=Util.StringReplace(docsubject1,"<br>","");    	        	    
      docsubject1=Util.StringReplace(docsubject1,"&lt;br&gt;","");

      session.setAttribute("docsubject"+userid,docsubject1);
      session.setAttribute("docCode"+userid,docCodeForRequestOperation);
      session.setAttribute(userid+"_"+requestid+"docsubject",docsubject1);
      session.setAttribute(userid+"_"+requestid+"docCode",docCodeForRequestOperation);

      if(needoutprint.equals("")) out.print("<script>try{"+prefix+"parent.document.weaver.requestIdDoc.value="+requestid+";}catch(e){}</script>");
      out.print("<script>try{"+prefix+"parent.document.all(\"requestid\").value="+requestid+";}catch(e){}</script>");
      
      session.setAttribute(userid+"_"+requestid+"coadCanSubmit", "true");
      session.setAttribute(userid+"_"+requestid+"IsCanSubmit", "true");
      String docView=Util.null2String(fu.getParameter("docView"));

      if (docView.equals("")) docView="0";
	
      if (docId.equals("")){
		  session.setAttribute("doc_topage",URLDecoder.decode(topage));

		  String defaultDocType="1";
		  String docType=".doc";
		  if(flowDocs.size()>=8){
			  defaultDocType=Util.null2String((String)flowDocs.get(7));
		  }
		  if(defaultDocType.equals("2")){
			  docType=".wps";
		  }else{
			  docType=".doc";
		  }

		  //out.print("<script>location.href=\"/docs/docs/DocAddExt.jsp?fromFlowDoc=1&topage="+topage+"&mainid="+mainid+"&secid="+secid+"&subid="+subid+"&docId="+docId+"&requestid="+requestid+"\"</script>");
		  if(needout){
			  //System.out.println("&&&&&&&&&&&&5982&&&&&&&&&&&&&&&&&user="+user.getUID());
		      if(needoutprint.equals("")) out.print("<script>"+prefix+"parent.location.href=\"ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&isintervenor="+isintervenor+"\"</script>");
		  }
		  out.print("<script>setDocUrl('/docs/docs/DocAddExt.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&fromFlowDoc=1&topage="+topage+"&mainid="+mainid+"&secid="+secid+"&subid="+subid+"&docId="+docId+"&requestid="+requestid+"&isintervenor="+isintervenor+"&docType="+docType+"')</script>");
		  session.setAttribute(requestid + "_wfdoc","/docs/docs/DocAddExt.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&fromFlowDoc=1&topage="+topage+"&mainid="+mainid+"&secid="+secid+"&subid="+subid+"&docId="+docId+"&requestid="+requestid+"&isintervenor="+isintervenor+"&docType="+docType);
		  session.setAttribute(rand + "_wfdoc","/docs/docs/DocAddExt.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&fromFlowDoc=1&topage="+topage+"&mainid="+mainid+"&secid="+secid+"&subid="+subid+"&docId="+docId+"&requestid="+requestid+"&isintervenor="+isintervenor+"&docType="+docType);
		  return;
          
      }else{
		  //更新为文档的最新版本 开始

		  int newDocId=0;
		  RecordSet.executeSql("select max(id) from DocDetail where id>"+docId+" and docEditionId>0 and exists(select 1 from DocDetail a where a.id="+docId+" and a.docEditionId=DocDetail.docEditionId )");
		  if(RecordSet.next()){
			  newDocId=Util.getIntValue(RecordSet.getString(1),-1);
		  }
		  if(newDocId>0){
			  docId=""+newDocId;
			  RequestDoc.setDocIdToRequest(String.valueOf(workflowid),String.valueOf(requestid),String.valueOf(newDocId));
		      if (flowDocs!=null&&flowDocs.size()>0){
				  out.print("<script>try{"+prefix+"parent.document.getElementById(\"field"+Util.getIntValue((String)flowDocs.get(1),-1)+"\").value="+newDocId+";}catch(e){}</script>");
			  }
		  }
		  //更新为文档的最新版本 结束
		  if (docView.equals("0")){
			  session.setAttribute("temp_doc_topage",URLDecoder.decode(topage));
			  //out.print("<script>location.href=\"/docs/docs/DocDspExt.jsp?fromFlowDoc=1&topage="+topage+"&mainid="+mainid+"&secid="+secid+"&subid="+subid+"&id="+docId+"&requestid="+requestid+"\"</script>");
			  //out.print("<script>location.href=\"/docs/docs/DocDspExt.jsp?fromFlowDoc=1&topage="+topage+"&mainid="+mainid+"&secid="+secid+"&subid="+subid+"&id="+docId+"&requestid="+requestid+"&isNoTurnWhenHasToPage=true\"</script>");			  
			  if(needout){
				//  System.out.println("&&&&&&&&&&&&625&&&&&&&&&&&&&&&&&user="+user.getUID());
			  	  if(needoutprint.equals("")) out.print("<script>"+prefix+"parent.location.href=\"ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&isintervenor="+isintervenor+"\"</script>");
			  }
		  	  out.print("<script>setDocUrl('/docs/docs/DocDspExt.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&fromFlowDoc=1&topage="+topage+"&mainid="+mainid+"&secid="+secid+"&subid="+subid+"&id="+docId+"&requestid="+requestid+"&isNoTurnWhenHasToPage=true&isintervenor="+isintervenor+"')</script>");
			  session.setAttribute(requestid+"_wfdoc","/docs/docs/DocDspExt.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&fromFlowDoc=1&topage="+topage+"&mainid="+mainid+"&secid="+secid+"&subid="+subid+"&id="+docId+"&requestid="+requestid+"&isNoTurnWhenHasToPage=true&isintervenor="+isintervenor);
			  session.setAttribute(rand+"_wfdoc","/docs/docs/DocDspExt.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&fromFlowDoc=1&topage="+topage+"&mainid="+mainid+"&secid="+secid+"&subid="+subid+"&id="+docId+"&requestid="+requestid+"&isNoTurnWhenHasToPage=true&isintervenor="+isintervenor);
		
		  }else{
			  session.setAttribute("doc_topage",URLDecoder.decode(topage));
/*            if (havaChage) {
			  if (docsubject.equals("")){
				  RecordSet.execute("update docdetail set maincategory="+mainid+",subcategory="+subid+" ,seccategory="+secid+" where id="+docId);
			  }else{
				  RecordSet.execute("update docdetail set docsubject='"+docsubject+"',maincategory="+mainid+",subcategory="+subid+" ,seccategory="+secid+" where id="+docId);
			  }
			  DocComInfo.updateDocInfoCache(""+docId);
			  }*/
			  if(iscreate.equals("1")&&!docId.equals("")){//在创建节点选择了文档，则将文档编号赋给流程字段
			      String docCodeForDocId="";
                  RecordSet.execute("select docCode from DocDetail where id="+Util.getIntValue(docId,-1));
                  if(RecordSet.next()){
					  docCodeForDocId=Util.null2String(RecordSet.getString("docCode")); 
                  }
                  if(!docCodeForDocId.equals("")){
					  RequestDoc.setCodeToRequest(""+workflowid,""+requestid,docCodeForDocId);	
                  }
			  }
			  //out.print("<script>location.href=\"/docs/docs/DocEditExt.jsp?fromFlowDoc=1&topage="+topage+"&mainid="+mainid+"&secid="+secid+"&subid="+subid+"&id="+docId+"&requestid="+requestid+"\"</script>");
			  if(needout){
				//  System.out.println("&&&&&&&&&&&&653&&&&&&&&&&&&&&&&&user="+user.getUID());
			  	  if(needoutprint.equals("")) out.print("<script>"+prefix+"parent.location.href=\"ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&isintervenor="+isintervenor+"\"</script>");
			  }
		  	  out.print("<script>setDocUrl('/docs/docs/DocEditExt.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&fromFlowDoc=1&topage="+topage+"&mainid="+mainid+"&secid="+secid+"&subid="+subid+"&id="+docId+"&requestid="+requestid+"&isintervenor="+isintervenor+"')</script>");
			  session.setAttribute(requestid+"_wfdoc","/docs/docs/DocEditExt.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&fromFlowDoc=1&topage="+topage+"&mainid="+mainid+"&secid="+secid+"&subid="+subid+"&id="+docId+"&requestid="+requestid+"&isintervenor="+isintervenor);
			  session.setAttribute(rand+"_wfdoc","/docs/docs/DocEditExt.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&fromFlowDoc=1&topage="+topage+"&mainid="+mainid+"&secid="+secid+"&subid="+subid+"&id="+docId+"&requestid="+requestid+"&isintervenor="+isintervenor);
		  }
		  return;
      }
    }
//  showsubmit 为0的时候新建文档将不显示提交按钮  response.sendRedirect("/docs/docs/DocList.jsp?topage="+topage+"&showsubmit=0");
}


%>