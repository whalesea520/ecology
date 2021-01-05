
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.blog.BlogReportManager"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title><%=SystemEnv.getHtmlLabelName(26470,user.getLanguage()) %></title>
<script type='text/javascript' src='js/timeline/lavalamp.min_wev8.js'></script>
<script type='text/javascript' src='js/timeline/easing_wev8.js'></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="css/blog_wev8.css" type=text/css rel=STYLESHEET>
<link href="js/timeline/lavalamp_wev8.css" rel="stylesheet" type="text/css"> 	

<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>
 
<script type="text/javascript" src="/blog/js/wdScrollTab/TabPanel_wev8.js"></script>
<link href="/blog/css/TabPanel_wev8.css" rel="stylesheet" type="text/css"/>

<jsp:include page="blogUitl.jsp"></jsp:include> 
<style>
.name{padding-left: 33px}
.tabClose{float: right;padding-right: 3px;cursor: pointer;}
.report{width:98%;height: 100%;overflow:auto}
.reportFrame{width: 100%;height: 100%;}
</style>
</HEAD>
<%
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17694,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<%
  String userid=""+user.getUID();
  BlogReportManager reportManager=new BlogReportManager();
  List tempList=reportManager.getReportTempList(userid);
  
%>

<body style="overflow-x: auto;overflow-y:hidden">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div id="blogLoading" class="loading" align='center'>
	<div id="loadingdiv" style="right:260px;">
		<div id="loadingMsg">
			<div><%=SystemEnv.getHtmlLabelName(81558,user.getLanguage())%></div>
		</div>
	</div>
</div>

<!-- tab -->
<div style="left:6px;width:43px;height:60px;background: url('/js/tabs/images/nav/mnav19_wev8.png') no-repeat center center;position: absolute;"></div>
<div id="tabTitle" style="left:50px;top:10px;height:60px;position: absolute;font-size:16px;"><%=SystemEnv.getHtmlLabelName(26470,user.getLanguage())%></div>	
<div id="tab" style="position: relative;width:100%;float: left;margin-top:30px;"></div>
</body>
<script>

var jcTabs = [
	'<iframe src="/blog/myReport.jsp" width="100%" height="98%" frameborder="0" id="mainConEmail" ></iframe>',
	'<iframe src="/blog/attentionReport.jsp" width="100%" height="98%" frameborder="0" id="mainConEmail" ></iframe>'
];



var tabpanel; 
var tab_height; 
$(document).ready(function(){  
	
	//alert($("body").height());
	$("#tab").height($("body").height()-50);
	var tabHeight=$("body").height()-30;
	tab_height = tabHeight;
	var maxLength=($("#tab").width()-86)/104;
    tabpanel = new TabPanel({  
        renderTo:'tab',  
        height:tabHeight,
        active : 0,
        autoResizable:true,
        maxLength : maxLength,  
        items : [
          		{id:'myReport',title:'<%=SystemEnv.getHtmlLabelName(18040,user.getLanguage()) %>',html:jcTabs[0],closable: false}
          		,{id:'attentionReport',title:'<%=SystemEnv.getHtmlLabelName(26943,user.getLanguage()) %>',html:jcTabs[1],closable: false}
          		
          		<%
				  for(int i=0;i<tempList.size();i++){
					  Map map=(Map)tempList.get(i);
					  String tempid=(String)map.get("tempid");
					  String tempName=(String)map.get("tempName");
					  
				%>
					,{id:'blog_<%=tempid%>',title:'<%=tempName %>',html:'<iframe src="customReport.jsp?tempid=<%=tempid%>" width="100%" height="98%" style="overflow:hidden" frameborder="0" id="mainConEmail" ></iframe>',closable: true}
				<%}%>
        ]
    });
	
	
}); 

jQuery(function(){
	var info ="<div id='tabcontentframe_box' class='_box' style='float:right;'>"+
		"<span title='<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>' style='font-size: 12px;cursor: pointer;'>"+
			"<input id='operata'  onmouseover='setCss(this)'"+
			"  class='e8_btn_top_first' type='button' value='<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>' onclick='addTab()'></span>"+
		"<span title='<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>' class='cornerMenu middle'></span></div>"
	jQuery(".tabpanel_move_content").append(info);
	
	jQuery("#operata").mouseover(function(){
		jQuery(this).addClass('e8_btn_top_first_hover');
	});
	
	jQuery("#operata").mouseout(function(){
		jQuery(this).removeClass('e8_btn_top_first_hover');
	});
	
});


//添加tab页
function addTab(type,url,tabname,mailId){
	jQuery.post("blogOperation.jsp?operation=addReport",function(data){
        var tempid=jQuery.trim(data);
	
		//这里的id分为li--tab的id,和tab里面内嵌的iframe的id
		var tabId="blog_"+tempid;
		var frameId="frame_"+tempid;
		var url = "customReport.jsp?isnew=true&tempid="+tempid;
		var tabname = "<%=SystemEnv.getHtmlLabelName(20412,user.getLanguage())%>";
		
		var wk=tabpanel.getTabPosision(tabId);
		if(typeof wk == 'number'){
		 	tabpanel.show(wk,false);//设置tab被选中，并且显示
		 	tabpanel.setTitle(wk, tabname);//设置tab的标题
		 	document.getElementById(frameId).src=url;//刷新页面
		 	return;
		 }
		var page="<iframe src='"+url+"' width='100%' height='98%' frameborder='0' id='"+frameId+"'></iframe>";
		tabpanel.addTab({id:tabId,title:tabname,html:page,closable: true});
	});
	
}

function deleteTab(tabId){
  	var index = tabId.indexOf("blog_");
  	if(index!=-1){
		var id = tabId.substring(5);
		jQuery.post("blogOperation.jsp?operation=delReport&tempid="+id);
	}
}

function refreshTab(id , title){
	tabpanel.setTitle("blog_"+id,title);
}

</script>
