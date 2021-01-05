
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
	<ul class="OContRightMsg2 FR ">
		<li>
			<a href="javascript:okBtn();" class="hover">
				<div>
					<div>
						<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())  %>
					</div>
				</div> </a>
		</li>
	</ul>
	<ul class="OContRightMsg2 FR">
		<li>
			<a href="javascript:delRow();" class="hover">
				<div>
					<div>
						<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())  %>
					</div>
				</div> </a>
		</li>
	</ul>
</div>
<input type="hidden" id="rid" name="rid" value=<%=Util.null2String(request.getParameter("requestid"))%> />
<input type="hidden" id="rname" name="rname" value=<%=Util.null2String(request.getParameter("requestname"))%> />
<input type="hidden" id="test" name="test" value=<%=Util.null2String(request.getParameter("licenseid"))%> />
<table id="attTable" width="100%" cellpadding="0"
	cellspacing="1" class="stripe OTable" bordercolor="#F0F0F0">
	<tr id="OTable2" height=25 class="cBlack">
		<td width="10%" align="center">

		</td>
		<td width="90%" align="left">
			<strong><%=SystemEnv.getHtmlLabelName(23752,user.getLanguage())  %></strong>
		</td>
	</tr>
</table>