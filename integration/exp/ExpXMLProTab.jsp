
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.expdoc.ExpUtil"%>
<%@page import="weaver.conn.RecordSet"%>
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
if(!HrmUserVarify.checkUserRight("intergration:expsetting", user)){
	  response.sendRedirect("/notice/noright.jsp");
	  return;
}
	String navName = "";
	String urlType = Util.null2String((String)request.getParameter("urlType"));
	String queryString=request.getQueryString();
	
	int id = Util.getIntValue(Util.null2String(request.getParameter("id")), 0);//id
	
	String sql="";
	String proid="";
	String proType="";
	String proName = "";

	sql="select * from exp_ProList where id='"+id+"'";
	rs.execute(sql);
	if(rs.next()){
		proid=Util.null2String(rs.getString("Proid"));
		proType=Util.null2String(rs.getString("ProType"));
		proName = Util.null2String(rs.getString("proName"));
	}

	if("".equals(urlType)){
		urlType="1";
	}
	String url = "/integration/exp/ExpXMLProAdd.jsp?"+queryString;
	

	if("1".equals(urlType)){
		navName = SystemEnv.getHtmlLabelName(125760,user.getLanguage());//XML方案
		url = "/integration/exp/ExpXMLProAdd.jsp?"+queryString;
	}else if("2".equals(urlType)){
		if(proType.equals("0")){  //XML方案
		navName = SystemEnv.getHtmlLabelName(125760,user.getLanguage());//XML方案
		url = "/integration/exp/ExpXMLProEdit.jsp?proid="+proid+"&"+queryString;
		}else if(proType.equals("1")){  //数据库方案
			navName = SystemEnv.getHtmlLabelName(125761,user.getLanguage());//数据库方案
			url = "/integration/exp/ExpDBProEdit.jsp?proid="+proid+"&"+queryString;
		}
	}else if("3".equals(urlType)){
		navName = SystemEnv.getHtmlLabelName(125761,user.getLanguage());//数据库方案
		url = "/integration/exp/ExpDBProAdd.jsp?"+queryString;
	}
	
  	if(id>0 && !"".equals(proName)){
  		navName = proName;
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
		objName:"<xmp><%=navName.replace("\\","\\\\").replace("\"","\\\"")%></xmp>"
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
						<li class='current'>
					    	<a href="<%=url %>" target="tabcontentframe">
					    		<%=SystemEnv.getHtmlLabelName(82751,user.getLanguage())%>
								
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