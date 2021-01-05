<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="StatitemComInfo" class="weaver.datacenter.StatitemComInfo" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String outrepid = Util.null2String(request.getParameter("outrepid"));
rs.executeProc("T_OutReport_SelectByOutrepid",""+outrepid);
rs.next() ;
String outrepname = Util.toScreenToEdit(rs.getString("outrepname"),user.getLanguage()) ;

String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(16890,user.getLanguage()) + ": " + outrepname;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",OutReportEdit.jsp?outrepid="+outrepid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;

%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=frmMain name=frmMain action="OutReportOperation.jsp" method=post>
<input type="hidden" name=operation value="addstatitem">
<input type=hidden name=outrepid value="<%=outrepid%>">
<input type=hidden name=outrepitemid value="">
<input type=hidden name=statitemid value="">

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">


  <table class=liststyle cellspacing=1 >
  <COLGROUP>
  <col width="35%">
  <col width="10%">
  <col width="10%">
  <col width="10%">
  <col width="10%"> 
  <col width="10%"> 
  <col width="15%">
    <tbody> 
    <tr class=header>
      <td><b><%=SystemEnv.getHtmlLabelName(16892,user.getLanguage())%></b></td>
      <td align=right colspan=2>
	  	  <button class=btn accessKey=I onClick="onShowStatitem()"><U>I</U>-º”»Î</button>
      </td>
    </tr>
    <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(16893,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></TD>
  </TR>
	<tr class=line ><td colspan="3"></td></tr>
	<% 
	boolean isLight = false;
	rs.executeProc("T_OutReportStatitem_SById",""+outrepid);
    int recordercount = rs.getCounts() ;
	while(rs.next()) {
		String outrepitemid = Util.null2String(rs.getString("outrepitemid")) ;
		String statitemid = Util.null2String(rs.getString("statitemid")) ;
        int dsporder = Util.getIntValue(rs.getString("dsporder"), 1) ;

		String statitemname = Util.toScreen(StatitemComInfo.getStatitemname(statitemid),user.getLanguage()) ;
        
	    isLight = ! isLight ;
  	%>
    <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
      <td><%=statitemname%></td>
      <td><a onClick="deleteStatitem('<%=outrepitemid%>')" style="CURSOR:HAND"><img border=0 src="/images/icon_delete.gif"></a></td>
      <td>
        <table border=0 width=100%><tr>
            <td width=50%>
            <% if( dsporder != 1 ) { %>
            <a onClick="upOrder('<%=outrepitemid%>')" style="CURSOR:HAND"><img src="/images/ArrowUpGreen.gif" border=0></a>
            <% } %>
            </td>
            <td width=50%>
            <% if(recordercount != dsporder && recordercount != 1 ) { %>
            <a onClick="downOrder('<%=outrepitemid%>')" style="CURSOR:HAND"><img src="/images/ArrowDownRed.gif" border=0></a>
            <% } %>
            </td>
            </tr>
        </table>
      </td>
    </tr>
    <input type="hidden" name="outrepitemids" value="<%=outrepitemid%>">
    <%}%>
    </tbody>
  </table>

  </td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

</form>


<script language=javascript>

function deleteStatitem(outrepitemid){
    if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
        document.frmMain.operation.value = "deletestatitem";
        document.frmMain.outrepitemid.value = outrepitemid;
        document.frmMain.submit();
    }
}

function upOrder(outrepitemid){
    document.frmMain.operation.value = "uporder";
    document.frmMain.outrepitemid.value = outrepitemid;
    document.frmMain.submit();
}

function downOrder(outrepitemid){
    document.frmMain.operation.value = "downorder";
    document.frmMain.outrepitemid.value = outrepitemid;
    document.frmMain.submit();
}


</script>
 
 <script language=vbs>
 sub onShowStatitem()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/datacenter/maintenance/statitem/ReportStatItemBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
        document.frmMain.operation.value = "addstatitem"
        document.frmMain.statitemid.value = id(0)
        document.frmMain.submit()
	end if
	end if
end sub
 
</script>


<script language=javascript>
 
 function onSave(){
    document.frmMain.operation.value="savestatitem";
    document.frmMain.submit();
 }
</script>
 
</BODY></HTML>
