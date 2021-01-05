
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MatrixManager" class="weaver.matrix.MatrixManager" scope="page" />
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>


<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(33943,user.getLanguage());
//矩阵id
String matrixid=request.getParameter("matrixid");
String issystem=request.getParameter("issystem");

//优先展示 字段维护  还是 数据维护。0 是字段维护  1是数据维护
String showtype=request.getParameter("showtype");

//确定是否展示 数据维护 tab 页
boolean datatableshow = false;
if(!"".equals(matrixid)){
  RecordSet.executeSql("select * from matrixfieldinfo where matrixid="+matrixid);
  if(RecordSet.next()) datatableshow = true;
}

//矩阵维护权限
boolean canmaint = HrmUserVarify.checkUserRight("Matrix:Maint",user);

//判断是否矩阵维护者
String matrixids = MatrixManager.getUserPermissionMatrixids(user);
String matrixidStr[] = matrixids.split(",");
boolean canedit = false;
boolean isManager = false;  //是否矩阵维护者
	for(int i =0;i<matrixidStr.length;i++){
		if(matrixid.equals(matrixidStr[i])){
			isManager=true;
		}
	}
if(canmaint || isManager){
	canedit = true;
}

%>

<script type="text/javascript">

$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        mouldID:"<%= MouldIDConst.getID("resource")%>",
        iframe:"tabcontentframe",
        staticOnLoad:true,
        objName:"<%=SystemEnv.getHtmlLabelName(33926,user.getLanguage()) %>"
    });

   	attachUrl();
}); 

function refreshTab() {
	jQuery('.flowMenusTd', parent.document).toggle();
	jQuery('.leftTypeSearch', parent.document).toggle();
}

function attachUrl(){
	var requestParameters=$(".voteParameterForm").serialize();
	$("a[target='tabcontentframe']").each(function(){
		var url = "";
	    if($(this).attr("urs"))url = $(this).attr("urs");
		url += "?"+requestParameters;
		$(this).attr("href",url);
	});
	$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(0)").attr("href"));
	
}
</script>

</head>



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
	    
		<ul class="tab_menu" >
		    <% if(canedit){//有权限 %>
					    <%if("1".equals(showtype)){ %>
					             <% if(datatableshow){ %>
									<li class="current">
										<a href="" urs='matrixtable.jsp' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(33933, user.getLanguage()) %></a>
									</li>
							    <%} %>
							    <%if("".equals(issystem)){ %>
								    <li  <% if(!datatableshow){ %>class="current" <%} %>>
										<a href="" urs='MatrixDesignList.jsp' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(33943, user.getLanguage()) %></a>
									</li>
					            <%} %>
								
					    <%}else{ %>
					    		<%if("".equals(issystem)){ %>
						            <li class="current">
										<a href="" urs='MatrixDesignList.jsp' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(33943, user.getLanguage()) %></a>
									</li>
								 <%} %>
								<% if(datatableshow){ %>
									<li >
										<a href="" urs='matrixtable.jsp' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(33933, user.getLanguage()) %></a>
									</li>
							    <%} %>
					    <%} %>
			<% } else if(!canedit && datatableshow){%>
			     <li class="current">
					 <a href="" urs='matrixtable.jsp' target="tabcontentframe"><%=SystemEnv.getHtmlLabelName(33933, user.getLanguage()) %></a>
				 </li>
			<%} %>
		</ul>
		 <div id="rightBox" class="e8_rightBox">
	    </div>
	    	</div>
		</div>
	</div>
		<div class="tab_box">
		<iframe onload="update()" src="" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		<form class="voteParameterForm">
			<input type="hidden" name="canedit" value="<%=canedit %>" class="requestParameters">
			<%
				Enumeration<String> e=request.getParameterNames();
				while(e.hasMoreElements()){
					String paramenterName=e.nextElement();
					String value=request.getParameter(paramenterName);
					//System.out.println(paramenterName + ":" + value);
					%>
						<input type="hidden" name="<%=paramenterName %>" value="<%=value %>" class="requestParameters">
					<% 
				}
				
			%>
		</form>
	</div></div>
</body>
</html>

