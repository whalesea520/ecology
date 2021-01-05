
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/integration/integrationinit.jsp" %>
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
			

</style>


<body scroll="no" >
	<%

		String type=Util.null2String(request.getParameter("type"));
		String showtype=Util.null2String(request.getParameter("showtype"));
		String loadurl="";
		if("1".equals(type)){
			loadurl="/integration/dataInterlist.jsp";
		}else if("2".equals(type)){
			loadurl="/integration/heteProductslist.jsp";
		}else if("3".equals(type)){
			loadurl="/integration/serviceReg/serviceRegMain.jsp?showtype=1";
		}else if("4".equals(type)){
			loadurl="/integration/serviceReg/serviceRegMain.jsp?showtype=2";
		}else if("5".equals(type)){
			loadurl="/integration/sapLog/logMainDetail.jsp";
		}
		else if("6".equals(type)){
			loadurl="/integration/Monitoring/FunSystem.jsp";
		}
		else if("7".equals(type)){
			loadurl="/integration/Monitoring/FieldSystem.jsp";
		}
		else if("8".equals(type)){
			loadurl="/integration/Monitoring/JarSystem.jsp";
		}
		else if("9".equals(type)){
			loadurl="/integration/Monitoring/WfSystem.jsp";
		}
	%>
<div class="w-all relative" style="background: #F5F6FA;height:50px;">
 <div class="absolute " style="top:12px;height:38px;width: 1000px" id="tabNav">
 
 	<div class="left hand  m-l-10  m-r-10 item" href="/integration/dataInterlist.jsp">
		<table height="38px" <%if("1".equals(type)){out.print("class='selected'");}%>>
			<tr>
				<td class="lefttd" style="width: 5px;"></td>
				<td class="centertd" >
						<div class="font12 bold menuli1" >
							<%=SystemEnv.getHtmlLabelName(30681 ,user.getLanguage())%>
						</div>
					</td>
				<td class="righttd" style="width: 5px;"></td>
			</tr>
		</table>
	</div>
	
	<div class="left hand m-r-10 item"  href="/integration/heteProductslist.jsp">
		<table height="38px " <%if("2".equals(type)){out.print("class='selected'");}%>>
			<tr>
				<td class="lefttd" style="width: 5px;"></td>
				<td class="centertd" >
				<div class="font12 bold menuli2" >
				<%=SystemEnv.getHtmlLabelName(31694 ,user.getLanguage())%>
				</div>
				</td>
				<td class="righttd" style="width: 5px;"></td>
			</tr>
		</table>
	</div>
	
	<div class="left hand m-r-10 item" href="/integration/serviceReg/serviceRegMain.jsp?showtype=1">
		<table height="38px" <%if("3".equals(type)){out.print("class='selected'");}%>>
			<tr>
				<td class="lefttd" style="width: 5px;"></td>
				<td class="centertd" style="">
					<div class="font12 bold menuli3">
						<%=SystemEnv.getHtmlLabelName(18076 ,user.getLanguage())%>
					</div>
				</td>
				<td class="righttd" style="width: 5px;"></td>
			</tr>
		</table>
	</div>
	
	<div class="left hand m-r-10 item" href="/integration/serviceReg/serviceRegMain.jsp?showtype=2">
		<table height="38px" <%if("4".equals(type)){out.print("class='selected'");}%>>
			<tr>
				<td class="lefttd" style="width: 5px;"></td>
					<td class="centertd" style="">
					<div class="font12 bold menuli4" >
						<%=SystemEnv.getHtmlLabelName(30624 ,user.getLanguage())%>
					</div>
				</td>
				<td class="righttd" style="width: 5px;"></td>
			</tr>
		</table>
	</div>

	<div class="left hand m-r-10 item" href="/integration/sapLog/logMainDetail.jsp">
		<table height="38px" <%if("5".equals(type)){out.print("class='selected'");}%>>
			<tr>
				<td class="lefttd" style="width: 5px;"></td>
				<td class="centertd" style="">
					<div class="font12 bold menuli5" >
						<%=SystemEnv.getHtmlLabelName(31921 ,user.getLanguage())%>
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