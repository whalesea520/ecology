
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("intergration:outtersyssetting", user)){
	  response.sendRedirect("/notice/noright.jsp");
	  return;
}
	String navName = "";
	String urlType = Util.null2String((String)request.getParameter("urlType"));
	String typename = Util.null2String(request.getParameter("typename"));/*QC342902 [80]支持CoreMail集成 */
	String queryString=request.getQueryString();
	if("".equals(urlType)){
		urlType="1";
	}
	String url = "/interface/outter/OutterSysAdd.jsp?"+request.getQueryString();
	if("1".equals(urlType)){
		navName =SystemEnv.getHtmlLabelName(20961 ,user.getLanguage());
		/*QC342902 [80]支持CoreMail集成  start*/
		if("8".equals(typename))
			url = "/interface/outter/OutterSysAdd_coremail.jsp?"+request.getQueryString();
		else
			url = "/interface/outter/OutterSysAdd.jsp?"+request.getQueryString();
		
	}else if("2".equals(urlType)){
		navName = Util.null2String(request.getParameter("id"));
		navName = java.net.URLDecoder.decode(navName,"UTF-8");
		rs.executeSql("select * from outter_sys where sysid='"+navName+"'");
		if(rs.next()){
			navName = Util.null2String(rs.getString("name"));
			typename = Util.null2String(rs.getString("typename"));
			
			//System.out.println(navName);
		}
		if("8".equals(typename))
			url = "/interface/outter/OutterSysEdit_coremail.jsp?"+request.getQueryString();
		else
			url = "/interface/outter/OutterSysEdit.jsp?"+request.getQueryString();
	   /*QC342902 [80]支持CoreMail集成  end*/
	}

%>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("integration")%>",
        staticOnLoad:true,
        notRefreshIfrm:true,
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
<%if("1".equals(urlType)){ %>
					<ul class="tab_menu">
						<li class='current'>
							<a href="<%=url %>" target="tabcontentframe">
								<%=SystemEnv.getHtmlLabelName(82751,user.getLanguage())%>
							</a>
						</li>
					</ul>
<%
}else if("2".equals(urlType)){ 
	//System.out.println("====="+queryString);
%>
					<ul class="tab_menu">
						<li class='current'>
							<a href="<%=url %>" target="tabcontentframe">
								<%=SystemEnv.getHtmlLabelName(82751,user.getLanguage())%>
							</a>
						</li>
						<li>
							<a href="/interface/outter/OutterSysShare.jsp?<%=queryString%>" target="tabcontentframe">
								<%=SystemEnv.getHtmlLabelName(82752,user.getLanguage())%>
							</a>
						</li>
							
							
					</ul>
<%
}
%>
					<div id="rightBox" class="e8_rightBox"></div>
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
</html>