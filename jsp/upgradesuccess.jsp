<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/jsp/systeminfo/init_wev8.jsp"%> 
<%@ page import="weaver.general.*,com.weaver.entity.*"%>
<%@ page import="com.weaver.update.PackageUtil"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
LogInfo logInfo = LogInfo.getLog();
request.getSession(true).removeAttribute("LogInfo");
String titlename ="";
String updatetype = logInfo.getUpdatetype();
RecordSet.execute("select id,label from ecologyuplist order by id desc");
String id = "";
String label = "";
if(RecordSet.next()) {
	id = ""+RecordSet.getInt("id");
	label = ""+RecordSet.getString("label");
}
if(updatetype.indexOf("非通用")>=0) {
	
} else {
	//通用包不会往ecologyuplist插值
	id="0";
	label = "0";
}
PackageUtil pageutil = new PackageUtil();
String content1 = id+"+"+"1+"+"7+"+label+"+content";
String content = pageutil.getUpgradeMessage("",content1);
String config1 = id+"+"+"0+"+"7+"+label+"+config";;
String configcontent = pageutil.getUpgradeMessage("",config1);

%>
<html>
 <head>
	<title> E-cology升级程序</title>
	<script type="text/javascript" src="/js/jquery_wev8.js"></script>
	<link rel="stylesheet" href="/css/main_wev8.css" type="text/css">
	<style>
	.heightlight {
		color:red;
		font-size:16px;
		font-weight:bold;
	}
	</style>
	<script type="text/javascript">
	var dWidth = 600;
	var dHeight = 500;
	
	function doOpen(url,title){
		if(typeof dialog  == 'undefined' || dialog==null){
			dialog = new window.top.Dialog();
		}
		dialog.currentWindow = window;
		dialog.Title = title;
		dialog.Width =  dWidth || 500;
		dialog.Height =  dWidth || 300;
		dialog.Drag = true;
		dialog.maxiumnable = true;
		dialog.URL = url;
		
		dialog.show();
	}
	function openMessage(id,flage,label) {
		var v = flage;
		if(v=="1") {
			doOpen("/jsp/detail.jsp?message=content&id="+id+"&label="+label,"<%=SystemEnv.getHtmlLabelName(17530,user.getLanguage())%>"+"<%=SystemEnv.getHtmlLabelName(33368,user.getLanguage())%>");
		} else if(v=="0"){
			doOpen("/jsp/detail.jsp?message=config&id="+id+"&label="+label,"<%=SystemEnv.getHtmlLabelName(724,user.getLanguage())%>");
		} else if(v=="2") {
			doOpen("/jsp/detail.jsp?message=sqlcontent&id="+id+"&label="+label,"<%=SystemEnv.getHtmlLabelName(33361,user.getLanguage())%>");
		}
		
	}
	
	$(document).ready(function(){
		$.post('/changebeanname.do?time='+new Date().getTime(),function(data){
					var content = "";

					if(data.indexOf("1") > -1) {
						content = "请手动覆盖一次补丁包中的ecology/WEB-INF/lib文件夹";
					} else if(data.indexOf("2") > -1){
						content = content+"<br>请手动覆盖一次补丁包中的ecology/classbean文件夹";
					} else if(data.indexOf("3") > -1){
						content = content+"<br>请手动覆盖一次补丁包中的ecology/WEB-INF/resin-web.xml文件";
					}
					if(content!="") {
						top.Dialog.alert("文件被占用,无法自动覆盖 <br>"+content);
					}
			  	});	 
	});
	</script>
 </head>
<body style="height:100%;width:100%;">
<jsp:include page="/jsp/systeminfo/commonTabHead.jsp?step=5">
			<jsp:param name="mouldID" value="upgrade" />
			<jsp:param name="navName" value="升级成功" />
</jsp:include>

<table id="topTitle" cellpadding="0" cellspacing="0">
</table>
<%@ include file="/jsp/systeminfo/TopTitle_Upgrade.jsp" %>
<%@ include file="/jsp/systeminfo/RightClickMenuConent_Upgrade.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(33703,user.getLanguage())+",javascript:confirm(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/jsp/systeminfo/RightClickMenu_Upgrade.jsp" %>
<div style="width:24%;height:100%;float:left;background:#fcfcfc;">
<jsp:include page="step.jsp"></jsp:include>
</div>
<div style="width:75%;height:100%;float:right">
		<div  style="height:380px;">
			<div  style="height:370px;width:100%;float:right;">
				<div style="height:100%;width:100%;margin-left:-10px;" >
				     <div style="height:50px;font-size:25px;margin-left:20px;padding-top:10px;margin-top:10px;line-height:50px;">升级成功</div>
					
						<%
						if(null!=logInfo)
						{
						%>
						
						<div style="margin-top:10px;margin-left:20px;width:90%;word-break:break-all;font-size:16px;">日志内容：<div>
						<div style="margin-top:10px;margin-left:40px;width:90%;word-break:break-all;font-size:16px;">升级时间：<%=logInfo.getDatetime() %></div>
						<div style="margin-top:10px;margin-left:40px;width:90%;word-break:break-all;font-size:16px;">升级类型：<%=logInfo.getUpdatetype() %></div>
						<div style="margin-top:10px;margin-left:40px;width:90%;word-break:break-all;font-size:16px;">备份目录：<%=logInfo.getBackuppath() %></div>
						<%
						}
						%>
			    	</div>
			    	<div class="heightlight" style="margin-top:10px;margin-left:0px;width:90%;word-break:break-all;">注意事项：</div>
			    	<div class="heightlight" style="margin-top:10px;margin-left:40px;width:90%;word-break:break-all;">请阅读下面相关升级内容，并配置相关项，若不配置可能导致系统功能不正常。确定升级成功后请重启一次服务，以保证系统高效运行。</div>
					<div class="heightlight" style="margin-top:10px;margin-left:40px;width:90%;word-break:break-all;">请查看升级包内容：<%=content %></div>
					<div class="heightlight" style="margin-top:10px;margin-left:40px;width:90%;word-break:break-all;">请查看升级相关配置：<%=configcontent %></div>
					<div class="heightlight" style="margin-top:10px;margin-left:40px;width:90%;word-break:break-all;">请查看升级脚本报错信息：<a href="javascript:openMessage('<%=id%>',2,'<%=label%>')"><%=SystemEnv.getHtmlLabelName(22045,user.getLanguage()) %></a></div>
					
		     </div>
			</div>
	  </div>
   </div>
</div>
</body>
</html>
