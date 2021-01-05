<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
String moudleid = Util.null2String(request.getParameter("moudleid"));
String moudlename = Util.fromScreen(request.getParameter("moudlename"),user.getLanguage());
String needconfirm = Util.null2String(request.getParameter("needconfirm"));
String moudlemaintener = Util.null2String(request.getParameter("moudlemaintener"));
String moudleviewer = Util.null2String(request.getParameter("moudleviewer"));
String moudlecreater = Util.null2String(request.getParameter("moudlecreater"));
String confirmtype = Util.null2String(request.getParameter("confirmtype"));
String moudleconfirmer = Util.null2String(request.getParameter("moudleconfirmer"));
String moudlesql = Util.fromScreen(request.getParameter("moudlesql"),user.getLanguage());
String isrootmoudle = Util.null2String(request.getParameter("isrootmoudle"));


if( needconfirm.equals("0") ) moudleconfirmer = "-1" ;
else if ( confirmtype.equals("1") ) moudleconfirmer = "0" ;

if(operation.equals("addnewmoudle") || operation.equals("addsubmoudle")){
	
    char separator = Util.getSeparator() ;
    
    String tableindex = "0" ;
    RecordSet.executeProc("SystemMoudle_SMaxID","") ;  // 查询下一个表的id
    if( RecordSet.next() ) tableindex = ""+Util.getIntValue(RecordSet.getString(1),0) ;
    String moudletablename = "T_SysMoudle_"+tableindex ;
    
    if(operation.equals("addnewmoudle")) isrootmoudle = "0" ;
    else isrootmoudle = moudleid ;

	String para = moudlename + separator + moudletablename
		+ separator + isrootmoudle + separator + needconfirm + separator + moudlemaintener + separator + moudleviewer + separator + moudlecreater  + separator + moudleconfirmer ;

	RecordSet.executeProc("SystemMoudle_Insert",para);
	
	String createtable = "" ;
    
    if(operation.equals("addnewmoudle"))   {
        createtable = " create table " + moudletablename + 
                     " (inputid  int IDENTITY(1,1) primary key CLUSTERED, " +
                     " inputsubject  varchar(150) ," +
                     " createrid  int ," +
                     " confirmid  int ," +
                     " createdate char(10) ," +
                     " confirmdate char(10) ," +
                     " inputstatus char(1) default '0' ) " ;
        RecordSet.executeSql(createtable);
    }
    else {
        createtable = " create table " + moudletablename + 
                     " (inputid  int , " +
                     " createrid  int ," +
                     " confirmid  int ," +
                     " createdate char(10) ," +
                     " confirmdate char(10) ," +
                     " inputstatus char(1) default '0' ) " ;
        RecordSet.executeSql(createtable);

        createtable = " create index " + moudletablename + "_in on " + moudletablename + " (inputid) " ;
        RecordSet.executeSql(createtable);
    }

 	if(operation.equals("addnewmoudle")) response.sendRedirect("MoudleManager.jsp");
    else response.sendRedirect("MoudleEdit.jsp?moudleid=" + moudleid);
 }
 else if(operation.equals("editnewmoudle") || operation.equals("editsubmoudle")){
	
    char separator = Util.getSeparator() ;
	String para = moudleid + separator + moudlename + separator + needconfirm + separator + moudlemaintener + separator + moudleviewer + separator + moudlecreater  + separator + moudleconfirmer + separator + moudlesql ;

	RecordSet.executeProc("SystemMoudle_Update",para);
    
 	if(operation.equals("editnewmoudle")) response.sendRedirect("MoudleManager.jsp");
    else response.sendRedirect("MoudleEdit.jsp?moudleid=" + isrootmoudle);
 }
 else if(operation.equals("deletenewmoudle") || operation.equals("deletesubmoudle")){
    char separator = Util.getSeparator() ;
	String para = ""+moudleid;
	RecordSet.executeProc("SystemMoudle_Delete",para);

 	if(operation.equals("deletenewmoudle")) response.sendRedirect("MoudleManager.jsp");
    else response.sendRedirect("MoudleEdit.jsp?moudleid=" + isrootmoudle);
 }
