<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/rightspluingForBrowser_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/docs/multiMainCategoryBrowser_wev8.js"></script>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("65",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e);
	}
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
</script>
<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
</HEAD>
<%

String check_per = Util.null2String(request.getParameter("mainCategoryIds"));
ArrayList chk_per = new ArrayList();
chk_per = Util.TokenizerString(check_per,",",false);

String documentids = "" ;
String documentnames ="";

if (!check_per.equals("")) {
	String strtmp = "select id,categoryname from docseccategory where id in ("+check_per+")";
	RecordSet.executeSql(strtmp);
	while(RecordSet.next()){
			documentids +="," + RecordSet.getString("id");
			documentnames += ","+RecordSet.getString("categoryname");
	}
}


String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));

int mainCategoryId=Util.getIntValue(request.getParameter("mainCategoryId"),0);
String mainCategoryName = Util.null2String(request.getParameter("mainCategoryName"));

String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}


if(mainCategoryId!=0){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where  id = '";
		sqlwhere += mainCategoryId;
		sqlwhere += "'";
	}
	else{
		sqlwhere += " and id = '";
		sqlwhere += mainCategoryId;
		sqlwhere += "'";
	}
}
if(!"".equals(mainCategoryName)){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where categoryname like '%";
		sqlwhere += Util.fromScreen2(mainCategoryName,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and categoryname like '%";
		sqlwhere += Util.fromScreen2(mainCategoryName,user.getLanguage());
		sqlwhere += "%'";
	}
}

%>
<BODY>
<div class="zDialog_div_content">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" onclick="btnOnSearch()" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnOnSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:onReset(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<FORM NAME=SearchForm id="SearchForm" STYLE="margin-bottom:0" action="DocMainCategoryMutiBrowser.jsp" method=post>
<input type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">

<%--added by XWJ on 2005-03-16 for td:1549--%>

<input type=hidden name="mainCategoryIds" value="<%=check_per%>">
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></wea:item>
		<wea:item><input class=Inputstyle name=mainCategoryId value='<%=mainCategoryId==0?"":mainCategoryId%>'></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item><input class=Inputstyle  name=mainCategoryName value='<%=mainCategoryName%>'></wea:item>
	</wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'colspan':'full'}">&nbsp;</wea:item>
	</wea:group>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
					<wea:item>
						<div id="dialog">
							<div id='colShow'></div>
						</div>
					</wea:item>
				</wea:group>
			</wea:layout>
		</wea:item>
	</wea:group>
</wea:layout>

</FORM>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
			<input type="button" class=zd_btn_submit accessKey=O  id=btnok value="O-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"></input>
			<input type="button" class=zd_btn_submit accessKey=2  id=btnclear value="2-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"></input>
	        <input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
		</wea:item>
	</wea:group>
</wea:layout>
<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
<script type="text/javascript">

jQuery(document).ready(function(){
	showMultiDocDialog("<%=documentids%>");
});


</SCRIPT>
</BODY></HTML>
