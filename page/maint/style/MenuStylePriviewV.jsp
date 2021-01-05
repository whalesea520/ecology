
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="mvsc" class="weaver.page.style.MenuVStyleCominfo" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
String styleid =Util.null2String(request.getParameter("styleid"));
String titlename = SystemEnv.getHtmlLabelName(22915,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage());
%>



<html>
 <head>
	<!--Base Css And Js-->
   	<link href="/css/Weaver_wev8.css" type="text/css" rel=stylesheet>
	<link href="/page/maint/style/common_wev8.css" type="text/css" rel=stylesheet>
	<link href="/js/jquery/plugins/menu/menuv/menuv_wev8.css" type="text/css" rel=stylesheet>

	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<SCRIPT language="javascript" src="/js/jquery/jquery_wev8.js"></script>
	
	<!--For Menu-->
	<SCRIPT language="javascript" src="/js/jquery/plugins/menu/menuv/menuv_wev8.js"></script>

	<style id="styleMenu" type="text/css" title="styleMenu">
		<%=mvsc.getCss(styleid)%>
	</style>
 </head>
<body  id="myBody">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onBack(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width="100%">
	<tr style="height:30px;"><td colspan="2"></td></tr>
	<tr>
		<td width="15%"></td>
		<td width="100%">			  
		<div style="width:50%;height:100%;position:relative;" id="divPreview">
			<fieldset> 
			<legend><%=SystemEnv.getHtmlLabelName(22974,user.getLanguage())%><!--预览区--></legend> 
				   <div style="align:center;padding-left:15px;" id="menuv" class="sdmenu">
					  <div class="mainBg_top">
						<a  href="#"  class="mainFont">Menu1</a>
						<a href="#" class="sub">Menu1-1</a>
						<a href="#" class="sub">Menu1-2</a>
						<a href="#" class="sub">Menu1-3</a>
					  </div>
					   <div class="mainBg">
						<a  href="#"  class="mainFont">Menu2</a>
						<a href="#" class="sub">Menu2-1</a>
						<a href="#" class="sub">Menu2-2</a>
						<a href="#" class="sub">Menu2-3</a>
					  </div>													
					  <div class="mainBg">
						<a  href="#"  class="mainFont">Menu3</a>
						<a href="#" class="sub">Menu3-1</a>
						<a href="#" class="sub">Menu3-2</a>
						<a href="#" class="sub">Menu3-3</a>   			
					  </div>
					  <div class="mainBg">
					 	 <a  href="#"class="collapsed mainFont">Menu4</a>
						  		
					  </div>
					</div>
			</fieldset> 
		</div>
		<div style="clear:both"></div>
		</td>
	</tr>
</table>						
</body>
</html>
<script language="javascript">		
		window.onscroll=function(){
			jQuery("#divPreview").css("top",document.body.scrollTop);
		};
		function onBack(){
			 location.href='/page/maint/style/MenuStyleList.jsp';
		}
		
	</script>
