<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
    if(! HrmUserVarify.checkUserRight("collaborationarea:edit", user)) { 
        //response.sendRedirect("/notice/noright.jsp") ;
        out.print("<script>window.location.href=\"/notice/noright.jsp\"</script>");
        return ;
    }
%>
<html>
    <head>
    </head>
    <body>
     <!-- 
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
    			<iframe src="/cowork/type/CoworkTypeChildFrame.jsp" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
    		</td>
    	</tr>
    	<tr>
    		<td style="width:23%;" class="flowMenusTd">
    			<div class="flowMenuDiv"  >
    				<div style="overflow:hidden;height:300px;position:relative;" id="overFlowDiv" >
    					<div class="ulDiv" id="e8treeArea"></div>
    				</div>
    			</div>
    		</td>
    	</tr>
    </table>
    -->
    <iframe src="/cowork/type/CoworkTypeChildFrame.jsp" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
    </body>

    <script type="text/javascript">
    	/*
    	window.typeid=null;
    	window.workflowid=null;
    	window.nodeids=null;
    	window.notExecute = false;
    	wuiform.init=function(){
    		wuiform.textarea();
    		wuiform.wuiBrowser();
    		wuiform.select();
    	}
    	var demoLeftMenus = null;
    	
    	function refreshTree2(){
    		jQuery(".ulDiv").html("");
    		jQuery.post("CoworkTypeTreeData.jsp",function(data){
    			data = jQuery.trim(data);
    			demoLeftMenus = eval('('+data+')');
    			leftNumMenu();
    			jQuery(".ulDiv").height(jQuery(".ulDiv").children(":first").height());
    			window.setTimeout(function(){
    				jQuery(".ulDiv").height(jQuery(".ulDiv").children(":first").height());
    			},1000);
    		});
    	}
    	
    	
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
    		$(".flowFrame").attr("src","CoworkTypeChildFrame.jsp?departmentid="+attr.id+"&"+new Date().getTime());
    	}
        */
    </script>
</html>

