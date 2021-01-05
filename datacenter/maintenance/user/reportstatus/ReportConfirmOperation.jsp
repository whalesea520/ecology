<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />


<%
String operation = Util.null2String(request.getParameter("operation"));

String confirmid = Util.null2String(request.getParameter("confirmid"));
String thetable = Util.null2String(request.getParameter("thetable"));
String inputid = Util.null2String(request.getParameter("inputid"));
String inputmodid = Util.null2String(request.getParameter("inputmodid"));
String inprepid = Util.null2String(request.getParameter("inprepid"));
String thedate = Util.null2String(request.getParameter("thedate"));
String usertitle = "" + Util.getIntValue(user.getTitle(), 0) ;
String inprepbudget = Util.null2String(request.getParameter("inprepbudget"));



if(operation.equals("edit")){

    Hashtable ht = new Hashtable() ;
    Hashtable ht_mod = new Hashtable() ;            // 修正中的数据

    Enumeration eu = request.getParameterNames() ;
    while(eu.hasMoreElements() ) {
        String keyname = (String)eu.nextElement() ;
        String keyvalue = Util.null2String(request.getParameter(keyname)) ;

        double keyvaluedouble = Util.getDoubleValue(keyvalue , 0) ;
        if(keyname.indexOf("_mod") < 0) ht.put(keyname , ""+keyvaluedouble) ; // 非修正中的数据
        else ht_mod.put(keyname.substring(0,keyname.length()-4) , ""+keyvaluedouble) ; // 修正中的数据
    }

    
    String sql = "" ; 
    String sqlmod = "" ;
    
    RecordSet.executeProc("T_IRItem_SelectByInprepid",inprepid);


    while (RecordSet.next()) {
        String itemfieldname = Util.null2String(RecordSet.getString("itemfieldname")) ;
        String itemfieldtype = Util.null2String(RecordSet.getString("itemfieldtype")) ;
        String itemgongsi = Util.null2String(RecordSet.getString("itemgongsi")) ;
        String inputablefact = Util.null2String(RecordSet.getString("inputablefact")) ; // 实际是否可输入
        String inputablebudg = Util.null2String(RecordSet.getString("inputablebudg")) ; // 预算是否可输入
        String inputablefore = Util.null2String(RecordSet.getString("inputablefore")) ; // 预测是否可输入
        String inputable = inputablefact ;
        if(inprepbudget.equals("1")) inputable = inputablebudg ;
        else if(inprepbudget.equals("2")) inputable = inputablefore ;
        
        if(sql.equals("")) {
            sql = " update " + thetable + " set "+ itemfieldname +" = " ;
        }
        else {
            sql += ","+itemfieldname+"=" ;
        }

        String itemvalue = "" ;
        
        if(itemfieldtype.equals("2")) itemvalue = "" + Util.getIntValue(request.getParameter(itemfieldname),0);
        else if(itemfieldtype.equals("3") || (itemfieldtype.equals("5") && inputable.equals("1")) ) itemvalue = "" + Util.getDoubleValue(request.getParameter(itemfieldname),0);
        else if(itemfieldtype.equals("5") && !inputable.equals("1") ) {
            String thesql = Util.fillValuesToString(itemgongsi, ht) ;
            rs2.executeSql(" select " + thesql +" as result ") ;
            if(rs2.next()) itemvalue = ""+Util.getDoubleValue(rs2.getString(1),0) ;
            else itemvalue = "0" ;
        }
        else itemvalue = Util.null2String(request.getParameter(itemfieldname));

        if(itemfieldtype.equals("2") || itemfieldtype.equals("3") || itemfieldtype.equals("5") ) {
            sql += itemvalue ;
        }
        else  {
            sql += "'" + Util.fromScreen2(itemvalue,user.getLanguage()) + "'" ;
        }
        
        if(itemfieldtype.equals("2") || itemfieldtype.equals("3") || itemfieldtype.equals("5") ) {
            if(sqlmod.equals("")) {
                sqlmod = " update " + thetable + " set "+ itemfieldname +" = " ;
            }
            else {
                sqlmod += ","+itemfieldname+"=" ;
            }

            itemvalue = Util.null2String(request.getParameter(itemfieldname+"_mod"));
            if(itemfieldtype.equals("2")) {
                sqlmod += Util.getIntValue(itemvalue,0) ;
            }
            else if(itemfieldtype.equals("3") || (itemfieldtype.equals("5") && inputable.equals("1")) ) {
                sqlmod += Util.getDoubleValue(itemvalue,0) ;
            }
            else if(itemfieldtype.equals("5") && !inputable.equals("1") ) {
                String thesql = Util.fillValuesToString(itemgongsi, ht_mod) ;
                rs2.executeSql(" select " + thesql +" as result ") ;
                if(rs2.next()) itemvalue = ""+Util.getDoubleValue(rs2.getString(1),0) ;
                sqlmod += Util.getDoubleValue(itemvalue,0) ;
            }
        }

    }

    sql += " where inputid = " + inputid ;
    sqlmod += " where inputid = " + inputmodid ;

        
    RecordSet.executeSql(sql);
//    out.print("sql 2 is " + sql) ;
    RecordSet.executeSql(sqlmod);
//    out.print("sql 3 is " + sqlmod) ;

    
    if(confirmid.equals("0"))
        response.sendRedirect("ReportConfirmDetail.jsp?thetable="+thetable+"&inputid="+inputid+"&inprepid="+inprepid+"&inprepbudget="+inprepbudget);
    else 
        response.sendRedirect("ReportConfirmDetail.jsp?confirmid="+confirmid);   
}

else if(operation.equals("confirm")){
    
    String sql = " update " + thetable + " set inputstatus='1' , confirmuserid = "+ usertitle+ " where inputid = " + inputid ;

    RecordSet.executeSql(sql);

    sql = " update " + thetable + " set inputstatus='1' , confirmuserid = "+ usertitle+ " where inputid = " + inputmodid ;

    RecordSet.executeSql(sql);

    RecordSet.executeProc("T_InputReportConfirm_Delete", confirmid );

    response.sendRedirect("ReportConfirm.jsp");
}

else if(operation.equals("check")){
    
    String sql = " update " + thetable + " set inputstatus='2' where reportdate = '" + thedate + "' ";

    RecordSet.executeSql(sql);

    response.sendRedirect("ReportDetailStatus.jsp?inprepid="+inprepid);
}
else if(operation.equals("reject")){
    
    String sql = " update " + thetable + " set inputstatus='0' where inputid = " + inputid ;

    RecordSet.executeSql(sql);

    sql = " update " + thetable + " set inputstatus='0' where inputid = " + inputmodid ;

    RecordSet.executeSql(sql);

    response.sendRedirect("ReportDetailStatus.jsp?inprepid="+inprepid);
}
%>

