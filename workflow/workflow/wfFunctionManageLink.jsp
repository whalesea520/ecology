<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.net.*,weaver.workflow.workflow.WfFunctionManageUtil" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.workflow.request.RequestAnnexUpload" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.workflow.RequestForceDrawBack"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.conn.RecordSet" %>
<%@ page import="weaver.cpt.util.CptWfUtil" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="WfForceOver" class="weaver.workflow.workflow.WfForceOver" scope="page"/>
<jsp:useBean id="WfForceDrawBack" class="weaver.workflow.workflow.WfForceDrawBack" scope="page"/>
<jsp:useBean id="WfFunctionManageUtil" class="weaver.workflow.workflow.WfFunctionManageUtil" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page"/>
<jsp:useBean id="TestWorkflowCheck" class="weaver.workflow.workflow.TestWorkflowCheck" scope="page"/>
<jsp:useBean id="Monitor" class="weaver.workflow.monitor.Monitor" scope="page" />
<%
boolean isfrommobile = "1".equals(Util.null2String(request.getParameter("isformmobile")));
String redirectPage = "/workflow/request/ViewRequest.jsp";
if (isfrommobile) {
    redirectPage = "/mobile/plugin/1/view.jsp";    
}

String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
 user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
 
 
    //初始化 
    RequestForceDrawBack requestForceDrawBack = new RequestForceDrawBack();
 
    String fromflow = Util.null2String(request.getParameter("fromflow"));
    String flag = Util.null2String(request.getParameter("flag"));
    String remark = Util.null2String(request.getParameter("remark"));
    String batch = Util.null2String(request.getParameter("batch"));
    String requestids[] = request.getParameterValues("requestids");
    int requestid = Util.getIntValue(request.getParameter("requestid"), 0);
    String signdocids = Util.null2String(request.getParameter("signdocids"));
    String signworkflowids = Util.null2String(request.getParameter("signworkflowids"));
    int requestLogId = Util.getIntValue(request.getParameter("workflowRequestLogId"),0);
    String requestfrom = Util.null2String(request.getParameter("requestfrom"));
    String annexdocids = "";
	int requestidvalue = Util.getIntValue(request.getParameter("requestidvalue"));
	if(requestidvalue > 0){
		requestid = requestidvalue;
	}
    /*这里记录下所有需要回传回去的查询参数值 Start*/
    String paraStr = "fromself=1";
    if("mo".equals(requestfrom)){
	    StringBuffer paramBuffer = new StringBuffer();
	    Enumeration enumeration =  request.getParameterNames();
	    while(enumeration.hasMoreElements()){
	        String parametername = enumeration.nextElement().toString();
	        if(parametername.endsWith("_")){
	            continue;
	        }
	        String parametervalue = Util.null2String(request.getParameter(parametername),"");
	        if("".equals(parametervalue)){
	            continue;
	        }
	        paramBuffer.append("&").append(parametername).append("=").append(URLEncoder.encode(parametervalue,"UTF-8"));
	    }
	    if(paramBuffer.length() > 0){
		    paraStr += paramBuffer.toString();
	    }
    }
	String remarkLocation = Util.null2String(request.getParameter("remarkLocation"));
	/*这里记录下所有需要回传回去的查询参数值 End*/
	int formid =0;
    if (fromflow.equals("1")) {
        FileUpload fu = new FileUpload(request);
		 f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
		 f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
		 user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
        remark = Util.null2String(fu.getParameter("remark"));
        int workflowid = Util.getIntValue(fu.getParameter("workflowid"), -1);
        int nodeid = Util.getIntValue(fu.getParameter("nodeid"), -1);
        formid = Util.getIntValue(fu.getParameter("formid"),-1);
        requestid = Util.getIntValue(fu.getParameter("requestid"), 0);
        requestLogId = Util.getIntValue(fu.getParameter("workflowRequestLogId"),0);
        //获取签字意见相关文档，相关流程

        signdocids = Util.null2String(fu.getParameter("signdocids"));
        signworkflowids = Util.null2String(fu.getParameter("signworkflowids"));
        String ismode = "";
        RecordSet.executeSql("select ismode from workflow_flownode where workflowid=" + workflowid + " and nodeid=" + nodeid);
        if (RecordSet.next()) {
            ismode = Util.null2String(RecordSet.getString("ismode"));
        }
        if (!ismode.equals("1")) {
            RequestAnnexUpload rau = new RequestAnnexUpload();
            rau.setRequest(fu);
            rau.setUser(user);
            annexdocids = rau.AnnexUpload();
        } else {
            String hasSign = "0";//模板中是否设置了签字
            RecordSet.executeSql("select * from workflow_modeview where formid=" + formid + " and nodeid=" + nodeid + " and fieldid=-4");
            if (RecordSet.next()) hasSign = "1";
            if ("1".equals(hasSign)) {//模板中设置了签字
                annexdocids = Util.null2String(fu.getParameter("qianzi"));
            } else {//模板中没有设置签字，按普通方式上传签字意见的附件
                RequestAnnexUpload rau = new RequestAnnexUpload();
                rau.setRequest(fu);
                rau.setUser(user);
                annexdocids = rau.AnnexUpload();
            }
        }
    }
    int userid = user.getUID();
    int logintype = Util.getIntValue(user.getLogintype());
    int usertype = (user.getLogintype().equals("1")) ? 0 : 1;
    ArrayList requestidsArr = new ArrayList();
    int workflowid = -1;
    int nodeid = -1;
    int nodeid_rb = -1;
    RecordSet.executeProc("workflow_Requestbase_SByID", requestid + "");
    if (RecordSet.next()) {
        workflowid = Util.getIntValue(RecordSet.getString("workflowid"), 0);
        nodeid = Util.getIntValue(RecordSet.getString("currentnodeid"), 0);
    }
    RecordSet.executeSql("select formid from workflow_base where id='"+workflowid+"'");
    if (RecordSet.next()) {
    	formid = Util.getIntValue(RecordSet.getString("formid"), 0);
    }
    WfForceOver.setRemark(remark);
    WfForceOver.setAnnexdocids(annexdocids);
    WfForceOver.setSigndocids(signdocids);
    WfForceOver.setSignworkflowids(signworkflowids);
    WfForceOver.setRequestLogId(requestLogId);
    WfForceOver.setRemarkLocation(remarkLocation);
