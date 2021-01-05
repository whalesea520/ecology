
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="companyManage" class="weaver.company.CompanyManager" scope="page" />
<%
	String abgroupid = companyManage.getABGroupids4Call(false);
	boolean isOK = companyManage.froWheelTree(abgroupid);
 %>
<script type="text/javascript">
	setInterval("closeMaint4Win()",5000);
	function closeMaint4Win()
	{
		if(<%=isOK%>==true){
			jQuery("#callBtn").qtip('hide');
			jQuery("#callBtn").qtip('destroy');
		}
	}
</script>
<div
	class="Absolute OHeaderLayerAB Bgfff BorderLMDIVHide">
	<div class="OHeaderLayerTit FL OHeaderLayerW3 ">
		<span id="spanTitle_gdh" class="cBlue FontYahei FS16 PL15"><%=SystemEnv.getHtmlLabelName(31035,user.getLanguage())%></span>
		
	</div>
	<div class="FL">
		<table width="420" border="0" align="center" cellpadding="0"
			cellspacing="0" class="MT5">
			<tr>
				<td height="25">
					<p><strong><%=SystemEnv.getHtmlLabelName(31036,user.getLanguage())%>  </strong></p>
					<br/>
					<p><%=SystemEnv.getHtmlLabelName(31037,user.getLanguage())%>  </p>
				</td>
			</tr>
			
		</table>
	</div>
</div>
<!--表头浮动层 end-->

