
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet"/>
<HTML><HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(131596,user.getLanguage());
String needfav ="1";
String needhelp ="";
int id = Util.getIntValue(request.getParameter("id"));
%>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
</head>
<%

if(!HrmUserVarify.checkUserRight("SensitiveWord:Manage", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
rs.executeSql("select * from sensitive_words where id = "+id);
String word = "";
if(rs.next()){
	word = Util.null2String(rs.getString("word"));
}
%>
<BODY>

<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>


<FORM id=weaver name=weaver action="/security/sensitive/SensitiveWordOperation.jsp" method=post>
<input type=hidden name="operation" value="edit">
<input type=hidden name="id" id="id" value="<%=id%>">


<%

	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onCancel(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	
%>

<TABLE class=ViewForm>
	 <COLGROUP>
	    <COL width="20%">
	    <COL width="80%">
		</colgroup>
	 <TBODY>
		<tr>
		<td><%=SystemEnv.getHtmlLabelName(131596,user.getLanguage())%></td>
		<td class=Field>
				<INPUT maxLength=500 size=500 class=InputStyle name="word" id="word"  onChange="checkinput('word','wordspan')" temptitle="<%=SystemEnv.getHtmlLabelName(131596,user.getLanguage())%>"  value="<%=word%>" style="width:80%;">
				<SPAN id=wordspan><%if("".equals(word)){%><IMG src="/images/BacoError.gif" align=absMiddle><%}%></SPAN>
		</td>
		</tr>
		<TR style="height: 1px!important;"><TD class=Line colSpan=2></TD></TR>
	</tbody>
</table>
       
</form>


<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script language="javascript">

function onSave(isEnterDetail){
	if(check_form(document.weaver,'word')){
			document.weaver.submit();
	}
}
function onCancel(){
		window.location.href="/security/sensitive/SensitiveWords.jsp"
	}


</script>
</BODY></HTML>