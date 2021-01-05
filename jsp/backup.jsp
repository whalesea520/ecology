<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<HTML>
<HEAD>
<%@ include file="/jsp/systeminfo/init_wev8.jsp" %>
<LINK rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
</HEAD>

<%
String imagefilename = "/images/hdNoAccess_wev8.gif";
String titlename = "";
String needfav ="";
String needhelp ="";
String message = "系统正在还原中...";
String type = Util.null2String(request.getParameter("type"));
if(type.equals("1")) {
	message = "还原成功！请确认数据库已经还原。"; 
} else {
	message = "系统正在还原中...";
}


%>
<%@ include file="/jsp/systeminfo/TopTitle_Upgrade.jsp" %>
<%@ include file="/jsp/systeminfo/RightClickMenuConent_Upgrade.jsp" %>
<%
RCMenu += "{"+"刷新"+",javascript:refresh(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<jsp:include page="/jsp/systeminfo/commonTabHead.jsp?step=1">
			<jsp:param name="mouldID" value="upgrade" />
			<jsp:param name="navName" value="还原" />
</jsp:include>
<%@ include file="/jsp/systeminfo/RightClickMenu_Upgrade.jsp" %>
<script type="text/javascript">
$(document).ready(function(){
	$.post("/backup.do?date="+((new Date()).getTime()),{
		
	},function(data){
		  eval("var result="+data);
		  if(result.isSuccess=="yes")
		  {
			  $("#message").html("还原成功！请确认数据库已经还原。");
		  }
		
	});
	timeout2=setInterval(getData,1000);
});

function getData(){
 	$.get('/backProcess.do?date='+((new Date()).getTime()),function(res){
 			  //var backuppath = $("#backuppath").val();
 			 var pro = res.backProcess;
 	     	  if(pro == "0") {
 	     		$("#message").html("正在解压备份文件...");
 	     	  } else if(pro == "1") {
 	     		$("#message").html("正在进行文件还原...");
 	     	  } else if(pro == "2") {
 	     		$("#message").html("还原成功！请确认数据库已经还原。");
 	     	  } 
  	});	
}
function refresh() {
	getData();
}
</script>
<BODY>

<div style="width:100%;position:absolute;top:20%;text-align:center;vertical-align:middle;">
	<img src="/images/ecology8/noright_wev8.png"/>
	<div id="message" style="height:60px;text-align: center;line-height:60px;font-size: 18px;"><%=message %></div>
</div>

</BODY>
</HTML>