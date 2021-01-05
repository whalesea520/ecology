
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(136,user.getLanguage()) + SystemEnv.getHtmlLabelName(216,user.getLanguage());
String needfav ="1";
String needhelp ="";
String CustomerID=Util.null2String(request.getParameter("CustomerID"));
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
String userid = ""+user.getUID();
%>
<BODY>
<%if(!isfromtab) {%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%} %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(84367,user.getLanguage())%>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="doSave()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM id=weaver action="/CRM/data/UniteCustomerOperation.jsp" method=post >
<wea:layout type="2col">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item>
				CRM(<%=SystemEnv.getHtmlLabelName(6074,user.getLanguage())%>)
			</wea:item>
			<wea:item>
				<%
					String browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?crmManager="+userid;
					String mainCustomerName=CustomerInfoComInfo.getCustomerInfoname(CustomerID);
				%>
				<brow:browser viewType="0" name="CustomerID" browserValue='<%=CustomerID%>' 
					browserOnClick="" 
					browserUrl='<%=browserUrl%>' 
					hasInput="false" isSingle="true" 
					hasBrowser = "true" isMustInput='2'
					linkUrl="/CRM/data/ViewCustomer.jsp?CustomerID=" 
					width="90%" browserSpanValue='<%=mainCustomerName%>'> 
				</brow:browser>
				
			</wea:item>
			
			<wea:item>
				CRM(<%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%>)
			</wea:item>
			<wea:item>
				<%
					String browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?crmManager="+userid;
				%>
				<brow:browser viewType="0" name="crmids" 
				         browserUrl='<%=browserUrl %>'
				         isSingle="false" hasBrowser="true"  hasInput="true" isMustInput="1"
				         completeUrl="/data.jsp?type=18" width="90%" ></brow:browser>
			</wea:item>
		</wea:group>
</wea:layout>
</FORM>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 

<script language=javascript>
function doSave(){
    if (check_form(document.forms[0],"CustomerID,crmids")) {
        
        window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15160,user.getLanguage())%>？",function(){
			var sub = document.all("crmids").value;
	        var main = document.all("CustomerID").value;
			
			if(sub == main){
				parent.getDialog(window).close();
				return;
			}
			
	        var subStr = new String(sub);
	        var result = "";
	        var begin = subStr.indexOf(main);
	        
	        sub = ","+sub+","
	        if (sub.indexOf(main) != -1) {
	        	sub = sub.replace(","+main+",",",");
	        }
	        sub = sub.substring(1,sub.length-1);
	        document.all("crmids").value = sub;
	        document.forms[0].submit();
		});
    }
}
</script>
</BODY>
</HTML>
