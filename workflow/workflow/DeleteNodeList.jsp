<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.workflow.WfRightManager" %>
<%@ page import="weaver.workflow.workflow.UserWFOperateLevel" %>
<%@ page import="weaver.workflow.search.WfAdvanceSearchUtil" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="wfrm" class="weaver.workflow.workflow.WfRightManager" scope="page"></jsp:useBean>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String wfid = Util.null2String(request.getParameter("wfid"));
boolean haspermission = wfrm.hasPermission3(Util.getIntValue(wfid), 0, user, WfRightManager.OPERATION_CREATEDIR);
if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int subCompanyId = Util.getIntValue(Util.null2String(session.getAttribute("managefield_subCompanyId")),-1);
int operatelevel = UserWFOperateLevel.checkUserWfOperateLevel(detachable,subCompanyId,user,haspermission,"WorkflowManage:All");
String titlename = "";

String nodename = Util.null2String(request.getParameter("nodename"));
String nodetype = Util.null2String(request.getParameter("nodetype"));
String nodeattribute = Util.null2String(request.getParameter("nodeattribute"));
String deleteoperator = Util.null2String(request.getParameter("deleteoperator"));
String createdatefrom = Util.null2String(request.getParameter("createdatefrom"));
String createdateto = Util.null2String(request.getParameter("createdateto"));

int status = Util.getIntValue(request.getParameter("status"),-1);

