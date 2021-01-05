<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="LedgerCategoryComInfo" class="weaver.fna.maintenance.LedgerCategoryComInfo" scope="page" />
<jsp:useBean id="LedgerList" class="weaver.fna.maintenance.LedgerList" scope="page" />
<HTML><HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<META NAME="AUTHOR" CONTENT="InetSDK">
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);

String selectedid ="" ;
String oldselectedid = Util.null2String(request.getParameter("selectedid"));
String newselectedid = Util.null2String(request.getParameter("newselectedid"));
String addorsub = Util.null2String(request.getParameter("addorsub"));
if(!newselectedid.equals("")) {
	if(addorsub.equals("1")) selectedid = oldselectedid+newselectedid+"|" ;
	else selectedid = Util.StringReplace(oldselectedid,newselectedid+"|" , "") ;
}
LedgerList.initLedgerList(selectedid);
int categorycount = LedgerCategoryComInfo.getLedgerCategoryNum() ;
int rownum = 0;
int tmp =categorycount/2;
if((tmp * 2)== categorycount)
	rownum = tmp;
else
	rownum = tmp+1;
	
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(585,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
 <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("FnaLedgerAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(365,user.getLanguage())+",javascript:checkadd(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("FnaLedgerCategory:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",'/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem ="+36+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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

<FORM id=weaver name=frmmain method=post action="FnaLedgerAdd.jsp">
<input type="hidden" name="paraid">
<TABLE class=viewform >
  <COLGROUP>
  <COL width="50%">
  <COL width="50%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=2></TH></TR>
  <TR class=spacing>
    <TD class=Sep1 colSpan=2 ></TD></TR>
 
  <TR class=Field>
    <TD align=left valign=top>
    <table class=viewform>
 <%
 int needtd=rownum;
 int cloumnum = 1;
 while(LedgerCategoryComInfo.next()){
 	String categoryid = LedgerCategoryComInfo.getLedgerCategoryid();
 	String categoryname = LedgerCategoryComInfo.getLedgerCategoryname();
 	needtd--;
%>
<tr><td height="8"></td></tr>
<tr><td id='category_<%=categoryid%>' onClick="clicktable(this)"><Strong><%=categoryname%></strong></td></tr>
<%
	LedgerList.setLedgerList("0",categoryid);
	while(LedgerList.next()){
		String ledgerstep = LedgerList.getLedgerstep();
		String ledgerid = LedgerList.getLedgerid();
		String ledgermark = LedgerList.getLedgermark();
		String ledgername = LedgerList.getLedgername();
		String ledgerimage = LedgerList.getLedgerimage();
		String ledgercategory = LedgerList.getCategoryid();
		int tdwidth = Util.getIntValue(ledgerstep)*15 ;
%>
<tr><td>
<table width="100%" border="0" cellspacing="0" cellpadding="0"><tr>
<td width="<%=tdwidth%>"><img src="0_wev8.gif" width="<%=tdwidth%>" height="1"></td>
<td WIDTH="20px" align="left">
<% if(ledgerimage.equals("0")) {%><IMG SRC="\images\imgBullet_wev8.gif" BORDER="0" HEIGHT="12px" WIDTH="12px">
<%} else if(ledgerimage.equals("1")) {%>
<A HREF="FnaLedger.jsp?selectedid=<%=selectedid%>&newselectedid=<%=ledgerid%>&addorsub=1"><IMG SRC="\images\btnDocExpand_wev8.gif" BORDER="0" HEIGHT="12px" WIDTH="12px"></A>
<%} else if(ledgerimage.equals("2")) {%>
<A HREF="FnaLedger.jsp?selectedid=<%=selectedid%>&newselectedid=<%=ledgerid%>&addorsub=0"><IMG SRC="\images\btnDocCollapse_wev8.gif" BORDER="0" HEIGHT="12px" WIDTH="12px"></A>
<% } %>
</td>
<td  align="left" id="ledger_<%=ledgerid%>_<%=ledgercategory%>" onClick="clicktable(this)" ondblclick="dblclicktable(this)">
<%=ledgermark%>&nbsp;-&nbsp;<%=ledgername%>
</td>
</tr></table>
</td></tr>
<% }
	if(needtd==0 && cloumnum<2 ){
 		needtd=rownum; cloumnum++ ;
 %>
 </table></td><td align=left valign=top><table class=viewform>
 <%}
 }%>
</table></TD>
</TR>
</table>
</form>
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
<script>
var lastclickid ;
function clicktable(thetd){
	if(thetd.id != lastclickid) {
		document.all(lastclickid).className = "" ;
		lastclickid = thetd.id ;
		thetd.className = "Selected" ;
		frmmain.paraid.value= lastclickid ;
	}	
}

function dblclicktable(thetd){
	thetableid = thetd.id ;
	location.href='FnaLedgerEdit.jsp?paraid='+thetableid;
}

function checkadd(){
	if(frmmain.paraid.value == "") {
		alert("<%=SystemEnv.getHtmlNoteName(38,user.getLanguage())%>") ;
	}
	else frmmain.submit() ;	
}
</script>
</BODY>
</HTML>