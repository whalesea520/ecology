<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@ include file="common.jsp"%>
<%
	String searchType = (String) valueList.get(nameList.indexOf("newsid"));
	String newsTemplate = (String) valueList.get(nameList.indexOf("newstemplate"));
	
%>

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>


<div id="searchengine_<%=eid%>">
	
	<FORM id="searchf_<%=eid%>"  method= "get" name="searchf_<%=eid%>" action="/page/element/SearchEngine/NewsSearchList.jsp" target='_blank'>
		<input type='hidden' name='eid' value='<%=eid %>'>
		<table border="0" cellspacing="0" cellpadding="0" align=center>
			<TBODY>
				<TR vAlign=top>
					
					<TD nowrap style="padding: 0 3px 0 5px">
						<INPUT title="<%=SystemEnv.getHtmlLabelName(197,7)%>" maxLength=2048 name=keyword autocomplete="off" class="InputStyle_1">
					</TD>
					<td nowrap>
						<INPUT type=submit value="<%=SystemEnv.getHtmlLabelName(197,7)%>" name=btnG>
						&nbsp;
					</td>
				</TR>
			</TBODY>
		</TABLE>
	</FORM>
	
</div>

