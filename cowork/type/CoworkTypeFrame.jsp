
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<%@ page import="java.util.*" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>


<link rel="stylesheet" href="/css/ecology8/request/leftNumMenu_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/leftNumMenu_wev8.js"></script>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>



</head>

<body scroll="no">
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;"  >

	<tr>
		<td class="leftTypeSearch">
			<div class="topMenuTitle">
				<span class="leftType">
				<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"/></span>
				<span><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%>
				</span>
				</span>
				<span class="leftSearchSpan">
					&nbsp;<input type="text" class="leftSearchInput" />
				</span>
				
			</div>
		</td>
		
		<td rowspan="2">
			<iframe src="CoworkTypeChildFrame.jsp" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		</td>
	</tr>
	
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div class="flowMenuDiv"  >
				<div style="overflow:hidden;height:300px;position:relative;" id="overFlowDiv" >
					<div class="ulDiv" ></div>
				</div>
			</div>
		</td>
	</tr>
</table>

</body>

<script type="text/javascript">
	
	window.typeid=null;
	window.workflowid=null;
	window.nodeids=null;
	// window.notExecute = true;
	wuiform.init=function(){
		wuiform.textarea();
		wuiform.wuiBrowser();
		wuiform.select();
	}
	var demoLeftMenus = null;
	
	function refreshTree(){
		jQuery(".ulDiv").html("");
		jQuery.post("CoworkTypeTreeData.jsp",function(data){
			data = jQuery.trim(data);
			demoLeftMenus = eval('('+data+')');
			leftNumMenu();
		});
	}
	
	jQuery(function(){
		jQuery.post("CoworkTypeTreeData.jsp",function(data){
			 data = jQuery.trim(data);
			 demoLeftMenus = eval('('+data+')');
			 
			 leftNumMenu();
		})
	});
	
	
	
	function leftNumMenu(){
		var	numberTypes={flowAll:{hoverColor:"#EE5F5F",color:"#EE5F5F",title:"<%=SystemEnv.getHtmlLabelName(16378,user.getLanguage())%>"}};
		
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
		$(".flowFrame").attr("src","CoworkTypeChildFrame.jsp?departmentid="+attr.id+"&"+new Date().getTime());
		   
	}

</script>
</html>

