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
String itemendesc = Util.fromScreen(request.getParameter("itemendesc"),user.getLanguage());
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
		+ separator + itemrow + separator + itemcolumn + separator + itemtype + separator + itemexpress + separator + itemdesc + separator + itemexpresstype + separator + picstatbudget + separator + picstatlast + separator + picstat + separator + itemmodtype + separator + itemendesc ;

	RecordSet.executeProc("T_OutReportItem_Insert",para);
    RecordSet.next() ;
    
    itemid = RecordSet.getString(1) ;

    if(itemtype.equals("2")) {
        
        ArrayList tables = new ArrayList() ;
        ArrayList tablenames = new ArrayList() ;
        ArrayList conditionids = new ArrayList() ;
        ArrayList conditionvalues = new ArrayList() ;
        String thetemptable = "" ;

        for(int i=0 ; i< totaldetail1 ; i++) {
            String itemtable = Util.null2String(request.getParameter("itemtable"+i));
            String itemtablealter = Util.null2String(request.getParameter("itemtablealter"+i));
            
            if(!itemtable.equals("")) {
                para = itemid + separator + itemtable + separator + itemtablealter ;
                RecordSet.executeProc("T_OutReportItemTable_Insert",para);
                tables.add(itemtablealter) ;
                tablenames.add(itemtable) ;
                if(thetemptable.equals("")) thetemptable = itemtablealter ;
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

        String fromyear = "" ;
        String frommonth = "$monthf" ;
        String fromday = "$dayf" ;
        String toyear = "" ;
        String tomonth = "$montht" ;
        String today = "$dayt" ;


        if(tables.size() != 0) {

            String conditionkey = " where " ;

            for(int j=0 ; j<conditionids.size() ; j++) {
                int tempconditionid = Util.getIntValue((String)conditionids.get(j),0) ;
                String tempconditionvalue = (String)conditionvalues.get(j) ;

                if(tempconditionid == 1 || tempconditionvalue.equalsIgnoreCase("$crm_code") ) {
                    if(tempconditionvalue.equalsIgnoreCase("$crm")) {
                        sqlcondition += conditionkey + " CRM_CustomerInfo.id=" + thetemptable + ".crmid " +
                                       " and CRM_CustomerInfo.id in("+tempconditionvalue+") " ;
                    }
                    else {
                        if(tempconditionvalue.equalsIgnoreCase("$crm_code")) tempconditionvalue = "$crm" ;
                        sqlcondition += conditionkey + " CRM_CustomerInfo.id=" + thetemptable+".crmid " + 
                                       " and CRM_CustomerInfo.crmcode like ''"+tempconditionvalue+"'' " ;
                    }
                    conditionkey = " and " ;
                }
                else if(tempconditionid == 2 ) fromyear = "$yearf" ;
                else if(tempconditionid == 5 ) toyear = "$yeart" ;
                else if(tempconditionid > 7 ) {
                    String tempfieldname = ConditionComInfo.getConditionitemfieldnames(""+tempconditionid) ;
                    
                    if(tempconditionvalue.indexOf("%") == -1 ) sqlcondition += conditionkey + thetemptable+"."+tempfieldname+" = ''"+tempconditionvalue+"'' " ;
                    else sqlcondition += conditionkey + thetemptable+"."+tempfieldname+" like  ''"+tempconditionvalue+"'' " ;

                    conditionkey = " and " ;
                }
            }

            String fromdate = "" ;
            String todate = "" ;

            if(!fromyear.equals("") && !frommonth.equals("") && !fromday.equals("")) {
                fromdate = fromyear+"-" + frommonth + "-" + fromday ;
                sqlcondition += conditionkey + thetemptable+".reportdate >= ''"+fromdate+"'' ";
                conditionkey = " and " ;
            }

            if(!toyear.equals("") && !tomonth.equals("") && !today.equals("")) {
                todate = toyear+"-" + tomonth + "-" + today ;
                sqlcondition += conditionkey + thetemptable+".reportdate <= ''"+todate+"'' ";
                conditionkey = " and " ;
            }

            String inputstatus = "$inputstatus" ;

            sqlcondition += conditionkey + thetemptable+".inputstatus >= ''"+inputstatus +"'' " ;
                    

            for(int i=0 ; i< tables.size() ; i++ ) {
                if(sqlfrom.equals("")) 
                    sqlfrom = "from " + (String)tablenames.get(i) +" "+  (String)tables.get(i) ;
                else {
                    String temptable = (String)tables.get(i) ;
                    sqlfrom += " left join " + (String)tablenames.get(i) +" "+ temptable ;
                    conditionkey = " on " ;

                    for(int j=0 ; j<conditionids.size() ; j++) {
                        int tempconditionid = Util.getIntValue((String)conditionids.get(j),0) ;
                        String tempconditionvalue = (String)conditionvalues.get(j) ;

                        if(tempconditionid == 1 || tempconditionvalue.equalsIgnoreCase("$crm_code") ) {
                            sqlfrom += conditionkey + thetemptable + ".crmid = " + temptable + ".crmid " ;
                            conditionkey = " and " ;
                        }
                        else if(tempconditionid > 7 ) {
                            String tempfieldname = ConditionComInfo.getConditionitemfieldnames(""+tempconditionid) ;
                            sqlfrom += conditionkey + thetemptable + "." + tempfieldname + " = " + temptable + "." + tempfieldname ;
                            conditionkey = " and " ;
                        }
                    }
                    if(!fromdate.equals("") || !todate.equals("") ) {
                        sqlfrom += conditionkey + thetemptable + ".reportdate = " + temptable + ".reportdate " ;
                        conditionkey = " and " ;
                    }
                    sqlfrom += conditionkey + thetemptable + ".modtype = " + temptable + ".modtype " ;
                }
            }

            for(int j=0 ; j<conditionids.size() ; j++) {
                int tempconditionid = Util.getIntValue((String)conditionids.get(j),0) ;
                String tempconditionvalue = (String)conditionvalues.get(j) ;
                if(tempconditionid == 1 || tempconditionvalue.equalsIgnoreCase("$crm_code") ) {
                    sqlfrom += " , CRM_CustomerInfo " ;
                    break ;
                }
            }

            RecordSet.executeSql("update T_OutReportItem set itemtable ='"+sqlfrom+"' , itemcondition = '" +
                                 sqlcondition + "' , firstaltertablename = '" + thetemptable + "' " +
                                 " where itemid="+itemid) ;
        } 
    }
    
    // 改为有post 方法提交
%>
    <HTML>
    <BODY onload='frOutReportItemOperation.submit ()'>
    <FORM name=frOutReportItemOperation method=post action='OutReportItemDetail.jsp'>
        <input type=hidden name=haspost value="1">
        <input type=hidden name=desc value="<%=itemdesc%>">
    </FORM>
    </BODY>
    </HTML>
<%
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

    RecordSet.executeSql(" select row_id from T_OutReportItemRow where outrepid="+outrepid+" and itemrow="+itemrow );

    if(RecordSet.next()) {
        RecordSet.executeSql(" delete from T_OutReportItemRow where outrepid="+outrepid+" and itemrow="+itemrow );
    }
    else {
        RecordSet.executeSql(" insert into T_OutReportItemRow(outrepid,itemrow) values("+outrepid+","+itemrow +")");
    }
    
    response.sendRedirect("OutReportItem.jsp?outrepid="+outrepid);
}

if(operation.equals("editcrmgroup")){


    RecordSet.executeSql(" delete T_OutReportItemRowGroup where outrepid="+outrepid+" and itemrow="+itemrow );
    String crmgroup = Util.null2String(request.getParameter("crmgroup"));
    
    if (!crmgroup.equals("")) RecordSet.executeSql(" insert into T_OutReportItemRowGroup(outrepid,itemrow,rowgroup) values("+outrepid+","+itemrow +",'"+crmgroup+"')");

    response.sendRedirect("OutReportItem.jsp?outrepid="+outrepid);

}


%>
