<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="InputReportWorkflowTriggerManager" class="weaver.datacenter.InputReportWorkflowTriggerManager" scope="page" />


<%
String inprepname = Util.fromScreen(request.getParameter("inprepname"),user.getLanguage());
String inpreptablename = Util.null2String(request.getParameter("inpreptablename"));
String inprepbugtablename = Util.null2String(request.getParameter("inprepbugtablename"));
String inprepfrequence = Util.null2String(request.getParameter("inprepfrequence"));
String currentyear = Util.null2String(request.getParameter("currentyear"));
String currentmonth = Util.null2String(request.getParameter("currentmonth"));
String currentday = Util.null2String(request.getParameter("currentday"));
String modulefilename = Util.null2String(request.getParameter("modulefilename"));
int helpdocid = Util.getIntValue(request.getParameter("helpdocid"),0);
String year = Util.null2String(request.getParameter("year"));
String month = Util.null2String(request.getParameter("month"));
String day = Util.null2String(request.getParameter("day"));
String date = Util.null2String(request.getParameter("date"));

String inprepid = Util.null2String(request.getParameter("inprepid"));
String inprepbudget = Util.null2String(request.getParameter("inprepbudget"));
String thetable = Util.null2String(request.getParameter("thetable"));
String thedate = Util.null2String(request.getParameter("thedate"));
String dspdate = Util.fromScreen(request.getParameter("dspdate"),user.getLanguage());
String currentdate = Util.null2String(request.getParameter("currentdate"));
String hasvalue = Util.null2String(request.getParameter("hasvalue"));
String hasmod = Util.null2String(request.getParameter("hasmod"));
String inputid = Util.null2String(request.getParameter("inputid"));
String inputmodid = Util.null2String(request.getParameter("inputmodid"));
String crmid = Util.null2String(request.getParameter("crmid"));
String fromcheck = Util.null2String(request.getParameter("fromcheck"));
String usertitle = "" + Util.getIntValue(user.getTitle(), 0) ;
String operation = Util.null2String(request.getParameter("operation"));
String inputstatus = "0" ;

if(fromcheck.equals("1")) inputstatus = "1" ;
else if( operation.equals("draft") ) inputstatus = "9" ;

String sql = "" ;
String sqlin1 = "" ;
String sqlin2 = "" ;

String sqlmod = "" ;
String sqlmodin1 = "" ;
String sqlmodin2 = "" ;
boolean hastruemod = false ;

if ( !hasvalue.equals("true") ) {	
    RecordSet.executeSql("select inputid , modtype from "+ thetable + " where inprepDspDate ='" +dspdate+"' and crmid ="+crmid ) ;
    while(RecordSet.next()) {
        String modtype = Util.null2String(RecordSet.getString("modtype")) ;
        if( modtype.equals("0") ) inputid = Util.null2String(RecordSet.getString("inputid")) ;
        else inputmodid = Util.null2String(RecordSet.getString("inputid")) ;
        hasvalue = "true" ;
    }
}


if(hasvalue.equals("true"))  {
    sql = " update " + thetable + " set inputdate='"+currentdate+"',inputstatus='" + inputstatus + "' " ;
}
else {
    sqlin1 = " insert into " + thetable + "(crmid ,reportdate, inprepdspdate , inputdate,reportuserid , inputstatus " ;
        sqlin2 = " values (" + crmid + ",'"+thedate+"','"+Util.fromScreen2(dspdate,user.getLanguage()) +"' ,'"+currentdate+"',"+user.getUID()+",'"+inputstatus+"' " ;
}
RecordSet.executeProc("T_IRItem_SelectByInprepid",inprepid);

while (RecordSet.next()) {
    String itemfieldname = Util.null2String(RecordSet.getString("itemfieldname")) ;
	String itemfieldtype = Util.null2String(RecordSet.getString("itemfieldtype")) ;
    
    sql += ","+itemfieldname+"=" ;
    sqlin1 += ","+itemfieldname ;

    String itemvalue = Util.null2String(request.getParameter(itemfieldname));

    if(itemfieldtype.equals("2") || itemfieldtype.equals("3") || itemfieldtype.equals("5") ) {
        if(itemfieldtype.equals("2")) {
            sqlin2 += "," + Util.getIntValue(itemvalue,0) ;
            sql += Util.getIntValue(itemvalue,0) ;
        }
        else {
            sqlin2 += "," + Util.getDoubleValue(itemvalue,0) ;
            sql += Util.getDoubleValue(itemvalue,0) ;
        }
    }
    else  {
        sqlin2 += ",'" + Util.fromScreen2(itemvalue,user.getLanguage()) + "'" ;
        sql += "'" + Util.fromScreen2(itemvalue,user.getLanguage()) + "'" ;
    }
}

