
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
boolean canedit = HrmUserVarify.checkUserRight("EditCreditInfo:Edit",user);
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	String id = Util.null2String(request.getParameter("id"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	if(!isclose.equals("1"))
	{
		RecordSet.executeProc("CRM_CreditInfo_SelectByID",id);
	
		if(RecordSet.getFlag()!=1)
		{
			response.sendRedirect("/CRM/DBError.jsp?type=FindData");
			return;
		}
		if(RecordSet.getCounts()<=0)
		{
			response.sendRedirect("/CRM/DBError.jsp?type=FindData");
			return;
		}
		RecordSet.first();
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript >
function checkSubmit(){
    if(check_form(weaver,'name,money')){
        weaver.submit();
    }
}
var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);
if("<%=isclose%>"=="1"){
	parentWin.location = "ListCreditInfoInner.jsp";
	parentWin.closeDialog();
}

jQuery(function(){
	checkinput("name","nameimage");
	checkinput("money","moneyimage");
});
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
if (canedit)
	titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":&nbsp;"+SystemEnv.getHtmlLabelName(580,user.getLanguage());
else
	titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":&nbsp;"+SystemEnv.getHtmlLabelName(580,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if (canedit){  
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),''} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(580,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<%if (canedit){  %>
				<input class="e8_btn_top middle" onclick="checkSubmit()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM id=weaver name="weaver" action="/CRM/Maint/CreditInfoOperation.jsp" method=post >
<input type="hidden" name="method" value="edit">
<input type="hidden" name="id" value="<%=id%>">

<wea:layout>
	<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(603,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="nameimage" required="true" value="">
				<% if(canedit) {%><INPUT class=InputStyle maxLength=150 style="width: 300px;" size=45 name="name" value="<%=Util.toScreenToEdit(RecordSet.getString(2),user.getLanguage())%>" onchange='checkinput("name","nameimage")' >
				<%}else {%><%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%><%}%>
			</wea:required>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(595,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="moneyimage" required="true" value="">
				<% if(canedit) {%><INPUT class=InputStyle maxLength=150 size=45 name="money"  
					temptitle="<%=SystemEnv.getHtmlLabelName(534,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(595,user.getLanguage())%>"
					onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("money");checkinput("money","moneyimage")' 
					value="<%=RecordSet.getString(3)%>"><%}else {%><%=RecordSet.getString(3)%><%}%>
			</wea:required>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(595,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(594,user.getLanguage())%></wea:item>
		<wea:item>
			<% if(canedit) {%><INPUT class=InputStyle maxLength=150 size=45 name="highamount"  
				onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("highamount")' value="<%=RecordSet.getString(4)%>">
			<%}else {%><%=RecordSet.getString(4)%><%}%>
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
