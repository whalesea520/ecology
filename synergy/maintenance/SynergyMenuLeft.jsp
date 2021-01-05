
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<HTML>
<HEAD>
<script>
 	window.notExecute = true;
</script>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link type="text/css" rel="stylesheet" href="/css/xtree_wev8.css">
<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xloadtree_wev8.js"></script>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link type="text/css" href="/js/tabs/css/e8tabs3_wev8.css" rel="stylesheet" />
<LINK href="/js/ecology8/customSelect/customSelect_wev8.css" type=text/css rel=STYLESHEET></LINK>
<script src="/js/ecology8/customSelect/customSelect_wev8.js" type="text/javascript"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>

</HEAD>

<%String stype=Util.null2String(request.getParameter("stype")); 
String titlename = "";
	if(stype.equals("wf"))
	{
		titlename = SystemEnv.getHtmlLabelName(32771, user.getLanguage());
	}else if(stype.equals("doc"))
	{
		titlename = SystemEnv.getHtmlLabelName(84275, user.getLanguage());
	}
%>

<BODY scroll=no>
<script language="javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core.min_wev8.js"></script>
<LINK href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css"  type=text/css rel=STYLESHEET></LINK>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<FORM NAME=weaver STYLE="margin-bottom:0" action="/synergy/maintenance/SynergyDesign.jsp" method=post target="contentframe">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<style>
   #overFlowDiv {
      width: 220px; 
   }

</style>
<input type='hidden' name='ptype'/>
<input type='hidden' name='assortmentid'/>
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;height:100%;"  >
<tr><td class="leftTypeSearch">
	<div class="topMenuTitle" style="border-bottom:none;" >
		<span class="leftType" >
		<span onclick="showE8TypeOption();"><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"/></span>
		<span>
			<div style="width:auto;height:auto;position:relative;" onclick="showE8TypeOption();" >
				<span id="optionSpan"><%=titlename%></span>
				<span style="width:16px;height:16px;padding-left:8px;cursor:pointer;line-height:16px;" >
					<img id="e8typeImg" src="/images/ecology8/doc/down_wev8.png"/>
				</span>
			</div>
		</span>
		<span id="totalDoc"></span>
		</span>
		<span class="leftSearchSpan">
			<input type="text" class="leftSearchInput" style="width:110px;"/>
		</span>
	</div>
</td>
</tr>
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div class="flowMenuDiv"  >
				<div style="overflow:hidden;height:300px;position:relative;" id="overFlowDiv">
					<div class="ulDiv" ></div>
				</div>
			</div>
		</td>
	</tr>
</table>
<ul id="e8TypeOption" class="e8TypeOption">
	<li onclick="changeShowType(this,'menu');">
		<span id="currentdoc" class="e8img"><img src="/images/ecology8/doc/current_wev8.png"/></span>
		<span class="e8img"><img src="/images/ecology8/doc/doc_sel_wev8.png"/></span>
		<span class="e8text">
		    <%
		    if(stype.equals("wf")){
		    %>
				<%=SystemEnv.getHtmlLabelName(32771, user.getLanguage())%>
			<%}else{ %>
			    <%=SystemEnv.getHtmlLabelName(84275, user.getLanguage())%>
		    <%}%>
		
		</span>
	</li>
	<li onclick="changeShowType(this,'operat');">
		<span id="currentorg" class="e8img  e8imgSel"><img src="/images/ecology8/doc/current_wev8.png"/></span>
		<span class="e8img"><img src="/images/ecology8/doc/org_sel_wev8.png"/></span>
		<span class="e8text">
              <%
			    if(stype.equals("wf")){
			  %>
					<%=SystemEnv.getHtmlLabelName(19060, user.getLanguage())%>
			  <%}else{ %>
				    <%=SystemEnv.getHtmlLabelName(84322, user.getLanguage())%>
			   <%}%>
        </span>
	</li>
</ul>
</FORM>


<div style="display:none;" id="menuStr">
	
