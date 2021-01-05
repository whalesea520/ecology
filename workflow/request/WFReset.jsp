<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %> 
<%
	String wfid = request.getParameter("wfid");
	String tab001URL = "/workflow/design/WorkflowLayoutEdit.jsp?wfid="+wfid;
	String tab002URL = "/workflow/workflow/Editwfnode.jsp?ajax=1&wfid="+wfid;
	String tab003URL = "/workflow/workflow/addwfnodeportal.jsp?ajax=1&wfid="+wfid;
	String type = request.getParameter("type");
	String url = "";
	if("2".equals(type)){
	    url = tab003URL;
	}else{
	    url = tab002URL;
	}
%>
<html>
	<head>
		<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
		<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
		<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
		<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
		<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
		<script type="text/javascript">
			 jQuery(function(){
				 jQuery('#wfrsetul li a').click(function(){
				 	jQuery(this).parent().addClass('current').siblings().removeClass('current');
				 });
				 var type = '<%=type%>';
				 if(type == '2'){
				 	jQuery('#wfrsetul li').eq(2).addClass('current');
				 }else{
				 	jQuery('#wfrsetul li').eq(1).addClass('current');
				 }
			 });
			 
			 function bindInnerRightMenu(e, target) {
				var e8_head=$("div#rightBox",window.document);
				jQuery(".cornerMenu",window.document).unbind("click");
				jQuery(".cornerMenu",window.document).click(function(e){
					bindCornerMenuEvent(e8_head, target.contentWindow, e);
					return false;
				});
			}
		</script>
		<style type="text/css">
			.tab_menu li{
				height:30px;
				line-height:30px;
			}
			.e8_ultab{
				height:30px;
			}
			.tab_menu{
				height:30px;
				line-height:30px;
				margin-left:10px;
			}
			.e8_boxhead{
				height:30px;
			}
			.e8_navtab {
			    height: 0px;
			    line-height: 0px;
		    }
		    .hereposition{
		    	float:right;
		    }
		</style>
	</head>

	<body>
		 <div class="e8_box">
	      <div class="e8_boxhead">
	         <div class="div_e8_xtree" id="div_e8_xtree"></div>
	         <div class="e8_ultab">
	              <div class="e8_navtab" id="e8_navtab">
	         </div>
	         <div>
            	 <ul class="tab_menu" id="wfrsetul">
		            <li>
			            <a href="<%=tab001URL %>" target="tabcontentframe">
			             <%=SystemEnv.getHtmlLabelName(16459,user.getLanguage()) %>
			            </a>
			            <span class="e8_rightBorder">|</span>
		           </li>
		           <li>
			            <a href="<%=tab002URL %>" target="tabcontentframe">
			             <%=SystemEnv.getHtmlLabelName(15615, user.getLanguage())%>
			            </a>
			            <span class="e8_rightBorder">|</span>
		           </li>
		            <li>
			            <a href="<%=tab003URL %>" target="tabcontentframe">
			             <%=SystemEnv.getHtmlLabelName(15606, user.getLanguage())%>
			            </a>
		           </li>
	          </ul>
	         <div id="rightBox" class="e8_rightBox">
	         </div>
	       </div>
	     </div>
	         <span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu hereposition"></span>
	  </div>
	   <div class="tab_box" style="height:550px;">
             <iframe src="<%=url %>" onload="bindInnerRightMenu(event, this)" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	     </div>
	 </div>     
		
	</body>
</html>
