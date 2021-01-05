
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<jsp:useBean id="rc" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}

function onShowResource() {
	url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
	disModalDialog(url, $G("resourcespan"), $G("userid"), false);
}

function disModalDialog(url, spanobj, inputobj, need, curl) {
	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}

</script>
</head>
<%
if(!HrmUserVarify.checkUserRight("LogView:View", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(131598,user.getLanguage());
String needfav ="1";
String needhelp ="";
String qname = Util.toHtml2(Util.null2String(request.getParameter("word")));
String module = Util.toHtml2(Util.null2String(request.getParameter("module")));
int handleWay = Util.getIntValue(request.getParameter("handleWay"));
int userid = Util.getIntValue(request.getParameter("userid"));
String startdate = Util.toHtml2(Util.null2String(request.getParameter("startdate")));
String enddate = Util.toHtml2(Util.null2String(request.getParameter("enddate")));
String ip = Util.toHtml2(Util.null2String(request.getParameter("ip")));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onBtnSearchClick()',_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<form method="post" name="searchfrm" id="searchfrm" action="/security/sensitive/SensitiveLogs.jsp">

<div class="advancedSearchDiv" id="advancedSearchDiv">
	<table class="viewform">
	  <colgroup>
	  <col width="10%">
	  <col width="40%">
	  <col width="10%">
	  <col width="40%">
		</colgroup>
	  <tbody>
		<tr>
			<td><%=SystemEnv.getHtmlLabelName(131596,user.getLanguage())%></td>
			<td class=Field><input type="text"  name="word" id="word"  value="<%=qname %>"/></td>
			<td><%=SystemEnv.getHtmlLabelName(19049,user.getLanguage())%></td>
			<td class=Field>
				<select name="module" id="module">
					<option value=""></option>
					<option value="流程">流程</option>
					<option value="文档">文档</option>
					<option value="人事">人事</option>
					<option value="门户">门户</option>
					<option value="资产">资产</option>
					<option value="流程">流程</option>
					<option value="表单建模">表单建模</option>
					<option value="移动建模">移动建模</option>
					<option value="手机版">手机版</option>
					<option value="系统登录">系统登录</option>
					<option value="项目">项目</option>
					<option value="e-message">e-message</option>
					<option value="短信">短信</option>
					<option value="微信">微信</option>
					<option value="计划任务">计划任务</option>
					<option value="其他">其他</option>
				</select>
			</td>
			</tr>
			<tr>
			<td><%=SystemEnv.getHtmlLabelName(124780,user.getLanguage())%></td>
			<td class=Field>
				<select name="handleWay" id="handleWay">
					<option value=""></option>
					<option value="0" <%=handleWay==0?"selected":""%>><%=SystemEnv.getHtmlLabelName(131636,user.getLanguage())%></option>
					<option value="1" <%=handleWay==1?"selected":""%>><%=SystemEnv.getHtmlLabelName(131637,user.getLanguage())%></option>
				</select>
			</td>
			<td><%=SystemEnv.getHtmlLabelName(99,user.getLanguage())%></td>
			<td class=Field>
					 <button type=button  class=browser onClick="onShowResource()"></button>
					 <input name=userid id="userid" type=hidden value="<%=userid%>">
					<span id=resourcespan>
					<%=Util.toScreen(rc.getResourcename(""+userid),user.getLanguage())%>
					</span>
			</td>
			</tr>
			<tr>
			<td><%=SystemEnv.getHtmlLabelName(15502,user.getLanguage())%></td>
			<td class=Field>
				<button type=button  class=calendar id=SelectDate onclick="gettheDate(startdate,fromdatespan)"></BUTTON>&nbsp;
      <SPAN id=fromdatespan ><%=startdate%></SPAN>
      -&nbsp;&nbsp;<button type=button  class=calendar id=SelectDate2 onclick="gettheDate(enddate,todatespan)"></BUTTON>&nbsp;
      <SPAN id=todatespan ><%=enddate%></SPAN>
	  <input type="hidden" name="startdate" class=Inputstyle value="<%=startdate%>"><input type="hidden" name="enddate" class=Inputstyle  value="<%=enddate%>">
			</td>
			<td><%=SystemEnv.getHtmlLabelName(33586,user.getLanguage())%></td>
			<td class=Field><input type="text"  name="ip" id="ip"  value="<%=ip %>"/></td>
		</tr>
		</tbody>
		</table>
</div>
</form>
<%
	String sqlWhere = "1 = 1";
	if(!qname.equals("")){
		sqlWhere += " and sensitivewords like '%"+qname+"%'";
	}	
	if(!"".equals(module)){
		sqlWhere  += " and module = '"+module+"'";
	}
	if(handleWay==0 || handleWay==1){
		sqlWhere  += " and handleWay = "+handleWay;
	}
	if(userid>0){
		sqlWhere  += " and userid = "+userid;
	}
	if(!"".equals(startdate)){
		sqlWhere += " and submittime >= '"+startdate+"'";
	}
	if(!"".equals(enddate)){
		sqlWhere += " and submittime <= '"+enddate+"'";
	}
	if(!ip.equals("")){
		sqlWhere += " and clientAddress like '%"+ip+"%'";
	}	
	 String tabletype="none";
	String tableString=""+
	   "<table  instanceid=\"docMouldTable\" pagesize=\"10\" tabletype=\""+tabletype+"\">"+
	   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"sensitive_logs\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"desc\"  sqldistinct=\"true\" />"+
	   "<head>"+							 
			 "<col pkey=\"id\" width=\"5%\" text=\"ID\" column=\"id\"  orderkey=\"id\"/>"+
			 "<col isfixed=\"true\" pkey=\"module\" width=\"10%\" column=\"module\" text=\""+SystemEnv.getHtmlLabelName(19049,user.getLanguage())+"\"/>"+
			 "<col pkey=\"sensitivewords\" width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(131596,user.getLanguage())+"\" column=\"sensitivewords\"/>";
			 tableString += "<col pkey=\"doccontent\" width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(345,user.getLanguage())+"\" column=\"doccontent\"/>";
			tableString += "<col pkey=\"path\" display=\"false\" width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(18499,user.getLanguage())+"\" column=\"path\"/>";
			tableString += "<col pkey=\"handleway\" width=\"10%\" transmethod=\"weaver.security.sensitive.SensitiveTransMethod.getHandleWay\" text=\""+SystemEnv.getHtmlLabelName(124780,user.getLanguage())+"\"  otherpara=\""+user.getLanguage()+"\" column=\"handleway\"/>";
			tableString += "<col pkey=\"userid\" width=\"10%\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getLastname\" text=\""+SystemEnv.getHtmlLabelName(99,user.getLanguage())+"\" column=\"userid\"/>";
			tableString += "<col pkey=\"submittime\" width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(15502,user.getLanguage())+"\" column=\"submittime\"/>";
			tableString += "<col pkey=\"clientAddress\" width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(33586,user.getLanguage())+"\" column=\"clientAddress\"/>";
	   tableString += "</head>"+
	   "</table>";
%> 
<wea:SplitPageTag isShowTopInfo="false" tableString="<%=tableString%>" mode="run"  />
<SCRIPT language="javascript" src="/js/datetime.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker.js"></script>
</BODY>
</HTML>