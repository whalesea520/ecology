
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<%@ page import="weaver.file.FileUpload,java.net.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
FileUpload fu = new FileUpload(request);
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
String topage=URLDecoder.decode(Util.null2String(fu.getParameter("topage")));


if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
    //response.sendRedirect("/notice/RequestError.jsp");
    out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
    return ;
}

    Calendar today = Calendar.getInstance();
    String inputDate=Util.add0(today.get(Calendar.YEAR), 4) + "-" + Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
    today.add(Calendar.DATE, -1) ;
    String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" + Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

    String year = Util.null2String(fu.getParameter("year"));
    String month = Util.null2String(fu.getParameter("month"));
    String day = Util.null2String(fu.getParameter("day"));
    String date = Util.null2String(fu.getParameter("date"));

    //System.out.println("year="+year+"#month="+month+"#day="+day+"#date="+date);
	int inprepId=0;
	String inprepfrequence="";
	String isInputMultiLine="";
	String inprepTableName="";
	RecordSet.executeSql("select inprepId,inprepfrequence,isInputMultiLine,inprepTableName from T_InputReport where billId="+formid);
	if(RecordSet.next()){
		inprepId=Util.getIntValue(RecordSet.getString("inprepId"),0);
		inprepfrequence=Util.null2String(RecordSet.getString("inprepfrequence"));
		isInputMultiLine=Util.null2String(RecordSet.getString("isInputMultiLine"));
		inprepTableName=Util.null2String(RecordSet.getString("inprepTableName"));
	}

	String thedate = currentdate;
	String dspdate = currentdate ;

    if(!inprepfrequence.equals("0")) {
		switch (Util.getIntValue(inprepfrequence)) {
			case 1:
				thedate = year + "-01-15" ;
				dspdate = year ;
				break ;
			case 2:
				thedate = year + "-"+month+"-15" ;
				dspdate = year + "-"+month ;
				break ;
			case 3:
				thedate = year + "-"+month+"-"+day ;
				dspdate = year + "-"+month ;
				if(day.equals("05")) dspdate += ""+SystemEnv.getHtmlLabelName(84483,user.getLanguage()) ;
				if(day.equals("15")) dspdate += ""+SystemEnv.getHtmlLabelName(84484,user.getLanguage()) ;
				if(day.equals("25")) dspdate += ""+SystemEnv.getHtmlLabelName(84485,user.getLanguage()) ;
					break ;
			case 4:
				thedate = date;
				Calendar todayNew = Calendar.getInstance();
				todayNew.set(Calendar.YEAR,Util.getIntValue(date.substring(0,4)));
				todayNew.set(Calendar.MONTH,Util.getIntValue(date.substring(5,7))-1);
  				todayNew.set(Calendar.DAY_OF_MONTH,Util.getIntValue(date.substring(8)));
				dspdate = Util.add0(todayNew.get(Calendar.YEAR), 4) + ""+SystemEnv.getHtmlLabelName(15323,user.getLanguage()) + Util.add0(todayNew.get(Calendar.WEEK_OF_YEAR), 2) + ""+SystemEnv.getHtmlLabelName(1926,user.getLanguage());
				break;
			case 5:
  				thedate = date ;
  				dspdate = date ;
  				break ;
            case 6:
                thedate = year + "-"+month+"-15" ;
                dspdate = year;
                if(month.equals("01")) dspdate += ""+SystemEnv.getHtmlLabelName(82520,user.getLanguage()) ;
			    if(month.equals("07")) dspdate += ""+SystemEnv.getHtmlLabelName(82521,user.getLanguage()) ;
                break;
		    case 7:
			    thedate = year + "-"+month+"-15" ;
                dspdate = year;
                if(month.equals("01")) dspdate += ""+SystemEnv.getHtmlLabelName(28287,user.getLanguage()) ;
			    if(month.equals("04")) dspdate += ""+SystemEnv.getHtmlLabelName(28288,user.getLanguage()) ;
                if(month.equals("07")) dspdate += ""+SystemEnv.getHtmlLabelName(28289,user.getLanguage()) ;
                if(month.equals("10")) dspdate += ""+SystemEnv.getHtmlLabelName(28290,user.getLanguage());
                break;
		}	
    }



    int crmId=0;
