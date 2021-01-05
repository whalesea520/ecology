<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<%
if(!HrmUserVarify.checkUserRight("DataCenter:Maintenance", user)) {
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>


<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
int inprepid = Util.getIntValue(request.getParameter("inprepid"),0);
String imagefilename = "/images/hdHRM.gif";
String titlename = Util.toScreen("报表项锁定",user.getLanguage(),"0");
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",InputReportItemCloseAdd.jsp?inprepid="+inprepid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",InputReportEdit.jsp?inprepid="+inprepid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
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
  <COL width="40%">
  <COL width="40%">
  <COL width="20%">
  <TBODY>
  <TR class=header>
    <TH colSpan=3>报表项锁定</TH></TR>
  <TR class=Header>
    <TD>基层单位</TD>
    <TD>报表字段</TD>
	<TD>操作</TD>
    
  </TR>
  <TR class=Line><TD colspan="3" style="padding: 0"></TD></TR> 
<%
      rs.executeSql("select a.*, b.itemdspname from T_InputReportItemClose a ,T_InputReportItem b where a.itemid = b.itemid and a.inprepid =" + inprepid );
      int needchange = 0;
    
      while(rs.next()){
	    String closeid = Util.null2String(rs.getString("closeid")) ;
	  	String itemdspname = Util.toScreen(rs.getString("itemdspname"),user.getLanguage()) ;
        String crmid = Util.null2String(rs.getString("crmid")) ;
        
       	if(needchange ==0){
       		needchange = 1;
%>
  <TR class=datalight>
  <%
  	}else{
  		needchange=0;
  %><TR class=datadark>
  <%  	}%>
    <TD><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmid),user.getLanguage())%></TD>
    <TD><%=itemdspname%></TD>
    <TD><a href='InputReportItemOperation.jsp?operation=deleteclose&closeid=<%=closeid%>&inprepid=<%=inprepid%>'>删除</a></TD>
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

</BODY></HTML>
