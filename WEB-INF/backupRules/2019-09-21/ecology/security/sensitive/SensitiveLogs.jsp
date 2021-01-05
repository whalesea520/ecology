
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<jsp:useBean id="rc" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<HTML><HEAD>
<%String parentid = Util.null2String(request.getParameter("parentid")); %>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}
</script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("LogView:View", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(65,user.getLanguage());
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
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onBtnSearchClick()',_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form method="post" name="searchfrm" id="searchfrm" action="/security/sensitive/SensitiveLogs.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="text" class="searchInput" name="flowTitle" id="flowTitle" onchange="setKeyword('flowTitle','word','searchfrm');"  value="<%=qname %>"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995, user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="4col">
		<wea:group context="<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>">
			<wea:item><%=SystemEnv.getHtmlLabelName(131596,user.getLanguage())%></wea:item>
			<wea:item><input type="text"  name="word" id="word"  value="<%=qname %>"/></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(19049,user.getLanguage())%></wea:item>
			<wea:item>
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
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(124780,user.getLanguage())%></wea:item>
			<wea:item>
				<select name="handleWay" id="handleWay">
					<option value=""></option>
					<option value="0" <%=handleWay==0?"selected":""%>><%=SystemEnv.getHtmlLabelName(131636,user.getLanguage())%></option>
					<option value="1" <%=handleWay==1?"selected":""%>><%=SystemEnv.getHtmlLabelName(131637,user.getLanguage())%></option>
				</select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(99,user.getLanguage())%></wea:item>
			<wea:item>
				 <brow:browser viewType="0" name="userid" browserValue='<%= ""+userid %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="49%"
					browserSpanValue='<%=Util.toScreen(rc.getResourcename(""+userid),user.getLanguage())%>'></brow:browser>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(15502,user.getLanguage())%></wea:item>
			<wea:item>
				<span class="wuiDateSpan" >
					<input name="startdate" value="<%=startdate%>"   class="wuiDateSel"     _span="startdatespan" _button="startdatebtn" >
					<input name="enddate" value="<%=enddate%>"   class="wuiDateSel"     _span="enddatespan" _button="enddatebtn" >
					</span>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(33586,user.getLanguage())%></wea:item>
			<wea:item><input type="text"  name="ip" id="ip"  value="<%=ip %>"/></wea:item>
		</wea:group>
		<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick()"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
				</wea:item>
	</wea:layout>
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
	   "<table pageId=\"SensitiveLogs_20170919\" instanceid=\"docMouldTable\" pagesize=\""+PageIdConst.getPageSize("SensitiveLogs_20170919",user.getUID(),PageIdConst.DOC)+"\" tabletype=\""+tabletype+"\">"+
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
<input type="hidden" name="pageId" id="pageId" value="SensitiveLogs_20170919"/>
<wea:SplitPageTag isShowTopInfo="false" tableString="<%=tableString%>" mode="run"  />
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</BODY>
</HTML>