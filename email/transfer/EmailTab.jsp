
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.cowork.CoworkDAO"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<%@ page import="java.util.*" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>

<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>


</head>

<%
	String url = "";
	String objName = "";
	if(request.getQueryString() != null){
        //区分明细页面和选择页面
		String isHidden= request.getParameter("isHidden");
		String folderid = Util.null2String(request.getParameter("folderid"),"-1");//0:收件箱；-1:已发送
			url = "/email/transfer/Email.jsp?"+request.getQueryString();
            if("true".equals(isHidden)){
                if("0".equals(folderid)){
                    objName = SystemEnv.getHtmlLabelName(131756,user.getLanguage());//内部邮件(收件箱)
                    
                }else{
                    objName = SystemEnv.getHtmlLabelName(131757,user.getLanguage());//内部邮件(已发送)
                }
                
            }else{
                objName = SystemEnv.getHtmlLabelNames("128807,24714",user.getLanguage());//选择内部邮件
            }
	}
	
%>


<body scroll="no">
	<div class="e8_box demo2" id="rightContent">
		<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
	        <div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span id="objName"></span>
				</div>
				<div>
					<ul class="tab_menu">
						
						<li class="defaultTab">
							<a href="" target="tabcontentframe" _datetype="list"></a>
						</li>
					</ul>
					<div id="rightBox" class="e8_rightBox"></div>
				</div>	
			</div>
		</div>
				
		<div class="tab_box"><div>
		<iframe src="<%=url %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	</div>	
</body>

<script>
$(document).ready(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("mail")%>",
        staticOnLoad:true,
        objName:"<%=objName %>"
    });
});


</script>
</html>
