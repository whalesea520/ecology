<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<BODY onload="frmMain.submit()">
<FORM id=frmMain name=frmMain action="InputReportDataOperation.jsp" method=post>
<%
String inprepid = Util.null2String(request.getParameter("inprepid"));
String inprepname = Util.fromScreen(request.getParameter("inprepname"),user.getLanguage());
String inprepbudget = Util.null2String(request.getParameter("inprepbudget"));

Hashtable ht = new Hashtable() ;                // 非修正中的数据
Hashtable ht_mod = new Hashtable() ;            // 修正中的数据
Enumeration eu = request.getParameterNames() ;
while(eu.hasMoreElements() ) {
    String keyname = (String)eu.nextElement() ;
    String keyvalue = Util.null2String(request.getParameter(keyname)) ;
    double keyvaluedouble = Util.getDoubleValue(keyvalue , 0) ;
    if(keyname.indexOf("_mod") < 0) ht.put(keyname , ""+keyvaluedouble) ; // 非修正中的数据
    else ht_mod.put(keyname.substring(0,keyname.length()-4) , ""+keyvaluedouble) ; // 修正中的数据
%>
<input type=hidden name="<%=keyname%>" value="<%=keyvalue%>">
<%
}

rs1.executeProc("T_IRItem_SelectByInprepid",""+inprepid);
while(rs1.next()) {
    String itemfieldname = Util.null2String(rs1.getString("itemfieldname")) ;
    String itemfieldtype = Util.null2String(rs1.getString("itemfieldtype")) ;
    String itemgongsi = Util.null2String(rs1.getString("itemgongsi")) ;
    int itemfieldscale = Util.getIntValue(rs1.getString("itemfieldscale"),0) ;
    String inputablefact = Util.null2String(rs1.getString("inputablefact")) ; // 实际是否可输入
    String inputablebudg = Util.null2String(rs1.getString("inputablebudg")) ; // 预算是否可输入
    String inputablefore = Util.null2String(rs1.getString("inputablefore")) ; // 预测是否可输入
    String inputable = inputablefact ;
    if(inprepbudget.equals("1")) inputable = inputablebudg ;
    else if(inprepbudget.equals("2")) inputable = inputablefore ;
    
    if(!inputable.equals("1")&& itemfieldtype.equals("5")) {
        String thesql = Util.fillValuesToString(itemgongsi, ht) ;       // 非修正的计算
        rs2.executeSql(" select " + thesql +" as result ") ;
        String thevalue = "" ;
        if(rs2.next()) thevalue = rs2.getString(1) ;
        if(!thevalue.equals("")) {
            BigDecimal thevaluedec = new BigDecimal ( thevalue );
            thevaluedec = thevaluedec.divide ( new BigDecimal ( 1.0000 ), itemfieldscale, BigDecimal.ROUND_HALF_DOWN );
            if(itemfieldscale==0) thevalue = ""+thevaluedec.intValue() ;
            else thevalue = ""+thevaluedec.doubleValue() ; 
        }
%>
<input type=hidden name="<%=itemfieldname%>" value="<%=thevalue%>">
<%
        thesql = Util.fillValuesToString(itemgongsi, ht_mod) ;             // 修正的计算
        rs2.executeSql(" select " + thesql +" as result ") ;
        thevalue = "" ;
        if(rs2.next()) thevalue = rs2.getString(1) ;
        if(!thevalue.equals("")) {
            BigDecimal thevaluedec = new BigDecimal ( thevalue );
            thevaluedec = thevaluedec.divide ( new BigDecimal ( 1.0000 ), itemfieldscale, BigDecimal.ROUND_HALF_DOWN );
            if(itemfieldscale==0) thevalue = ""+thevaluedec.intValue() ;
            else thevalue = ""+thevaluedec.doubleValue() ; 
        }
%>
<input type=hidden name="<%=itemfieldname%>_mod" value="<%=thevalue%>">
<%
    }
}
%>
</form>

</BODY>
</HTML>
