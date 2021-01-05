<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ConditionComInfo" class="weaver.datacenter.ConditionComInfo" scope="page" />

<%


String operation = Util.null2String(request.getParameter("operation"));
String itemid = Util.null2String(request.getParameter("itemid"));
String outrepid = Util.null2String(request.getParameter("outrepid"));
String itemrow = Util.null2String(request.getParameter("itemrow"));
String itemcolumn = Util.null2String(request.getParameter("itemcolumn"));
String itemtype = Util.null2String(request.getParameter("itemtype"));


String itemexpress = Util.fromScreen(request.getParameter("itemexpress"),user.getLanguage());

String itemdesc = Util.fromScreen(request.getParameter("itemdesc"),user.getLanguage());
String itemexpresstype = Util.null2String(request.getParameter("itemexpresstype"));
String itemmodtype = Util.null2String(request.getParameter("itemmodtype"));
String picstatbudget = ""+ Util.getIntValue(request.getParameter("picstatbudget"),0);
String picstatlast = ""+ Util.getIntValue(request.getParameter("picstatlast"),0);
String picstat = ""+ Util.getIntValue(request.getParameter("picstat"),0);
int totaldetail1 = Util.getIntValue(request.getParameter("totaldetail1"),0);
int totaldetail2 = Util.getIntValue(request.getParameter("totaldetail2"),0);
int totaldetail3 = Util.getIntValue(request.getParameter("totaldetail3"),0);


String fromitem = Util.null2String(request.getParameter("fromitem"));
String toitems[] = request.getParameterValues("toitem");
int outrepcolumn = Util.getIntValue(request.getParameter("outrepcolumn"),0);
int outreprow = Util.getIntValue(request.getParameter("outreprow"),0);

String deletetype = Util.null2String(request.getParameter("deletetype"));

String sqlfrom = "" ;
String sqlcondition = "" ;


