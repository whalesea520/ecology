<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />


<%

	String forbidAttDownload = Util.null2String(request.getParameter("forbidAttDownload"));
	String isneeddelacc = Util.null2String(request.getParameter("isneeddelacc"));
	String candelacc = Util.null2String(request.getParameter("candelacc"));
	String seccategory = Util.null2String(request.getParameter("seccategory"));
	String subcategory = Util.null2String(request.getParameter("subcategory"));
	String maincategory = Util.null2String(request.getParameter("maincategory"));
	String formid = Util.null2String(request.getParameter("formid"));
	String isbill = Util.null2String(request.getParameter("isbill"));
	int selectedCateLog = Util.getIntValue(Util.null2String(request.getParameter("selectedCateLog")));
	int catelogType =Util.getIntValue(Util.null2String(request.getParameter("catelogType")));
	String docPath=Util.null2String(request.getParameter("docPath"));


%>
<wea:layout type="2col">
<%String context5 = "<a name='FUJIAN'>"+ SystemEnv.getHtmlLabelName(23796,user.getLanguage()) +"</a>"; %>
<wea:group context='<%=context5 %>'>
	<wea:item><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(92,user.getLanguage())%></wea:item>
	<wea:item>
		<select class=inputstyle id=catalogtype name=catalogtype onchange="switchCataLogType(this.value)" style="float: left;">
			<option value=0 <%if(catelogType == 0){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(19213,user.getLanguage())%></option>
			<option value=1 <%if(catelogType == 1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(19214,user.getLanguage())%></option>
		</select>&nbsp;
		<%
			String sqlSelectCatalog=null;
			int tempFieldId=0;
			if("1".equals(isbill)){
				sqlSelectCatalog = "select formField.id,fieldLable.labelName as fieldLable "
						+ "from HtmlLabelInfo  fieldLable ,workflow_billfield  formField "
						+ "where fieldLable.indexId=formField.fieldLabel "
						+ "  and formField.billId= " + formid
						+ "  and formField.viewType=0 "
						+ "  and fieldLable.languageid =" + user.getLanguage()
						+ "  and formField.fieldHtmlType = '5' and not exists ( select * from workflow_selectitem where (docCategory is null or docCategory = '') and formField.ID = workflow_selectitem.fieldid and isBill='1' )order by formField.dspOrder";
			}else{
				sqlSelectCatalog = "select formDict.ID, fieldLable.fieldLable "
						+ "from workflow_fieldLable fieldLable, workflow_formField formField, workflow_formdict formDict "
						+ "where fieldLable.formid = formField.formid and fieldLable.fieldid = formField.fieldid and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "
						+ "and formField.formid = " + formid
						+ " and fieldLable.langurageid = " + user.getLanguage()
						+ " and formDict.fieldHtmlType = '5' and not exists ( select * from workflow_selectitem where (docCategory is null or docCategory = '') and formDict.ID = workflow_selectitem.fieldid and isBill='0') order by formField.fieldorder";
			}
		%>
		<select class=inputstyle id=selectcatalog <%if(catelogType == 0){%>style="display:none;float: left;"<%}%> name=selectcatalog>
			<%
				RecordSet.executeSql(sqlSelectCatalog);
				while(RecordSet.next()){
					tempFieldId = RecordSet.getInt("ID");
			%>
			<option value=<%= tempFieldId %> <% if(tempFieldId == selectedCateLog) { %> selected <% } %> ><%= RecordSet.getString("fieldLable") %></option>
			<%}%>
		</select>&nbsp;
		<span id=mypath <%if(catelogType == 1){%>style="display:none"<%}%> >
			<brow:browser name="pathcategory" viewType="0" hasBrowser="true" hasAdd="false"
						  browserOnClick="onShowCatalog('pathcategoryspan')" isMustInput="1" isSingle="true" hasInput="true"
						  completeUrl="/data.jsp?type=categoryBrowser" _callback="onShowCatalogData" width="300px" browserValue='<%=docPath%>' browserSpanValue='<%=docPath%>' />
			</span>
		<input type=hidden id='maincategory' name='maincategory' value="<%=maincategory%>">
		<input type=hidden id='subcategory' name='subcategory' value="<%=subcategory%>">
		<input type=hidden id='seccategory' name='seccategory' value="<%=seccategory%>">
	</wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(22944,user.getLanguage())%></wea:item>
	<wea:item><input type=checkbox name="candelacc" tzCheckbox="true" value="1" <%if(candelacc.equals("1")){%>checked<%}%>></wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(31494,user.getLanguage())%></wea:item>
	<wea:item>
		<input type="checkbox" tzCheckbox="true" <% if(isneeddelacc.equals("1")) {%> checked <%}%> name="isneeddelacc" value="1">
		&nbsp;&nbsp;
		<span class='e8tips' title='<%=SystemEnv.getHtmlLabelName(28572,user.getLanguage()) %>'><img src='/images/tooltip_wev8.png' align='absMiddle'/></span>

	</wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(27025,user.getLanguage())%></wea:item>
	<wea:item><input type=checkbox name="forbidAttDownload" tzCheckbox="true" value="1" <% if(forbidAttDownload.equals("1")) {%> checked <%}%>></wea:item>
</wea:group>
</wea:layout>