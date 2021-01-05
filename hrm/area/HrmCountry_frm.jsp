
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- added by wcd 2014-07-14 [E7 to E8] -->
<%
	String cid = Util.null2String(request.getParameter("cid"));
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script type="text/javascript">
			function refreshTreeMain(id,parentId,options){
				var options = jQuery.extend({
					idPrefix:"country_"
				},options);
				refreshTree(id,parentId,options);
			}
		</script>
	</HEAD>
	<body scroll="no">
		<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
		<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;"  >
			<tr>
				<td class="leftTypeSearch">
					<div class="topMenuTitle" style="border:none;">
						<span class="leftType">
						<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"/></span>
						<span><%=SystemEnv.getHtmlLabelNames("377",user.getLanguage())%></span>
						<span id="totalDoc"></span>
						</span>
						<span class="leftSearchSpan">
							<input type="text"  id="leftSearch" class="leftSearchInput" style="width:110px;"/>
						</span>
					</div>
					
				</td>
				<td rowspan="2">
					<iframe src="/hrm/HrmTab.jsp?_fromURL=hrmAreaCountry&cid=<%=cid%>" id="contentframe" name="contentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
				</td>
			</tr>
			<tr>
				<td style="width:23%;" class="flowMenusTd">
					<div class="flowMenuDiv"  >
						<div style="overflow:hidden;position:relative;" id="overFlowDiv">
							<div class="ulDiv" ><iframe src="/hrm/area/HrmCountry_left.jsp?cid=<%=cid%>" id="contentframe1" name="contentframe1" class="" frameborder="0" height="100%" width="100%;" scrolling="no"></iframe></div>
						</div>
					</div>
				</td>
			</tr>
		</table>

		<script type="text/javascript">
			jQuery(document).ready(function(){
				setTimeout(function(){
					document.onkeydown=function(event){
			            var e = event || window.event || arguments.callee.caller.arguments[0];
			             if(e && e.keyCode==13){ // enter 键
			                 $("#contentframe1").attr("src","/hrm/area/HrmCountry_left.jsp?cid=<%=cid%>&searchStr="+$("#leftSearch").val());
			            }
			        }; 
					$(".searchImg").click(function(){ 
						//if($("#leftSearch").val() != ''){
							$("#contentframe1").attr("src","/hrm/area/HrmCountry_left.jsp?cid=<%=cid%>&searchStr="+$("#leftSearch").val());
						//}
					 });
				},1000);
			});
			function onfouc(){
				jQuery("#leftSearch").focus();
			}
		</script>
	</body>
</html>