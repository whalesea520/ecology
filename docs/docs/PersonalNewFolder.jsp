
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DocUserSelfUtil" class="weaver.docs.docs.DocUserSelfUtil" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<META NAME="AUTHOR" CONTENT="InetSDK">
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%
int userCategory= Util.getIntValue(request.getParameter("userCategory"),0);
int haspost= Util.getIntValue(request.getParameter("haspost"),0);


if(haspost == 1){%>

<script language=javascript>
window.opener.parent.mainParent.document.location.reload(true);
window.close();
</script>
<%}%>

<script>


function checkForm(obj)
{
	var filename = document.create_folder_form.folder_name.value;
	var p = /^\s+$/;
	if (p.test(filename))
	{
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83420,user.getLanguage())%>");
		return false;
	}
	if (filename == '')
	{
		top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(83420,user.getLanguage())%>');
		return false;
	}
	else if (  filename.indexOf('/') != -1
			|| filename.indexOf('\\') != -1
			|| filename.indexOf(':') != -1
			|| filename.indexOf('*') != -1
			|| filename.indexOf('?') != -1
			|| filename.indexOf('"') != -1
			|| filename.indexOf('<') != -1
			|| filename.indexOf('>') != -1
			|| filename.indexOf('|') != -1 )
	{
		top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(83421,user.getLanguage())%>:\n/\\:*?"<>|');
		return false;
	}
	else
	{
        obj.disabled = true 
		document.create_folder_form.submit();
	}
}
</script>
</head>
<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:checkForm(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%

int parentid = Util.getIntValue(DocUserSelfUtil.getParentids(""+userCategory),0);
String parentids = DocUserSelfUtil.getParentids(""+userCategory);

		

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(18473,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<DIV class=HdrProps>
</DIV>
<form method="POST" action="PersonalDocOperation.jsp" name="create_folder_form">
<TABLE class=form>
  <COLGROUP>
  <TBODY>
<input type=hidden name="userCategory" value="<%=userCategory%>">
<input type=hidden name="parentid" value="<%=parentid%>">
<input type=hidden name="parentids" value="<%=parentids%>">
<input type=hidden name="operation" value="addfolder">
<br>
<div align=left>
<img src="images/font_win_wev8.gif" width="18" height="18" align="absmiddle"><b><%=SystemEnv.getHtmlLabelName(18499,user.getLanguage())%>:</b>
<a href="new_folder.jsp?userCategory=0"><img src="images/folder0_wev8.gif" width="18" height="18" align="absmiddle" border=0><%=SystemEnv.getHtmlLabelName(18476,user.getLanguage())%></a>
<%
int tmppos = parentids.indexOf(",0,");
while(tmppos != -1){
	int endpos = parentids.indexOf(",",tmppos+1);
	String tmpstr = "";
	if(endpos !=-1){
		tmpstr = parentids.substring(tmppos+1,endpos);
	}else{
		tmpstr = parentids.substring(tmppos+1);
	}
	if(!tmpstr.equals("0")){
%>
>&nbsp<a href="new_folder.jsp?userCategory=<%=tmpstr%>"><img src="images/folder0_wev8.gif" width="18" height="18" align="absmiddle" border=0><%=DocUserSelfUtil.getCatalogName(tmpstr)%></a>

<%}
	tmppos = endpos;
}
	if(userCategory!=0){
%>
><a href="new_folder.jsp?userCategory=<%=userCategory%>"><img src="images/folder0_wev8.gif" width="18" height="18" align="absmiddle" border=0><%=DocUserSelfUtil.getCatalogName(""+userCategory)%></a>
<%}%></div>
<br>
<div align=left>
 <b><%=SystemEnv.getHtmlLabelName(18473,user.getLanguage())+SystemEnv.getHtmlLabelName(195,user.getLanguage())%>：</b><input name="folder_name" class="inputStyle" size=30 class=saveHistory >
</div>

</form>



