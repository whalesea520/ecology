<%@ page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CptShare" class="weaver.cpt.capital.CptShare" scope="page" />
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSet" scope="page" />
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
String remark = Util.null2String(fu.getParameter("remark"));
String[] check_node_vals = fu.getParameterValues("check_node_val");
String chatsType =  Util.fromScreen(fu.getParameter("chatsType"),user.getLanguage());
if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
    out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
    return ;
}
ArrayList frozennumList = new ArrayList();
ArrayList capitalidList = new ArrayList();

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
        out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=1');</script>");
        return ;
    }
    else {
        out.print("<script>wfforward('/workflow/request/RequestView.jsp?message=1');</script>");
        return ;
    }
}

char flag = 2; 
String updateclause = "" ;
//只有普通模式才需要这么做，模板模式不需要处理
if(!ismode.equals("1")&&(src.equals("save") || src.equals("submit"))) {      // 修改细表和主表信息
	if( !iscreate.equals("1") ) RecordSet.executeSql("delete from bill_CptFetchDetail where cptfetchid =" + billid);
    else {
        requestid = RequestManager.getRequestid() ;
        billid = RequestManager.getBillid() ;
    }
	float totalamount =0;
	
	for(int i=0;i<rowsum;i++) {		
		String idval = ""+i;
		if(check_node_vals!=null){
			idval = check_node_vals[i];
		 }
		int cptid = Util.getIntValue(Util.null2String(fu.getParameter("node_"+idval+"_cptid")),0);
		int capitalid = Util.getIntValue(Util.null2String(fu.getParameter("node_"+idval+"_capitalid")),0);
		float number = Util.getFloatValue(fu.getParameter("node_"+idval+"_number"),0);
		float unitprice = Util.getFloatValue(fu.getParameter("node_"+idval+"_unitprice"),0);
		float amount = number * unitprice;
		String needdate = Util.null2String(fu.getParameter("node_"+idval+"_needdate"));
		String purpose = Util.null2String(fu.getParameter("node_"+idval+"_purpose"));
		String cptdesc = Util.null2String(fu.getParameter("node_"+idval+"_cptdesc"));
		String para = ""+billid+flag+cptid+flag+capitalid+flag+number+flag+unitprice+flag + amount+flag+needdate+flag+purpose+flag+cptdesc;
		RecordSet.executeProc("bill_CptFetchDetail_Insert",para);
		totalamount += amount;		
	}					
	updateclause += " set totalamount = "+totalamount+" ";
	updateclause="update bill_CptFetchMain "+updateclause+" where id = "+billid;
	RecordSet.executeSql(updateclause);
}

boolean flowstatus = RequestManager.flowNextNode() ;
if( !flowstatus ) {
	out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?f_weaver_belongto_userid="+user.getUID()+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&requestid="+requestid+"&message=2');</script>");
    return ;
}

