
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("ServiceFile:Manage",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(28579,user.getLanguage());
String needfav ="1";
String needhelp ="";
String errorcode = Util.null2String(request.getParameter("errorcode"));
String _code = Util.null2String(request.getParameter("_code"));
RecordSet.execute("select * from SAPCONN where code='"+_code+"'");
String sapclient = "";
String _hostname = "";
String userid = "";
String password = "";
String language = "";
String systemnumber = "";
if(RecordSet.next()){
	sapclient = RecordSet.getString("sapclient");
	_hostname = RecordSet.getString("hostname");
	userid = RecordSet.getString("userid");
	password = RecordSet.getString("password");
	language = RecordSet.getString("language");
	systemnumber = RecordSet.getString("systemnumber");
}
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",SAPConnection.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="SAPConnectionOperation.jsp">
<input type="hidden" id="operation" name="operation" value="edit">
<input type="hidden" id="_code" name="_code" value="<%=_code%>">
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
			  <TABLE class=ViewForm>
				<COLGROUP> <COL width="20%"> <COL width="80%">
				<TBODY>
					
				<TR class=Title>
				  <TH colSpan=2><%=titlename%>&nbsp;<%if("101".equals(errorcode)) {%><font color=red><%=SystemEnv.getHtmlLabelName(127959 ,user.getLanguage()) %></font><%} %></TH>
				</TR>
				<TR class=Spacing>
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				<tr>
				  <td>SAP<%=SystemEnv.getHtmlLabelName(83570 ,user.getLanguage()) %></td>
				  <td class=Field>
				  	<input class="inputstyle" type=text id="code" name="code" MaxLength="10" onChange="checkinput('code','codespan')" value=<%=_code %>>
				  	<span id="codespan"><%if("".equals(_code)){ %><img src="/images/BacoError_wev8.gif" align=absmiddle><%} %></span>
				  </td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td>SAP<%=SystemEnv.getHtmlLabelName(15038 ,user.getLanguage())+SystemEnv.getHtmlLabelName(32531 ,user.getLanguage())  %></td>
				  <td class=Field>
					<input class="inputstyle" type=text id="hostname" name="hostname" MaxLength="50" onChange="checkinput('hostname','hostnamespan')" value="<%=_hostname%>">
				  	<span id="hostnamespan"><%if("".equals(_hostname)) {%><img src="/images/BacoError_wev8.gif" align=absmiddle><%} %></span>
				  </td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td>SAP<%=SystemEnv.getHtmlLabelName(108 ,user.getLanguage()) %></td>
				  <td class=Field>
				  	<input class="inputstyle" type=text id="sapclient" name="sapclient" MaxLength="50" onChange="checkinput('sapclient','sapclientspan')" value="<%=sapclient%>">
				  	<span id="sapclientspan"><%if("".equals(sapclient)){ %><img src="/images/BacoError_wev8.gif" align=absmiddle><%} %></span>
				  </td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td>SAP<%=SystemEnv.getHtmlLabelName(2072 ,user.getLanguage()) %></td>
				  <td class=Field>
				  	<input class="inputstyle" type=text id="userid" name="userid" MaxLength="50" onChange="checkinput('userid','useridspan')" value="<%=userid%>">
				  	<span id="useridspan"><%if("".equals(userid)) {%><img src="/images/BacoError_wev8.gif" align=absmiddle><%} %></span>
				  </td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td>SAP<%=SystemEnv.getHtmlLabelName(409 ,user.getLanguage()) %></td>
				  <td class=Field>
				  	<input class="inputstyle" type="password" id="password" name="password" MaxLength="50" onChange="checkinput('password','passwordspan')" value="<%=password%>">
				  	<span id="passwordspan"><%if("".equals(password)) {%><img src="/images/BacoError_wev8.gif" align=absmiddle><%} %></span>
				  </td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td>SAP<%=SystemEnv.getHtmlLabelName(231 ,user.getLanguage()) %></td>
				  <td class=Field>
				  	<input class="inputstyle" type=text id="language" name="language" MaxLength="50" onChange="checkinput('language','languagespan')" value="<%=language%>">
				  	<span id="languagespan"><%if("".equals(language)) {%><img src="/images/BacoError_wev8.gif" align=absmiddle><%} %></span>
				  </td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td>SAP<%=SystemEnv.getHtmlLabelName(83588 ,user.getLanguage()) %></td>
				  <td class=Field>
				  	<input class="inputstyle" type=text id="systemnumber" name="systemnumber" MaxLength="50" onChange="checkinput('systemnumber','systemnumberspan')"  value="<%=systemnumber%>">
				  	<span id="systemnumberspan"><%if("".equals(systemnumber)){ %><img src="/images/BacoError_wev8.gif" align=absmiddle><%} %></span>
				  </td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR>

<tr>
<td colSpan="10">
</td>
</tr>
				
				</TBODY>
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
</BODY>

<script language="javascript">
function onSubmit(){
    if(check_form(frmMain,"code,hostname,sapclient,userid,password,language,systemnumber")) frmMain.submit();
}
</script>

</HTML>
