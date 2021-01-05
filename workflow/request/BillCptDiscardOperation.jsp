<%@ page import="java.math.BigDecimal"%>
<%@ page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CptShare" class="weaver.cpt.capital.CptShare" scope="page" />
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSetTrans" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>
<%@ page import="weaver.file.FileUpload" %>
<%
FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;
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
String requestname = Util.fromScreen(fu.getParameter("requestname"),user.getLanguage());
String requestlevel = Util.fromScreen(fu.getParameter("requestlevel"),user.getLanguage());
String messageType =  Util.fromScreen(fu.getParameter("messageType"),user.getLanguage());
String chatsType =  Util.fromScreen(fu.getParameter("chatsType"),user.getLanguage());
String remark = Util.null2String(fu.getParameter("remark"));
String[] check_node_vals = fu.getParameterValues("check_node_val");
if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
    //response.sendRedirect("/notice/RequestError.jsp");
    out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
    return ;
}

String ismode="";
RecordSet.executeSql("select ismode,showdes,printdes from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
    ismode=Util.null2String(RecordSet.getString("ismode"));
}
int rowsum = Util.getIntValue(Util.null2String(fu.getParameter("nodesnum")));
if(ismode.equals("1")){//图形化模式下的取值，只有一个明细组，取nodesnum0
	rowsum = Util.getIntValue(Util.null2String(fu.getParameter("nodesnum0")));
}
if(check_node_vals!=null &&( rowsum>check_node_vals.length)){
	rowsum=check_node_vals.length;
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
RequestManager.setChatsType(chatsType) ;
boolean savestatus = RequestManager.saveRequestInfo() ;
requestid = RequestManager.getRequestid() ;
if( !savestatus ) {
    if( requestid != 0 ) {

        String message=RequestManager.getMessage();
        if(!"".equals(message)){
        	out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message="+message+"');</script>");
            return ;
        }

        //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1");
        out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=1');</script>");
        return ;
    }
    else {
        //response.sendRedirect("/workflow/request/RequestView.jsp?message=1");
		out.print("<script>wfforward('/workflow/request/RequestView.jsp?message=1');</script>");
        return ;
    }
}

char flag = 2; 
if(!ismode.equals("1")&&(src.equals("save") || src.equals("submit"))) {// 保存修改明细表信息
	if( !iscreate.equals("1") ) RecordSet.executeSql("delete from bill_Discard_Detail where detailrequestid =" + requestid);
  else{
  	requestid = RequestManager.getRequestid();
  }
	if(check_node_vals!=null &&check_node_vals.length>0 ){
		for(int i=0;i<check_node_vals.length;i++) {
			String idval = check_node_vals[i];
			int capitalid = Util.getIntValue(Util.null2String(fu.getParameter("node_"+idval+"_capitalid")),0);//报废资产
			String number = Util.null2String(fu.getParameter("node_"+idval+"_number"));//数量
			if (number.equals("")) number="0";
			String needdate = Util.null2String(fu.getParameter("node_"+idval+"_needdate"));//报废日期
			String fee = Util.null2String(fu.getParameter("node_"+idval+"_fee"));//相关费用
			if(fee.equals("")) fee = "0";
			String desc = Util.null2String(fu.getParameter("node_"+idval+"_remark"));//备注
			String para = ""+requestid+flag+capitalid+flag+number+flag+needdate+flag+fee+flag+desc;
			RecordSet.executeProc("bill_Discard_Detail_Insert",para);	
		}
		
	}
	
}

boolean flowstatus = RequestManager.flowNextNode() ;
if( !flowstatus ) {
    //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
    out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=2');</script>");
    return ;
}

//审批通过后到归档节点，更新资产表。功能相当于：资产管理-〉资产管理-〉资产报废 ==开始==
if(src.equals("submit")&&RequestManager.getNextNodetype().equals("3")){
	//int rowsum = Util.getIntValue(Util.null2String(fu.getParameter("nodesnum")));
	for(int i=0;i<rowsum;i++) {
		String capitalid = Util.null2String(fu.getParameter("node_"+i+"_capitalid"));//报废资产
		String discarddate = Util.null2String(fu.getParameter("node_"+i+"_needdate"));//报废日期
		String capitalnum = Util.null2String(fu.getParameter("node_"+i+"_number"));//数量
		String fee = Util.null2String(fu.getParameter("node_"+i+"_fee"));//相关费用
		String tempremark = Util.null2String(fu.getParameter("node_"+i+"_remark"));//备注		
		if (ismode.equals("1")) {
			capitalid = Util.null2String(fu.getParameter("field642_"+i));//资产
			capitalnum = Util.null2String(fu.getParameter("field643_"+i));//数量
			discarddate = Util.null2String(fu.getParameter("field644_"+i));//报废日期
			fee = Util.null2String(fu.getParameter("field645_"+i));//相关费用
			tempremark = Util.null2String(fu.getParameter("field646_"+i));//备注
		}
		if(capitalnum.equals("")) capitalnum = "0";
		if(fee.equals("")){
			fee = "0";
		}
		String sptcount = "";//sptcount1为1表示单独核算
		RecordSet.executeProc("CptCapital_SelectByID",capitalid);
    if(RecordSet.next()){
    	sptcount = RecordSet.getString("sptcount");
    }
		if(sptcount.equals("")) sptcount = "0";

		char separator = Util.getSeparator() ;
		String para = "";
		if(sptcount.equals("1")){
			para = capitalid;
			para +=separator+discarddate;
			para +=separator+"0";
			para +=separator+"0";
			para +=separator+"1";
			para +=separator+"";
			para +=separator+"0";
			para +=separator+"";
			para +=separator+fee;
			para +=separator+"5";
			para +=separator+tempremark;
			para +=separator+sptcount;
			RecordSet.executeProc("CptUseLogDiscard_Insert",para);
		}else{
			para = capitalid;
			para +=separator+discarddate;
			para +=separator+"0";
			para +=separator+"0";
			para +=separator+capitalnum;
			para +=separator+"";
			para +=separator+"0";
			para +=separator+"";
			para +=separator+fee;
			para +=separator+"5";
			para +=separator+tempremark;
			para +=separator+sptcount;
			
			RecordSet.executeProc("CptUseLogDiscard_Insert",para);
		}
		//获取资产的使用部门
		String CptDept_from = CapitalComInfo.getDepartmentid(capitalid);
		//获取流转记录
		 rs1.executeSql("SELECT MAX(id) AS id  FROM CptUseLog WHERE capitalid = "+capitalid+"");
		 if(rs1.next()){
		 	String id  = rs1.getString("id");
		 	rs1.executeSql("update CptUseLog set olddeptid = "+CptDept_from+" where id = "+id+"");
		 }
		CapitalComInfo.removeCapitalCache();
		
		//更新冻结数量
		/**
		BigDecimal old_frozennum = new BigDecimal("0");
		BigDecimal new_frozennum = new BigDecimal("0");
		RecordSet.executeSql("select frozennum as old_frozennum from CptCapital where id="+capitalid);
		if(RecordSet.next()){
		    String temp = Util.null2String(RecordSet.getString("old_frozennum"));
		    if(!temp.equals("")) old_frozennum = new BigDecimal(temp);
		}
		new_frozennum = old_frozennum.subtract(new BigDecimal(capitalnum));
		RecordSet.executeSql("update CptCapital set frozennum="+new_frozennum+" where id="+capitalid);
    	**/
	}
}
//审批通过后到归档节点，更新资产表。功能相当于：资产管理-〉资产管理-〉资产报废 ==结束==
//触发数据库的触发器更新冻结数量
for(int i=0;i<rowsum;i++){
	if (ismode.equals("1")) {
		float number = Util.getFloatValue(fu.getParameter("field643_"+i),0);//数量
		if (number <= 0) number=0;
		int capitalid = Util.getIntValue(Util.null2String(fu.getParameter("field642_"+i)),0);
		RecordSet.executeSql("update CptCapital set frozennum = 0 where id="+capitalid);
	} else {
		float number = Util.getFloatValue(fu.getParameter("node_"+i+"_number"),0);//领用数量
		if (number <= 0) number=0;
		int capitalid = Util.getIntValue(Util.null2String(fu.getParameter("node_"+i+"_capitalid")),0);
		if(!"save".equals(src)){
			RecordSet.executeSql("update CptCapital set frozennum = 0 where id="+capitalid);
		}
	}
	
}

boolean logstatus = RequestManager.saveRequestLog() ;
WFManager.setWfid(workflowid);
WFManager.getWfInfo();
String isShowChart = Util.null2String(WFManager.getIsShowChart());
if ("1".equals(isShowChart)) {
	out.print("<script>wfforward('/workflow/request/WorkflowDirection.jsp?requestid=" + requestid + "&workflowid=" + workflowid + "&isbill=" + isbill + "&formid=" + formid+"');</script>");
} else{
	%>
	<%@ include file="/workflow/request/RedirectPage.jsp" %> 
	<%
	
	//out.print("<script>wfforward('/workflow/request/RequestView.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"');</script>");
}

//response.sendRedirect("/workflow/request/RequestView.jsp");
%>