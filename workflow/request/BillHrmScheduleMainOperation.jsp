<%@ page import="weaver.general.Util,java.util.*,weaver.conn.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<%@ page import="weaver.file.FileUpload" %>
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
String crmids = "" ;
String projectids = "" ;

Calendar startdates = Calendar.getInstance() ;
String currentdate = Util.add0(startdates.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(startdates.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(startdates.get(Calendar.DAY_OF_MONTH) , 2) ;

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

if( src.equals("save") || src.equals("submit") ) {      // 修改细表和主表信息
    char flag=Util.getSeparator() ;
    double feesumcount = 0 ;
    double realfeesumcount = 0 ;
    int accessorycount = 0 ;

    if( !iscreate.equals("1") ) {
        RecordSet.executeSql(" delete Bill_HrmScheduleDetail where scheduleid = "+billid);
    }
    else {
        requestid = RequestManager.getRequestid() ;
        billid = RequestManager.getBillid() ;
    }
    
    ArrayList fieldids=new ArrayList();             //字段队列
    ArrayList fieldnames=new ArrayList();           //单据的字段的表字段名队列
    ArrayList fieldviewtypes=new ArrayList();       //单据是否是detail表的字段1:是 0:否(如果是,将不显示)

    String enddates = "" ;
    String tempstartdate = "" ;
    int allsumday = 0 ;

    
    RecordSet.executeProc("workflow_billfield_Select",formid+"");
    while(RecordSet.next()){
        fieldids.add(Util.null2String(RecordSet.getString("id")));
        fieldnames.add(Util.null2String(RecordSet.getString("fieldname")));
        fieldviewtypes.add(Util.null2String(RecordSet.getString("viewtype")));
    }

    int rowsum = Util.getIntValue(Util.null2String(fu.getParameter("nodesnum")));
	for(int i=0;i<rowsum;i++) {	

        String sql1 = "" ;
        String sql2 = "" ;
        boolean caninsert = true ;

        for( int j=0 ; j< fieldids.size() ; j++ ) {
            String fieldviewtype = (String) fieldviewtypes.get(j) ;
            if( fieldviewtype.equals("0") ) continue ;

            String fieldid = (String) fieldids.get(j) ;
            String fieldname = (String) fieldnames.get(j) ;

            String filevalue = Util.null2String(fu.getParameter("field"+fieldid+"_"+i));
            if( filevalue.equals("") && !fieldname.equals("sumday") ) {
                caninsert = false ;
                break ;
            }

            if( fieldname.equals("sumday") ) continue ;

            if( sql1.equals("") ) sql1 = fieldname ;
            else sql1 += "," + fieldname ;

            if( !sql2.equals("") ) sql2 += "," ;

            if( fieldname.equals("scheduleid") ) {
                sql2 += ""+Util.getIntValue(filevalue, 0 ) ;
            }
            else {
                sql2 += "'"+filevalue+"'" ;
            }

            if( fieldname.equals("startdate") ) {
                int fromyear = Util.getIntValue(filevalue.substring(0 , 4)) ; 
                int frommonth = Util.getIntValue(filevalue.substring(5 , 7)) ; 
                int fromday = Util.getIntValue(filevalue.substring(8 , 10)) ; 

                startdates.set(fromyear,frommonth - 1 , fromday) ;
                tempstartdate = filevalue ;
            }

            if( fieldname.equals("enddate") ) enddates  = filevalue ;
        }

        if( !caninsert ) continue ;

        int sumday = 0 ;
        while( tempstartdate.compareTo(enddates) <= 0 ) {
            sumday ++ ;
            startdates.add(Calendar.DATE , 1) ; 
            tempstartdate =  Util.add0(startdates.get(Calendar.YEAR) , 4) + "-" + 
                        Util.add0(startdates.get(Calendar.MONTH) + 1 , 2) + "-" + 
                        Util.add0(startdates.get(Calendar.DAY_OF_MONTH) , 2) ; 
        }
        
        allsumday += sumday ;

        String sql = " insert into Bill_HrmScheduleDetail ( " + sql1 + ",sumday,scheduleid) values( " + sql2 + "," + sumday + ","+billid+")" ;

        RecordSet.executeSql(sql);
	}

    RecordSet.executeSql(" update Bill_HrmScheduleMain set sumday = " + allsumday + " where id = " + billid );

}

boolean flowstatus = RequestManager.flowNextNode() ;
if( !flowstatus ) {
	//response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
	out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2');</script>");
	return ;
}

boolean logstatus = RequestManager.saveRequestLog() ;


if( RequestManager.getNextNodetype().equals("3")) {
    RecordSet.executeSql("select * from Bill_HrmScheduleMain where id = "+billid);
    if( RecordSet.next() ) {
        String resource_n = Util.null2String(RecordSet.getString("resource_n"));
		String reason = Util.null2String(RecordSet.getString("reason")) ;

        weaver.hrm.tools.Time thetimes = new weaver.hrm.tools.Time() ;
        
        RecordSet.executeSql("select * from Bill_HrmScheduleDetail where scheduleid = "+billid);

        while( RecordSet.next() ) {
            String diffid  = Util.null2String(RecordSet.getString("diffid"));
            String startdate =    Util.null2String(RecordSet.getString("startdate"));
            String starttime = Util.null2String(RecordSet.getString("starttime"));
            String enddate = Util.null2String(RecordSet.getString("enddate")) ;       
            String endtime = Util.null2String(RecordSet.getString("endtime")) ;

            String totaltime = thetimes.getTotalTimeOnce(resource_n , diffid , startdate , starttime , enddate , endtime) ; 
//	        int totalday = thetimes.getWorkDay(totaltime , Util.getIntValue(resource_n)) ;

            RecordSet rs = new RecordSet() ;
            char separator = Util.getSeparator() ; 

/*          
            String para = diffid + separator + resource_n + separator + startdate  + separator + starttime  + separator + enddate + separator + endtime + separator + reason +separator+"0"+separator+resource_n+separator+currentdate;
            rs.executeProc("HrmScheduleMain_Insert",para);
            rs.next() ; 
            int schedulediffid = rs.getInt(1) ; 

            para = "" + schedulediffid + separator + totaltime ; 	
            rs.executeProc("HrmScheduleTotalTime" , para) ; 

            para = "" + schedulediffid + separator + totalday ; 
            rs.executeProc("HrmScheduleTotalDay" , para) ;    */
            
            // 现有系统
            
            String realdifftime = "0" ;
            if( totaltime.length() >= 5 ) {
                int totalhour = Util.getIntValue(totaltime.substring(0,totaltime.length()-3),0) ;
                int totalmin = Util.getIntValue(totaltime.substring(3,5),0) ;
                realdifftime = "" + ( totalhour*60 + totalmin ) ;
            }
            
            String difftype = "" ;
            rs.executeSql( " select difftype from HrmScheduleDiff where id = " + diffid ) ;
            if( rs.next() ) difftype = Util.null2String(rs.getString("difftype")) ;

            String para = diffid + separator + resource_n + separator + startdate + separator + starttime +  separator + enddate + separator + endtime + separator + reason  + separator + "0" + separator + resource_n + separator + currentdate + separator + realdifftime + separator + difftype; 

            rs.executeProc("HrmScheduleMain_Insert" , para) ; 

        }
	}
}

//response.sendRedirect("/workflow/request/RequestView.jsp");
out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");

%>
