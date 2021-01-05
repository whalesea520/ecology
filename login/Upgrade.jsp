<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.general.MathUtil,weaver.general.GCONST,weaver.general.StaticObj,
                 weaver.system.SysUpgradeCominfo,weaver.general.TimeUtil"%>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.file.*,weaver.hrm.common.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.lang.reflect.Field" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="suc" class="weaver.system.SysUpgradeCominfo" scope="page" />
<link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
<script type="text/javascript" src="/js/jquery/jquery_wev8.js"></script>

<link href="/css/commom_wev8.css" type="text/css" rel="stylesheet">
<style>
.btnclass {
	margin-top:20px!important;
	margin-left:0px!important;
	margin-bottom:10px;
	width:200px;
	height:30px;
}
.btnclass { 	
		border:0px;cursor:pointer;
		background-color:#558ED5;
		color:white;
}
.updating {
	font-family:"Microsoft YaHei"!important;
	margin:0px 0 0 0!important;
}
#imagediv {
	float:left;
}
.updatingnew {
	font-family:"Microsoft YaHei"!important;
	border:1px solid #DBDBDB;
	margin:0px 0 0 0!important;
	width:49.7%;
	position:relative;
}
.divleft {
	float:left;
}
.divright{
	float:right;
}
.imagediv {
	text-align:center;
}
.content {
	margin-left:15px;
	margin-right:15px;
	margin-top:10px;
}
#pro {
 float:left
}

</style>
<script type="text/javascript">
$(document).ready(function(){
	$("#skipall").bind("click",skipall);
	$("#backup").hide();
	if($(".divleft")) {
		var divleftheight = $(".divleft").height();
		var divrightheight = $(".divright").height();
		var height = divleftheight>divrightheight?divleftheight:divrightheight;
		$(".divleft").css("height",height);
		$(".divright").css("height",height);
	}

});
function myrefresh(){
	window.location.href="/login/Login.jsp";
}

</script>
<body style="height:100%;width:100%;">
<jsp:include page="upgradeCheck.jsp"/>
<div style="margin:0 auto!important;width:100%!important">
<div class="titleclass" style="margin:0 auto;width:80%;background-color:#558ed5;font-size:16px;color:white;height:30px;line-height:30px;">&nbsp;&nbsp;升级信息</div>	
<%
 //判断resin版本
 //防止低版本覆盖高版本升级工具之后  找不到isHigherResin3变量报错
try {
	Class<?> classInstance=null;
			        
	classInstance=Class.forName("weaver.system.SysUpgradeCominfo");
	Field field = classInstance.getField("isHigherResin3");
	Boolean isHigherResin3 = (Boolean)field.get(classInstance);  
	
	//field = classInstance.getField("checkClusterMain");
	//Boolean checkClusterMain = (Boolean)field.get(classInstance);  
	//判断resin版本     
	if(isHigherResin3 != true) {
		response.sendRedirect("/login/UpgradeMessage.jsp?error=resin");
		return;
	}
	//判断升级前的数据库字符集
	field = classInstance.getField("rightDBCharset");
	Boolean rightDBCharset = (Boolean)field.get(classInstance);
	if(rightDBCharset != true) {
		response.sendRedirect("/login/UpgradeMessage.jsp?error=dbcharset");
		return;
	}
	//判断是否非集群 或者集群主节点 --与安全补丁包冲突，不在页面拦截 只在日志输出
	/* if(checkClusterMain != true) {
		response.sendRedirect("/login/UpgradeMessage.jsp?error=clustermain");
		return;
	} */
	
	//判断数据库版本
	//数据库版本过低（SQLServer2000），无法升级逻辑无法执行，也无法登录系统；请先升级数据库版本。	
	field = classInstance.getField("checkDBVersion");
	Boolean checkDBVersion = (Boolean)field.get(classInstance);
	if(checkDBVersion != true) {
		response.sendRedirect("/login/UpgradeMessage.jsp?error=dbversion");
		return;
	}
	
}catch(Exception e) {
}


int pagestatus = 999;
int status = 999;
int checklev = 1;

Properties prop = new Properties();
FileInputStream fis = new FileInputStream(GCONST.getRootPath() +"WEB-INF"+ File.separatorChar 
		+ "prop" + File.separatorChar+"Upgrade.properties");

prop.load(fis);
pagestatus=Util.getIntValue(prop.getProperty("PAGESTATUS"),0);
status=Util.getIntValue(prop.getProperty("STATUS"),0);
fis = new FileInputStream(GCONST.getRootPath() +"WEB-INF"+ File.separatorChar 
		+ "prop" + File.separatorChar+"ecologyupdate.properties");
prop.load(fis);
checklev=Util.getIntValue(prop.getProperty("checklevel"),1);


String returnval = suc.checkUpgrade(pagestatus,status);
//重新赋值一次  开始
if(SysUpgradeCominfo.pStatus != pagestatus) {
	SysUpgradeCominfo.pStatus = pagestatus;
}
if(SysUpgradeCominfo.status != status) {
	SysUpgradeCominfo.status = status;
}

//重新赋值一次  结束

//System.out.println("------returnval:"+returnval);
if(returnval != null) {
	out.println(returnval);
	//return;
} else {%>
					
<div style="margin:0 auto;border:1px solid #DBDBDB;width:80%">
<div class=updating style="text-align:center;font-size:20px;"><img src="/images/upgrade.gif"><br/>升级中...<br/>
</div>
								
<%}

//判断是否存在脚本，如果脚本不存在了，自动还原文件状态
if(0!=status || 0!=pagestatus) {
	boolean isSQLexists = suc.isSQLExists();
	if(!isSQLexists) {
		suc.ChangeProp("0","",0,0,"","");
	}
}

%>
</div>
<script type='text/javascript'>
var status = "<%=status%>";
var time = 5000;
if(status==1) {
	time  = 10000;//指定10秒刷新一次
}
setTimeout('myrefresh()',time); 

var checklevel = "<%=checklev%>";
var pstatus = "<%=pagestatus%>";
if(pstatus=="2"&&checklevel!="0") {
	$("#conbtn").css("display","none");
	$(".conmessage").css("display","none");
}

</script>	
</body>

</html>
