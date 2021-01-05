<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("proj")%>",
        staticOnLoad:true
    });
    attachUrl();
}); 
</script>
<link rel="stylesheet" href="/proj/css/common_wev8.css" type="text/css" />
<!-- 自定义设置tab页 -->
<%
	String url = "";
	int taskid =Util.getIntValue( Util.null2String(request.getParameter("taskid")),0);
	String type = Util.null2String(request.getParameter("type"));
	url = "ViewTask.jsp?isfromProjTab=1&taskrecordid="+taskid;
	RecordSet.executeSql("select * from prj_taskprocess where id="+taskid);
	RecordSet.next();
	String subject=Util.null2String( RecordSet.getString("subject"));
	String prjid=Util.null2String( RecordSet.getString("prjid"));
	String status_prj=Util.null2String( RecordSet.getString("status"));
	String parenthrmids=Util.null2String( RecordSet.getString("parenthrmids"));
	String hrmid=Util.null2String( RecordSet.getString("hrmid"));
	
	
%>
<script type="text/javascript">
function attachUrl()
{
	
	if("<%=type%>"=="doc")
	{
		$("a[target='tabcontentframe']").parent("li").removeClass("current");
		$("a[target='tabcontentframe']:eq(5)").parent("li").addClass("current");
		$("#tabcontentframe").attr("src","/proj/process/DspTaskReference.jsp?ProjID=<%=prjid %>&taskrecordid=<%=taskid %>&src=doc");
	}
	
} 
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
	       			<li class="current">
						<a target="tabcontentframe" href="<%=url %>"><%=SystemEnv.getHtmlLabelNames("83789",user.getLanguage())%></a>
					</li>
					<li>
						<a target="tabcontentframe" href="/proj/process/ViewPrjTaskSub.jsp?ProjID=<%=prjid %>&parenttaskid=<%=taskid %>&parenthrmid=<%=hrmid %>"><%=SystemEnv.getHtmlLabelNames("2098",user.getLanguage())%></a>
					</li>
					<li>
						<a target="tabcontentframe" href="/proj/process/ViewPrjDiscuss.jsp?types=PT&sortid=<%=taskid %>"><%=SystemEnv.getHtmlLabelNames("15153",user.getLanguage())%><span class="num" style="display:none;" id="discussNum_span"></span></a>
					</li>
					<li>
						<a target="tabcontentframe" href="/proj/task/PrjTaskShareDsp.jsp?capitalid=<%=taskid %>"><%=SystemEnv.getHtmlLabelNames("2112",user.getLanguage())%></a>
					</li>
					<li>
						<a target="tabcontentframe" href="/proj/process/DspTaskReference.jsp?parenthrmids=<%=parenthrmids %>&status_prj=<%=status_prj %>&ProjID=<%=prjid %>&src=req&taskrecordid=<%=taskid %>"><%=SystemEnv.getHtmlLabelNames("1044",user.getLanguage())%><span id="reqNum_span"></span></a>
					</li>
					<li>
						<a target="tabcontentframe" href="/proj/process/DspTaskReference.jsp?parenthrmids=<%=parenthrmids %>&status_prj=<%=status_prj %>&ProjID=<%=prjid %>&src=doc&taskrecordid=<%=taskid %>"><%=SystemEnv.getHtmlLabelNames("857",user.getLanguage())%><span id="docNum_span"></span></a>
					</li>
					<li>
						<a target="tabcontentframe" href="/proj/process/DspTaskReference.jsp?parenthrmids=<%=parenthrmids %>&status_prj=<%=status_prj %>&ProjID=<%=prjid %>&src=crm&taskrecordid=<%=taskid %>"><%=SystemEnv.getHtmlLabelNames("783",user.getLanguage())%><span id="crmNum_span"></span></a>
					</li>
					<li>
						<a target="tabcontentframe" href="/proj/process/DspTaskReference.jsp?parenthrmids=<%=parenthrmids %>&status_prj=<%=status_prj %>&ProjID=<%=prjid %>&src=cpt&taskrecordid=<%=taskid %>"><%=SystemEnv.getHtmlLabelNames("858",user.getLanguage())%><span id="cptNum_span"></span></a>
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
<script type="text/javascript">	
$(function(){
	var objname='<%=subject %>';
	setTabObjName(objname);
});

$(function(){//加载tab数值
	getDiscussNum("getnum",'PT','<%=taskid %>');
});
function getDiscussNum(src,type,sortid){
	jQuery.ajax({
		url : "/proj/process/PrjGetDiscussNumAjax.jsp",
		type : "post",
		async : true,
		processData : true,
		data : {src:src,type:type,sortid:sortid},
		dataType : "json",
		success: function do4Success(data){
			if(data){
				if(data.count&&data.count>0){
					$("#discussNum_span").html(data.count).show();
				}
			}
		}
	});
}
function refreshOpener(){
	try{
		opener.location.href=opener.location.href;
	}catch(e){}
	
}
</script>
</body>
</html>

