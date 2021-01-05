
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="taskManager" class="weaver.worktask.request.TaskManager" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

<link rel="stylesheet" href="/worktask/css/common_wev8.css" type="text/css" />
<link rel="stylesheet" href="/worktask/css/powerFloat_wev8.css" type="text/css" />


<%
	//下属ID
	int subuserid = Util.getIntValue(request.getParameter("subuserid"),0);
    int userid = user.getUID();
%>

<style>
#floatBox_list{
   display: none
}

.float_list_ul{
   border: 1px solid #e5e5e5;
   border-top: none;
   min-height: 100px;
}

.float_list_ul li {
	line-height: 30px;
	border-bottom: 1px dashed #e5e5e5;
	border-top: none;
}

.float_list_ul li a{
	padding-left: 7px;
}

.subordinateOpen{
   background-color: #fff;
	border: medium none;
	cursor: pointer;
	height: 39px;
	left: 0px;
	line-height: 32px;
	position: absolute;
	text-align: center;
	top: 11px;
	width: 10px;
	background-image: url(/images/ecology8/openTree_wev8.png);

}

.subordinateOpen:hover{
   background-image: url(/images/ecology8/openTree_hover_wev8.png);
}

.subordinateClose{
   background-color: #fff;
	border: medium none;
	cursor: pointer;
	height: 39px;
	left: 0px;
	line-height: 32px;
	position: absolute;
	text-align: center;
	top: 11px;
	width: 10px;
	background-image: url(/images/ecology8/closeTree_wev8.png);
	display:none

}

.subordinateClose:hover{
   background-image: url(/images/ecology8/closeTree_hover_wev8.png);
}

.e8_tablogo{
   margin-left: 15px !important;
}
</style>

<script type="text/javascript">

$(function(){
    
    <% if(Util.getIntValue(request.getParameter("subuserid"),0) !=0){ %>
       $(".subordinateOpen").hide();
	    $(".subordinateClose").show();
    <%}%>

    $('.e8_box').Tabs({
        getLine:1,
        mouldID:"<%= MouldIDConst.getID("worktask")%>",
        iframe:"tabcontentframe",
        staticOnLoad:true,
        objName:"<%=SystemEnv.getHtmlLabelName(16539,user.getLanguage()) %>"
       
    });

   	attachUrl();
   	
   	//带链接下拉
	$("#subordinate").powerFloat({
		width: 100,
		eventType: "click",
		target: $("#floatBox_list"),
		hoverHold: false,
		offsets: {
			x: -10,
			y: -1
		}
	});
	
	$("#subordinateli").click(function(){
	   //$("#subordinate").html("<%=SystemEnv.getHtmlLabelName(442, user.getLanguage()) %>("+$(this).attr("username")+")");
	   //$.powerFloat.hide();
	   var subuserid = "<%=subuserid%>";
	   $("[name='tabcontentframe']").attr("src","taskmain.jsp?tasktype=1&taskuser="+subuserid);
	});
	
	$(".tab_menu li").click(function(){
	   if(!$(this).hasClass("subordinateli")){
	     $("#subordinate").html("<%=SystemEnv.getHtmlLabelName(442, user.getLanguage()) %>");
	   }
	});
	
	if("<%=subuserid%>" !='0'){
	   $("#subordinateli").trigger("click");
	}
	
	$(".subordinateOpen").click(function(){
	    if($(".e8_leftToggle", parent.parent.document).css("left") != '0px'){
	        $(".e8_leftToggle", parent.parent.document).trigger("click");
	    }
	    //$(".e8_leftToggle", parent.parent.document).hide();
	    $("#MainFrameSet", window.parent.document).attr("cols","225,*");
	    $(".subordinateOpen").hide();
	    $(".subordinateClose").show();
	});
	
	$(".subordinateClose").click(function(){
	    //alert($(".e8_leftToggle", parent.parent.document).css("left"));
	    $(".e8_leftToggle", parent.parent.document).trigger("click");
	    //$(".e8_leftToggle", parent.parent.document).show();
	    $("#MainFrameSet", window.parent.document).attr("cols","0,*");
	    $(".subordinateOpen").show();
	    $(".subordinateClose").hide();
	});
}); 


function refreshTab() {
	jQuery('.flowMenusTd', parent.document).toggle();
	jQuery('.leftTypeSearch', parent.document).toggle();
}