if(operation.equals("edit")){


    char separator = Util.getSeparator() ;

	String para = itemid + separator + outrepid
		+ separator + itemrow + separator + itemcolumn + separator + itemtype + separator + itemexpress + separator + itemdesc + separator + itemexpresstype + separator + picstatbudget + separator + picstatlast + separator + picstat + separator + itemmodtype;

	RecordSet.executeProc("T_OutReportItem_Insert",para);
    RecordSet.next() ;
    
    itemid = RecordSet.getString(1) ;

    if(itemtype.equals("2")) {
        
        ArrayList tables = new ArrayList() ;
        ArrayList tablenames = new ArrayList() ;
        ArrayList conditionids = new ArrayList() ;
        ArrayList conditionvalues = new ArrayList() ;

        for(int i=0 ; i< totaldetail1 ; i++) {
            String itemtable = Util.null2String(request.getParameter("itemtable"+i));
            String itemtablealter = Util.null2String(request.getParameter("itemtablealter"+i));
            
            if(!itemtable.equals("") && !itemtablealter.equals("")) {
                para = itemid + separator + itemtable + separator + itemtablealter ;
                RecordSet.executeProc("T_OutReportItemTable_Insert",para);
                tables.add(itemtablealter) ;
                tablenames.add(itemtable) ;
            }
        }


        for(int i=0 ; i< totaldetail2 ; i++) {
            String conditionid = Util.null2String(request.getParameter("conditionid"+i));
            String conditionvalue = Util.fromScreen(request.getParameter("conditionvalue"+i),user.getLanguage());

            if(!conditionid.equals("") && !conditionvalue.equals("")) {
                para = itemid + separator + conditionid + separator + conditionvalue ;
                RecordSet.executeProc("T_OutRItemCondition_Insert",para);
                conditionids.add(conditionid) ;
                conditionvalues.add(conditionvalue) ;
            }
        }


        for(int i=0 ; i< totaldetail3 ; i++) {
            String coordinatename = Util.fromScreen(request.getParameter("coordinatename"+i),user.getLanguage());
            String coordinatevalue = Util.fromScreen(request.getParameter("coordinatevalue"+i),user.getLanguage());

            if(!coordinatename.equals("") && !coordinatevalue.equals("")) {
                para = itemid + separator + coordinatename + separator + coordinatevalue ;
                RecordSet.executeProc("T_OutReportICoordinate_Insert",para);
            }
        }


    
        String fromyear = "1960" ;
        String frommonth = "01" ;
        String fromday = "01" ;
        String toyear = "3000" ;
        String tomonth = "12" ;
        String today = "31" ;


        if(tables.size() != 0) {

            for(int j=0 ; j<conditionids.size() ; j++) {
                String tempconditionid = (String)conditionids.get(j) ;
                String tempconditionvalue = (String)conditionvalues.get(j) ;

                if(tempconditionvalue.indexOf("-") > 0) {
                    tempconditionvalue = Util.StringReplaceOnce(tempconditionvalue,"-","@-") ;
                }

                if(tempconditionvalue.indexOf("+") > 0) {
                    tempconditionvalue = Util.StringReplaceOnce(tempconditionvalue,"+","@+") ;
                }

                if(tempconditionvalue.indexOf("*") > 0) {
                    tempconditionvalue = Util.StringReplaceOnce(tempconditionvalue,"*","@*") ;
                }

                if(tempconditionvalue.indexOf("/") > 0) {
                    tempconditionvalue = Util.StringReplaceOnce(tempconditionvalue,"/","@/") ;
                }

                
                if(tempconditionid.equals("1") || tempconditionvalue.equalsIgnoreCase("$crm_code") ) {
                    if(sqlcondition.equals("")) {
                        if(tempconditionvalue.equalsIgnoreCase("$crm")) {
                            sqlcondition = " where CRM_CustomerInfo.id=" ;
                            for(int i=0;i<tables.size();i++) {
                                String temptable = (String)tables.get(i) ;
                                if(i==0) sqlcondition += temptable+".crmid " ;
                                else sqlcondition += " and CRM_CustomerInfo.id="+ temptable+".crmid " ;
                            }
                            sqlcondition += " and CRM_CustomerInfo.id in("+tempconditionvalue+") " ;
                        }
                        else {
                            if(tempconditionvalue.equalsIgnoreCase("$crm_code")) tempconditionvalue = "$crm" ;
                            sqlcondition = " where CRM_CustomerInfo.id=" ;
                            for(int i=0;i<tables.size();i++) {
                                String temptable = (String)tables.get(i) ;
                                if(i==0) sqlcondition += temptable+".crmid " ;
                                else sqlcondition += " and CRM_CustomerInfo.id="+ temptable+".crmid " ;
                            }
                            sqlcondition += " and CRM_CustomerInfo.engname like ''"+tempconditionvalue+"'' " ;
                        }
                    }
                    else {
                        if(tempconditionvalue.equalsIgnoreCase("$crm")) {
                            sqlcondition += " and CRM_CustomerInfo.id=" ;
                            for(int i=0;i<tables.size();i++) {
                                String temptable = (String)tables.get(i) ;
                                if(i==0) sqlcondition += temptable+".crmid " ;
                                else sqlcondition += " and CRM_CustomerInfo.id="+ temptable+".crmid " ;
                            }
                            sqlcondition += " and CRM_CustomerInfo.id in("+tempconditionvalue+") " ;
                        }
                        else {
                            if(tempconditionvalue.equalsIgnoreCase("$crm_code")) tempconditionvalue = "$crm" ;
                            sqlcondition += " and CRM_CustomerInfo.id=" ;
                            for(int i=0;i<tables.size();i++) {
                                String temptable = (String)tables.get(i) ;
                                if(i==0) sqlcondition += temptable+".crmid " ;
                                else sqlcondition += " and CRM_CustomerInfo.id="+ temptable+".crmid " ;
                            }
                            sqlcondition += " and CRM_CustomerInfo.engname like ''"+tempconditionvalue+"'' " ;
                        }
                    }
                }

                else if(tempconditionid.equals("2")) fromyear = tempconditionvalue ;
                else if(tempconditionid.equals("3")) {
                    if(tempconditionvalue.indexOf("$") ==0) frommonth = tempconditionvalue ;
                    else frommonth = Util.add0(Util.getIntValue(tempconditionvalue,0),2) ;
                }
                else if(tempconditionid.equals("4")) {
                    if(tempconditionvalue.indexOf("$") ==0) fromday = tempconditionvalue ;
                    else fromday = Util.add0(Util.getIntValue(tempconditionvalue,0),2) ;
                }
                else if(tempconditionid.equals("5")) toyear = tempconditionvalue ;
                else if(tempconditionid.equals("6")) {
                    if(tempconditionvalue.indexOf("$") ==0) tomonth = tempconditionvalue ;
                    else tomonth = Util.add0(Util.getIntValue(tempconditionvalue,0),2) ;
                }
                else if(tempconditionid.equals("7")) {
                    if(tempconditionvalue.indexOf("$") ==0) today = tempconditionvalue ;
                    else today = Util.add0(Util.getIntValue(tempconditionvalue,0),2) ;
                }
                else {
                    String tempfieldname = ConditionComInfo.getConditionitemfieldnames(tempconditionid) ;
                    String temptable1 = "" ;
                    
                    if(sqlcondition.equals("")) {
                        for(int i=0;i<tables.size();i++) {
                            String temptable = (String)tables.get(i) ;
                            
                            if(i==1) sqlcondition = " where "+temptable1+"."+tempfieldname+" = "+temptable +"."+tempfieldname ;
                            
                            if(i>1) sqlcondition += " and "+temptable1+"."+tempfieldname+" = "+temptable +"."+tempfieldname ;

                            temptable1 = temptable ;
                        }
                        
                        if(sqlcondition.equals("")) sqlcondition = " where "+ temptable1+"."+tempfieldname+" = ''"+tempconditionvalue+"'' " ;
                        else sqlcondition += " and "+ temptable1+"."+tempfieldname+" = ''"+tempconditionvalue+"'' " ;
                    }
                    else {
                        for(int i=0;i<tables.size();i++) {
                            String temptable = (String)tables.get(i) ;
                            
                            if(i>=1) sqlcondition += " and "+temptable1+"."+tempfieldname+" = "+temptable +"."+tempfieldname ;

                            temptable1 = temptable ;
                        }
                        
                        sqlcondition += " and "+ temptable1+"."+tempfieldname+" = ''"+tempconditionvalue+"'' " ;
                    }
                }
            }

            String fromdate = fromyear+"-" + frommonth + "-" + fromday ;
            String todate = toyear+"-" + tomonth + "-" + today ;
            String temptable1 = "" ;

            if(sqlcondition.equals("")) {
                for(int i=0;i<tables.size();i++) {
                    String temptable = (String)tables.get(i) ;
                    
                    if(i==1) sqlcondition = " where "+temptable1+".reportdate = "+temptable +".reportdate" ;
                    
                    if(i>1) sqlcondition += " and "+temptable1+".reportdate = "+temptable +".reportdate" ;

                    temptable1 = temptable ;
                }
                
                if(sqlcondition.equals("")) sqlcondition = " where "+ temptable1+".reportdate >= ''"+fromdate+"'' and " + temptable1+".reportdate <= ''"+todate+"'' ";
                else sqlcondition += " and "+ temptable1+".reportdate >= ''"+fromdate+"' and " + temptable1+".reportdate <= ''"+todate+"'' ";
            }
            else {
                for(int i=0;i<tables.size();i++) {
                    String temptable = (String)tables.get(i) ;
                    
                    if(i>=1) sqlcondition += " and "+temptable1+".reportdate = "+temptable +".reportdate" ;
                    
                    temptable1 = temptable ;
                }
                
                sqlcondition += " and "+ temptable1+".reportdate >= ''"+fromdate+"'' and " + temptable1+".reportdate <= ''"+todate+"'' ";
            }

            String inputstatus = "$inputstatus" ;

            if(sqlcondition.equals("")) {
                for(int i=0;i<tables.size();i++) {
                    String temptable = (String)tables.get(i) ;

                    if(i==0) sqlcondition = " where "+temptable+".inputstatus >= ''"+inputstatus +"'' " ;
                    
                    if(i>0) sqlcondition += " and "+temptable+".inputstatus >= ''"+inputstatus +"'' " ;
                }
            }
            else {
                for(int i=0;i<tables.size();i++) {
                    String temptable = (String)tables.get(i) ;
                    sqlcondition += " and "+temptable+".inputstatus >= ''"+inputstatus +"'' " ;

                }
                
            }


            for(int i=0 ; i< tables.size() ; i++ ) {
                if(sqlfrom.equals("")) sqlfrom = "from " + (String)tablenames.get(i) +" "+  (String)tables.get(i) ;
                else sqlfrom += " , " + (String)tablenames.get(i) +" "+ (String)tables.get(i) ;
            }

            for(int i=0 ; i<conditionids.size() ; i++) {
                String tempconditionid = (String)conditionids.get(i) ;
                if(!tempconditionid.equals("1")) continue ;
                sqlfrom += " , CRM_CustomerInfo " ;
            }
            
            RecordSet.executeSql("update T_OutReportItem set itemtable ='"+sqlfrom+"' where itemid="+itemid);

            RecordSet.executeSql("update T_OutReportItem set itemcondition ='"+Util.fromBaseEncoding2(sqlcondition,7)+"' where itemid="+itemid);

        } 
    }

    response.sendRedirect("OutReportItemDetail.jsp?haspost=1&desc="+itemdesc); 
}