/*---------------------------查 看 或 管 理 页 面 各 项 功 能 管 理----------------------*/

//强制归档
    if ("ov".equals(flag)) {
//提交时针对流程再作一次权限判断

        //if (!WfForceOver.isOver(requestid) && (WfForceOver.isNodeOperator(requestid, userid) || WFUrgerManager.getMonitorViewRight(requestid, userid))) {
        if (WfFunctionManageUtil.haveOtherOperationRight(requestid)&&!WfForceOver.isOver(requestid) && (WfForceOver.isNodeOperator(requestid, userid) || WFUrgerManager.getMonitorViewRight(requestid, userid))) {
            requestidsArr.add("" + requestid);
            WfForceOver.doForceOver(requestidsArr, request, response);
            int currentNodeId=0;
            rs.executeSql(
				"select nodeid from workflow_flownode where workflowid = "
					+ workflowid + " and nodetype = 3");
			if (rs.next()) {
				currentNodeId = rs.getInt("nodeid");
			}
            if("1".equals((String) session.getAttribute("istest"))) out.print(TestWorkflowCheck.gotoNextNode(session,"ov",user, "0", workflowid,requestid,currentNodeId,""));
            else out.print("<script>wfforward('" + redirectPage + "?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&requestid=" + requestid + "&fromoperation=1&updatePoppupFlag=1');</script>");
          //  return;
        } else {
            //response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid=" + requestid + "&fromoperation=1&updatePoppupFlag=1&infoKey=ovfail");
            out.print("<script>wfforward('" + redirectPage + "?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&requestid=" + requestid + "&fromoperation=1&updatePoppupFlag=1&infoKey=ovfail');</script>");
          //  return;
        }
        releaseNumber( formid, workflowid);
        return;
    }

