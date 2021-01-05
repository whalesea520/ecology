
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<% if(!HrmUserVarify.checkUserRight("CRM_EvaluationAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }

	String isclose = Util.null2String(request.getParameter("isclose"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript >
function checkSubmit(){
	jQuery.ajax({
		url:"/CRM/Maint/EvaluationOperation.jsp?method=getSumproportion&proportion="+jQuery("input[name='proportion']").val(),
		type:"post",
		async:true,
		success:function(msg){
			if(msg == "overMax")
			{
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15223,user.getLanguage())%>100%");
				return;
			}
			else
			{
				if(check_form(weaver,'name,proportion')){
        			weaver.submit();
    			}
			}
		}
	});
    
}
var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);
if("<%=isclose%>"=="1"){
	parentWin.location = "EvaluationListInner.jsp";
	parentWin.closeDialog();
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6070,user.getLanguage())+SystemEnv.getHtmlLabelName(101,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),''} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(16497,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="checkSubmit()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM id=weaver action="/CRM/Maint/EvaluationOperation.jsp" method=post>
<input type="hidden" name="method" value="add">
<wea:layout>
	<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="nameimage" required="true" value="">
				<INPUT class=InputStyle maxLength=50 size=45 name="name" onchange='checkinput("name","nameimage")'
				temptitle="<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>">
			</wea:required>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="proportionimage" required="true" value="">
				<INPUT class=InputStyle maxLength=3 size=45 name="proportion" onchange='checkinput("proportion","proportionimage")'
				onKeyPress="ItemCount_KeyPress()"
				temptitle="<%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%>">&#37;
			</wea:required>
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>

<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
</BODY>
</HTML>