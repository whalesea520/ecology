
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.setting.*" %>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.general.GCONST"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rsExtend" class="weaver.conn.RecordSet" scope="page" />
<%
String colorStyle = (String)session.getAttribute("ColorStyleInfo");
if("".equals(colorStyle)||colorStyle==null){
	colorStyle="";
}
%>
<html>
<head>
<script src="/wui/theme/ecology8/page/js/jquery.cookie_wev8.js" type="text/javascript"></script>

<style type="text/css">
	.icon{
		
		width: 90px;
		margin-left: auto;
		margin-right:auto;
		height:90px;
		background: url(/wui/theme/ecology8/page/images/skin/yuan_wev8.png);
	}
	.colorlist{
		height: 75px;
		padding-left:35px;
		position: relative;
	}
	.coloritem{
		margin-top:12px;
		width: 50px;
		float: left;
		height: 50px;
		cursor: pointer;
	}
	
	.first{
		border-top-left-radius:5px;
		border-bottom-left-radius:5px;
	}
	
	.last{
		border-top-right-radius:5px;
		border-bottom-right-radius:5px;
	}
	
	.selected{
		display:none;
		height:75px;
		width:60px;
		position: absolute;
		
		box-shadow: 0 0 5px #ccc;
	}
	
	#selectedIcon{
		height: 100%;
		width: 100%;
		background-position: 40% center;
		background-repeat: no-repeat;
	}
</style>
<script type="text/javascript">
$(document).ready(function(){
	$(".coloritem").click(function(){
		//alert(1)
		 $this=jQuery(this);
		//alert( $this.position().left)
			jQuery(".selected").css("background-color",$this.css("background-color"));
		   
		    jQuery(".selected").animate({                
		        top: $this.position().top ,
		        left: $this.position().left-5
		    });
		     jQuery(".selected").show();
		     var img ="";
		     if($(this).index()==0){
		     	 img = "/wui/theme/ecology8/page/images/skin/color_wev8.png"
		     }else{
		     	 img = "/wui/theme/ecology8/page/images/skin/color"+$(this).index()+"_wev8.png"
		     }
		     
		     $("#selectedIcon").css({'background-image':'url('+img+')'})
		     var css = $(this).attr("css");
		     
		     $("#themecolor",top.document).remove();
		     $("#themecolorfile",top.document).remove();
		     $("#portalCss",top.document).attr("href","/wui/theme/ecology8/skins/default/page/"+css+"_wev8.css");
		    
		     //$.cookie("e8skinname",css);
		     //$.cookie("e8skinindex",$(this).index());
		     jQuery.post("/wui/theme/ecology8/page/skinColorDo.jsp?css="+css,null,function(){});
		     //var bgcolor = $("#leftmenucontainer",top.document)
		     $(".leftMenuOverride",top.document).css("background-color",$($("#leftmenucontainer",top.document)).css("background-color"));
		})
		
		var colorStyle='<%=colorStyle%>'
		
		if(colorStyle != ''){
			if(colorStyle!="left"){
				var img = "/wui/theme/ecology8/page/images/skin/color"+$(".coloritem[css='"+colorStyle+"']").index()+"_wev8.png"
				$("#selectedIcon").css({'background-image':'url('+img+')'})
				$(".coloritem[css='"+colorStyle+"']").trigger("click");
			}else{
				var img = "/wui/theme/ecology8/page/images/skin/color_wev8.png"
				$("#selectedIcon").css({'background-image':'url('+img+')'})
				$(".coloritem[css='"+colorStyle+"']").trigger("click");
			}
		}
})

</script>
</head>
<body>
<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
				
			</table>
	<div id="colorContainer">
		<div style="height:25px;">
			&nbsp;
		</div>
		<div class="icon">
			<div id="selectedIcon">
			</div>
		</div>
		<div style="height:25px;">
			&nbsp;
		</div>
		<div class="colorlist">
			<div class="coloritem first " css="left" style="background-color:#0070C1 ; ">
				&nbsp;
			</div>
			<div class="coloritem  " css="left1" style="background-color:#cc3432 ; ">
				&nbsp;
			</div>
			<div class="coloritem " css="left2"  style="background-color:#5c64c2">
				&nbsp;
			</div>
			<div class="coloritem " css="left3"  style="background-color:#50833b">
				&nbsp;
			</div>
			<div class="coloritem " css="left4"  style="background-color:#874d19">
				&nbsp;
			</div>
			<div class="coloritem " css="left5"  style="background-color:#f46f43">
				&nbsp;
			</div>
			<div class="coloritem " css="left6"  style="background-color:#22c9b2">
				&nbsp;
			</div>
			<div class="coloritem " css="left7" style="background-color:#b24079">
				&nbsp;
			</div>
			<div class="coloritem " css="left8" style="background-color:#83686c">
				&nbsp;
			</div>
			<div class="coloritem " css="left9" style="background-color:#666f81">
				&nbsp;
			</div>
			<div class="coloritem last" css="left10" style="background-color:#627f7e;">
				&nbsp;
			</div>
			<div style="clear: both;">
			
			<div class="selected"></div>
		</div>
	</div>
	
	
</body>
</html>
