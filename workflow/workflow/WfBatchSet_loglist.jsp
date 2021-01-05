<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.workflow.search.WfAdvanceSearchUtil" %>
<jsp:useBean id="rci" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>
<jsp:useBean id="scci" class="weaver.hrm.company.SubCompanyComInfo"></jsp:useBean>
<jsp:useBean id="dci" class="weaver.hrm.company.DepartmentComInfo"></jsp:useBean>
<%
	String titlename = "";
	String createdatefrom = Util.null2String(request.getParameter("createdatefrom"));
	String createdateto = Util.null2String(request.getParameter("createdateto"));
	int creator = Util.getIntValue(request.getParameter("creator"),0);
	String departmentid = Util.null2String(request.getParameter("departmentid"));
	String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="/js/datetime_wev8.js"></script>
		<script language="javascript" src="/js/selectDateTime_wev8.js"></script>
		<script language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
			
			function resizeDialog(_document){
				if(!_document)_document = document;
				
				var zDialog_div_bottom = jQuery(".zDialog_div_bottom:first");
				var zDialog_div_content = jQuery(".zDialog_div_content:first");
				var bottomheight = zDialog_div_bottom.height();
				var paddingBottom = zDialog_div_bottom.css("padding-bottom");
				var paddingTop = zDialog_div_bottom.css("padding-top");
				var headHeight = 0;
				var e8Box = zDialog_div_content.closest(".e8_box");
				if(e8Box.length>0){
					headHeight = e8Box.children(".e8_boxhead").height();
				}
				if(!!paddingBottom && paddingBottom.indexOf("px")>0){
					paddingBottom = paddingBottom.substring(0,paddingBottom.indexOf("px"));
				}
				if(!!paddingTop && paddingTop.indexOf("px")>0){
					paddingTop = paddingTop.substring(0,paddingTop.indexOf("px"));
				}
				if(isNaN(paddingBottom)){
					paddingBottom = 0;
				}else{
					paddingBottom = parseInt(paddingBottom);
				}
				if(isNaN(paddingTop)){
					paddingTop = 0;
				}else{
					paddingTop = parseInt(paddingTop);
				}
				window.setTimeout(function(){
					var bodyheight = jQuery(window).height();//_document.body.offsetHeight;
					alert(bodyheight+","+document.documentMode);
					if(document.documentMode!=5){
						zDialog_div_content.css("height",bodyheight-bottomheight-paddingTop-headHeight-7);
					}else{
						zDialog_div_content.css("height",bodyheight-bottomheight-paddingBottom-paddingTop-headHeight-7);
					}
				},100);
			}
			
			function search(){
				loglist.submit();
			}
			
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			function onClose(){
				if(dialog){
				    dialog.close();
				}else{  
					window.parent.close() ;
				}	
			}
		</script>
	</head>
	<body>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:search(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
		 %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form id="loglist" name="loglist" method="post" action="/workflow/workflow/WfBatchSet_loglist.jsp">
		<div class="zDialog_div_content">
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		    			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="search(this)">
						<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
					</td>
				</tr>
			</table> 
			<wea:layout type="4Col">
				<wea:group context="<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage()) %>">
					<wea:item><%=SystemEnv.getHtmlLabelName(17482,user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser viewType="0" name="creator" browserValue='<%=""+creator %>' 
				          browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" 
				          hasInput="true"  width="150px" isSingle="true" hasBrowser = "true" 
				          isMustInput='1' completeUrl="/data.jsp"  browserSpanValue='<%=rci.getLastname(""+creator) %>'> 
						</brow:browser> 
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelNames("83,31131",user.getLanguage())%></wea:item>
					<wea:item>
			    		<span class="wuiDateSpan" selectId="createdateselect" selectValue="">
							<input class="wuiDateSel" type="hidden" name="createdatefrom" value="<%=createdatefrom%>">
							<input class="wuiDateSel" type="hidden" name="createdateto" value="<%=createdateto%>">
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(33553,user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser viewType="0" name="subcompanyid" browserValue="<%=subcompanyid %>" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=164" width="80%" browserSpanValue="<%=scci.getSubCompanyname(subcompanyid) %>"> </brow:browser>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(126029,user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser viewType="0" name="departmentid" browserValue="<%=departmentid %>" browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=" hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp?type=4" width="80%" browserSpanValue="<%=dci.getDepartmentName(departmentid) %>"> </brow:browser>
					</wea:item>
				</wea:group>
				<wea:group context="列表" attributes="{'samePair':'listgroup'}">
					<wea:item attributes="{'colspan':'4','id':'_itemtable','isTableList':'true'}">
						<%
							String sqlWhere = " where a.wfid = b.id ";
							WfAdvanceSearchUtil wfsearchUtil = new WfAdvanceSearchUtil(request,new RecordSet());
							sqlWhere += wfsearchUtil.handCreateDateCondition("a.createdate");
							
							if(creator > 0){
							    sqlWhere += " and a.creator = " + creator;
							}
							
							if(!"".equals(departmentid) ||  !"".equals(subcompanyid)){
								sqlWhere += " and exists (select 1 from hrmresource c where c.id = a.creator ";							    
							    if(!"".equals(departmentid)) {
							        sqlWhere += " and c.departmentid = " + departmentid;
							    }
							    
							    if(!"".equals(subcompanyid)){
							        sqlWhere += " and c.subcompanyid1 = " + subcompanyid;
							    }
							    
							    //虚拟部门 分部
							    sqlWhere += "union all select 1 from hrmresourcevirtualview d where d.id = a.creator ";
							    if(!"".equals(departmentid)) {
							        sqlWhere += " and d.departmentid = " + departmentid;
							    }
							    
							    if(!"".equals(subcompanyid)){
							        sqlWhere += " and d.subcompanyid1 = " + subcompanyid;
							    }
							    
							    sqlWhere += ") ";
							}
							
							String tableString = "";
							String backfields = " createdate||' '||createtime as createdt,creator,wfid,operateobj,ip,b.workflowname ";
							String fromSql = " workflow_batch_operate_log a,workflow_base b ";
							String orderby = " createdate,createtime ";
							tableString =   " <table instanceid=\"workflow_wfbatchsetloglist\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WFBATCHSET_LOGLIST,user.getUID())+"\" >"+
								            "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"wfid\"   sqlsortway=\"ASC\" />"+
								            "       <head>"+
								            "           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(31131,user.getLanguage())+"\" column=\"createdt\"  orderkey=\"createdate,createtime\"  />"+
								            "           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(17482,user.getLanguage())+"\" column=\"creator\" orderkey=\"creator\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getLastname\"/>"+
								            "           <col width=\"18%\"  text=\""+SystemEnv.getHtmlLabelNames("126032,30046",user.getLanguage())+"\" column=\"workflowname\" orderkey=\"wfid\" />"+
								            "			<col width=\"18%\"  text=\""+SystemEnv.getHtmlLabelName(106,user.getLanguage())+"\" column=\"operateobj\" orderkey=\"operateobj\" />"+
								            "			<col width=\"18%\"  text=\""+SystemEnv.getHtmlLabelName(17484,user.getLanguage())+"\" column=\"ip\" orderkey=\"fielddbtype\" />"+
								            "       </head>"+
								            " </table>";
						%>
						<TABLE width="100%" cellspacing=0>
						    <tr>
						        <td valign="top">  
						            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
						        </td>
						    </tr>
						</TABLE>	
			            <input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.WF_WFBATCHSET_LOGLIST%>"/>
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
		</form>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="padding:0 !important;">
			<div style="padding:5px 0px;">
				<wea:layout needImportDefaultJsAndCss="true">
					<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
						<wea:item type="toolbar">
				    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
						</wea:item>
					</wea:group>
				</wea:layout>
			</div>
		</div>
	</body>
</html>