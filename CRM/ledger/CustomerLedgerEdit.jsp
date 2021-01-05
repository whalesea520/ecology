<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="LedgerComInfo" class="weaver.fna.maintenance.LedgerComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdCRMAccount_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(136,user.getLanguage())+":"
	+SystemEnv.getHtmlLabelName(585,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


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
<%
char flag = Util.getSeparator() ;

String customerid=Util.null2String(request.getParameter("customerid"));
String customername=CustomerInfoComInfo.getCustomerInfoname(customerid);
String tradetype=Util.null2String(request.getParameter("tradetype"));

String customercode="";
RecordSet.executeProc("CRM_LedgerInfo_Select",customerid+flag+tradetype);
if(RecordSet.next()){
	customercode=RecordSet.getString("customercode");
}
boolean canedit=HrmUserVarify.checkUserRight("CustomerLedgerEdit:Edit", user);
boolean candelete=HrmUserVarify.checkUserRight("CustomerLedgerEdit:Delete", user);
%>
<form id=weaver name=frmmain method=post action="CustomerLedgerOperate.jsp" onSubmit="return check_form(this,'customercode')">
<input type=hidden name=operation>
<input type=hidden name=customerid value="<%=customerid%>">
<input type=hidden name=tradetype value="<%=tradetype%>">
<div style="display:none">
<%if(canedit){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSave type="button" accesskey="S" onclick="doSave()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<%}%>
<%if(candelete){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:weaver.Delete.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnDelete type="button" accesskey="S" id=Delete onclick="if(isdel()){doDelete();}"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
<%}%>
</div>
<table class=ViewForm>
   <colgroup>
   <col width="30%">
   <col width="70%">
   <tr class=title><th colspan=2><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%> :
   <%=Util.toScreen(customername,user.getLanguage())%></th></tr>
<TR><TD class=Line1 colSpan=2></TD></TR>
   <tr>
     <td><%=SystemEnv.getHtmlLabelName(1266,user.getLanguage())%></td>
     <td class=field>
     <%if(canedit){%>
     <input type=text class=InputStyle name=customercode size=30 maxlength=10 onChange="checkinput('customercode','codespan')"
     onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=Util.toScreenToEdit(customercode,user.getLanguage())%>">
     <span id=codespan><%if(customercode.equals("")){%><img src="/images/BacoError_wev8.gif" align="absmiddle"><%}%></span>
     <%} else {%>
     <%=Util.toScreen(customercode,user.getLanguage())%>
     <%}%>
     </td>
   </TR><tr><td class=Line colspan=2></td></tr>
   <tr>
     <td><%=SystemEnv.getHtmlLabelName(1267,user.getLanguage())%></td>
     <td class=field>
     <%if(tradetype.equals("1")){%><%=SystemEnv.getHtmlLabelName(745,user.getLanguage())%><%}%>
     <%if(tradetype.equals("2")){%><%=SystemEnv.getHtmlLabelName(746,user.getLanguage())%><%}%>
     </td>
   </TR><tr><td class=Line colspan=2></td></tr>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script language=javascript>
	function doSave(){
		if(check_form(document.frmmain,'customercode')){
			document.frmmain.operation.value="save";
			document.frmmain.submit();
		}
	}
	function doDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")){
			document.frmmain.operation.value="delete";
			document.frmmain.submit();
		}
	}
</script>
</body>
</html>