/* 
else if(operation.equals("edit")){
    char separator = Util.getSeparator() ;

    String para = ""+moudleid + separator + moudlename + separator + moudletablename + separator + moudlebugtablename + separator + moudlefrequence + separator + moudlebudget  + separator + moudleforecast + separator + startdate + separator + enddate ;

	RecordSet.executeProc("T_InputReport_Update",para);

    if(!moudlebudget.equals(oldmoudlebudget)) {

        if(oldmoudlebudget.equals("0")) {
            String createtable = " create table " + moudlebugtablename + 
                         " (inputid  int IDENTITY(1,1) primary key CLUSTERED, " +
                         " crmid  int ," +
                         " reportdate char(10) ," +
                         " moudledspdate varchar(80) ," +
                         " inputdate char(10) ," +
                         " inputstatus char(1) default '0', " + 
                         " reportuserid int , " +
                         " confirmuserid int , " +
                         " modtype char(1) default '0') " ;

            RecordSet.executeSql(createtable);

            RecordSet.executeProc("T_InputReportItem_SelectBymoudleid",""+moudleid);
            while(RecordSet.next()) {
                String itemfieldname = Util.null2String(RecordSet.getString("itemfieldname")) ;
                String itemfieldtype = Util.null2String(RecordSet.getString("itemfieldtype")) ;
                String itemfieldscale = Util.null2String(RecordSet.getString("itemfieldscale")) ;

                String altertable = " alter table " + moudlebugtablename + " add " + itemfieldname ;
                switch (Util.getIntValue(itemfieldtype)) {
                    case 1 :
                        altertable += " varchar("+itemfieldscale+") " ;
                        break ;
                    case 2 :
                        altertable += " integer " ;
                        break ;
                    case 3 :
                        altertable += " decimal(12,"+itemfieldscale+") " ;
                        break ;
                    case 4 :
                        altertable += " varchar(100) " ;
                        break ;
                    case 5 :
                        altertable += " decimal(12,"+itemfieldscale+") " ;
                        break ;
                    case 6 :
                        altertable += " text " ;
                        break ;
                }
                
                RecordSet.executeSql(altertable);
            }

        }
        else {
            moudlebugtablename = moudletablename + "_buget" ;
            String droptable = " drop table " + moudlebugtablename  ;
            RecordSet.executeSql(droptable);
        }
    }

    if(!moudleforecast.equals(oldmoudleforecast)) {

        if(oldmoudleforecast.equals("0")) {
            String createtable = " create table " + moudlefortablename + 
                         " (inputid  int IDENTITY(1,1) primary key CLUSTERED, " +
                         " crmid  int ," +
                         " reportdate char(10) ," +
                         " moudledspdate varchar(80) ," +
                         " inputdate char(10) ," +
                         " inputstatus char(1) default '0', " + 
                         " reportuserid int , " +
                         " confirmuserid int , " +
                         " modtype char(1) default '0') " ;

            RecordSet.executeSql(createtable);

            RecordSet.executeProc("T_InputReportItem_SelectBymoudleid",""+moudleid);
            while(RecordSet.next()) {
                String itemfieldname = Util.null2String(RecordSet.getString("itemfieldname")) ;
                String itemfieldtype = Util.null2String(RecordSet.getString("itemfieldtype")) ;
                String itemfieldscale = Util.null2String(RecordSet.getString("itemfieldscale")) ;

                String altertable = " alter table " + moudlefortablename + " add " + itemfieldname ;
                switch (Util.getIntValue(itemfieldtype)) {
                    case 1 :
                        altertable += " varchar("+itemfieldscale+") " ;
                        break ;
                    case 2 :
                        altertable += " integer " ;
                        break ;
                    case 3 :
                        altertable += " decimal(12,"+itemfieldscale+") " ;
                        break ;
                    case 4 :
                        altertable += " varchar(100) " ;
                        break ;
                    case 5 :
                        altertable += " decimal(12,"+itemfieldscale+") " ;
                        break ;
                    case 6 :
                        altertable += " text " ;
                        break ;
                }
                
                RecordSet.executeSql(altertable);
            }

        }
        else {
            String droptable = " drop table " + moudletablename + "_forecast"  ;
            RecordSet.executeSql(droptable);
        }
    }
	
 	response.sendRedirect("InputReport.jsp");
 }
 else if(operation.equals("delete")){
    char separator = Util.getSeparator() ;
	String para = ""+moudleid;
	RecordSet.executeProc("T_InputReport_Delete",para);

    String droptable =  " drop table " + moudletablename ;
    RecordSet.executeSql(droptable);
    
    if(oldmoudlebudget.equals("1")) {
        droptable =  " drop table " + moudlebugtablename ;
        RecordSet.executeSql(droptable);
    }

    if(oldmoudleforecast.equals("1")) {
        droptable =  " drop table " + moudlefortablename ;
        RecordSet.executeSql(droptable);
    }

 	response.sendRedirect("InputReport.jsp");
 }

 else if(operation.equals("addcrm")){
    char separator = Util.getSeparator() ;
	String para = ""+moudleid + separator + crmid ;
	RecordSet.executeProc("T_InputReportCrm_Insert",para);

 	response.sendRedirect("InputReportEdit.jsp?moudleid="+moudleid);
 }

 else if(operation.equals("deletecrm")){
    char separator = Util.getSeparator() ;
	String para = ""+moudlecrmid;
	RecordSet.executeProc("T_InputReportCrm_Delete",para);

 	response.sendRedirect("InputReportEdit.jsp?moudleid="+moudleid);
 }

 else if(operation.equals("close")){
    
	RecordSet.executeSql("update T_InputReport set moudlebudgetstatus = '2' where moudleid="+moudleid);

 	response.sendRedirect("InputReportEdit.jsp?moudleid="+moudleid);
 }

else if(operation.equals("open")){
    
	RecordSet.executeSql("update T_InputReport set moudlebudgetstatus = '1' where moudleid="+moudleid);

 	response.sendRedirect("InputReportEdit.jsp?moudleid="+moudleid);
 }
 else if(operation.equals("editcontactright")){
	RecordSet.executeSql("delete T_InputReportCrmContacter where moudlecrmid="+moudlecrmid);
    String contacterids[] = request.getParameterValues("contacterid") ;
    if( contacterids != null ) {
        for(int i=0 ; i<contacterids.length ; i++) {
            RecordSet.executeSql("insert into T_InputReportCrmContacter( moudlecrmid, contacterid ) values("+moudlecrmid +" , " + contacterids[i]+" ) ");
        }
    }
 	response.sendRedirect("InputReportEdit.jsp?moudleid="+moudleid);
 } */
%>
