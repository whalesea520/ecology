
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        staticOnLoad:true,
        mouldID:"<%= MouldIDConst.getID("communicate")%>",
        objName:"<%=SystemEnv.getHtmlLabelName(32640,user.getLanguage()) %>"
    });
    
    function getIframeDocument(){
    	var _contentDocument = getIframeDocument2();
    	var _contentWindow = getIframeContentWindow();
    	if(!!_contentDocument){
    		jQuery("#ALL").bind("click",function(){
    			_contentWindow = getIframeContentWindow();
    			_contentDocument = getIframeDocument2();
				_contentWindow.resetCondtion();
				jQuery("#timeSag",_contentDocument).val("0");
				jQuery("#weaverA",_contentDocument).submit();
			});
			
			jQuery("#TODAY").bind("click",function(){
    			_contentDocument = getIframeDocument2();
				jQuery("#timeSag",_contentDocument).val("1");
				jQuery("#weaverA",_contentDocument).submit();
			});
			
			jQuery("#WEEK").bind("click",function(){
    			_contentDocument = getIframeDocument2();
				jQuery("#timeSag",_contentDocument).val("2");
				jQuery("#weaverA",_contentDocument).submit();
			});
			
			jQuery("#MOUTH").bind("click",function(){
    			_contentDocument = getIframeDocument2();
				jQuery("#timeSag",_contentDocument).val("3");
				jQuery("#weaverA",_contentDocument).submit();
			});
			
			jQuery("#SEASON").bind("click",function(){
    			_contentDocument = getIframeDocument2();
				jQuery("#timeSag",_contentDocument).val("4");
				jQuery("#weaverA",_contentDocument).submit();
			});
			
			jQuery("#YEAR").bind("click",function(){
    			_contentDocument = getIframeDocument2();
				jQuery("#timeSag",_contentDocument).val("5");
				jQuery("#weaverA",_contentDocument).submit();
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
	String url = "/wechat/wechatList.jsp";
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
		        	 <li id="ALLli">
			        	<a  id="ALL" val="0" href="#" onclick="return false;" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li id="TODAYli" class="current">
			        	<a id="TODAY" val="1" href="#" onclick="return false;" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(15537,user.getLanguage()) %>
			        	</a>
			        </li>
			         <li id="WEEKli">
			        	<a id="WEEK" val="2" href="#"  onclick="return false;" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(15539,user.getLanguage()) %>
			        	</a>
			        </li>
					 <li id="MOUTHli">
			        	<a id="MOUTH" val="3" href="#"  onclick="return false;" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(15541,user.getLanguage()) %>
			        	</a>
			        </li>
			         <li id="SEASONli">
			        	<a id="SEASON" val="4" href="#"  onclick="return false;" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(21904,user.getLanguage()) %>
			        	</a>
			        </li>
					 <li id="YEARli">
			        	<a id="YEAR" val="5" href="#"  onclick="return false;" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(15384,user.getLanguage()) %>
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

