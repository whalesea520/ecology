
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="bb" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="OverTimeInfo" class="weaver.workflow.node.NodeOverTimeInfo" scope="page" />
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<%
	//rulesrc 1:出口条件 2:批次条件
	String rulesrc = Util.null2String(request.getParameter("rulesrc"));
	String formid = Util.null2String(request.getParameter("formid"));
	String isbill = Util.null2String(request.getParameter("isbill"));
	String linkid = Util.null2String(request.getParameter("linkid"));
	String wfid = Util.null2String(request.getParameter("wfid"));
	String ruleid = Util.null2String(request.getParameter("ruleid"));
	String isnew = Util.null2String(request.getParameter("isnew"));
	String nodeid = Util.null2String(request.getParameter("nodeid"));
	String newrule = Util.null2String(request.getParameter("newrule"));
	String rownum = Util.null2String(request.getParameter("rownum")); //批次和督办需要用到行号
	
	//需要映射明细的ID, 
	int detailid = Util.getIntValue(request.getParameter("detailid"), 0);
	
	String objName = "";
	boolean hasovertime = true;
	
	String overtimeset = bb.getPropValue(GCONST.getConfigFile() , "ecology.overtime");   
	boolean showovertimeset=OverTimeInfo.getIsCreateOrReject(Util.getIntValue(linkid));
	
	if(rulesrc.equals("1"))
	{
		String isreject = Util.null2String(request.getParameter("isreject"));
		String curtype = Util.null2String(request.getParameter("curtype"));
		if(isreject.equals("1") || curtype.equals("0"))
			hasovertime = false;
	}
%>
<script type="text/javascript">
$(function() {
	$('.e8_box').Tabs({
		getLine : 1,
		iframe : "tabcontentframe",
		mouldID:"<%= MouldIDConst.getID("formmode")%>",
		staticOnLoad:true,
		objName:"<%=objName%>"
	});
	attachUrl("linkcond");
});

function changeRuleRelation(rulecondits,ruleRelationship, rulesrc){
	var parentWin = parent.getParentWindow(window);
	var rulemaplistids = jQuery(parentWin.document).find("#rulemaplistids").val();
	if((rulesrc == '7' || rulesrc == '8') || (rulemaplistids != undefined && rulemaplistids != null && rulemaplistids != "")){
		jQuery(parentWin.document).find("#conditions").html(rulecondits);
		jQuery(parentWin.document).find("#conditioncn").val(rulecondits);
	}
	jQuery(parentWin.document).find("#ruleRelationship").val(ruleRelationship);
}

function setRuleRelation(ruleRelationship){
	var parentWin = parent.getParentWindow(window);
	jQuery(parentWin.document).find("#ruleRelationship").val(ruleRelationship);
}

function attachUrl(param)
{
	//70是showcondition.jsp//80因为结构和逻辑完全不同，因此使用showcondition2.jsp
	if("<%=newrule%>"==="")
		$("[name='tabcontentframe']").attr("src","/workflow/ruleDesign/ruleMappingList.jsp?rulesrc=<%=rulesrc%>&detailid=<%=detailid %>&ruleid=<%=ruleid%>&formid=<%=formid%>&isbill=<%=isbill%>&linkid=<%=linkid%>&wfid=<%=wfid%>&isnew=<%=isnew%>&nodeid=<%=nodeid%>&rownum=<%=rownum%>");
	else
		$("[name='tabcontentframe']").attr("src","/formmode/interfaces/showcondition2.jsp?rulesrc=<%=rulesrc%>&detailid=<%=detailid %>&ruleid=<%=ruleid%>&formid=<%=formid%>&isbill=<%=isbill%>&linkid=<%=linkid%>&wfid=<%=wfid%>&isnew=<%=isnew%>&nodeid=<%=nodeid%>&rownum=<%=rownum%>");
}

function changeTab(param)
{
	document.getElementById("tabcontentframe").contentWindow.changeTab(param);
}

