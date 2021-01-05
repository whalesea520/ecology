
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocUserSelfUtil" class="weaver.docs.docs.DocUserSelfUtil" scope="page" />

<HTML><HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<META NAME="AUTHOR" CONTENT="InetSDK">
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%


String operation= Util.null2String(request.getParameter("operation"));
int userCategory= Util.getIntValue(request.getParameter("userCategory"),0);
int docId= Util.getIntValue(request.getParameter("docId"),0);
int haspost= Util.getIntValue(request.getParameter("haspost"),0);
boolean docRename = false ;
if ("docRename".equals(operation)){
    docRename = true ;
}

if(haspost == 1){%>

<script language=javascript>
//window.opener.parent.mainParent.document.location.reload(true);
//window.close();
</script>
<%}%>

<script>


function checkForm(obj)
{
	var filename = document.create_folder_form.folder_name.value;
	var p = /^\s+$/;
	if (p.test(filename))
	{
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81968,user.getLanguage())%>");
		return false;
	}
	if (filename == '')
	{
		top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(81968,user.getLanguage())%>');
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
		top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(83419,user.getLanguage())%>:\n/\\:*?"<>|');
		return false;
	}
	else
	{   
        obj.disabled = true ;
        if (<%=docRename%>) {
            document.create_folder_form.operation.value='docRename'
        } else {
            document.create_folder_form.operation.value = 'folderRename' 
        }
		document.create_folder_form.submit();
	}
}
</script>
</head>
<BODY>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
if (docRename) {
    titlename = titlename+SystemEnv.getHtmlLabelName(18493,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(18477,user.getLanguage());
} else {
    titlename = titlename+SystemEnv.getHtmlLabelName(18473,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(18477,user.getLanguage());
}

String needfav ="";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:checkForm(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
 <%
 String showName = "" ;
 if (!docRename){ 
    showName = DocUserSelfUtil.getCatalogName(""+userCategory);
   } else {
     showName = DocUserSelfUtil.getDocNameAtonce(""+docId);
   }
 %>
<DIV class=HdrProps>
</DIV>
<form method="POST" action="PersonalDocOperation.jsp" name="create_folder_form">
<input type=hidden name="userCategory" value="<%=userCategory%>">
<input type=hidden name="docId" value="<%=docId%>">
<input type=hidden name="operation">
<TABLE class=viewForm>
  <COLGROUP>
  <TBODY>
  <TR class=line1><TD colspan="2"></TD></TR>  
  <tr>
    <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>：</td>    
    <td class="field">
         <input name="folder_name" size=30 class="inputStyle" value="<%=showName%>">
    </td>
    <TR class=line><TD colspan="2"></TD></TR>  
</tbody>
</table>
</form>
</body>
</html>


