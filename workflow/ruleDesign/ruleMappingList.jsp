<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@page import="weaver.workflow.ruleDesign.RuleBean"%>

<HTML><HEAD>
<%
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(68,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(21737,user.getLanguage()) ;
	String needfav = "";
	String needhelp = "";
	String method = Util.null2String(request.getParameter("method"));
	int ruleRelationship = 1;
	int ruleid = 0;
	ruleid = Util.getIntValue(request.getParameter("ruleid"),0);
	
	int detailid = Util.getIntValue(request.getParameter("detailid"), -1);
	//System.out.println(ruleid);
	boolean isnotdelImg = true;
	if(method.equals("onDel"))
	{
		isnotdelImg = RuleBusiness.deleteRule(ruleid);
	}else if(method.equals("onDelMap"))
	{
		//System.out.println(request.getParameter("mapid"));
		int mapid = 0;
		mapid = Util.getIntValue(request.getParameter("mapid"),0);
		isnotdelImg = RuleBusiness.deleteRuleMapping(mapid);
	}else if(method.equals("onDelMaps"))
	{
		String mapids = Util.null2String(request.getParameter("mapid"));
		mapids = mapids.substring(0,mapids.length()-1);
		String[] tempids = Util.TokenizerString2(mapids, ",");
		for(String tempid : tempids){
			isnotdelImg = RuleBusiness.deleteRuleMapping(Util.getIntValue(tempid));
		}
	}else if(method.equals("onDelOld"))
	{
		isnotdelImg = RuleBusiness.deleteRuleOld(ruleid);
	}
	
	String rulesrc = Util.null2String(request.getParameter("rulesrc"));
	int ruleconditiontipInfoId = 84553;
	//督办 流程代理
	if("4".equals(rulesrc)||"6".equals(rulesrc)||"5".equals(rulesrc)){
	    ruleconditiontipInfoId = 126686;
	}
	String formid = Util.null2String(request.getParameter("formid"));
	String isbill = Util.null2String(request.getParameter("isbill"));
	String linkid = Util.null2String(request.getParameter("linkid"));
	String isnew = Util.null2String(request.getParameter("isnew"));
	String wfid = Util.null2String(request.getParameter("wfid"));
	
	String navname = "";
	String nodegroupid = "";
	String nodeid = Util.null2String(request.getParameter("nodeid"));
	int rownum = Util.getIntValue(request.getParameter("rownum"),0);
	//System.out.println("rownum"+rownum);
	if(rulesrc.equals("1") || rulesrc.equals("2") || rulesrc.equals("4")|| rulesrc.equals("5")|| rulesrc.equals("6"))
	{	//如果是出口和批次，需要根据 节点ID确定规则ID
		RecordSet.executeSql(" select id from rule_base where rulesrc="+rulesrc +" and linkid="+linkid);
		if(RecordSet.first())
			ruleid = Util.getIntValue(RecordSet.getString("id"),0);
		//QC178169
		if(rulesrc.equals("1")) RecordSet.executeSql("select * from rule_maplist t1,rule_base t2 where t1.ruleid = t2.id and (t1.rulesrc="+rulesrc +" or t1.rulesrc=-" + rulesrc +") and t1.linkid="+linkid);
		if(rulesrc.equals("1") && RecordSet.getCounts() == 0) {
			String strSql = "select 1 from workflow_nodelink where not (condition is null or dbms_lob.getlength(condition) =0) and id="+linkid;
			if(RecordSet.getDBType().equals("sqlserver")){
				strSql = "select 1 from workflow_nodelink where not (convert(varchar,condition) is null or convert(varchar,condition) ='' or convert(varchar,condition) =' ') and id="+linkid;
			}
			RecordSet1.executeSql(strSql);
			if(RecordSet1.getCounts() > 0) {
				isnotdelImg = true;
			} else {
				isnotdelImg = false;
			}
		}
		if(rulesrc.equals("2"))
		{
			RecordSet1.executeSql(" select t2.nodename,t1.workflowid,t1.ruleRelationship from workflow_flownode t1,workflow_nodebase t2 where t1.nodeid = t2.id and t2.id="+nodeid);
			RecordSet1.first();
			navname = ""+SystemEnv.getHtmlLabelName(81951,user.getLanguage())+" ("
			+WorkflowComInfo.getWorkflowname(Util.null2String(RecordSet1.getString("workflowid")))+"-"
			+Util.null2String(RecordSet1.getString("nodename"))+")";
			wfid = Util.null2String(RecordSet1.getString("workflowid"));
			ruleRelationship = Util.getIntValue(Util.null2String(RecordSet1.getString("ruleRelationship")), 1);
		}
	}else if (rulesrc.equals("3"))	//传过来等于3不等于实际等于3，再往数据库请求一次查真是的rulesrc
	{
		ruleid = Util.getIntValue(request.getParameter("ruleid"),0);
		RecordSet.executeSql(" select * from rule_base where id="+ruleid);
		if(RecordSet.first())
		{
			
			rulesrc = Util.null2String(RecordSet.getString("rulesrc"));
			if(rulesrc.equals("1") || rulesrc.equals("2") || rulesrc.equals("4"))
			{
				formid = Util.null2String(RecordSet.getString("formid"));
				isbill = Util.null2String(RecordSet.getString("isbill"));
				linkid = Util.null2String(RecordSet.getString("linkid"));
				wfid = Util.null2String(RecordSet.getString("wfid"));
				if(rulesrc.equals("2"))//节点
				{
					nodegroupid = linkid;
					RecordSet1.executeSql(" select t4.nodename,t3.workflowid from workflow_nodegroup t1,workflow_groupdetail t2,workflow_flownode t3,workflow_nodebase t4 "
							 +" where t1.id = t2.groupid and t1.nodeid=t3.nodeid and t3.nodeid=t4.id "
							 +" and t2.id="+nodegroupid);
					RecordSet1.first();
					navname = ""+SystemEnv.getHtmlLabelName(81951,user.getLanguage())+" ("
							+WorkflowComInfo.getWorkflowname(Util.null2String(RecordSet1.getString("workflowid")))+"-"
							+Util.null2String(RecordSet1.getString("nodename"))+")";
				}
			}else
			{
				navname = ""+SystemEnv.getHtmlLabelName(81952,user.getLanguage());
			}
		}
	} else if (rulesrc.equals("7")) {
        RecordSet1.executeSql(" select ruleRelationship from Workflow_SubwfSet where id=" + linkid);
        if (RecordSet1.next()) {
            ruleRelationship = Util.getIntValue(Util.null2String(RecordSet1.getString("ruleRelationship")), 1);
        }
    } else if (rulesrc.equals("8")) {
        RecordSet1.executeSql(" select ruleRelationship from Workflow_TriDiffWfDiffField where id=" + linkid);
        if (RecordSet1.next()) {
            ruleRelationship = Util.getIntValue(Util.null2String(RecordSet1.getString("ruleRelationship")), 1);
        }
    }
	
	//找出流程名称和节点名称/出口名称
	if(rulesrc.equals("1"))
	{	//出口
		RecordSet1.executeSql(" select workflowid,linkname,conditioncn,condition,ruleRelationship from workflow_nodelink where id="+linkid);
		//System.out.println("linkid===>"+linkid);
		String oldcondition = "";
		String oldconditionsql = "";
		String linkname = "";
		if(RecordSet1.first())
		{
			navname = SystemEnv.getHtmlLabelName(18850,user.getLanguage())+" ("
					+WorkflowComInfo.getWorkflowname(Util.null2String(RecordSet1.getString("workflowid")))+"-"
					+Util.null2String(RecordSet1.getString("linkname"))+")";
			wfid = Util.null2String(RecordSet1.getString("workflowid"));
			oldcondition = Util.null2String(RecordSet1.getString("conditioncn"));
			oldconditionsql = Util.null2String(RecordSet1.getString("condition"));
			oldcondition = oldcondition.replaceAll("'","''");
			oldcondition = oldcondition.replaceAll("\\\\","\\");
			linkname = Util.null2String(RecordSet1.getString("linkname"));
			ruleRelationship = Util.getIntValue(Util.null2String(RecordSet1.getString("ruleRelationship")), 1);
		}
		//出口中显示80之前的设置条件
		String sql = "select count(0) num from rule_base where linkid='"+linkid+"' and rulesrc='-1'";
		RecordSet1.executeSql(sql);
		int num = 0;
		if(RecordSet1.first())
		{
			num = Util.getIntValue(RecordSet1.getString("num"),0);
		}
		if(num == 0 && (!oldconditionsql.equals("")&&!oldcondition.equals("")))
		{
			RuleBusiness rulebusiness = new RuleBusiness();
			RuleBean rb = new RuleBean();
			rb.setRulename(WorkflowComInfo.getWorkflowname(wfid)+" "+linkname);
			rb.setRulesrc("-1");
			rb.setLinkid(linkid);
			rb.setFormid("-1");
			rb.setCondit(oldcondition);
			String reid = RuleBusiness.newRule(rb);
			
			RecordSet1.executeSql("insert into rule_maplist (linkid,ruleid,wfid,isused,rulesrc,nm,rowidenty)values('"
					+ linkid +"','"+reid+"','"+wfid+"','0','-1','2','0')");
			
			//System.out.println("insert");
		}
	}else if(rulesrc.equals("4"))//督办
	{
		//RecordSet1.executeSql(" select workflowid from workflow_urgerdetail where id="+linkid);
		//if(RecordSet1.first())
			navname = ""+SystemEnv.getHtmlLabelName(81953,user.getLanguage())+" ("
				+WorkflowComInfo.getWorkflowname(Util.null2String(linkid))+")";
		wfid = linkid;
	}else if(rulesrc.equals("5")){//流程数据交换
		//navname = "流程数据交换条件设置"+" ("+WorkflowComInfo.getWorkflowname(Util.null2String(wfid))+")";
		RecordSet1.executeSql("select name,ruleRelationship from  wfec_indatawfset where id="+linkid);
		if(RecordSet1.first()){
			navname = RecordSet1.getString(1);
			ruleRelationship = Util.getIntValue(Util.null2String(RecordSet1.getString("ruleRelationship")), 1);
		}
	}else if(rulesrc.equals("6")){//流程代理
		navname = ""+SystemEnv.getHtmlLabelName(84550,user.getLanguage())+" ("+WorkflowComInfo.getWorkflowname(Util.null2String(wfid))+")";
	} else if (rulesrc.equals("7") || rulesrc.equals("8")) {
        navname = SystemEnv.getHtmlLabelName(126298,user.getLanguage()) + "("+WorkflowComInfo.getWorkflowname(Util.null2String(wfid))+")";
    }
 %>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/workflow/ruleDesign/js/jquery.form.js"></script>
<script type="text/javascript">
	
	$(document).ready(function(){
  		resizeDialog(document);
  		settitle();
  		if(<%=!isnotdelImg%> && "<%=rulesrc%>"==="1")
  		{
  			jQuery(parent.parent.getParentWindow(parent).document).find("#por<%=linkid%>_conspan").html("");
  		}
	});
	function settitle()
	{
		var navname = "<%=navname%>";
		parent.setTabObjName(navname);
	}
	var dialog = null;
	function onNew()
	{
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/formmode/interfaces/showconditionContent.jsp?newrule=1&rulesrc=<%=rulesrc%>&ruleid=<%=ruleid%>&formid=<%=formid%>&isbill=<%=isbill%>&linkid=<%=linkid%>&wfid=<%=wfid%>&isnew=1&nodeid=<%=nodeid%>&rownum=<%=rownum%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(84551,user.getLanguage())%>";
		dialog.Width = 900;
		dialog.Height = 568;
		dialog.Drag = true;
		dialog.maxiumnable = true;
		dialog.URL = url;
		dialog.show();
	}
	
	function onEdit(mapid,ruleid)
	{	
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/formmode/interfaces/showconditionContent.jsp?newrule=1&rulesrc=<%=rulesrc%>&ruleid="+ruleid+"&formid=<%=formid%>&isbill=<%=isbill%>&linkid=<%=linkid%>&wfid=<%=wfid%>&nodeid=<%=nodeid%>&rownum=<%=rownum%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(84552,user.getLanguage())%>";
		dialog.Width = 900;
		dialog.Height = 568;
		dialog.Drag = true;
		dialog.maxiumnable = true;
		dialog.URL = url;
		dialog.show();
	}
	
	var options = {
		type: "post",
        success: function () {
            saveRuleRelationship();
        }
    };
	
	function onDel(mapid,ruleid)
	{
		var confirmContent = "<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>";
    	window.top.Dialog.confirm(confirmContent, function (){
    		$("[name=method]").val("onDel");
    		$("[name=ruleid]").val(ruleid);
    		$("#frmmain").ajaxSubmit(options);
		}, function () {
		});
	}
	
	function saveRuleRelationship(obj){
		var ruleRelationship = "";
		//ruleRelationship = jQuery("checked").val();
		ruleRelationship = jQuery("input[name='ruleRelationship']:checked").val();
		$.ajax({
			type: "post",
		    url: "/workflow/ruleDesign/ruleMappingOperation.jsp?_" + new Date().getTime() + "=1&",
		    data: {
		    	ruleid:jQuery("input[name=ruleid]").val(),
		    	rulesrc:jQuery("input[name=rulesrc]").val(),
		    	linkid:jQuery("input[name=linkid]").val(),
		    	nodeid:jQuery("input[name=nodeid]").val(),
		    	rownum:jQuery("input[name=rownum]").val(),
		    	ruleRelationship:ruleRelationship,
		    	actionKey:"relationship"
		    	},
		    contentType : "application/x-www-form-urlencoded; charset=UTF-8",
		    complete: function(){
		    	location.reload();
			},
		    error:function (XMLHttpRequest, textStatus, errorThrown) {
		    } , 
		    success:function (data, textStatus) {
		    	var _data = jQuery.parseJSON(data);
		    	if(_data != null){
		    		parent.changeRuleRelation(_data.condits,_data.ruleRelationship, jQuery("input[name=rulesrc]").val());
		    	}
		    } 
	    });
	}
	
	function onDelOld(mapid,ruleid)
	{
		var confirmContent = "<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>";
    	window.top.Dialog.confirm(confirmContent, function (){
    		$("[name=method]").val("onDelOld");
    		$("[name=ruleid]").val(ruleid);
    		$("#frmmain").ajaxSubmit(options);
		}, function () {
		});
	}
    
	function onDelmap(mapid)
	{
		var confirmContent = "<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>";
	    	window.top.Dialog.confirm(confirmContent, function (){
	    		$("[name=method]").val("onDelMap");
	    		$("[name=mapid]").val(mapid);
	    		$("#frmmain").ajaxSubmit(options);
			}, function () {
			});
	}
	
	function onMapping()
	{
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/workflow/ruleDesign/ruleMapping.jsp?rulesrc=<%=rulesrc%>&ruleid=<%=ruleid%>&formid=<%=formid%>&isbill=<%=isbill%>&linkid=<%=linkid%>&wfid=<%=wfid%>&isnew=<%=isnew%>&nodeid=<%=nodeid%>&rownum=<%=rownum%>&detailid=<%=detailid %>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(84547,user.getLanguage())%>";
		dialog.Width = 600;
		dialog.Height = 450;
		dialog.Drag = true;
		dialog.maxiumnable = true;
		dialog.URL = url;
		dialog.show();
	}
	
	function onEditmap(mapid,params)
	{
	
	    var paramarray = params.split("+");
        var ruleid=paramarray[0];
        var detailid = paramarray[1];
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/workflow/ruleDesign/ruleMapping.jsp?rulesrc=<%=rulesrc%>&ruleid="+ruleid+"&formid=<%=formid%>&isbill=<%=isbill%>&linkid=<%=linkid%>&wfid=<%=wfid%>&isnew=<%=isnew%>&nodeid=<%=nodeid%>&rownum=<%=rownum%>&mapid="+mapid + "&detailid=" + detailid;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(84547,user.getLanguage())%>";
		dialog.Width = 600;
		dialog.Height = 450;
		dialog.Drag = true;
		dialog.maxiumnable = true;
		dialog.URL = url;
		dialog.show();
	}
	
	function ondDelMappings()
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
    		$("#frmmain").ajaxSubmit(options);
		}, function () {});
	}
	
	var parentWin1 = null;
		var dialog1 = null;
		try{
			parentWin1 = parent.parent.getParentWindow(parent);
			dialog1 = parent.parent.getDialog(parent);
			dialog1.checkDataChange = false;
		}catch(e){}
