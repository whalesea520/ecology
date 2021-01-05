
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<%
	String navName = "";
	navName = SystemEnv.getHtmlLabelName(18375,user.getLanguage());
	String isclose=Util.null2String(request.getParameter("isclose"));
	String currenttab=Util.null2String(request.getParameter("currenttab"));
	if("".equals( currenttab)){
		currenttab="tab1";
	}
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
<%
if("1".equals( isclose)){
	%>
try{
	var parentWin = parent.getParentWindow(window);
	if("<%=isclose%>"=="1"){
		parentWin._table.reLoad();
		parentWin.refreshLeftTree();
		parentWin.closeDialog();
	}
}catch(e){}
	<%
}

%>

$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("proj")%>",
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
				jQuery("#nomalDiv",_contentDocument).css("display","");
				jQuery("#agendaDiv",_contentDocument).css("display","none");
				jQuery("#currentTab").val("tab1");
			});
			
			jQuery("#agenda").bind("click",function(){
				_contentDocument = getIframeDocument2();
				jQuery("#nomalDiv",_contentDocument).css("display","none");
				jQuery("#agendaDiv",_contentDocument).css("display","");
				jQuery("#currentTab").val("tab2");
			});
			if(jQuery("#currentTab").val()=="tab2"){
				setTimeout('jQuery("#agenda").trigger("click");',600);
			}
    	}else{
    		window.setTimeout(function(){
    			getIframeDocument();
    		},500);
    	}
    }
    
     getIframeDocument();
});

</script>
<%
	String url = "/proj/Templet/ProjTempletViewTab.jsp";
	
	if(request.getQueryString() != null){
		url += "?"+request.getQueryString();
	}
%>

</head>
<BODY scroll="no">
<input type="hidden" name="currentTab" id="currentTab"  value="<%=currenttab %>" />
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
								<%=SystemEnv.getHtmlLabelName(16290,user.getLanguage()) %>
							</a>
						</li>
						<li>
							<a id="agenda" href="#" onclick="return false;" >
								<%=SystemEnv.getHtmlLabelName(18505,user.getLanguage()) %>
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


function closeWinAFrsh(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDlgARfsh();
}

function closeDialog(){
	var dialog = parent.getDialog(window);
	//dialog.closeByHand();
	dialog.close();
}

</script>