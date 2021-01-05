<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/docs/common.jsp"%>
<jsp:useBean id="XmlReportManage" class="weaver.report.XmlReportManage" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(18240,user.getLanguage())+SystemEnv.getHtmlLabelName(22377,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(17744,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/country/HrmCountriesAdd.jsp,_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="frmmain" method="post" action="XmlReportUpdate.jsp">
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

<TABLE class="viewForm">
    <colgroup> 
    <col width="15%"/>
    <col width="85%"/>
	</colgroup>
	<THEAD>
    <TR class="Title"> 
      <TH colSpan="2"><%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%></TH>
    </TR>
	<TR class=Spacing> 
      <TD class=Line1 colSpan=2></TD>
    </TR>
    </THEAD> <TBODY> 
      <tr> 
      <td><%=SystemEnv.getHtmlLabelName(22376,user.getLanguage())%></td>
      <td class="Field"><BUTTON class=Calendar onclick="onShowDate('updateDatespan','updateDate');checkRightDate();"></BUTTON> 
              <SPAN id=updateDatespan><%=Util.null2String(request.getParameter("updateDate"))%><IMG id="BacoErrorImg" src='/images/BacoError_wev8.gif' align=absMiddle></span>
              <input type="hidden" name="updateDate" id="updateDate" value="<%=Util.null2String(request.getParameter("updateDate"))%>">
      </td>
    </tr>
    </TBODY> 
  </TABLE>

<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="50">
  <COL width="80%">
  <COL>
  <TBODY>
  <TR class=Header>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(19014,user.getLanguage())%></TH></TR>
   <TR class=Header>
	<TD><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(17517,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
  </TR>
  <TR class=Line><TD colspan="2" ></TD></TR> 
<%
int sn = 0;
List list = new ArrayList();
if(!Util.null2String(request.getParameter("updateDate")).equals(""))
	list = XmlReportManage.getXmlFile(request.getParameter("updateDate"));
for(int i=0; i<list.size(); i++) {
	sn++;
	String[] str = (String[]) list.get(i);
%>
  <TR class=datalight>
  <TD><%=sn%></TD>
  <TD><%=str[0]%></TD>
  <TD><%if(str[1].equals("0")){%><%=SystemEnv.getHtmlLabelName(17744,user.getLanguage())%><%}else{%><font color="red"><%=SystemEnv.getHtmlLabelName(498,user.getLanguage())%></font><%}%></TD>
  </TR>
<%
}
%>  
 </TBODY>
 </TABLE>
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
</BODY>
</HTML>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script>
var oldDate = document.getElementById('updateDatespan').innerHTML;
function doSave() {
	if(document.getElementById('updateDate').value!='') {
		document.frmmain.submit();
	}
	else {
		alert('<%=SystemEnv.getHtmlLabelName(21663,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18622,user.getLanguage())%>!');
	}
}
if(document.getElementById('updateDate').value!='') {
	document.getElementById('BacoErrorImg').style.display = 'none';
}
function checkRightDate() {
	var spanvalue = document.getElementById('updateDatespan').innerHTML;
	if(spanvalue!=oldDate && spanvalue.indexOf('<IMG')==-1) {
		document.getElementById('updateDate').value = spanvalue;
	}
}
</script>