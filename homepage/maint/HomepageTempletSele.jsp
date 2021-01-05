
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hpc" class="weaver.homepage.cominfo.HomepageCominfo" scope="page"/>
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page"/>
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
  </head>
  
<body>
<%
int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19100,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(19422,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onOk(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;

	
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
	<colgroup>
	<col width="">
	<col width="10">
	<tr>
		<td height="10" colspan="2"></td>
	</tr>
	<tr>	
		<td valign="top">		
		<TABLE width=100% height=100% border="0" cellspacing="0">
		<colgroup>
		<col width="">
		<col width="5">
			  <tr>
				<td height="10" colspan="2"></td>
			  </tr>
			  <tr>		
				<td valign="top">  		
				 <form name="frmSele" method="post" action="HomepageMaintOperate.jsp">
				 <input type="hidden" name="method" value="ref">
				 <input type="hidden" name="subCompanyId" value="<%=subCompanyId%>">
				 
					  <TABLE class=Shadow width=100%>
						<tr>
						  <td valign="top">                        
							<TABLE class="ViewForm">
							<colgroup>
							<col width="20%">		
							<col width="80%">	
							<TR>
								<TD><%=SystemEnv.getHtmlLabelName(19423,user.getLanguage())%></TD>
								<TD class=field>
									<SELECT NAME="srchpid" id="srchpid">
										<%
											pc.setTofirstRow();
											while(pc.next()){
										%>
										<option value="<%=pc.getId()%>"><%=pc.getInfoname()%></option>
										<%}%>
									</SELECT>
								</TD>
							</TR>
							<tr style="height:1px;"><td colspan=2 class=line></td></tr>
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
				</td>
			</tr>
		</TABLE>
		
		</td>
		<td></td>
	</tr>
	<tr>
		<td height="10" colspan="2"></td>
	</tr>
	</table>
</body>
</html>
<SCRIPT LANGUAGE="JavaScript">
<!--
function onOk(){
	frmSele.submit();
}
function onBack(){
	window.location="/homepage/maint/HomepageRight.jsp?subCompanyId=<%=subCompanyId%>"
}
//-->
</SCRIPT>
