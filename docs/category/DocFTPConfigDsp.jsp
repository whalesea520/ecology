
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

</head>

<%

    int id = Util.getIntValue(request.getParameter("id"),0);
    String FTPConfigName="";
    String FTPConfigDesc="";
    String serverIP="";
    String serverPort="";
    String userName="";
    String userPassword="";
    String defaultRootDir="";
    int maxConnCount=0;
    float showOrder=0;
	
	RecordSet.executeSql("select * from DocFTPConfig where id=" + id);
	if(RecordSet.next()){
		FTPConfigName = Util.null2String(RecordSet.getString("FTPConfigName"));
		FTPConfigDesc = Util.null2String(RecordSet.getString("FTPConfigDesc"));
		serverIP = Util.null2String(RecordSet.getString("serverIP"));
		serverPort = Util.null2String(RecordSet.getString("serverPort"));
		userName = Util.null2String(RecordSet.getString("userName"));
		userPassword = Util.null2String(RecordSet.getString("userPassword"));
		defaultRootDir = Util.null2String(RecordSet.getString("defaultRootDir"));
		maxConnCount = Util.getIntValue(RecordSet.getString("maxConnCount"),0);
		showOrder = Util.getFloatValue(RecordSet.getString("showOrder"),0);
	}



String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(20518,user.getLanguage())+"："+FTPConfigName;
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<DIV>
<%
if(HrmUserVarify.checkUserRight("DocFTPConfigEdit:Edit", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:location='DocFTPConfigEdit.jsp?id="+id+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(HrmUserVarify.checkUserRight("DocFTPConfigEdit:Delete", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}
//TD.4617 增加返回按钮
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:location='DocFTPConfig.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

</DIV>
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

<DIV id=msgDiv style="color:red"></DIV>

<iframe name="msgDivGetter" style="width:100%;height:200;display:none"></iframe>

<FORM id=weaver name=weaver action="UploadDocFTPConfig.jsp" method=post enctype="multipart/form-data">
<input type=hidden name=operation>
<input type=hidden name=id value="<%=id%>">


<br>
<TABLE class=ViewForm>
<TBODY>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">

<TR class=Spacing><TD aligh=left colspan=2>
<b>
<%=SystemEnv.getHtmlLabelName(20518,user.getLanguage())%>
</b>
</TD></TR>
<TR><TD class=Line1 colSpan=2></TD></TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></td>
<td class=field>
<%=id%>
</td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
<td class=field>
<%=FTPConfigName%>
</td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td>
<td class=field>
<%=FTPConfigDesc%>
</td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></td>
<td class=field>
<%=serverIP%>
</td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18782,user.getLanguage())%></td>
<td class=field>
<%=serverPort%>
</td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2072,user.getLanguage())%></td>
<td class=field>
<%=userName%>
</td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></td>
<td class=field>
●●●●●●
</td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18476,user.getLanguage())%></td>
<td class=field>
<%=defaultRootDir%>
</td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(20522,user.getLanguage())%></td>
<td class=field>
<%=maxConnCount%>
</td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<tr>
<td><%=SystemEnv.getHtmlLabelName(20519,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></td>
<td class=field>
<%=showOrder%>
</td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>



</tbody>
</table>






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

</body>


<script language=javascript>
function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		document.all("msgDivGetter").src="DocFTPConfigIframe.jsp?operation=Delete&FTPConfigId="+<%=id%>;
	}
}

function checkForDelete(returnString){
	if(returnString=='') {
		document.weaver.operation.value='delete';
		document.weaver.submit();
	}else{
		msgDiv.innerHTML=returnString;
	}
}

</script>