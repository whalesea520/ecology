
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script>
function onDelete(){
	top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		document.weaver.operation.value='delete';
		document.weaver.submit();
	});
}
var dialog = parent.parent.getDialog(parent); 
</script>
</head>
<jsp:useBean id="MailMouldManager" class="weaver.docs.mail.MailMouldManager" scope="page" />
<%

int messageid = Util.getIntValue(request.getParameter("messageid"),0);
int id = Util.getIntValue(request.getParameter("id"),0);
String isDialog = Util.null2String(request.getParameter("isdialog"));
	MailMouldManager.setId(id);
	MailMouldManager.getMailMouldInfoById();
	String mouldname=MailMouldManager.getMailMouldName();
	String mouldtext=MailMouldManager.getMailMouldText();
	MailMouldManager.closeStatement();
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(71,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage())+":"+mouldname;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if("2".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%if(!isDialog.equals("2")){ %>
<DIV>
<%
if(HrmUserVarify.checkUserRight("DocMailMouldEdit:Edit", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:location='/docs/mail/DocMouldEdit.jsp?id="+id+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(HrmUserVarify.checkUserRight("DocMailMouldEdit:add", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='/docs/mail/DocMouldAdd.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(HrmUserVarify.checkUserRight("DocMailMouldEdit:Delete", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}if(HrmUserVarify.checkUserRight("DocMailMould:log", user)){
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:location='/systeminfo/SysMaintenanceLog.jsp?secid=63&sqlwhere="+xssUtil.put("where operateitem=57 and relatedid="+id)+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
}
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

</DIV>
<%} %>
<FORM id=weaver name=weaver action="UploadDoc.jsp" method=post enctype="multipart/form-data">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></wea:item>
		<wea:item>
		<%=id%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></wea:item>
		<wea:item>
		<%=mouldname%>
		</wea:item>
		<wea:item attributes="{'colspan':'full'}">
			<%=SystemEnv.getHtmlLabelName(18693,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<%=mouldtext%>
		</wea:item>
	</wea:group>
</wea:layout>
<input type=hidden name=operation>
<input type=hidden name=id value="<%=id%>">
<input type=hidden name=mouldname value="<%=mouldname%>">
<textarea id="mouldtext" name=mouldtext style="display:none;width:100%;height=500px">##<%=mouldtext%></textarea>
</FORM>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if("2".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
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
<script>
try{
	parent.setTabObjName("<%= mouldname %>");
}catch(e){}
</script>
</html>
