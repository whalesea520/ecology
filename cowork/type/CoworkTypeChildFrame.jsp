<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>

<html>
    <head>
        <%
        	String departmentid = Util.null2String(request.getParameter("departmentid"));
        %>
        <script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
        <link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
        <link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
        <script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
        <link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
        <link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
        <script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
        <script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
    </head>

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
                            <!-- 
    						<li class="e8_tree">
    							<a><%=SystemEnv.getHtmlLabelName(455,user.getLanguage()) %></a> 
    						</li>
    						<li class="defaultTab">
    							<a href="" target="tabcontentframe" _datetype="list"><%=SystemEnv.getHtmlLabelName(23669,user.getLanguage())%></a>
    						</li>
                             -->
    					</ul>
    					<div id="rightBox" class="e8_rightBox"></div>
    				</div>
    			</div>
    		</div>
    		<div class="tab_box">
    		    <iframe src="" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
            <div>
    	</div>	
    </body>

    <script type="text/javascript">
        window.notExecute = true;
        $(document).ready(function(){
    	    $('.e8_box').Tabs({
    			getLine : 1,
    			iframe : "tabcontentframe",
    			mouldID:"<%=MouldIDConst.getID("collaboration")%>",
    	       	staticOnLoad:true,
    	        objName:"<%=SystemEnv.getHtmlLabelName(33690,user.getLanguage())%>"  //版块设置
    		});
    		attachUrl();
    		
            /*
    		jQuery("#e8_tablogo").bind("click",function(){
    			if(jQuery("#e8treeArea",parent.document).children().length==0){
        			parent.refreshTree2();
        		}
        	});
            */
    	});
      
      	function attachUrl(){
    	   $("[name='tabcontentframe']").attr("src","/cowork/type/CoworkTypeChild.jsp?departmentid=<%=departmentid %>");
    	}
    </script>
</html>
