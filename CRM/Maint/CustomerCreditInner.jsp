
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6097,user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(6098,user.getLanguage());
String needfav ="1";
String needhelp ="";

boolean canedit = HrmUserVarify.checkUserRight("CRM_CustomerCreditAdd:Add",user);
if (!canedit) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%
String CreditAmount = "" ;
String CreditTime = "";
String CurrencyID = "";
RecordSet.execute("select * from CRM_CustomerCredit");
if (RecordSet.next()) {
	CreditAmount = RecordSet.getString("CreditAmount");
	CreditTime = RecordSet.getString("CreditTime");
	CurrencyID = RecordSet.getString("currencytype");
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave1(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSave1()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="菜单" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>


<FORM name=weaver action="/CRM/Maint/CustomerCreditOperation.jsp" method=post >
<input type="hidden" name="method" value="edit">

<wea:layout>
	<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></wea:item>
		<wea:item>
       		<brow:browser viewType="0" name="currencytype" 
	        	browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp"
	        	browserValue='<%=CurrencyID%>'
		        browserSpanValue='<%=Util.toScreen(CurrencyComInfo.getCurrencyname(CurrencyID),user.getLanguage()) %>'
	        	isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='2'
	        	completeUrl="/data.jsp?type=12" width="150px" ></brow:browser>
		</wea:item>
			
		<wea:item><%=SystemEnv.getHtmlLabelName(6097,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="CreditAmountimage" required="true">
				<INPUT class=InputStyle maxLength=11 size=20 name="CreditAmount" style="width: 150px"
					temptitle="<%=SystemEnv.getHtmlLabelName(6097,user.getLanguage())%>"
					onchange='checkinput("CreditAmount","CreditAmountimage");checkdecimal_length("CreditAmount",8)' 
					onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("CreditAmount")' value = "<%=CreditAmount%>">
			</wea:required>
		</wea:item>
		
		
		
		<wea:item><%=SystemEnv.getHtmlLabelName(6098,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="CreditTimeimage" required="true">
				<INPUT class=InputStyle maxLength=3 size=10 name="CreditTime" style="width: 150px"
					temptitle="<%=SystemEnv.getHtmlLabelName(6098,user.getLanguage())%>"
					onchange='checkinput("CreditTime","CreditTimeimage")' 
					onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("CreditTime")' value = "<%=CreditTime%>">
			</wea:required>
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>

<script language=javascript>
function doSave1(){	
	if (check_form(weaver,"CreditAmount,CreditTime,currencytype")){ 
		weaver.submit();
	}
}	
jQuery(function(){
	checkinput("CreditAmount","CreditAmountimage");
	checkinput("CreditTime","CreditTimeimage");
});
</script>
</BODY>
</HTML>
