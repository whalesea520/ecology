<%@ page import="weaver.general.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CptShare" class="weaver.cpt.capital.CptShare" scope="page" />
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
String updateclause = "" ;
String ismode="";
RecordSet.executeSql("select ismode,showdes,printdes from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
    ismode=Util.null2String(RecordSet.getString("ismode"));
}

// add record into bill_CptApplyDetail
if(!ismode.equals("1")&&(src.equals("save") || src.equals("submit"))) {      // 修改细表和主表信息
	if( !iscreate.equals("1") ) RecordSet.executeSql("delete from bill_CptAdjustDetail where cptadjustid =" + billid);
    else {
        requestid = RequestManager.getRequestid() ;
        billid = RequestManager.getBillid() ;
    }

	int rowsum = Util.getIntValue(Util.null2String(fu.getParameter("nodesnum")));
	float totalamount =0;

	if(check_node_vals!=null && check_node_vals.length>0){
		for(int i=0;i<check_node_vals.length;i++) {		
	  String idval = ""+i;
		if(check_node_vals!=null){
		  idval = check_node_vals[i];
		 }
		
		int cptid = Util.getIntValue(Util.null2String(fu.getParameter("node_"+idval+"_cptid")),0);
		int capitalid = Util.getIntValue(Util.null2String(fu.getParameter("node_"+idval+"_capitalid")),0);
		float number = Util.getFloatValue(fu.getParameter("node_"+idval+"_number"),0);
		//if (number <= 0) continue;
		float unitprice = Util.getFloatValue(fu.getParameter("node_"+idval+"_unitprice"),0);
		float amount = number * unitprice;
		String needdate = Util.null2String(fu.getParameter("node_"+idval+"_needdate"));
		String purpose = Util.null2String(fu.getParameter("node_"+idval+"_purpose"));
		String cptdesc = Util.null2String(fu.getParameter("node_"+idval+"_cptdesc"));		
		String para = ""+billid+flag+cptid+flag+capitalid+flag+number+flag+unitprice+flag + amount+flag+needdate+flag+purpose+flag+cptdesc;		
		RecordSet.executeProc("bill_CptAdjustDetail_Insert",para);		
		totalamount += amount;		
			}		
	}
	updateclause += " set totalamount = "+totalamount+" ";
	updateclause="update bill_CptAdjustMain "+updateclause+" where id = "+billid;
	RecordSet.executeSql(updateclause);

}

boolean flowstatus = RequestManager.flowNextNode() ;
if( !flowstatus ) {
	//response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
	out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=2');</script>");
	return ;
}

//审批通过后到归档节点，更新资产表。功能相当于：资产管理-〉资产管理-〉资产调拨 ==开始==
if(src.equals("submit")&&RequestManager.getNextNodetype().equals("3")){

	String CptDept_to = Util.null2String(fu.getParameter("field190"));//调往部门
	String hrmid = Util.null2String(fu.getParameter("field191"));//调拨申请人
    
	int rowsum = Util.getIntValue(Util.null2String(fu.getParameter("nodesnum")));
	if(ismode.equals("1")){//图形化模式下的取值，只有一个明细组，取nodesnum0
		rowsum = Util.getIntValue(Util.null2String(fu.getParameter("nodesnum0")));
	}
	for(int i=0;i<rowsum;i++){		
		String replacecapitalid = Util.null2String(fu.getParameter("node_"+i+"_capitalid"));//调拨资产 
		Calendar today = Calendar.getInstance();
		String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     		 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                         Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
    String usecount="1"; 
		String usestatus ="-4";
		String tempremark = Util.null2String(fu.getParameter("node_"+i+"_purpose"))+"/"+Util.null2String(fu.getParameter("node_"+i+"_cptdesc"));//备注=用途+描述
		if(ismode.equals("1")){
			replacecapitalid = Util.null2String(fu.getParameter("field296_"+i));//资产
			String purpose = Util.null2String(fu.getParameter("field205_"+i));//用途
			String cptdesc = Util.null2String(fu.getParameter("field206_"+i));//描述
			tempremark = purpose + "/" + cptdesc;
		}
		String CptDept_from = CapitalComInfo.getDepartmentid(replacecapitalid);//资产所属部门

		//int number = (int)Util.getFloatValue(fu.getParameter("node_"+i+"_number"),0);
		//for(int j=0;j<number;j++){
			String para = "";
	
	    para = replacecapitalid ;
	    para +=flag+currentdate;
	    para +=flag+CptDept_to;
	    para +=flag+hrmid;
	    para +=flag+usecount;
	    para +=flag+"";
	    para +=flag+usestatus;
	    para +=flag+tempremark;    
	    para +=flag+CptDept_from;
	    
		  RecordSet.executeProc("Capital_Adjust",para);
		  RecordSet.executeSql("update cptcapital set resourceid = '" + hrmid + "',departmentid = '" + CptDept_to + "' where id = '" + replacecapitalid + "'");
		  CapitalComInfo.removeCapitalCache();
		  CptShare.setCptShareByCpt(replacecapitalid);//更新detail表 
	  //}
 }
}
//审批通过后到归档节点，更新资产表。功能相当于：资产管理-〉资产管理-〉资产调拨 ==结束==

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

%>