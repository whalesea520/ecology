<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.general.GCONST"%>
<%@ page import="java.io.*"%>
<%@ include file="/jsp/systeminfo/init_wev8.jsp"%> 
<jsp:useBean id="ConfigInfo" class="com.weaver.function.ConfigInfo" scope="page"/>
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
<%
if(ConfigInfo.getEcologypath() == null || "".equals(ConfigInfo.getEcologypath())) {
	String servletPath = request.getSession().getServletContext().getRealPath("/");
	ConfigInfo.setEcologypath(servletPath);
}
	String operation = Util.null2String(request.getParameter("operation"));
	int userid= user.getUID();
	if(userid!=1) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
%>
<html>
 <head>
 
	<title> E-cology升级程序</title>

	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<script type="text/javascript">
	var operation = '<%=operation%>';
	</script>
	<script type="text/javascript" src="/js/updateclient/index.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
	<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<%
String type= Util.null2String(request.getParameter("type"));
String url = "/verifyBeforeForward.do?type=local";
String navName = "";
boolean processSql = false;
if("1".equals(type)) {//本地升级
	url = "/verifyBeforeForward.do?type=local";
	navName = SystemEnv.getHtmlLabelName(127349,user.getLanguage());
} else if("2".equals(type)) {//远程升级
	url = "/verifyBeforeForward.do?type=remote";
	navName = SystemEnv.getHtmlLabelName(127350,user.getLanguage());
} else if("3".equals(type)) {//还原
	url = "/prepareToRecover.do?type=prepareToRecover";
	navName = SystemEnv.getHtmlLabelName(589,user.getLanguage());
} else if("4".equals(type)) {//参数设置
	url = "/jsp/selectdirectory.jsp";
	navName = SystemEnv.getHtmlLabelName(17632,user.getLanguage());
} else if("5".equals(type)) {//升级记录
	url = "/jsp/updateView.jsp";
	navName = SystemEnv.getHtmlLabelName(17632,user.getLanguage());
} else if("6".equals(type)) {//代码认证
	url = "/jsp/keyCompare.jsp";
	navName = SystemEnv.getHtmlLabelName(127698,user.getLanguage());
} else if("7".equals(type)) {
	url = "/jsp/sqlLog.jsp";
	navName = "脚本执行效率报表";
}

Properties prop = new Properties();
FileInputStream fis = new FileInputStream(GCONST.getRootPath() +"WEB-INF"+ File.separatorChar 
		+ "prop" + File.separatorChar+"Upgrade.properties");

prop.load(fis);
int upgradeStatus=Util.getIntValue(prop.getProperty("STATUS"),3);
int pagestatus = Util.getIntValue(prop.getProperty("PAGESTATUS"),0);//

String classbeanbak= Util.null2String(baseBean.getPropValue("ecologyupdate","classbeanbak"));
String upgradetype= Util.null2String(baseBean.getPropValue("ecologyupdate","upgradetype"));


if("1".equals(type)&&(upgradeStatus != 0 || pagestatus == 3 || pagestatus == 2)) {//
	url = "/jsp/processSql.jsp";
	navName = SystemEnv.getHtmlLabelName(17530,user.getLanguage());
	processSql = true;
}

%>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"iframe1",
        mouldID:"<%= MouldIDConst.getID("integration")%>",
        staticOnLoad:true,
        notRefreshIfrm:true,
        objName:"<%=navName%>"
    });
}); 

$("document").ready(function(){
	var type = "<%=type %>";
	var processSql = "<%=processSql %>";
	if(processSql == "false") {
	 	$.get('/checkProcess.do',function(res){
			  //var backuppath = $("#backuppath").val();
			 var checkpro = res.checkProcess;
			
	     	  if(checkpro == "0"||checkpro == "1"||checkpro == "2") {
	     		 $("#iframe1").attr("src","/jsp/check.jsp?checkpro="+checkpro);
	     	  }
		});	
	 	
	 	$.get('/getProcess.do',function(res){
	 		 var pro = res.progress;
 			 var backuppath = res.backuppath;
	     	  if(""!=pro&&"0"!=pro&&undefined!=pro&&(type=="1"||type=="2")) {
	     		  $("#iframe1").attr("src","/jsp/upgradefiles.jsp?process="+pro+"&backuppath="+backuppath);
	     		  $("#objName").val("<%=SystemEnv.getHtmlLabelName(589,user.getLanguage())%>");
	     	  }
	     	  
	  		//升级成功页面
	  		var classbeanbak = "<%=classbeanbak%>";
	  		var upgradetype = "<%=upgradetype%>";
	  		var upgradeStatus = "<%=upgradeStatus%>";
	  		//文件备份覆盖完成  脚本执行完成
	  		if(pro=="0"&&upgradeStatus=="0"&&""!=classbeanbak&&"1"==upgradetype) {
	  			 $("#iframe1").attr("src","/jsp/upgradesuccess.jsp");
	  		}
		});

	}
});
<%
if("1".equals(type)||"2".equals(type)||"".equals(type)) {
%>
$("document").ready(function(){
	$.ajax({
		url:'<%=url%>',
		error : function(res,status){
			$("#iframe1").attr("src","/jsp/message.jsp?errortype=3");
		}
	});

});
<%}%>
</script>
 </head>

<body style="height:100%;width:100%;">
<iframe id="iframe1" name="iframe1" src="<%=url %>" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>	
</body>
</html>