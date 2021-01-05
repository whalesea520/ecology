<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.getParentWindow(window);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>
<%
/**
if(!HrmUserVarify.checkUserRight("CptCapitalGroupAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
**/


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";


String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<div style="margin-top:30px!important;">
<wea:layout>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'customAttrs':'nowrap=true'}">表单名称</wea:item>
		<wea:item>
			<wea:required id="assortmentname_span" required="true">
				<input id=assortmentname  name=assortmentname size="50" onchange="checkinput(this.name,'assortmentname_span')"  >
			</wea:required>
		</wea:item>
		
	</wea:group>
</wea:layout>
</div>
	<!-- 对话框底下的按钮 -->
<%if("1".equals(isDialog)){ %>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_submit" type="button" name="save" onclick="submitData();" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/>
    		<span class="e8_sep_line">|</span>
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentWin.closeDialog();"  value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"/>
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
	if (check_form(frmain,'assortmentname')){
		parentWin.closeDialog();
	}
}
</script>


</BODY></HTML>
