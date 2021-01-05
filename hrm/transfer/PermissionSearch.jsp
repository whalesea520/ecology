
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- Added by wcd 2014-11-06 [权限查询] -->
<%@page import="weaver.hrm.authority.domain.*,weaver.hrm.authority.manager.*"%>
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="HrmTransferSetManager" class="weaver.hrm.authority.manager.HrmTransferSetManager" scope="page" />
<jsp:useBean id="HrmTransferLogManager" class="weaver.hrm.authority.manager.HrmTransferLogManager" scope="page" />
<jsp:useBean id="HrmTransferLogDetailManager" class="weaver.hrm.authority.manager.HrmTransferLogDetailManager" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("HrmRrightAuthority:search", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename =SystemEnv.getHtmlLabelName(81553,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String transferType = Util.null2String(request.getParameter("transferType"),"resource");
	String cmd = Util.null2String(request.getParameter("cmd"));
	String fromid=Util.null2String(request.getParameter("fromid"));
	if(fromid.length()==0)fromid=Util.null2String(request.getParameter("resourceid"));
	String fromname = "";
	if(fromid.length() > 0){
		if(transferType.equals("resource")) {
			fromname = ResourceComInfo.getResourcename(fromid);
		} else if(transferType.equals("department")) {
			fromname = DepartmentComInfo.getDepartmentname(fromid);
		} else if(transferType.equals("subcompany")) {
			fromname = SubCompanyComInfo.getSubCompanyname(fromid);
		} else if(transferType.equals("role")) {
			fromname = RolesComInfo.getRolesRemark(fromid);
		} else if(transferType.equals("jobtitle")) {
			fromname = JobTitlesComInfo.getJobTitlesmark(fromid);
		}
	}
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
		<link href="/appres/hrm/css/authority_wev8.css" type="text/css" rel="STYLESHEET">
		<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
		<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
		<link type="text/css" href="/js/tabs/css/e8tabs2_wev8.css" rel="stylesheet" />
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/hrm/HrmTools_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
		<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
		<script type="text/javascript">
			function doProcFrom(event,data,name){
				showData();
			}
			
			function delFromCall(text,fieldid,params){
				doChangeType();
			}
			
			function doChangeType(){
				_writeBackData('fromid', 2, {id:'',name:''},{hasInput:true});
				document.all("defaultDiv").style.display = "block";
				hiddenContent();
			}
			
			function hiddenContent(){
				document.all("contentDiv").style.display = "none";
				document.all("contentDiv").innerHTML = "<div class=\"xTable_message\" style=\"top:30%;left:40%\"><%=SystemEnv.getHtmlLabelName(84041, user.getLanguage())%></div>";
			}
			
			function getAjaxUrl() {
				var type = $GetEle("transferType").value;
				var value = "1";
				if (type == 'resource') {
					value = "1";
				} else if (type == 'department') {
					value = "4";
				} else if (type == 'subcompany') {
					value = "164";
				} else if (type == 'role') {
					value = "65";
				} else if (type == 'jobtitle') {
					value = "24";
				}
        		return "/data.jsp?show_virtual_org=-1&type=" + value;
        	}
			
			function onShowBrowser() {
				var type = $GetEle("transferType").value;
				var url = "";
				if (type == 'resource') {
					url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?show_virtual_org=-1&resourceids=";
				} else if (type == 'department') {
					url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?show_virtual_org=-1&selectedids=";
				} else if (type == 'subcompany') {
					url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1&selectedids=";
				} else if (type == 'role') {
					url = "/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp?selectids=";
				} else if (type == 'jobtitle') {
					url = "/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp?selectids=";
				}
				return url;
			}
		</script>
	</head>
	<BODY>
		<SCRIPT LANGUAGE="JavaScript">
		<!-- Hide
		function killErrors() {
			return true;
		}
		window.onerror = killErrors;
		// -->
		</SCRIPT>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<form id=frmmain name=frmmain method=post action="HrmRightTransferOperation.jsp" >
			<input class=inputstyle type=hidden name="jsonSql" value="">
			<input class=inputstyle type=hidden name="submitJson" value="">
			<input class=inputstyle type=hidden name="needExecuteSql" value="0">
			<input class=inputstyle type=hidden name="zsESQL" value="0">
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
					<wea:item>
						<SELECT style="width:120px" name="transferType" onchange="doChangeType()">
							<option value="resource" <%=transferType.equals("resource")?"selected":""%>><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>
							<option value="department" <%=transferType.equals("department")?"selected":""%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
							<option value="subcompany" <%=transferType.equals("subcompany")?"selected":""%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
							<option value="jobtitle" <%=transferType.equals("jobtitle")?"selected":""%>><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option>
							<option value="role" <%=transferType.equals("role")?"selected":""%>><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
						</SELECT>
					</wea:item>
					<wea:item>
						<brow:browser name="fromid" viewType="0" hasBrowser="true" hasAdd="false" 
							getBrowserUrlFn="onShowBrowser" isMustInput="2" isSingle="true" hasInput="true" 
							completeUrl="javascript:getAjaxUrl()" 
							width="200px" browserValue='<%=fromid %>' browserSpanValue='<%=fromname %>' 
							_callback="doProcFrom" afterDelCallback = "delFromCall" />
					</wea:item>
				</wea:group>
			</wea:layout>
			<div id="defaultDiv" style="position:absolute!important;top:70px!important;height:auto!important;position:relative;height:100%;bottom:4px;width:100%;overflow:auto;">
				<wea:layout type="2col"><wea:group context='<%=SystemEnv.getHtmlLabelNames("385,17463",user.getLanguage())%>'>&nbsp;</wea:group></wea:layout>
			</div>
			<div id="contentDiv" style="position:absolute!important;top:70px!important;height:auto!important;position:relative;height:100%;bottom:4px;width:100%;overflow:auto;<%=(cmd.equals("showContent") || fromid.length() > 0) ? "" : "display:none"%>">
				<div class="xTable_message" style="top:30%;left:40%"><%=SystemEnv.getHtmlLabelName(84041, user.getLanguage())%></div>
			</div>
		</form>
		<script type="text/javascript">
			function doOpen(url, title){
				var dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				dialog.Title = title;
				dialog.Width = 700;
				dialog.Height = 500;
				dialog.Drag = true;
				dialog.maxiumnable = true;
				dialog.URL = url;
				dialog.show();
			}
			
			function showData(){
				document.all("defaultDiv").style.display = "none";
				document.all("contentDiv").style.display = "block";
				var ajax = ajaxinit();
				ajax.open("POST", "PermissionSearchResult.jsp", true);
				ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
				ajax.send("fromid="+$GetEle("fromid").value+"&toid=&transferType="+$GetEle("transferType").value+"&authorityTag=transfer"+"&jsonSql=&submitJson=&needExecuteSql=0&zsESQL=0");
				ajax.onreadystatechange = function() {
					if (ajax.readyState == 4 && ajax.status == 200) {
						try{
							document.all("contentDiv").innerHTML = ajax.responseText;
						}catch(e){
							return false;
						}
					}
				}
			}
		</script>
	</body>
</html>
