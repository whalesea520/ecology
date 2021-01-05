<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
int outrepid = Util.getIntValue(request.getParameter("outrepid"),0);
String outrepcategory = Util.null2String(request.getParameter("outrepcategory")); /*报表所属 0:固定报表 1：明细报表 2:排序报表*/
int msg = Util.getIntValue(request.getParameter("msg"),-1);
rs.executeProc("T_OutReport_SelectByOutrepid",""+outrepid);
rs.next() ;

String outrepname = Util.toScreenToEdit(rs.getString("outrepname"),user.getLanguage()) ;
int outreprow = Util.getIntValue(rs.getString("outreprow"),0) ;
int outrepcolumn = Util.getIntValue(rs.getString("outrepcolumn"),0) ;

String imagefilename = "/images/hdHRMCard.gif";
String titlename = Util.toScreen("输出报表-更改行列 : ",user.getLanguage(),"0")+outrepname;

 if(msg != -1) {
titlename = titlename + "<font color=red>"+SystemEnv.getHtmlLabelName(16622,user.getLanguage())+"</font>";

}

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
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",OutReportEdit.jsp?outrepid="+outrepid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>


<FORM id=weaver name=frmMain action="OutReportOperation.jsp" method=post>
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


  <TABLE class=viewform>
    <COLGROUP> <COL width="15%"> <COL width="10%"> <COL width="70%"><TBODY> 
    <TR class=title> 
      <TH colSpan=3><%=outrepname%></TH>
    </TR>
    <TR class=spacing> 
      <TD class=line1 colSpan=3 ></TD>
    </TR>
    <% if(outrepcategory.equals("0") || outrepcategory.equals("2")) { // 只有为固定报表或者排序报表时候显示 %>
    <TR> 
      <TD>增加行</TD>
      <TD class=Field>
        <input type="radio" name="changetype" value="1" checked>
      </TD>
      <TD class=Field>
        <input type="radio" name="rowtype" value="1">
        最前
        <input type="radio" name="rowtype" value="2" checked>
        在
        <select class=inputstyle name="addrownum" style='width:30%'>
		<% for(int i=1 ; i<=outreprow ; i++) { %>
          <option value="<%=i%>"><%=i%></option>
		<%}%>
        </select>
        行后</TD>
    </TR><TR class=spacing> 
      <TD class=line colSpan=3 ></TD>
    </TR>
    <%}%>
    <TR> 
      <TD>增加列</TD>
      <TD class=Field>
        <input type="radio" name="changetype" value="2">
      </TD>
      <TD class=Field>
        <input type="radio" name="columntype" value="1">
        最前 
        <input type="radio" name="columntype" value="2" checked>
        在
        <select class=inputstyle name="addcolumnnum"  style='width:30%'>
		<% for(int i=1 ; i<=outrepcolumn ; i++) { %>
          <option value="<%=i%>"><%=i%></option>
		<%}%>
        </select>
        列后</TD>
    </TR><TR class=spacing> 
      <TD class=line colSpan=3 ></TD>
    </TR>
    <% if(outrepcategory.equals("0") || outrepcategory.equals("2")) { // 只有为固定报表或者排序报表时候显示 %>
    <TR> 
      <TD>删除行</TD>
      <TD class=Field>
        <input type="radio" name="changetype" value="3">
      </TD>
      <TD class=Field>
        <select class=inputstyle name="delrownum"  style='width:30%'>
		<% for(int i=1 ; i<=outreprow ; i++) { %>
          <option value="<%=i%>"><%=i%></option>
		<%}%>
        </select>
        行</TD>
    </TR><TR class=spacing> 
      <TD class=line colSpan=3 ></TD>
    </TR>
    <%}%>
    <TR> 
      <TD>删除列</TD>
      <TD class=Field>
<input type="radio" name="changetype" value="4">
      </TD>
      <TD class=Field>
        <select class=inputstyle name="delcolumnnum"  style='width:30%'>
		<% for(int i=1 ; i<=outrepcolumn ; i++) { %>
          <option value="<%=i%>"><%=i%></option>
		<%}%>
        </select>
        列</TD>
    </TR><TR class=spacing> 
      <TD class=line1 colSpan=3 ></TD>
    </TR>
    <input type="hidden" name=operation value=change>
	<input type="hidden" name=outrepid value=<%=outrepid%>>
    <input type="hidden" name=outrepcategory value=<%=outrepcategory%>>
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
 
</BODY></HTML>
