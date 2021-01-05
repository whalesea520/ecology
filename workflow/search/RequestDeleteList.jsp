<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.workflow.search.WfAdvanceSearchUtil" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String requestname  = Util.null2String(request.getParameter("requestname"));
	String requestmark  = Util.null2String(request.getParameter("requestmark"));
	String operator  = Util.null2String(request.getParameter("operator"));
	String operatorDepartmentid  = Util.null2String(request.getParameter("operatorDepartmentid"));
	String operatorsubcompanyid  = Util.null2String(request.getParameter("operatorsubcompanyid"));
	String titlename = "";
	
	//判断是否有流程回收站权限
	//1、有“流程回收”权限的用户：列表显示所有被删除的流程
	//2、普通用户：列表显示被自己删除流程
	boolean hasWfRPermissions =  HrmUserVarify.checkUserRight("WorkflowRecycleBin:All", user);
%>
<html>
	<head>
		<link href="/css/Weaver_wev8.css" type=text/css rel="stylesheet">
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="/js/datetime_wev8.js"></script>
		<script language="javascript" src="/js/selectDateTime_wev8.js"></script>
		<script language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/ecology8/request/wFCommonAdvancedSearch_wev8.js"></script>
		
		<script type="text/javascript">
			function onBtnSearchClick(){
				var requestname=$("input[name='requestnameTitle']",parent.document).val();
				$("input[name='requestname']").val(requestname);
				jQuery('#searchform').submit();
			}
			
			jQuery(document).ready(function () {
				jQuery("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
			});
			
			/**
			*清空搜索条件
			*/
			function resetCondtion(selector){
				jQuery('#searchInput',parent.document).val('');
				resetCondition(selector);
			}
			
		</script>
	</head>
	<body>
			<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<%
				RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ",javascript:onBtnSearchClick(),_self}";
				RCMenuHeight += RCMenuHeightStep;
			%>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
			<form id="searchform" name="searchform" method="post" action="RequestDeleteList.jsp">
				<table id="topTitle" cellpadding="0" cellspacing="0">
					<tr>
						<td></td>
						<td class="rightSearchSpan" style="text-align:right;">
							<input type="text" class="searchInput" id="searchInput" name="requestnameTitle" value="<%=requestname %>"/>
							<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
							<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
						</td>
					</tr>
				</table>
				<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
					<wea:layout type="4col">
						<wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
							<wea:item><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></wea:item>
							<wea:item><input type="text" style='width:80%;' id="requestname" name="requestname" class="inputStyle" value="<%=requestname %>"></wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(19502,user.getLanguage())%></wea:item>
							<wea:item><input type="text" style='width:80%;' name="requestmark" class="inputStyle" value="<%=requestmark %>"></wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%></wea:item>
							<wea:item>
								<brow:browser viewType="0" name="operator" browserValue="<%=operator %>" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp" width="80%" browserSpanValue="<%=ResourceComInfo.getLastname(operator) %>"> </brow:browser>
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(21663,user.getLanguage())%></wea:item>
				    	 	<wea:item>
					    		<span class="wuiDateSpan" selectId="createdateselect" selectValue="">
									<input class=wuiDateSel type="hidden" name="createdatefrom" value="<%=Util.null2String(request.getParameter("createdatefrom")) %>">
									<input class=wuiDateSel type="hidden" name="createdateto" value="<%=Util.null2String(request.getParameter("createdateto")) %>">
								</span>
					    	</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(33826,user.getLanguage())%></wea:item>
							<wea:item>
								<brow:browser viewType="0" name="operatorDepartmentid" browserValue="<%=operatorDepartmentid %>" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=4" width="80%" browserSpanValue="<%=DepartmentComInfo.getDepartmentName(operatorDepartmentid) %>"> </brow:browser>
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(33827,user.getLanguage())%></wea:item>
							<wea:item>
								<brow:browser viewType="0" name="operatorsubcompanyid" browserValue="<%=operatorsubcompanyid %>" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=164" width="80%" browserSpanValue="<%=SubCompanyComInfo.getSubCompanyname(operatorsubcompanyid) %>"> </brow:browser> 
							</wea:item>
						</wea:group>
						<wea:group context="">
							<wea:item type="toolbar">
								<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit"/>
								<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
								<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
							</wea:item>
						</wea:group>
					</wea:layout>
				</div>
				<%
					String sqlWhere = " where a.request_id = b.requestid and b.workflowid = c.id  and e.id = b.currentnodeid and a.isold = '0' ";
					if(!"".equals(requestname)){
					    sqlWhere  += " and b.requestname like '%"+requestname+"%'";
					}
					
					if(!"".equals(requestmark)){
					    sqlWhere += " and b.requestmark like '%"+requestmark+"%'";
					}
					
					if(!"".equals(operator)){
					    sqlWhere += " and a.operate_userid = " + operator;
					}
					
					if(!"".equals(operatorDepartmentid)){
					    sqlWhere += " and exists (select 1 from hrmresource h where h.id = a.operate_userid and h.departmentid = "+operatorDepartmentid+")";
					}
					
					if(!"".equals(operatorsubcompanyid)){
					    sqlWhere += " and exists (select 1 from hrmresource f where f.id = a.operate_userid and f.subcompanyid1 ="+operatorsubcompanyid+")";
					}
					
					//无权限的只能查询自己删除的流程
					if(!hasWfRPermissions){
					    sqlWhere  += " and a.operate_userid = " +user.getUID();
					}
		
					WfAdvanceSearchUtil wfsearchUtil = new WfAdvanceSearchUtil(request,new RecordSet());
					sqlWhere += wfsearchUtil.handCreateDateCondition("a.operate_date");
					
					String orderby =" a.operate_date,a.operate_time ";
					String backfields = " b.requestid,b.requestname, b.status, e.nodename,c.workflowname,b.requestmark,a.operate_userid,a.client_address ";
					if(rs.getDBType().equals("oracle")){
					    backfields += ",a.operate_date||' '||a.operate_time as deltime "; 
					}else{
					    backfields += ",a.operate_date+' '+a.operate_time as deltime ";
					}
					String fromSql =" workflow_requestdeletelog a,workflow_requestbase_dellog b,workflow_base c,workflow_nodebase e ";
					//System.out.print("select " +backfields + " from " + fromSql + sqlWhere);
					String tableString = " <table instanceid=\"workflowRequestDeleteListTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_REQUESTDELETELIST,user.getUID())+"\" >"+
									     "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"b.requestid\" sqlsortway=\"DESC\" sqlisdistinct=\"false\" />"+
									     "       <head>"+
									     "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(229,user.getLanguage())+"\"  column=\"requestname\" orderkey=\"requestname\" />"+
									     "           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(125749,user.getLanguage())+"\" column=\"workflowname\" orderkey=\"workflowname\" />"+
									     "           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(19502,user.getLanguage())+"\"  column=\"requestmark\" orderkey=\"requestmark\"  />"+
									     "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(21663,user.getLanguage())+"\"  column=\"deltime\" orderkey=\"operate_date,operate_time\" />"+
									     "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17482,user.getLanguage())+"\"  column=\"operate_userid\" orderkey=\"operate_userid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getLastname\"/>"+
									     "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(129346,user.getLanguage())+"\" column=\"nodename\" />"+
									     "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(129347,user.getLanguage())+"\" column=\"status\" />"+
									     "           <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(33586,user.getLanguage())+"\" column=\"client_address\" />"+
									     "       </head>"+
									     " </table>";
			%>
				<TABLE width="100%" cellspacing=0>
				    <tr>
				        <td valign="top">  
							<wea:SplitPageTag tableString='<%=tableString %>' mode="run" /> 
							<input type="hidden" name="pageId" id="pageId" _showCol="false" value="<%= PageIdConst.WF_REQUESTDELETELIST %>"/>
				        </td>
				    </tr>
				</TABLE>
			</form>
	</body>
</html>
		