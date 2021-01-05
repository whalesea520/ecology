<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.JSONObject"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String rightStr=Util.null2String(request.getParameter("rightStr"));
String selectedids=Util.null2String(request.getParameter("selectedids"));
String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));
String fromHrmStatusChange = Util.null2String(request.getParameter("fromHrmStatusChange"));
String tabid="0";


%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
</HEAD>
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
			    <ul class="tab_menu">
		    		<li class="<%=tabid.equals("0")?"current":"" %>">
			        	<a id="tabId0" href="javascript:resetbanner(0);">
			        		<%=SystemEnv.getHtmlLabelName(18770,user.getLanguage())%><!-- 按组织结构 --> 
			        	</a>
			      </li>
			      <li class="<%=tabid.equals("1")?"current":"" %>">
			        	<a id="tabId1" href="javascript:resetbanner(1);">
			        		<%=SystemEnv.getHtmlLabelName(18771,user.getLanguage())%><!-- 按定义的组 --> 
			        	</a>
			      </li>
		    		<li class="<%=tabid.equals("2")?"current":"" %>">
			        	<a id="tabId2" href="javascript:resetbanner(2);">
			        		<%=SystemEnv.getHtmlLabelName(18412,user.getLanguage())%><!-- 组合查询 --> 
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
        		<IFRAME name=frame1 id=frame1 width="100%" onload="update();" height="160px" frameborder=no scrolling=no>
						<%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%></IFRAME>
            <iframe  id="frame2" name="frame2" class="flowFrame" src="/hrm/resource/MultiSelectByRight.jsp?rightStr=<%=rightStr %>&sqlwhere=<%=xssUtil.put(sqlwhere)%>&selectedids=<%=selectedids%>&tabid=<%=tabid %>&fromHrmStatusChange=<%=fromHrmStatusChange%>" frameborder="0" height="375px" width="100%"></iframe>
        </div>
	    </div>
	</div>
<script language=javascript>
	var tabid = null;
	function resetbanner(objid){
		tabid=objid;
		if(tabid == 0 ){		        
    	document.getElementById("frame1").src="/hrm/resource/SearchByOrganByRight.jsp?rightStr=<%=rightStr %>&sqlwhere=<%=xssUtil.put(sqlwhere)%>&selectedids=<%=selectedids%>&fromHrmStatusChange=<%=fromHrmStatusChange%>"
    }else if(tabid == 1){
			document.getElementById("frame1").src="/hrm/resource/SearchByGroupByRight.jsp?rightStr=<%=rightStr %>&sqlwhere=<%=xssUtil.put(sqlwhere)%>&selectedids=<%=selectedids%>&fromHrmStatusChange=<%=fromHrmStatusChange%>"
		}else if(tabid == 2){
			document.getElementById("frame1").src="/hrm/resource/SearchByRight.jsp?rightStr=<%=rightStr %>&sqlwhere=<%=xssUtil.put(sqlwhere)%>&selectedids=<%=selectedids%>&fromHrmStatusChange=<%=fromHrmStatusChange%>";
		}
	}

	resetbanner(<%=tabid%>);
	
	jQuery('.e8_box').Tabs({
	getLine:1,
	iframe:"frame1",
	needNotCalHeight:true,
	//contentID:"#frame1",
  mouldID:"<%=MouldIDConst.getID("resource") %>",
  objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(33210, user.getLanguage())) %>,
	staticOnLoad:true
});
</script>

</body>
</html>