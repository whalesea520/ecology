
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	String id = Util.null2String(request.getParameter("id"));
	String method = Util.null2String(request.getParameter("method"));
	String from = Util.null2String(request.getParameter("from"));
	String dialog = Util.null2String(request.getParameter("dialog"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	RecordSet.executeSql("select id, name from Meeting_Type where id = "+ id);
	String name = "";
	if (RecordSet.next()) {
		name = Util.null2String(RecordSet.getString("name"));
	}
	String objName = SystemEnv.getHtmlLabelName(2104,user.getLanguage());
	if(!"".equals(name)){
		objName = name;
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
        objName:"<%=objName%>"
    });
    
});


</script>

<%
	int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));
	String url = "/meeting/Maint/MeetingTypeEdit.jsp";
	if(request.getQueryString() != null){
		url += "?"+request.getQueryString();
	} else {
		url += "?id="+id+"&method="+method+"&from="+from+"&dialog="+dialog+"&isclose="+isclose;
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
				   
						 <li <%	if ("edit".equals(method) || "".equals(method)) {%> class="current" <%} %>>
							<a href="/meeting/Maint/MeetingTypeEdit.jsp?dialog=1&id=<%=id %>&method=edit&from=<%=from %>" target="tabcontentframe">
								<%=SystemEnv.getHtmlLabelName(33276,user.getLanguage()) %>
							</a>
						</li>
						<li <%	if ("share".equals(method)) {%> class="current" <%} %>>
							<a href="/meeting/Maint/MeetingTypeEdit.jsp?dialog=1&id=<%=id %>&method=share&from=<%=from %>"  target="tabcontentframe">
								<%=SystemEnv.getHtmlLabelName(19910,user.getLanguage()) %>
							</a>
						</li>
						<li <%	if ("member".equals(method)) {%> class="current" <%} %>>
							<a href="/meeting/Maint/MeetingTypeEdit.jsp?dialog=1&id=<%=id %>&method=member&from=<%=from %>"  target="tabcontentframe">
								<%=SystemEnv.getHtmlLabelName(149,user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(2106,user.getLanguage()) %>
							</a>
						</li>
						<li <%	if ("caller".equals(method)) {%> class="current" <%} %>>
							<a href="/meeting/Maint/MeetingTypeEdit.jsp?dialog=1&id=<%=id %>&method=caller&from=<%=from %>"  target="tabcontentframe">
								<%=SystemEnv.getHtmlLabelName(2152,user.getLanguage())+(user.getLanguage()==8?" ":"")+SystemEnv.getHtmlLabelName(19467,user.getLanguage()) %>
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

<script type="text/javascript">

function closeWinAFrsh(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDlgARfsh();
}

function closeDialog(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDialog();
}

</script>