<%@ page language="java" contentType="text/html; charset=UTF-8"%>
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
		<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(82754,user.getLanguage())%></wea:item>
		<wea:item>
		<INPUT type="checkbox" value="1" id="displayName_<%=eid%>" name="displayName_<%=eid%>" onclick="change(this);" <% if(valueList.get(nameList.indexOf("displayName")).equals("1")) out.print("checked"); else out.print(""); %>/> <%=SystemEnv.getHtmlLabelName(82755,user.getLanguage())%> 
		<!--QC297379 [80][90]集成登录设置-解决集成登录元素中改变名称字数，但列表中集成登录名称字数没有变化的问题  -->
		<!--
		<span id="len_ctr">&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(82756,user.getLanguage())%>&nbsp;&nbsp;<input class=inputstyle type="text" style='width:120px!important;' name="displayNamelen_<%=eid%>"  value="<%=valueList.get(nameList.indexOf("displayNamelen"))%>" 
			onkeyup="this.value=this.value.replace(/[^0-9]/g,'');" onblur="checkNumber(this.value)" _noMultiLang='true'></span>
		-->
		<!--QC297379 [80][90]集成登录设置-解决集成登录元素中改变名称字数，但列表中集成登录名称字数没有变化的问题 end-->
		</wea:item>
		
		<wea:item>&nbsp;</wea:item>
		<wea:item>
			<INPUT type="checkbox" value="1" name="displayimag_<%=eid%>" onclick="change1(this);" <% if(valueList.get(nameList.indexOf("displayimag")).equals("1")) out.print("checked"); else out.print(""); %>/> <%=SystemEnv.getHtmlLabelName(82757,user.getLanguage())%>
		</wea:item>
		
		<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(82758,user.getLanguage())%></wea:item>
		<wea:item>	
    	<select name="displaytype_<%=eid%>" >
			<option value="1" <%if("1".equals(valueList.get(nameList.indexOf("displaytype")))) out.println("selected");%>>
			<%=SystemEnv.getHtmlLabelName(82759,user.getLanguage())%></option>
			<option value="2" <%if("2".equals(valueList.get(nameList.indexOf("displaytype")))) out.println("selected");%>>
			<%=SystemEnv.getHtmlLabelName(82760,user.getLanguage())%></option>
		</select>
		</wea:item>
		
		<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(82761,user.getLanguage())%></wea:item>
		<wea:item>	
    	<select name="displaylayout_<%=eid%>" >
			<option value="1" <%if("1".equals(valueList.get(nameList.indexOf("displaylayout")))) out.println("selected");%>>
			1<%=SystemEnv.getHtmlLabelName(82762,user.getLanguage())%></option>
			<option value="2" <%if("2".equals(valueList.get(nameList.indexOf("displaylayout")))) out.println("selected");%>>
			2<%=SystemEnv.getHtmlLabelName(82762,user.getLanguage())%></option>
			<option value="3" <%if("3".equals(valueList.get(nameList.indexOf("displaylayout")))) out.println("selected");%>>
			3<%=SystemEnv.getHtmlLabelName(82762,user.getLanguage())%></option>
		</select>
		</wea:item>
<%
	}
%>
	</wea:group>
</wea:layout>
<script language=javascript>
function change(obj) {
	var temp = obj.checked;
	if(temp) {
		$("#len_ctr").show();
		$("[name=displayName_<%=eid%>]").val("1");
	} else {
		$("#len_ctr").hide();
		$("[name=displayName_<%=eid%>]").val("0");
	}
}

function change1(obj) {
	var temp = obj.checked;
	if(temp) {
		$("[name=displayimag_<%=eid%>]").val("1");
	} else {
		$("[name=displayimag_<%=eid%>]").val("0");
	}

}

function checkNumber(value) {
	if(value == "") {
		$("[name=displayNamelen_<%=eid%>]").val(8);
	} else {
		if(value > 30 || value < 1) {
			$("[name=displayNamelen_<%=eid%>]").val(8);
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129645,user.getLanguage())%>");
		} else {
			$("[name=displayNamelen_<%=eid%>]").val(parseInt(value));
		}
	}
}
</script>
	