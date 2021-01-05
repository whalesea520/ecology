<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.*" %>
<%
if(!HrmUserVarify.checkUserRight("intergration:expsetting", user)){
	  response.sendRedirect("/notice/noright.jsp");
	  return;
}
String _fromURL = Util.null2String(request.getParameter("_fromURL"));
if(_fromURL.equals("")){
	_fromURL = "1";
}
%>
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<%if(_fromURL.equals("1")|| _fromURL.equals("")){%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelNames("31691,251",user.getLanguage())+"FTP"%>" class="e8_btn_top" onclick="document.contentframeRight.add()"/>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" class="e8_btn_top" onclick="document.contentframeRight.doDelete()"/>
				<%}else if(_fromURL.equals("2")){%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(125759,user.getLanguage())%>" class="e8_btn_top" onclick="document.contentframeRight.add()"/><!-- 注册归档本地 -->
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" class="e8_btn_top" onclick="document.contentframeRight.doDelete()"/>
				<%}else if(_fromURL.equals("3")){%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(125788,user.getLanguage())%>" class="e8_btn_top" onclick="document.contentframeRight.add()"/><!-- 注册归档数据库 -->
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" class="e8_btn_top" onclick="document.contentframeRight.doDelete()"/>
				<%}else if(_fromURL.equals("4")){%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(125755,user.getLanguage())%>" class="e8_btn_top" onclick="document.contentframeRight.addXML()"/><!-- 注册XML方案 -->
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(125756,user.getLanguage())%>" class="e8_btn_top" onclick="document.contentframeRight.addDB()"/><!-- 注册数据库方案 -->
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" class="e8_btn_top" onclick="document.contentframeRight.doDelete()"/>
				<%}%>
				<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu" onclick="showCornerMenu()"></span>
			</td>
		</tr>
	</table>
