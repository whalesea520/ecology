<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />


<%

String inprepid = Util.null2String(request.getParameter("inprepid"));
String inprepbudget = Util.null2String(request.getParameter("inprepbudget"));
String thetable = Util.null2String(request.getParameter("thetable"));
String thedate = Util.null2String(request.getParameter("thedate"));
String dspdate = Util.null2String(request.getParameter("dspdate"));
String currentdate = Util.null2String(request.getParameter("currentdate"));
String hasvalue = Util.null2String(request.getParameter("hasvalue"));
String inputid = Util.null2String(request.getParameter("inputid"));
String crmid = Util.null2String(request.getParameter("crmid"));
String type = Util.null2String(request.getParameter("type"));
String modtype = "" ;

if(type.equals("1")) {
    modtype= "2" ;
}
else {
    modtype= "3" ;
}

Hashtable ht_mod = new Hashtable() ;            // 修正中的数据

Enumeration eu = request.getParameterNames() ;
while(eu.hasMoreElements() ) {
    String keyname = (String)eu.nextElement() ;
    String keyvalue = Util.null2String(request.getParameter(keyname)) ;

    double keyvaluedouble = Util.getDoubleValue(keyvalue , 0) ;
    if(keyname.indexOf("_mod") >= 0) ht_mod.put(keyname.substring(0,keyname.length()-4) , ""+keyvaluedouble) ; // 修正中的数据
}


String sql = "" ;
String sqlin1 = "" ;
String sqlin2 = "" ;

if(hasvalue.equals("true"))  {
    sql = " update " + thetable + " set inputdate='"+currentdate+"' " ;
}
else {
    sqlin1 = " insert into " + thetable + "(crmid ,reportdate, inprepdspdate , inputdate,inputstatus ,modtype " ;
    sqlin2 = " values (" + crmid + ",'"+thedate+"','"+Util.fromScreen2(dspdate,user.getLanguage()) +"' ,'"+currentdate+"','2' ,'"+modtype+"' " ;
}

RecordSet.executeProc("T_IRItem_SelectByInprepid",inprepid);

while (RecordSet.next()) {
    String itemfieldname = Util.null2String(RecordSet.getString("itemfieldname")) ;
	String itemfieldtype = Util.null2String(RecordSet.getString("itemfieldtype")) ;
    String itemgongsi = Util.null2String(RecordSet.getString("itemgongsi")) ;

    if(!itemfieldtype.equals("2") && !itemfieldtype.equals("3")&& !itemfieldtype.equals("5") ) continue ;
    
    sql += ","+itemfieldname+"=" ;
    sqlin1 += ","+itemfieldname ;

    String itemvalue = Util.null2String(request.getParameter(itemfieldname+"_mod"));

    if(itemfieldtype.equals("2")) {
        sqlin2 += "," + Util.getIntValue(itemvalue,0) ;
        sql += Util.getIntValue(itemvalue,0) ;
    }
    else if(itemfieldtype.equals("3") ) {
        sqlin2 += "," + Util.getDoubleValue(itemvalue,0) ;
        sql += Util.getDoubleValue(itemvalue,0) ;
    }
    else if(itemfieldtype.equals("5") ) {
        String thesql = Util.fillValuesToString(itemgongsi, ht_mod) ;
        rs2.executeSql(" select " + thesql +" as result ") ;
        if(rs2.next()) itemvalue = ""+Util.getDoubleValue(rs2.getString(1),0) ;
        sqlin2 += "," + Util.getDoubleValue(itemvalue,0) ;
        sql += Util.getDoubleValue(itemvalue,0) ;
    }
}

sqlin1 += ")" ;
sqlin2 += ")" ;

if(hasvalue.equals("true"))  {
    sql += " where inputid = " + inputid ;
}
else {
    sql = sqlin1 + sqlin2 ;
}
	
RecordSet.executeSql(sql);

response.sendRedirect("ReportDetailStatus.jsp?inprepid="+inprepid);

%>

