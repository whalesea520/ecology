<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>

<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String userid=Util.null2String(request.getParameter("userid"));
int dsp=Util.getIntValue(request.getParameter("dsp"),0);
int dw=Util.getIntValue(request.getParameter("dw"),920);
String departmentid=ResourceComInfo.getDepartmentID(userid);
String subcompanyid = ResourceComInfo.getSubCompanyID(userid);
if(subcompanyid==null||subcompanyid.equals("")||subcompanyid.equalsIgnoreCase("null"))
 subcompanyid="-1";
String sex=ResourceComInfo.getSexs(userid);


%>
<div class="hrmDiv" dsp="<%=dsp %>" style="height: 60px;border-bottom: 1px solid #F1F1F1;font-size: 12px;word-wrap:break-word;">
	<div style="float:left;margin: 0px 20px 0px 5px;">
		<!-- 头像 -->
		<span>
			<a href="/hrm/resource/HrmResource.jsp?id=<%=userid %>" target="_blank">
				<%=User.getUserIcon(userid,"width:46px;height:46px;border-radius:23px;line-height: 46px;font-size: 14px;") %>
			</a>
		</span>
	</div>
	<div style="float:left">
		<div>
			<!-- 姓名部门 -->
			<span>
				<font><a href="/hrm/resource/HrmResource.jsp?id=<%=userid %>" target="_blank"><%=ResourceComInfo.getLastname(userid) %></a></font>
				<font>
				<%if(sex.equals("0")) {
					out.print("&nbsp; ("+SystemEnv.getHtmlLabelName(28473,user.getLanguage())+")");
				}else if(sex.equals("1")) {
					out.print("&nbsp; ("+SystemEnv.getHtmlLabelName(28474,user.getLanguage())+")");
				} %>
				&nbsp;&nbsp;&nbsp;&nbsp;<img src="/fullsearch/img/unit_wev8.png">  
				<%=DepartmentComInfo.getAllParentDepartmentNames(departmentid,subcompanyid)%>
				</font>
			</span>
		</div>
		<div style="margin-top: 8px;">
			<!-- 其他信息 -->
			<span><label style="color: #848484;"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage()) %>：</label><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(ResourceComInfo.getJobTitle(userid)),user.getLanguage()) %></span>&nbsp;&nbsp;&nbsp;
			<span><label style="color: #848484;"><%=SystemEnv.getHtmlLabelName(421,user.getLanguage()) %>：</label><%=ResourceComInfo.getTelephone(userid)%></span>&nbsp;&nbsp;&nbsp;
			<span><label style="color: #848484;"><%=SystemEnv.getHtmlLabelName(422,user.getLanguage()) %>：</label><%=ResourceComInfo.getMobileShow(userid, user)%></span>&nbsp;&nbsp;&nbsp;
			<span><label style="color: #848484;"><%=SystemEnv.getHtmlLabelName(20869,user.getLanguage()) %>：</label><%=ResourceComInfo.getEmail(userid)%></span>
		</div>
	</div>
	<div class="hrmDivOper" style="float:right;position: absolute;left: <%=dw-210 %>px;display:none">
		<table style="width: 227px;height: 50px;text-align: center;vertical-align: middle;background-color: #D9F1FF">
			<tbody>
				<tr>
					<td><a href="javascript:void(0);" onclick="setUserId(<%=userid %>);openmessage();return false;" title="<%=SystemEnv.getHtmlLabelName(16635,user.getLanguage()) %>"><img style="border:none;" src="/images/messageimages/temp/msn_wev8.png" onmouseover="javascript:this.src='/images/messageimages/temp/msnhot_wev8.png';" onmouseout="javascript:this.src='/images/messageimages/temp/msn_wev8.png';"></a></td>
					<td><a href="javascript:void(0);" onclick="setUserId(<%=userid %>);openemail();return false;" title="<%=SystemEnv.getHtmlLabelName(2051,user.getLanguage()) %>"><img style="border:none;" src="/images/messageimages/temp/email_wev8.png" onmouseover="javascript:this.src='/images/messageimages/temp/emailhot_wev8.png';" onmouseout="javascript:this.src='/images/messageimages/temp/email_wev8.png';"></a></td>
					<td><a href="javascript:void(0);" onclick="setUserId(<%=userid %>);doAddWorkPlan();return false;" title="<%=SystemEnv.getHtmlLabelName(18481,user.getLanguage()) %>"><img style="border:none;" src="/images/messageimages/temp/workplan_wev8.png" onmouseover="javascript:this.src='/images/messageimages/temp/workplanhot_wev8.png';" onmouseout="javascript:this.src='/images/messageimages/temp/workplan_wev8.png';"></a></td>
					<td><a href="javascript:void(0);" onclick="setUserId(<%=userid %>);doAddCoWork();return false;" title="<%=SystemEnv.getHtmlLabelName(18034,user.getLanguage()) %>"><img style="border:none;" src="/images/messageimages/temp/cowork_wev8.png" onmouseover="javascript:this.src='/images/messageimages/temp/coworkhot_wev8.png';" onmouseout="javascript:this.src='/images/messageimages/temp/cowork_wev8.png';"></a></td>
				</tr>
			</tbody>
		</table>
	</div>
</div>