<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<html>
<head>
<link rel="stylesheet" href="/css/ecology8/request/leftNumMenu_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/leftNumMenu_wev8.js"></script>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
		
<style>
.groups {
	border-style: solid;
	border-color: #BBB;
	border-width: 1px;
	border-radius: 3px;
}
.groupiteam {
	height: 26px;
	background-color: #F6F6F6;
	color: black;
	padding: 0px 10px 0px 10px;
	line-height: 25px;
}
.groupiteamhover {
	background-color: #E6E6E6;;
}
.popWindow{
     width:450px;
     height:auto;
     box-shadow:rgba(0,0,0,0.2) 0px 0px 5px 0px;
     border: 2px solid #90969E;
     background: #ffffff;
}

</style>
</head>
<body style="overflow: hidden;">
		
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;"  >
	<tr>
		<td class="leftTypeSearch" style="height:40px;">
			<div class="topMenuTitle">
				<span class="leftType">
				<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"/></span>
				<span><%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %>
				</span>
				</span>
			</div>
		</td>
		
		<td rowspan="2" style="height:100%">
			<iframe id="contactTable" src="/blog/group/BlogGroupListFrame.jsp?groupid=all" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		</td>
	</tr>
	
	<tr>
		<td style="width:23%;" class="flowMenusTd" align="left">
			<div class="flowMenuDiv"  >
				<div style="overflow: auto;height:100%;position:relative;" id="overFlowDiv" >
					<div class="ulDiv" style="height:auto;"></div>
				</div>
			</div>
		</td>
	</tr>
</table>

</body>
</html>

<script>
	
	var groupid;
	var groupName;
	window.typeid=null;
	window.workflowid=null;
	window.nodeids=null;
	window.notExecute = true;
	wuiform.init=function(){
		wuiform.textarea();
		wuiform.wuiBrowser();
		wuiform.select();
	}
	
	var demoLeftMenus;
	
	jQuery(function(){
		
		jQuery("span[name='all']").hide();
		refreshTreeSed(true);
		jQuery(".flowMenusTd").show();
		jQuery(".leftTypeSearch").show();
		
		$("#overFlowDiv").height($(document.body).height()-40);
		
		//$("#contactTable").height($(document.body).height());
	});
	
	
	function refreshTreeSed(reload){
		jQuery(".ulDiv").html("");
		jQuery.post("/blog/group/BlogGroupListLeft.jsp?"+new Date().getTime(), function(data){
			demoLeftMenus = eval('('+data+')');
			leftNumMenu();
			if(reload){
				setTimeout(function(){
					jQuery(".ztree li:first").find("a").click();
				},1000);
			}	
		});
	}
	function leftNumMenu(){
		var	numberTypes={flowAll:{hoverColor:"#EE5F5F",color:"#EE5F5F",title:"<%=SystemEnv.getHtmlLabelName(16378,user.getLanguage()) %>"}};
		
		$(".ulDiv").leftNumMenu(demoLeftMenus,{
			numberTypes:numberTypes,
			showZero:false,
			menuStyles:["menu_lv1",""],
			expand:{
				url:function(attr,level){
					return attr.urlSum;
				},
				done:function(children,attr,level){
					jQuery(".ulDiv").height(jQuery(".ulDiv").children(":first").height());
					jQuery('#overFlowDiv').perfectScrollbar("update");
				}
			},
			clickFunction:function(attr,level,numberType){
				leftMenuClickFn(attr,level,numberType);
			}
		});
		var sumCount=0;
		$(".e8_level_2").each(function(){
			sumCount+=parseInt($(this).find(".e8_block:last").html());
		});
	}
	
	function leftMenuClickFn(attr,level,numberType){
		groupid = attr.id;
		groupName = attr.name;
		window.parent.controlOperation(groupid);
		
		$(".flowFrame").attr("src","/blog/group/BlogGroupList.jsp?groupid="+attr.id+"&"+new Date().getTime());
		   //showMenu();
	}
	
	function refreshChild(){
		document.getElementById('contactTable').contentWindow.document.getElementById('contactTable').contentWindow._table.reLoad();
	}
	
	
</script>
<script>
//移动到组
function moveToGroup(himself,event){

	document.getElementById('contactTable').contentWindow.document.getElementById('tabcontentframe').contentWindow.moveToGroup(himself,event);
}

//复制到组
function copyToGroup(himself,event){
	document.getElementById('contactTable').contentWindow.document.getElementById('tabcontentframe').contentWindow.copyToGroup(himself,event);
}
	
</script>

<script>

var currentGroup = "all";

</script>