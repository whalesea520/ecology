<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.report.FnaReport"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script type="text/javascript" src="/fna/js/e8Common_wev8.js?r=9"></script>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
	</head>
<%
String rptTypeName = Util.null2String(request.getParameter("rptTypeName")).trim();
boolean canview = FnaReport.checkUserRight(rptTypeName, user) ;
if(!canview) {
	response.sendRedirect("/notice/noright.jsp") ; 
	return ; 
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav = "1";
String needhelp = "";

String _guid1 = Util.null2String(request.getParameter("_guid1")).trim();
String id = Util.null2String(request.getParameter("id")).trim();


HashMap<String, String> retHm = FnaReport.getFnaReportShareLevel(Util.getIntValue(id), _guid1, user.getUID());

boolean isEdit = "true".equals(retHm.get("isEdit"));//编辑
boolean isFull = "true".equals(retHm.get("isFull"));//完全控制
if(!isEdit && !isFull) {
	response.sendRedirect("/notice/noright.jsp") ; 
	return ; 
}

String tbName = "";
String description = "";
String sql = "select tbName, guid1, id, description from fnaTmpTbLog where isTemp = 0 and (guid1 = '"+StringEscapeUtils.escapeSql(_guid1)+"' or id = "+Util.getIntValue(id)+")";
rs.executeSql(sql);
if(rs.next()){
	tbName = Util.null2String(rs.getString("tbName")).trim();
	if("".equals(_guid1)){
		_guid1 = Util.null2String(rs.getString("guid1")).trim();
	}
	if("".equals(id)){
		id = Util.null2String(rs.getString("id")).trim();
	}
	description = Util.null2String(rs.getString("description")).trim();
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:doSave(),_self} ";
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(82523,user.getLanguage()) %>"/>
</jsp:include>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr><td>&nbsp;</td>
		<td class="rightSearchSpan" style="text-align: right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="doSave();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
		
		
<wea:layout type="2Col" >
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(15517, user.getLanguage())%></wea:item><!-- 报表名称 -->
		<wea:item>
			<wea:required id="tbNameimage" required="true">
				<input class="inputstyle" id="tbName" name="tbName" value="<%=FnaCommon.escapeHtml(tbName) %>" maxlength="100" 
					onmousemove="checkinput('tbName','tbNameimage')" onBlur='checkinput("tbName","tbNameimage")' />
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item><!-- 描述 -->
		<wea:item>
			<textarea class="inputstyle" id="description" name="description" rows="4" style="width: 90%;"><%=FnaCommon.escapeHtml(description)%></textarea>
       	</wea:item>
	</wea:group>
</wea:layout>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	    <wea:group context="">
	    	<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage()) %>" id="zd_btn_cancle" class="zd_btn_cancle" onclick="onCancel();">
	    	</wea:item>
	    </wea:group>
	</wea:layout>
</div>
<script type="text/javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...
var _guid1 = "<%=_guid1 %>";

jQuery(document).ready(function(){
	resizeDialog(document);
	checkinput("tbName","tbNameimage");
});

//页面初始化事件
checkinput("fnayear","namespan");

function doSave(){
	var tbName = jQuery("#tbName").val();
	var description = jQuery("#description").val();
	
	if(tbName==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("15517,18019", user.getLanguage()) %>");
		return;
	}

	openNewDiv_FnaBudgetViewInner1(_Label33574);
	var rptTypeName = "<%=rptTypeName %>";
	jQuery.ajax({
		url : "/fna/report/common/FnaRptSaveOp.jsp",
		type : "post",
		processData : false,
		data : "operation=saveNew&rptTypeName="+encodeURI(rptTypeName)+"&_guid1="+_guid1+"&tbName="+encodeURI(tbName)+"&description="+encodeURI(description),
		dataType : "json",
		success: function do4Success(msg){ 
			try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
			if(msg.flag){
				var parentWin = parent.getParentWindow(window);
				parentWin.hiddenSaveBtn();
				onCancel2();
			}else{
				alert(msg.erroInfo);
			}
		}
	});
}

function onCancel(){
	var dialog = parent.getDialog(window);	
	dialog.closeByHand();
}

function onCancel2(){
	var dialog = parent.getDialog(window);	
	dialog.close();
}

//关闭
function doClose(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDialog();
}
</script>
</BODY>
</HTML>
