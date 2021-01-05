<%@ include file="/page/element/viewCommon.jsp"%>
<%@ include file="common.jsp" %>
<%@ page import="weaver.hrm.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>

<%
String heightValue = (String)valueList.get(nameList.indexOf("height"));
if("".equals(heightValue))
{
	heightValue = "100";	
}else{
	heightValue=heightValue.replace("+","");
}
String sql = "select padcontent "+
			 " from scratchpad "+
			 " where userid = "+user.getUID()+" and eid='"+eid+"'";
rs.executeSql(sql);
String padcontent = "";
while(rs.next())
{
	padcontent = rs.getString("padcontent");	
}
%>
<script type="text/javascript">
	
</script>
<div id="scratchpad_<%=eid %>">
	<table height="<%=heightValue%>" border="0" style="width:100%;">
		<tr>
			<td>
				<TEXTAREA id=scratchpadarea_<%=eid %> style="WIDTH: 100%; HEIGHT: <%=heightValue%>px;FONT-SIZE: 9pt; MARGIN: 0px; FONT-FAMILY: Verdana;" onblur="saveScratchpad('<%=eid %>','<%=user.getUID() %>');"><%=padcontent %></TEXTAREA>
			</td>
		</tr>
	</table>
</div>