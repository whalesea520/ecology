
<%@page import="java.util.ArrayList"%>
<%--以下为支持JBOSS应用服务器校验语法，作出如下改动，将<wea:layout>和<wea:group>标签头移入此页面保证标签有始有终--%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ include file="/page/element/settingCommon_params.jsp"%>
<%@ include file="common.jsp"%>
<wea:layout type="2Col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
<%@ include file="/page/element/settingCommon_dom.jsp"%>

<%--以上，为支持JBOSS应用服务器校验语法，作出如下改动，将<wea:layout>和<wea:group>标签头移入此页面保证标签有始有终--%>

<%
String flashSrcType = (String)valueList.get(nameList.indexOf("flashSrcType"));
String flashSrc = (String)valueList.get(nameList.indexOf("flashSrc"));
String width = (String)valueList.get(nameList.indexOf("width"));
String height = (String)valueList.get(nameList.indexOf("height"));
%>
<%
if("2".equals(esharelevel)){
		%>

	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19653,user.getLanguage())%></wea:item>
	<wea:item>
		<INPUT class="inputstyle" style="display:none"
			title="<%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>"
			style="WIDTH: 24px" name="width_<%=eid%>"
			value="<%=width %>" />
		
		<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>:
		<INPUT class="inputstyle"
			title="<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>"
			style="WIDTH: 30px" name="height_<%=eid %>"
			value="<%=height %>" onkeypress="ItemCount_KeyPress(event)" />
		&nbsp;	
	</wea:item>
	<wea:item>&nbsp;Flash<%=SystemEnv.getHtmlLabelName(15240,user.getLanguage())%></wea:item>
	<wea:item>
		<TABLE class="viewform" width="100%">
			<col width="80" />
			<col width="*" />
			<TBODY>
				<TR>
					<TD>
						<INPUT id="flashSrcType_<%=eid%>" type="radio"
							<%if(flashSrcType.equals("1")) out.print("checked");%>
							name="flashSrcType_<%=eid%>" selecttype="1" value='1' />
						<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18493,user.getLanguage())%>
					</TD>
					<td>
						<input width="60%" name="flashSrc_<%=eid%>"
							id="flashSrc_<%=eid%>" class="filetree" type="text"
							value="<%if(flashSrcType.equals("1")) out.print(flashSrc);%>" />
					</td>
				</TR>
				<TR>
					<TD>
						<INPUT id="flashSrcType_<%=eid%>" type="radio"
							<%if(flashSrcType.equals("2")) out.print("checked");%>
							name="flashSrcType_<%=eid%>" selecttype="2" value="2" />
						URL<%=SystemEnv.getHtmlLabelName(18499,user.getLanguage())%>
						&nbsp;&nbsp;
					</TD>
					<TD>
						<input name="flashUrl_<%=eid%>"
							value="<%if(flashSrcType.equals("2")) out.print(flashSrc); %>"
							class="inputStyle" style="WIDTH:90%" onKeyPress= "CheckNum()">
					</TD>
				</TR>
			</TBODY>
		</TABLE>
	</wea:item>
	<%} %>
	</wea:group>
</wea:layout>
<SCRIPT LANGUAGE="JavaScript">
		function   CheckNum() 
		{ 
			if (Window.event.keyCode==39) 
				{ 
    			window.event.keyCode=0; 
				} 
		} 
</SCRIPT>
