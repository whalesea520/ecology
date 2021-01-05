
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.location.LocationComInfo"%>
<%@ page import="weaver.hrm.company.DepartmentComInfo"%>
<%@ page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.hrm.job.JobTitlesComInfo"%>
<%@ page import="weaver.hrm.job.JobActivitiesComInfo"%>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");

User user = HrmUserVarify.getUser(request , response);
if(user == null)  return ;

int detailid = Util.getIntValue((String)request.getParameter("detailid"));

if(detailid==-1) {
	String url = "/mobile/plugin/6/list.jsp";
	if(request.getQueryString()!=null&&!"".equals(request.getQueryString())) url += "?" + request.getQueryString();
	response.sendRedirect(url);
	return;
}
//标记是从微搜模块进入start
String fromES=Util.null2String((String)request.getParameter("fromES"));
//标记是从微搜模块进入end
String from = Util.null2String((String)request.getParameter("from"));
String module = Util.null2String((String)request.getParameter("module"));
String scope = Util.null2String((String)request.getParameter("scope"));
String clienttype = Util.null2String((String)request.getParameter("clienttype"));

ResourceComInfo rci = new ResourceComInfo();
SubCompanyComInfo scci = new SubCompanyComInfo();
DepartmentComInfo dci = new DepartmentComInfo();
LocationComInfo lci = new LocationComInfo();
JobTitlesComInfo jtci = new JobTitlesComInfo();
JobActivitiesComInfo jaci = new JobActivitiesComInfo();

String status = Util.null2String(rci.getStatus(detailid+"")+"");
String statusname = "";
if(status.equals("0")) statusname=SystemEnv.getHtmlLabelName(15710,user.getLanguage());
if(status.equals("1")) statusname=SystemEnv.getHtmlLabelName(15711,user.getLanguage());
if(status.equals("2")) statusname=SystemEnv.getHtmlLabelName(480,user.getLanguage());
if(status.equals("3")) statusname=SystemEnv.getHtmlLabelName(15844,user.getLanguage());
if(status.equals("4")) statusname=SystemEnv.getHtmlLabelName(6094,user.getLanguage());
if(status.equals("5")) statusname=SystemEnv.getHtmlLabelName(6091,user.getLanguage());
if(status.equals("6")) statusname=SystemEnv.getHtmlLabelName(6092,user.getLanguage());
if(status.equals("7")) statusname=SystemEnv.getHtmlLabelName(2245,user.getLanguage());
if(status.equals("10")) statusname=SystemEnv.getHtmlLabelName(1831,user.getLanguage());
%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title><%=rci.getLastname(detailid+"") %></title>
	<script type='text/javascript' src='/mobile/plugin/js/jquery/jquery_wev8.js'></script>
	<script type='text/javascript' src='/mobile/plugin/js/jquery/jquery-ui_wev8.js'></script>
	<link rel="stylesheet" href="/mobile/plugin/css/cupertino/jquery-ui_wev8.css" type="text/css">
	<link rel="stylesheet" href="/mobile/plugin/css/mobile_wev8.css" type="text/css">
	<style type="text/css">
	.textfield {
		width:100%;
		height:32px;
		line-height:30px;
	}
	</style>
</head>
<body>

