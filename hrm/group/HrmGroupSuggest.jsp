<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.common.Tools"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(126254,user.getLanguage());
String needfav ="1";
String needhelp ="";
String groupid = Util.null2String(request.getParameter("groupid"));
String isclose = Util.null2String(request.getParameter("isclose"));
String groupname = "";	
String sql = " select name from hrmgroup where id= "+groupid;
rs.executeSql(sql);
if(rs.next()) {
	groupname = rs.getString("name");
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);

if("<%=isclose%>"=="1"){
	dialog.close();	
}

var dWidth = 700;
var dHeight = 500;
function doOpen(url,title,_dWidth,_dHeight){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = title;
	dialog.Width = _dWidth ? _dWidth : dWidth;
	dialog.Height = _dHeight ? _dHeight : dHeight;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

function doShow(id){
	doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmGroup&method=HrmGroupAdd&cmd=show&isdialog=1&id="+id,"<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())+SystemEnv.getHtmlLabelName(17748,user.getLanguage())%>");
}		
</script>
</head>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(615, user.getLanguage()) + ",javascript:submitData(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
    		<input class="e8_btn_top" type="button" id="btnSave" onclick="submitData();" value="<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form id=weaver name=frmMain action="GroupOperation.jsp" method=post>
<input type="hidden" name="operation" value="savesuggest">
<input type="hidden" name="groupid" value="<%=groupid %>">
<div class="zDialog_div_content">
	<wea:layout type="2col">
		<wea:group context="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>">
			<wea:item><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></wea:item>
			<wea:item>
				<wea:required id="suggesttitlespan" required="true">
					<INPUT class=inputstyle type=text size=30 name="suggesttitle" value="<%=SystemEnv.getHtmlLabelName(126253,user.getLanguage())%>" onchange='checkinput("suggesttitle","suggesttitlespan")'>
				</wea:required>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(126437,user.getLanguage())%></wea:item>
			<wea:item><a href="javascript:doShow(<%=groupid %>)" style="color: #018efb"><%=groupname%></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(15821,user.getLanguage())%></wea:item>
			<wea:item>
				<input name="suggesttype" type="radio" value="1" checked><%=SystemEnv.getHtmlLabelName(125217,user.getLanguage())%>
				<input name="suggesttype" type="radio" value="2"><%=SystemEnv.getHtmlLabelName(126444,user.getLanguage())%>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(126439,user.getLanguage())%></wea:item>
			<wea:item>
			  <brow:browser viewType="0" name="content" browserValue="" 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?show_virtual_org=-1&selectedids="
            hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="2"
            completeUrl="/data.jsp?show_virtual_org=-1"  temptitle="<%= SystemEnv.getHtmlLabelName(6087,user.getLanguage())%>"
            browserSpanValue="" width="70%" >
        </brow:browser>
			</wea:item>
		</wea:group>
</wea:layout>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
    	<wea:item type="toolbar">
    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
</form>
<script language=javascript>
function submitData() {
 if(check_form(frmMain,'suggesttitle,content')){
 	frmMain.submit();
 }
}
jQuery(document).ready(function(){
checkinput("suggesttitle","suggesttitlespan");
})
</script>
</BODY>
</HTML>