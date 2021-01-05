
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util,java.net.*"%>
<%
String message = Util.null2String(request.getParameter("message"));  // 返回的错误信息

%>

<HTML>
<HEAD>
<LINK rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
</HEAD>
<BODY>
<%if (message.equals("0")) {%>

<TABLE class=Form>
<TR>
	<TD valign=top>
		<TABLE>
			<TR class=Section><TH style="font-size:8pt"> 提交成功！</TH></TR>
		    
			<TR><TD>信息提交成功！我们会尽快和您联系！谢谢！</TD></TR>
			
		</TABLE>
	</TD>
	
</TR>
</TABLE>

<%}else{%>

<TABLE class=Form>
<TR>
	<TD valign=top>
		<TABLE>
			<TR class=Section><TH style="font-size:8pt"> 提交出错！</TH></TR>
		    
			<TR><TD>请通知网站管理员！</TD></TR>
			
		</TABLE>
	</TD>
	
</TR>
</TABLE>

<%}%>

</BODY>
</HTML>