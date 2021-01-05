<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*,weaver.workflow.exchange.ExchangeUtil" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="workType" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<%
if(!HrmUserVarify.checkUserRight(ExchangeUtil.WFEC_SETTING_RIGHTSTR, user))
{
	response.sendRedirect("/notice/noright.jsp");    	
	return;
}
boolean isUseWfManageDetach = manageDetachComInfo.isUseWfManageDetach();
%>
<%
	String navName = "";
	int typeid =Util.getIntValue(Util.null2String(request.getParameter("typeid")),0); 
	int detachable = 0 ;
	if(isUseWfManageDetach) detachable = 1 ;
	int subCompanyId=Util.getIntValue(request.getParameter("subcomid"),-1);
	String reflush = Util.null2String(request.getParameter("reflush"));
	String url = "/workflow/exchange/managelist.jsp?detachable="+detachable;
	if(reflush.equals("1")){
		url += "&reflush=1";
	}
	String wfid = Util.null2String(request.getParameter("wfid"));
	String wftypeid = Util.null2String(request.getParameter("wftypeid"));
	if(!wfid.equals("")){
		if(url.indexOf("?")!=-1){
			url += "&wfid="+wfid ;
		}else{
			url += "?wfid="+wfid ;
		}
	}
	if(!wftypeid.equals("")){
		if(url.indexOf("?")!=-1){
			url += "&wftypeid="+wftypeid ;
		}else{
			url += "?wftypeid="+wftypeid ;
		}
	}
	if(subCompanyId>0){
		if(url.indexOf("?")!=-1){
			url += "&subcompanyid="+subCompanyId ;
		}else{
			url += "?subcompanyid="+subCompanyId ;
		}
	}
	if(typeid == 0){
			navName = SystemEnv.getHtmlLabelName(82487,user.getLanguage());
	}else{
		navName = workType.getWorkTypename(typeid+"");
	}
	String showname = "";
	if(detachable==1){
		showname = SystemEnv.getHtmlLabelName(141,user.getLanguage());
	}else{
		showname = SystemEnv.getHtmlLabelName(63,user.getLanguage());
	}
%>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        mouldID:"<%= MouldIDConst.getID("workflow")%>",
        iframe:"tabcontentframe",
        staticOnLoad:true
    });
}); 

jQuery(document).ready(function(){ setTabObjName("<%=navName%>"); });
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
			    	<li class="e8_tree">
			        	<a onclick="javascript:mnToggleleft();"><<<%=showname %></a>
			        </li>
		    </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	    </div>
	    </div>
	    </div>
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=url %>" onload="update1()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
<script type="text/javascript">
	function mnToggleleft(){
		var f = window.parent.oTd1.style.display;
		if (f != null) {
			if(f==''){
				window.parent.oTd1.style.display='none';
				<%if(detachable==1){%>
				window.parent.parent.oTd1.style.display='none';
				<%}%>
			}else{ 
				window.parent.oTd1.style.display='';
				var divHeght = window.parent.wfleftFrame.setHeight();
				<%if(detachable==1){%>
				window.parent.parent.leftframe.setHeight(divHeght);
				window.parent.parent.oTd1.style.display='';
				<%}%>
			}
		}
	}
	
	function update1(){
		update();

		var src = "";
		try {
			src = document.getElementById("tabcontentframe").contentWindow.location.href
		}catch(e) {
			src = jQuery("#tabcontentframe").attr("src");
		}
		if(src.indexOf("reflush")!=-1){
			window.parent.wfleftFrame.location = "/workflow/exchange/leftTree.jsp?1=1&tempflag="+Math.random();
		}
		
	}

</script>
</html>
