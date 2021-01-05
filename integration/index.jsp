
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/integration/integrationinit.jsp" %>
<link rel="stylesheet" href="/integration/css/base_wev8.css" type="text/css">
<html>
<style>
 	
 		li { list-style-type: disc; list-style-position: inside; margin-left: 22px}
 		.w-162{width: 162px}
 		.m-g30{margin-left: 30px}
 		.h-85{height:85px}
 </style>
<body scroll="no" oncontextmenu=self.event.returnValue=false>
<div class="h-all w-all" style='background:url(images/bg_wev8.png) top center no-repeat #F5F6FA;'>
<div class="center">
	<div class="h-85">&nbsp;</div>
	<div class="w-500 font36 colorfff p-t-30 " style="margin:0 auto;font-family:'微软雅黑';padding-left:120px;'">
		<%=SystemEnv.getHtmlLabelName(81371,user.getLanguage()) %>
	</div>
	<div class="w-600 font14  text-left  " style="color:#70a018; margin:0 auto;font-family:'微软雅黑';padding-left:250px;'">
			<div class="lh-160p p-l-20" style='background:url(images/icon_wev8.png) left center no-repeat'>	<%=SystemEnv.getHtmlLabelName(81372,user.getLanguage()) %>。</div>
					<div class="lh-160p p-l-20" style='background:url(images/icon_wev8.png) left center no-repeat'>	<%=SystemEnv.getHtmlLabelName(81373,user.getLanguage()) %>。</div>
					<div class="lh-160p p-l-20" style='background:url(images/icon_wev8.png) left center no-repeat'>	<%=SystemEnv.getHtmlLabelName(81374,user.getLanguage()) %>。</div>
					<div class="lh-160p p-l-20" >&nbsp;</div>
	</div>
	<div class="w-all  font14 text-left " style='margin:0 auto;font-family:微软雅黑;color:#70a018;'>
			
			<table width="100%" style='margin:0 auto;font-family:微软雅黑;color:#70a018;'>
				<tr>
					<td width="50%">
					</td>
					<td width="50%" style="margin-left:-50px;">
					
					</td>
				</tr>
			</table>
			
	 </div>
	 <div class=" center" style="margin:0 auto;">
			<table class=" w-all" style="margin:0 auto;">
				<tr>
					<td class=' ' align='middle'>
						<div class="w-162">
							<div><img id="1"  src="images/1_wev8.png" class="hand"  onclick="onloadContent(1)"></div>
							<div class="font14 color333 m-t-10 hand"><%=SystemEnv.getHtmlLabelName(81375,user.getLanguage()) %></div>
							<div class="font12 lh-160p m-t-10" style='color:#70a018;text-align: left;'>
									<ul >
										<li>DML<%=SystemEnv.getHtmlLabelName(81376,user.getLanguage()) %></li>
										<li>ABAP-RFC<%=SystemEnv.getHtmlLabelName(81376,user.getLanguage()) %></li>
										<li>WEBSERVICE<%=SystemEnv.getHtmlLabelName(81376,user.getLanguage()) %></li>
										<li style=" list-style-type: none "></li>
										<li style=" list-style-type: none "></li>
									</ul>
							
							</div>
						</div>
					</td>
					<td class=' ' align='middle'>
					<div class="w-162">
							<div><img id="2" src="images/2_wev8.png"  onclick="onloadContent(2)"  style="cursor: pointer;"></div>
							<div class="font14 color333 m-t-10 hand"><%=SystemEnv.getHtmlLabelName(81377,user.getLanguage()) %></div>
							<div class="font12 lh-160p m-t-10" style='color:#70a018;text-align: left;'>
									<ul>
										<li><%=SystemEnv.getHtmlLabelName(81378,user.getLanguage()) %></li>
										<li><%=SystemEnv.getHtmlLabelName(81379,user.getLanguage()) %></li>
										<li style=" list-style-type: none "></li>
										<li style=" list-style-type: none "></li>
										<li style=" list-style-type: none "></li>
									</ul>
							</div>
						</div>
					</td>
					<td class=' ' align='middle'>
					<div class="w-162">
							<div><img id="3" src="images/3_wev8.png" class="hand" onclick="onloadContent(3,1)"></div>
							<div class="font14 color333 m-t-10 hand"><%=SystemEnv.getHtmlLabelName(81380,user.getLanguage()) %></div>
							<div class="font12 lh-160p m-t-10" style='color:#70a018;text-align: left;padding-left: 10px'>
									<ul>
										<li class="m-g30"><%=SystemEnv.getHtmlLabelName(81381,user.getLanguage()) %></li>
										<li class="m-g30"><%=SystemEnv.getHtmlLabelName(81382,user.getLanguage()) %></li>
										<li style=" list-style-type: none "></li>
										<li style=" list-style-type: none "></li>
										<li style=" list-style-type: none "></li>
									</ul>
							</div>
						</div>
					</td>
					<td class=' ' align='middle'>
					<div class="w-162">
							<div><img id="4" src="images/4_wev8.png" class="hand" onclick="onloadContent(4,2)"></div>
							<div class="font14 color333 m-t-10 hand"><%=SystemEnv.getHtmlLabelName(81383,user.getLanguage()) %></div>
							<div class="font12 lh-160p m-t-10" style='color:#70a018;text-align: left;padding-left: 10px'>
									<ul>
										<li><%=SystemEnv.getHtmlLabelName(81384,user.getLanguage()) %></li>
										<li><%=SystemEnv.getHtmlLabelName(81385,user.getLanguage()) %></li>
										<li style=" list-style-type: none "></li>
										<li style=" list-style-type: none "></li>
										<li style=" list-style-type: none "></li>
									</ul>
							</div>
						</div>
					</td>
					<td class=' ' align='middle'>
					
					<div class="w-162">
								<div><img id="5" src="images/5_wev8.png " class="hand" onclick="onloadContent(5)"></div>
							<div class="font14 color333 m-t-10 hand"><%=SystemEnv.getHtmlLabelName(31921,user.getLanguage()) %></div>
							<div class="font12 lh-160p m-t-10" style='color:#70a018;text-align: left;padding-left: 20px'>
									<ul>
										<li><%=SystemEnv.getHtmlLabelName(31695,user.getLanguage()) %></li>
										<li><%=SystemEnv.getHtmlLabelName(31696,user.getLanguage()) %></li>
										<li><%=SystemEnv.getHtmlLabelName(31922,user.getLanguage()) %></li>
										<li><%=SystemEnv.getHtmlLabelName(31697,user.getLanguage()) %></li>
										<li>SAP<%=SystemEnv.getHtmlLabelName(23113,user.getLanguage()) %></li>
									</ul>
							</div>
						</div>
					</td>
					
				</tr>
			</table>
	 
			</div>
	 </div>
</div>
<script type="text/javascript">
	jQuery("img").hover(function(){
		$(this).attr("src","images/"+$(this).attr("id")+"_hover_wev8.png")
	},function(){
		$(this).attr("src","images/"+$(this).attr("id")+".png")
		
	})
	function onloadContent(type,showtype){
			window.location.href='/integration/content.jsp?type='+type+"&showtype="+showtype;
	}
</script>
</body>
</html>