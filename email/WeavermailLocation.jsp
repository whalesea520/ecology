<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.email.MailUserData" %>
<%@ page import="javax.mail.*" %>
<%@ page import="javax.mail.internet.*" %>


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>

<%
String mailtype = ""+Util.getIntValue(request.getParameter("mailtype"),0) ;
RecordSet.executeSql("select * from MailResource where resourceid = " + user.getUID()+" and mailtype='"+mailtype+"' order by senddate desc ") ;
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(71,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>


<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(2029,user.getLanguage())+",WeavermailAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

if(!mailtype.equals("3")) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(2030,user.getLanguage())+",javascript:doDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(2031,user.getLanguage())+",javascript:doDeleteforever(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(2032,user.getLanguage())+",WeavermailIndex.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM ACTION="WeavermailOperation.jsp" name=weaver METHOD="POST" onSubmit="return check_form(this,'username,password')">
  <input type = hidden name=operation value=deletelocation>
  <input type = hidden name=mailtype value=<%=mailtype%>>

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

		  <table class=ListStyle cellspacing="1">
			<colgroup> <col width="5%"> <col width="10%"> <col width="25%"> <col width="30%">  <col width="20%"> <col width="10%">
			<tbody> 
			<tr class=Header> 
			  <th colspan=6>
			  <% if(mailtype.equals("0")) {%>
			  <%=SystemEnv.getHtmlLabelName(2037,user.getLanguage())%> ：
			  <%} else if(mailtype.equals("1")) {%>
			  <%=SystemEnv.getHtmlLabelName(2038,user.getLanguage())%> ：
			  <%} else if(mailtype.equals("2")) {%>
			  <%=SystemEnv.getHtmlLabelName(2039,user.getLanguage())%> ：
			  <%} else if(mailtype.equals("3")) {%>
			  <%=SystemEnv.getHtmlLabelName(2040,user.getLanguage())%> ：
			  <%}%>
			  <%=RecordSet.getCounts()%></th>
			</tr>
			<tr class=Header> 
			  <td>&nbsp;</td>
			  <td><%=SystemEnv.getHtmlLabelName(848,user.getLanguage())%></td>
			  <td><%=SystemEnv.getHtmlLabelName(2034,user.getLanguage())%></td>
			  <td><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></td>
			  <td><%=SystemEnv.getHtmlLabelName(2035,user.getLanguage())%></td>
			  <td><%=SystemEnv.getHtmlLabelName(2036,user.getLanguage())%></td>
			</tr>
			<TR class=Line><TD colspan="6" ></TD></TR> 
			<%
		  int i=0;
		  while(RecordSet.next()) {
			if(i==0){
				i=1;
		  %>
			<tr class=datalight> 
			  <%
			}else{
				i=0;
		  %>
			<tr class=datadark> 
			  <%} %>
			  <td>
				<input type="checkbox" name="themail" value="<%=RecordSet.getString("id")%>">
			  </td>
			  <td><%
			  if(RecordSet.getString("priority").equals("") || Util.getIntValue(RecordSet.getString("priority").substring(0,1),3) == 3 ) {%>
			  Normal
			  <%} else if(Util.getIntValue(RecordSet.getString("priority").substring(0,1),3) > 3 ) {%>
			  Low
			  <%} else if(Util.getIntValue(RecordSet.getString("priority").substring(0,1),3) < 3 ) {%>
			  High
			  <%}%>
			  </td>
			  <%
			  	String temp = RecordSet.getString("sendfrom");
			  	String temp_lastname = Util.null2String(ResourceComInfo.getLastnameByEmail(temp));
			  	if(!temp_lastname.equals("")) temp = temp_lastname + "  "+"&lt;"+temp+"&gt;";
			  	/*
			  	String sql = "select lastname from HrmResource where email='"+temp+"'";
			  	rs.executeSql(sql);
	        	if(rs.next()){
	        		String pers = rs.getString("lastname");
	        		temp = pers + "  "+"&lt;"+temp+"&gt;";
	        	}
	        	*/
			  %>
			  <td><%=temp%></td>
			  <%
			  String tmpsubject="";
			  if(RecordSet.getString("subject").equals("")) tmpsubject="No Subject" ;
			  else  tmpsubject=RecordSet.getString("subject") ;
			  %>
			  <td><a href="WeavermailDetailLocation.jsp?msgid=<%=RecordSet.getString("id")%>&mailtype=<%=mailtype%>"><%=Util.toScreen(tmpsubject,user.getLanguage())%></a></td>
			  <td><%=RecordSet.getString("senddate")%></td>
			  <td><%=RecordSet.getString("size")%></td>
			</tr>
			<%}%>
			</tbody> 
		  </table>

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
</form>
</BODY>
<script>
function doDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
	document.weaver.operation.value='deletelocation';
	document.weaver.submit();
	}
}

function doDeleteforever(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
	document.weaver.operation.value='deleteforeverlocation';
	document.weaver.submit();
	}
}
</script>
</html>