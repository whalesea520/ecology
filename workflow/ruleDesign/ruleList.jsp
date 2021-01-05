<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="DocNewsComInfo" class="weaver.docs.news.DocNewsComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
	function onBtnSearchClick(){
		jQuery("#frmmain").submit();
	}
	
	jQuery(document).ready(function(){
	});
	
	
	var dialog = null;
	function closeDialog(){
		if(dialog)
			dialog.close();
	}
	function openRuleDesin(id,rulesrc){
		dialog = new window.top.Dialog();
		dialog.currentWindow = window; 
		var url = "/formmode/interfaces/showconditionContent.jsp?rulesrc=3&ruleid=" + id;
		if(rulesrc==="3") url+="&newrule=1";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(33716,user.getLanguage())%>";
		dialog.Width = 900;
		dialog.Height = 500;
		dialog.maxiumnable = true;
		dialog.DefaultMax=false;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
	}
	function editRuleInfo(id) {
	    if (!!window.top.Dialog) {
		   dialog = new window.top.Dialog();
		} else {
		   dialog = new Dialog();
		}
		dialog.currentWindow = window;
		dialog.Width = 500;
		dialog.Height = 290;
		dialog.Modal = true;
		dialog.isIframe=false;
		if (!!!id) {
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(579,user.getLanguage())%>"; 
		} else {
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(19827,user.getLanguage())+SystemEnv.getHtmlLabelName(579,user.getLanguage())%>";
		}
		dialog.URL = "/workflow/ruleDesign/addRule.jsp?date=" + new Date().getTime() + "&ruleid=" + id+"&src=rename";
		dialog.show();
	}
	
	function openRuleMapping(id) {
		if (!!window.top.Dialog) {
		   dialog = new window.top.Dialog();
		} else {
		   dialog = new Dialog();
		}
		dialog.currentWindow = window;
		dialog.Width = 900;
		dialog.Height = 500;
		dialog.Modal = true;
		dialog.isIframe=false;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(33364,user.getLanguage())%>"; 
		
		dialog.URL = "/workflow/ruleDesign/viewRuleMapContent.jsp?date=" + new Date().getTime() + "&ruleid=" + id;
		dialog.show();
	}
	
	function delRule(id) {
		var confirmContent = "<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>?";
    	window.top.Dialog.confirm(confirmContent, function (){
    		$("#ruleid").val(id);
    		$("#frmmain")[0].action = "/workflow/ruleDesign/ruleDelete.jsp";
    		$("#frmmain")[0].submit();
		}, function () {
		});
	}
function batchDelRule(){
	var typeids = "";
	$("input[name='chkInTableTag']").each(function(){
		if($(this).attr("checked"))			
			typeids = typeids +$(this).attr("checkboxId")+",";
	});
	if(typeids=="") return ;
	Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
						window.location="/workflow/ruleDesign/ruleDelete.jsp?from=ruleManager&typeids="+typeids;
				}, function () {}, 320, 90,false);
}	

	
</script> 
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(70,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(68,user.getLanguage());
String needfav ="1";
String needhelp ="";
String rulename = Util.null2String(request.getParameter("rulename"));
//String depid = Util.null2String(request.getParameter("depid"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if(HrmUserVarify.checkUserRight("DocFrontpageAdd:add", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:editRuleInfo()',_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName( 32136 ,user.getLanguage())+",javascript:batchDelRule()',_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
}

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form action="/workflow/ruleDesign/ruleList.jsp" name="frmmain" id="frmmain">
	<input type="hidden" name="ruleid" id="ruleid" value=""/>
	<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.WF_RULEDESIGN_RULELIST %>"/>
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">			
				<input type="button" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" onclick="javascript:editRuleInfo()"/>				
				<input type="button" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" onclick="batchDelRule()" >
				<input type="text" class="searchInput" name="rulename" value="<%= rulename %>"/>
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
</form>
	<%
		//设置好搜索条件				
		String sqlWhere = "1=1 and linkid>=-1 and rulesrc=3";
		if(!rulename.equals("")){
			sqlWhere += " and rulename like '%"+rulename+"%'";
		}
		String backfields = " id,rulesrc,formid,linkid,rulename,ruledesc,condit ";
		String sqlfrom = " rule_base ";
		String operateString= "<operates width=\"20%\">";
	 	       operateString+=" <popedom otherpara=\"column:rulesrc\" transmethod=\"weaver.workflow.ruleDesign.RuleBusiness.getNewsOperate\"></popedom> ";
	 	       operateString+="     <operate href=\"javascript:editRuleInfo();\" text=\""+SystemEnv.getHtmlLabelName(19827,user.getLanguage())+"\" index=\"0\"/>";
	 	       operateString+="     <operate href=\"javascript:openRuleDesin()\" otherpara=\"column:rulesrc\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(579,user.getLanguage())+"\" index=\"1\"/>";
	 	       operateString+="     <operate href=\"javascript:delRule();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" index=\"2\"/>";
	 	       operateString+="     <operate href=\"javascript:openRuleMapping();\" text=\""+SystemEnv.getHtmlLabelName(33364,user.getLanguage())+"\" index=\"3\"/>";
	 	       operateString+="</operates>";
				
		String tableString=""+
			"<table  pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_RULEDESIGN_RULELIST,user.getUID())+"\" tabletype=\"checkbox\">"+
			" <checkboxpopedom  showmethod=\"weaver.workflow.ruleDesign.RuleBusiness.getRuleCheckbox\" id=\"checkbox\"  popedompara=\"column:id+column:rulesrc\" />"+
			"<sql backfields=\""+backfields+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlform=\"" + sqlfrom + "\" sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
			operateString+
			"<head>";
			tableString += "<col width=\"10%\" text=\"id\" column=\"id\"  orderkey=\"id\" />";
			tableString += "<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(19829,user.getLanguage())+"\" column=\"rulename\"  orderkey=\"rulename\" />";
			tableString += "<col width=\"60%\" text=\""+SystemEnv.getHtmlLabelName(19496,user.getLanguage())+"\" column=\"condit\" />";
			tableString +=	 
			"</head>"+
			"</table>";      
	%>
			<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/> 
 
 </BODY></HTML>