sqlin1 += ")" ;
sqlin2 += ")" ;

if(hasvalue.equals("true"))  {
    sql += " where inputid = " + inputid ;
}
else {
    sql = sqlin1 + sqlin2 ;
}
RecordSet.executeSql(sql);

if(!hasvalue.equals("true"))  {
    RecordSet.executeSql(" update "+ thetable +" set  inputId=id where inprepDspDate ='" +dspdate+"' and crmid ="+crmid) ;
    RecordSet.executeSql("select max(inputid) from "+ thetable +" where inprepDspDate ='" +dspdate+"' and crmid ="+crmid) ;
    if(RecordSet.next()){
		inputid = Util.null2String(RecordSet.getString(1)) ;
	}
}

if(! operation.equals("draft") ){
    InputReportWorkflowTriggerManager.setRequest(request);
    String returnStatus=InputReportWorkflowTriggerManager.triggerWorkflow(Util.getIntValue(inprepid,0),inputid,user);

    if("".equals(returnStatus)){
	    RecordSet.executeSql(" update "+ thetable +" set  inputStatus='4' where inprepDspDate ='" +dspdate+"' and crmid ="+crmid) ;
    }else if("false".equals(returnStatus)){
	    RecordSet.executeSql(" update "+ thetable +" set  inputStatus='9' where inprepDspDate ='" +dspdate+"' and crmid ="+crmid) ;
    }
}

if( !fromcheck.equals("1") && !inputstatus.equals("9")) {
    int confirmrecordcount = 0 ;
    RecordSet.executeSql(" select count(confirmid) from T_InputReportConfirm " +
                         " where inprepid ="+ inprepid + " and inputid =" + inputid + " and thetable ='" + thetable + "' "  );
    if( RecordSet.next() ) confirmrecordcount = Util.getIntValue(RecordSet.getString(1),0) ;

    if(confirmrecordcount == 0 )  {

        char separator = Util.getSeparator() ;
       
        // 为新亚增加的填报人id (即CRM 联系人的 id ) 
        String reportuserid = usertitle ;

        String para = inprepid + separator + inprepbudget + separator + thetable + separator + inputid
                + separator + dspdate + separator + crmid + separator +  CustomerInfoComInfo.getCustomerInfomanager(crmid) + separator + reportuserid ;  

        RecordSet.executeProc("T_InputReportConfirm_Insert",para);
    }
}

if(fromcheck.equals("1"))
    response.sendRedirect("/datacenter/maintenance/reportstatus/ReportDetailStatus.jsp?inprepid="+inprepid) ;
else {
%>
    <HTML>
    <BODY onload="frmMain.submit()">
    <FORM id=frmMain name=frmMain action="InputReportData.jsp" method=post>
    <input type=hidden name="inprepid" value="<%=inprepid%>">
    <input type=hidden name="fromcheck" value="<%=fromcheck%>">
    <input type=hidden name="crmid" value="<%=crmid%>">
    <input type=hidden name="inprepname" value="<%=inprepname%>">
    <input type=hidden name="inpreptablename" value="<%=inpreptablename%>">
    <input type=hidden name="inprepbugtablename" value="<%=inprepbugtablename%>">
    <input type=hidden name="inprepfrequence" value="<%=inprepfrequence%>">
    <input type=hidden name="inprepbudget" value="<%=inprepbudget%>">
    <input type=hidden name="currentyear" value="<%=currentyear%>">
    <input type=hidden name="currentmonth" value="<%=currentmonth%>">
    <input type=hidden name="currentday" value="<%=currentday%>">
    <input type=hidden name="modulefilename" value="<%=modulefilename%>">
    <input type=hidden name="helpdocid" value="<%=helpdocid%>">
    <input type=hidden name="currentdate" value="<%=currentdate%>">
    <input type=hidden name="year" value="<%=year%>">
    <input type=hidden name="month" value="<%=month%>">
    <input type=hidden name="day" value="<%=day%>">
    <input type=hidden name="date" value="<%=date%>">
    </FORM>
    </BODY>
    </HTML>
<%
}
%>
