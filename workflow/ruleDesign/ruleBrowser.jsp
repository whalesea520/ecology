<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@page import="weaver.workflow.ruleDesign.RuleBean"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>

<%
String rulename = Util.null2String(request.getParameter("rulename"));
%>
<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
	<jsp:param name="mouldID" value="workflow"/>
	<jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(33251,user.getLanguage())+SystemEnv.getHtmlLabelName(579,user.getLanguage()) %>"/>
</jsp:include>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:searchrule(),_top} " ;
    RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div id="container">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>" onclick="searchrule()" class="e8_btn_top" id="btnok1">
	       	<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 
<div class="zDialog_div_content">
<form action="ruleBrowser.jsp" name="weaver" id="weaver" method="post">
<!-- 
<input type="hidden" name="pageId" id="pageId" _showCol="false" value="<%=PageIdConst.WF_RULEFIELD_LIST%>"/>
 -->
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage()) %>'>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(19829,user.getLanguage()) %>
		</wea:item>
		<wea:item>
			<input type="text" name="rulename" id="rulename" value="<%=rulename%>">
		</wea:item>
	</wea:group>
</wea:layout>
</form>
<%
	

	//设置好搜索条件				
	String sqlWhere = " rulesrc=3 ";
	if(!rulename.equals(""))sqlWhere+=" and rulename like '%"+rulename+"%'";
	String sqlfields = " id,rulename,condit ";
	String sqlfrom = " rule_base ";
	String sqlorderby = " id ";
	
	String tableString=""+
		   "<table tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_RULEFIELD_LIST,user.getUID())+"\">"+
		   "<sql backfields=\"" + sqlfields + "\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlform=\"" + sqlfrom + "\" sqlorderby=\"" + sqlorderby + "\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
		   
		   "<head>";
		   		tableString += "<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(19829,user.getLanguage())+"\" column=\"rulename\" />";
		   		tableString += "<col width=\"60%\" text=\""+SystemEnv.getHtmlLabelName(15364,user.getLanguage())+"\" column=\"condit\" />";
		   		tableString +=	 
		   "</head>"+
		   "</table>";      
  %>
	<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/> 
</div>
</div>
<script language=javascript>
	var dialog = parent.getDialog(window);
	jQuery(document).ready(function(){
  		resizeDialog(document);
	});
</script>
<div id="footer">
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout>
			<wea:group context="" attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" id="zd_btn_submit"  class="zd_btn_submit" onclick="dialog.close()">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close()">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage()) %>" id="zd_btn_clean"  class="zd_btn_cancle" onclick="cleanValue()">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
</div>

<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
<script type="text/javascript">
	jQuery(function(){
		jQuery("#_xTable").bind("click",BrowseTable_onclick);
	});
	
	function BrowseTable_onclick(e){
	   var e=e||event;
	   var target=e.srcElement||e.target;

		if( target.nodeName =="TD"||target.nodeName =="A"  ){
			var pNode = target.parentNode;
			if(pNode.nodeName!="TR"){
				pNode = pNode.parentNode;
			}
			var _id = jQuery(jQuery(target).parents("tr")[0].cells[0]).find("input").val();
			var _name = jQuery(jQuery(target).parents("tr")[0].cells[1]).html();
			var _condit = jQuery(jQuery(target).parents("tr")[0].cells[2]).html();
			var returnjson = {id:_id,name:_name,condit:_condit};
			if(dialog){
				dialog.callback(returnjson);
			}else
			{
				window.parent.returnValue = returnjson;
			  	window.parent.close();
			}
		}
	}
	
	function cleanValue()
	{
		var returnjson = {id:"",name:"",condit:""};
		if(dialog){
			dialog.callback(returnjson);
		}else
		{
			window.parent.returnValue = returnjson;
		  	window.parent.close();
		}
	}
	
	function searchrule()
	{
		weaver.submit();
	}
</script>

</BODY></HTML>

