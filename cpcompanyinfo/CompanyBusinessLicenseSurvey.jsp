<%@page import="org.json.JSONObject"%>
<%@page import="weaver.fna.budget.BudgetYear"%>
<%@page import="weaver.fna.budget.BudgetHandler"%>
<%@page import="weaver.fna.general.FnaBudgetLeftRuleSet"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.conn.RecordSet"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="cu" class="weaver.company.CompanyUtil" scope="page" />
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<!-- 自定义设置tab页 -->
<%	
HashMap<String, String> kv = (HashMap<String,String>)pack.packageParams(request, HashMap.class);
String _fromURL = Util.null2String(kv.get("_fromURL"));//来源

String companyid = Util.null2String(request.getParameter("companyid"));
boolean maintFlag = false;
if(cu.canOperate(user,"2")||cu.canOperate(companyid,user,"2"))//后台维护权限
{
	maintFlag = true;
}
//很关键的一个变量，用于判断后续页面是否开发编辑权限
//0--只有这个公司的查看权限，没有维护权限
//1--拥有这个公司查看和维护全县
String showOrUpdate =Util.null2String(request.getParameter("showOrUpdate"));

String companyname = "";
String archivenum = "";
/* 公司基本表*/
String sqlinfo = "select * from CPCOMPANYINFO where companyid = " + companyid;
rs.execute(sqlinfo);
if(rs.next()){
	companyname = rs.getString("COMPANYNAME");
	archivenum = rs.getString("ARCHIVENUM");
}

String frmSrc = "/cpcompanyinfo/CompanyBusinessLicenseList.jsp?companyid="+companyid+"&showOrUpdate="+showOrUpdate+"&maintFlag="+maintFlag;

%>
<script type="text/javascript">
jQuery(function(){
    jQuery('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%=MouldIDConst.getID("cpcompany") %>",
        objName:<%=JSONObject.quote(companyname+"     "+archivenum) %>,
        staticOnLoad:true
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
					<li class="defaultTab">
						<a href="#">
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
	            <iframe src="<%=frmSrc %>" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>

