<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
String operation = Util.null2String(request.getParameter("operation"));
String itemid = Util.null2String(request.getParameter("itemid"));
String inprepid = Util.null2String(request.getParameter("inprepid"));
String itemdspname = Util.fromScreen(request.getParameter("itemdspname"),user.getLanguage());
String itemfieldname = Util.null2String(request.getParameter("itemfieldname"));
String itemfieldtype = Util.null2String(request.getParameter("itemfieldtype"));
String itemfieldscale = Util.null2String(request.getParameter("itemfieldscale"));
String olditemfieldname = Util.null2String(request.getParameter("olditemfieldname"));
String olditemfieldtype = Util.null2String(request.getParameter("olditemfieldtype"));
String olditemfieldscale = Util.null2String(request.getParameter("olditemfieldscale"));
String itemfieldunit = Util.fromScreen(request.getParameter("itemfieldunit"),user.getLanguage());
int totaldetail = Util.getIntValue(request.getParameter("totaldetail"),0);

if((itemfieldscale.equals("") || itemfieldscale.equals("0")) && itemfieldtype.equals("1")) itemfieldscale = "60" ;
if((itemfieldscale.equals("") || itemfieldscale.equals("0")) && itemfieldtype.equals("3")) itemfieldscale = "2" ;
if(olditemfieldscale.equals("0")) olditemfieldscale = "" ;

RecordSet.executeProc("T_SurveyItem_SelectByInprepid",""+inprepid);
RecordSet.next() ;
String inpreptablename = Util.null2String(RecordSet.getString("inpreptablename")) ;

if(operation.equals("add")){

    char separator = Util.getSeparator() ;

    String para = inprepid + separator + itemdspname + separator + itemfieldname + separator +                       itemfieldtype + separator + itemfieldscale + separator + itemfieldunit ;
    RecordSet.executeProc("T_fieldItem_Insert",para);

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
            altertable += " decimal(12,"+itemfieldscale+") " ;
            break ;
        case 6 :
            altertable += " text " ;
            break ;
           
    }
    RecordSet.executeSql(altertable);
    response.sendRedirect("InputReportEdit.jsp?inprepid=" + inprepid);
}
 
else if(operation.equals("edit")){
    char separator = Util.getSeparator() ;
    String para = ""+itemid + separator + inprepid +separator + itemdspname + separator +                        itemfieldname + separator + itemfieldtype + separator + itemfieldscale 
                    + separator + itemfieldunit ;
	RecordSet.executeProc("T_fieldItem_Update",para);

    if(!olditemfieldtype.equals( itemfieldtype ) ||  !olditemfieldscale.equals( itemfieldscale )) {
        String altertable = " alter table " + inpreptablename + " alter column  " +                                   olditemfieldname ;
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
        RecordSet.executeSql(altertable); 
    }
    if( !olditemfieldname.equals(itemfieldname) )  {

        RecordSet.executeSql("exec sp_rename '"+inpreptablename+"."+olditemfieldname+"', '"+itemfieldname+"', 'column' "); 
    }
    
    if(totaldetail !=0) {
        RecordSet.executeProc("T_fieldItemDetail_Delete",itemid);
        for( int i =0 ; i< totaldetail ; i++) {
            String itemvalue = Util.fromScreen(request.getParameter("itemvalue"+i),user.getLanguage());
            String itemdsp = Util.fromScreen(request.getParameter("itemdsp"+i),user.getLanguage());
            
            if(!itemvalue.equals("")) {
                para = itemid + separator + itemvalue + separator + itemdsp ;
                RecordSet.executeProc("T_fieldItemDetail_Insert",para);
            }
        }
    }
    response.sendRedirect("InputReportEdit.jsp?inprepid=" + inprepid);
}

else if(operation.equals("delete")){
    char separator = Util.getSeparator() ;
    String para = ""+itemid;
    RecordSet.executeProc("T_fieldItem_Delete",para);
    RecordSet.executeProc("T_fieldItemDetail_Delete",para);
    RecordSet.executeSql ( "ALTER TABLE "+ inpreptablename +" DROP COLUMN " + olditemfieldname );
    response.sendRedirect("InputReportEdit.jsp?inprepid=" + inprepid);

}
%>