</script> 
</head>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<form action="/workflow/ruleDesign/ruleMappingList.jsp" name="frmmain" id="frmmain">
	<input type="hidden" name="mapid" >
	<input type="hidden" name="method" >
	<input type="hidden" name="rulesrc" value="<%=rulesrc %>" >
	<input type="hidden" name="ruleid" >
	<input type="hidden" name="formid" value="<%=formid %>" >
	<input type="hidden" name="isbill" value="<%=isbill %>" >
	<input type="hidden" name="linkid" value="<%=linkid %>" >
	<input type="hidden" name="isnew" value="<%=isnew %>" >
	<input type="hidden" name="wfid" value="<%=wfid %>" >
	<input type="hidden" name="nodeid" value="<%=nodeid %>" >
	<input type="hidden" name="rownum" value="<%=rownum %>" >
	<input type="hidden" name="pageId" id="pageId" _showCol="false" value="<%=PageIdConst.WF_RULEDESIGN_RULEMAPPINGLIST%>"/>
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" onclick="javascript:ondDelMappings()"/>
				<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelNames("19422,124825",user.getLanguage()) %>" onclick="javascript:onMapping()"/>
				<%
				//映射明细字段时， 不能新建，只能引用，且可以引用指定明细表
				if (detailid < 1) {
				%>
				<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelNames("1421,579",user.getLanguage())%>" onclick="javascript:onNew()"/>
				<%
				}
				%>
				<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<%if(rulesrc.equals("1") || rulesrc.equals("2") || rulesrc.equals("7") || rulesrc.equals("8")){ %>
	<wea:layout type="2Col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(579,user.getLanguage()) + SystemEnv.getHtmlLabelName(320,user.getLanguage())%>'> 
			<wea:item><%=SystemEnv.getHtmlLabelName(82828,user.getLanguage())%></wea:item>
			<wea:item>
				<input type="radio" name="ruleRelationship" value="1" <%if (1==ruleRelationship) out.println("checked");%> onclick="saveRuleRelationship(this)">AND&nbsp;&nbsp;
				<input type="radio" name="ruleRelationship" value="2" <%if (2==ruleRelationship) out.println("checked");%> onclick="saveRuleRelationship(this)">OR&nbsp;&nbsp;
			</wea:item>
		</wea:group>
	</wea:layout>
	<% }%>
