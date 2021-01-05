<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
	String orderbytype = Util.null2String(request.getParameter("orderbytype"));
	String isSignDoc = Util.null2String(request.getParameter("isSignDoc"));
	String isSignWorkflow = Util.null2String(request.getParameter("isSignWorkflow"));
	String annexsubcategory = Util.null2String(request.getParameter("annexsubcategory"));
	String isannexUpload = Util.null2String(request.getParameter("isannexUpload"));
	String issignview = Util.null2String(request.getParameter("issignview"));
	String annexmaincategory = Util.null2String(request.getParameter("annexmaincategory"));
	String annexseccategory = Util.null2String(request.getParameter("annexseccategory"));
	String annexdocPath = Util.null2String(request.getParameter("annexdocPath"));
%>
<wea:layout type="2col">
<%String context7 = "<a name='QIANZI'>"+SystemEnv.getHtmlLabelName(17614,user.getLanguage())+"</a>"; %>
	<wea:group context='<%=context7%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(81648,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle id=orderbytype name=orderbytype onchange="changeOrderShow()" >
		    	<option value=1 <%if("1".equals(orderbytype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21604,user.getLanguage())%></option>
		    	<option value=2 <%if("2".equals(orderbytype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21605,user.getLanguage())%></option>
		    </select>&nbsp;&nbsp;
			<span class='e8tips' title='
				<%if("2".equals(orderbytype)){%>
				<%=SystemEnv.getHtmlLabelName(21628,user.getLanguage())%>
				<%}else{%>
				<%=SystemEnv.getHtmlLabelName(21629,user.getLanguage())%>
				<%}%>
			'><img src='/images/tooltip_wev8.png' align='absMiddle'/></span>	
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(31500,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=checkbox name="issignview" tzCheckbox="true" value="1" <% if(issignview.equals("1")) {%> checked <%}%>>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(34035,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=checkbox name="isSignDoc" tzCheckbox="true" value="1" <% if("1".equals(isSignDoc)) {%> checked <%}%> onclick="ShowORHidden(this,'isSignDoctr','showDocTab')">
		</wea:item>
		<%
			String isSignDoctr = "{'samePair':'isSignDoctr','display':''}";
			if(!"1".equals(isSignDoc)) isSignDoctr = "{'samePair':'isSignDoctr','display':'none'}";
		 %>

		<wea:item><%=SystemEnv.getHtmlLabelName(34034,user.getLanguage())%></wea:item>
		<wea:item>
		<input type=checkbox name="isSignWorkflow" tzCheckbox="true" value="1" <% if("1".equals(isSignWorkflow)) {%> checked <%}%> onclick="ShowORHidden(this,'isSignWorkflowtr','showWorkflowTab')">
		</wea:item>
		<%
		String isSignWorkflowtr = "{'samePair':'isSignWorkflowtr','display':''}";
		if(!"1".equals(isSignWorkflow)) isSignWorkflowtr = "{'samePair':'isSignWorkflowtr','display':'none'}";
		%>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(34036,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=checkbox name="isannexUpload" tzCheckbox="true" value="1" <% if("1".equals(isannexUpload)) {%> checked <%}%> onclick="ShowORHidden(this,'annxtCategorytr,showuploadtabtr','showUploadTab')">
		</wea:item>
		<%
			String 	annxtCategorytr = "{'samePair':'annxtCategorytr','display':''}";
			if(!"1".equals(isannexUpload)) annxtCategorytr = "{'samePair':'annxtCategorytr','display':'none'}";
		%>
		<wea:item attributes='<%=annxtCategorytr %>'><%=SystemEnv.getHtmlLabelName(21418,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=annxtCategorytr %>'>
			<brow:browser name="annexseccategory" viewType="0" hasBrowser="true" hasAdd="false" 
			              browserOnClick="onShowAnnexCatalog('annexseccategoryspan')" isMustInput="1" isSingle="true" hasInput="true"
			              completeUrl="/data.jsp?type=categoryBrowser" _callback="annexseccategoryData" width="300px" browserValue='<%=annexseccategory%>' browserSpanValue='<%=annexdocPath%>' />    
			<input type=hidden id='annexmaincategory' name='annexmaincategory' value="<%=annexmaincategory%>">
			<input type=hidden id='annexsubcategory' name='annexsubcategory' value="<%=annexsubcategory%>">		
		</wea:item>
		<%
			String showuploadtabtr = "{'samePair':'showuploadtabtr','display':''}";
			if(!"1".equals(isannexUpload)) showuploadtabtr = "{'samePair':'showuploadtabtr','display':'none'}";
		%>
	</wea:group>
</wea:layout>