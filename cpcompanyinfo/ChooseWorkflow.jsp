
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<!--表头浮动层 start-->
<div
	class="Bgfff">
	<div class="FL">
		
		<div class="border17 FL PTop5" style="width:476px;padding-bottom:5px">
		<%=SystemEnv.getHtmlLabelName(30946,user.getLanguage()) %>：<input id="wfname" type="text" text="">
			<ul class="OContRightMsg2 FR">
				<li>
					<a href="javascript:searchWorkflow();" class="hover"><div>
							<div>
								<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage()) %>
							</div>
						</div> </a>
				</li>
			</ul>

		</div>
		<div class="FL" style="height:190px;width:476px;">
			<iframe id="wfiframe" style="width:100%;height:100%" frameborder=no src="/cpcompanyinfo/ChooseWorkflowList.jsp"/>
		
		</div>
	</div>
</div>
<!--表头浮动层 end-->

<script type="text/javascript">
	jQuery(document).ready(function(){
		
	});
	
	function searchWorkflow(){
		jQuery("#wfiframe").attr("src","/cpcompanyinfo/ChooseWorkflowList.jsp?requestname="+jQuery("#wfname").val());
	}
	
	//点击流程后
	function clickWorkflow(requestid,requestname){
		jQuery("#isNeedReSearch").val("Y");
		jQuery("#isReEdit").val("N");
		//jQuery("#workflowspan").html("<a style='color:blue;' href=javascript:workflow2one("+requestid+")>"+requestname+"</a>")
		jQuery("#workflowspan").html("<a style='color:blue;' requestid="+requestid+" href=javascript:onWorkflowAttachmentOpen('"+requestid+"','"+requestname+"')>"+requestname+"</a>");

	}
	
	function workflow2one(requestid){
		//alert(requestid);
	}
	
</script>