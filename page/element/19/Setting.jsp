
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
strsqlwhere=Util.null2String(strsqlwhere);
String setValue1="";
int tempPos=strsqlwhere.indexOf("^,^");
if(tempPos!=-1){
  setValue1=strsqlwhere.substring(0,tempPos);	
} else {
	setValue1=strsqlwhere;
}
String height = (String)valueList.get(nameList.indexOf("height"));
String width = (String)valueList.get(nameList.indexOf("width"));
if("".equals(height)){
	height ="195";
}
if("".equals(width)){
	width = "300";
}
%>
	<%
if("2".equals(esharelevel)){
		%>	
		<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2036,user.getLanguage())%></wea:item>
		<wea:item>
		<%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>:
		<INPUT class="inputstyle"
			title="<%=SystemEnv.getHtmlLabelName(203,user.getLanguage())%>"
			style="WIDTH: 34px" name="width_<%=eid %>"
			value="<%=width %>" onkeypress="ItemCount_KeyPress(event)" onpaste="return !clipboardData.getData('text').match(/\D/)"
			ondragenter="return false"
			style="ime-mode:Disabled"
			>
		&nbsp;
		<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>:
		<INPUT class="inputstyle"
			title="<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>"
			style="WIDTH: 34px" name="height_<%=eid %>"
			value="<%=height %>" onkeypress="ItemCount_KeyPress(event)" onpaste="return !clipboardData.getData('text').match(/\D/)"
			ondragenter="return false"
			style="ime-mode:Disabled"
			>
		&nbsp;
		</wea:item>
		<<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(20048,user.getLanguage()) %></wea:item>
		<<wea:item><INPUT TYPE="text" name="_whereKey_<%=eid %>" value="<%=setValue1 %>" class="inputStyle" style="width:98%"><br><%=SystemEnv.getHtmlLabelName(20050,user.getLanguage()) %>(SHA:000001;SHE:399001)</wea:item>
	<%
}
		%>
	</wea:group>
</wea:layout>


