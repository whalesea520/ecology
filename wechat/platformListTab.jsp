
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
//判断是否有分权
String detachable=Util.null2String(session.getAttribute("wechatdetachable")!=null?session.getAttribute("wechatdetachable").toString():"0");
 
String url = "/wechat/platformList.jsp";
String subCompanyId=request.getParameter("subCompanyId");
String title="";
if(subCompanyId != null&&!"".equals(subCompanyId)){
	url += "?subCompanyId="+subCompanyId;
	title= SubCompanyComInfo.getSubCompanyname(subCompanyId);
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
        mouldID:"<%= MouldIDConst.getID("communicate")%>",
        staticOnLoad:true,
        objName:"<%="".equals(title)?SystemEnv.getHtmlLabelName(32639,user.getLanguage()):title %>"
    });
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
				    		<%if("1".equals(detachable)){%>
						        <li class="e8_tree">
						        	<a onclick="javascript:toggleLeft();"><%=SystemEnv.getHtmlLabelName(26505,user.getLanguage()) %></a>
						        </li>
				    		<%} %>
				        	 <li class="defaultTab">
					        	<a  id="ALL" href="#" onclick="return false;" target="tabcontentframe">
					        		<%=TimeUtil.getCurrentTimeString() %>
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

