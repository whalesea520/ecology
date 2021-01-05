<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<%
String customid = Util.null2String(request.getParameter("customid"));
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String templateid = Util.null2String(request.getParameter("templateid"));
String sourcetype = Util.null2String(request.getParameter("sourcetype"));//1--高级搜索；2--普通查询
String tempquerystring = Util.null2String(request.getQueryString()); 
if (tempquerystring.indexOf("&flag") > -1) {
	tempquerystring = tempquerystring.substring(0,tempquerystring.indexOf("&flag"));
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
if("<%=isclose%>"=="1"){
	parent.closeWinAFrsh(<%=templateid%>);	
}
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),mainFrame} " ;//保存
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:closePrtDlgARfsh("+templateid+"),mainFrame} " ;//关闭
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;"><!-- 保存 -->
				<input class="e8_btn_top middle" onclick="javascript:submitData(this)" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
		</wea:item>
	</wea:group>
</wea:layout>
<FORM id=frmain name=frmain action="/formmode/template/SaveTemplateOperation.jsp?<%=tempquerystring %>" method=post >
<input type="hidden" name="method" value="saveTemplate" />
<input type="hidden" name="customid" value="<%=customid %>" />
<input type="hidden" name="sourcetype" value="<%=sourcetype %>" />
<div style="margin-top:30px!important;">
<wea:layout type="2col">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'customAttrs':'nowrap=true'}"><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage()) %><!--模板名称--></wea:item>
		<wea:item>
			<wea:required id="templatename_span" required="true">
				<input id=templatename  name=templatename size="30" onchange="checkinput('templatename','templatename_span')" value=""  >
			</wea:required>
		</wea:item>
		<wea:item attributes="{'customAttrs':'nowrap=true'}"><%=SystemEnv.getHtmlLabelName(19471,user.getLanguage()) %><!--模板类型--></wea:item>
		<wea:item>
			<select name="templatetype" id="templatetype" style="width: 135px;">
	    		<option value="0"><%=SystemEnv.getHtmlLabelName(83139,user.getLanguage()) %><!-- 私人模板 --></option>
	    		<%-- <option value="1"><%=SystemEnv.getHtmlLabelName(83140,user.getLanguage()) %><!-- 公共模板 --></option> --%>
	    	</select>
		</wea:item>
		<wea:item attributes="{'customAttrs':'nowrap=true'}"><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage()) %><!-- 显示顺序--></wea:item>
		<wea:item>
			<input type="text" name="displayorder" style="width: 50px;" value=""/>
		</wea:item>
	</wea:group>
</wea:layout>
</div>
</FORM>
<%if ("1".equals(isDialog)) {%>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar"><!-- 关闭 -->
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="zd_btn_cancle" onclick="closePrtDlgARfsh('<%=templateid %>')">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script type="text/javascript">
jQuery(document).ready(function(){
	resizeDialog(document);
});
</script>
<%} %>

<script language="javascript">

function submitData()
{
	if (check_form(frmain,'templatename')){
		document.frmain.submit();
	}
}
function closePrtDlgARfsh(templateid){
	window.parent.closeWinAFrsh(templateid);
}
</script>
</BODY></HTML>
