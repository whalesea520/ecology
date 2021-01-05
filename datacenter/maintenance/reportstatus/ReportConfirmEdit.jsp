<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs4" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs5" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />




<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
int inputid = Util.getIntValue(request.getParameter("inputid"),0);
int inputmodid = Util.getIntValue(request.getParameter("inputmodid"),0);
int inprepid = Util.getIntValue(request.getParameter("inprepid"),0);
int confirmid = Util.getIntValue(request.getParameter("confirmid"),0);
String inprepname = Util.fromScreen(request.getParameter("inprepname"),user.getLanguage());
String thetable = Util.null2String(request.getParameter("thetable"));
String dspdate = Util.null2String(request.getParameter("dspdate"));
String inprepbudget = Util.null2String(request.getParameter("inprepbudget"));


String sql =  "select * from "+ thetable + 
				  " where inputid ="+inputid ;
	
rs2.executeSql(sql) ;
rs2.next() ;

String crmid = Util.null2String(rs2.getString("crmid")) ;

sql = "select * from "+ thetable + 
                  " where inputid ="+inputmodid ;
rs4.executeSql(sql) ;
rs4.next() ;

ArrayList closeitemids = new ArrayList() ;
ArrayList closeitemvalue = new ArrayList() ;

rs.executeSql("select max(reportdate) from "+ thetable + 
				  " where crmid ="+crmid +" and modtype='0'") ;

if(rs.next()) {
    String maxreportdate = rs.getString(1) ;

    sql =  "select * from "+ thetable + 
				  " where reportdate ='" +maxreportdate+"' and crmid ="+crmid +" and modtype='0'";

    rs5.executeSql(sql) ;
    rs5.next() ;

    rs.executeSql("select a.itemid , b.itemfieldname from T_InputReportItemClose a , T_InputReportItem b where a.itemid=b.itemid and  a.inprepid ="+inprepid+" and a.crmid="+crmid) ;
    while(rs.next()) {
        closeitemids.add(Util.null2String(rs.getString("itemid"))) ;
        String itemfieldname = Util.null2String(rs.getString("itemfieldname")) ;
        String lastvalue= Util.toScreen(rs5.getString(itemfieldname),user.getLanguage()) ;
        closeitemvalue.add(lastvalue) ;
    }
}


String imagefilename = "/images/hdHRMCard.gif";
String titlename = Util.toScreen("输入报表",user.getLanguage(),"0") + inprepname;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:frmMain.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>


