
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.cowork.CoworkDAO"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.cowork.CoworkLabelVO"%>
<jsp:useBean id="CoworkItemMarkOperation" class="weaver.cowork.CoworkItemMarkOperation" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
int userid=user.getUID();
String layout=Util.null2String(request.getParameter("layout"),"1");
String jointype=Util.null2String(request.getParameter("jointype"));
String menuType=Util.null2String(request.getParameter("menuType"),"discuss");

String iframesrc="/cowork/CoworkTabFrame.jsp?layout="+layout+"&jointype="+jointype;
if(menuType.equals("themeApproval"))  //主题审批
	iframesrc="/cowork/CoworkTabFrame.jsp?layout="+layout+"&jointype=5";
else if(menuType.equals("contentApproval")){ //内容审批
	iframesrc="/cowork/CoworkDiscussFrame.jsp?layout="+layout;
}else if(menuType.equals("themeMonitor")){   //主题监控
	iframesrc="/cowork/CoworkMonitorFrame.jsp?layout="+layout;
}else if(menuType.equals("contentMonitor")){ //内容监控
	iframesrc="CoworkMonitorContent.jsp?layout="+layout;
}


String width="100%";
if(layout.equals("1")) width="478px";
%>

<link rel="stylesheet" href="/css/ecology8/request/leftNumMenu_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/leftNumMenu_wev8.js"></script>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/cowork/coworkview_wev8.js"></script>

<style>
.layout_right1{height:100%}
.layout_right2{position: absolute;left: 275px;top:0px;right:0px;height:100%;}
.layout_left1{position: absolute;left: 0px;top:0px;width:275px;height:570px;overflow: hidden;}
.layout_left2{position: absolute;left: 0px;top:0px;width:275px;bottom:0px;overflow: hidden;}
</style>
<%
	CoworkDAO coworkdao=new CoworkDAO();
	Map mainTotal=coworkdao.getCoworkCount(user,"main");
	Map subTotal=coworkdao.getCoworkCount(user,"sub");
	String leftMenus="";
	String sql="select * from cowork_maintypes ORDER BY id asc";
	RecordSet.execute(sql);
	while(RecordSet.next()){
		String mainTypeId=RecordSet.getString("id");
		String mainTypeName=RecordSet.getString("typename");
		String mainflowAll=mainTotal.containsKey(mainTypeId)?(String)mainTotal.get(mainTypeId):"0";
		
		String submenus="";           
		sql="SELECT * from cowork_types where departmentid="+mainTypeId+" ORDER BY id asc";
		rs.execute(sql);
		while(rs.next()){
			String subTypeId=rs.getString("id");
			String subTypeName=rs.getString("typename");
			String subflowAll=subTotal.containsKey(subTypeId)?(String)subTotal.get(subTypeId):"0";
			submenus+=",{name:'"+subTypeName+"',"+
						 "attr:{subTypeId:'"+subTypeId+"',parentid:'"+mainTypeId+"'},"+
						 "numbers:{flowAll:"+subflowAll+"}"+
           				"}";
		}
		submenus=submenus.length()>0?submenus.substring(1):submenus;
		submenus="["+submenus+"]";
		String info = rs.getCounts()!=0?"":"hasChildren:false,";
		leftMenus+=",{"+
					 "name:'"+mainTypeName+"',"+info+
					 "attr:{mainTypeId:'"+mainTypeId+"'},"+
					 "numbers:{flowAll:"+mainflowAll+"},"+
					 "submenus:"+submenus+
		 		   "}";
	}
	leftMenus=leftMenus.length()>0?leftMenus.substring(1):leftMenus;
	leftMenus="["+leftMenus+"]";
%>
</head>
<body scroll="no">
	
	
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;"  >

	<tr>
		<td class="leftTypeSearch">
			<div class="topMenuTitle">
				<span class="leftType">
				<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"/></span>
				<span><%=SystemEnv.getHtmlLabelName(21979,user.getLanguage())%></span>
				</span>
				<span class="leftSearchSpan">
					&nbsp;<input type="text" class="leftSearchInput" />
				</span>
			</div>
		</td>
		
		<td rowspan="2">
			<iframe src="<%=iframesrc%>" class="flowFrame" id="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		</td>
	</tr>
	
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div class="flowMenuDiv"  >
				<div style="overflow-y:scroll ;height:100%;position:relative;" id="overFlowDiv" >
					<div class="ulDiv" ></div>
				</div>
			</div>
		</td>
	</tr>
</table>	
	
</body>
<script>
  var layout="<%=layout%>";
  var jointype="<%=jointype%>";
  
  var demoLeftMenus=eval("(<%=leftMenus%>)");
  var menuUrl="<%=iframesrc%>";
  
  $(document).ready(function(){
  	
  	if(layout=="1"){		
	  	$("#flowFrame").bind("resize",function(){
	  	
	  		var centerDiv=$(this).contents().find("#tabcontentframe").contents().find(".centerDiv");
	  		
	  		var northDivWidth=$(this).contents().find("#tabcontentframe").contents().find(".northDiv").width();
	  		var leftMenuWidth=$(".flowMenusTd").width();
	  		
	  		if($(".flowMenusTd").is(":hidden")){
	  			centerDiv.parent().css("width",document.body.clientWidth-northDivWidth-8);
	  			centerDiv.css("width",document.body.clientWidth-northDivWidth-8);
	  		}else{
	  			centerDiv.parent().css("width",document.body.clientWidth-northDivWidth-leftMenuWidth-8);
	  			centerDiv.css("width",document.body.clientWidth-northDivWidth-leftMenuWidth-8);
	  		}
	  		
	  	});	
	}	
	    
  });
   
</script>
</html>

