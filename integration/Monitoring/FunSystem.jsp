
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<%@ include file="/integration/integrationinit.jsp" %>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<html>

		<body>
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
			
				<script type="text/javascript">
					jQuery(document).ready(function () {
						$("#topTitle").topMenuTitle();
						$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
						$("#tabDiv").remove();
						$("#advancedSearch").bind("click", function(){
						});
					});
								function loadfun(){
									//jQuery("#sb").load("/integration/Monitoring/FunSystemOperation.jsp?time="+new Date().getTime());
									$.post("/integration/Monitoring/FunSystemOperation.jsp",{"time":new Date().getTime()},function(data){
										jQuery("#sb").html(data);
									});
								}
								function checkfun(obj){
									jQuery(obj).attr({"disabled":"disabled"});
									var poolid=jQuery("#poolid").val();
									var funname=jQuery("#funname").val();
									if(poolid==""||funname==""){
										alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
										jQuery(obj).removeAttr("disabled");
										return;
									}
									var o4params={"poolid":poolid,"funName":funname,"data":new Date().getTime()};
									jQuery.post("/integration/serviceReg/checkSAPFunctionAjax.jsp",o4params,function(data){
													alert(data["message"]);
													if(data["message"].length<13){
														loadfun();
													}else{
														jQuery("#sb").html("");
													}
													jQuery(obj).removeAttr("disabled");
									},"json");
								}
								function upperCase(obj)   {
						            var y=jQuery.trim(jQuery(obj).val());
						            obj.value=y.toUpperCase();
						        }
						        function hideimg(obj,objspan){
									if(obj.value){
										$(objspan).html("");
									}else{
										$(objspan).html("<img src='/images/BacoError_wev8.gif' align=absMiddle>");
									}
								}
				</script>
				<table id="topTitle" cellpadding="0" cellspacing="0">
					<tr>
						<td></td>
						<td class="rightSearchSpan" style="text-align:right; width:630px!important">
							<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
							<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
						</td>
					</tr>
				</table>
				<div id="tabDiv" >
				   <span style="font-size:14px;font-weight:bold;">&nbsp;</span> 
				</div>
				
				<div class="cornerMenuDiv"></div>
				<div class="advancedSearchDiv" id="advancedSearchDiv">
					
				</div>
			<wea:layout>
				<wea:group context='<%= SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
					<wea:item>
				     	<%=SystemEnv.getHtmlLabelName(28231,user.getLanguage())%>
				     </wea:item>
				    <wea:item>
				    		<input type="text" id="funname"  style="width:180px;" onchange="checkinput('funname','funnamespan'),upperCase(this)" maxlength=80>
								<span id=funnamespan>
										<img src="/images/BacoError_wev8.gif" align=absMiddle>
								</span>
				    </wea:item>
				    
				       <wea:item>
				     		<%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%>
				    </wea:item>
				    <wea:item>
						<%  out.println(SapUtil.getDatasourceSelect("1","poolid","hideimg(this,poolidspan)","","selectmax_width","   "));  %>
						<span id=poolidspan>
							<img src="/images/BacoError_wev8.gif" align=absMiddle>
						</span>
				    </wea:item>
				    <wea:item>
				    	<input type="button"  class="e8_btn_submit"  value='A-<%=SystemEnv.getHtmlLabelName(31640,user.getLanguage())%>'  accesskey="A" onclick="checkfun(this)">
				    </wea:item>
				 </wea:group>
			</wea:layout>
			<div id="sb"  style="padding-left: 10px">
			</div>
		</body>
</html>
