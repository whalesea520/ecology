
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page"/>
<% if(!HrmUserVarify.checkUserRight("CRM_ContractTypeAdd:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }

	String isclose = Util.null2String(request.getParameter("isclose"));
	String msgid = Util.null2String(request.getParameter("msgid"));
	int indetail = Util.getIntValue(request.getParameter("indetail"),0);
	String id = Util.null2String(request.getParameter("id"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript >
function checkSubmit(){
    if(check_form(weaver,'name')){
        weaver.submit();
    }
}
var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);
if("<%=isclose%>"=="1" && "<%=indetail%>"=="0"){
	parent.getParentWindow(window)._table.reLoad();
	parent.getDialog(window).close();
}

if("<%=isclose%>"=="1" && "<%=indetail%>"=="1"){
	parent.getParentWindow(window)._table.reLoad();
	parent.getParentWindow(window).doEdit("<%=id%>");
	parent.getDialog(window).close();
}


function checkSubmitDetail()
{
	$("input[name='indetail']").val("1");
	checkSubmit();
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
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
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(16482,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="checkSubmitDetail()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM id=weaver action="/CRM/Maint/CustomerTypeOperation.jsp" method=post>
	<input type="hidden" name="method" value="add">
	<input type="hidden" name="indetail" value="0">
	
<wea:layout attributes="{'cw1':'25%','cw2':'75%'}">
	<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<wea:required id="nameimage" required="true" value="">
				<INPUT class=InputStyle maxLength=50 size=45 name="name" onchange='checkinput("name","nameimage")'
				temptitle="<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>">
				<%if("17626".equals(msgid)){%><%=SystemEnv.getHtmlLabelName(17626,user.getLanguage())%><%}%> 
			</wea:required>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<INPUT class=InputStyle maxLength=150 size=45 name="desc">
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(15057,user.getLanguage())%></wea:item>
		<wea:item>
			<%String browserUrl = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere="+xssUtil.put("where isbill=1 and formid=79");%>
			<brow:browser viewType="0" name="workflowid"  
                	browserOnClick="" browserUrl="<%=browserUrl%>"
                	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
                	completeUrl="" width="267px"
                	browserSpanValue="" browserValue="" >
        	</brow:browser>
		</wea:item>
	</wea:group>
</wea:layout>
	
</FORM>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</BODY>
</HTML>
