
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.settings.BirthdayReminder"%>
<%@page import="weaver.social.service.*"%>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
	String resourceid = Util.null2String(request.getParameter("resourceid"),"");
	SocialIMService socialIMService=new SocialIMService();
	Map<String, String> details = socialIMService.getPersonDetails(resourceid);
	
	String userName=SocialUtil.getUserName(resourceid);
	String imageHead=SocialUtil.getUserHeadImage(resourceid);
	String jobtitle=SocialUtil.getUserJobTitle(resourceid);
	String deptName=SocialUtil.getUserDepCompany(resourceid);
	String subName=SocialUtil.getUserSubCompany(resourceid);
	String managerid=ResourceComInfo.getManagerID(resourceid);
	String manageName=SocialUtil.getUserName(managerid);
	String telephone=ResourceComInfo.getTelephone(resourceid);
	String mobile=ResourceComInfo.getMobile(resourceid);
	String sex=ResourceComInfo.getSexs(resourceid);
%>	
<style>
	html,body {
		padding: 0;
		border: 0;
		margin: 0;
	}
	#detailInfo {table-layout: fixed;}
	#detailInfo tr {
		height: 30px;
	}
	
	#detailInfo tr td.fieldname {
		text-align: left;
  		width: 33px;
  		padding-right: 10px;
  		padding-left: 58px;
  		color: #8e9598;
  		vertical-align: top;
	}
	#detailInfo tr td.fieldvalue {
		text-align: left;
  		color: #3C4350;
  		text-overflow: ellipsis;
  		white-space: nowrap;
  		overflow: hidden;
  		vertical-align: top;
	}
	
	#personRelated td {
		text-align: center;
		height:100%;
	}
	
	#personRelated td .vSplit {
		width: 1px;
  		height: 16px;
  		display: inline-block;
  		background: #e4e7e9;
  		position: absolute;
  		right: 0px;
  		top: 22px;
	}
	
	#personRelated .relatedBtn {
		height: 59px;
	  	line-height: 59px;
	  	color: #3C4350;
	  	cursor: pointer;
	  	position: relative;
	}
	#personRelated .relatedBtn .relatedCnt {
		color: #A7ACB2;
	}
	#personRelated .relatedBtn img,
	#personRelated .relatedBtn span {
		vertical-align: middle;
	}
	#personRelated .relatedBtn:hover {
	  	background: #F1F5FE;
	}
</style>
<table id="outTbl" style="width:100%;height:100%;border-collapse:collapse;display:block;" cellpadding=0px; cellspacing=0px>
	<tbody>
		<tr style="height:105px">
			<td style="text-align:center;vertical-align:bottom;">
				<img class="_targetHead" style="width:80px;height:80px;vertical-align:middle;border-radius: 50%;" src="<%=imageHead%>"/>
				<span class="_targetName" style="vertical-align: middle;font-size: 14px;margin-left: 21px;margin-right: 10px;"><%=userName%></span>
				<img class="_targetSexIco" style="vertical-align: middle;" src="/rdeploy/address/img/<%=sex.equals("0")?"male":"female" %>_ico_wev8.png" alt="女"/>
			</td>
		</tr>
		
		<tr style="height:207px"><td style="height: 182px;vertical-align: bottom;">
			<table id="detailInfo" style="width:100%;height:182px">
				<tr><td class="fieldname">组织:</td><td class="fieldvalue _targetOrg"><%=subName%>/<%=deptName%></td></tr>
				<tr><td class="fieldname">岗位:</td><td class="fieldvalue _targetJob"><%=jobtitle%></td></tr>
				<tr><td class="fieldname">手机:</td><td class="fieldvalue _targetMobile"><%=mobile%></td></tr>
				<tr><td class="fieldname">电话:</td><td class="fieldvalue _targetTel"><%=telephone%></td></tr>
				<tr><td class="fieldname">上级:</td><td class="fieldvalue _targetUpper"><%=manageName%></td></tr>
			</table>
		</td></tr>
		<tr style="height:60px;background:#FAFBFD;border-top:1px solid #e4e4e4;display:none;">
			<td>
				<table id="personRelated" style="width:100%;" cellpadding=0px; cellspacing=0px>
					<tr>
						<td>
							<div class="relatedBtn">
								<img src="/rdeploy/address/img/wf_ico_wev8.png"/>
								<span>流程</span>
								<span class="relatedCnt _targetWf">(30)</span>
								<div class="vSplit"></div>
							</div>
						</td>
						<td>
							<div class="relatedBtn">
								<img src="/rdeploy/address/img/task_ico_wev8.png"/>
								<span>任务</span>
								<span class="relatedCnt _targetTask">(10)</span>
								<div class="vSplit"></div>
							</div>
						</td>
						<td>
							<div class="relatedBtn">
								<img src="/rdeploy/address/img/schedule_ico_wev8.png"/>
								<span>日程</span>
								<span class="relatedCnt _targetSchedule">(10)</span>
							</div>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</tbody>
</table>
<script>
	resourceid = "<%=resourceid%>";
	$(document).ready(function(){
	
		var lastname = '<%=userName%>';
		var headurl = '<%=imageHead%>';
		
		
		//绑定缓存数据
		$("#outTbl").data("targetId",resourceid);
		$("#outTbl").data("targetName",lastname);
		$("#outTbl").data("targetHead",headurl);
	});
</script>





