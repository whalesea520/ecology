
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
int languageId = 7;
  int labelid=Util.getIntValue(((String)request.getAttribute("labelid")==null?request.getParameter("labelid"):(String)request.getAttribute("labelid")),129755);
  String msg=SystemEnv.getHtmlLabelName(labelid,languageId);
  String comefrom =Util.null2String((String)request.getAttribute("comefrom")==null?request.getParameter("comefrom"):(String)request.getAttribute("comefrom"));
%>
<script type="text/javascript">
 
</script>
<html>
  <head>
    <title><%=SystemEnv.getHtmlLabelName(84239,languageId) %></title>
    <script type="text/javascript" src="/wui/common/jquery/jquery_wev8.js"></script>
    <link type='text/css' rel='stylesheet'  href='/wui/theme/ecology7/skins/default/wui_wev8.css'/>
  </head>
<body style="margin:0px;padding:0px;">
<div style="width: 100%;position:absolute;margin-top: 10%" align="center" id="messageArea">
    <div style="width: 700px;font-family:微软雅黑;font-size:16px;height:247px;border:1px solid #e2e2e2;text-align:left;" align="center">
    <div style="float:left; ">
    	<div style=" height:80px; width:80px;background: url(/wui/common/page/images/error_left_wev8.png); margin-top:80px;margin-left:40px!important; margin-left:20px"></div>
    </div>
	<div style=" height:205px; border-left:solid 1px #e8e8e8; margin:20px;margin-top:22px; float:left; margin-left:40px;"></div>
	<div style="height:260px; width:510px; float:left; line-height:25px;">
		<p id="msg" style="font-weight:normal;margin-top:16px;color:#fe9200;">
			   <%=SystemEnv.getHtmlLabelName(labelid,languageId) %>
		</p>
		<p style="color:#8f8f8f;margin-top:16px;">
			<%=SystemEnv.getHtmlLabelName(127944,languageId) %>
		</p>
    </div>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(309,languageId)%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close()">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>

</body>
</html>    
  
