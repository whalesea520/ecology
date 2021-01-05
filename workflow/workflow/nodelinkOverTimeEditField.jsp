<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browser" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
	String id = Util.null2String(request.getParameter("id")).trim();

	int workflowid = 0;
	int CustomWorkflowid = 0;
	rs.executeSql("select * from workflow_nodelinkOverTime where id=" + id);
	if(rs.next()) {
		workflowid = Util.getIntValue(Util.null2String(rs.getString("workflowid")), 0);
		CustomWorkflowid = Util.getIntValue(rs.getString("CustomWorkflowid"), 0);
	}
	
	int formid = 0;
    String isbill = "";
    int formid_cus = 0;
    String isbill_cus = "";
    rs.executeSql("select * from workflow_base where id in (" + workflowid + ", " + CustomWorkflowid + ")");
    while(rs.next()) {
    	int wfid = Util.getIntValue(Util.null2String(rs.getString("id")), 0);
    	if(wfid == workflowid) {
	    	formid = Util.getIntValue(Util.null2String(rs.getString("formid")), 0);
	    	isbill = Util.null2String(rs.getString("isbill"));
    	}
    	if(wfid == CustomWorkflowid) {
    		formid_cus = Util.getIntValue(Util.null2String(rs.getString("formid")), 0);
    		isbill_cus = Util.null2String(rs.getString("isbill"));
    	}
    }
	
	HashMap otFieldMap = new HashMap();
	rs.executeSql("select * from workflow_nodelinkOTField where overTimeId=" + id);
	while(rs.next()) {
		int toFieldid = Util.getIntValue(Util.null2String(rs.getString("toFieldId")), 0);
		if(toFieldid != 0) {
			otFieldMap.put(toFieldid,  Util.getIntValue(Util.null2String(rs.getString("fromFieldId")), 0));
		}
	}
	
	ArrayList detailcounts = new ArrayList();
	String _detailcountsql = "select groupid from workflow_formfield where isdetail = '1' and formid=" + formid + " group by groupid order by groupid";
	if("1".equals(isbill)) {
		_detailcountsql = "select tablename from workflow_billdetailtable where billid=" + formid + " order by orderid ";
	}
	rs.executeSql(_detailcountsql);
	while(rs.next()) {
		detailcounts.add(Util.null2String(rs.getString(1)));
	}
	
	HashMap fromFieldNameMap = new HashMap();
	fromFieldNameMap.put(-1, SystemEnv.getHtmlLabelName(84729, user.getLanguage())); // 流程ID
	fromFieldNameMap.put(-2, SystemEnv.getHtmlLabelName(26876, user.getLanguage())); // 流程标题
	fromFieldNameMap.put(-3, SystemEnv.getHtmlLabelName(15534, user.getLanguage())); // 紧急程度
	fromFieldNameMap.put(-4, SystemEnv.getHtmlLabelName(15793, user.getLanguage())); // 提醒人
	fromFieldNameMap.put(-5, SystemEnv.getHtmlLabelName(128686, user.getLanguage())); // 超时人
	fromFieldNameMap.put(-6, SystemEnv.getHtmlLabelName(128687, user.getLanguage())); // 超时节点
	String sql = "";
	if("1".equals(isbill)) {
		sql = "select a.id, b.labelname as fieldlabel, a.viewtype, a.detailtable as groupid from workflow_billfield a, htmllabelinfo b where a.fieldlabel = b.indexid and b.languageid=" + user.getLanguage() + " and a.billid=" + formid;
	}else {
		sql = " select a.fieldid as id, a.fieldlable as fieldlabel, b.isdetail, b.groupid as viewtype from workflow_fieldlable a, workflow_formfield b where a.formid = b.formid and a.fieldid = b.fieldid and a.langurageid=" + user.getLanguage() + " and a.formid=" + formid;
	}
	rs.executeSql(sql);
	while(rs.next()) {
		int fieldId = Util.getIntValue(Util.null2String(rs.getString("id")), 0);
		if(fieldId <= 0) {
			continue;
		}
		String fieldlabel = Util.null2String(rs.getString("fieldlabel"));
		int viewtype = Util.getIntValue(Util.null2String(rs.getString("viewtype")), 0);
		if(viewtype != 0) {
			String groupid = Util.null2String(rs.getString("groupid"));
			fieldlabel += "(" + SystemEnv.getHtmlLabelName(17463, user.getLanguage()) + (detailcounts.indexOf(groupid) + 1) + ")";
		}
		fromFieldNameMap.put(fieldId, fieldlabel);
	}
	
	String titlename = "";
