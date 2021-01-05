
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<%
	HashMap<String,String> kv = (HashMap)pack.packageParams(request, HashMap.class);
	String _fromURL = kv.get("_fromURL");
	String subcompanyId = Util.null2String(request.getParameter("subCompanyId"));
	String url = "";
	String navName = "";
	int detachable=0;
	boolean isUseDocManageDetach=ManageDetachComInfo.isUseDocManageDetach();
if(isUseDocManageDetach){
detachable=1;
}
	int isdetach = Util.getIntValue(request.getParameter("isDetach"),-1);
	if(detachable==1 && isdetach!=1&&isdetach!=3){
		if(_fromURL.equals("1")){//新闻设置
			response.sendRedirect("/docs/news/DocNews_frm.jsp?"+request.getQueryString());
			return;
		}
	}
	if(_fromURL.equals("1")){//新闻设置
		url = "/docs/news/DocNews.jsp";
		if(subcompanyId.equals("")){
			subcompanyId = Util.null2String(session.getAttribute("docdftsubcomid"));
		}
		session.setAttribute("docNews_subcompanyid",subcompanyId);
		navName = (detachable!=1 || subcompanyId.equals("")||subcompanyId.equals("0"))?SystemEnv.getHtmlLabelName(33436,user.getLanguage()):SubCompanyComInfo.getSubCompanyname(subcompanyId);
	}else if(_fromURL.equals("2")){//新闻类型设置
		url = "/docs/news/type/newstypeList.jsp";
		navName = SystemEnv.getHtmlLabelName(19859,user.getLanguage());
	}
%>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<script src="/js/tabs/expandCollapse_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />


<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("doc")%>",
        staticOnLoad:true,
        objName:"<%= navName%>"
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
		    <ul class="tab_menu">
		    	<%if(_fromURL.equals("1") && Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0)==1){ %>
			    	<li class="e8_tree">
				    	<a href="#">
			        		
			        	</a>
			        </li>
			    <%} %>
			    <li class="defaultTab" >
		        	<a href="#" target="tabcontentframe">
						<%=TimeUtil.getCurrentTimeString() %>
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
	            <iframe src="<%=url %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>

