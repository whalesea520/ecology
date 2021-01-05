<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="LabelInfoManager" class="weaver.systeminfo.label.LabelInfoManager" scope="page"/>
<jsp:useBean id="LabelMainManager" class="weaver.systeminfo.label.LabelMainManager" scope="page"/>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<html>

<%
	String Favouritename="";
	int id;
	id = Util.getIntValue(request.getParameter("id"),0);
    RecordSet.executeSql("select  pagename from SysFavourite where id = " + id );
    if( RecordSet.next()) Favouritename = Util.null2String(RecordSet.getString("pagename"));
%>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;	
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(2081,user.getLanguage())+SystemEnv.getHtmlLabelName(633,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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

			  <FORM style="MARGIN-TOP: 0px" name=frmView method=post action="FavouriteOperation.jsp">
					<TABLE class=ViewForm>
					  <COLGROUP> <COL width="20%"> <COL width="80%"><TBODY> 
					  <TR class=Title> 
						<TH colSpan=5><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
					  </TR>
					  <TR class=Spacing> 
						<TD class=Line1 colSpan=5></TD>
					  </TR>
					  <input type="hidden" name="id" value="<%=id%>">
					  <TR> 
						<TD><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TD>
						<TD Class=Field><INPUT class=InputStyle name=Favouritename value="<%=Favouritename%>"></TD>
					  </TR>
					  <TR> 
						<TD class=Line colSpan=5></TD>
					  </TR>
					  </TBODY> 
					</TABLE>
					<br>        
			<input type="hidden" name="operation" value="editFavourite">

				  </FORM>
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
</BODY>
<script language="javascript">
function doSubmit()
{
	frmView.submit();
}
function doBack()
{
	history.back();
}
</script>
</HTML>
