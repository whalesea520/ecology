<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/jsp/systeminfo/init_wev8.jsp"%> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="com.weaver.general.GCONSTUClient"%>
<html>
<%

%>
 <head>
	<title> E-cology升级程序</title>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	
	<script type="text/javascript">
	
	function next() {
		var flag = $("#confirm").attr("checked");
		if(flag) {
			window.location.href = "/jsp/selectZip.jsp";
		} else {
			top.Dialog.alert("请确认数据库已备份！");
			return;
		}
		
	}
	</script>
 </head>
<%
 String titlename ="";
 %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<jsp:include page="/jsp/systeminfo/commonTabHead.jsp?step=0">
			<jsp:param name="mouldID" value="upgrade" />
			<jsp:param name="navName" value="备份数据库" />
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(1402 ,user.getLanguage()) %>" class="e8_btn_top" onclick="next()"/>
		</td>
	</tr>
</table>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(1402,user.getLanguage())+",javascript:next(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body style="height:100%;width:100%;"> 

<div style="width:24%;height:100%;float:left;background:#fcfcfc;">
<jsp:include page="step.jsp"></jsp:include>
</div>
<div style="width:75%;height:100%;float:right">
<input id="process" type="hidden"></input>
	<div  style="height:380px;">
			
			<div  style="height:370px;width:100%;float:right;margin-top:10px;">
				<div style="height:100%;width:100%;margin-left:-10px;">
                      <div style="margin-top:10px;text-align: center;" >
                       <img src="/images/ecology8/noright_wev8.png" width="162px" height="162px"/>
                      </div>
                       <div style="margin-top:10px;height:60px;text-align: center;line-height:60px;font-size: 18px;" >
                            	<span><input  notBeauty=true type="checkbox" id="confirm"></input></span>请确认数据库已经做好备份<span style="color:red;">（必须在停止ecology服务的情况下备份）<span>!
                       </div>
                       <div style="margin-top:0px;margin-left:20px;height:20px;text-align: left;line-height:20px;font-size: 15px;" >
                       <p>*目前该工具不支持跨版本升级（如E7升级E8），可以使用运维平台--升级工具进行跨版本升级。
                       <br>
                       *如果补丁包中包含Emessage、EMobile、运维平台的功能，请确认对应的服务已停止。
                       <br>*请确认ecology/classbean文件夹未被占用。
                       </p>
                       
                       </div>

				</div>
			
			</div>
	</div>
</div>
</body>
</html>