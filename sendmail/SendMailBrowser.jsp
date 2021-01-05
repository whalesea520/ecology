<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="SendMailBrowser.jsp" method=post>
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
			<TABLE ID=BrowseTable class=BroswerStyle cellspacing="1" width="100%">
			<TR class=DataHeader>
			<TH width=0% style="display:none"></TH>
			<TH width=40%>标识</TH>
			<TH width=60%>输入报表名称</TH>
			</TR>
			<TR class=Line style="height:1px"><TH colspan="3" ></TH></TR> 
			<%
			int i=0;
			String sqlwhere = "select * from T_SurveyItem " ;
			rs.execute(sqlwhere);
			while(rs.next()){
					if(i==0){
					i=1;
			%>
			<TR class=DataLight>
			<%
				}else{
					i=0;
			%>
			<TR class=DataDark>
				<%
				}
				%>
				<TD><%=Util.toScreen(rs.getString("inprepid"),user.getLanguage())%></TD>
			   
				<TD><%=Util.toScreen(rs.getString("inprepname"),user.getLanguage())%></TD>
			</TR>
			<%}%>
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

</FORM>
<SCRIPT LANGUAGE="JavaScript">

	jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
			
		window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()};
			window.parent.close()
		})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			$(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			$(this).removeClass("Selected")
	})

})
function submitClear()
{
	window.parent.returnValue = {id:"",name:""};
	window.parent.close()
}
function onClose()
{
	window.parent.close() ;
}
function onClear()
{
	submitClear() ;
}

  </SCRIPT>
</BODY>
</HTML>