function setParentPic(id,ishow,rulesrc,ruleids,rulecondits,maplistids)
{
	var parentWin = parent.getParentWindow(window);
	if(rulesrc === "1")
	{
		if(!!ishow)
			jQuery(parentWin.document).find("#por"+id+"_conspan").html("<img src='/workflow/ruleDesign/images/ok_hover_wev8.png' border='0'>");
		else
			jQuery(parentWin.document).find("#por"+id+"_conspan").html("");
	}else if(rulesrc ==="4")
	{
		if(!!ishow)
		{
			jQuery(parentWin.document).find("#wfconditions").html(rulecondits);
			jQuery(parentWin.document).find("#wfconditionss").val(ruleids);
			jQuery(parentWin.document).find("#wfconditioncn").val(rulecondits);
			jQuery(parentWin.document).find("#rulemaplistids").val(maplistids);
		}
		else
		{
			jQuery(parentWin.document).find("#wfconditions").html("");
			jQuery(parentWin.document).find("#wfconditionss").val("");
			jQuery(parentWin.document).find("#wfconditioncn").val("");
			jQuery(parentWin.document).find("#rulemaplistids").val("");
		}
	}else if(rulesrc === "2")
	{
		if(!!ishow)
		{
			jQuery(parentWin.document).find("#conditions").html(rulecondits);
			jQuery(parentWin.document).find("#conditionss").val(ruleids);
			jQuery(parentWin.document).find("#conditioncn").val(rulecondits);
			jQuery(parentWin.document).find("#rulemaplistids").val(maplistids);
		}
		else
		{
			jQuery(parentWin.document).find("#conditions").html("");
			jQuery(parentWin.document).find("#conditionss").val("");
			jQuery(parentWin.document).find("#conditioncn").val("");
			jQuery(parentWin.document).find("#rulemaplistids").val("");
		}
	}else if(rulesrc === "6")
    {
        if(!!ishow)
        {
            jQuery(parentWin.document).find("#conditions").html(rulecondits);
            jQuery(parentWin.document).find("#conditionss").val(ruleids);
            jQuery(parentWin.document).find("#conditioncn").val(rulecondits);
            jQuery(parentWin.document).find("#rulemaplistids").val(maplistids);
        }
        else
        {
            jQuery(parentWin.document).find("#conditions").html("");
            jQuery(parentWin.document).find("#conditionss").val("");
            jQuery(parentWin.document).find("#conditioncn").val("");
            jQuery(parentWin.document).find("#rulemaplistids").val("");
        }
    } else if(rulesrc === "7" || rulesrc === "8") {
        if(!!ishow)
        {
            jQuery(parentWin.document).find("#conditions").html(rulecondits);
            jQuery(parentWin.document).find("#conditionss").val(ruleids);
            jQuery(parentWin.document).find("#conditioncn").val(rulecondits);
            jQuery(parentWin.document).find("#rulemaplistids").val(maplistids);
        }
        else
        {
            jQuery(parentWin.document).find("#conditions").html("");
            jQuery(parentWin.document).find("#conditionss").val("");
            jQuery(parentWin.document).find("#conditioncn").val("");
            jQuery(parentWin.document).find("#rulemaplistids").val("");
        }
        jQuery.ajax({
            type: "POST",
            url: "/workflow/workflow/WorkflowSubWfConditionUpdate.jsp",
            data:{"rulesrc":rulesrc, "linkid":id, "conditionss":ruleids, "conditioncn":rulecondits},
            success:function() {}
        });
    }
}
function settab1(){
	$("#tabcontentframe").attr("src","/workflow/ruleDesign/ruleMappingList.jsp?rulesrc=<%=rulesrc%>&detailid=<%=detailid %>&ruleid=<%=ruleid%>&formid=<%=formid%>&isbill=<%=isbill%>&linkid=<%=linkid%>&wfid=<%=wfid%>");	
}
function settab2(){
	$("#tabcontentframe").attr("src","/workflow/workflow/showcondition.jsp?formid=<%=formid%>&isbill=<%=isbill%>&linkid=<%=linkid%>&wfid=<%=wfid%>&detailid=<%=detailid %>");
}

</script>
</HEAD>
<BODY>
<div class="e8_box demo2">
	<div class="e8_boxhead">
		<div class="div_e8_xtree" id="div_e8_xtree"></div>
        <div class="e8_tablogo" id="e8_tablogo"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName"></span>
			</div>
			<div>
				<ul class="tab_menu">
					<%if(rulesrc.equals("1") && hasovertime && newrule.equals("")){ %>
					<li class="current" ><a  onclick="settab1()" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(33413,user.getLanguage()) %></a></li><!-- 出口条件 -->
					<%
					if (!"".equals(overtimeset) && !showovertimeset) {
					%>
					<li class="" ><a onclick="settab2()" target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(18818,user.getLanguage()) %></a></li><!-- 超时设置 -->
					<%
					}
					%>
					<%} %>
				</ul>
				<div id="rightBox" class="e8_rightBox"></div>
			</div>
		</div>
	</div>
	<div class="tab_box"><div>
	<iframe src="" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
</div> 
</BODY>
</HTML>