<FORM id=frmMain name=frmMain action="ReportConfirmOperation.jsp" method=post >
<input type="hidden" name="inprepid" value="<%=inprepid%>">
<input type="hidden" name="confirmid" value="<%=confirmid%>">
<input type="hidden" name="thetable" value="<%=thetable%>">
<input type="hidden" name="inputid" value="<%=inputid%>">
<input type="hidden" name="inputmodid" value="<%=inputmodid%>">
<input type="hidden" name="operation" value="edit">
<input type="hidden" name="inprepbudget" value="<%=inprepbudget%>">




  <table class=liststyle cellspacing=1 >
  <COLGROUP>
  <COL width="15%">
  <COL width="40%">
  <COL width="40%">
    <tbody> 
    <tr class=header>
      <td colspan=2><nobr><b><%=inprepname%> : <font color=blue><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmid),user.getLanguage())%> &nbsp; <%=dspdate%></font></b></td>
      <td align=right></td>
    </tr>
	<% 
	rs.executeProc("T_IRItemtype_SelectByInprepid",""+inprepid);
	while(rs.next()) {
		String itemtypeid = Util.null2String(rs.getString("itemtypeid")) ;
		String itemtypename = Util.toScreen(rs.getString("itemtypename"),user.getLanguage()) ;
	%>
	<tr class=header> 
      <td colspan=3><%=itemtypename%></td>
    </tr>
    <tr class=line> 
      <td colspan=3></td>
    </tr>
    <%
	int i = 0 ;
	rs1.executeProc("T_IRItem_SelectByItemtypeid",""+itemtypeid);
	while(rs1.next()) {
		String itemid = Util.null2String(rs1.getString("itemid")) ;
		String itemdspname = Util.toScreen(rs1.getString("itemdspname"),user.getLanguage()) ;
		String itemfieldname = Util.null2String(rs1.getString("itemfieldname")) ;
		String itemfieldtype = Util.null2String(rs1.getString("itemfieldtype")) ;
		String itemfieldscale = Util.null2String(rs1.getString("itemfieldscale")) ;
		String itemexcelsheet = Util.toScreen(rs1.getString("itemexcelsheet"),user.getLanguage()) ;
		String itemexcelrow = Util.null2String(rs1.getString("itemexcelrow")) ;
		String itemexcelcolumn = Util.null2String(rs1.getString("itemexcelcolumn")) ;
        String itemfieldunit = Util.toScreen(rs1.getString("itemfieldunit"),user.getLanguage()) ;
        String inputablefact = Util.null2String(rs1.getString("inputablefact")) ; // 实际是否可输入
        String inputablebudg = Util.null2String(rs1.getString("inputablebudg")) ; // 预算是否可输入
        String inputablefore = Util.null2String(rs1.getString("inputablefore")) ; // 预测是否可输入
        String inputable = inputablefact ;
        if(inprepbudget.equals("1")) inputable = inputablebudg ;
        else if(inprepbudget.equals("2")) inputable = inputablefore ;
        
        if(!inputable.equals("1")) continue ;

        if(i==0){
            i=1;
        %>
        <tr class=datalight> 
          <%}else{
            i=0;
        %>
        <tr class=datadark> 
        <% }%>
        <td><%=itemdspname%></td>
        <% 
        int closedindex = closeitemids.indexOf(itemid) ;
        if(closedindex >=0 ) { %>
        <td>
        <%=closeitemvalue.get(closedindex)%>
        <input type=hidden name=<%=itemfieldname%> value='<%=closeitemvalue.get(closedindex)%>'>
        </td><td>&nbsp;</td>
	    <%} else if(itemfieldtype.equals("1")) { %>
		<td><input type=text class=inputstyle size=30 maxlength=<%=itemfieldscale%> name=<%=itemfieldname%>  value="<%=Util.toScreenToEdit(rs2.getString(itemfieldname),user.getLanguage())%>" ><%=itemfieldunit%></td><td>&nbsp;</td>
		<%} else if(itemfieldtype.equals("2")) { 
            String modfieldname = itemfieldname + "_mod" ;
        %>
		<td><input type=text class=inputstyle size=30 name=<%=itemfieldname%> <% /*if( Util.getIntValue( rs2.getString(itemfieldname) , 0) != 0 ) { */
        if( true) {%> value="<%=Util.toScreenToEdit(rs2.getString(itemfieldname),user.getLanguage())%>" <%}%> onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)'><%=itemfieldunit%></td>
        
        <td><input type=text class=inputstyle size=30 name=<%=modfieldname%> <% if( Util.getIntValue(rs4.getString(itemfieldname),0) != 0 ) {%> value="<%=Util.toScreenToEdit(rs4.getString(itemfieldname),user.getLanguage())%>" <%}%>  onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)'>(前次修正)</td>

		<%} else if(itemfieldtype.equals("3") || itemfieldtype.equals("5") ) { 
            String modfieldname = itemfieldname + "_mod" ;
        %>
		<td><input type=text class=inputstyle size=30 name=<%=itemfieldname%> <% /*if( Util.getDoubleValue(rs2.getString(itemfieldname),0) != 0 ) */ 
        if( true) {%> value="<%=Util.toScreenToEdit(rs2.getString(itemfieldname),user.getLanguage())%>" <%}%> onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'><%=itemfieldunit%></td>
        
        <td><input type=text class=inputstyle size=30 name=<%=modfieldname%> <% if( Util.getDoubleValue(rs4.getString(itemfieldname),0) != 0 ) {%> value="<%=Util.toScreenToEdit(rs4.getString(itemfieldname),user.getLanguage())%>" <%}%> onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)'>(前次修正)</td>

		<%} else if(itemfieldtype.equals("4")) { %>
		<td><select class="InputStyle" name="<%=itemfieldname%>"><%=itemfieldunit%>
		<%	rs3.executeProc("T_IRItemDetail_SelectByItemid",""+itemid);
			while(rs3.next()) {
			String itemdsp = Util.toScreenToEdit(rs3.getString("itemdsp"),user.getLanguage());
			String itemvalue = Util.toScreenToEdit(rs3.getString("itemvalue"),user.getLanguage());
			String selected = "" ;
			if((Util.toScreen(rs2.getString(itemfieldname),user.getLanguage())).equals( itemvalue)) selected = "selected" ;
		%>
          <option value="<%=itemvalue%>" <%=selected%>><%=itemdsp%></option>
		<%}%>
        </select></td><td>&nbsp;</td>
		<%} else if(itemfieldtype.equals("6")) { %>
        <td><textarea class="InputStyle"  name="<%=itemfieldname%>" rows="5" cols=60> <%=Util.toScreenToEdit(rs2.getString(itemfieldname),user.getLanguage())%> </textarea><%=itemfieldunit%></td><td>&nbsp;</td>
		<%}%>
    </tr>
	<%}}%>
    </tbody>
  </table>
  
</form>
</BODY></HTML>
