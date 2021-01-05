
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
boolean canedit = HrmUserVarify.checkUserRight("EditCustomerStatus:Edit",user);
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	String id = Util.null2String(request.getParameter("id"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	
	//which tab 基本信息;显示字段名 add by Dracula @2014-1-28
	String winfo = Util.null2String(request.getParameter("winfo"));
	String name = "";
	String desc = "";
	String cnname = "";
	String usname = "";
	String twname = "";
	if(!isclose.equals("1"))
	{
		RecordSet.executeProc("CRM_CustomerStatus_SelectByID",id);
		if(RecordSet.next())
		{
			name = Util.null2String(RecordSet.getString(2));
			desc = Util.null2String(RecordSet.getString(3));
			cnname = Util.null2String(RecordSet.getString("cnname"));
			usname = Util.null2String(RecordSet.getString("usname"));
			twname = Util.null2String(RecordSet.getString("twname"));
		}
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
	}
	if(cnname.equals(""))
	{
		cnname = Util.toScreenToEdit(RecordSet.getString(2),user.getLanguage());
	}
	
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript >
function checkSubmit(){
    if(check_form(weaver,'name')){
        weaver.submit();
    }
}
var parentWin = parent.parent.getParentWindow(parent.window);
if("<%=isclose%>"=="1"){
	parentWin.location = "ListCustomerStatusInner.jsp";
	parentWin.closeDialog();
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
if (canedit)
	titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":&nbsp;"
		+SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(602,user.getLanguage());
else
	titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":&nbsp;"
		+SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(602,user.getLanguage());

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

<FORM id=weaver name="weaver" action="/CRM/Maint/CustomerStatusOperation.jsp" method=post>
<input type="hidden" name="method" value="edit">
<input type="hidden" name="id" value="<%=id%>">


<wea:layout attributes="{layoutTableId:CRM_CS_BaseInfo_Table}">
	<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' >
		<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
			<% if(canedit) {%><INPUT class=InputStyle maxLength=150 style="width: 300px;" size=45 name="name" value="<%=Util.toScreenToEdit(RecordSet.getString(2),user.getLanguage())%>" onchange='checkinput("name","nameimage")' ><%}else {%><%=name%><%}%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		<wea:item>
			<% if(canedit) {%><INPUT class=InputStyle maxLength=150 style="width: 300px;" size=45 name="desc" value="<%=Util.toScreenToEdit(RecordSet.getString(3),user.getLanguage())%>"><%}else {%><%=desc%><%}%>
		</wea:item>
	</wea:group>
</wea:layout>


<wea:layout attributes="{layoutTableId:CRM_CS_ShowName_Table,'cw1':'35','cw2':'65%'}">
	<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%> (简体中文)</wea:item>
		<wea:item>
			<% if(canedit) {%><INPUT class=InputStyle maxLength=150 size=35 name="cnname"  value="<%=cnname%>"><%}else {%><%=cnname%><%}%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%> (English)</wea:item>
		<wea:item>
			<% if(canedit) {%><INPUT class=InputStyle maxLength=150 size=35 name="usname" value="<%=usname%>"><%}else {%><%=usname%><%}%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%> (繁體中文)</wea:item>
		<wea:item>
			<% if(canedit) {%><INPUT class=InputStyle maxLength=150 size=35 name="twname" value="<%=twname%>"><%}else {%><%=twname%><%}%>
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

</BODY>
<script language=javascript >
if("<%=winfo%>" == "1")
	$("#CRM_CS_ShowName_Table").css("display","none");
else
	$("#CRM_CS_BaseInfo_Table").css("display","none");
</script>
</HTML>
