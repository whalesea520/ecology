
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />


<%
	HashMap<String,String> kv = (HashMap)pack.packageParams(request, HashMap.class);
	String _fromURL = Util.null2String(kv.get("_fromURL"));
	String url = "";
	String subcompanyId = Util.null2String(request.getParameter("subCompanyId"));
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("docdetachable")),0);
	if(subcompanyId.equals("")){
		subcompanyId = Util.null2String(session.getAttribute("docdftsubcomid"));
	}

	String titlename = "";
	String id = Util.null2String(request.getParameter("id"));
	RecordSet.executeSql("select reportname from Workflow_Report where id="+id);
	if(RecordSet.next()){
		titlename = RecordSet.getString("reportname");
	}
	url = "/workflow/report/ReportCondition.jsp?id="+id;
%>

<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"",
        staticOnLoad:true,
        objName:"<%=titlename%>"
    });
 
 }); 

</script>

</head>
<BODY scroll="no">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
	<div class="e8_box demo2">
		<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
			<div class="e8_tablogonew" id="e8_tablogonew"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span ><%=titlename%></span>
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
</div>    
</body>
</html>


