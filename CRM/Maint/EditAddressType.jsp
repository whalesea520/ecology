
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<% 
boolean canedit = HrmUserVarify.checkUserRight("EditAddressType:Edit",user);
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	int msgid = Util.getIntValue(request.getParameter("msgid"), -1);
	String id = Util.null2String(request.getParameter("id"));
	
	String isclose = Util.null2String(request.getParameter("isclose"));
	if(!isclose.equals("1"))
	{
		RecordSet.executeProc("CRM_AddressType_SelectByID",id);
		
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
    if(check_form(weaver,'type')){
        weaver.submit();
    }
}
if("<%=isclose%>"=="1"){
	parent.getParentWindow(window)._table.reLoad();
	parent.getDialog(window).close();
}

jQuery(function(){
	checkinput("type","typeimage");
});
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
if (canedit) 
	titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())
				+":"+SystemEnv.getHtmlLabelName(110,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage());
else
	titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())
				+":"+SystemEnv.getHtmlLabelName(110,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage());

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
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(16486,user.getLanguage()) %>"/>
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

<wea:layout>
	<wea:group context="" attributes="{groupDisplay:none,itemAreaDisplay:none}">
		<%if (msgid != -1) {%>
		<wea:item><FONT color="red" size="2"><%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%></FONT></wea:item>
		<%}%>
	</wea:group>
</wea:layout>
	

<FORM id=weaver action="/CRM/Maint/AddressTypeOperation.jsp" method=post>
<input type="hidden" name="method" value="edit">
<input type="hidden" name="id" value="<%=id%>">

<wea:layout>
	<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<wea:required id="typeimage" required="true" value="">
				<% if(canedit) {%><INPUT class=InputStyle maxLength=150 style="width: 300px;" size=45 name="type" value="<%=Util.toScreenToEdit(RecordSet.getString(2),user.getLanguage())%>" onchange='checkinput("type","typeimage")' >
				<%}else {%><%=Util.toScreen(RecordSet.getString(2),user.getLanguage())%><%}%>
			</wea:required>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<% if(canedit) {%><INPUT class=InputStyle maxLength=150 size=45 name="desc" value="<%=Util.toScreenToEdit(RecordSet.getString(3),user.getLanguage())%>"><%}else {%><%=Util.toScreen(RecordSet.getString(3),user.getLanguage())%><%}%>
		</wea:item>
	</wea:group>
</wea:layout>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close();">
	    </wea:item>
		</wea:group>
	</wea:layout>
</div>

</FORM>

<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</BODY>
</HTML>
