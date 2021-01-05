
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetI" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />

<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));

RecordSetI.executeProc("CRM_Find_Item",CustomerID);

RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
if(RecordSet.getCounts()<=0)
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
RecordSet.first();
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>

<BODY>
<DIV class=HdrTitle>
<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
  <TBODY>
  <TR>
    <TD align=left width=55><IMG height=24 src="/images/hdLOG_wev8.gif"></TD>
    <TD align=left><SPAN id=BacoTitle style="FONT-WEIGHT: bold; FONT-SIZE: medium"><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%> - <%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%>:<a href="/CRM/data/ViewCustomer.jsp?log=n&CustomerID=<%=RecordSet.getString("id")%>"><%=Util.toScreen(RecordSet.getString("name"),user.getLanguage())%></a></SPAN></TD>
    <TD align=left>&nbsp;</TD>
    <TD width=5></TD>
  </TR>
  </TBODY>
</TABLE>
</DIV>
<DIV class=HdrProps></DIV>
<FORM id=weaverA action="ProjCustomerOperation.jsp" method=post>
<input type="hidden" name="method" value="add">
<input type="hidden" name="CustomerID" value="<%=CustomerID%>">

<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="20%">
  <COL width=80%>
  <TBODY>
  <TR class=Spacing>
          <TD class=Line1 colSpan=2></TD></TR>
           <TR>
          <TD colSpan=2><BUTTON class=btnNew accessKey=A type=submit><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON></TD>
        </TR>
           <TR>
          <TD><%=SystemEnv.getHtmlLabelName(145,user.getLanguage())%></TD>
	  <td><button class=Browser onClick='onShowAsset()'></button>
		<span class=InputStyle id=itemspan></span>
		<input type='hidden' name='ItemID' id='ItemID'>
	  </td>
        </TR>
  </TBODY>
</TABLE>
</FORM>

<FORM id=weaverD action="ProjCustomerOperation.jsp" method=post>
<input type="hidden" name="method" value="delete">
<input type="hidden" name="CustomerID" value="<%=CustomerID%>">

<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="20%">
  <COL width=80%>
  <TBODY>
  <TR class=Spacing>
          <TD class=Line1 colSpan=2></TD></TR>
           <TR>
          <TD colSpan=2><BUTTON class=btnDelete accessKey=D type=submit onclick="return isdel()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON></TD>
        </TR>
  </TBODY>
</TABLE>

	  <TABLE class=ListStyle>
          <TBODY>
	  </TBODY>
	  </TABLE>
</FORM>

<script language=vbs>

sub onShowAsset()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/asset/LgcAssetBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> "" then
		itemspan.innerHtml = id(1)
		ItemID.value=id(0)
		else
		itemspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		ItemID.value=""
		end if
	end if
end sub

</script>

</body>
</html>