//强制收回
    if ("rb".equals(flag)) {
//提交时针对流程再作一次权限判断
        if (WfFunctionManageUtil.haveOtherOperationRight(requestid)&&WfForceDrawBack.isHavePurview(requestid, userid, logintype, -1, -1)) {
            requestidsArr.add("" + requestid);
            //WfForceDrawBack.doForceDrawBack(requestidsArr, request, response, -1, -1);
            //使用新的收回方式
            int result = requestForceDrawBack.foreceDrawBack(user, requestid, false, -1, -1);
            if (result == requestForceDrawBack.OLDDATA) {
                WfForceDrawBack.doForceDrawBack(requestidsArr, request, response, -1, -1);
            }
			WfForceDrawBack.wfCancleOperatorAgent(requestid, userid, workflowid, 0, true);
            releaseNumber( formid, workflowid);
            //response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid=" + requestid + "&fromoperation=1&updatePoppupFlag=1");
			out.print("<script>parent.window.opener._table.reLoad();</script>");
            out.print("<script>wfforward('" + redirectPage + "?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&requestid=" + requestid + "&fromoperation=1&updatePoppupFlag=1');</script>");
            return;
        } else {
			out.print("<script>parent.window.opener._table.reLoad();</script>");
        	out.print("<script>wfforward('" + redirectPage + "?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&requestid=" + requestid + "&fromoperation=1&updatePoppupFlag=1&infoKey=rbfail');</script>");
            return;        	
        }
    }
  //流程暂停
    if ("stop".equals(flag)) 
    {
    	WfFunctionManageUtil.setStopOperation(requestid,user);
        if(requestfrom.equals("mo"))
        {
           
        	response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitorList.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&"+paraStr);
    		return;
        }
        else
        {
        	//out.print("<script>alert('"+SystemEnv.getHtmlLabelName(26154,user.getLanguage())+"');setTimeout('top.window.close()',1);</script>");
        	out.print("<script>wfforward('" + redirectPage + "?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&requestid=" + requestid + "&fromoperation=1&updatePoppupFlag=1');</script>");
        	return;
        }
    }
    //流程撤销
    if ("cancel".equals(flag)) 
    {
    	WfFunctionManageUtil.setCancelOperation(requestid,user);
        if(requestfrom.equals("mo"))
        {
        	response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitorList.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&"+paraStr);
    		return;
        }
        else
        {
        	//out.print("<script>alert('"+SystemEnv.getHtmlLabelName(26155,user.getLanguage())+"');setTimeout('top.window.close()',1);</script>");
        	out.print("<script>wfforward('" + redirectPage + "?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&requestid=" + requestid + "&fromoperation=1&updatePoppupFlag=1');</script>");
        	return;
        }
    }
    //流程启用
    if ("restart".equals(flag)) 
    {
    	WfFunctionManageUtil.setRestartOperation(requestid,user);
        if(requestfrom.equals("mo"))
        {
        	response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitorList.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&"+paraStr);
    		return;
        }
        else
        {
        	out.print("<script>wfforward('" + redirectPage + "?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&requestid=" + requestid + "&fromoperation=1&updatePoppupFlag=1');</script>");
        	return;
        }
    }

/*----------------------------------监 控 页 面 各 项 功 能 管 理-------------------------------*/

//强制归档
    if ("ovm".equals(flag)) {
        if ("1".equals(batch)) {//批量
//批量提交时针对流程再作一次权限判断

            if (requestids != null) {
                for (int i = 0; i < requestids.length; i++) {
                	requestid = Util.getIntValue((String)requestids[i],0);
                    if (WfFunctionManageUtil.haveOtherOperationRight(requestid)&&!WfForceOver.isOver(requestid)) {
                        requestidsArr.add(requestids[i]);
                    }
                    releaseNumber( formid, workflowid);
                }
                WfForceOver.doForceOver(requestidsArr, request, response);
            }
            response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitorList.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&"+paraStr);
            return;
        } else {
//非批量提交时针对流程再作一次权限判断

            if (WfFunctionManageUtil.haveOtherOperationRight(requestid)&&!WfForceOver.isOver(requestid)) {
                requestidsArr.add("" + requestid);
                WfForceOver.doForceOver(requestidsArr, request, response);
                response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitorList.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&"+paraStr);
               // return;
            } else {
                response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitorList.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&infoKey=ovfail&"+paraStr);
              //  return;
            }
            releaseNumber( formid, workflowid);
            return;
        }
    }
    //强制归档，来自/system/systemmonitor/workflow/WorkflowMonitor.jsp的批量强制归档

    if ("ovmwfm".equals(flag)) {
    	String multiRequestIds = Util.null2String(request.getParameter("multiRequestIds"));
    	requestids = Util.TokenizerString2(multiRequestIds, ",");
		if (requestids != null) {
		    for (int i = 0; i < requestids.length; i++) {
		    	int requestid_tmp = Util.getIntValue(requestids[i]);
		    	if(!WfFunctionManageUtil.haveOtherOperationRight(requestid_tmp))
		    	{
		    		continue;
		    	}
		    	boolean isForceOver=false;
		    	rs.execute("select creater,workflowid from workflow_requestbase where requestid = " + requestid_tmp);
		        rs.next();
		        String creater = rs.getString(1);
		        int workflowid_rs = rs.getInt(2);
		        
		        weaver.workflow.monitor.MonitorDTO dto = Monitor.getMonitorInfo(user.getUID()+"",creater,workflowid_rs+"");
		        isForceOver = dto.getIsforceover();
		        
		        WfFunctionManageUtil wfFunctionManageUtil=new WfFunctionManageUtil();
		        //HashMap map = wfFunctionManageUtil.wfFunctionManageAsMonitor(workflowid_rs);
		        //String ov = (String)map.get("ov");
		        if (isForceOver && !WfForceOver.isOver(requestid_tmp)) {
		            requestidsArr.add(requestids[i]);
		        }
		    }
		    WfForceOver.doForceOver(requestidsArr, request, response);
		}
		response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitorList.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&"+paraStr);
		releaseNumber( formid, workflowid);
		return;
    }