//审批通过后到归档节点，更新资产表。功能相当于：资产管理-〉资产管理-〉资产领用 ==开始==
if(src.equals("submit")&&RequestManager.getNextNodetype().equals("3")){
	String para = "";
	
	String capitalid = "";
	String capitalnum = "";
	String resourceid = "";
	String departmentid = "";
	String tempremark = "";
	String sptcount = "";
	String location="";
	boolean isoracle = RecordSet.getDBType().equals("oracle");
	String sqltemp="";
	String useddate = "";
	
	resourceid = Util.null2String(fu.getParameter("field208"));//申请人
	departmentid = Util.null2String(fu.getParameter("field207"));//部门
	
	for(int i=0;i<rowsum;i++){
		capitalid = Util.null2String(fu.getParameter("node_"+i+"_capitalid"));//领用资产
		capitalnum = Util.null2String(fu.getParameter("node_"+i+"_number"));//领用数量
		tempremark = Util.null2String(fu.getParameter("node_"+i+"_purpose"))+"/"+Util.null2String(fu.getParameter("node_"+i+"_cptdesc"));//备注=用途+描述
		if (ismode.equals("1")) {
			capitalid = Util.null2String(fu.getParameter("field297_"+i));//资产
			capitalnum = Util.null2String(fu.getParameter("field215_"+i));//领用数量
			String purpose = Util.null2String(fu.getParameter("field219_"+i));//用途
			String cptdesc = Util.null2String(fu.getParameter("field220_"+i));//描述
			tempremark = purpose + "/" + cptdesc;
		}
		if(Util.getFloatValue(capitalnum,0)<=0) continue;

		RecordSet.executeProc("CptCapital_SelectByID",capitalid);
    if(RecordSet.next()){
    	sptcount = RecordSet.getString("sptcount");//是否单独核算
    }
	useddate = Util.null2String(fu.getParameter("node_"+i+"_needdate"));//领用日期
	if (ismode.equals("1")) {
		useddate = Util.null2String(fu.getParameter("field218_"+i));//领用日期
	}
    
    location = "";//存放地点，流程中没有此字段。

    if(!capitalid.equals("")){
    if(sptcount.equals("1")){
        para = capitalid;
        para +=flag+useddate;
        para +=flag+departmentid;
        para +=flag+resourceid;
        para +=flag+"1";
        para +=flag+"";
        para +=flag+"0";
        para +=flag+"2";
        para +=flag+tempremark;
        para +=flag+location;
        para +=flag+sptcount;

        RecordSet.executeProc("CptUseLogUse_Insert",para);
    }else{ 
        para = capitalid;
        para +=flag+useddate;
        para +=flag+departmentid;
        para +=flag+resourceid;
        para +=flag+capitalnum;
        // para +=separator+userequest; 
        para +=flag+"";    
        para +=flag+"0";  
        para +=flag+"2";
        para +=flag+tempremark;
        para +=flag+location;
        para +=flag+"0";

        RecordSet.executeProc("CptUseLogUse_Insert",para);
    }

    RecordSet.executeProc("HrmInfoStatus_UpdateCapital",""+resourceid);
    CapitalComInfo.removeCapitalCache();
    CptShare.setCptShareByCpt(capitalid);//更新detail表
    
    if(!location.equals("")){
        RecordSet.executeSql("update CptCapital set location='"+location+"' where id="+capitalid);
    }

    //更新折旧开始时间
if("1".equals(sptcount) ){
		if(!isoracle){
        sqltemp="update CptCapital set deprestartdate='"+useddate+"' where id="+capitalid+" and (deprestartdate is null or deprestartdate='')";
    }else{
        sqltemp="update CptCapital set deprestartdate='"+useddate+"' where id="+capitalid+" and deprestartdate is null";
    }
    RecordSet.executeSql(sqltemp);

}
    
    }
	}
}
//审批通过后到归档节点，更新资产表。功能相当于：资产管理-〉资产管理-〉资产领用 ==结束==
//触发数据库的触发器更新冻结数量
for(int i=0;i<rowsum;i++){
	if (ismode.equals("1")) {
		float number = Util.getFloatValue(fu.getParameter("field215_"+i),0);//领用数量
		if (number <= 0) number=0;
		int capitalid = Util.getIntValue(Util.null2String(fu.getParameter("field297_"+i)),0);
		RecordSet2.executeSql("update CptCapital set frozennum = 0 where id="+capitalid);
	} else {
		float number = Util.getFloatValue(fu.getParameter("node_"+i+"_number"),0);//领用数量
		if (number <= 0) number=0;
		int capitalid = Util.getIntValue(Util.null2String(fu.getParameter("node_"+i+"_capitalid")),0);
		if(!"save".equals(src)){
			RecordSet2.executeSql("update CptCapital set frozennum = 0 where id="+capitalid);
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
//response.sendRedirect("/workflow/request/RequestView.jsp");
	//out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
	
	%>
	<%@ include file="/workflow/request/RedirectPage.jsp" %> 
	<%
	
}
%>