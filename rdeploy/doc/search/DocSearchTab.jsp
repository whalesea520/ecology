<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
<HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<script src="/js/datetime_wev8.js"></script>


<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />

<%
	String url = "DocCommonContent.jsp?hasTab=1&"+request.getQueryString();
	String searchType = Util.null2String(request.getParameter("searchType")); // 0 最近更新 1 我的文档 2 查询文档 3 文档目录
	String seccategory = Util.null2String(request.getParameter("seccategory"));	
%>
<script type="text/javascript">
	<%  if(searchType.equals("3")){%>
	    window.notExecute = false;
	<% } else {%>
		window.notExecute = true;
	<% }%>
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("doc")%>",
        staticOnLoad:true
    });

    function getIframeDocument(){
			 <% if(searchType.equals("0")){%>
			 
			 jQuery("#docAll").bind("click",function(){
    			_contentDocument = getIframeDocument2();
				var todaydate =  getTodayDate();
				var customSearchParaVal = "list=all&urlType=6&isNew=yes";
				jQuery("#customSearchPara",_contentDocument).val(customSearchParaVal)
				jQuery("#frmmain",_contentDocument).submit();
			});
			 
			 
			jQuery("#docToday").bind("click",function(){
				_contentDocument = getIframeDocument2();
				var todaydate =  getTodayDate();
				var customSearchParaVal = "list=all&isNew=yes&urlType=6&doclastmoddatefrom="+todaydate+"&doclastmoddateto="+todaydate;
				jQuery("#customSearchPara",_contentDocument).val(customSearchParaVal)
				jQuery("#frmmain",_contentDocument).submit();
			});
			
			jQuery("#docWeek").bind("click",function(){
    			_contentDocument = getIframeDocument2();
				var customSearchParaVal = "list=all&isNew=yes&urlType=6&doclastmoddatefrom="+getWeekStartDate()+"&doclastmoddateto="+getWeekEndDate();
				jQuery("#customSearchPara",_contentDocument).val(customSearchParaVal)
				jQuery("#frmmain",_contentDocument).submit();
			});
			
			jQuery("#docMonth").bind("click",function(){
				_contentDocument = getIframeDocument2();
				var customSearchParaVal = "list=all&isNew=yes&urlType=6&doclastmoddatefrom="+getMonthStartDate()+"&doclastmoddateto="+getMonthEndDate();
				jQuery("#customSearchPara",_contentDocument).val(customSearchParaVal)
				jQuery("#frmmain",_contentDocument).submit();
			});
			
			jQuery("#docQuarterly").bind("click",function(){
				_contentDocument = getIframeDocument2();
				var customSearchParaVal = "list=all&isNew=yes&urlType=6&doclastmoddatefrom="+getQuarterStartDate()+"&doclastmoddateto="+getQuarterEndDate();
				jQuery("#customSearchPara",_contentDocument).val(customSearchParaVal)
				jQuery("#frmmain",_contentDocument).submit();
			});
			
			jQuery("#docYear").bind("click",function(){
				_contentDocument = getIframeDocument2();
				var customSearchParaVal = "list=all&isNew=yes&urlType=6&doclastmoddatefrom="+getYearStartDate()+"&doclastmoddateto="+getYearEndDate();
				jQuery("#customSearchPara",_contentDocument).val(customSearchParaVal)
				jQuery("#frmmain",_contentDocument).submit();
			});
    	<% 	}  else {%>
    	
    		jQuery("#docAll").bind("click",function(){
    			_contentDocument = getIframeDocument2();
				var todaydate =  getTodayDate();
				var customSearchParaVal = "list=all&urlType=6";
				<% if(searchType.equals("1")){%>
    				customSearchParaVal = customSearchParaVal+"&doccreaterid="+<%= user.getUID() %>
    			<% } %>
				jQuery("#customSearchPara",_contentDocument).val(customSearchParaVal)
				jQuery("#frmmain",_contentDocument).submit();
			});
			
			jQuery("#notReply").bind("click",function(){
				_contentDocument = getIframeDocument2();
				jQuery("#dspreply",_contentDocument).val("1");
				var customSearchParaVal = jQuery("#customSearchPara",_contentDocument).val();
    			if(customSearchParaVal.indexOf("dspreply=0") > 0)
    			{
    				customSearchParaVal = customSearchParaVal.replace("dspreply=0","dspreply=1");
    			}
    			else if(customSearchParaVal.indexOf("dspreply=2") > 0)
    			{
    				customSearchParaVal = customSearchParaVal.replace("dspreply=2","dspreply=1");
    			}
    			else if(customSearchParaVal.indexOf("dspreply=1") > 0)
    			{
    				
    			}
    			else {
    				customSearchParaVal = customSearchParaVal+"&dspreply=1"
    			}
    			
    			<% if(searchType.equals("1")){%>
    				customSearchParaVal = customSearchParaVal+"&doccreaterid="+<%= user.getUID() %>
    			<% } %>
				jQuery("#customSearchPara",_contentDocument).val(customSearchParaVal)				

				jQuery("#frmmain",_contentDocument).submit();
			});
			jQuery("#onlyReply").bind("click",function(){
				_contentDocument = getIframeDocument2();
				var customSearchParaVal = jQuery("#customSearchPara",_contentDocument).val();
    			jQuery("#dspreply",_contentDocument).val("2");
    			if(customSearchParaVal.indexOf("dspreply=0") > 0)
    			{
    				customSearchParaVal = customSearchParaVal.replace("dspreply=0","dspreply=2");
    			}
    			else if(customSearchParaVal.indexOf("dspreply=1") > 0)
    			{
    				customSearchParaVal = customSearchParaVal.replace("dspreply=1","dspreply=2");
    			}
    			else if(customSearchParaVal.indexOf("dspreply=2") > 0)
    			{
    				
    			}
    			else {
    				customSearchParaVal = customSearchParaVal+"&dspreply=2"
    			}
    			<% if(searchType.equals("1")){%>
				customSearchParaVal = customSearchParaVal+"&doccreaterid="+<%= user.getUID() %>
			<% } %>
				jQuery("#customSearchPara",_contentDocument).val(customSearchParaVal)
				jQuery("#frmmain",_contentDocument).submit();
			});
			<% } %>
    }
   getIframeDocument();
});
	
