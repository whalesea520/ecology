
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>


<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));

RecordSetC.executeProc("CRM_ContacterLog_R_SById",CustomerID);
RecordSetC.next();
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script language=javascript >
var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);
function doSave(){
    if(check_form(weaver,'before')){
        weaver.submit();
    }
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6061,user.getLanguage())+" - "+"<a href=/CRM/data/ViewCustomer.jsp?CustomerID="+CustomerID+">"+Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(CustomerID),user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
%>
<BODY>
<%if(!isfromtab) {%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%} %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(589,user.getLanguage())+",javascript:document.weaver.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(6061,user.getLanguage()) %>"/>
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

<FORM id=weaver name=weaver action="ContacterLogRemindOperation.jsp" method=post onsubmit='return check_form(this,"before")'>
	<input type="hidden" name="CustomerID" value="<%=CustomerID%>">
	<wea:layout type="2col" attributes="{'cw1':'30%','cw2':'70%'}">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(33396,user.getLanguage())%>' >
				<wea:item><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></wea:item>
				<wea:item>
					<INPUT type=checkbox  tzCheckbox="true" name="isremind" <%=RecordSetC.getString("isremind").equals("0")?"checked":""%> value="0"/>
				</wea:item>
				
				<wea:item><%=SystemEnv.getHtmlLabelName(34219,user.getLanguage())%></wea:item>
				<wea:item>
					<INPUT class=InputStyle style="width:50px" name="before" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("before")' onchange='checkinput("before","beforeimage")' value = "<%=RecordSetC.getString("before")%>"><%=SystemEnv.getHtmlLabelName(34221,user.getLanguage())%><SPAN id=beforeimage><%if (RecordSetC.getString("before").equals("")) {%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN>
				</wea:item>
				
			</wea:group>
	</wea:layout>
</FORM>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.ContacterRemindCallback();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</BODY>
</HTML>
