
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<% 
if(!HrmUserVarify.checkUserRight("CrmSalesChance:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String str="select * from CRM_SelltimeSpan";
RecordSet.executeSql(str);
String operation = "add";
String time = "";
String spannum = "";
while(RecordSet.next()){
	operation = "edit";
	time=RecordSet.getString("timespan");
	spannum=RecordSet.getString("spannum");
}

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(15102,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<SCRIPT language="JavaScript">
function doSave() {
	if (check_form(document.weaver, "time,spannum"))
		document.weaver.submit();
}

jQuery(function(){
	checkinput("time","timeimage");
	checkinput("spannum","spannumimage");
});

var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);

</SCRIPT>

<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(16498,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSave()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>


<FORM name="weaver" action="/CRM/sellchance/CRMTimespanOperation.jsp" method=post>
<input type="hidden" name="method" value="<%=operation %>">
	<wea:layout attributes="{'cw1':'30%','cw2':'70%'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(61,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage())%>'>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(15237,user.getLanguage())%></wea:item>
			<wea:item>
				<wea:required id="timeimage" required="true">
					<INPUT text class=InputStyle maxLength=50 size=20 name="time" value="<%=time%>" 
						onBlur='checkcount1(this);checkinput("time","timeimage")' onKeyPress="ItemCount_KeyPress()" >
				</wea:required>
			</wea:item>
		
			<wea:item><%=SystemEnv.getHtmlLabelName(15238,user.getLanguage())%></wea:item>
			<wea:item>
				<wea:required id="spannumimage" required="true">
					<INPUT text class=InputStyle maxLength=50 size=20 name="spannum" value="<%=spannum%>" 
						onBlur='checkcount1(this);checkinput("spannum","spannumimage")' onKeyPress="ItemCount_KeyPress()" > 
				</wea:required>
			
			</wea:item>
		</wea:group>
	</wea:layout>
</FORM>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 


</BODY>
</HTML>
