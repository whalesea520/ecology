
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpsu" class="weaver.homepage.style.HomepageStyleUtil" scope="page"/>
<jsp:useBean id="hpsc" class="weaver.homepage.cominfo.HomepageStyleCominfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<BODY>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19440,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(19422,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
   	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:frmSele.submit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.history.go(-1),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<TABLE width=100% height=100% border="0" cellspacing="0">
<colgroup>
<col width="">
<col width="5">
	  <tr>
		<td height="10" colspan="2"></td>
	  </tr>
	  <tr>		
		<td valign="top">  		
		 <form name="frmSele" method="post" action="HomepageStyleOperate.jsp" enctype="multipart/form-data">
		 <input type="hidden" name="method" value="ref">
		  <TABLE class=Shadow width=100%>
			<tr>
			  <td valign="top">                        
				<TABLE class="ViewForm">
				<colgroup>
				<col width="20%">		
				<col width="80%">	
				<TR>
					<TD><%=SystemEnv.getHtmlLabelName(19425,user.getLanguage())%></TD>
					<TD class=field>
						<SELECT NAME="seleSrcStyle" id="seleSrcStyle">
							<%
							hpsc.setTofirstRow();	
							while(hpsc.next()){
							%>
							 <option value="<%=hpsc.getId()%>"><%=hpsc.getStylename()%></option>
							<%}%>
						</SELECT>
					</TD>
				</TR>
				<tr><td colspan=2 class=line></td></tr>
				</table>	
			  </td>
			</tr>
		  </TABLE>   
		  </form>
		</td>
		<td></td>
	  </tr>
	  <tr>
		<td height="10" colspan="2"></td>
	  </tr>
	</table>
  </BODY>
</HTML>

