
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<link rel="stylesheet" href="/integration/css/base_wev8.css" type="text/css">
<html>
<style>
.menuli1{
	height:25px; 
	line-height:25px; 
	background: url(images/sub1_wev8.png) left center no-repeat;
	padding-left:30px;
	padding-right:0px;
	color:#589456;
}
.menuli2{
	height:25px; 
	line-height:25px; 
	background: url(images/sub2_wev8.png) left center no-repeat;
	padding-left:30px;
	padding-right:0px;
	color:#589456;
}
.menuli3{
	height:25px; 
	line-height:25px; 
	background: url(images/sub3_wev8.png) left center no-repeat;
	padding-left:30px;
	padding-right:0px;
	color:#589456;
}
.menuli4{
	height:25px; 
	line-height:25px; 
	background: url(images/sub4_wev8.png) left center no-repeat;
	padding-left:30px;
	padding-right:0px;
	color:#589456;
}
.menuli5{
	height:25px; 
	line-height:25px; 
	background: url(images/sub5_wev8.png) left center no-repeat;
	padding-left:30px;
	padding-right:0px;
	color:#589456;
}
.menuli6{
	height:25px; 
	line-height:25px; 
	background: url(images/sub6_wev8.png) left center no-repeat;
	padding-left:30px;
	padding-right:0px;
	color:#589456;
}
.menuli7{
	height:25px; 
	line-height:25px; 
	background: url(images/sub7_wev8.png) left center no-repeat;
	padding-left:30px;
	padding-right:0px;
	color:#589456;
}
.menuli8{
	height:25px; 
	line-height:25px; 
	background: url(images/sub8_wev8.png) left center no-repeat;
	padding-left:30px;
	padding-right:0px;
	color:#589456;
}
.menuli9{
	height:25px; 
	line-height:25px; 
	background: url(images/sub9_wev8.png) left center no-repeat;
	padding-left:30px;
	padding-right:0px;
	color:#589456;
}

</style>


<body scroll="no" >
	<%

		String type=Util.null2String(request.getParameter("type"));
		String showtype=Util.null2String(request.getParameter("showtype"));
		
		String loadurl="/integration/WsShowEditSetList.jsp";
	%>
<div class="w-all relative" style="background: #F5F6FA;height:50px;">
 <div class="absolute " style="top:12px;height:38px;width: 1000px" id="tabNav">
 	<div class="left hand  m-l-10  m-r-10 item" href="/integration/WsShowEditSetList.jsp">
		<table height="38px" <%if("1".equals(type)){out.print("class='selected'");}%>>
			<tr>
				<td class="lefttd" style="width: 5px;"></td>
				<td class="centertd" >
					<div class="font12 bold menuli1" >
						<%=SystemEnv.getHtmlLabelName(32301,user.getLanguage())%><!-- 数据展示集成列表 -->
					</div>
				</td>
				<td class="righttd" style="width: 5px;"></td>
			</tr>
		</table>
	</div>
	
	<div class="left hand m-r-10 item"  href="/servicesetting/browsersetting.jsp?type=2">
		<table height="38px " <%if("2".equals(type)){out.print("class='selected'");}%>>
			<tr>
				<td class="lefttd" style="width: 5px;"></td>
				<td class="centertd" >
					<div class="font12 bold menuli2" >
						<%=SystemEnv.getHtmlLabelName(32302,user.getLanguage())%><!-- 数据展示浏览框列表 -->
					</div>
				</td>
				<td class="righttd" style="width: 5px;"></td>
			</tr>
		</table>
	</div>
</div>
</div>

<div style="border-top:  #0b7906 solid 3px;">
	<iframe id="contentFrame" src="<%=loadurl%>"  frameborder="0" width="100%" height="90%"></iframe>
</div>
</body>

<style>
	.selected .lefttd{
		background: url('images/btn_left_wev8.png');
		width: 5px;
	}
	.selected .centertd{
		background:url('images/btn_center_wev8.png') repeat;
	}
	.selected .righttd{
		background: url('images/btn_right_wev8.png');
		width: 5px;
	}
</style>
<script type="text/javascript">
	jQuery(document).ready(function(){
		jQuery("#tabNav").find(".item").bind("click",function(){
			if(!jQuery(this).find("table").hasClass("selected")){
				jQuery(".selected").removeClass("selected");
				jQuery(this).find("table").addClass("selected");
				jQuery("#contentFrame").attr("src",jQuery(this).attr("href"))
			}
		})
	})
</script>
</html>