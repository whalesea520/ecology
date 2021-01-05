
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<%@ page import="java.util.*" %>
<%
int userid=user.getUID();
String layout=Util.null2String(request.getParameter("layout"),"1");
String jointype=Util.null2String(request.getParameter("jointype"));
String menuType=Util.null2String(request.getParameter("menuType"));
String name= Util.null2String(request.getParameter("name")); //快速搜索协作主题
String id = Util.null2String(request.getParameter("id"));

String iframesrc="/cowork/CoworkTabFrame.jsp?showtree=1&layout="+layout+"&jointype="+jointype+"&coworkid="+id;
if(jointype.equals("5")){
	menuType = "themeApproval";
}
if(menuType.equals("themeApproval"))  //主题审批
	iframesrc="/cowork/CoworkTabFrame.jsp?layout="+layout+"&jointype=5";
else if(menuType.equals("contentApproval")){ //内容审批
	iframesrc="/cowork/CoworkDiscussFrame.jsp?layout="+layout;
}else if(menuType.equals("themeMonitor")){   //主题监控
	iframesrc="/cowork/CoworkMonitorFrame.jsp?layout="+layout;
}else if(menuType.equals("contentMonitor")){ //内容监控
	iframesrc="CoworkMonitorContent.jsp?layout="+layout;
}else if(menuType.equals("commentMonitor")){ //评论监控
    iframesrc="CoworkMonitorComment.jsp?layout="+layout;
}
boolean flag = iframesrc.contains("CoworkTabFrame") && "1".equals(layout);

String params="&name="+name;
iframesrc=iframesrc+params;

String width="100%";
if(layout.equals("1")) width="478px";
%>

<link rel="stylesheet" href="/css/ecology8/request/leftNumMenu_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/leftNumMenu_wev8.js"></script>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/cowork/coworkview_wev8.js"></script>

<style>
.layout_right1{height:100%}
.layout_right2{position: absolute;left: 275px;top:0px;right:0px;height:100%;}
.layout_left1{position: absolute;left: 0px;top:0px;width:275px;height:570px;overflow: hidden;}
.layout_left2{position: absolute;left: 0px;top:0px;width:275px;bottom:0px;overflow: hidden;}
</style>

</head>
<body>
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;"  >
	<tr>
		<td class="leftTypeSearch coworkTreeInfo" <%if(flag){ %>style="position: absolute;z-index: 2;top: 0px;width: 246px;"<%} %>>
			<div class="topMenuTitle">
				<span class="leftType">
				<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"/></span>
				<span><%=SystemEnv.getHtmlLabelName(21979,user.getLanguage())%></span>
				</span>
				<span class="leftSearchSpan">
					&nbsp;<input type="text" class="leftSearchInput" />
				</span>
			</div>
		</td>
		
		<td rowspan="2" <%if(flag){%>style="position: relative;left: 0px;"<%} %>>
			<iframe src="<%=iframesrc%>" class="flowFrame" id="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		</td>
	</tr>
	
	<tr <%if(flag){ %>style="position: absolute;z-index: 2;top: 60px;width: 247px;"<%} %> class="coworkTreeInfo">
		<td style="width:23%;<%if(flag){ %>float: left;<%} %>" class="flowMenusTd">
			<div class="flowMenuDiv"  >
				<div style="overflow:hidden;height:300px;position:relative;" id="overFlowDiv" >
					<div class="ulDiv" id="e8treeArea"></div>
				</div>
			</div>
		</td>
	</tr>
</table>	
	
</body>
<script>
  var layout="<%=layout%>";
  var jointype="<%=jointype%>";
  
  var demoLeftMenus = "";
  var menuUrl="<%=iframesrc%>";
  var flag = "<%=flag%>";
  $(document).ready(function(){
  
  	if(layout=="1"){		
	  	$("#flowFrame").bind("resize",function(){
	  	
	  		var centerDiv=$(this).contents().find("#tabcontentframe").contents().find(".centerDiv");
	  		
	  		var northDivWidth=$(this).contents().find("#tabcontentframe").contents().find(".northDiv").width();
	  		var leftMenuWidth=$(".flowMenusTd").width();
	  		
	  		if($(".flowMenusTd").is(":hidden")){
	  			centerDiv.parent().css("width",document.body.clientWidth-northDivWidth-8);
	  			centerDiv.css("width",document.body.clientWidth-northDivWidth-8);
	  		}else{
	  			centerDiv.parent().css("width",document.body.clientWidth-northDivWidth-leftMenuWidth-8);
	  			centerDiv.css("width",document.body.clientWidth-northDivWidth-leftMenuWidth-8);
	  		}
	  		
	  	});	
	}
	
	setTimeout(function(){
	
		jQuery('.leftTypeSearch').hide();
	
	}, 2000);	
	    
  });
  
  var flag = true;
  jQuery(function(){
  	if("<%=flag%>" == "true"){
  		jQuery(".flowMenusTd li a").live("click",function(){
  			if("" != jQuery(".ulDiv").html() && flag){
		 		jQuery(jQuery(".flowFrame")[0].contentWindow.document.getElementById("e8_tablogo")).click();
		 		flag = false;
			}
  		});
  	
  		jQuery(".flowFrame").live("mouseover",function(){
			if("" != jQuery(".ulDiv").html() && flag){
			  jQuery(jQuery(".flowFrame")[0].contentWindow.document.getElementById("e8_tablogo")).click();
			  flag = false;
			}
  		});
  		
  		jQuery(".flowsTable").live("mouseleave",function(){
  			if("" != jQuery(".ulDiv").html() && flag){
  			  jQuery(jQuery(".flowFrame")[0].contentWindow.document.getElementById("e8_tablogo")).click();
  			  flag = false;
  			}
  		});
  	}
  });
  	  
  function refreshTree2(){
  		flag = true;
		jQuery.ajax({
			url:"/cowork/coworkViewTree.jsp?menuType=<%=menuType%>",
			beforeSend:function(){
				if(jQuery("#e8treeArea").children().length>0){
					return false;
				}
				if(jQuery(".leftTypeSearch").css("display") === "none");
				else
					e8_before2();
			},
			complete:function(){
				e8_after2();
			},
			success:function(data){
				jQuery(".ulDiv").html("");
				demoLeftMenus = eval('('+data+')');
				flowPageManager.loadFunctions.leftNumMenu();
				jQuery(".ulDiv").height(jQuery(".ulDiv").children(":first").height());
				window.setTimeout(function(){
					jQuery(".ulDiv").height(jQuery(".ulDiv").children(":first").height());
				},1000);
			}
		});
	}
</script>
</html>

