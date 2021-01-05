
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<%
	String navName = "";
	//if(user.getLanguage() == 8){
	//	navName = SystemEnv.getHtmlLabelName(82,user.getLanguage())+" "+SystemEnv.getHtmlLabelName(2103,user.getLanguage());
	//} else {
	//	navName = SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(2103,user.getLanguage());
	//}
	navName = SystemEnv.getHtmlLabelName(2103,user.getLanguage());
%>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("meeting")%>",
        staticOnLoad:true,
        objName:"<%=navName %>"
    });
    
    function getIframeDocument(){
    	var _contentDocument = getIframeDocument2();
    	var _contentWindow = getIframeContentWindow();
    	if(!!_contentDocument){
    		jQuery("#nomal").bind("click",function(){
    			_contentWindow = getIframeContentWindow();
    			_contentDocument = getIframeDocument2();
				//jQuery("#nomalDiv",_contentDocument).css("display","");
				jQuery("#agendaDiv",_contentDocument).css("display","none");
				jQuery("#serviceDiv",_contentDocument).css("display","none");
				jQuery("#nomalDiv",_contentDocument).css("position","");
			});
			
			jQuery("#agenda").bind("click",function(){
				_contentDocument = getIframeDocument2();
				//jQuery("#nomalDiv",_contentDocument).css("display","none");
				jQuery("#agendaDiv",_contentDocument).css("display","");
				jQuery("#serviceDiv",_contentDocument).css("display","none");
				jQuery("#nomalDiv",_contentDocument).css("position","absolute");
				jQuery("#nomalDiv",_contentDocument).css("top","-9990px");
			});
			
			jQuery("#service").bind("click",function(){
				_contentDocument = getIframeDocument2();
				//jQuery("#nomalDiv",_contentDocument).css("display","none");
				jQuery("#agendaDiv",_contentDocument).css("display","none");
				jQuery("#serviceDiv",_contentDocument).css("display","");
				jQuery("#nomalDiv",_contentDocument).css("position","absolute");
				jQuery("#nomalDiv",_contentDocument).css("top","-9990px");
			});
		
    	}else{
    		window.setTimeout(function(){
    			getIframeDocument();
    		},500);
    	}
    }
    
     getIframeDocument();
});

function toggleLeft(){
	var f = window.parent.document.getElementById("oTd1").style.display;

	if (f != null) {
		if (f==''){
			window.parent.document.getElementById("oTd1").style.display='none'; 
		}else{ 
			window.parent.document.getElementById("oTd1").style.display=''; 
		}
	}
}
</script>
<%
	String url = "/meeting/data/NewMeeting.jsp";
	if(request.getQueryString() != null){
		url += "?"+request.getQueryString();
	}
%>

</head>
<BODY scroll="no">
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
						<li class="current">
							<a id="nomal" href="#" onclick="return false;" >
								<%=SystemEnv.getHtmlLabelName(24249, user.getLanguage())%>
							</a>
						</li>
						<li>
							<a id="agenda" href="#" onclick="return false;" >
								<%=SystemEnv.getHtmlLabelName(31327, user.getLanguage())%>
							</a>
						</li>
						<li>
							<a id="service" href="#" onclick="return false;" >
								<%=SystemEnv.getHtmlLabelName(2107, user.getLanguage())%>
							</a>
						</li>
					</ul>
					<div id="rightBox" class="e8_rightBox">
					</div>
				</div>
			</div>
		</div>
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=url %>" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;" onload="update()"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>
<script type="text/javascript">
function forbiddenPage(){
	$("<div class=\"datagrid-mask\" style=\"position:fixed;z-index:2;opacity:0.4;filter:alpha(opacity=40);BACKGROUND-COLOR:#fff;\"></div>").css({display:"block",width:"100%",height:"100%",top:0,left:0}).appendTo("body");   
    $("<div class=\"datagrid-mask-msg\" style=\"background:#fff;position:fixed;z-index:3;padding: 10px;padding-top: 6px;padding-bottom: 6px;border: 1px solid;\"></div>").html("<%=SystemEnv.getHtmlLabelName(25666,user.getLanguage())%>").appendTo("body").css({display:"block",left:($(document.body).outerWidth(true) - 190) / 2,top:($(window).height() - 45) / 2});  
} 

function releasePage(){  
    $(".datagrid-mask,.datagrid-mask-msg").hide();  
}

function closeWinAFrsh(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDlgARfsh();
}

function closeDialog(){
	//var parentWin = parent.getParentWindow(window);
	//parentWin.closeDialog();
	var dialog = parent.getDialog(window);
	dialog.closeByHand();
}

</script>