
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<%
    int wtid = Util.getIntValue(request.getParameter("wtid"),0); 

    String isclose = Util.null2String(request.getParameter("isclose"));
    
    //System.out.println("isclose==============="+isclose);
    String titlename = "";
%>

<html>
<HEAD> 
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="worktask"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())+SystemEnv.getHtmlLabelName(15807,user.getLanguage())%>"/>  
</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
   
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
			   <td>
				</td>
				<td class="rightSearchSpan" style="text-align:right; ">
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"
						class="e8_btn_top middle" onclick="doSave(this);">
					<span title="<%=SystemEnv.getHtmlLabelName(2104,user.getLanguage()) %>" class="cornerMenu middle"></span>
				</td>
			</tr>
		</table>
		<div id="tabDiv" >
			<span id="hoverBtnSpan" class="hoverBtnSpan">
					<span></span>
			</span>
		</div>
		<div class="advancedSearchDiv" id="advancedSearchDiv">
		</div>
	
		<div class="zDialog_div_content">

        <form name="weaverA" method="post" action="worktaskMonitorOperator.jsp">
          <INPUT TYPE="hidden" NAME="wtid" value="<%=wtid%>">           
		  <INPUT type="hidden" Name="method" value="savemonitor">


                <wea:layout type="2col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' >
						<!-- 对象 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(15807, user.getLanguage())%></wea:item>
						<wea:item>
							<span id="useridSP" style="float:left;">
							<brow:browser viewType="0" name="monitor" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="260px"
							completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
							browserSpanValue=""></brow:browser>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(21969, user.getLanguage())%></wea:item>
						<wea:item >	
							<SELECT class="InputStyle" name="monitortype" id="monitortype" style="width:120px;">
							    <option value="0" selected><%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%></option> 
                                 <option value="1"><%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%></option> 
                                 <option value="2"><%=SystemEnv.getHtmlLabelName(140, user.getLanguage())%></option>
							  </SELECT>
						</wea:item>
					</wea:group>
				</wea:layout>
                </form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="zd_btn_cancle" onclick="parentDialog.close();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</body>
</html>


<SCRIPT LANGUAGE="JavaScript">
 
if("<%=isclose%>"=="1"){
    //alert("<%=isclose%>");
	var dialog = parent.getDialog(window);
	dialog.currentWindow.location.reload()
	dialog.close();	
}


function doSave(){
 if(check_form(document.weaverA,'monitor')) {
       document.weaverA.submit();
 }

}

</SCRIPT>


