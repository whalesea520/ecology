<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />

<%
String operation = Util.null2String(request.getParameter("operation"));
String itemid = Util.null2String(request.getParameter("itemid"));
String moudleid = Util.null2String(request.getParameter("moudleid"));
String itemdspname = Util.fromScreen(request.getParameter("itemdspname"),user.getLanguage());
String itemfieldtype = Util.null2String(request.getParameter("itemfieldtype"));
String itemfieldscale = Util.null2String(request.getParameter("itemfieldscale"));
String itembroswertype = Util.null2String(request.getParameter("itembroswertype"));
String itemvalidate = Util.null2String(request.getParameter("itemvalidate"));
String itemmaintenance = Util.null2String(request.getParameter("itemmaintenance"));
String itemdsporder = Util.null2String(request.getParameter("itemdsporder"));
String itemfieldname = Util.null2String(request.getParameter("itemfieldname"));

String olditemfieldtype = Util.null2String(request.getParameter("olditemfieldtype"));
String olditemfieldscale = Util.null2String(request.getParameter("olditemfieldscale"));
String olditembroswertype = Util.null2String(request.getParameter("olditembroswertype"));

int totaldetail = Util.getIntValue(request.getParameter("totaldetail"),0);
int issub = Util.getIntValue(request.getParameter("issub"),0);

if(itemvalidate.equals("")) itemvalidate = "0" ;
if(itemmaintenance.equals("")) itemmaintenance = "0" ;


if(operation.equals("additem")){
	
    char separator = Util.getSeparator() ;

    String itemindex = "0" ;
    RecordSet.executeProc("SystemMoudleItem_SMaxID","") ;  // 查询下一个字段的id
    if( RecordSet.next() ) itemindex = ""+Util.getIntValue(RecordSet.getString(1),0) ;
    itemfieldname = "F_Item_" + itemindex ;


	String para = moudleid + separator + itemdspname
		+ separator + itemfieldname + separator + itemfieldtype + separator + itemfieldscale 
        + separator + itembroswertype + separator + itemvalidate + separator + itemmaintenance ;

	RecordSet.executeProc("SystemModuleItem_Insert",para);
    
    String moudletablename = "" ;
	RecordSet.executeProc("SystemMoudle_SByMoudleid",moudleid);
    if(RecordSet.next()) moudletablename = Util.null2String(RecordSet.getString("moudletablename")) ;

    String altertable = " alter table " + moudletablename + " add " + itemfieldname ;
    
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
            String fielddbtype = BrowserComInfo.getBrowserdbtype(itembroswertype);
            altertable += " " + fielddbtype + " " ;
            break ;
        case 6 :
            altertable += " text " ;
            break ;
    }
    RecordSet.executeSql(altertable);

 }
else if(operation.equals("edititem")){
    char separator = Util.getSeparator() ;

    String para = itemid + separator + moudleid + separator + itemdspname
		+ separator + itemfieldtype + separator + itemfieldscale 
        + separator + itembroswertype + separator + itemvalidate + separator + itemmaintenance 
        + separator + itemdsporder ;

	RecordSet.executeProc("SystemModuleItem_Update",para);

    if(!olditemfieldtype.equals( itemfieldtype ) ||  !olditemfieldscale.equals( itemfieldscale ) ||  !olditembroswertype.equals( itembroswertype ) ) {

        String moudletablename = "" ;
        RecordSet.executeProc("SystemMoudle_SByMoudleid",moudleid);
        if(RecordSet.next()) moudletablename = Util.null2String(RecordSet.getString("moudletablename")) ;
		
        String altertable = " alter table " + moudletablename + " alter column  " + itemfieldname ;
    
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
                String fielddbtype = BrowserComInfo.getBrowserdbtype(itembroswertype);
                altertable += " " + fielddbtype + " " ;
                break ;
            case 6 :
                altertable += " text " ;
                break ;
        }
        
        RecordSet.executeSql(altertable);
    }

    if(totaldetail !=0) {
        RecordSet.executeProc("SystemModuleItemDetail_Delete",itemid);

        for( int i =0 ; i< totaldetail ; i++) {
//            String itemdsp = Util.fromScreen(request.getParameter("itemdsp"+i),user.getLanguage());
            String itemvalue = Util.fromScreen(request.getParameter("itemvalue"+i),user.getLanguage());

            if(!itemvalue.equals("")) {
                para = itemid + separator + itemvalue ;
                RecordSet.executeProc("SystemModuleItemDetail_Insert",para);
            }
        }
    }

 }
else if(operation.equals("deleteitem")){
    char separator = Util.getSeparator() ;
	String para = ""+itemid;
	RecordSet.executeProc("SystemModuleItem_Delete",para);
    RecordSet.executeProc("SystemModuleItemDetail_Delete",para);

    String moudletablename = "" ;
    RecordSet.executeProc("SystemMoudle_SByMoudleid",moudleid);
    if(RecordSet.next()) moudletablename = Util.null2String(RecordSet.getString("moudletablename")) ;

    RecordSet.executeSql ( "ALTER TABLE "+ moudletablename +" DROP COLUMN " + itemfieldname );

 }
 else if(operation.equals("uporder")){
    char separator = Util.getSeparator() ;
	String para = itemid + separator + "1" ;         // 1 : 表示顺序前移
	RecordSet.executeProc("SystemModuleItem_UOrder",para);
 }
 else if(operation.equals("downorder")){
    char separator = Util.getSeparator() ;
	String para = itemid + separator + "2" ;         // 2 : 表示顺序后移

	RecordSet.executeProc("SystemModuleItem_UOrder",para);
 }  

if( issub == 0 ) response.sendRedirect("MoudleEdit.jsp?moudleid=" + moudleid);
else response.sendRedirect("SubMoudleEdit.jsp?moudleid=" + moudleid);
%>
