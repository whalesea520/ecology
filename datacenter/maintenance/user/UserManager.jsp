<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("DataCenter:Maintenance", user)) {
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdHRM.gif";
String titlename = Util.toScreen("基层用户管理:",user.getLanguage(),"0") ;
String needfav ="1";
String needhelp ="";
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:frmMain.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<form id=frmMain name=frmMain method=post action=UserManagerOperation.jsp>
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
   
   <COL width="25%">
    <COL width="20%"> 
    <COL width="20%">
    <COL width="20%">
    <COL width="15%">
  <TBODY>
  <TR class=header>
    <TH colSpan=5>用户信息</TH></TR>
  <TR class=Header>
    <TD>基层企业</TD>
    <TD>联系人</TD>    
    <TD>登录号</TD>
    <TD>密码</TD>
    <TD>有效性</TD>
  </TR><TR class=Line><TD colspan="5" ></TD></TR> 
<%
      String tempcustomerid = "" ;
      boolean isLight = false;
      boolean needdsp = false;
      ArrayList contacterids = new ArrayList() ;
      ArrayList loginids = new ArrayList() ;
      ArrayList passwords = new ArrayList() ;
      ArrayList statuss = new ArrayList() ;
      String sql = "select contacterid, loginid , password, status from T_DatacenterUser" ;
      rs.executeSql(sql);      		      		
      while(rs.next()){
          contacterids.add(Util.null2String(rs.getString("contacterid"))) ;
          loginids.add(Util.null2String(rs.getString("loginid"))) ;
          passwords.add(Util.null2String(rs.getString("password"))) ;
          statuss.add(Util.null2String(rs.getString("status"))) ;
      }

      sql = "select id, fullname , customerid from CRM_CustomerContacter order by customerid " ;
      rs.executeSql(sql);      		      		
      while(rs.next()){
          String id = Util.null2String(rs.getString("id")) ;
          String fullname = Util.toScreen(rs.getString("fullname"),user.getLanguage()) ;
          String customerid = Util.null2String(rs.getString("customerid")) ;
          String loginid = "" ;
          String password = "" ;
          String status = "" ;

          if( !customerid.equals(tempcustomerid) ) {
              tempcustomerid = customerid ;
              needdsp = true ;
          }
          else needdsp = false ;

          int contacteridindex = contacterids.indexOf( id ) ;
          if( contacteridindex != -1 ) {
              loginid = (String) loginids.get( contacteridindex ) ;
              password = (String) passwords.get( contacteridindex ) ;
              status = (String) statuss.get( contacteridindex ) ;
          }

          isLight = !isLight ;
%>
  <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
    <TD><%if(needdsp){%><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(customerid),user.getLanguage())%><%} else {%>&nbsp;<%}%>
    </TD>
    <td><%=fullname%></td>
    <TD><input type=text class="InputStyle" id='loginid_<%=id%>' name='loginid_<%=id%>' size='30' value="<%=loginid%>"></TD>
    <TD><input type=password class="InputStyle" id='password_<%=id%>' name='password_<%=id%>' size='30' value="<%=password%>"></TD>
    <TD><input type=checkbox id='status_<%=id%>' name='status_<%=id%>' value="1" <% if(status.equals("1"))           {%>checked<%}%>></TD>
  </TR>
<%    
    }
%>  
 </TBODY></TABLE>	</td>
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
