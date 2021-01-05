<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
if(!HrmUserVarify.checkUserRight("DocPicUploadAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String isClose = Util.null2String(request.getParameter("isclose"));
%>
<jsp:useBean id="PicUploadManager" class="weaver.docs.tools.PicUploadManager" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<SCRIPT language="javascript">
var dialog = null;
var parentWin = null;
try{
 dialog = parent.parent.getDialog(parent);
 parentWin = parent.parent.getParentWindow(parent);
 <%if("1".equals(isClose)){%>
 	parentWin._table.reLoad();
 	dialog.close();
 <%}%>
}catch(e){}
function checkSubmit(){
    if(check_form(weaver,'picname,imagefile')){
        weaver.submit();
    }
}
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(70,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(74,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%if(!isDialog.equals("1")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/docs/tools/DocPicUpload.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
} %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="checkSubmit();" value="<%=SystemEnv.getHtmlLabelName(30986, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmmain action="UploadImage.jsp" method=post enctype="multipart/form-data" onSubmit="return check_form(this,'picname,imagefile')">
<input type="hidden" name="operation" value="add">
<input type="hidden" name="isdialog" value="<%=isDialog%>">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="InvalidFlag_Description" required="true">
				<input temptitle="<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>" type="text" class=InputStyle name="picname" maxLength=30 onchange="checkinput('picname','InvalidFlag_Description')" size=30>
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=InputStyle  size="1" name="pictype">
				<option value="1" selected><%=SystemEnv.getHtmlLabelName(2009,user.getLanguage())%></option>
				<option value="3"><%=SystemEnv.getHtmlLabelName(2010,user.getLanguage())%></option>
    		</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></wea:item>
		<wea:item><input type="file" name="imagefile"></wea:item>
	</wea:group>	
</wea:layout>

</form>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
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
</body>
</html>
