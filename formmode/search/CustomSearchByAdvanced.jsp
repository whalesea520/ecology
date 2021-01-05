
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<jsp:useBean id="customSearchService" class="weaver.formmode.service.CustomSearchService" scope="page" />
<jsp:useBean id="FormModeRightInfo" class="weaver.formmode.search.FormModeRightInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
int customid = Util.getIntValue(request.getParameter("customid"));
int viewtype=Util.getIntValue(request.getParameter("viewtype"),0);
Map m = customSearchService.getCustomSearchById(customid);
String customName = Util.null2String(m.get("customname"));
String customDesc = Util.null2String(m.get("customdesc"));
String tempquerystring = Util.null2String(request.getQueryString());
tempquerystring  = new String(tempquerystring.getBytes("ISO8859_1"), "UTF-8");
String customidStr = "";
if(tempquerystring.indexOf("customid=")==-1){
	customidStr ="customid="+customid+"&";
}
rs.execute("select modeid from mode_customsearch a where a.id="+customid);
String modeid = "0";
if(rs.next()){
    modeid=""+Util.getIntValue(rs.getString("modeid"),0);
}
//============================================权限判断====================================
boolean isRight = false;
if(viewtype == 3){//监控权限判断
	boolean isHavepageRight = FormModeRightInfo.isHavePageRigth(customid,4);
	if(isHavepageRight){
		FormModeRightInfo.setUser(user);
		isRight = FormModeRightInfo.checkUserRight(customid,4);
	}
	else{  //如果自定义查询页面无监控权限，则检查全局监控权限
		ModeRightInfo.setModeId(Util.getIntValue(modeid));
		ModeRightInfo.setType(viewtype);
		ModeRightInfo.setUser(user);
		
		isRight = ModeRightInfo.checkUserRight(viewtype);
	}
}else{
	//自定义页面查看权限
	rs.executeSql("select * from mode_searchPageshareinfo where righttype=1 and pageid = " + customid);
	if(rs.next()){  
		FormModeRightInfo.setUser(user);
		isRight = FormModeRightInfo.checkUserRight(customid,1);
	}else{  //没有设置任何查看权限数据，则认为有权限查看
		isRight = true;
	}
}

if(!isRight){
	//response.sendRedirect("/notice/noright.jsp");
	out.println("<script>window.location.href='/notice/noright.jsp';</script>");
	return;
}

String treesqlwhere = Util.null2String(request.getParameter("treesqlwhere"));
String treenodeid = Util.null2String(request.getParameter("treenodeid"));

String url = "/formmode/search/CustomSearchByAdvancedIframe.jsp?"+customidStr+tempquerystring+"&treesqlwhere="+treesqlwhere+"&treenodeid="+treenodeid+"&fromadvanced=1";
%>
<!DOCTYPE html><HEAD>
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
        mouldID:"<%= MouldIDConst.getID("formmode")%>",
        staticOnLoad:true,
        objName:"<%=customName%>"
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
					<span id="objName" title="<%=customDesc %>"></span>
				</div>
				<div>	
			    <ul class="tab_menu">
				    <li class="current">
						<a href="<%=url %>" target="tabcontentframe">
							<%=SystemEnv.getHtmlLabelName(1889,user.getLanguage()) %><!-- 高级查询条件 -->
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

