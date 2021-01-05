
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
</head>
<%
if(!HrmUserVarify.checkUserRight("intergration:hrsetting", user)){
 	response.sendRedirect("/notice/noright.jsp");
 	return;
}
String typename=Util.null2String(request.getParameter("typename"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23660,user.getLanguage());
%>

<BODY>
<div class="zDialog_div_content">
<script language=javascript >
var parentWin = parent.getParentWindow(window);
</script>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(18596,user.getLanguage())+",javascript:importFile(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
String tiptitle1 = SystemEnv.getHtmlLabelName(83315,user.getLanguage());//导入文件格式必须为.sql格式
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="/integration/hrsettingOperation.jsp" enctype="multipart/form-data">
<input type="hidden" id="operation" name="operation" value="">
<input type="hidden" id="invoketype" name="invoketype" value="1">
<input type="hidden" name="isdialog" value="<%=isDialog%>">

<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(68,user.getLanguage())+SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
	  <wea:item><%=SystemEnv.getHtmlLabelName(18596,user.getLanguage()) %></wea:item><!-- 导入导出 -->
	  <wea:item>
     	<input class=InputStyle type=file size=20 name="filename" id="filename" title="<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(18493,user.getLanguage()) %>"></SPAN>
     </wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>' attributes="{'samePair':'RemarkInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
		  <wea:item attributes="{'colspan':'2'}">
			<%=tiptitle1 %>；
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>

</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context=""  attributes="{'groupDisplay':'none'}">
					<wea:item type="toolbar">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(18596,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="importFile();">
						<span class="e8_sep_line">|</span>
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
					</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
	function importFile()
	{
		var filename = frmMain.filename.value;
		if(filename.indexOf(".sql")==-1)
		{
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84650,user.getLanguage())%>");//请选择正确的脚本文件！
			return;
		}
		//alert(filename);
		frmMain.operation.value = "import";
		if(filename!="")
			frmMain.submit();
		else
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(18493,user.getLanguage()) %>!");//请先选择文件
	}
</script>
</BODY>
</HTML>
