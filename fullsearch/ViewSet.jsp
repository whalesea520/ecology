
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.fullsearch.model.FSViewSetInfo" %>
<%@ include file="init.jsp" %>
<jsp:useBean id="viewSet" class="weaver.fullsearch.bean.ViewSetBean"/>
<jsp:setProperty name="viewSet" property="pageContext" value="<%=pageContext%>"/>
<jsp:setProperty name="viewSet" property="user" value="<%=user%>"/>
<% 
     if(user == null){
		user = HrmUserVarify.checkUser(request,response);
     }
	 String type = request.getParameter("changetype");
     if("bgimg".equals(type)){
     		String bgimgid = request.getParameter("bgimgid");
     		viewSet.saveBackGroupImage(user.getUID(), bgimgid);
     		return;
     }else if("viewset".equals(type)){
     		viewSet.saveViewSet();
%>
<script language="JavaScript" type="text/javascript">
    window.parent.returnValue = "1";
    window.parent.close();
</script>
<%
     } else {
            Map map = viewSet.getMapOfViewSet(user.getUID());
            FSViewSetInfo allVinfo = null;
            if(map.containsKey("ALL")){
            	allVinfo = (FSViewSetInfo)map.get("ALL");
            }

            //每页显示条数
            int num = (allVinfo != null?allVinfo.getNumPerPage():-1);

            List fields = null;
 %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=10" /> 
<title><%=SystemEnv.getHtmlLabelName(83361,user.getLanguage()) %></title>
<script type="text/javascript" src="../js/jquery/jquery_wev8.js"></script> 
<link href="../css/viewSet_wev8.css" rel="stylesheet" type="text/css" />
<style type="text/css">
<!--
*{
	font-family:微软雅黑;
}
.btnclass{
	width:auto;
}
.btnbaseChild{
	width: 30px;
	overflow: hidden;
}
-->
</style>
<script language="JavaScript" type="text/javascript">
   jQuery(document).ready(function(){
         jQuery(".btnclass").mouseover(function(){
		     jQuery(this).find(".btnleft").css("background-position", "bottom left");
			 jQuery(this).find(".btnright").css("background-position", "bottom right");
		 });
		 
		 jQuery(".btnclass").mouseout(function(){
		     jQuery(this).find(".btnleft").css("background-position", "top left");
			 jQuery(this).find(".btnright").css("background-position", "top right");
		 });
		 
   		jQuery(".btnbase").click(function(){
		   var hidediv = jQuery(this).attr("hidediv");
		   if(jQuery("#"+hidediv).css("display") == "none"){
			   jQuery("#"+hidediv).css("display", "");
			  jQuery(this).removeClass("coBarClose").addClass("coBarOpen").find("div").text("<%=SystemEnv.getHtmlLabelName(20721,user.getLanguage()) %>"); //收缩
			  jQuery(this).attr("title","<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage()) %>");
		   }else{
			  jQuery("#"+hidediv).css("display", "none");
			  jQuery(this).removeClass("coBarOpen").addClass("coBarClose").find("div").text("<%=SystemEnv.getHtmlLabelName(15315,user.getLanguage()) %>"); //展开
			  jQuery(this).attr("title","<%=SystemEnv.getHtmlLabelName(31835,user.getLanguage()) %>");
			}
		});
		
   });

</script>

<script language="JavaScript" type="text/javascript">
   jQuery(document).ready(function(){
        		 
   		jQuery("#OK").click(function(){
		   jQuery('#changetype').val("viewset");
		   jQuery('#frm').submit();
		   //window.returnValue = "1";
           //window.close();
		});
		
		jQuery("#CANCEL").click(function(){
		   window.returnValue = "0";
           window.close();
		});
		
   });

</script>

</head>
<body>
<form action="" method="POST" name="frm" id="frm" target="endiframe">
<input type="hidden" id="changetype" name="changetype" value=""/>
<div align="center" id="maindiv">
	<div align="left" id="topbar"><span class="topbar_text"><%=SystemEnv.getHtmlLabelName(83361,user.getLanguage()) %></span></div>
	<div align="left" id="commSetDiv" class="commSet">
		<div align="left" id="commtitlediv" class="commtitle"><span class="commtitle_text"><%=SystemEnv.getHtmlLabelName(83362,user.getLanguage()) %></span></div>
		<div align="left" id="contentdiv" class="content">
			<div class="content_text"><%=SystemEnv.getHtmlLabelName(17491,user.getLanguage()) %>：&nbsp
				<select id="numperpage" name="numperpage">
					<option value="0"  <%if(num <= 0){%>selected<%} %>  > </option>
					<option value="5" <%if(num == 5){%>selected<%} %>>5</option>
					<option value="8" <%if(num == 8){%>selected<%} %>>8</option>
					<option value="10" <%if(num == 10){%>selected<%} %>>10</option>
					<option value="15" <%if(num == 15){%>selected<%} %>>15</option>
					<option value="20" <%if(num == 20){%>selected<%} %>>20</option>
				</select>&nbsp;<%=(user.getLanguage()==7||user.getLanguage()==9)?"条":"" %>
            </div>
	    </div>
	</div>
	<div align="left" style="width: 275px;height:10px"></div>
	
	<div align="left" id="commSetDiv" class="commSet">
		<div align="left" id="docsetdiv" class="commtitle" style="display:inline-block;">
			<div class="commtitle_text"><%=SystemEnv.getHtmlLabelNames("58,32317",user.getLanguage()) %></div>
			<div class="btnbase coBarOpen"  title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage()) %>" hidediv="contentdiv1">
				<div class="btnbaseChild" style="margin-left: 28px;padding-top: 0px;"><%=SystemEnv.getHtmlLabelName(20721,user.getLanguage()) %></div>
			</div>
		</div>
		<% 
		fields = new ArrayList();
		if(map.containsKey("DOC")){
			FSViewSetInfo info = (FSViewSetInfo)map.get("DOC");
			fields = Util.TokenizerString(info.getShowField()==null?"":info.getShowField(), ",");
		}
			 %>
		<div align="left" id="contentdiv1" class="content">
			<div id="" class="content_text"> 
				<div><input name="CREATOR" type="checkbox" value="1"  <% if(fields.contains("CREATOR")) {%>checked<%} %>/><%=SystemEnv.getHtmlLabelName(271,user.getLanguage()) %></div> 
				<div><input name="DIRECTORY" type="checkbox"  value="1" <% if(fields.contains("DIRECTORY")) {%>checked<%} %>/><%=SystemEnv.getHtmlLabelName(92,user.getLanguage()) %></div> 
				<div><input name="CREATE_DATE" type="checkbox" value="1" <% if(fields.contains("CREATE_DATE")) {%>checked<%} %>/><%=SystemEnv.getHtmlLabelName(722,user.getLanguage()) %></div> 
			</div>
		</div>
	</div>
	<div align="left" style="width: 275px;height:10px"></div>
	
	<div align="left" id="footbar" class="footbar" style="display:inline-block;">
		
		<div id="CANCEL" class="btnclass" style="margin-right: 30px;" title="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>" >
			<div class="btnleft" style=""><%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %></div>
		    <div class="btnright"> &nbsp;</div>
		</div>
		<div id="OK" class="btnclass"  title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" >
			<div class="btnleft" style=""><%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %></div>
		    <div class="btnright"> &nbsp;</div>
		</div>
	</div>
</div>
</form>
<IFRAME name=endiframe id=endiframe  width=0px  height=0px frameborder=no scrolling=no>
</IFRAME>
</body>
</html>

<% }%>