</div>
<script language="javascript">
	var demoLeftMenus = [];
	

	var stype = "<%=stype%>";
	$(document).ready(function(){
		jQuery('.e8_box').Tabs({
	    	getLine:1,
	    	image:true,
	    	needLine:true,
	    	needTopTitle:false,
	    	needInitBoxHeight:false,
	    	needFix:true,
	    	tabMenuFixWidth:jQuery("td.leftTypeSearch").width()
	    });
		//e8_initTree("/synergy/maintenance/SynergyMenuLeftManage2.jsp?stype="+stype+"&pagetype=menu");
		onloadtree("menu");
	});
	function onloadtree(pagetype)
	{
		jQuery.ajax({
			url:"/synergy/maintenance/SynergyMenuLeftManage2.jsp",
			dataType:"json",
			beforeSend:function(){
				if(jQuery(".leftTypeSearch").css("display") === "none");
				else
					e8_before2();
			},
			complete:function(){
				e8_after2();
			},
			data:{
				stype:stype,
				pagetype:pagetype,
				wftypeid:"0",
				doclevel:"0"
			},
			success:function(data){
				//alert(data);
				$("#overFlowDiv").attr("loadtree","true");
				if(data != null)
				{
					var expand = {
						url:function(attr,level){
							return "/synergy/maintenance/SynergyMenuLeftManage2.jsp?stype="+stype+"&pagetype="+pagetype+"&wftypeid="+attr._id+"&doclevel="+level;
						},
						done:function(children,attr,level){
							jQuery(".ulDiv").height(jQuery(".ulDiv").children(":first").height());
							jQuery('#overFlowDiv').perfectScrollbar("update");
						}
					};
					$(".ulDiv").leftNumMenu(data,{
						multiJson:(pagetype=="operat" && stype=="doc")?true:false,	
						expand:stype=="doc"?null:expand,
						clickFunction:function(attr,level){
							leftMenuClickFn(pagetype,stype,attr,level);
						}
					});
				}
			}
		});
	}
	function changeShowType(obj,pagetype)
	{
		if(pagetype==="menu")
		{
			jQuery("#currentorg").addClass("e8imgSel");
			jQuery("#currentdoc").removeClass("e8imgSel");
			jQuery("#currentImg").attr("src","/images/ecology8/doc/doc_wev8.png");
			
			if("<%=stype%>"=='wf'){
			   jQuery("#optionSpan").text("<%=SystemEnv.getHtmlLabelName(32771, user.getLanguage())%>");
			}else{
			   jQuery("#optionSpan").text("<%=SystemEnv.getHtmlLabelName(84275, user.getLanguage())%>");
			}
		}
		else
		{
			jQuery("#currentorg").removeClass("e8imgSel");
			jQuery("#currentdoc").addClass("e8imgSel");
			jQuery("#currentImg").attr("src","/images/ecology8/doc/org_wev8.png");
			if("<%=stype%>"=='doc'){
			   jQuery("#optionSpan").text("<%=SystemEnv.getHtmlLabelName(84322, user.getLanguage())%>");
			}else{
			   jQuery("#optionSpan").text("<%=SystemEnv.getHtmlLabelName(19060, user.getLanguage())%>");
			}
		}
		window.oldtree = true;
		onloadtree(pagetype);
		showE8TypeOption();
	}
	
	function leftMenuClickFn(pagetype,stype,attr,level){
		var id="0";
		// pagetype 为  menu  则 baseid 为 synergy_base 中id 值， 协同中 synergy_base 中的id 为 协同的 hp id
		// pagetype 为  operat 则 baseid 为 流程id  或  文档 id
		var baseid = attr._id;
		//var stype = attr.stype;
		//var pagetype = attr.pagetype;
		//非根节点
		if(attr.hasChildren){
		   return;
		   //alert(1);
		   //document.weaver.action="/synergy/maintenance/SynergyDesign.jsp?stype="+stype;
		   //document.weaver.submit();
		  // return;
		}
		//!pagetype && (pagetype = 'operat');
		
		if(pagetype === "menu")
		{
			document.weaver.action = "/synergy/maintenance/SynergyDesign.jsp?hpid="+baseid+"&stype="+stype+"&pagetype="+pagetype;
		}else
		{
			document.weaver.action = "/synergy/maintenance/SynergyDesign.jsp?wfdocid="+baseid+"&stype="+stype+"&pagetype="+pagetype;
		}
	//	if(pagetype==="operat" && (level==1 || level==2) && stype==="doc")
	//	{
	//		document.SearchForm.action = "/synergy/maintenance/SynergyDesign.jsp?wfdocid="+baseid+"&stype="+stype;
	//	}
		
		//alert(document.weaver.action);
		
		document.weaver.submit();
	}
	
	function onClickCustomField(id,wfid,stype,pagetype,isSynergypage) {

		if(id==="0")
		{
			document.getElementById("id").value = wfid;
			document.weaver.action = "/synergy/maintenance/SynergyDesign.jsp?wfdocid="+wfid+"&stype="+stype+"&pagetype="+pagetype;
		}
		else
		{
			document.getElementById("id").value = id;
			document.weaver.action = "/synergy/maintenance/SynergyDesign.jsp?hpid="+id+"&stype="+stype+"&pagetype="+pagetype;
		}
		if(pagetype === "operat" && (isSynergypage==="0" || isSynergypage === "1") )
		{
			document.SearchForm.action = "/synergy/maintenance/SynergyDesign.jsp?wfdocid="+wfid+"&stype="+stype;
		}
		document.weaver.submit();
	}
</script>
</BODY>
</HTML>