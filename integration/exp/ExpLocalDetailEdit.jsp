<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("intergration:expsetting", user)){
 	response.sendRedirect("/notice/noright.jsp");
 	return;
}
%>
<%
String sysid = Util.null2String(request.getParameter("id"));
String backto = Util.null2String(request.getParameter("backto"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
rs.executeSql("select * from exp_localdetail where id="+sysid+"");
String name = "";
String path = "";
if(rs.next()){
	name = Util.toScreenToEdit(rs.getString("name"),user.getLanguage());
	path = Util.toScreenToEdit(rs.getString("path"),user.getLanguage());
}

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(125790,user.getLanguage());//归档本地注册
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
boolean usedFlag = new weaver.expdoc.ExpUtil().getShowmethod(sysid+"+1").equals("true");
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
</script>
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("intergration:expsetting", user)){
	canEdit = true;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("intergration:expsetting", user) && usedFlag){
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<%
			if(HrmUserVarify.checkUserRight("intergration:expsetting", user)){
				canEdit = true;
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onSave()"/>
			<%}
			if(HrmUserVarify.checkUserRight("intergration:expsetting", user) && usedFlag){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onDelete()"/>
			<%
			}
			%>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>
<FORM id=weaver name=frmMain action="ExpLocalDetailOperation.jsp?isdialog=1" method=post enctype="multipart/form-data" >
<wea:layout><!-- 基本信息 -->
	<wea:group context="<%=SystemEnv.getHtmlLabelName(81711,user.getLanguage())%>" attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
            <wea:required id="nameimage" required="true" value='<%=name%>'>
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="100" name="name"  value="<%=name%>" onchange='checkinput("name","nameimage")'>
            </wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(84630,user.getLanguage())%></wea:item>
		<wea:item>
            <wea:required id="pathimage" required="true" value='<%=path%>'>
            	<input class=inputstyle type=text style='width:280px!important;' size=100 maxlength="100" name="path"  value="<%=path%>" onchange='checkinput("path","pathimage")' _noMultiLang='true'>
            </wea:required>
		</wea:item>	
	</wea:group>
</wea:layout>
<br>
 <input class=inputstyle type=hidden name=operation>
 <input class=inputstyle type=hidden name=id value="<%=sysid%>">
 <input class=inputstyle type=hidden name=backto value="<%=backto%>">
 </form>
<script language=javascript>

function onSave(){
	var checkvalue = "name,path";
	if(check_form(frmMain,checkvalue)){
		document.frmMain.operation.value="edit";
		document.frmMain.submit();
	}
}
function doAdd(){
	document.location.href="/integration/exp/ExpLocalDetailAdd.jsp?typename=<%=backto%>";
}

function onDelete(){
	top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>", function (){
		document.frmMain.operation.value="delete";
		document.frmMain.submit();
	}, function () {}, 320, 90);
}
function onBack(){
	parentWin.closeDialog();
}
 </script>
 <%if("1".equals(isDialog)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" onclick='onBack();'></input>
				</wea:item>
			</wea:group>
		</wea:layout>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
	</div>
 </div>
 <%} %>
</BODY>
</HTML>
