<%@ page import="org.json.JSONObject"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>  
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<% 
String needsystem=Util.null2String(request.getParameter("needsystem"));
String from = Util.null2String(request.getParameter("from"));
String sqltag  = Util.null2String(request.getParameter("sqltag"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String workflowid = Util.null2String(request.getParameter("workflowid"));
String fieldid = Util.null2String(request.getParameter("fieldid"));
String billid = Util.null2String(request.getParameter("billid"));
String fromHrmStatusChange = "";
int uid=user.getUID();
String tabid="2";

if(!workflowid.equals("") && fieldid.equals("") && !billid.equals("")){
	RecordSet rs = new RecordSet();
	rs.executeSql("select * from workflow_billfield where fieldname = 'organizationid' and billid = " + billid);
	if(rs.next()){
		fieldid = rs.getString("id");
	}
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
</HEAD>
<body scroll="no">
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
		    		<li class="<%=tabid.equals("0") ?"current":"" %>">
			        	<a id="tabId0" href="javascript:resetbanner(0);">
			        		<%=SystemEnv.getHtmlLabelName(18770,user.getLanguage())%><!-- 按组织结构 --> 
			        	</a>
			      </li>
			      <li class="<%=tabid.equals("2") ?"current":"" %>">
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
        	<IFRAME name=frame1 id=frame1 width=100% height=190px frameborder=no scrolling=no onload="update();">
			//浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。
			</IFRAME> 
			<IFRAME name=frame2 id=frame2 src="/fna/browser/costCenter/single/FccBrowserList.jsp?sqltag=<%=sqltag%>&fromHrmStatusChange=<%=fromHrmStatusChange %>&tabid=<%=tabid%>&needsystem=<%=needsystem%>&from=<%=from%>&sqlwhere=<%=xssUtil.put(sqlwhere) %>&workflowid=<%=workflowid %>&fieldid=<%=fieldid %>" class="flowFrame" width=100%  height=345px frameborder=no scrolling="yes">
			//浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。
			</IFRAME>
        </div>
	    </div>
	</div>
<script language=javascript>
 jQuery('.e8_box').Tabs({
		getLine:1,
		iframe:"frame1",
		needNotCalHeight:true,
		//contentID:"#frame1",
	    mouldID:"<%=MouldIDConst.getID("fna") %>",
	    objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(515, user.getLanguage())) %>,
		staticOnLoad:true
	});

	function resetbanner(objid){
		var curDoc;
		if(document.all){
			curDoc=window.frames["frame2"].document
		}
		else{
			curDoc=document.getElementById("frame2").contentDocument	
		}
		if(objid == 0 ){
		  window.frame1.location="/fna/browser/costCenter/single/FccBrowserTree.jsp?sqltag=<%=sqltag%>&needsystem=<%=needsystem%>&from=<%=from%>&fromHrmStatusChange=<%=fromHrmStatusChange%>&sqlwhere=<%=xssUtil.put(sqlwhere) %>&workflowid=<%=workflowid%>&fieldid=<%=fieldid%>";
		  try{
		  	$(curDoc).find("#btnsub").css("display","none");
		  	$(curDoc).find("#btnsub").next().css("display","none");
			}catch(err){}	
		}else if(objid == 2){
			window.frame1.location="/fna/browser/costCenter/single/FccBrowserTab2.jsp?sqltag=<%=sqltag%>&needsystem=<%=needsystem%>&from=<%=from%>&fromHrmStatusChange=<%=fromHrmStatusChange%>&sqlwhere=<%=xssUtil.put(sqlwhere) %>&workflowid=<%=workflowid%>&fieldid=<%=fieldid%>";
			try{
		  	$(curDoc).find("#btnsub").css("display","");
		  	$(curDoc).find("#btnsub").next().css("display","");
			}catch(err){}	
		}
	}
	resetbanner(<%=tabid%>);
</script>
</body>
</html>