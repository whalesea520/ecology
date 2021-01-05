<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%
	int tempImageFileId = Util.getIntValue(request.getParameter("tempImageFileId"), 0);
%>

<table border=0 cellspacing="0" cellpadding="0">
	<tbody>
		<tr height='100%'>
			<td style="border: 0px;">
				<div id="DivID" style="border: 0px !important;">
					<img src="/weaver/weaver.file.FileDownload?fileid=<%=tempImageFileId%>"></img>
				</div>
			</td>
		</tr>
	</tbody>
</table>