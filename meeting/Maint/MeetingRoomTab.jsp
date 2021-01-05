
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.FileUpload" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
	int subid=Util.getIntValue(request.getParameter("subCompanyId"));
	String objname=SystemEnv.getHtmlLabelName(16615,user.getLanguage());
	if(subid > 0){
		objname=SubCompanyComInfo.getSubCompanyname(""+subid);
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
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("meeting")%>",
        staticOnLoad:true,
        objName:"<%=objname %>"

    });
    
    function getIframeDocument(){
    	var _contentDocument = getIframeDocument2();
    	var _contentWindow = getIframeContentWindow();
    	if(!!_contentDocument){
    		jQuery("#ALL").bind("click",function(){
    			_contentWindow = getIframeContentWindow();
    			_contentDocument = getIframeDocument2();
				//_contentWindow.resetCondtionAVS();
				jQuery("#statuss",_contentDocument).val("0");
				jQuery("#weaverA",_contentDocument).submit();
			});
			
			jQuery("#normal").bind("click",function(){
				_contentDocument = getIframeDocument2();
				jQuery("#statuss",_contentDocument).val("1");
				jQuery("#weaverA",_contentDocument).submit();
			});
			
			jQuery("#locked").bind("click",function(){
    			_contentDocument = getIframeDocument2();
				jQuery("#statuss",_contentDocument).val("2");
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

	String url = "/meeting/Maint/MeetingRoom_left.jsp";
	if(request.getQueryString() != null){
		url += "?"+request.getQueryString();
	} else {
		FileUpload fu = new FileUpload(request);
		String subCompanyId = Util.null2String(fu.getParameter("subCompanyId"));
		url += "?subCompanyId="+subCompanyId;
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
						<li class="e8_tree">
							<a onclick="javascript:toggleLeft();"><%=SystemEnv.getHtmlLabelName(26505,user.getLanguage()) %></a>
						</li>
							 <li id="ALLli" class="current">
								<a  id="ALL" href="#" onclick="return false;" target="tabcontentframe">
									<%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %>
								</a>
							</li>
							<li id="normalli">
								<a id="normal" href="#" onclick="return false;" target="tabcontentframe">
									<%=SystemEnv.getHtmlLabelName(225,user.getLanguage()) %>
								</a>
							</li>
							 <li id="lockedli">
								<a id="locked" href="#" onclick="return false;" target="tabcontentframe">
									<%=SystemEnv.getHtmlLabelName(22205,user.getLanguage()) %>
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

