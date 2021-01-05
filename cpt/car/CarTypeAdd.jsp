
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<% 
String isclosed = Util.null2String(request.getParameter("isclosed"),"0");
if(!HrmUserVarify.checkUserRight("Car:Maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script>
	<%if ("1".equals(isclosed)){%>
		window.parent.closeWinAFrsh();
	<%}%>
</script>
</head>

<%
String dialog=Util.null2String(request.getParameter("dialog"),"0");
String isclose = Util.null2String(request.getParameter("isclose"));
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17630,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32720,user.getLanguage())+",javascript:onSubmitAndCreate(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{" + SystemEnv.getHtmlLabelName(309, user.getLanguage())+",javascript:closePrtDlgARfsh(),_self} ";
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="javascript:onSubmit(this)" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(32720,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="javascript:onSubmitAndCreate(this)" type="button" value="<%=SystemEnv.getHtmlLabelName(32720,user.getLanguage())%>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>
<form name=frmmain action="CarTypeOperation.jsp">
<input type="hidden" name=operation value=add>
<input type="hidden" name=dialog value=<%=dialog%>>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(17630,user.getLanguage())%>'>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<INPUT class=inputstyle type=text size=30 name="name" onchange='checkinput("name","nameimage")'>
    		<SPAN id=nameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<INPUT class=inputstyle type=text size=60 name="description">
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(1491,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<INPUT class=inputstyle type=text size=20 name="usefee" onKeyPress="ItemNum_KeyPress()" 
   				 onBlur="checknumber1(this);checkinput('usefee','usefeespan')">
    		<SPAN id=usefeespan><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN><%=SystemEnv.getHtmlLabelName(17647,user.getLanguage())%></TD>
		</wea:item>
	</wea:group>
</wea:layout>
<%if ("1".equals(dialog)) {%>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
			<wea:group context="">
				<wea:item type="toolbar">
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
						id="zd_btn_cancle" class="zd_btn_cancle" onclick="closePrtDlgARfsh()">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
<%}%>
</form>
<script language="javascript">
function onSubmit()
{
    if(check_form($GetEle("frmmain"),'name,usefee')){
	    $GetEle("frmmain").submit();
    }
}
function onSubmitAndCreate()
{
    if(check_form($GetEle("frmmain"),'name,usefee')){
    	$GetEle("frmmain").operation.value="addAndNew";
	    $GetEle("frmmain").submit();
    }
}
function closePrtDlgARfsh(){
	window.parent.closeWinAFrsh();
}
</script>
</BODY></HTML>
