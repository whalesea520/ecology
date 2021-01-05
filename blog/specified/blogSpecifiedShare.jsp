
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
<HEAD>
<title></title>

<LINK href="/blog/css/blog_wev8.css" type=text/css rel=STYLESHEET>
<link type='text/css' rel='stylesheet'  href='/blog/js/treeviewAsync/eui.tree_wev8.css'/>
<script language='javascript' type='text/javascript' src='/blog/js/treeviewAsync/jquery.treeview_wev8.js'></script>
<script language='javascript' type='text/javascript' src='/blog/js/treeviewAsync/jquery.treeview.async_wev8.js'></script>

<link rel="stylesheet" href="/css/ecology8/request/leftNumMenu_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/leftNumMenu_wev8.js"></script>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

<style>
.hrmOrg span.subcompany{background:none;}
.hrmOrg span.company, .hrmOrg span.subcompany, .hrmOrg span.department, .hrmOrg span.person{padding:0px;}
.hrmOrg span.company{background:none;}
.hrmOrg span.department{background:none}
.treeview .expandable-hitarea{background:url('/images/xp_none/Lplus_wev8.png')};
.treeview li.lastCollapsable, .treeview li.lastExpandable{background:none;background-image:url('')}
.treeview li.lastExpandable{background-position:none}
.hrmOrg span.person{background:none;}
</style>


</HEAD>
<%

if (!HrmUserVarify.checkUserRight("blog:specifiedShare", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

int userid=user.getUID();

%>	
<body scroll=no style="overflow-y:hidden">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;height:100%">

	<tr>
		<td class="leftTypeSearch" style="width:40px;">
			<div class="topMenuTitle">
				<span class="leftType">
				<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"/></span>
				<span><%=SystemEnv.getHtmlLabelName(16455,user.getLanguage()) %>
				</span>
				</span>
				
				
			</div>
		</td>
		
		<td rowspan="2" height="100%">
			<iframe id='ifmBlogItemContent' name="ifmBlogItemContent" src="blogSpecifiedShareListFrame.jsp" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		</td>
	</tr>
	
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div class="flowMenuDiv"  >
				<div style="overflow-y:scroll;height:496px;position:relative;" id="overFlowDiv" >
					<div id="listItems">
						   <ul id="hrmOrgTree" style="width: 100%"></ul>
					</div>
				</div>
			</div>
		</td>
	</tr>
</table>


</body>
<script>
  
  jQuery(document).ready(function(){
  		$("#overFlowDiv").height(document.body.clientHeight-40);
	    $(".leftTypeSearch").height(40);
	    jQuery("#divListContentContaner").height(jQuery("#itmeList").height()); //固定 divListContentContaner高度防止不出现滚动条      
	    $("#hrmOrgTree").addClass("hrmOrg"); 
	    $("#hrmOrgTree").treeview({
	         url:"/blog/hrmOrgTree.jsp"
	    });
  });
  
  function dblclickTree(blogid,type,obj){
  		openBlog(blogid, type, obj);
  }

  function openBlog(blogid,type,obj){
	var url="";
	if(type==1){
	  ifmBlogItemContent.window.tabcontentframe.window.addSpecifiedShare(blogid);
	  return;
    }
	if(type==2||type==3){
	  return ;
	}
	jQuery("#ifmBlogItemContent").attr("src",url);
	if(obj){
		 jQuery(obj).css("font-weight","normal");
		 jQuery(obj).parent().parent().find(".selected").removeClass("selected");
		 jQuery(obj).parent().addClass("selected");
	}
 }


/*收缩左边栏*/
function mnToggleleft(obj){
	if(jQuery("#itmeList").is(":hidden")){
	        jQuery("#frmCenterImg").removeClass("frmCenterImgClose");
	        jQuery("#frmCenterImg").addClass("frmCenterImgOpen");
			jQuery("#itmeList").show();
	}else{
	        jQuery("#frmCenterImg").removeClass("frmCenterImgOpen");
	        jQuery("#frmCenterImg").addClass("frmCenterImgClose"); 
			jQuery("#itmeList").hide();
	}
}
</script>
