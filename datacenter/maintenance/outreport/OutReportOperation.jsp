<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%

String operation = Util.null2String(request.getParameter("operation"));
String outrepid = Util.null2String(request.getParameter("outrepid"));
String outrepname = Util.fromScreen(request.getParameter("outrepname"),user.getLanguage());
String outrepenname = Util.toScreenToEdit(request.getParameter("outrepenname"),user.getLanguage()) ;
String outreprow = Util.null2String(request.getParameter("outreprow"));
String outrepcolumn = Util.null2String(request.getParameter("outrepcolumn"));
String modulefilename = Util.null2String(request.getParameter("modulefilename")); //模板文件名称
String enmodulefilename = Util.null2String(request.getParameter("enmodulefilename")); //模板文件名称
// 刘煜 2004 年10月23 日增加模板文件自适应行高和列宽
String autocolumn = Util.null2String(request.getParameter("autocolumn")); //列宽
String autorow = Util.null2String(request.getParameter("autorow")); //行高

String outreptype = Util.null2String(request.getParameter("outreptype")); //报表种类
String outrepcategory = Util.null2String(request.getParameter("outrepcategory")); /*报表所属 0:固定报表 1：明细报表 2:排序报表*/
String outrepdesc = Util.fromScreen(request.getParameter("outrepdesc"),user.getLanguage());
String outrependesc = Util.null2String(request.getParameter("outrependesc"));
String userid = Util.null2String(request.getParameter("userid"));
String usertype = Util.null2String(request.getParameter("usertype"));
String outrepshareid = Util.null2String(request.getParameter("outrepshareid"));
String changetype = Util.null2String(request.getParameter("changetype"));
String rowtype = Util.null2String(request.getParameter("rowtype"));
String columntype = Util.null2String(request.getParameter("columntype"));
int addrownum = Util.getIntValue(request.getParameter("addrownum"));
int addcolumnnum = Util.getIntValue(request.getParameter("addcolumnnum"));
int delrownum = Util.getIntValue(request.getParameter("delrownum"));
int delcolumnnum = Util.getIntValue(request.getParameter("delcolumnnum"));

// 统计项变量
int totaldetail1 = Util.getIntValue(request.getParameter("totaldetail1"));
int totaldetail2 = Util.getIntValue(request.getParameter("totaldetail2"));
String outrepitemid = Util.null2String(request.getParameter("outrepitemid"));
String statitemid = Util.null2String(request.getParameter("statitemid"));


if(operation.equals("add")){
	
    char separator = Util.getSeparator() ;

  	
	String para = outrepname + separator + outreprow 
		+ separator + outrepcolumn + separator + outrepdesc + separator + modulefilename  + separator + outreptype + separator + outrepcategory + separator + enmodulefilename + separator + outrepenname + separator + outrependesc + separator + autocolumn + separator + autorow;
	RecordSet.executeProc("T_OutReport_Insert",para);
	
    
 	response.sendRedirect("OutReport.jsp");
 }
 
