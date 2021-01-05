<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
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
String topage = Util.null2String(request.getParameter("topage"));
String navName = "";
String url = "";
if(topage.equals("selectItemEdit")){
	String src = Util.null2String(request.getParameter("src"));
	String id = Util.null2String(request.getParameter("id"));
	if(src.equals("add")){
		navName = SystemEnv.getHtmlLabelName(124895,user.getLanguage());
	}else if(src.equals("edit")){
		navName = SystemEnv.getHtmlLabelName(124896,user.getLanguage());
	}
	url="/workflow/selectItem/selectItemEdit.jsp?src="+src+"&id="+id;
}else if(topage.equals("selectItemReferences")){
	String id = Util.null2String(request.getParameter("id"));
	navName = SystemEnv.getHtmlLabelName(33364,user.getLanguage());
	url="/workflow/selectItem/selectItemReferences.jsp?id="+id;
}else if(topage.equals("selectItemLog")){
    String id = Util.null2String(request.getParameter("id"));
	navName = SystemEnv.getHtmlLabelName(83,user.getLanguage());
	url="/workflow/selectItem/selectItemLog.jsp?id="+id;
}else if(topage.equals("selectItemBrowser")){
	navName = SystemEnv.getHtmlLabelName(124930,user.getLanguage());
	url="/workflow/selectItem/selectItemBrowser.jsp";
}else if(topage.equals("selectItemSupFieldBrowser")){
    //url = "/workflow/selectItem/selectItemMain.jsp?topage=selectItemSupFieldBrowser&fieldhtmltype=5&billid=&isdetail=" + isdetail + "&isbill=1";
	
	String detailtable = Util.null2String(request.getParameter("detailtable"));
	String fieldhtmltype = Util.null2String(request.getParameter("fieldhtmltype"));
	String billid = Util.null2String(request.getParameter("billid"));
	String isdetail = Util.null2String(request.getParameter("isdetail"));
	String isbill = Util.null2String(request.getParameter("isbill"));
	String fieldid = Util.null2String(request.getParameter("fieldid"));
	navName = SystemEnv.getHtmlLabelName(22755,user.getLanguage());
	url="/workflow/selectItem/selectItemSupFieldBrowser.jsp?detailtable="+detailtable+"&fieldhtmltype="+fieldhtmltype+"&billid="+billid+"&isdetail=" + isdetail + "&isbill="+isbill+"&fieldid="+fieldid;
}else if(topage.equals("fieldBrowser")){
	
	String detailtable = Util.null2String(request.getParameter("detailtable"));
	String fieldhtmltype = Util.null2String(request.getParameter("fieldhtmltype"));
	String billid = Util.null2String(request.getParameter("billid"));
	String isdetail = Util.null2String(request.getParameter("isdetail"));
	String isbill = Util.null2String(request.getParameter("isbill"));
	String fieldid = Util.null2String(request.getParameter("fieldid"));
	navName = SystemEnv.getHtmlLabelName(22662,user.getLanguage());
	url="/workflow/selectItem/fieldBrowser.jsp?detailtable="+detailtable+"&fieldhtmltype="+fieldhtmltype+"&billid="+billid+"&isdetail=" + isdetail + "&isbill="+isbill+"&fieldid="+fieldid;
}else if(topage.equals("selectItemEdit0")){
	String fieldid = Util.null2String(request.getParameter("fieldid"));
	navName = SystemEnv.getHtmlLabelName(32714,user.getLanguage());
	url="/workflow/selectItem/selectItemEdit0.jsp?fieldid="+fieldid;
	
}else if(topage.equals("BillManagementFieldAdd0")){
	String fieldid = Util.null2String(request.getParameter("fieldid"));
	String billId = Util.null2String(request.getParameter("billId"));
	String type = Util.null2String(request.getParameter("type"));
	String isbill = Util.null2String(request.getParameter("isbill"));
	String fromWFCode = Util.null2String(request.getParameter("fromWFCode"));
	navName = SystemEnv.getHtmlLabelName(261,user.getLanguage());
	if(type.equals("1")){
		url="/workflow/workflow/BillManagementFieldAdd0.jsp?frompage=1&src=addfield&isbill="+isbill+"&srcType=mainfield&billId="+billId+"&fromWFCode="+fromWFCode;
	}else{
		url="/workflow/workflow/BillManagementFieldAdd0.jsp?frompage=1&fieldid="+fieldid+"&isbill="+isbill+"&src=editfield&isused=true&srcType=mainfield&billId="+billId+"&fromWFCode="+fromWFCode;
	}
}else if(topage.equals("deleteNodeList")){
    navName = SystemEnv.getHtmlLabelNames("126185,15599",user.getLanguage());
    url="/workflow/workflow/DeleteNodeList.jsp?"+request.getQueryString();
}else if(topage.equals("wfbatchsetloglist")){
    navName = SystemEnv.getHtmlLabelName(32061,user.getLanguage());
    url="/workflow/workflow/WfBatchSet_loglist.jsp?"+request.getQueryString(); 
}else{
	navName = SystemEnv.getHtmlLabelName(124876,user.getLanguage());
	url = "/workflow/selectItem/selectItemSettings.jsp";
}



%>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        mouldID:"<%= MouldIDConst.getID("workflow")%>",
        iframe:"tabcontentframe",
        staticOnLoad:true,
        objName:"<%=navName%>"
    });
}); 
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
		    
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	    </div>
		</div>
	</div>
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=url %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
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
		}else{ 
			window.parent.oTd1.style.display='';
			window.parent.wfleftFrame.setHeight();
		}
	}
}
</script>
</html>