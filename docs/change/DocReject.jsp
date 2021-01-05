<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%String isClose = Util.null2String(request.getParameter("isclose")); %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">
	var parentWin = parent.parent.getParentWindow(parent);
	var parentDialog = parent.parent.getDialog(parent);
	<%if(isClose.equals("1")){%>
		parentWin._table.reLoad();
		parentDialog.close();
	<%}%>
</script>
</head>
<%
String ids = Util.null2String(request.getParameter("ids"));
String src = Util.null2String(request.getParameter("src"));
String status = "";
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23082,user.getLanguage())+"-";
String groupName = SystemEnv.getHtmlLabelNames("23048,26481",user.getLanguage());
String confirmInfo = SystemEnv.getHtmlLabelNames("33571",user.getLanguage());
if(src.equals("reject")) {
	titlename += SystemEnv.getHtmlLabelName(23048,user.getLanguage());
	status = "2";
	groupName = SystemEnv.getHtmlLabelNames("23048,26481",user.getLanguage());
	confirmInfo = SystemEnv.getHtmlLabelNames("33571",user.getLanguage());
}
else {
	titlename += SystemEnv.getHtmlLabelName(236,user.getLanguage());
	status = "3";
	groupName = SystemEnv.getHtmlLabelNames("236,26481",user.getLanguage());
	confirmInfo = SystemEnv.getHtmlLabelNames("33572",user.getLanguage());
}
String needfav ="";
String needhelp ="";
%>
<body>
<div class="zDialog_div_content">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="doSave(this);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>					
		</td>
	</tr>
</table>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:doSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="frmmain" method="post" action="/docs/change/ReceiveDocOpterator.jsp">
<input type=hidden name="src" value="<%=src%>">
<input type=hidden name="ids" value="<%=ids%>">
<input type=hidden name="status" value="<%=status%>">

<wea:layout>
	<wea:group context='<%=groupName %>'>
		<wea:item attributes="{'colspan':'full'}">
			<wea:required id="detailspan" required="true">
				<textarea class="InputStyle" temptitle="<%=groupName %>" onchange="checkinput('detail','detailspan');" id="detail" name="detail" rows="5" style="width:90%"></textarea>
			</wea:required>
		</wea:item>
	</wea:group>
</wea:layout>
  <input type="hidden" name="totaldetail" value=0> 

</form>
</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<%--<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="onSave;">
						<%if(!operation.equals("add")){%>
							<span class="e8_sep_line">|</span>
							<input type="button" name="zd_btn_submit" onclick="parentWin.onPreview(<%=id %>);" class="zd_btn_submit" value="<%= SystemEnv.getHtmlLabelName(221,user.getLanguage())%>"/>
						<%} %>					
					<span class="e8_sep_line">|</span>--%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentDialog.closeByHand();">
				</wea:item>
			</wea:group>
		</wea:layout>
</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</body>
</html>
<script>
function doSave(mobj) {
	if(check_form(frmmain,"detail")){
		top.Dialog.confirm("<%=confirmInfo%>",function(){
			document.frmmain.submit();
			mobj.disabled = true;
		});
	}
}
</script>
