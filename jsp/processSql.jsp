<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/jsp/systeminfo/init_wev8.jsp"%> 
<%@ page import="java.io.*"%>
<%@ page import="java.net.InetAddress"%>
<jsp:useBean id="suc" class="weaver.system.SysUpgradeCominfo" scope="page" />
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
<html>
 <head>
	<title> E-cology升级程序</title>
	<script type="text/javascript" src="/js/jquery_wev8.js"></script>
	<link rel="stylesheet" href="/css/main_wev8.css" type="text/css">
	<%
	int time = 10000;
	String titlename ="";

	int pagestatus = 999;
	int status = 999;
	String sqlpath = GCONST.getRootPath() + "sqlupgrade" + File.separatorChar;
   	RecordSet rs1 = new RecordSet();
    boolean isoracle = (rs1.getDBType()).equals("oracle") ;
    boolean isdb2 = (rs1.getDBType()).equals("db2") ;
    boolean ismysql = (rs1.getDBType()).equals("mysql") ;
    if(isoracle) {
    	sqlpath = sqlpath + "Oracle";
    } else if(isdb2) {
    	sqlpath = sqlpath + "DB2" ;
    } else if(ismysql){
    	sqlpath = sqlpath + "MySQL" ;
    } else {
    	sqlpath = sqlpath + "SQLServer";
    }
	Properties prop = new Properties();
	FileInputStream fis = new FileInputStream(GCONST.getRootPath() +"WEB-INF"+ File.separatorChar 
			+ "prop" + File.separatorChar+"Upgrade.properties");

	prop.load(fis);
	pagestatus=Util.getIntValue(prop.getProperty("PAGESTATUS"),0);
	status=Util.getIntValue(prop.getProperty("STATUS"),0);
    boolean sqlfinished = false;
    boolean isMainNode = true;
    //集群判断是否是主节点  只有主节点才执行脚本
    String hostaddr = "";  
    String mainControlIp ="";
    try
    {
        InetAddress ia = InetAddress.getLocalHost();
        hostaddr = ia.getHostAddress();
    }
    catch(Exception e)
    {
    	e.printStackTrace();
    }
    
    mainControlIp = Util.null2String(baseBean.getPropValue(GCONST.getConfigFile() , "MainControlIP"));
    if((!"".equals(mainControlIp)&&hostaddr.equals(mainControlIp))||"".equals(mainControlIp))
    {
    	isMainNode = true;
    } else {
    	isMainNode = false;
    }
    File rundir = null;
    String[] runfilelist = null;
    if(isMainNode) {
    	 	rundir = new File(sqlpath);
    	    runfilelist = rundir.list();
    	    if(runfilelist!=null&&runfilelist.length > 0) {
    	    	
    	    } else {
    	    	sqlfinished  = true;
    	    	time = 20000;
    	    }
    } else {
    	sqlfinished  = true;
    	time = 20000;
    }
   
    
    if(pagestatus==0&&sqlfinished) {
    	response.sendRedirect("/jsp/upgradesuccess.jsp");
    }
    if(status == 1 || status == 3) {
    	time = 20000;
    }
    
    //System.out.println("----pagestatus:"+pagestatus);
	%>
	<script type="text/javascript">
	function myrefresh(){ 
		window.location.reload(); 
	} 
	$("document").ready(function(){
		$("#skipall").bind("click",skipall);
		$("#backup").bind("click",backup);
		if($(".divleft")) {
			var divleftheight = $(".divleft").height();
			var divrightheight = $(".divright").height();
			var height = divleftheight>divrightheight?divleftheight:divrightheight;
			$(".divleft").css("height",height);
			$(".divright").css("height",height);
			//$(".divleft").parent().css("width","99%");
			
			//$("#title").css("width","99%");
		} else {
			
		}

		
		setTimeout("myrefresh()",<%=time%>);

	});

	</script>
	<style type="text/css">
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
		width:49.50%;
		position:relative;
	}
	.divleft {
		float:left;
	}
	.divright {
		float:right;
	}
	.imagediv {
		text-align:center;
	}
	.content {
			margin-left:15px;
			margin-right:15px;
			margin-top:10px;
			font-size:12px!important;
	}
	.btnclass{
		margin-top:20px!important;
		margin-left:0px!important;
		margin-right:20px!important;
	}

	.btnclass { 	
			border:0px;cursor:pointer;
			background-color:#558ED5;
			color:white;
	}
	#pro {
	 float:left
	}
	
	</style>
 </head>
<jsp:include page="/jsp/upgradeCheck.jsp"/>
<%@ include file="/jsp/systeminfo/TopTitle_Upgrade.jsp" %>
<%@ include file="/jsp/systeminfo/RightClickMenuConent_Upgrade.jsp" %>
<jsp:include page="/jsp/systeminfo/commonTabHead.jsp?step=4">
			<jsp:param name="mouldID" value="upgrade" />
			<jsp:param name="navName" value="执行脚本" />
</jsp:include>
<%




if(status ==2) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(354 ,user.getLanguage())+",javascript:myrefresh(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
} else {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(354 ,user.getLanguage())+",javascript:myrefresh(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	if(status ==1) {
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1256 ,user.getLanguage())+",javascript:continueExcute(2),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+"跳过整个脚本"+",javascript:skipall(),_self}" ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(589 ,user.getLanguage())+",javascript:backup(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	

}
%>
<%@ include file="/jsp/systeminfo/RightClickMenu_Upgrade.jsp" %>
<body style="height:100%;width:100%;">
<form>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important"><%--
		<%if(pagestatus==3){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(33703 ,user.getLanguage()) %>" class="e8_btn_top" onclick="continueExcute(0)"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(17416 ,user.getLanguage()) %>" class="e8_btn_top" onclick="exportFile()"/>
		<%} else {%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(1256 ,user.getLanguage()) %>" class="e8_btn_top" onclick="continueExcute(2)"/>
		<%}%>
		--%>
		<input type="button" value="<%=SystemEnv.getHtmlLabelName(354 ,user.getLanguage()) %>" class="e8_btn_top" onclick="myrefresh()"/>
		<%if(status ==1 || status==3){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(589 ,user.getLanguage()) %>" class="e8_btn_top" onclick="backup()"/>
		<%} %>
		</td>
	</tr>
</table>
<body style="height:100%;width:100%;"> 
<div style="width:24%;height:100%;float:left;background:#fcfcfc;">
<jsp:include page="step.jsp"></jsp:include>
</div>

<div style="width:75%;height:100%;float:right">
		<div  style="height:380px;">
			<div  style="height:370px;width:100%;float:right;margin-top:10px;">
				<div style="height:100%;width:100%;background:white;text-align:left;">
					<div style="width:100%;height:100%;font-size:18px;" >
					<div class="titleclass" id="title" style="margin:0 auto;width:80%;background-color:#558ed5;font-size:16px;color:white;height:30px;line-height:30px;">&nbsp;&nbsp;升级信息</div>	
			           		<%
							String returnval = suc.checkUpgrade(pagestatus,status);
							//System.out.println("------returnval:"+returnval);
							
							if(returnval != null) {
								out.println(returnval);
								//return;
							} else {%>
							
							<div style="margin:0 auto;border:1px solid #DBDBDB;width:80%">
							<div class=updating style="text-align:center;"><img src="/images/upgrade.gif"><br/>升级中...<br/>
							</div>
								
							<%}
							%>
			            
					</div>
				</div>
			</div>
		</div>
</div>
</body>
</html>