<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/jsp/systeminfo/init_wev8.jsp"%> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
<html>
<head>
	<title> E-cology升级程序</title>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<%
	String checkpro = Util.null2String(request.getParameter("checkpro"));
	String next = Util.null2String((String)request.getParameter("next"));
	String localfile = Util.null2String((String)request.getSession(true).getAttribute("localfile"));
	String uploadzip = Util.null2String((String)request.getSession(true).getAttribute("uploadzip"));
	%>
	<script type="text/javascript">
	
	function cancel() {
		window.location.href="/jsp/selectZip.jsp";
	}
	var timeout2;
	$(document).ready(function(){
		var checkpro = "<%=checkpro%>";
		var next = "<%=next%>";
		if(checkpro =="") {//判断是否从本地升级直接跳转过来的
		    if(next == "1") {
		    	$("#message").html("正在进行跳包检查...");
				$.get('/check.do?date='+(new Date()).valueOf()+"&next=1",function(data){});	
			} else {
				$.get('/check.do?date='+(new Date()).valueOf()+"&localfile=<%=localfile%>&uploadzip=<%=uploadzip%>",function(data){});	
			}
		} else {
			getData();
		}

		timeout2=setInterval(getData,1000);
	});
	
	function getData(){
	 	$.get('/checkProcess.do?date='+(new Date()).valueOf(),function(res){
	 			  //var backuppath = $("#backuppath").val();
	 			 var pro = res.checkProcess;
	 			 var proMessage = res.proMessage;
	 			  if(proMessage=="canUpgradeOrNot") {
	 	     	  	window.location.href="/jsp/skippackage.jsp";
	 	     	  	clearInterval(timeout2);
	 	     	  	return;
	 	     	  } else if(proMessage=="cannotUpgrade") {
	 	     	  	window.location.href="/jsp/error.jsp";
	 	     	  	clearInterval(timeout2);
	 	     	  	return;
	 	     	  } else if(proMessage=="canNotUpgradeCheck") {
	 	     	  	window.location.href="/jsp/keyCheck.jsp";
	 	     	  	clearInterval(timeout2);
	 	     	  	return;
	 	     	  } else if(proMessage=="canNotUpgradeClassbean") {
	 	     	  	window.location.href="/jsp/error.jsp?type=classbean";
	 	     	  	clearInterval(timeout2);
	 	     	  	return;
	 	     	  }
	 	     	  
	 	     	  if(pro == "0") {
	 	     		$("#message").html("正在解压升级包...");
	 	     		return;
	 	     	  } else if(pro == "1") {
	 	     		$("#message").html("正在进行文件对比...");
	 	     		return;
	 	     	  } else if(pro == "2") {
	 	     		$("#message").html("正在进行跳包检查...");
	 	     		return;
	 	     	  } else if(pro == "3") {
	 	     	  	$("#message").html("升级包检查完成...");
	 	     		window.location.href="/jsp/upgradefiles.jsp";
	 	     		return;
	 	     	  }
	  	});	
	}
	function refresh() {
		getData();
	}
	</script>
</head>
<%
String message = Util.null2String((String)request.getAttribute("message"));
String titlename="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<jsp:include page="/jsp/systeminfo/commonTabHead.jsp?step=2">
			<jsp:param name="mouldID" value="upgrade" />
			<jsp:param name="navName" value="本地升级" />
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="刷新" class="e8_btn_top" onclick="refresh()"/>
		</td>
	</tr>
</table>

<%
RCMenu += "{"+"刷新"+",javascript:refresh(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<div style="width:24%;height:100%;float:left;background:#fcfcfc;">
<jsp:include page="step.jsp"></jsp:include>
</div>
<div style="width:75%;height:100%;float:right">
<div style="height:380px;">
			<div  style="height:370px;width:100%;float:right;margin-top:10px;">
				<div style="height:100%;width:100%;margin-left:-10px;">
                      <div style="margin-top:10px;text-align: center;" >
                       <img src="/images/upgrade.gif" width="400px" height="300px"/>
                      </div>
                       <div id="message" style="margin-top:10px;height:60px;text-align: center;line-height:60px;font-size: 18px;" >
                            正在进行升级解压与升级包验证，请稍后...
                       </div>

				</div>
			
			</div>
</div>
</div>
<div>
</div>
</body>
</html>