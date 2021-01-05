
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<%
	HashMap<String,String> kv = (HashMap)pack.packageParams(request, HashMap.class);
	String subcompanyId = Util.null2String(request.getParameter("subcompanyIdShare"));
	String url = "";
	String navName = "";
     String hasRightSub="";
	 boolean isUseDocManageDetach=ManageDetachComInfo.isUseDocManageDetach();
     if(isUseDocManageDetach){
	hasRightSub=SubCompanyComInfo.getRightSubCompany(user.getUID(),"DocShareRight:all",-1);
	if(!subcompanyId.equals("")){
	 hasRightSub=subcompanyId;
	}
	session.setAttribute("hasRightSub",hasRightSub);
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
			
			
			
		   
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	     </div>
			</div>
		</div>
	    <div class="tab_box">
	        
	            <iframe src="/docs/search/DocMain.jsp?urlType=15&from=shareManageDoc&isDetach=3&subcompanyId=<%=subcompanyId%>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        
	    </div>
	</div>     
</body>
</html>


