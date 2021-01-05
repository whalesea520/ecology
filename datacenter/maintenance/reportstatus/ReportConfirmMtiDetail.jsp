<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs4" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />



<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String confirmid = Util.null2String(request.getParameter("confirmid"));
String inputid = Util.null2String(request.getParameter("inputid"));
String inprepid = Util.null2String(request.getParameter("inprepid"));
String thetable = Util.null2String(request.getParameter("thetable"));
String crmid = Util.null2String(request.getParameter("crmid")) ;
String thedate = Util.null2String(request.getParameter("thedate"));
String inprepbudget = Util.null2String(request.getParameter("inprepbudget"));
int bywhat = Util.getIntValue(request.getParameter("bywhat"),1);
String currentdate =  Util.null2String(request.getParameter("currentdate"));
int formstatus=Util.getIntValue(request.getParameter("formstatus"),0);
String inprepname = "" ;
String inputmodid = "";
String reportdate = thedate ;
String dspdate= Util.null2String(request.getParameter("dspdate"));

boolean ischeck = false ;

if(!confirmid.equals("")) {
    rs.executeProc("T_IRConfirm_SelectByConfirmid",""+confirmid);
    rs.next() ;

    inputid = Util.null2String(rs.getString("inputid")) ;
    inprepid = Util.null2String(rs.getString("inprepid")) ;
    inprepname = Util.toScreen(rs.getString("inprepname"),user.getLanguage()) ;
    dspdate = Util.toScreen(rs.getString("inprepdspdate"),user.getLanguage()) ;
    thetable = Util.null2String(rs.getString("thetable")) ; 
    crmid = Util.null2String(rs.getString("crmid")) ;
    inprepbudget = Util.null2String(rs.getString("inprepbudget")) ; 

    reportdate = dspdate ;
}
else if(!thedate.equals("")) {
    ischeck = true ;
    rs.executeProc("T_InputReport_SelectByInprepid",""+inprepid);
    rs.next() ;

    inprepname = Util.toScreenToEdit(rs.getString("inprepname"),user.getLanguage()) ; 
}

String sql = "select * from "+ thetable + " where reportdate = '"+thedate+"' and crmid = " + crmid ;
rs2.executeSql(sql) ;

boolean hasclosed= false ;

String thereportperiod = reportdate.substring(0,4) + reportdate.substring(5,7) ;
rs.executeSql("select fnayearperiodsid from FnaYearsPeriodsList where isclose='1' and fnayearperiodsid = '"+thereportperiod+"' ");
if(rs.next()) {
    hasclosed = true ;
}

String imagefilename = "/images/hdHRMCard.gif";
String titlename = Util.toScreen("确认输入报表",user.getLanguage(),"0") + inprepname;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doback(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=weaver name=frmMain action="ReportConfirmMtiOperation.jsp" method=post>
<input type="hidden" name="confirmid" value="<%=confirmid%>">
<input type="hidden" name="inputid" value="<%=inputid%>">
<input type="hidden" name="inprepid" value="<%=inprepid%>">
<input type="hidden" name="inprepname" value="<%=inprepname%>">
<input type="hidden" name="thetable" value="<%=thetable%>">
<input type="hidden" name="thedate" value="<%=thedate%>">
<input type="hidden" name="dspdate" value="<%=dspdate%>">
<input type="hidden" name="crmid" value="<%=crmid%>">
<input type="hidden" name="inprepbudget" value="<%=inprepbudget%>">
<% if(ischeck) {%>
<input type="hidden" name="operation" value="check">
<%} else { %>
<input type="hidden" name="operation" value="confirm">
<%}%>

  <table class=liststyle cellspacing=1 >
  <COLGROUP>
  <COL width="15%">
  <COL width="85%">
    <tbody> 
    <tr class=header>
      <td><nobr><b><%=inprepname%> : <font color=blue><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmid),user.getLanguage())%> &nbsp; <%=dspdate%></font></b></td>
      <td align=right>
            <a href="#" onClick="doReject();">退回</a>
       </td>
    </tr>
	<% 
    rs2.beforFirst() ;
    while( rs2.next() ) {
        rs.executeProc("T_IRItemtype_SelectByInprepid",""+inprepid);
        while(rs.next()) {
            String itemtypeid = Util.null2String(rs.getString("itemtypeid")) ;
            String itemtypename = Util.toScreen(rs.getString("itemtypename"),user.getLanguage()) ;
	%>
	<tr class=header> 
      <td colspan=2><%=itemtypename%></td>
    </tr>
    <tr class=line>
      <td colspan=2></td>
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
            
            if(!inputable.equals("1")&&!itemfieldtype.equals("5")) continue ;
            
            if(i==0){
                i=1;
  	%>
    <tr class=datalight> 
      <%    }else{
  		        i=0;
  	%>
    <tr class=datadark> 
    <%      }%>
      <td>
        <% if(itemfieldtype.equals("5")&& !inputable.equals("1")) {%><b><%}%>
        <%=itemdspname%>
        <% if(itemfieldtype.equals("5")&& !inputable.equals("1")) {%></b><%}%>
      </td>
	  <td>
        <% if((itemfieldtype.equals("2") || itemfieldtype.equals("3") || (itemfieldtype.equals("5")&&inputable.equals("1")) ) && Util.getDoubleValue(rs2.getString(itemfieldname),0) != 0 ) {%> <%=Util.getFloatStr(Util.toScreen(rs2.getString(itemfieldname),user.getLanguage()),3)%><%=itemfieldunit%>
       <%} else {%> 
        <% if(itemfieldtype.equals("5")&& !inputable.equals("1")) {%><b> <%=Util.getFloatStr(Util.toScreen(rs2.getString(itemfieldname),user.getLanguage()),3)%><%=itemfieldunit%></b><%} else {%> <%=Util.toScreen(rs2.getString(itemfieldname),user.getLanguage())%><%=itemfieldunit%><%}%> 
       <%}%>
      </td>
    </tr>
	<%}}}%>
    </tbody>
  </table>
  
</form>

<script language=javascript>
 function doEdit(){
    document.frmMain.action="ReportConfirmMtiEdit.jsp";
    document.frmMain.submit();
 }
 function doReject(){
    if( confirm("确定退回原单位修改？") ) {
        document.frmMain.operation.value="reject" ;
        document.frmMain.submit();
    }
 }
function doback(){
    <%if(formstatus==1){%>
    window.location="ReportDetailStatus.jsp?inprepid=<%=inprepid%>";
    <%}else{%>
    window.location="ReportMtiDetailCrm.jsp?thetable=<%=thetable%>&crmid=<%=crmid%>&inprepid=<%=inprepid%>&inprepbudget=<%=inprepbudget%>&bywhat=<%=bywhat%>&currentdate=<%=currentdate%>";
    <%}%>
}
 

 </script> 
</BODY></HTML>