if(operation.equals("delete")){


    char separator = Util.getSeparator() ;
  	
	String para = itemid  ;

	RecordSet.executeProc("T_OutReportItem_Delete",para);
    
    response.sendRedirect("OutReportItemDetail.jsp?haspost=2");
}


if(operation.equals("copy")){ 

    if(!fromitem.equals(""))  {
        if(toitems != null) {

            char separator = Util.getSeparator() ;

            int toitemcount = toitems.length ;

            if(fromitem.indexOf("row_") == 0 ) {
                String fromrow = fromitem.substring(4) ;

                for(int countindex =0 ; countindex < toitemcount ; countindex++) {
                    String toitemvalue = toitems[countindex] ;
                    if(toitemvalue.indexOf("row_") != 0 ) continue ;
                    String torow = toitemvalue.substring(4) ;
                    
                    if(fromrow.equals(torow)) continue ;

                    for(int i= 1 ; i <= outrepcolumn ; i++) {
                        
                        String para = outrepid + separator + torow
                            + separator + ""+i + separator + fromrow + separator + ""+i  ;
                        RecordSet.executeProc("T_OutReportItem_Copy",para);
                    }
                }
            }

            if(fromitem.indexOf("col_") == 0 ) {
                String fromcol = fromitem.substring(4) ;

                for(int countindex =0 ; countindex < toitemcount ; countindex++) {
                    String toitemvalue = toitems[countindex] ;
                    if(toitemvalue.indexOf("col_") != 0 ) continue ;
                    String tocol = toitemvalue.substring(4) ;
                    
                    if(fromcol.equals(tocol)) continue ;

                    for(int i= 1 ; i <= outreprow ; i++) {
                        
                        String para = outrepid + separator + ""+i
                            + separator + tocol + separator + ""+i + separator + fromcol  ;
                        RecordSet.executeProc("T_OutReportItem_Copy",para);
                    }
                }
            }

            if(fromitem.indexOf("rowcol_") == 0 ) {
                String fromrowcol[] = Util.TokenizerString2(fromitem,"_") ;
                String fromrow = fromrowcol[1] ;
                String fromcol = fromrowcol[2] ;

                for(int countindex =0 ; countindex < toitemcount ; countindex++) {
                    String toitemvalue = toitems[countindex] ;
                    
                    if(toitemvalue.indexOf("col_") == 0 ) {
                        String tocol = toitemvalue.substring(4) ;
                    
                        for(int i= 1 ; i <= outreprow ; i++) {
                            String torow = "" +i ;
                            if(fromrow.equals(torow) && fromcol.equals(tocol)) continue ;

                            String para = outrepid + separator + torow
                                + separator + tocol + separator + fromrow + separator + fromcol  ;
                            RecordSet.executeProc("T_OutReportItem_Copy",para);
                        }
                    }

                    if(toitemvalue.indexOf("row_") == 0 ) {
                        String torow = toitemvalue.substring(4) ;
                    
                        for(int i= 1 ; i <= outrepcolumn ; i++) {
                            String tocol = "" +i ;
                            if(fromrow.equals(torow) && fromcol.equals(tocol)) continue ;

                            String para = outrepid + separator + torow
                                + separator + tocol + separator + fromrow + separator + fromcol  ;
                            RecordSet.executeProc("T_OutReportItem_Copy",para);
                        }
                    }

                    if(toitemvalue.indexOf("rowcol_") == 0 ) {
                        String torowcol[] = Util.TokenizerString2(toitemvalue,"_") ;
                        String torow = torowcol[1] ;
                        String tocol = torowcol[2] ;
                    
                        if(fromrow.equals(torow) && fromcol.equals(tocol)) continue ;

                        String para = outrepid + separator + torow
                            + separator + tocol + separator + fromrow + separator + fromcol  ;
                        RecordSet.executeProc("T_OutReportItem_Copy",para);
                    }
                }
            }
        }
    }

    response.sendRedirect("OutReportItem.jsp?outrepid="+outrepid);
}


