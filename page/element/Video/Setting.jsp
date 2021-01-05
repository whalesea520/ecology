
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%--以下为支持JBOSS应用服务器校验语法，作出如下改动，将<wea:layout>和<wea:group>标签头移入此页面保证标签有始有终--%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ include file="/page/element/settingCommon_params.jsp"%>
<%@ include file ="common.jsp" %>
<wea:layout type="2Col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
<%@ include file="/page/element/settingCommon_dom.jsp"%>

<%--以上，为支持JBOSS应用服务器校验语法，作出如下改动，将<wea:layout>和<wea:group>标签头移入此页面保证标签有始有终--%>
		<%
if("2".equals(esharelevel)){
		%>	
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19653,user.getLanguage())%><!--显示设置--></wea:item>
	<wea:item>
		<INPUT style='display:none'	class="inputstyle" title="<%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>" style="WIDTH: 24px"	name="width_<%=eid%>" value="<%=valueList.get(nameList.indexOf("width")) %>"/> 
		<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>:<INPUT class="inputstyle" title="<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>" style="WIDTH: 38px;HEIGHT:18px;" name="height_<%=eid %>" onkeypress="ItemCount_KeyPress(event)" value="<%=valueList.get(nameList.indexOf("height")) %>" />&nbsp;&nbsp;&nbsp;
		<input type='hidden' name= "quality_<%=eid%>" value='9'>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<INPUT type="checkbox" <% if(valueList.get(nameList.indexOf("fullScreen")).equals("on")) out.print("checked"); else out.print(""); %> name="fullScreen_<%=eid%>" />
		<%=SystemEnv.getHtmlLabelName(22839,user.getLanguage())%>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<INPUT type="checkbox" <% if(valueList.get(nameList.indexOf("autoPlay")).equals("on")) out.print("checked"); else out.print(""); %> name="autoPlay_<%=eid%>" />
		<%=SystemEnv.getHtmlLabelName(22840,user.getLanguage())%> <BR />
	</wea:item>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(22841,user.getLanguage())%><!--视频来源--></wea:item>
	<wea:item>
		<TABLE class="viewform" width="100%">
				<col width="80"/>
				<col width="*"/>
			<TBODY>
				<TR>
					<TD>
					<INPUT id="videoSrcType_<%=eid%>" type="radio"
						<%if( "".equals(valueList.get(nameList.indexOf("videoSrcType")))|| valueList.get(nameList.indexOf("videoSrcType")).equals("1")) out.print("checked");%> name="videoSrcType_<%=eid%>" selecttype="1" value='1' />
					<%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18493,user.getLanguage())%>
					</TD>
					<td>
					<input width="60%" name="videoSrc_<%=eid%>" id="videoSrc_<%=eid%>"  class="filetree" type="text" value="<%if(valueList.get(nameList.indexOf("videoSrcType")).equals("1")) out.print(valueList.get(nameList.indexOf("videoSrc")));%>"/>
					</td>
				</TR>
				<TR>
					<TD><INPUT id="videoSrcType_<%=eid%>" type="radio"
						<%
						if(valueList.get(nameList.indexOf("videoSrcType")).equals("2")) out.print("checked");%> name="videoSrcType_<%=eid%>" selecttype="2" value="2" /> URL<%=SystemEnv.getHtmlLabelName(18499,user.getLanguage())%><!--文档目录-->&nbsp;&nbsp;
						</TD>
						<TD>
						<input name = "videoUrl_<%=eid%>" value="<%if(valueList.get(nameList.indexOf("videoSrcType")).equals("2")) out.print(valueList.get(nameList.indexOf("videoSrc"))); %>"  onKeyPress= "CheckNum()" class="inputStyle" style='width:90%'>
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
	
