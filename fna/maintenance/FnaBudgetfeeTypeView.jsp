<%@page import="org.json.JSONObject"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.conn.RecordSet"%>

<%@page import="weaver.fna.general.FnaSplitPageTransmethod"%><HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script type="text/javascript">
jQuery(function(){
    jQuery('.e8_box').Tabs({
        getLine:1,
        contentID:"#divMainInfo",
        iframe:"tabcontentframe",
        mouldID:"<%=MouldIDConst.getID("fna") %>",
        objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(33175, user.getLanguage())) %>,
        staticOnLoad:true
    });
});
</script>
<!-- 自定义设置tab页 -->
<%
	// || HrmUserVarify.checkUserRight("FnaBudgetfeeTypeEdit:Edit",user)
	boolean canEdit = HrmUserVarify.checkUserRight("FnaLedgerAdd:Add",user) || HrmUserVarify.checkUserRight("FnaLedgerEdit:Edit",user);
	if(!canEdit){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}

	RecordSet rs = new RecordSet();
	
	int subjectId = Util.getIntValue(request.getParameter("subjectId"),0);
	if(subjectId < 0){
		subjectId = 0;
	}

	String subjectName = "";
	int feelevel = 0;
	
	String sql = "select * from FnaBudgetfeeType a where a.id = "+subjectId;
	rs.executeSql(sql);
	if(rs.next()){
		subjectName = Util.null2String(rs.getString("name")).trim();
		feelevel = Util.getIntValue(rs.getString("feelevel"), 999);
	}
	if("".equals(subjectName)){
		subjectName = SystemEnv.getHtmlLabelName(33175, user.getLanguage());//科目设置
	}
	
	String xjLable = SystemEnv.getHtmlLabelName(27170,user.getLanguage());//下级
	if(feelevel==0){
		xjLable = "";
	}
	String feelevelName = new FnaSplitPageTransmethod().getSubjectLevel(feelevel+"", user.getLanguage()+"");
	
	String urlDef = "/fna/maintenance/FnaBudgetfeeTypeGridViewInner.jsp?subjectId="+subjectId;
%>
</head>			        
<BODY scroll="no">
	<div class="e8_box demo2">
	<div class="e8_boxhead">
		<div class="div_e8_xtree" id="div_e8_xtree"></div>
        <div class="e8_tablogo" id="e8_tablogo" onclick="mnToggleleft(this);"></div>
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
	            <iframe src="<%=urlDef %>" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
<script type="text/javascript">
function mnToggleleft(obj){
	if(window!=null&&window.parent!=null&&window.parent.oTd1!=null&&window.parent.oTd1.style!=null){
		var f = window.parent.oTd1.style.display;
		if(f==null||f==""){
			obj.innerHTML=obj.innerHTML.replace("&lt;&lt;","&gt;&gt;");
			window.parent.oTd1.style.display='none';
		}else{
			obj.innerHTML=obj.innerHTML.replace("&gt;&gt;","&lt;&lt;");
			window.parent.oTd1.style.display='';
		}
	}
}
jQuery(document).ready(function(){
	setTabObjName("<%=subjectName%>");
});
</script>
</html>

