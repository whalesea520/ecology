<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String inprepid = Util.null2String(request.getParameter("inprepid"));
String inprepname = Util.fromScreen(request.getParameter("inprepname"),user.getLanguage());
String dspdate = Util.null2String(request.getParameter("dspdate"));
String inprepbudget = Util.null2String(request.getParameter("inprepbudget"));

String imagefilename = "/images/hdHRMCard.gif";
String titlename = Util.toScreen("输入报表确认",user.getLanguage(),"0") + inprepname;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosubmit(frmMain),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=frmMain name=frmMain action="InputReportMtiDataOperation.jsp" method=post>
<%
Hashtable ht = new Hashtable() ;

Enumeration eu = request.getParameterNames() ;
while(eu.hasMoreElements() ) {
    String keyname = (String)eu.nextElement() ;
    String keyvalue = Util.null2String(request.getParameter(keyname)) ;
    double keyvaluedouble = Util.getDoubleValue(keyvalue , 0) ;
    ht.put(keyname , ""+keyvaluedouble) ;
%>
<input type=hidden name="<%=keyname%>" value="<%=keyvalue%>">
<%}

ArrayList itemfieldnames = new ArrayList() ;
rs1.executeProc("T_IRItem_SelectByInprepid",inprepid);
while(rs1.next()) {
    String itemfieldname = Util.null2String(rs1.getString("itemfieldname")) ;
    itemfieldnames.add(itemfieldname) ;
}

%>


  <table class=liststyle cellspacing=1 >
  <COLGROUP>
  <COL width="15%">
  <COL width="85%">
    <tbody> 
    <tr class=header>
      <td><nobr><b><%=inprepname%> : <font color=red><%=dspdate%></font></b></td>
      <td align=right></td>
    </tr>
	<% 
    int totalvalue = Util.getIntValue(request.getParameter("totalvalue"),0) ;
    for( int i= 0 ; i< totalvalue ; i++ ) {
        String therecvalue = Util.null2String(request.getParameter("thevalue_"+i)) ;
        if( !therecvalue.equals("1")) continue ;

        rs.executeProc("T_IRItemtype_SelectByInprepid",""+inprepid);
        while(rs.next()) {
            String itemtypeid = Util.null2String(rs.getString("itemtypeid")) ;
            String itemtypename = Util.toScreen(rs.getString("itemtypename"),user.getLanguage()) ;
	%>
	<tr class=header> 
      <td colspan=2><%=itemtypename%></td>
    </tr>
    <tr class=line> 
      <td  colspan=2></td>
    </tr>
    <%
	int j = 0 ;

	rs1.executeProc("T_IRItem_SelectByItemtypeid",""+itemtypeid);
	while(rs1.next()) {
		String itemid = Util.null2String(rs1.getString("itemid")) ;
		String itemdspname = Util.toScreen(rs1.getString("itemdspname"),user.getLanguage()) ;
		String itemfieldname = Util.null2String(rs1.getString("itemfieldname")) ;
        String itemfieldtype = Util.null2String(rs1.getString("itemfieldtype")) ;
        String itemexcelsheet = Util.null2String(rs1.getString("itemexcelsheet")) ;
        String itemfieldunit = Util.toScreen(rs1.getString("itemfieldunit"),user.getLanguage()) ;
        int itemfieldscale = Util.getIntValue(rs1.getString("itemfieldscale"),0) ;
		
  	if(j==0){
  		j=1;
  	%>
    <tr class=datalight> 
      <%}else{
  		j=0;
  	%>
    <tr class=datadark> 
    <% }%>
      <td><% if(itemfieldtype.equals("5")) {%><b><%}%><%=itemdspname%><% if(itemfieldtype.equals("5")) {%></b><%}%></td>
	  <td><% if(!itemfieldtype.equals("5")) {%>
      <% if(!itemfieldtype.equals("2") && !itemfieldtype.equals("3") ) {%> <%=Util.null2String(request.getParameter(itemfieldname+"_"+i))%><%=itemfieldunit%>
      <%} else {%>
        <%=Util.getFloatStr(Util.null2String(request.getParameter(itemfieldname+"_"+i)),3)%><%=itemfieldunit%>
        <%}} else {
        for( int k = 0 ; k< itemfieldnames.size() ; k++ ) {
            itemexcelsheet = Util.StringReplace( itemexcelsheet , (String)itemfieldnames.get(k) , "#####&&&") ;
            itemexcelsheet = Util.StringReplace( itemexcelsheet , "#####&&&", (String)itemfieldnames.get(k)+"_" + i ) ;
        }

        String thesql = Util.fillValuesToString(itemexcelsheet, ht) ;
        rs2.executeSql(" select " + thesql +" as result ") ;
        String thevalue = "" ;
        if(rs2.next())
            thevalue = rs2.getString(1) ;
            if(!thevalue.equals("")) {
                BigDecimal thevaluedec = new BigDecimal ( thevalue );
                thevaluedec = thevaluedec.divide ( new BigDecimal ( 1.0000 ), itemfieldscale, BigDecimal.ROUND_HALF_DOWN );
                if(itemfieldscale==0) thevalue = ""+thevaluedec.intValue() ;
                else thevalue = ""+thevaluedec.doubleValue() ; 
            }
        %>
        <b><%=Util.getFloatStr(thevalue,3)%><%=itemfieldunit%></b>
        <input type=hidden name="<%=itemfieldname%>_<%=i%>" value="<%=thevalue%>">
        <%}%>
       </td>
    </tr>
	<%}}%>
    <tr class=spacing> 
      <td colspan=3 height=15></td>
    </tr>
    <%}%>
    </tbody>
  </table>
  
</form>

<script language=javascript>
function dosubmit(obj) {
    alertstr = "你要提交的是<%=dspdate%>的<%=inprepname%>"
    <% if(inprepbudget.equals("1")) {%> alertstr += "预算版本"; <%}%>
    <% if(inprepbudget.equals("2")) {%> alertstr += "预测版本"; <%}%>
    alertstr += "\n请确认你需要录入的是正确的！" ;
    
    if(confirm(alertstr)) {
        document.frmMain.submit();
        obj.disabled = true ;
    }
}
</script>

</BODY></HTML>
