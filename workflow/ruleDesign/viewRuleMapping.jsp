<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@page import="weaver.workflow.ruleDesign.RuleBean"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>

<%
	String ruleid = Util.null2String(request.getParameter("ruleid"));

	RecordSet rs = new RecordSet();
	String navname = "";
	rs.executeSql("select rulename from rule_base where id="+ruleid);
	if(rs.next())
		navname = rs.getString("rulename");
	//System.out.println("navname:"+navname);
	String wfname = Util.null2String(request.getParameter("wfname"));
	String rulesrc = Util.null2String(request.getParameter("rulesrc"));
	String method = Util.null2String(request.getParameter("method"));
	if(method.equals("onDelMap"))
	{
		//System.out.println(request.getParameter("mapid"));
		int mapid = 0;
		mapid = Util.getIntValue(request.getParameter("mapid"),0);
		RuleBusiness.deleteRuleMapping(mapid);
	}else if(method.equals("onDelMaps"))
	{
		String mapids = Util.null2String(request.getParameter("mapid"));
		mapids = mapids.substring(0,mapids.length()-1);
		String[] tempids = Util.TokenizerString2(mapids, ",");
		for(String tempid : tempids){
			RuleBusiness.deleteRuleMapping(Util.getIntValue(tempid));
		}
	}
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:searchrule(),_top} " ;
    RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div id="container">
<form action="/workflow/ruleDesign/viewRuleMapping.jsp" name="frmmain" id="frmmain">
<input type="hidden" name="method" >
<input type="hidden" name="mapid" >
<input type="hidden" name="ruleid" value="<%=ruleid %>" >
<input type="hidden" name="rulesrc" value="<%=rulesrc %>">
<input type="hidden" name="pageId" id="pageId" _showCol="false" value="WF:VIEWRULEMAPPINGLIST"/>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" onclick="javascript:delmappings()"/>
			<input type="text" class="searchInput" name="wfname" value="<%= wfname %>"/>
	       	<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 
</form>
<%
	//设置好搜索条件				
	String sqlWhere = " t1.wfid=t2.id and t1.rulesrc<>3 and t1.nm=1 and t1.rowidenty=0 and t1.ruleid="+ruleid;
	if(!rulesrc.equals(""))
		sqlWhere += " and t1.rulesrc in ("+rulesrc + ") ";
	if(!wfname.equals(""))
		sqlWhere +=" and t2.workflowname like '%"+wfname+"%' ";
	String sqlfields = " t1.id,t1.wfid,t1.linkid,t1.ruleid,t1.rulesrc,t1.nm, t1.detailid ";
	String sqlfrom = " rule_maplist t1,workflow_base t2 ";
	String sqlorderby = " t1.id ";
	String operateString= "<operates width=\"20%\">";
		operateString+=" <popedom  transmethod=\"weaver.workflow.ruleDesign.RuleBusiness.getRuleMappingOperate\"></popedom> ";
		operateString+="     <operate href=\"javascript:editmapping();\" otherpara=\"column:linkid+column:wfid+column:rulesrc+column:detailid\" text=\""+SystemEnv.getHtmlLabelName(33881,user.getLanguage())+"\" index=\"0\" />";
     	operateString+="     <operate href=\"javascript:delmapping();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" index=\"0\" />";
     	operateString+="</operates>";
	String tableString=""+
		   "<table  instanceid=\"workflowRequestListTable\" pageId=\"WF:VIEWRULEMAPPINGLIST\" tabletype=\"checkbox\" pagesize=\"10\">"+
		   
		   "<sql backfields=\"" + sqlfields + "\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlform=\"" + sqlfrom + "\" sqlorderby=\"" + sqlorderby + "\"  sqlprimarykey=\"t1.id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
		   operateString+
		   "<head>";
		   		tableString += "<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(81651,user.getLanguage())+"\" column=\"wfid\"  transmethod=\"weaver.workflow.ruleDesign.RuleBusiness.getwfname\"/>";
		   		tableString += "<col width=\"60%\" text=\""+ SystemEnv.getHtmlLabelName(33806,user.getLanguage())+"\" column=\"wfid\"  transmethod=\"weaver.workflow.ruleDesign.RuleBusiness.getwftypename\"/>";
		   		tableString += "<col width=\"60%\" text=\""+SystemEnv.getHtmlLabelName(31932,user.getLanguage())+"\" column=\"id\" otherpara=\"column:linkid+column:wfid+column:rulesrc+"+user.getLanguage()+"\" transmethod=\"weaver.workflow.ruleDesign.RuleBusiness.getquoteposition\" />";
		   		tableString +=	 
		   "</head>"+
		   "</table>";      
  %>
	<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/> 
</div>
<script language=javascript>
	var dialog = parent.parent.getDialog(parent);
	$(document).ready(function(){
  		resizeDialog(document);
  		settitle();
	});
	function settitle()
	{
		var navname = "<%=navname%>";
		
		parent.setTabObjName(navname);
	}
	function delmapping(id)
	{
		var confirmContent = "<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>?";
    	window.top.Dialog.confirm(confirmContent, function (){
    		$("[name=method]").val("onDelMap");
    		$("[name=mapid]").val(id);
    		$("#frmmain")[0].submit();
		}, function () {
		});
	}
	
	function delmappings()
	{
		var typeids = "";
		$("input[name='chkInTableTag']").each(function(){
			if($(this).attr("checked"))			
				typeids = typeids +$(this).attr("checkboxId")+",";
		});
		if(typeids=="") return ;
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
			$("[name=method]").val("onDelMaps");
    		$("[name=mapid]").val(typeids);
    		$("#frmmain")[0].submit();
		}, function () {});
	}
	function editmapping(mapid,params)
	{
	   var paramarray = params.split("+");
		var linkid=paramarray[0];
		var wfid = paramarray[1];
		var rulesrc = paramarray[2];
		var detailid = paramarray[3];
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/workflow/ruleDesign/ruleMapping.jsp?rulesrc="+rulesrc+"&ruleid=<%=ruleid%>&mapid="+mapid+"&linkid="+linkid+"&wfid="+wfid + "&detailid=" + detailid;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(84547,user.getLanguage())%>";
		dialog.Width = 600;
		dialog.Height = 450;
		dialog.Drag = true;
		dialog.maxiumnable = true;
		dialog.URL = url;
		dialog.show();
	}
	
	function onBtnSearchClick(){
		jQuery("#frmmain").submit();
	}
</script>

</BODY></HTML>