/*	int crmFieldId=0;
	RecordSet.executeSql("select id from workflow_billField where billId="+formid+" and fieldName='crmId'");
	if(RecordSet.next()){
		crmFieldId=Util.getIntValue(RecordSet.getString("id"),0);
	}

	crmId=Util.getIntValue(fu.getParameter("field" + crmFieldId), 0);
    
	String sqlHasInput=null;
	if("1".equals(isInputMultiLine)){
		sqlHasInput="select requestId from "+ inprepTableName + "_main where inprepDspDate ='" +dspdate+"' and crmid ="+crmId +" and modtype='0'";
	}else{
		sqlHasInput="select requestId from "+ inprepTableName + " where inprepDspDate ='" +dspdate+"' and crmid ="+crmId +" and modtype='0'";
	}

	RecordSet.executeSql("select 1 from "+ inprepTableName + " where inprepDspDate ='" +dspdate+"' and crmid ="+crmId +" and modtype='0'");
	if(RecordSet.next()&&("1".equals(iscreate))){
		int tempRequestId=0;
	    RecordSet.executeSql(sqlHasInput);
		if(RecordSet.next()){
			tempRequestId=Util.getIntValue(RecordSet.getString("requestId"),0);
		}
		if(tempRequestId>0){
			//response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+tempRequestId+"&isovertime=0");
			out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+tempRequestId+"&isovertime=0');</script>");
			return ;
		}else{
			//response.sendRedirect("/datacenter/input/InputReportDate.jsp?inprepid="+inprepId);
			out.print("<script>wfforward('/datacenter/input/InputReportDate.jsp?inprepid="+inprepId+"');</script>");
			return ;
		}
	}
*/


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
//add by xhheng @ 2005/01/24 for 消息提醒 Request06
RequestManager.setMessageType(messageType) ;

boolean savestatus = RequestManager.saveRequestInfo() ;
requestid = RequestManager.getRequestid() ;
if( !savestatus ) {
    if( requestid != 0 ) {
        //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1");
        out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1');</script>");
        return ;
    }
    else {
        //response.sendRedirect("/workflow/request/RequestView.jsp?message=1");
        out.print("<script>wfforward('/workflow/request/RequestView.jsp?message=1');</script>");
        return ;
    }
}

boolean flowstatus = RequestManager.flowNextNode() ;
if( !flowstatus ) {
	//response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
	out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2');</script>");
	return ;
}

boolean logstatus = RequestManager.saveRequestLog() ;

if( src.equals("save") || src.equals("submit")|| src.equals("reject") ) {      // 修改明细表和主表信息


	String reportDate=thedate;
	String inprepDspDate=dspdate;
	String inputStatus="0";
//	if(src.equals("save")&&"1".equals(iscreate)){
//		inputStatus="9";
//	}
	if( RequestManager.getNextNodetype().equals("0")){
		inputStatus="9";
	}
    if( RequestManager.getNextNodetype().equals("3")) {
		inputStatus="4";
    }
	int reportUserId=0;
    String modType="0";

	String tableName="";
	String detailTableName="";
	RecordSet.executeSql("select tableName ,detailTableName from workflow_bill where id="+formid);
	if(RecordSet.next()){
		tableName=Util.null2String(RecordSet.getString("tableName"));
		detailTableName=Util.null2String(RecordSet.getString("detailTableName"));
	}

    if(!isInputMultiLine.equals("1")&&!tableName.equals("")){
		RecordSet.executeSql("update "+tableName+" set inputId=id where  requestId="+requestid);
	}

	if(!tableName.equals("")){
		RecordSet.executeSql("update "+tableName+" set reportDate='"+reportDate+"',inprepDspDate='"+inprepDspDate+"',inputDate='"+inputDate+"',inputStatus='"+inputStatus+"',modType='"+modType+"' where  requestId="+requestid);
	}
	if(!detailTableName.equals("")){
		int mainId=0;
		RecordSet.executeSql("select id,crmId,reportUserId from "+tableName+" where requestId="+requestid);
		if(RecordSet.next()){
			mainId=Util.getIntValue(RecordSet.getString("id"),0);
			crmId=Util.getIntValue(RecordSet.getString("crmId"),0);
			reportUserId=Util.getIntValue(RecordSet.getString("reportUserId"),0);
		}
		RecordSet.executeSql("update "+detailTableName+" set crmId="+crmId+",reportDate='"+reportDate+"',inprepDspDate='"+inprepDspDate+"',inputDate='"+inputDate+"',inputStatus='"+inputStatus+"',reportUserId="+reportUserId+",modType='"+modType+"' where  mainId="+mainId);
	}


}
if( src.equals("delete") ) {           //  修改明细表和主表信息

}

if(!topage.equals("")){
	if(topage.indexOf("?")!=-1){
		//response.sendRedirect(topage+"&requestid="+requestid);
		out.print("<script>wfforward('"+topage+"&requestid="+requestid+"');</script>");
	}else{
		//response.sendRedirect(topage+"?requestid="+requestid);
		out.print("<script>wfforward('"+topage+"?requestid="+requestid+"');</script>");
	}
}else{
	//response.sendRedirect("/workflow/request/RequestView.jsp");
	out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
}
%>