%>
<html>
<head>
<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
<script language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ", javascript:doSave(), _self}";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
	<jsp:param name="mouldID" value="workflow" />
	<jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(21845, user.getLanguage()) %>" />
</jsp:include>
<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" onclick="doSave()" />
				<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<form name="overTimeFieldSetForm" id="overTimeFieldSetForm" action="/workflow/workflow/nodelinkOverTimeOperate.jsp" method="post">
		<input type="hidden" name="operate" value="setField" />
		<input type="hidden" name="id" value="<%=id %>" />
		<wea:layout type="2col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%>'>
				<wea:item attributes="{'isTableList':'true'}">
					<TABLE class="ListStyle" cellspacing="1">
						<COLGROUP>
							<COL width="40%">
							<COL width="60%">
						</COLGROUP>
						<TR class=header>
							<TH><%=SystemEnv.getHtmlLabelName(128661, user.getLanguage()) %></TH>
							<TH><%=SystemEnv.getHtmlLabelName(128662, user.getLanguage()) %></TH>
						</TR>
						<TR>
							<TD>
								<%=SystemEnv.getHtmlLabelName(26876, user.getLanguage()) %>
								<input type="hidden" name="toFieldId" value="-1" />
								<input type="hidden" name="toFieldName_-2" value="" />
								<input type="hidden" name="toFieldGroupid_-1" value="-1" />
							</TD>
							<TD>
								<brow:browser name="fromFieldId_-1" viewType="0" hasBrowser="true" hasAdd="false"
									browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/nodelinkOverTimeEditFieldBrowser.jsp?mainOnly=&wfid=" + workflowid %>'
									isMustInput="1" isSingle="true" hasInput="true"
									completeUrl='<%="/data.jsp?type=fieldBrowser&wfid=" + workflowid %>' browserValue="<%=Util.null2String(otFieldMap.get(-1)) %>" browserSpanValue="<%=Util.null2String(fromFieldNameMap.get(Util.getIntValue(Util.null2String(otFieldMap.get(-1)), 0))) %>" />
							</TD>
						</TR>
						<TR>
							<TD>
								<%=SystemEnv.getHtmlLabelName(128667, user.getLanguage()) %>
								<input type="hidden" name="toFieldId" value="-2" />
								<input type="hidden" name="toFieldName_-2" value="" />
								<input type="hidden" name="toFieldGroupid_-2" value="-1" />
							</TD>
							<TD>
								<brow:browser name="fromFieldId_-2" viewType="0" hasBrowser="true" hasAdd="false"
									browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/nodelinkOverTimeEditFieldBrowser.jsp?mainOnly=&wfid=" + workflowid %>'
									isMustInput="1" isSingle="true" hasInput="true"
									completeUrl='<%="/data.jsp?type=fieldBrowser&wfid=" + workflowid %>' browserValue="<%=Util.null2String(otFieldMap.get(-2)) %>" browserSpanValue="<%=Util.null2String(fromFieldNameMap.get(Util.getIntValue(Util.null2String(otFieldMap.get(-2)), 0))) %>" />
							</TD>
						</TR>
						<%
							sql = " select a.fieldid as id, a.fieldlable as fieldlabel, c.fieldname from workflow_fieldlable a, workflow_formfield b, workflow_formdict c where a.formid = b.formid and a.fieldid = b.fieldid and a.fieldid = c.id and (b.isdetail is null or b. isdetail <> '1') and a.isdefault = '1' and a.formid=" + formid_cus + " order by b.fieldorder ";
							if("1".equals(isbill_cus)) {
								sql = "select id, fieldlabel, fieldname from workflow_billfield where (viewtype is null or viewtype <> 1) and billid=" + formid_cus + " order by dsporder ";
							}
							rs.executeSql(sql);
							while(rs.next()){
								int fieldId = Util.getIntValue(Util.null2String(rs.getString("id")), 0);
								if(fieldId <= 0) {
									continue;
								}
								String fieldlabel = Util.null2String(rs.getString("fieldlabel"));
								if("1".equals(isbill_cus)) {
									fieldlabel = SystemEnv.getHtmlLabelName(Util.getIntValue(fieldlabel, 0), user.getLanguage());
								}
						%>
								<TR>
									<TD>
										<%=fieldlabel %>
										<input type="hidden" name="toFieldId" value="<%=fieldId %>" />
										<input type="hidden" name="toFieldName_<%=fieldId %>" value="<%=Util.null2String(rs.getString("fieldname")) %>" />
										<input type="hidden" name="toFieldGroupid_<%=fieldId %>" value="0" />
									</TD>
									<TD>
										<brow:browser name='<%="fromFieldId_" + fieldId %>' viewType="0" hasBrowser="true" hasAdd="false"
											browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/nodelinkOverTimeEditFieldBrowser.jsp?mainOnly=&wfid=" + workflowid %>'
											isMustInput="1" isSingle="true" hasInput="true"
											completeUrl='<%="/data.jsp?type=fieldBrowser&wfid=" + workflowid %>' browserValue="<%=Util.null2String(otFieldMap.get(fieldId)) %>" browserSpanValue="<%=Util.null2String(fromFieldNameMap.get(Util.getIntValue(Util.null2String(otFieldMap.get(fieldId)), 0))) %>" />
									</TD>
								</TR>
						<%	} %>
					</TABLE>
				</wea:item>
		 	</wea:group>
			<%
				int i = 0;
				String detailcountsql = "select groupid from workflow_formfield where isdetail = '1' and formid=" + formid_cus + " group by groupid order by groupid";
				if("1".equals(isbill_cus)) {
					detailcountsql = "select tablename from workflow_billdetailtable where billid=" + formid_cus + " order by orderid ";
				}
				rs.executeSql(detailcountsql);
				while(rs.next()) {
					String groupid = Util.null2String(rs.getString(1));
					i++;
			%>
					<wea:group context='<%=SystemEnv.getHtmlLabelName(17463, user.getLanguage()) + i %>'>
						<wea:item attributes="{'isTableList':'true'}">
							<TABLE class="ListStyle" cellspacing="1">
								<COLGROUP>
									<COL width="40%">
									<COL width="60%">
								</COLGROUP>
								<TR class=header>
									<TH><%=SystemEnv.getHtmlLabelName(128661, user.getLanguage()) %></TH>
									<TH><%=SystemEnv.getHtmlLabelName(128662, user.getLanguage()) %></TH>
								</TR>
								<%
									if("1".equals(isbill_cus)) {
										sql = "select a.id, b.labelname as fieldlabel, fieldname from workflow_billfield a, htmllabelinfo b where a.fieldlabel = b.indexid and a.viewtype = 1 and a.detailtable='" + groupid + "' and b.languageid=" + user.getLanguage() + " and a.billid=" + formid_cus + " order by a.dsporder ";
									}else {
										sql = " select a.fieldid as id, a.fieldlable as fieldlabel, c.fieldname from workflow_fieldlable a, workflow_formfield b, workflow_formdictdetail c where a.formid = b.formid and a.fieldid = b.fieldid and a.fieldid = c.id and b.isdetail = '1' and b.groupid=" + groupid + " and a.langurageid=" + user.getLanguage() + " and a.formid=" + formid_cus + " order by b.fieldorder ";
									}
									rs1.executeSql(sql);
									while(rs1.next()) {
										int fieldId = Util.getIntValue(Util.null2String(rs1.getString("id")), 0);
										if(fieldId <= 0) {
											continue;
										}
										String fieldlabel = Util.null2String(rs1.getString("fieldlabel"));
								%>
										<TR>
											<TD>
												<%=fieldlabel %>
												<input type="hidden" name="toFieldId" value="<%=fieldId %>" />
												<input type="hidden" name="toFieldName_<%=fieldId %>" value="<%=Util.null2String(rs1.getString("fieldname")) %>" />
												<input type="hidden" name="toFieldGroupid_<%=fieldId %>" value="<%=i %>" />
											</TD>
											<TD>
												<brow:browser name='<%="fromFieldId_" + fieldId %>' viewType="0" hasBrowser="true" hasAdd="false"
													browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/nodelinkOverTimeEditFieldBrowser.jsp?wfid=" + workflowid %>'
													isMustInput="1" isSingle="true" hasInput="true"
													completeUrl='<%="/data.jsp?type=fieldBrowser&wfid=" + workflowid %>' browserValue="<%=Util.null2String(otFieldMap.get(fieldId)) %>" browserSpanValue="<%=Util.null2String(fromFieldNameMap.get(Util.getIntValue(Util.null2String(otFieldMap.get(fieldId)), 0))) %>" />
											</TD>
										</TR>
								<%	} %>
							</TABLE>
						</wea:item>
				 	</wea:group>
			<%	} %>
		</wea:layout>
	</form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle" class="zd_btn_cancle" onclick="closeDialog()" />
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</body>
<script type="text/javascript">
jQuery(document).ready(function() {
	resizeDialog(document);
});

function doSave() {
	enableAllmenu();
	overTimeFieldSetForm.submit();
}

function closeDialog() {
	parent.getDialog(window).close();
}
</script>
</html>
