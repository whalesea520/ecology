<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
int crmid = Util.getIntValue(request.getParameter("crmid"),0);
int inprepcrmid = Util.getIntValue(request.getParameter("inprepcrmid"),0);
int inprepid = Util.getIntValue(request.getParameter("inprepid"),0);

// 可以进行输入的
ArrayList contacterids = new ArrayList() ;
rs.executeSql(" select contacterid from T_InputReportCrmContacter where inprepcrmid="+inprepcrmid);
while(rs.next()) {
    String contacterid = Util.null2String(rs.getString("contacterid")) ;
    contacterids.add( contacterid ) ;
}

// 可以进行修正的
ArrayList contactmoderids = new ArrayList() ;
rs.executeSql(" select contacterid from T_InputReportCrmModer where inprepcrmid="+inprepcrmid);
while(rs.next()) {
    String contacterid = Util.null2String(rs.getString("contacterid")) ;
    contactmoderids.add( contacterid ) ;
}

// 可以选择crm 的, 可选择的crm
ArrayList contactselcrmids = new ArrayList() ;
ArrayList contactselcrms = new ArrayList() ;
rs.executeSql(" select contacterid, selcrm from T_InputReportCrmSel where inprepcrmid="+inprepcrmid);
while(rs.next()) {
    String contacterid = Util.null2String(rs.getString("contacterid")) ;
    String selcrm = Util.null2String(rs.getString("selcrm")) ;
    contactselcrmids.add( contacterid ) ;
    contactselcrms.add( selcrm ) ;
}



String imagefilename = "/images/hdHRMCard.gif";
String titlename = Util.toScreen("输入报表权限",user.getLanguage(),"0") ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",InputReportEdit.jsp?inprepid="+inprepid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=weaver name=frmMain action="InputReportOperation.jsp" method=post>
<input type="hidden" name=operation>
<input type="hidden" name=crmid value="<%=crmid%>">
<input type="hidden" name=inprepcrmid value="<%=inprepcrmid%>">
<input type="hidden" name=inprepid value="<%=inprepid%>">

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

<TABLE class=liststyle cellspacing=1 >
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=header>
    <TH colSpan=2>联系人权限</TH></TR>
  <TR class=Header>
    <TD>联系人</TD>
    <TD>权限</TD>
  </TR>
  <TR class=line>
    <TD colSpan=2 ></TD></TR>
<%
    boolean isLight = false ;
    rs.executeSql("select id, fullname from CRM_CustomerContacter where customerid = " + crmid); 
    while(rs.next()){
        String id = Util.null2String(rs.getString("id")) ;
        String fullname = Util.toScreen(rs.getString("fullname"),user.getLanguage()) ;
        isLight = !isLight ; 
%>
  <TR class='<%=( isLight ? "datalight" : "datadark" )%>'> 
      <TD><%=fullname%></TD>
      <TD>
      <input type="checkbox" name=contacterid <%if(contacterids.indexOf(id) != -1) {%> checked <%}%> value="<%=id%>">可录入&nbsp;
      <input type="checkbox" name=contactmoderid <%if(contactmoderids.indexOf(id) != -1) {%> checked <%}%> value="<%=id%>">可进行年月修正
      <%  int theselcrmindex = contactselcrmids.indexOf(id) ;
          String selcrmid = "" ;
          String selcrmname = "" ;
          if(theselcrmindex != -1) {
              selcrmid = (String)contactselcrms.get(theselcrmindex) ;
              String[] selcrmnames = Util.TokenizerString2(selcrmid,",") ;
              for(int i=0 ; i<selcrmnames.length; i++) {
                if(selcrmname.equals("")) selcrmname = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(selcrmnames[i]),user.getLanguage()) ;
                else selcrmname += "," +  Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(selcrmnames[i]),user.getLanguage()) ;
              }
          }
      %>
      <input type="checkbox" name=contactselcrm <%if(theselcrmindex != -1) {%> checked <%}%> value="<%=id%>">可选择客户 &nbsp;&nbsp;
      <BUTTON class=Browser id=SelecCrmid onClick="onShowCustomer(crmidspan_<%=id%>,crmid_<%=id%>)"></BUTTON> 
        <span id="crmidspan_<%=id%>"><%=selcrmname%></span> 
        <INPUT id="crmid_<%=id%>" type=hidden name="crmid_<%=id%>" value="<%=selcrmid%>">
      </TD>
  </TR>
<%
    }
%>  
 </TBODY></TABLE>
 
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
<script language=vbs>
sub onShowCustomer(tdname,inputename)
    thevalue = inputename.value 
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="&thevalue)
	if NOT isempty(id) then
        if id(0)<> "" then
		tdname.innerHtml = right(id(1),len(id(1))-1)
		inputename.value = right(id(0),len(id(0))-1)
		else
		tdname.innerHtml = ""
		inputename.value =""
		end if
	end if
end sub

</script>

<script language=javascript>
 function onSave(){
    document.frmMain.operation.value="editcontactright";
    document.frmMain.submit();
 }
</script>
</BODY></HTML>