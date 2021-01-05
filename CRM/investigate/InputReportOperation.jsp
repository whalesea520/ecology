<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation")) ;
String inprepid = Util.null2String(request.getParameter("inprepid")) ;
String inprepname = Util.fromScreen(request.getParameter("inprepname"),user.getLanguage()) ;
String inpreptablename = Util.null2String(request.getParameter("inpreptablename")) ;
String mailid = Util.null2String(request.getParameter("mailid")) ;
String urlname = Util.null2String(request.getParameter("urlname")) ;
String sql = "" ;

if(operation.equals("add")){
    char separator = Util.getSeparator() ;
	String para = mailid + separator + inprepname + separator + inpreptablename + separator + urlname ;
    
	RecordSet.executeProc("T_SurveyItem_Insert",para);
	String createtable = " create table " + inpreptablename + 
                         " (id  int IDENTITY(1,1) primary key CLUSTERED, " +
                         " crmid  int ," +   /*客户ID*/
                         " contacterid int ,"+ /*联系人的ID*/
                         " inputid int ,"+ /*调查ID*/
                         " reportdate char(10) )" ;  /*日期*/

    RecordSet.executeSql(createtable);
    response.sendRedirect("InputReport.jsp");
 }
 
else if(operation.equals("edit")){
    char separator = Util.getSeparator() ;
    String para = ""+inprepid + separator + mailid + separator + inprepname + separator + inpreptablename + separator + urlname ;
    RecordSet.executeProc("T_SurveyItem_Update",para);

    String createtable = " create table " + inpreptablename + 
                 " (id  int IDENTITY(1,1) primary key CLUSTERED, " +
                 " crmid  int ," +   /*客户ID*/
                 " contacterid int ,"+ /*联系人的ID*/
                 " inputid int ,"+ /*调查ID*/
                 " reportdate char(10) )" ;  /*日期*/
    RecordSet.executeSql(createtable);
    sql = "select * from T_fieldItem where inprepid ="+inprepid ;
    rs.executeSql(sql);
    while(rs.next()) {
        String itemfieldname = Util.null2String(rs.getString("itemfieldname")) ;
        String itemfieldtype = Util.null2String(rs.getString("itemfieldtype")) ;
        String itemfieldscale = Util.null2String(rs.getString("itemfieldscale")) ;
        String altertable = " alter table " + inpreptablename + " add " + itemfieldname ;
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
                altertable += " varchar(100) " ;
                break ;
            case 6 :
                altertable += " text " ;
                break ;
        }
        rs1.executeSql(altertable);

    }
   
response.sendRedirect("InputReport.jsp");
}

else if(operation.equals("delete")){
    char separator = Util.getSeparator() ;
	String para = ""+inprepid;
	RecordSet.executeProc("T_SurveyItem_Delete",para);

    String droptable =  " drop table " + inpreptablename ;
    RecordSet.executeSql(droptable);
 	response.sendRedirect("InputReport.jsp");
}
%>
