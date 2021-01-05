
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.setting.*" %>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<jsp:useBean id="rsExtend" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<%
	String themeid=Util.null2String(request.getParameter("themeId"));
%>

<style type="text/css">
	body,html{
		padding:0;
		margin:0;
	}
	.selected{
	
	}
	.theme{
		width:80px;
		float:left;
		cursor:pointer;
		padding:0;
		margin-left:12px;
		margin-top:12px;
	}
	.theme .t1{
		margin:auto;
		height:1px;
		padding:0;
	}
	.theme .t2{
		margin:auto;
		padding:0;
		height:1px;
		border-left:1px solid #d0d0d0;
		border-top:none;
		border-right:1px solid #d0d0d0;
		border-bottom:none;
		background:#f7f7f7;
	}
	.theme .b1{
		margin:auto;
		padding:0;
		height:1px;
	}
	.theme .b2{
		margin:auto;
		padding:0;
		height:1px;
	}
	.theme .boxContent{
		margin:auto;
		padding:0;
	}
	.wbtn{
		border:1px solid #d0d0d0;
		background:#f7f7f7;
		height:23px;
		_height:25px;
	}
	.BoxBody{
		background:url(/workplan/calendar/css/images/icons/tick_wev8.png) no-repeat;
		background-position:100% 0;
		height:16px;
	}
  </style>
  <script type="text/javascript">
  	$(function(){
		$(".theme").click(function(){
			$(".BoxBody").remove();
			$("input[name=themeid]").val($(this).find("input")[0].value);
			$(this).find(".boxContent").append("<div class=\"BoxBody\"></div>");
			
		});
  	  	});
  </script>
</head>

<body style="font-family:微软雅黑;font-size:12px;">
	<input type="hidden" name="themeid" vlaue=<%=themeid %>>
	<table cellpadding="0px" cellspacing="0px" width="100%">
		<tr align="center">
			<td>
		<%
			
			for(int i=0;i<20;i++){
		%>
		
		<div class="theme" id="theme-<%=i%>" >
		<input type="hidden" name="theme-<%=i%>" value=<%=i %>>
		<div style="padding-left:2px;padding-right:2px;border:none;height:1;padding-top:0;padding-bottom:0;">
			<div class="t1" style="background:<%=getColor(i,0)%>;border-left:1px solid <%=getColor(i,0)%>;border-top:1px solid <%=getColor(i,0)%>;border-right:1px solid <%=getColor(i,0)%>;border-bottom:none;"></div>
			
		</div>
		<div style="padding-left:1px;padding-right:1px;height:1;padding-top:0;padding-bottom:0;">
			<div class="t2" style="background:<%=getColor(i,0)%>;border-left:1px solid <%=getColor(i,0)%>;border-top:none;border-right:1px solid <%=getColor(i,0)%>;border-bottom:none;"></div>
		</div>
		<div class="boxContent" style="background:<%=getColor(i,1)%>;height:60px;">
			<div class="title" style="background:<%=getColor(i,0)%>;height:17px;border-bottom:1px solid <%=getColor(i,0)%>"></div>
			<%if((""+i).equals(themeid)){ %>
					<div class="BoxBody"></div>
			<%} %>
		</div>
		
		<div style="padding-left:1px;padding-right:1px;height:1;padding-top:0;padding-bottom:0;">
			<div class="b2" style="background:<%=getColor(i,1)%>;border-left:1px solid <%=getColor(i,0)%>;border-top:none;border-right:1px solid <%=getColor(i,0)%>;border-bottom:none;"></div>
		</div>
		<div style="padding-left:2px;padding-right:2px;border:none;height:1;padding-top:0;padding-bottom:0;">
			<div class="b1" style="background:<%=getColor(i,1)%>;border-left:1px solid <%=getColor(i,0)%>;border-top:none;border-right:1px solid <%=getColor(i,0)%>;border-bottom:1px solid <%=getColor(i,0)%>;"></div>
		</div>
	</div>
		<%} %>
				
		</td>
	</table>
</body>

</html>
<%!
	public String getColor(int i,int j){
		
		String  d = "666666888888aaaaaabbbbbbdddddda32929cc3333d96666e69999f0c2c2b1365fdd4477e67399eea2bbf5c7d67a367a994499b373b3cca2cce1c7e15229a36633cc8c66d9b399e6d1c2f029527a336699668cb399b3ccc2d1e12952a33366cc668cd999b3e6c2d1f01b887a22aa9959bfb391d5ccbde6e128754e32926265ad8999c9b1c2dfd00d78131096184cb05288cb8cb8e0ba52880066aa008cbf40b3d580d1e6b388880eaaaa11bfbf4dd5d588e6e6b8ab8b00d6ae00e0c240ebd780f3e7b3be6d00ee8800f2a640f7c480fadcb3b1440edd5511e6804deeaa88f5ccb8865a5aa87070be9494d4b8b8e5d4d47057708c6d8ca992a9c6b6c6ddd3dd4e5d6c6274878997a5b1bac3d0d6db5a69867083a894a2beb8c1d4d4dae54a716c5c8d8785aaa5aec6c3cedddb6e6e41898951a7a77dc4c4a8dcdccb8d6f47b08b59c4a883d8c5ace7dcce";
		
		return "#" + d.substring(i * 30 + j * 6, i * 30 + (j + 1) * 6);
	
	}
%>