if(operation.equals("deletebatch")){

    char separator = Util.getSeparator() ;

    if(deletetype.equals("1")) {

        for(int j= 1 ; j<= outrepcolumn ; j++ ) {
                String para = outrepid + separator + itemrow + separator + ""+j   ;
                RecordSet.executeProc("T_OutReportItem_DeleteByRowCol",para);
        }
    }

    else if(deletetype.equals("2")) {

        for(int j= 1 ; j<= outreprow ; j++ ) {
                String para = outrepid + separator + ""+j + separator + itemcolumn   ;
                RecordSet.executeProc("T_OutReportItem_DeleteByRowCol",para);
        }
    }
    
    response.sendRedirect("OutReportItem.jsp?outrepid="+outrepid);
}

if(operation.equals("editrow")){

    RecordSet.executeSql(" select rowid from T_OutReportItemRow where outrepid="+outrepid+" and itemrow="+itemrow );

    if(RecordSet.next()) {
        RecordSet.executeSql(" delete from T_OutReportItemRow where outrepid="+outrepid+" and itemrow="+itemrow );
    }
    else {
        RecordSet.executeSql(" insert into T_OutReportItemRow(outrepid,itemrow) values("+outrepid+","+itemrow +")");
    }
    
    response.sendRedirect("OutReportItem.jsp?outrepid="+outrepid);
}


%>
