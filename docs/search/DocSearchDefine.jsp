<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="DocSearchDefineManager" class="weaver.docs.search.DocSearchDefineManager" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
int userid=Util.getIntValue(request.getParameter("userid"),-1);
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(343,user.getLanguage());
String needfav ="1";
String needhelp ="";

DocSearchDefineManager.setUserid(userid);
DocSearchDefineManager.selectSearchDefine();
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(149,user.getLanguage())+",javascript:onDefault(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
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
<script>
function onSave(){
	document.frmmain.savetype.value="save";
	document.frmmain.submit();
}
function onDefault(){
	document.frmmain.savetype.value="default";
	document.frmmain.submit();
}
</script>
<FORM id=docsearch name=frmmain action="DocSearchDefineSave.jsp" method=post >
  <input type="hidden" name="savetype">
  <%if (DocSearchDefineManager.getUserid()==-1){%>
  	<input type="hidden" name="operation" value="insert">
  <%} else{ %>
  	<input type="hidden" name="operation" value="update">
  <% }%>
  <table class=ViewForm>
  	<colgroup>
	<COL width="15%">
	<COL width="85%">
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></TH>
        </TR>
    	<TR class=Spacing>
          <TD class=Line1 colSpan=2></TD></TR>
        <tr>
        <tr>
          <td><input type="checkbox" name="subject" value="0" <%if (DocSearchDefineManager.getSubjectdef().equals("0")){%> checked<%}%>></td>
          <td><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></td>
        </tr>
        <tr>
          <td><input type="checkbox" name="content" value="0" <%if (DocSearchDefineManager.getContentdef().equals("0")){%> checked<%}%>></td>
          <td><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></td>
        </tr>
		<tr>
          <td><input type="checkbox" name="keyword" value="0" <%if (DocSearchDefineManager.getKeyworddef().equals("0")){%> checked<%}%>></td>
          <td><%=SystemEnv.getHtmlLabelName(2005,user.getLanguage())%></td>
        </tr>
        <tr>
          <td><input type="checkbox" name="reply" value="0" <%if (DocSearchDefineManager.getReplydef().equals("0")){%> checked<%}%>></td>
          <td><%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%></td>
        </tr>
        <tr>
          <td><input type="checkbox" name="docid" value="0" <%if (DocSearchDefineManager.getDociddef().equals("0")){%> checked<%}%>></td>
          <td><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></td>
        </tr>
        <tr>
          <td><input type="checkbox" name="owner" value="0" <%if (DocSearchDefineManager.getOwnerdef().equals("0")){%> checked<%}%>></td>
          <td><%=SystemEnv.getHtmlLabelName(79,user.getLanguage())%></td>
        </tr>
        <tr>
          <td><input type="checkbox" name="category" value="0" <%if (DocSearchDefineManager.getCategorydef().equals("0")){%> checked<%}%>></td>
          <td><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%>,<%=SystemEnv.getHtmlLabelName(66,user.getLanguage())%>,<%=SystemEnv.getHtmlLabelName(67,user.getLanguage())%></td>
        </tr>
        <tr>
          <td><input type="checkbox" name="department" value="0" <%if (DocSearchDefineManager.getDepartmentdef().equals("0")){%> checked<%}%>></td>
          <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
        </tr>
        <tr>
          <td><input type="checkbox" name="item" value="0" <%if (DocSearchDefineManager.getItemdef().equals("0")){%> checked<%}%>></td>
          <td><%=SystemEnv.getHtmlLabelName(145,user.getLanguage())%></td>
        </tr>
        <tr>
          <td><input type="checkbox" name="itemcategory" value="0" <%if (DocSearchDefineManager.getItemmaincategorydef().equals("0")){%> checked<%}%>></td>
          <td><%=SystemEnv.getHtmlLabelName(145,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></td>
        </tr>

        
        <tr>
          <td><input type="checkbox" name="crm" value="0" <%if (DocSearchDefineManager.getCrmdef().equals("0")){%> checked<%}%>></td>
          <td><%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></td>
        </tr>
        <tr>
          <td><input type="checkbox" name="hrm" value="0" <%if (DocSearchDefineManager.getHrmresdef().equals("0")){%> checked<%}%>></td>
          <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
        </tr>
        <tr>
          <td><input type="checkbox" name="project" value="0" <%if (DocSearchDefineManager.getProjectdef().equals("0")){%> checked<%}%>></td>
          <td><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></td>
        </tr>
        <tr>
          <td><input type="checkbox" name="finance" value="0" <%if (DocSearchDefineManager.getFinancedef().equals("0")){%> checked<%}%>></td>
          <td><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(187,user.getLanguage())%></td>
        </tr>
        <tr>
          <td><input type="checkbox" name="financeref1" value="0" <%if (DocSearchDefineManager.getFinancerefdef1().equals("0")){%> checked<%}%>></td>
          <td><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(191,user.getLanguage())%>1</td>
        </tr>
        <tr>
          <td><input type="checkbox" name="financeref2" value="0" <%if (DocSearchDefineManager.getFinancerefdef2().equals("0")){%> checked<%}%>></td>
          <td><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(191,user.getLanguage())%>2</td>
        </tr>
        <tr>
          <td><input type="checkbox" name="langurage" value="0" <%if (DocSearchDefineManager.getLanguragedef().equals("0")){%> checked<%}%>></td>
          <td><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></td>
        </tr>
        <tr>
          <td><input type="checkbox" name="status" value="0" <%if (DocSearchDefineManager.getStatusdef().equals("0")){%> checked<%}%>></td>
          <td><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></td>
        </tr>
        <tr>
          <td><input type="checkbox" name="publish" value="0" <%if (DocSearchDefineManager.getPublishdef().equals("0")){%> checked<%}%>></td>
          <td><%=SystemEnv.getHtmlLabelName(114,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></td>
        </tr>        
    </tr>
  </table>
</form>

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

</body>
</html>