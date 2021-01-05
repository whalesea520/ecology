<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% if(!HrmUserVarify.checkUserRight("FnaLedgerAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String paraid = Util.null2String(request.getParameter("paraid")) ;
String paraids[] = Util.TokenizerString2(paraid,"_") ;
String categoryid = "" ;
String supledgerid = "" ;
String supledgerstr ="" ;
if(paraids[0].equals("category")) {
categoryid = paraids[1];
supledgerid="0";
supledgerstr = "0|" ;
}
else {
categoryid = paraids[2];
supledgerid=paraids[1];
RecordSet.executeProc("FnaLedger_SelectSupLedgerall",supledgerid);
RecordSet.next();
supledgerstr = Util.null2String(RecordSet.getString(1))+supledgerid+"|" ;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(585,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(365,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<FORM id=frmain action=FnaLedgerOperation.jsp method=post onSubmit='return check_form(this,"ledgermark,ledgername")'>
<DIV><BUTTON class=btnSave accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON></div>
  <input type="hidden" name="categoryid" value="<%=categoryid%>">
  <input type="hidden" name="supledgerid" value="<%=supledgerid%>">
 <input type="hidden" name="operation" value="addledger">
  <input type="hidden" name="supledgerstr" value="<%=supledgerstr%>">
  <table class=Form>
    <colgroup> <col width="14%"> <col width="27%"> <col width="4%"> <col width="14%"> 
    <col width="27%"> <tbody> 
    <tr class=section> 
      <th colspan=7><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></th>
    </tr>
    <tr> 
      <td class=Sep1 colspan=7></td>
    </tr>
    <input type=hidden value=0 name=BCValidate>
    <tr> 
      <td>-<%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></td>
      <td class=FIELD> 
        <input accesskey=Z name=ledgermark size="15" onChange='checkinput("ledgermark","ledgermarkimage")'>
        <span id=ledgermarkimage><img 
            src="/images/BacoError_wev8.gif" align=absMiddle></span> </td>
    </tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
      <td class=FIELD><nobr>
        <input accesskey=Z name=ledgername size="30" onChange='checkinput("ledgername","ledgernameimage")'>
        <span id=ledgernameimage><img 
            src="/images/BacoError_wev8.gif" align=absMiddle></span> </td>
          <td></td>
      <td>-<%=SystemEnv.getHtmlLabelName(1467,user.getLanguage())%></td>
      <td class=FIELD> 
        <select class=inputstyle id=autosubledger 
      style="WIDTH: 150px" name=autosubledger>
          <option value=0 
        selected>-<%=SystemEnv.getHtmlLabelName(557,user.getLanguage())%></option>
          <option value=1>-<%=SystemEnv.getHtmlLabelName(1468,user.getLanguage())%></option>
		  <option value=2>-<%=SystemEnv.getHtmlLabelName(1469,user.getLanguage())%></option>
          <option value=3>-<%=SystemEnv.getHtmlLabelName(1470,user.getLanguage())%></option>
		  <option value=4>-<%=SystemEnv.getHtmlLabelName(1471,user.getLanguage())%></option>
        </select>
      </td>
    </tr>
    <tr> 
      <td>-<%=SystemEnv.getHtmlLabelName(1472,user.getLanguage())%></td>
      <td class=FIELD> 
        <select class=inputstyle id=ledgergroup 
      style="WIDTH: 150px" name=ledgergroup>
          <option value=1 
        selected>-<%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></option>
          <option value=2>-<%=SystemEnv.getHtmlLabelName(1473,user.getLanguage())%></option>
          <option 
        value=3>-<%=SystemEnv.getHtmlLabelName(1474,user.getLanguage())%></option>
          <option value=4>-<%=SystemEnv.getHtmlLabelName(425,user.getLanguage())%></option>
          <option value=5>-<%=SystemEnv.getHtmlLabelName(1475,user.getLanguage())%></option>
        </select>
        &nbsp; 
        <select 
      class=inputstyle id=ledgerbalance name=ledgerbalance>
          <option 
        value=1 selected><%=SystemEnv.getHtmlLabelName(1465,user.getLanguage())%></option>
          <option value=2><%=SystemEnv.getHtmlLabelName(1466,user.getLanguage())%></option>
        </select>
      </td>
      <td></td>
      <td><%=SystemEnv.getHtmlLabelName(1476,user.getLanguage())%></td>
      <td class=FIELD> 
        <select class=inputstyle id=ledgercurrency 
      style="WIDTH: 150px" name=ledgercurrency>
          <option 
        value=3><%=SystemEnv.getHtmlLabelName(1460,user.getLanguage())%></option>
          <option value=2 selected><%=SystemEnv.getHtmlLabelName(526,user.getLanguage())%></option>
          <option 
        value=1><%=SystemEnv.getHtmlLabelName(1477,user.getLanguage())%></option>
        </select>
      </td>
    </tr>
    
    </tbody> 
  </table>
  </FORM>
</BODY></HTML>
