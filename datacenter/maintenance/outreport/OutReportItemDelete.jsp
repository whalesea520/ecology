<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
int outrepid = Util.getIntValue(request.getParameter("outrepid"),0);

rs.executeProc("T_OutReport_SelectByOutrepid",""+outrepid);
rs.next() ;

int outreprow = Util.getIntValue(rs.getString("outreprow"),0) ;
int outrepcolumn = Util.getIntValue(rs.getString("outrepcolumn"),0) ;
String outrepcategory = Util.null2String(rs.getString("outrepcategory")) ;  /*报表所属 0:固定报表 1：明细报表 2:排序报表 , 只有固定报表和排序报表有报表项定义*/



String imagefilename = "/images/hdHRMCard.gif";
String titlename = Util.toScreen("报表项定义删除",user.getLanguage(),"0");
String needfav ="1";
String needhelp ="";
%>
<BODY>
<DIV class=HdrProps></DIV>

<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",OutReportItem.jsp?outrepid="+outrepid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=weaver name=frmMain action="OutReportItemOperation.jsp" method=post >
<input type="hidden" name=operation value=deletebatch>
<input type="hidden" name=outrepid value=<%=outrepid%>>
<input type="hidden" name=outreprow value=<%=outreprow%>>
<input type="hidden" name=outrepcolumn value=<%=outrepcolumn%>>
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

  <table class=viewform>
    <colgroup> <col width="20%"> <col width="80%"> <tbody> 
    <tr class=title> 
      <th colspan=2>删除报表项定义</th>
    </tr>
    <tr class=spacing> 
      <td class=line1 colspan=2 ></td>
    </tr>
    <% if(outrepcategory.equals("0")) { // 只有为固定报表时候显示 %>
    <tr> 
      <td> 
        <input type="radio" name="deletetype" value="1" checked>
        删除行定义</td>
      <td class=Field> 
        <select class="InputStyle" name="itemrow" style='width:30%'>
          <% for(int i=1 ; i<=outreprow ; i++) { 
            %>
          <option value="<%=i%>"><%=i%></option>
          <%}%>
        </select>
        行</td>
    </tr>    <tr class=spacing> 
      <td class=line colspan=2 ></td>
    </tr>
    <% } %>
    <tr> 
      <td> 
        <input type="radio" name="deletetype" value="2">
        删除列定义</td>
      <td class=Field> 
        <select class="InputStyle" name="itemcolumn"  style='width:30%'>
          <% for(int i=1 ; i<=outrepcolumn ; i++) { 
            String ch = Util.getCharString(i) ;
            %>
          <option value="<%=i%>"><%=ch%></option>
          <%}%>
        </select>
        列 </td>
    </tr>  <tr class=spacing> 
      <td class=line1 colspan=2 ></td>
    </tr>
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

function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.submit();
		}
}

</script>


</BODY></HTML>