<div id="view_page">

	<div id="view_header">
		<table style="width: 100%; height: 40px;">
			<tr>
				<td width="10%" align="left" valign="middle" style="padding-left:5px;">
					<a href="javascript:goBack();">
						<div style="width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;">
						返回
						</div>
					</a>
				</td>
				<td align="center" valign="middle">
					<div id="view_title"><%=rci.getLastname(detailid+"") %></div>
				</td>
				<td width="10%" align="right" valign="middle" style="padding-right:5px;">
				</td>
			</tr>
		</table>
	</div>
	
	<div style="width:100%;height:135px;position:relative;">
	
		<div style="position:absolute;left:10px;top:10px;right:120px;">
	
			<div style="width:100%;height:122px;-webkit-border-radius:6px;-moz-border-radius:6px;background:url(/images/bg_w_65_wev8.png);border:solid 1px #DEDEDE;">
				<div class="textfield text-ellipsis" style="border-bottom:solid 1px #DEDEDE;">&nbsp;&nbsp;&nbsp;&nbsp;姓名：<%=rci.getLastname(detailid+"") %></div>
				<div class="textfield text-ellipsis" style="border-bottom:solid 1px #DEDEDE;">&nbsp;&nbsp;&nbsp;&nbsp;岗位/职务：<%=jtci.getJobTitlesname(rci.getJobTitle(detailid+"")) %>/<%=jaci.getJobActivitiesname(jtci.getJobactivityid(rci.getJobTitle(detailid+""))) %></div>
				<div class="textfield text-ellipsis" style="border-bottom:solid 1px #DEDEDE;">&nbsp;&nbsp;&nbsp;&nbsp;分部：<%=scci.getSubCompanyname(rci.getSubCompanyID(detailid+"")) %></div>
				<div class="textfield text-ellipsis">&nbsp;&nbsp;&nbsp;&nbsp;部门：<%=dci.getDepartmentname(rci.getDepartmentID(detailid+"")) %></div>
			</div>
			
		</div>
			
		<div style="position:absolute;width:10px;top:10px;right:100px;"></div>

		<div style="position:absolute;width:100px;top:10px;right:10px;">
		
			<div style="width:100px;height:122px;-webkit-border-radius:6px;-moz-border-radius:6px;background:url(/images/bg_w_65_wev8.png);border:solid 1px #CCC;text-align:center;line-height:90px;">
			<%
			if(rci.getMessagerUrls(detailid+"")!=null&&!"".equals(rci.getMessagerUrls(detailid+""))) {
			%>
			<img src="<%=rci.getMessagerUrls(detailid+"")%>" height="64px" width="64px" style="padding-top:30px;">
			<%
			} else {
			%>
			<img src="/images/icon_user_wev8.png" height="64px" width="64px" style="padding-top:30px;">
			<% 
			}
			%>
			</div>
				
		</div>
		
	</div>
	
	<div style="width:100%;height:103px;position:relative;">
	
		<div style="position:absolute;left:10px;top:10px;right:10px;">
	
		<div style="width:100%;height:90px;-webkit-border-radius:6px;-moz-border-radius:6px;background:url(/images/bg_w_65_wev8.png);border:solid 1px #DEDEDE;">
			<div class="textfield text-ellipsis" style="border-bottom:solid 1px #DEDEDE;">&nbsp;&nbsp;&nbsp;&nbsp;直接上级：<%=rci.getLastname(rci.getManagerID(detailid+"")) %></div>
			<div class="textfield text-ellipsis" style="border-bottom:solid 1px #DEDEDE;">&nbsp;&nbsp;&nbsp;&nbsp;状态：<%=statusname %></div>
			<div class="textfield text-ellipsis">&nbsp;&nbsp;&nbsp;&nbsp;办公地点：<%=lci.getLocationname(rci.getLocationid(detailid+"")) %></div>
		</div>
		
		</div>
		
	</div>
	
	<div style="width:100%;height:100px;position:relative;">
		
		<div style="position:absolute;left:10px;top:10px;right:10px;">
		
		<div style="width:100%;height:90px;-webkit-border-radius:6px;-moz-border-radius:6px;background:url(/images/bg_w_65_wev8.png);border:solid 1px #DEDEDE;">
			
			<div style="width:100%;height:30px;position:relative;line-height:30px;border-bottom:solid 1px #DEDEDE;">
				<div style="position:absolute;left:0px;right:0px;top:0px;">&nbsp;&nbsp;&nbsp;&nbsp;办公电话：<%=rci.getTelephone(detailid+"") %></div>
				<%if(rci.getTelephone(detailid+"")!=null&&!"".equals(rci.getTelephone(detailid+""))) { %>
				<div style="position:absolute;right:0px;top:0px;"><a href="tel://<%=rci.getTelephone(detailid+"") %>"><img width="30px" src="/images/icon_dial_wev8.png"></a></div>
				<% } %>
			</div>

			<div style="width:100%;height:30px;position:relative;line-height:30px;border-bottom:solid 1px #DEDEDE;">
				<div style="position:absolute;left:0px;right:0px;top:0px;">&nbsp;&nbsp;&nbsp;&nbsp;移动电话：<%=rci.getMobile(detailid+"") %></div>
				<%if(rci.getMobile(detailid+"")!=null&&!"".equals(rci.getMobile(detailid+""))) { %>
				<div style="position:absolute;right:35px;top:0px;"><a href="tel://<%=rci.getMobile(detailid+"") %>"><img width="30px" src="/images/icon_dial_wev8.png"></a></div>
				<div style="position:absolute;right:0px;top:0px;"><a href="sms:<%=rci.getMobile(detailid+"") %>"><img width="30px" src="/images/icon_sms_wev8.png"></a></div>
				<% } %>
			</div>
			
			<div style="width:100%;height:30px;position:relative;line-height:30px;">
				<div style="position:absolute;left:0px;right:0px;top:0px;">&nbsp;&nbsp;&nbsp;&nbsp;电子邮件：<%=rci.getEmail(detailid+"") %></div>
				<%if(rci.getEmail(detailid+"")!=null&&!"".equals(rci.getEmail(detailid+""))) { %>
				<div style="position:absolute;right:0px;top:0px;"><a href="mailto:<%=rci.getEmail(detailid+"") %>"><img width="30px" src="/images/icon_email_wev8.png"></a></div>
				<% } %>
			</div>

		</div>
		
		</div>
		
	</div>
	
</div>

<div id="loading">正在加载数据，请稍等...</div>
<div id="loadingmask" class="ui-widget-overlay"></div>

<script type="text/javascript">
$(document).ready(function() {
	
	$( "#loading" ).hide();
	$( "#loadingmask" ).hide();
	
});

function goBack() {
	var fromES="<%=fromES%>";
	if(fromES=="true"){
		 location = "/mobile/plugin/fullsearch/list.jsp?module=<%=module%>&scope=<%=scope%>&fromES=true";
	}else{
		location = "/list.do?module=<%=module%>&scope=<%=scope%>";
	}
}

function doLeftButton() {
	goBack();
	return 1;
}

</script>

</BODY>
</HTML>