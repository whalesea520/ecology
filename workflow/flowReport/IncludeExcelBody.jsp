
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String exportProcess=Util.null2String(request.getParameter("exportProcess"));
String exportSQL=Util.null2String(request.getParameter("exportSQL"));
exportSQL = xssUtil.put(exportSQL);
%>
<style>
#loadingExcel{
    position:absolute;
    background:#ffffff;
    left:40%;
    top:40%;
    padding:8px;
    z-index:20001;
    height:auto;
    border:1px solid #ccc;
    display: none;
}
</style>
<iframe name="exportExcel" id="exportExcel" src="" onreadystatechange="hideload()" style="display:none">
</iframe>
<div id="loadingExcel">	
		<span><img src="/images/loading2_wev8.gif" align="absmiddle"></span>
		<span><%=SystemEnv.getHtmlLabelName(26692, user.getLanguage())%></span>
</div>
<script type="text/javascript">
jQuery(window).scroll(function()
{
	var	top=jQuery(window).scrollTop();
	jQuery("#loadingExcel").css({"top":top+300});//随鼠标滚动而移动
});
function hideload(){
	if(document.readyState == "complete"  || document.readyState == "loaded"){
		jQuery("#loadingExcel").hide();
	}	
}
jQuery(document).ready(function(){
	if(!window.attachEvent)jQuery("#loadingExcel").remove();
});
function exportExcel()
{
   if(window.attachEvent)jQuery("#loadingExcel").show();
   var sql="<%=exportSQL%>";//查询语句
  // sql=URLencode(sql);
   var exportProcess="<%=exportProcess%>";//流程导出操作类型
   document.getElementById("exportExcel").src="/workflow/flowReport/WorkflowReportExportExcel.jsp?rund="+(new Date().getTime())+"&exportProcess="+exportProcess+"&sql="+sql;
}
function URLencode(sStr)
{
    return escape(sStr).replace(/\+/g, '%2B').replace(/\"/g,'%22').replace(/\'/g, '%27').replace(/\//g,'%2F');
}
function getParamValues(forms){
	var doURL=[];
	jQuery(":input,select",forms).each(function(){
		var name=jQuery(this).attr("name");
		var value=jQuery(this).val();
		if(value!="" && name!="subsqlstr")value=delHtmlTag(value);
		if(name!="" && value!="")doURL.push(name+"="+value);
	});
	if(doURL.length>0){
		doURL=doURL.join("&");
	}
	return doURL;
}
function delHtmlTag(str)
{
return str.replace(/<[^>]+>/g,"");//去掉所有的html标记
}
</script>
