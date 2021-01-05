<%@page import="weaver.fna.interfaces.thread.FnaThreadResult"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<head>
</head>
<%
if(!HrmUserVarify.checkUserRight("CostStandardProcedure:edit", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = "";

String key_generateFieldPropertySQL_full = Util.null2String(request.getParameter("key_generateFieldPropertySQL_full")).trim();

FnaThreadResult fnaThreadResult = new FnaThreadResult();
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(132237,user.getLanguage()) %>"/><!-- 带出费用标准的字段属性SQL -->
</jsp:include>
	<textarea id="textareaFnaCostStandardDefi" style="width: 96%;height: 315px;" readonly="readonly"><%
		String generateFieldPropertySQL_full = "";
		try{
			if(!"".equals(key_generateFieldPropertySQL_full)){
				generateFieldPropertySQL_full = Util.null2String((String)fnaThreadResult.getInfoObjectByInfoKey(key_generateFieldPropertySQL_full, "generateFieldPropertySQL_full"));
			}
		}catch(Exception ex){
		}
	%><%=generateFieldPropertySQL_full %></textarea>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="submit" id="btnClose" onclick="doClose();" 
    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 取消 -->
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
</body>
<script language="javascript">
//关闭
function doClose(){
	var dialog = parent.getDialog(window);	
	dialog.closeByHand();
}
</script>
</HTML>
