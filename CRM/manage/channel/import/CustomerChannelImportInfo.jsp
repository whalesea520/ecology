
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

	</head>
	<BODY>
	<div style="overflow: auto;padding-left: 5px">
		<TABLE>
			<tr>
				<td id="msg" align="left" colspan="2" width="100%" height="100%">
					<font size="2" color="#FF0000">
					<%
					 	String errormsg = (String) request.getSession().getAttribute("CRM_IMPORT_ERROR");
					 	out.println(errormsg);
					%>
					</font>
				</td>
			</tr>
		</table>
	</div>
	</body>
</HTML>