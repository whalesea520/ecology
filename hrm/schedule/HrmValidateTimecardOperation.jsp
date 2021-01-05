
<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.* , java.io.* , weaver.general.Util,weaver.file.*" %>
<%@ page import="weaver.general.SendMail" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>

<%
String operation = Util.null2String(request.getParameter("operation"));
String fromdate = Util.fromScreen(request.getParameter("fromdate") , user.getLanguage()) ; //排班日期从
String enddate = Util.fromScreen(request.getParameter("enddate") , user.getLanguage()) ; //排班日期到

char separator = Util.getSeparator() ;

if(operation.equals("recreate")) {

    ArrayList resourceids = new ArrayList() ;
    ArrayList usercodes = new ArrayList() ;

    RecordSet.executeSql("select * from HrmTimecardUser ") ;
    while ( RecordSet.next() ) {
        String resourceid = Util.null2String(RecordSet.getString("resourceid")) ;
        String usercode = Util.null2String(RecordSet.getString("usercode")) ;
        resourceids.add( resourceid ) ;
        usercodes.add( usercode ) ;
    }

    RecordSet.executeSql("select * from HrmValidateCardInfo ") ;
    while ( RecordSet.next() ) {
        String id = Util.null2String(RecordSet.getString("id")) ; 
        String Cardid = Util.null2String(RecordSet.getString("Cardid")) ; 
        String carddate = Util.null2String(RecordSet.getString("carddate")) ; 
        String cardtime = Util.null2String(RecordSet.getString("cardtime")) ; 
        String workshift = Util.null2String(RecordSet.getString("workshift")) ; 

        int usercodeindex = usercodes.indexOf(Cardid) ;
        if( usercodeindex != -1 ) {
            String resourceid = (String) resourceids.get( usercodeindex ) ;
            String procedurepara = resourceid +separator+ carddate +separator+ cardtime +separator + "0" ;
            RecordSet.executeProc("HrmRightCardInfo_Insert",procedurepara);
            RecordSet.executeSql("delete HrmValidateCardInfo where id = " + id );
            
        }
    } 
    response.sendRedirect("/hrm/report/schedulediff/HrmRpValidateTimecard.jsp?fromdate="+fromdate+"&enddate="+enddate) ;
}

%>
