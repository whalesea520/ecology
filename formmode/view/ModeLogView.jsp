<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.form.FormManager"%>
<%@ page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Map.Entry" %>
<%@ page import="weaver.formmode.interfaces.ModeManageMenu" %>
<%@ page import="weaver.formmode.view.ResolveFormMode"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResolveFormMode" class="weaver.formmode.view.ResolveFormMode" scope="page" />
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<jsp:useBean id="ModeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />
<jsp:useBean id="ModeViewLog" class="weaver.formmode.view.ModeViewLog" scope="page"/>
<jsp:useBean id="FormModeRightInfo" class="weaver.formmode.search.FormModeRightInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%

String titlename = SystemEnv.getHtmlLabelName(83,user.getLanguage());//日志
String needfav ="";
String needhelp ="";

String modeId = Util.null2String(request.getParameter("modeId"));
String relatedId = Util.null2String(request.getParameter("relatedId"));
String resourceid = Util.null2String(request.getParameter("resourceid"));
String fromdate = Util.null2String(request.getParameter("fromdate"));
String todate = Util.null2String(request.getParameter("todate"));
String initFlag = Util.null2String(request.getParameter("initFlag"));

String iframeurl = "/formmode/view/ModeLogViewIframe.jsp?modeId="+modeId+"&relatedId="+relatedId+"&resourceid="+resourceid+"&fromdate="+fromdate+"&todate="+todate+"&initFlag="+initFlag;
String modename = "";
if(Util.getIntValue(modeId,-1) > 0 ){
	rs.executeSql("select * from modeinfo where id="+modeId);
	if(rs.next()){
		modename = Util.null2String(rs.getString("modename"));
	}
}

%>
<!DOCTYPE html>
<HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>

<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        staticOnLoad:true,
        mouldID:"<%= MouldIDConst.getID("formmode")%>",
        objName:"<%=modename%>"
    });
 }); 

var parentWin = window.parent.parent.getParentWindow(parent);
	var dialog = window.parent.parent.getDialog(parent);
	if(!dialog){
		parentWin = window.parent.parent;
		dialog = window.parent.parent.getDialog(window);
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
				    <li class="current">
						<a href="<%=iframeurl%>" target="tabcontentframe">
							<%=modename %>
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
	            <iframe src="<%=iframeurl%>" id="tabcontentframe" name="tabcontentframe" onload="update()" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>
