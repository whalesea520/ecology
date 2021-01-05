
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/browserTag" prefix="brow" %>
<%@ page import="weaver.workflow.request.Browsedatadefinition" %>
<%@ page import="weaver.workflow.browserdatadefinition.Condition" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>

<%@ include file="/workflow/workflow/addwf_checktetachable.jsp" %>
<body>
	<%
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(32752,user.getLanguage());
		String needfav = "";
		String needhelp = "";

	    int wfid = Util.getIntValue(Util.null2String(request.getParameter("wfid")), 0);
	    FormFieldTransMethod FormFieldTransMethod = new FormFieldTransMethod();
	    int expwfid = Util.getIntValue(Util.null2String(request.getParameter("expwfid")), 0);
	    if (expwfid > 0) {
	    	Browsedatadefinition.importFromOtherWorkflow(String.valueOf(wfid), String.valueOf(expwfid));
	    	Condition.importFromOtherWorkflow(String.valueOf(wfid), String.valueOf(expwfid));
	    }
		boolean hasData = false;
	%>
	<!-- start -->
	<div id="mainDiv">
		<FORM id=frmMain name=frmMain action=Browsedatadefinition.jsp method=post>
			<wea:layout type="4col" attributes="{expandAllGroup:true}">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(32752,user.getLanguage())%>'>
					<wea:item attributes="{'colspan':'full','isTableList':'true'}">

						<input type="hidden" name="src" id="src" value="addrequest">
						<input type="hidden" name="wfid" id="wfid" value="<%=wfid%>">
						<input type="hidden" name="expwfid" id="expwfid" value="">
						<table class="ListStyle" cellspacing="0" style="table-layout: fixed;">
							<col width="25%"> 
							<col width="25%"> 
							<col width="20%"> 
							<col width="30%">
							<thead>
								<tr class="header"> 
								    <th><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></th>
								    <th><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></th>
								    <th><%=SystemEnv.getHtmlLabelName(17997,user.getLanguage())%></th>
								    <th><%=SystemEnv.getHtmlLabelName(32752,user.getLanguage())%></th>
								</tr>
							</thead>
						  	<tbody>
							   <%
					            String sql="SELECT isbill,formid FROM workflow_base WHERE id='"+wfid+"'";
							    rs.executeSql(sql);
							    String isBill="";
							    String formId="";
								if(rs.next()){
									isBill=rs.getString("isbill");
								    formId=rs.getString("formid");
							    }
								Map<String, Condition> conditions = Condition.readTitleMap(String.valueOf(wfid));
							   	if ("0".equals(isBill)) {	
									rs.executeSql("SELECT isdetail,fieldid,(SELECT fieldlable FROM workflow_fieldlable WHERE fieldid=t1.fieldid AND langurageid=7 AND formid = '"+formId+"') AS fieldname FROM workflow_formfield t1 WHERE formid='"+formId+"' AND ((t1.fieldid IN(SELECT id FROM workflow_formdict WHERE t1.fieldid=workflow_formdict.id AND workflow_formdict.fieldhtmltype=3 AND workflow_formdict.type IN("+Condition.getConfigFieldTypes()+")) OR t1.fieldid IN(SELECT id FROM workflow_formdictdetail WHERE id=fieldid AND t1.isdetail=1 AND fieldhtmltype=3 AND type IN("+Condition.getConfigFieldTypes()+")))) ORDER BY groupid,fieldorder,fieldid ASC");
									while (rs.next()) {
										hasData = true;
										String fieldId = Util.null2String(rs.getString("fieldid"));
										String fieldname = Util.null2String(rs.getString("fieldname"));
										String isdetail = Util.null2String(rs.getString("isdetail"));
										String isdetailname = "";
										String viewtype = "0";
										if ("1".equals(isdetail)) {
											isdetailname = SystemEnv.getHtmlLabelName(18021,user.getLanguage());
											viewtype = "1";
										} else {
											isdetailname = SystemEnv.getHtmlLabelName(18020,user.getLanguage());
											viewtype = "0";
										}
										String requestname = "";
										Condition condition = conditions.get(fieldId);
										if (condition != null) {
											requestname = condition.getTitle();
										}
										if (requestname == null || requestname.isEmpty()) {
											requestname = Browsedatadefinition.getRequestbs(String.valueOf(wfid), fieldId);
										}
										String param = "?fieldid="+fieldId+"&type=&wfid="+wfid+"&viewtype="+viewtype+"&isbill=0&formid="+formId;
								   %>
									   <tr>
										    <td><%=fieldname%></td>
										    <td><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%>&nbsp;<%=Browsedatadefinition.getFieldTypeString(String.valueOf(wfid), fieldId, String.valueOf(user.getLanguage())) %></td>
										    <td><%=isdetailname%></td>
										    <td> 
										    	<button class="Browser1" type="button" onclick="javascript:onShowFileConfig('/systeminfo/BrowserMain.jsp?url=/workflow/workflow/RequestBrowserfunction.jsp','<%=param%>');" value="<%=fieldId%>"></button>
												<span><%=requestname%></span>
										    </td>
										</tr>
										<tr class="Spacing" style="height:1px!important;"><td colspan="4" class="paddingLeft18"><div class="intervalDivClass"></div></td></tr>
									<%}
								} else {
									rs.executeSql("SELECT id,fieldlabel,type,detailtable FROM workflow_billfield WHERE billid='"+formId+"' AND (fieldhtmltype=3 AND type IN("+Condition.getConfigFieldTypes()+")) ORDER BY detailtable,dsporder,id ASC");
									while (rs.next()) {
										hasData = true;
										String fieldId = Util.null2String(rs.getString("id"));	
										String fieldlabel = Util.null2String(rs.getString("fieldlabel"));
										String type = Util.null2String(rs.getString("type"));
									    String detailtable = Util.null2String(rs.getString("detailtable"));
									    String typename = "";
									    String mainordetail = "";
									    typename = Browsedatadefinition.getFieldTypeString(type, String.valueOf(user.getLanguage()));
									    String viewtype = "0";
										if ("".equals(detailtable)) {
											mainordetail = SystemEnv.getHtmlLabelName(18020, user.getLanguage());
											viewtype = "0";
										} else {
											mainordetail = SystemEnv.getHtmlLabelName(18021, user.getLanguage());
											viewtype = "1";
										}
										String requestname = "";
										Condition condition = conditions.get(fieldId);
										if (condition != null) {
											requestname = condition.getTitle();
										}
										if (requestname == null || requestname.isEmpty()) {
											requestname = Browsedatadefinition.getRequestbs(String.valueOf(wfid), fieldId);
										}
										String param = "?fieldid="+fieldId+"&type="+type+"&wfid="+wfid+"&viewtype="+viewtype+"&isbill=1&formid="+formId;
										%>				
									   <tr>
									    <td><%=FormFieldTransMethod.getFieldname(fieldlabel,""+7) %></td>
									    <td><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%>&nbsp;<%=typename%></td>
									    <td><%=mainordetail %></td>
									    <td>
											<button class="Browser1" type="button" onclick="javascript:onShowFileConfig('/systeminfo/BrowserMain.jsp?url=/workflow/workflow/RequestBrowserfunction.jsp','<%=param%>');" value="<%=fieldId%>"></button>
											<span><%=requestname%></span>
									    </td>
									</tr>
									<tr class="Spacing" style="height:1px!important;"><td colspan="4" class="paddingLeft18"><div class="intervalDivClass"></div></td></tr>
								<%	}
								   }
						         %>
							</tbody>
					  	</table>
					</wea:item>
				</wea:group>
				</wea:layout>
		</FORM>
	</div>

	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
		if (hasData) {
			RCMenu += "{"+SystemEnv.getHtmlLabelName(129431, user.getLanguage())+",javascript:onShowWorkFlowBase(),_self}";
			RCMenuHeight += RCMenuHeightStep;
		}
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

	<script type="text/javascript">
		function onShowFileConfig(url, param) {
			var browserDialog = new top.Dialog();
			browserDialog.Width = 700;
			browserDialog.Height = 600;
			browserDialog.URL = url + escape(param);
			browserDialog.Title = '<%=SystemEnv.getHtmlLabelName(32752,user.getLanguage())%>';
			browserDialog.checkDataChange = false;
			browserDialog.callback=function(data) {
				browserDialog.close();
				frmMain.submit();
			};
			browserDialog.show();
		}

		function onShowWorkFlowBase() {
			var browserDialog = new top.Dialog();
			browserDialog.Width = 500;
			browserDialog.Height = 600;
			browserDialog.URL = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowserMuti.jsp?wfid=<%=wfid%>";
			browserDialog.Title = '<%=SystemEnv.getHtmlLabelNames("126832,16579",user.getLanguage()) %>';
			browserDialog.checkDataChange = false;
			browserDialog.callback=function(data) {
				browserDialog.close();
				var retValue = data;
				if (retValue != null) {
					if (wuiUtil.getJsonValueByIndex(retValue, 0) != "" ) {
						top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(129432, user.getLanguage())%>（"+wuiUtil.getJsonValueByIndex(retValue, 1)+"）"+<%=SystemEnv.getHtmlLabelNames("18946,33329",user.getLanguage()) %>+"?", function() {
							jQuery('#expwfid').val(wuiUtil.getJsonValueByIndex(retValue, 0));
							frmMain.submit();
						});
					} 
				}
			};
			browserDialog.show();
		}
	</script>
	<!-- end -->
</body>
</html>
