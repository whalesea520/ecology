
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
String strKeyword=Util.null2String(request.getParameter("strKeyword"));
String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));

int uid=user.getUID();
    String resourcemulti = null;
    Cookie[] cks = request.getCookies();

    for (int i = 0; i < cks.length; i++) {

        if (cks[i].getName().equals("WorkflowKeywordBrowserMulti" + uid)) {
            resourcemulti = cks[i].getValue();
            break;
        }
    }

    String tabid="0";
if(resourcemulti!=null&&resourcemulti.length()>0){
String[] atts=Util.TokenizerString2(resourcemulti,"|");
tabid=atts[0];

}
%>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<STYLE type=text/css>
PRE {
}
A {
	COLOR:#000000;FONT-WEIGHT: bold; TEXT-DECORATION: none
}
A:hover {
	COLOR:#56275D;TEXT-DECORATION: none
}
</STYLE>


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
<IFRAME name=frame1 id=frame1  width=100% onload="update();" height="160px" frameborder=no scrolling=no>
</IFRAME>

<IFRAME name=frame2 id=frame2 src="/docs/sendDoc/WorkflowKeywordBrowserMultiSelect.jsp?tabid=<%=tabid%>&strKeyword=<%=strKeyword%>&sqlwhere=<%=xssUtil.put(sqlwhere)%>" width=100% class="flowFrame"  height="370px" frameborder=no scrolling=no>
</IFRAME>
</div>
	    </div>
	</div>



<script language=javascript>
jQuery('.e8_box').Tabs({
	getLine:1,
	iframe:"frame1",
	needNotCalHeight:true,
  mouldID:"<%=MouldIDConst.getID("doc") %>",
  objName:"<%=SystemEnv.getHtmlLabelName(16978, user.getLanguage()) %>",
	staticOnLoad:true
});
var tabid = null;
function resetbanner(objid){
	tabid = objid;
	if(tabid==0){
		document.getElementById("frame1").src = "/docs/sendDoc/WorkflowKeywordBrowserMultiSearchByOrgan.jsp?sqlwhere=<%=sqlwhere%>";
	}else if(tabid==2){
		document.getElementById("frame1").src = "/docs/sendDoc/WorkflowKeywordBrowserMultiSearch.jsp?sqlwhere=<%=sqlwhere%>";
	}
}

resetbanner(<%=tabid%>);
</script>

</body>
</html>