//强制收回
    if ("rbm".equals(flag)) {
        int tempuser = -1;
        int tempusertype = 0;
		int tempworkflowid = 0;

        if ("1".equals(batch)) {//批量
//批量提交时针对流程再作一次权限判断

            if (requestids != null) {
                for (int i = 0; i < requestids.length; i++) {
                    requestidsArr = new ArrayList();
                    //从日志中去找最后一个操作者

                    //RecordSet.executeSql("select max(logid), operator,operatortype from workflow_requestlog where requestid=" + requestids[i] + " and (logtype='2' or logtype='0' or logtype='3' or logtype='e') and exists(select 1 from workflow_currentoperator where requestid=workflow_requestlog.requestid and userid=workflow_requestlog.operator and usertype=workflow_requestlog.operatortype and isremark='2' and preisremark='0' and operatedate is not null and operatedate>' ') group by operator,operatortype order by max(logid) desc");
					RecordSet.executeSql("select max(logid), operator,operatortype,workflowid from workflow_requestlog where requestid=" + requestids[i] + " and (logtype='2' or logtype='0' or logtype='3' or logtype='e' ) and exists(select 1 from workflow_currentoperator where requestid=workflow_requestlog.requestid and userid=workflow_requestlog.operator and usertype=workflow_requestlog.operatortype and isremark='2' and preisremark='0' and operatedate is not null and operatedate>' ') group by operator,operatortype,workflowid order by max(logid) desc");
                    if (RecordSet.next()) {
                        tempuser = Util.getIntValue(RecordSet.getString("operator"));
                        tempusertype = Util.getIntValue(RecordSet.getString("operatortype"), 0);
						tempworkflowid = Util.getIntValue(RecordSet.getString("workflowid"), 0);
                    }else{
                        //RecordSet.executeSql("select userid,usertype from workflow_currentoperator where requestid = " + requestids[i] + " and isremark = '2' and preisremark='0' and operatedate is not null and operatedate>' ' order by operatedate desc ,operatetime desc");
						RecordSet.executeSql("select userid,usertype,workflowid from workflow_currentoperator where requestid = " + requestids[i] + " and isremark = '2' and preisremark='0' and operatedate is not null and operatedate>' ' order by operatedate desc ,operatetime desc");
                        if (RecordSet.next()) {
                            tempuser = RecordSet.getInt("userid");
                            tempusertype = RecordSet.getInt("usertype");
							tempworkflowid = Util.getIntValue(RecordSet.getString("workflowid"), 0);
                        }
                    }
                    if (WfFunctionManageUtil.haveOtherOperationRight(Integer.parseInt(requestids[i]))&&WfForceDrawBack.isHavePurview(Integer.parseInt(requestids[i]), userid, logintype, tempuser, tempusertype)) {
                        requestidsArr.add(requestids[i]);
                        //WfForceDrawBack.doForceDrawBack(requestidsArr, request, response, tempuser, tempusertype);
                        int result = requestForceDrawBack.foreceDrawBack(user, requestid, true, tempuser, tempusertype);
                        if (result == requestForceDrawBack.OLDDATA) {
                            WfForceDrawBack.doForceDrawBack(requestidsArr, request, response, tempuser, tempusertype);
                        }
						WfForceDrawBack.wfCancleOperatorAgent(Integer.parseInt(requestids[i]), userid, tempworkflowid, 0, true);
                    }
                }
            }
            releaseNumber( formid, workflowid);
            response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitorList.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&"+paraStr);
            return;
        } else {
//非批量提交时针对流程再作一次权限判断

			//从日志中去找最后一个操作者

            RecordSet.executeSql("select max(logid), operator,operatortype from workflow_requestlog where requestid=" + requestid + " and (logtype='2' or logtype='0' or logtype='3') and exists(select 1 from workflow_currentoperator where requestid=workflow_requestlog.requestid and userid=workflow_requestlog.operator and usertype=workflow_requestlog.operatortype and isremark='2' and preisremark='0' and operatedate is not null and operatedate>' ') group by operator,operatortype order by max(logid) desc");
            if (RecordSet.next()) {
                tempuser = Util.getIntValue(RecordSet.getString("operator"));
                tempusertype = Util.getIntValue(RecordSet.getString("operatortype"), 0);
            }else{
                RecordSet.executeSql("select userid,usertype from workflow_currentoperator where requestid = " + requestid + " and isremark = '2' and preisremark='0' and operatedate is not null and operatedate>' ' order by operatedate desc ,operatetime desc");
                if (RecordSet.next()) {
                    tempuser = RecordSet.getInt("userid");
                    tempusertype = RecordSet.getInt("usertype");
                }
            }
            if (WfFunctionManageUtil.haveOtherOperationRight(requestid)&&WfForceDrawBack.isHavePurview(requestid, userid, logintype, tempuser, tempusertype)) {
                requestidsArr.add("" + requestid);
                //WfForceDrawBack.doForceDrawBack(requestidsArr, request, response, tempuser, tempusertype);
                int result = requestForceDrawBack.foreceDrawBack(user, requestid, true, tempuser, tempusertype);
                if (result == requestForceDrawBack.OLDDATA) {
                    WfForceDrawBack.doForceDrawBack(requestidsArr, request, response, tempuser, tempusertype);
                }
				WfForceDrawBack.wfCancleOperatorAgent(requestid, userid, workflowid, 0, true);
                releaseNumber( formid, workflowid);
                response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitorList.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&"+paraStr);
                return;
            } else {
                response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitorList.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&infoKey=rbfail&"+paraStr);
                return;
            }
        }

    }
    //流程暂停
    if ("mostop".equals(flag)) 
    {
    	String multiRequestIds = Util.null2String(request.getParameter("multiRequestIds"));
    	requestids = Util.TokenizerString2(multiRequestIds, ",");
    	if (requestids != null) {
            for (int i = 0; i < requestids.length; i++) 
            {
            	requestid = Util.getIntValue((String)requestids[i],-1);
            	if(requestid<1)
            	{
            		continue;
            	}
            	WfFunctionManageUtil.setStopOperation(requestid,user);
            }
        }
    	
        response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitorList.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&"+paraStr);
        return;
    }
    //流程撤销
    if ("mocancel".equals(flag)) 
    {
    	String multiRequestIds = Util.null2String(request.getParameter("multiRequestIds"));
    	requestids = Util.TokenizerString2(multiRequestIds, ",");
    	if (requestids != null) {
            for (int i = 0; i < requestids.length; i++) 
            {
            	requestid = Util.getIntValue((String)requestids[i],-1);
            	if(requestid<1)
            	{
            		continue;
            	}
            	WfFunctionManageUtil.setCancelOperation(requestid,user);
            }
    	}
        response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitorList.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&"+paraStr);
        return;
    }
    //流程启用
    if ("morestart".equals(flag)) 
    {
    	String multiRequestIds = Util.null2String(request.getParameter("multiRequestIds"));
    	requestids = Util.TokenizerString2(multiRequestIds, ",");
    	if (requestids != null) {
            for (int i = 0; i < requestids.length; i++) 
            {
            	requestid = Util.getIntValue((String)requestids[i],-1);
            	if(requestid<1)
            	{
            		continue;
            	}
            	WfFunctionManageUtil.setRestartOperation(requestid,user);
            }
    	}
        response.sendRedirect("/system/systemmonitor/workflow/WorkflowMonitorList.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&"+paraStr);
        return;
    }
%>
<%!

	public void releaseNumber(int formid,int workflowid){

		RecordSet rs = new RecordSet();
		//这里判断是否是自定义资产的流程，如果是，就撤回
		CptWfUtil cptWfUtil = new CptWfUtil();
		String cptwftype = cptWfUtil.getWftype("" + workflowid);
		if (!"".equals(cptwftype) && !"apply".equalsIgnoreCase(cptwftype)) {
			rs.executeSql("update CptCapital set frozennum = 0 where isdata='2' ");
		}else if (formid==19||formid==201||formid==220||formid==220) {
		    rs.executeSql("update CptCapital set frozennum = 0 where isdata='2' ");
		}
	
	}


%>
