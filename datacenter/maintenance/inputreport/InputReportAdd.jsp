<%@ page language="java" contentType="text/html; charset=GBK" %> 
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String errmsg = Util.null2String(request.getParameter("errmsg"));

String imagefilename = "/images/hdHRMCard.gif";
//String titlename = Util.toScreen("新 ：输入报表",user.getLanguage(),"0");
String titlename = Util.toScreen(SystemEnv.getHtmlLabelName(82,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(15184,user.getLanguage()),user.getLanguage(),"0");
String needfav ="1";
String needhelp ="";

// 查询现在已经有的表 

String inpreptablenames = "" ;

RecordSet.executeSql(" select inpreptablename from T_InputReport ");
while(RecordSet.next()) {
    String inpreptablename = Util.null2String(RecordSet.getString("inpreptablename")) ;
    inpreptablenames += ","+inpreptablename ;
}

if(!inpreptablenames.equals("")) inpreptablenames += "," ;

%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=frmMain name=frmMain action="InputReportOperation.jsp" method=post>
<input type="hidden" name="hastable" id="hastable">

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
<% if(errmsg.equals("1")) { %><font color=red><b><%=SystemEnv.getHtmlLabelName(20786,user.getLanguage())%></b></font><br><%}%>
<TABLE class=viewform>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=title>
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(20787,user.getLanguage())%></TH>
    </TR>
  <TR class=spacing style='height:1px'>
    <TD class=line1 colSpan=2 ></TD></TR>
  <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15185,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=text class="InputStyle" size=50 name="inprepname" onchange='checkinput("inprepname","inprepnameimage")'>
          <SPAN id=inprepnameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
        </TR>  <TR class=spacing style='height:1px'>
    <TD class=line colSpan=2 ></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15190,user.getLanguage())%></TD>
          <TD class=Field><INPUT type=text class="InputStyle"  size=50 maxlength="20" name="inpreptablename" onchange='checkinput("inpreptablename","inpreptablenameimage")'>
          <SPAN id=inpreptablenameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
        </TR><TR class=spacing style='height:1px'>
    <TD class=line colSpan=2 ></TD></TR>
        <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(18776,user.getLanguage())%></TD>
      <TD class=Field >
        <select class="InputStyle"  name="inprepfrequence" >
          <option value="0"><%=SystemEnv.getHtmlLabelName(763,user.getLanguage())%></option>
		  <option value="1"><%=SystemEnv.getHtmlLabelName(20616,user.getLanguage())%></option>
		  <option value="2"><%=SystemEnv.getHtmlLabelName(20617,user.getLanguage())%></option>
		  <option value="3"><%=SystemEnv.getHtmlLabelName(20618,user.getLanguage())%></option>
		  <option value="4"><%=SystemEnv.getHtmlLabelName(20619,user.getLanguage())%></option>
		  <option value="5"><%=SystemEnv.getHtmlLabelName(20620,user.getLanguage())%></option>
        </select>
      </TD>
    </TR><TR class=spacing style='height:1px'>
    <TD class=line colSpan=2 ></TD></TR>

<!--
    <TR> 
      <TD>有否预算</TD>
      <TD class=FIELD> 
        <input type="checkbox" name="inprepbudget" value="1">
      </TD>
    </TR><TR class=spacing style='height:1px'>
    <TD class=line colSpan=2 ></TD></TR>
    <TR> 
      <TD>有否预测</TD>
      <TD class=FIELD> 
        <input type="checkbox" name="inprepforecast" value="1">
      </TD>
    </TR><TR class=spacing style='height:1px'>
    <TD class=line colSpan=2 ></TD></TR>
-->
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(20612,user.getLanguage())%></TD>
      <TD class=FIELD> 
      <input type="checkbox" name="isInputMultiLine" value="1">
      </TD>
    </TR> <TR class=spacing style='height:1px'>
    <TD class=line colSpan=2 ></TD></TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(20788,user.getLanguage())%></TD>
      <TD class=FIELD> 
        <BUTTON class=Calendar type="button" onclick="getDate(startdatespan, startdate)"></BUTTON> 
              <SPAN id=startdatespan style="FONT-SIZE: x-small"></SPAN> 
              <input type="hidden" name="startdate" id="startdate">
      </TD>
    </TR><TR class=spacing style='height:1px'>
    <TD class=line colSpan=2 ></TD></TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(20789,user.getLanguage())%></TD>
      <TD class=FIELD> 
        <BUTTON class=Calendar type="button" onclick="getDate(enddatespan, enddate)"></BUTTON> 
              <SPAN id=enddatespan style="FONT-SIZE: x-small"></SPAN> 
              <input type="hidden" name="enddate" id="enddate">
      </TD>
    </TR><TR class=spacing style='height:1px'>
    <TD class=line colSpan=2 ></TD></TR>
    <TR>
      <TD><%=SystemEnv.getHtmlLabelName(20719,user.getLanguage())%></TD>
      <TD class=Field><INPUT type=text class=inputstyle size=50 name="modulefilename" ></TD>
    </TR> <TR class=spacing style='height:1px'>
    <TD class=line colSpan=2 ></TD></TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(15593,user.getLanguage())%></TD>
      <TD class=FIELD> 
       
        <input class=wuiBrowser _url="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp" _displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}'>#b{name}</a>" type=hidden name="helpdocid" size="80" value="">
      </TD>
    </TR><TR class=spacing style='height:1px'>
    <TD class=line colSpan=2 ></TD></TR>
        <input type="hidden" name=operation value=add>
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

<script language="javascript">
function submitData(obj)
{
	if (check_form(frmMain,'inprepname,inpreptablename')) {
        allinpreptablename = "<%=inpreptablenames%>" ;
        theinpreptablename = ","+document.frmMain.inpreptablename.value+"," ;
        if( allinpreptablename.indexOf(theinpreptablename) !=-1) {
            if(confirm("<%=SystemEnv.getHtmlLabelName(20794,user.getLanguage())%>") ) {
                document.frmMain.hastable.value = "1" ;
		        obj.disabled=true;
		        frmMain.submit();
            }
        }
        else {
		    obj.disabled=true;
            frmMain.submit();
        }
    }
}
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</BODY></HTML>
