
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.ruleDesign.RuleBean"%>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@ include file="/systeminfo/init_wev8.jsp"  %>

<%
List<RuleBean> rules = RuleBusiness.getAllRuleList();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" " http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html><head>
<style type="text/css">

.leftType {
	font-weight:normal!important;
}
</style>

<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>


<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<script type="text/javascript" src="/js/ecology8/request/requestView_wev8.js"></script>
<script type="text/javascript" src="/workflow/ruleDesign/js/ruleView_wev8.js"></script>
		<script type="text/javascript">
			var demoLeftMenus=[
				<%
				for (int i=0; i<rules.size(); i++) {
					RuleBean rb = rules.get(i);
				%>
					{	
						name:"<%=rb.getName() %>",
						attr:{
							ruleid:"<%=rb.getId() %>"
						}
					}
					<%=i < (rules.size() - 1) ? "," : ""  %>
				<%
				}
				%>
			];
		</script>

		<table cellspacing="0" cellpadding="0" class="flowsTable"  >
			<tr>
				<td class="leftTypeSearch">
					<span class="leftType">
					<span><%=SystemEnv.getHtmlLabelName(82857,user.getLanguage())%></span>(<%=rules.size() %>)
					</span>
					<span class="leftSearchSpan">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(83981,user.getLanguage())%>" onclick="newRule()" class="zd_btn_submit"/>
						<!-- 
						&nbsp;<input type="text" class="leftSearchInput" />
						 -->
					</span>
				</td>
				<td rowspan="2">
					<iframe src="" class="flowFrame" frameborder="0" ></iframe>
				</td>
			</tr>
			<tr>
				<td style="width:23%;" class="flowMenusTd">
					<div class="flowMenuDiv"  >
						<!--<div class="flowMenuAll"><span class="allText">全部&nbsp;</span></div>-->
						<div style="overflow:hidden;height:300px;position:relative;" id="overFlowDiv">
							<div class="ulDiv" ></div>
						</div>
					</div>
				</td>
			</tr>
		</table>
	
</body></html>