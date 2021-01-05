<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
	<BODY>
	<div style="overflow: auto;padding-left: 5px">
		<TABLE>
			<tr>
				<td id="msg" align="left" colspan="2" width="100%" height="100%">
					<font size="2" color="#FF0000">
					<%
					 	String errormsg = Util.null2String((String) request.getSession().getAttribute("GOAL_IMPORT_INFO"));
					 	out.println(errormsg);
					%>
					</font>
				</td>
			</tr>
		</table>
	</div>
	</body>
</HTML>