</script>
</head>
<body>
	<div class="e8_box demo2">
		<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
			<div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span id="objName"></span>
				</div>
				<div>
					<ul class="tab_menu" style="visibility:hidden;">
						
			         <% if(searchType.equals("0")){%>
			        <% if(seccategory.isEmpty()) {%>
				         <li id="docAll">
				        	<a  href="#" onclick="return false;" target="tabcontentframe">
				        		<%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %>
				        	</a>
				        </li>
				        <li  class="current">
			        	<a id="docToday" href="#" onclick="return false;" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(15537,user.getLanguage()) %>
			        	</a>
			        </li>
			        <% } else { %>
			        	 <li id="docAll" class="current">
				        	<a  href="#" onclick="return false;" target="tabcontentframe">
				        		<%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %>
				        	</a>
				        </li>
				        <li>
			        	<a id="docToday" href="#" onclick="return false;" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(15537,user.getLanguage()) %>
			        	</a>
			        </li>
			        <% } %>
			        
			         <li>
			        	<a id="docWeek" href="#" onclick="return false;" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(15539,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li>
			        	<a id="docMonth" href="#" onclick="return false;" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(15541,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li>
			        	<a id="docQuarterly" href="#" onclick="return false;" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(21904,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li>
			        	<a id="docYear" href="#" onclick="return false;" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(15384,user.getLanguage()) %>
			        	</a>
			        </li>
			        <% } else {%>
			        <li id="docAll" class="current">
			        	<a  href="#" onclick="return false;" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %>
			        	</a>
			        </li>
			        	<li id="notReply">
			        	<a href="#" target="tabcontentframe" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(18467,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li id="onlyReply">
			        	<a href="#" target="tabcontentframe" onclick="return false;">
			        		<%=SystemEnv.getHtmlLabelName(18468,user.getLanguage()) %>
			        	</a>
			        </li>
			        	
			        <% } %>
					</ul>
					<div id="rightBox" class="e8_rightBox">
					</div>
				</div>
			</div>
		</div>
	    <div class="tab_box">
	        <div>
	       <iframe src="<%=url %>" onload="update()"  id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>