function attachUrl(){
	var requestParameters=$(".voteParameterForm").serialize();
	$("a[target='tabcontentframe']").each(function(){
	    var url = "";
	    if($(this).attr("urs"))url = $(this).attr("urs");
		url += "&taskuser=<%=userid %>"+"&"+requestParameters;
		$(this).attr("href",url);
	});
	
	$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(0)").attr("href"));
	
}

</script>

</head>

<body scroll="no">

<div id="floatBox_list2" ></div>
<div id="floatBox_list" >
   <ul class="float_list_ul">
   <%
	//下属个数
	int xscount = 0;
	//rs.execute("select * from HrmResource where status in (0,1,2,3) and managerid= "+userid);
	//while(rs.next()){
	%>
	<%
	    // xscount++;
	  // } 
	%>
   </ul>
</div>

	<div class="e8_box demo2">
	<div class="e8_boxhead">
	    <div class="div_e8_xtree" id="div_e8_xtree"></div>
        <div class="e8_tablogo" id="e8_tablogo"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName"></span>
			</div>
		<div>
	    
		<ul class="tab_menu" >
			<li <% if(subuserid == 0){%> class="current" <%} %> >
				<a href="" urs='taskmain.jsp?tasktype=1' target="tabcontentframe">
				          <%=SystemEnv.getHtmlLabelName(19865, user.getLanguage()) %>
				          <% 
				             String count = taskManager.getTaskTypeCount("1","",userid+"",rs);
				             if(!"0".equals(count)){
				          %>
				            (<%=count %>)
				          <%} %>
				</a>
			</li>
			 <% 
	             count = taskManager.getTaskTypeCount("2","",userid+"",rs);
	             if(!"0".equals(count)){
	         %>
			   <li >
					<a href="" urs='taskmain.jsp?tasktype=2' target="tabcontentframe">
					      <%=SystemEnv.getHtmlLabelName(81832, user.getLanguage()) %>
				            (<%=count %>)
					</a>
			   </li>
			 <%} %>
			 
			  <% 
	             count = taskManager.getTaskTypeCount("3","",userid+"",rs);
	             if(!"0".equals(count)){
	         %>
			   <li >
					<a href="" urs='taskmain.jsp?tasktype=3' target="tabcontentframe">
					      <%=SystemEnv.getHtmlLabelName(26933, user.getLanguage()) %>
				            (<%=count %>)
					</a>
			   </li>
			 <%} %>
			 
			  <% 
	             count = taskManager.getTaskTypeCount("4","",userid+"",rs);
	             if(!"0".equals(count)){
	         %>
			   <li >
					<a href="" urs='taskmain.jsp?tasktype=4' target="tabcontentframe">
					      <%=SystemEnv.getHtmlLabelName(81833, user.getLanguage()) %>
				            (<%=count %>)
					</a>
			   </li>
			 <%} %>
			 
			  <% 
	             count = taskManager.getTaskTypeCount("5","",userid+"",rs);
	             if(!"0".equals(count)){
	         %>
			   <li >
					<a href="" urs='taskmain.jsp?tasktype=5' target="tabcontentframe">
					      <%=SystemEnv.getHtmlLabelName(81834, user.getLanguage()) %>
				            (<%=count %>)
					</a>
			   </li>
			 <%} %>
			 
			 <% if(subuserid != 0){ %>
				  <li id="subordinateli" class="current">
						<a href="javascript:void(0);">
						      <%=SystemEnv.getHtmlLabelName(442, user.getLanguage()) %>(<%=ResourceComInfo.getLastname(subuserid+"") %>)
						</a>
				   </li>
		      <%} %>
			 
			
		</ul>
		 <div id="rightBox" class="e8_rightBox">
	    </div>
	    	</div>
		</div>
	</div>
		<div class="tab_box">
		<iframe onload="update()" src="" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		<form class="voteParameterForm">
			<%
				Enumeration<String> e=request.getParameterNames();
				while(e.hasMoreElements()){
					String paramenterName=e.nextElement();
					String value=request.getParameter(paramenterName);
					//System.out.println(paramenterName + ":" + value);
					%>
						<input type="hidden" name="<%=paramenterName %>" value="<%=value %>" class="requestParameters">
					<% 
				}
				
			%>
		</form>
	</div></div>
	
	<div class="subordinateOpen">
	</div>
	<div class="subordinateClose">
	</div>
	
<script type="text/javascript" src="/worktask/js/jquery-powerFloat-min_wev8.js"></script>	
</body>
</html>

