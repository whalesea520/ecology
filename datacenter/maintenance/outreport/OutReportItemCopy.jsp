<%@ page import="weaver.general.Util,java.util.*" %>
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

String outrepname = Util.toScreenToEdit(rs.getString("outrepname"),user.getLanguage()) ;
int outreprow = Util.getIntValue(rs.getString("outreprow"),0) ;
int outrepcolumn = Util.getIntValue(rs.getString("outrepcolumn"),0) ;
int columncount = outrepcolumn+1 ;

ArrayList rowcols = new ArrayList() ;
ArrayList itemdescs = new ArrayList() ;

rs.executeSql("select itemid ,itemrow, itemcolumn , itemdesc from T_OutReportItem where outrepid = " + outrepid) ;
while(rs.next()) {
    String theitemdesc = Util.toScreen(rs.getString("itemdesc"),user.getLanguage()) ;
	String therow = Util.null2String(rs.getString("itemrow")) ;
	String thecol = Util.null2String(rs.getString("itemcolumn")) ;
	rowcols.add(therow+"_"+thecol) ;
    itemdescs.add(theitemdesc) ;
}


String imagefilename = "/images/hdHRMCard.gif";
String titlename = SystemEnv.getHtmlLabelName(20758,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>


<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+",javascript:frmMain.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",OutReportItem.jsp?outrepid="+outrepid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=weaver name=frmMain action="OutReportItemOperation.jsp" method=post >
<input type="hidden" name=operation value=copy>
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

  <table class=liststyle cellspacing=1 >
    <tbody> 
    <tr class=header> 
      <th colspan=<%=columncount%>><%=SystemEnv.getHtmlLabelName(20759,user.getLanguage())%>:<%=outrepname%></th>
    </tr>
  
    <tr class=Header> 
      <td>&nbsp;</td>
      <% for(int i= 1; i<=outrepcolumn ; i++) {
          String thechar = Util.getCharString(i) ;
    %>
      <td>
        <input type="radio" name="fromitem" value="col_<%=i%>"><%=i+"("+thechar+")"%>
      </td>
      <%}%>
    </tr>  <tr class=line> 
      <td colspan=<%=columncount%>></td>
    </tr>
    <% for(int j= 1; j<outreprow+1 ; j++) {  %>
    <tr class=datalight> 
      <td class=Header>
        <input type="radio" name="fromitem" value="row_<%=j%>">
              </td>
              <% for(int i= 1; i<=outrepcolumn ; i++) {  
                int rowcolindex = rowcols.indexOf(""+j+"_"+i) ;
            %>
              <td><nobr>
                <input type="radio" name="fromitem" value="rowcol_<%=j%>_<%=i%>">
                <%if(rowcolindex != -1) {%><%=itemdescs.get(rowcolindex)%><%}%></td>
              <%}%>
            </tr>
            <%
            }
        %>
    </tbody>
  </table>
  <br>
  <table class=liststyle cellspacing=1 >
    <tbody> 
    <tr class=header> 
      <th colspan=<%=columncount%>><%=SystemEnv.getHtmlLabelName(20760,user.getLanguage())%>:<%=outrepname%> £¨<%=SystemEnv.getHtmlLabelName(20761,user.getLanguage())%>£©</th>
    </tr>
 
    <tr class=Header> 
      <td>&nbsp;</td>
      <% for(int i= 1; i<=outrepcolumn ; i++) {
          String thechar = Util.getCharString(i) ;
    %>
      <td> 
        <input type="checkbox" name="toitem" value="col_<%=i%>"><%=i+"("+thechar+")"%>
      </td>
      <%}%>
    </tr>   <tr class=line> 
      <td  colspan=<%=columncount%>></td>
    </tr>
    <% for(int j= 1; j<outreprow+1 ; j++) {  %>
    <tr class=datalight> 
      <td class=Header> 
        <input type="checkbox" name="toitem" value="row_<%=j%>">
      </td>
      <% for(int i= 1; i<=outrepcolumn ; i++) {  
                int rowcolindex = rowcols.indexOf(""+j+"_"+i) ;
            %>
      <td><nobr> 
        <input type="checkbox" name="toitem" value="rowcol_<%=j%>_<%=i%>">
        <%if(rowcolindex != -1) {%>
        <%=itemdescs.get(rowcolindex)%>
        <%}%>
      </td>
      <%}%>
    </tr>
    <%
            }
        %>
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
 
</BODY></HTML>
