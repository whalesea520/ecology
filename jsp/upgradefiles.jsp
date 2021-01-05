<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/jsp/systeminfo/init_wev8.jsp"%> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="com.weaver.general.GCONSTUClient"%>
<html>
<%
String process = Util.null2String(request.getParameter("process"));
String backuppath = Util.null2String(request.getParameter("backuppath"));
backuppath = java.net.URLDecoder.decode(backuppath, "UTF-8");
//System.out.println("backuppath:"+backuppath);
String check = Util.null2String(request.getParameter("check"));
String checkmessage = Util.null2String((String)request.getAttribute("message"));
request.removeAttribute("message");
%>
<META http-equiv="pragma" content="no-cache">  
<META http-equiv="cache-control" content="no-cache">
 <head>
	<title> E-cology升级程序</title>
	<script type="text/javascript" src="/js/updateclient/upgradefiles.js"> </script>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<script type="text/javascript">
	function refresh() {
	 	$.get('/getProcess.do?date='+(new Date()).valueOf(),function(res){
	 		 var pro = res.progress;
			 var backuppath = res.backuppath;
	     	  if(""!=pro&&"0"!=pro&&undefined!=pro) {
	     		  window.location.href="/jsp/upgradefiles.jsp?process="+pro+"&backuppath="+backuppath;
	     	  }
	});
	}
	</script>
 </head>
<%
 String titlename ="";
 %>
<%@ include file="/jsp/systeminfo/TopTitle_Upgrade.jsp" %>
<%@ include file="/jsp/systeminfo/RightClickMenuConent_Upgrade.jsp" %>
<jsp:include page="/jsp/systeminfo/commonTabHead.jsp?step=3">
			<jsp:param name="mouldID" value="upgrade" />
			<jsp:param name="navName" value="本地升级" />
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(1402 ,user.getLanguage()) %>" class="e8_btn_top" onclick="next()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(354,user.getLanguage()) %>" class="e8_btn_top" onclick="refresh()"/>
		</td>
	</tr>
</table>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(1402,user.getLanguage())+",javascript:next(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(354,user.getLanguage())+",javascript:refresh(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/jsp/systeminfo/RightClickMenu_Upgrade.jsp" %>
<body style="height:100%;width:100%;"> 
<input type="hidden" id="backuppath" value="<%=backuppath%>"></input>
<input type="hidden" id="checkmessage" value="<%=checkmessage%>"></input>
<input type="hidden" id="check" value="<%=check%>"></input>
<div style="width:24%;height:100%;float:left;background:#fcfcfc;">
<jsp:include page="step.jsp"></jsp:include>
</div>
<div style="width:75%;height:100%;float:right">
<input id="process" value="<%=process%>" type="hidden"></input>
		<div  style="height:380px;">
			<div  style="height:370px;width:100%;float:right;margin-top:10px;">
				<div style="height:100%;width:100%;text-align:center;">
					<div style="width:100%;height:100%;font-size:18px;" >
			           	<div style="width:100%;height:60px;margin-top:120px;text-align:center;" >
			           	    <div id="message" style="width:100%;font-size:19px;text-align:center;"></div>
			           	</div>
			           	<div style="width:100%;">
			           	<div id="bak" style="height:34px;width:270px;background:url('/images/bak.png') no-repeat;text-align:center;display:none;margin:0 auto" >    	
			                 <div id="pro" style="height:33px;width:0px;background:url('/images/process.png') no-repeat;text-align:center;"></div> 
			            </div>
			            </div>
					</div>
				</div>
			</div>
		</div>
</div>
		<%--
		<div  style="clear:both;height:45px;position:relative;">
			<div style="width:97%;height:30px;padding-right:20px;padding-top:14px;" align="right">
			<input type="button"  value="下一步" style="background:url(/img/nextbtn.png);border:none;width:70px;height:25px;color:#ffffff;font-weight:bold;" id="next">
			</div>
		</div>
--%></body>
</html>