%>
<html>
	<head>
		<link href="/css/Weaver_wev8.css" type=text/css rel="stylesheet">
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="/js/datetime_wev8.js"></script>
		<script language="javascript" src="/js/selectDateTime_wev8.js"></script>
		<script language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script type="text/javascript">
			function onBtnSearchClick(){
				var nodename=$("input[name='nodeTitle']",parent.document).val();
				$("input[name='nodename']").val(nodename);
				window.location="/workflow/workflow/DeleteNodeList.jsp?topage=deleteNodeList&wfid=<%=wfid%>&nodename="+nodename;
			}
			
			jQuery(document).ready(function () {
				jQuery("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
			});
			
			var parentDialog = parent.parent.getDialog(parent);
			var parentWin = parent.parent.getParentWindow(parent);
			
			function onReset() {
				//browser
				jQuery('#advancedSearchDiv .e8_os input[type="hidden"]').each(function() {
					_writeBackData(jQuery(this).attr('name'), 1, {id:'',name:''});
				});
				//input
				jQuery('#advancedSearchDiv input[type!=button]').val('');
				//select
				jQuery('#advancedSearchDiv select').each(function() {
					setSelectBoxValue(this);
				});
				
				jQuery("#searchInput",parent.document).val("");
			}
			
			
			function setSelectBoxValue(selector, value) {
				if (value == null) {
					value = jQuery(selector).find('option').first().val();
				}
				jQuery(selector).selectbox('change',value,jQuery(selector).find('option[value="'+value+'"]').text());
			}
			
			function reductionnode(nodeid,newnodename,newnodetype){
				jQuery('#saveform input[name=nodeid]').val(nodeid);
				jQuery('#saveform input[name=nodename]').val(newnodename);
				jQuery('#saveform input[name=nodetype]').val(newnodetype);
				saveform.submit();
			}
			
			function checkNodeNameAndnodeType(nodeid,nodename){
				jQuery.ajax({
					type:'post',
					url:'/workflow/workflow/nodereduction.jsp?_'+new Date().getTime()+"=1",
					data:{
						nodeid:nodeid,
						wfid:'<%=wfid%>',
						nodename:nodename,
						src:'check'
					},
					error:function (XMLHttpRequest, textStatus, errorThrown) {
						onBtnSearchClick();
					} , 
				    success:function (data, textStatus) {
				    	var result = jQuery.parseJSON(data);
				    	if(result.status === "0"){
				    		opennodenameresetdialog(0,nodeid,nodename);
			    		}
			    		if(result.status === "1"){
			    			opennodenameresetdialog(1,nodeid,nodename);
			    		}	
				    	
				    	if(result.status === "2"){
				    		reductionnode(nodeid,nodename);
				    	}
				    }
				});
			}
			
			function opennodenameresetdialog(status,nodeid,nodename){
				var dialogtemp_01 = new window.top.Dialog();
				dialogtemp_01.currentWindow = window;
				dialogtemp_01.Width = 300;
				dialogtemp_01.Height = 150;
				dialogtemp_01.Modal = true;
				dialogtemp_01.Title = "<%=SystemEnv.getHtmlLabelName(24960,user.getLanguage())%>"; 
				dialogtemp_01.URL = "/workflow/workflow/wfnodereset.jsp?nodeid="+nodeid+"&nodename="+nodename+"&status="+status+"&date=" + new Date().getTime();
				dialogtemp_01.show();
			}
			
			if(<%=status%> == 2){
				jQuery('#tab002',parentWin.document).trigger('click');
			}
		</script>
	</head>
	<body>
		<div class="zDialog_div_content">
			<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
			<form id="searchfrm" name="searchfrm" method="post" action="DeleteNodeList.jsp">
				<input type="hidden" name="wfid" value="<%=wfid %>">
				<table id="topTitle" cellpadding="0" cellspacing="0">
					<tr>
						<td></td>
						<td class="rightSearchSpan" style="text-align:right;">
							<input type="text" class="searchInput" id="searchInput" name="nodeTitle" value="<%=nodename %>"/>
							<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
							<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
						</td>
					</tr>
				</table>
				<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
					<wea:layout type="4col">
						<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
							<wea:item><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></wea:item>
							<wea:item><input type="text" style='width:80%;' id="nodename" name="nodename" class="inputStyle" value="<%=nodename %>"></wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelNames("125426,31131",user.getLanguage())%></wea:item>
				    	 	<wea:item >
					    		<span class="wuiDateSpan" selectId="createdateselect" selectValue="">
									<input class=wuiDateSel type="hidden" name="createdatefrom" value="<%=createdatefrom%>">
									<input class=wuiDateSel type="hidden" name="createdateto" value="<%=createdateto%>">
								</span>
					    	</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(15536,user.getLanguage())%></wea:item>
							<wea:item>
								<span>
									<select class=inputstyle  name="nodetype">
										<option value=""><strong><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></strong></option>
									    <option value="0" <%if(nodetype.equals("0")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></strong></option>
									    <option value="1" <%if(nodetype.equals("1")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></strong></option>
									    <option value="2" <%if(nodetype.equals("2")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></strong></option>
									    <option value="3" <%if(nodetype.equals("3")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></strong></option>
									</select>
								</span>
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(21393,user.getLanguage())%></wea:item>
							<wea:item>
								<span>
									<select class=inputstyle  name="nodeattribute" onchange="changeattri(this)">
										<option value=""><strong><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></strong></option>
									    <option value="0" <%if(nodeattribute.equals("0")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></strong></option>
									    <option value="1" <%if(nodeattribute.equals("1")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(21394,user.getLanguage())%></strong></option>
									    <option value="2" <%if(nodeattribute.equals("2")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(21395,user.getLanguage())%></strong></option>
									    <option value="3" <%if(nodeattribute.equals("3")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(21396,user.getLanguage())%></strong></option>
									    <option value="4" <%if(nodeattribute.equals("4")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(21397,user.getLanguage())%></strong></option>
									    <option value="5" <%if(nodeattribute.equals("5")){%> selected <%}%>><strong><%=SystemEnv.getHtmlLabelName(126603,user.getLanguage())%></strong></option>
									</select>
								</span>
							</wea:item>
							<wea:item><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%></wea:item>
							<wea:item>
								<span>
									<brow:browser viewType="0" 
												  name="deleteoperator" 
												  browserValue='<%=deleteoperator %>' 
												  browserOnClick="" 
												  browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" 
												  hasInput="true"  
												  width="80%" 
												  isSingle="true" 
												  hasBrowser = "true" 
												  isMustInput='1' 
												  completeUrl="/data.jsp"  
												  browserSpanValue='<%=ResourceComInfo.getLastname(deleteoperator) %>'> 
							   		</brow:browser>
							   	</span> 
							</wea:item>
						</wea:group>
						<wea:group context="">
							<wea:item type="toolbar">
								<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="jQuery('#searchfrm').submit();"/>
								<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="onReset();"/>
								<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
							</wea:item>
						</wea:group>
					</wea:layout>
				</div>
			
			<%
				String sqlWhere = "where a.workflowid = " + wfid;
				if(!"".equals(nodename)){
				    sqlWhere += " and b.nodename like '%"+nodename+"%'";
				}
	
				if(!"".equals(nodetype)){
				    sqlWhere += " and a.nodetype = "+nodetype;
				}
	
				if(!"".equals(nodeattribute)){
				    sqlWhere += " and b.nodeattribute = "+nodeattribute;
				}
	
				if(!"".equals(deleteoperator)){
				    sqlWhere += " and a.deleteoperator = " + deleteoperator;
				}
	
				WfAdvanceSearchUtil wfsearchUtil = new WfAdvanceSearchUtil(request,new RecordSet());
				sqlWhere += wfsearchUtil.handCreateDateCondition("a.deletedate");
				String orderby =" a.deletedate desc,a.deletetime desc ";
				String backfields = " b.nodename,a.nodetype,b.nodeattribute,a.deleteoperator,a.nodeid,a.workflowid";
				if(rs.getDBType().equals("oracle")){
				    backfields += ",a.deletedate||' '||a.deletetime as deltime "; 
				}else{
				    backfields += ",a.deletedate+' '+a.deletetime as deltime ";
				}
				String fromSql =" workflow_flownode_dellog a left join workflow_nodebase b on a.nodeid = b.id ";
				String tableString = " <table instanceid=\"workflowDeleteNodeListTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_DELETENODELIST,user.getUID())+"\" >"+
								     "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.nodeid\" sqlsortway=\"ASC\" sqlisdistinct=\"false\" />"+
								     "       <head>"+
								     "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15070,user.getLanguage())+"\"  column=\"nodename\" orderkey=\"nodename\" />"+
								     "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(127003,user.getLanguage())+"\" column=\"deltime\" orderkey=\"deletedate,deletetime\" />"+
								     "           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(15536,user.getLanguage())+"\"  column=\"nodetype\" orderkey=\"nodetype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.workflow.workflow.WFNodeTransMethod.getNodetype\" />"+
								     "           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(21393,user.getLanguage())+"\"  column=\"nodeattribute\" orderkey=\"nodeattribute\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.workflow.workflow.WFNodeTransMethod.getNodeAttributeName\"/>"+
								     "           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(17482,user.getLanguage())+"\"  column=\"deleteoperator\" orderkey=\"deleteoperator\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getLastname\"/>"+
								     "           <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(126032,user.getLanguage())+"\" column=\"nodeid\" otherpara=\"column:workflowid+"+operatelevel+"+"+user.getLanguage()+"+column:nodename\" transmethod=\"weaver.workflow.workflow.WFNodeTransMethod.getNodeReductionBtn\"/>"+
								     "       </head>"+
								     " </table>";
			%>
			<TABLE width="100%" cellspacing=0>
			    <tr>
			        <td valign="top">  
						<wea:SplitPageTag tableString='<%=tableString%>' mode="run" /> 
						<input type="hidden" name="pageId" id="pageId" _showCol="false" value="<%= PageIdConst.WF_WORKFLOW_DELETENODELIST %>"/>
			        </td>
			    </tr>
			</TABLE>
			</form>
		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
					<wea:item type="toolbar">
				    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentDialog.close()">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
		<form id="saveform" name="saveform" method="post" action="/workflow/workflow/nodereduction.jsp">
			<input type="hidden" name="wfid" value="<%=wfid %>">
			<input type="hidden" name="nodeid" value="">
			<input type="hidden" name="nodename" value="">
			<input type="hidden" name="nodetype" value="">
			<input type="hidden" name="src" value="submit">
		</form>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
	</body>
</html>