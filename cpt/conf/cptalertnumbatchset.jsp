<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page" />

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

if(!HrmUserVarify.checkUserRight("CptCapital:modify",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String paraid = Util.null2String(request.getParameter("paraid")) ;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";


String needfav ="1";
String needhelp ="";
%>
<BODY >
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="assest"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("33511",user.getLanguage()) %>'/>
</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),mainFrame} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<FORM id=frmain action=cptalertnumconfop.jsp method=post >
<input type="hidden" name="ids" value="<%=Util.null2String(request.getParameter("capitalids")) %>">
<input type="hidden" name="method" value="alertnumbatchset">


<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(15294,user.getLanguage())%></wea:item>
		<wea:item>
				<input class="InputStyle"  id=alertnum  name=alertnum size="8" onchange="checkFloat(this)"  >
		</wea:item>
	</wea:group>

</wea:layout>

<!-- 对话框底下的按钮 -->
<%if("1".equals(isDialog)){ %>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentWin.closeDialog();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
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


</FORM>
<script language="javascript">

function submitData()
{
	var form=jQuery("#frmain");
	var form_data=form.serialize();
	var form_url=form.attr("action");
	jQuery.ajax({
		url : form_url,
		type : "post",
		async : true,
		data : form_data,
		dataType : "json",
		contentType: "application/x-www-form-urlencoded; charset=utf-8", 
		success: function do4Success(msg){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("82933",user.getLanguage())%>");
			parentWin.closeDialog();
			parentWin._table.reLoad();
		}
	});
		
}
</script>


</BODY></HTML>