else if(operation.equals("edit")){
    char separator = Util.getSeparator() ;

    String para = ""+outrepid + separator + outrepname  + separator + outrepdesc + separator + modulefilename  + separator + outreptype + separator + outrepcategory  + separator + enmodulefilename + separator + outrepenname + separator + outrependesc + separator + autocolumn + separator + autorow ;
	RecordSet.executeProc("T_OutReport_Update",para);



    // 增加删除报表预定义条件值
    RecordSet.executeSql(" delete T_OutReportCondition where outrepid = " + outrepid);

    for(int i=0 ; i< totaldetail2 ; i++) {
        String conditionid = Util.null2String(request.getParameter("conditionid"+i));
        String conditioncnname = Util.fromScreen(request.getParameter("conditioncnname"+i),user.getLanguage());
        String conditionenname = Util.fromScreen(request.getParameter("conditionenname"+i),user.getLanguage());

        if(!conditionid.equals("")) {
            para = ""+outrepid + separator + conditionid + separator + conditioncnname + separator + conditionenname  ;
	        RecordSet.executeProc("T_OutReportCondition_Insert",para);
        }
    }
    

    // 增加删除明细报表预定义从表和条件值
    if(outrepcategory.equals("1")) {
        RecordSet.executeSql(" update T_OutReport set outreprow = " + outreprow + " where outrepid = " + outrepid );
        RecordSet.executeSql(" delete T_ReportStatSqlValue where outrepid = " + outrepid);
        
        if ( totaldetail1 != 0 ) {
            RecordSet.executeProc("T_ReportStatitemTable_Delete",""+outrepid);

            for(int i=0 ; i< totaldetail1 ; i++) {
                String itemtable = Util.null2String(request.getParameter("itemtable"+i));
                String itemtablealter = Util.null2String(request.getParameter("itemtablealter"+i));
                
                if(!itemtable.equals("") && !itemtablealter.equals("")) {
                    para = ""+outrepid + separator + itemtable + separator + itemtablealter ;
                    RecordSet.executeProc("T_ReportStatitemTable_Insert",para);
                }
            }
        }
    }


    // 增加报表共享是否可以下载打印的控制
        
    RecordSet.executeSql(" update T_OutReportShare set sharelevel = 0 where outrepid = " + outrepid );
    
    String sharelevels[] = request.getParameterValues("sharelevels") ;

    if(sharelevels != null) {
        String sharelevelstr = "" ;

        for(int i=0 ; i<sharelevels.length ; i++) {
            if(i==0) sharelevelstr = sharelevels[i] ;
            else sharelevelstr += "," + sharelevels[i] ;
        }

        RecordSet.executeSql(" update T_OutReportShare set sharelevel = 1 where outrepshareid in ( " + sharelevelstr + " ) " );
    }

 	response.sendRedirect("OutReport.jsp");
 }

 else if(operation.equals("delete")){
    char separator = Util.getSeparator() ;
	String para = ""+outrepid;
	RecordSet.executeProc("T_OutReport_Delete",para);

 	response.sendRedirect("OutReport.jsp");
 }

 else if(operation.equals("adduser")){
    char separator = Util.getSeparator() ;
    String para = "" ;
    if(!usertype.equals("3") ) {
        para = ""+outrepid + separator + userid  + separator + usertype ;
        RecordSet.executeProc("T_OutReportShare_Insert",para);
    }
    else {
        RecordSet.executeSql(" select resourceid from HrmRoleMembers where roleid="+userid + " and resourceid != 1 " );
        while(RecordSet.next()){
            String tmpresourceid = RecordSet.getString("resourceid");
            para = ""+outrepid + separator + tmpresourceid  + separator + "1" ;
            RecordSet.executeProc("T_OutReportShare_Insert",para);
        }
    }
    
    if ( totaldetail2 != 0 ) {
        // 增加删除报表预定义条件值
        RecordSet.executeSql(" delete T_OutReportCondition where outrepid = " + outrepid);

        for(int i=0 ; i< totaldetail2 ; i++) {
            String conditionid = Util.null2String(request.getParameter("conditionid"+i));
            String conditioncnname = Util.fromScreen(request.getParameter("conditioncnname"+i),user.getLanguage());
            String conditionenname = Util.fromScreen(request.getParameter("conditionenname"+i),user.getLanguage());

            if(!conditionid.equals("")) {
                para = ""+outrepid + separator + conditionid + separator + conditioncnname + separator + conditionenname  ;
                RecordSet.executeProc("T_OutReportCondition_Insert",para);
            }
        }
    }

    if ( outrepcategory.equals("1") ) {
        RecordSet.executeSql(" delete T_ReportStatSqlValue where outrepid = " + outrepid);
        if ( totaldetail1 != 0 ) {
            RecordSet.executeProc("T_ReportStatitemTable_Delete",""+outrepid);
            for(int i=0 ; i< totaldetail1 ; i++) {
                String itemtable = Util.null2String(request.getParameter("itemtable"+i));
                String itemtablealter = Util.null2String(request.getParameter("itemtablealter"+i));
                
                if(!itemtable.equals("") && !itemtablealter.equals("")) {
                    para = ""+outrepid + separator + itemtable + separator + itemtablealter ;
                    RecordSet.executeProc("T_ReportStatitemTable_Insert",para);
                }
            }
        }
    }

 	response.sendRedirect("OutReportEdit.jsp?outrepid="+outrepid);
 }

 else if(operation.equals("deleteuser")){
    char separator = Util.getSeparator() ;
	String para = ""+outrepshareid;
	RecordSet.executeProc("T_OutReportShare_Delete",para);
    
    if ( outrepcategory.equals("1") ) {
        RecordSet.executeSql(" delete T_ReportStatSqlValue where outrepid = " + outrepid);
        if ( totaldetail1 != 0 ) {
            RecordSet.executeProc("T_ReportStatitemTable_Delete",""+outrepid);
            for(int i=0 ; i< totaldetail1 ; i++) {
                String itemtable = Util.null2String(request.getParameter("itemtable"+i));
                String itemtablealter = Util.null2String(request.getParameter("itemtablealter"+i));
                
                if(!itemtable.equals("") && !itemtablealter.equals("")) {
                    para = ""+outrepid + separator + itemtable + separator + itemtablealter ;
                    RecordSet.executeProc("T_ReportStatitemTable_Insert",para);
                }
            }
        }
    }

    if ( totaldetail2 != 0 ) {
        // 增加删除报表预定义条件值
        RecordSet.executeSql(" delete T_OutReportCondition where outrepid = " + outrepid);

        for(int i=0 ; i< totaldetail2 ; i++) {
            String conditionid = Util.null2String(request.getParameter("conditionid"+i));
            String conditioncnname = Util.fromScreen(request.getParameter("conditioncnname"+i),user.getLanguage());
            String conditionenname = Util.fromScreen(request.getParameter("conditionenname"+i),user.getLanguage());

            if(!conditionid.equals("")) {
                para = ""+outrepid + separator + conditionid + separator + conditioncnname + separator + conditionenname  ;
                RecordSet.executeProc("T_OutReportCondition_Insert",para);
            }
        }
    }
 	response.sendRedirect("OutReportEdit.jsp?outrepid="+outrepid);
 }
 else if(operation.equals("addstatitem")){
    char separator = Util.getSeparator() ;
	String para = ""+outrepid + separator + statitemid  ;
	RecordSet.executeProc("T_OutReportStatitem_Insert",para);

 	response.sendRedirect("OutReportStatitem.jsp?outrepid="+outrepid);
 }
 else if(operation.equals("savestatitem")){
    RecordSet.executeSql("update T_OutReportStatitem set needthismonth = '' , needthisyear = '' , needlastmonth = '' , needlastyear = '' where outrepid = " + outrepid );

    String[] alloutrepitemids = request.getParameterValues("outrepitemids") ;
    if( alloutrepitemids != null ) {
        String theoutrepitemid = "" ;
        String needthismonth = "" ;
        String needthisyear = "" ;
        String needlastmonth = "" ;
        String needlastyear = "" ;

        for(int i=0 ; i<alloutrepitemids.length ; i++) {
            theoutrepitemid = alloutrepitemids[i] ;
            needthismonth = Util.null2String(request.getParameter("needthismonth_"+theoutrepitemid));
            needthisyear = Util.null2String(request.getParameter("needthisyear_"+theoutrepitemid));
            needlastmonth = Util.null2String(request.getParameter("needlastmonth_"+theoutrepitemid));
            needlastyear = Util.null2String(request.getParameter("needlastyear_"+theoutrepitemid));

            RecordSet.executeSql("update T_OutReportStatitem set needthismonth = '"+needthismonth+"' , needthisyear = '"+needthisyear+"' , needlastmonth = '"+needlastmonth+"' , needlastyear = '"+needlastyear+"' where outrepitemid = " + theoutrepitemid );
        }
    }
 	response.sendRedirect("OutReportStatitem.jsp?outrepid="+outrepid);
 }

 else if(operation.equals("deletestatitem")){
    char separator = Util.getSeparator() ;
	String para = ""+outrepitemid;
	RecordSet.executeProc("T_OutReportStatitem_Delete",para);

 	response.sendRedirect("OutReportStatitem.jsp?outrepid="+outrepid);
 }

 else if(operation.equals("uporder")){
    char separator = Util.getSeparator() ;
	String para = ""+outrepitemid + separator + "1"  ; // 1 代表向上调整
	RecordSet.executeProc("T_OutReportStatitem_Uorder",para);

 	response.sendRedirect("OutReportStatitem.jsp?outrepid="+outrepid);
 }

 else if(operation.equals("downorder")){
    char separator = Util.getSeparator() ;
	String para = ""+outrepitemid + separator + "2"  ; // 2 代表向下调整
	RecordSet.executeProc("T_OutReportStatitem_Uorder",para);

 	response.sendRedirect("OutReportStatitem.jsp?outrepid="+outrepid);
 }

 else if(operation.equals("copy")){
    char separator = Util.getSeparator() ;
	String para = ""+outrepid;
	RecordSet.executeProc("T_OutReport_Copy",para);

 	response.sendRedirect("OutReport.jsp");
 }

 else if(operation.equals("change")){
    String sql = "" ;
    int changenum = 0 ;
    char separator = Util.getSeparator() ;
    String para = "" ;

    switch(Util.getIntValue(changetype)) {
        case 1:
            sql = " update T_OutReport set outreprow = outreprow+1 where outrepid = " + outrepid ;
            RecordSet.executeSql(sql);
            
            if(rowtype.equals("1")) changenum = 1 ;
            else changenum = addrownum +1 ;

            sql = " update T_OutReportItem set itemrow = itemrow+1 where itemrow >= " + changenum +" and outrepid = " + outrepid ;
            RecordSet.executeSql(sql);
            break ;
        
        case 2:
            sql = " update T_OutReport set outrepcolumn = outrepcolumn+1 where outrepid = " + outrepid ;
            RecordSet.executeSql(sql);

            if(columntype.equals("1")) changenum = 1 ;
            else changenum = addcolumnnum +1 ;

            sql = " update T_OutReportItem set itemcolumn = itemcolumn+1 where itemcolumn >= " + changenum +" and outrepid = " + outrepid ;
            RecordSet.executeSql(sql);
            break ;

        case 3:
            sql = " update T_OutReport set outreprow = outreprow-1 where outrepid = " + outrepid ;
            RecordSet.executeSql(sql);

            para = ""+outrepid + separator + ""+delrownum  ;
            RecordSet.executeProc("T_OutReportItem_DeleteByRow",para);

            sql = " update T_OutReportItem set itemrow = itemrow-1 where itemrow > " + delrownum +" and outrepid = " + outrepid ;
            RecordSet.executeSql(sql);

			//Guosheng 2005-2-3 Modify 删除行时必须把指定的客户组也删除掉，否则结果会不正确
			sql = " delete T_OutReportItemRowGroup where outrepid= " + outrepid +" and itemrow  = " + delrownum ;
            RecordSet.executeSql(sql);

            break ;

        case 4:
            sql = " update T_OutReport set outrepcolumn = outrepcolumn-1 where outrepid = " + outrepid ;
            RecordSet.executeSql(sql);
            
            para = ""+outrepid  + separator + ""+delcolumnnum ;
            RecordSet.executeProc("T_OutReportItem_DeleteByCol",para);

            sql = " update T_OutReportItem set itemcolumn = itemcolumn-1 where itemcolumn > " + delcolumnnum +" and outrepid = " + outrepid ;
            RecordSet.executeSql(sql);
            break ;
    }

 	response.sendRedirect("OutReportChange.jsp?outrepid="+outrepid+"&msg=1&outrepcategory="+outrepcategory);
 }

%>