</form>
<%
	//设置好搜索条件				
	String sqlWhere = " t1.ruleid = t2.id and (t1.rulesrc="+rulesrc+" or t1.rulesrc=-"+rulesrc+") and t1.linkid="+linkid;
	if((rulesrc.equals("2") || rulesrc.equals("4")|| rulesrc.equals("5")|| rulesrc.equals("6")) && isnew.equals("1"))
		sqlWhere += " and rowidenty="+rownum;
	String sqlfields = " t1.id, t1.ruleid,t2.condit,t2.rulename,t1.nm , t1.detailid";
	String sqlfrom = " rule_maplist t1,rule_base t2";
	String sqlorderby = "t2.id";
	String operateString= "";
	operateString = "<operates>";
	operateString +=" <popedom transmethod=\"weaver.workflow.ruleDesign.RuleBusiness.getRuleMappingOperate\" otherpara=\"column:nm\" ></popedom> ";
	operateString +="     <operate href=\"javascript:onEditmap();\" otherpara=\"column:ruleid+column:detailid\" text=\""+SystemEnv.getHtmlLabelName(33881,user.getLanguage())+"\" index=\"0\"/>";
	operateString +="     <operate href=\"javascript:onEdit();\" otherpara=\"column:ruleid\" text=\""+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+"\" index=\"1\"/>";
	operateString +="     <operate href=\"javascript:onDelmap();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" index=\"2\"/>";
	operateString +="     <operate href=\"javascript:onDel();\" otherpara=\"column:ruleid\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" index=\"3\"/>";
	operateString +="     <operate href=\"javascript:onDelOld();\" otherpara=\"column:ruleid\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" index=\"4\"/>";
	operateString +="</operates>";
	String tableString=""+
		   "<table tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_RULEDESIGN_RULEMAPPINGLIST,user.getUID())+"\">"+
		   " <checkboxpopedom  id=\"checkbox\"  popedompara=\"column:nm\" showmethod=\"weaver.workflow.ruleDesign.RuleBusiness.getMapResultCheckBox\" />"+ 
		   "<sql backfields=\"" + sqlfields + "\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlform=\"" + sqlfrom + "\" sqlorderby=\"" + sqlorderby + "\"  sqlprimarykey=\"t1.id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
		   operateString+
		   "<head>";
		   		tableString += "<col width=\"35%\" text=\""+SystemEnv.getHtmlLabelName(19829,user.getLanguage())+"\" column=\"rulename\" />";
		   		tableString += "<col width=\"35%\" text=\""+SystemEnv.getHtmlLabelName(15240,user.getLanguage())+"\" column=\"nm\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.workflow.ruleDesign.RuleBusiness.getNM\"/>";
		   		tableString += "<col width=\"60%\" text=\""+SystemEnv.getHtmlLabelName(15364,user.getLanguage())+"&lt;span class='xTable_algorithmdesc' title='"+SystemEnv.getHtmlLabelName(ruleconditiontipInfoId,user.getLanguage())+"'&gt;&lt;img src='/images/tooltip_wev8.png' style='vertical-align:top;'/&gt;&lt;/span&gt;\" column=\"ruleid\" otherpara=\""+user.getUID()+"\" transmethod=\"weaver.workflow.ruleDesign.RuleBusiness.getExpressionsDisplayStringByRuleId\" />";
		   		tableString +=	 
		   "</head>"+
		   "</table>";      
  %>
	<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/> 
</div>
 <div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context="" attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
			    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="zd_btn_cancle" onclick="dialog1.close()">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
</BODY>
</HTML>
