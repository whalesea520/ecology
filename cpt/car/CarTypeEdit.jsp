
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
String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17630,user.getLanguage());
String needfav ="1";
String needhelp ="";

String id=Util.fromScreen(request.getParameter("id"),user.getLanguage());
String dialog=Util.null2String(request.getParameter("dialog"),"0");
String isclose = Util.null2String(request.getParameter("isclose"));
String name="";
String description="";
String usefee="";
String CanDelete=request.getParameter("CanDelete");
RecordSet.executeProc("CarType_SelectByID",id);
if(RecordSet.next()){
    name=RecordSet.getString("name");
    description=RecordSet.getString("description");
    usefee=RecordSet.getString("usefee");
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:submitData(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{" + SystemEnv.getHtmlLabelName(309, user.getLanguage())+",javascript:closePrtDlgARfsh(),_self} ";
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="javascript:onSave()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>			
<form id=frmmain name=frmmain action="CarTypeOperation.jsp" STYLE="margin-bottom:0" method=post>
<input type="hidden" name=operation>
<input type="hidden" name=dialog value=<%=dialog%>>
<input type="hidden" name=id value=<%=id%>>
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(17630,user.getLanguage())%>'>
		<% if ("1".equals(CanDelete)) { %>
			<wea:item>
			</wea:item>
			<wea:item>
				<font color="red"><%=SystemEnv.getHtmlLabelName(21018,user.getLanguage())%></font>
			</wea:item>
		<% } %>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<INPUT class=inputstyle type=text size=30 name="name" onchange='checkinput("name","nameimage")' value="<%=name%>">
    		<SPAN id=nameimage></SPAN>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<INPUT class=inputstyle type=text size=60 name="description" value="<%=description%>">
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(1491,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<INPUT class=inputstyle type=text size=20 name="usefee" onKeyPress="ItemNum_KeyPress()" 
    			onBlur="checknumber1(this);checkinput('usefee','usefeespan')" value="<%=usefee%>">
    		<SPAN id=usefeespan></SPAN><%=SystemEnv.getHtmlLabelName(17647,user.getLanguage())%>
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
<script language=javascript>
function onSave(){
	if(check_form($GetEle("frmmain"),'name,usefee')){
		$GetEle("operation").value="edit";
		$GetEle("frmmain").submit();
	}
}
function onDelete(){
		if(isdel()) {
			$GetEle("operation").value="delete";
			$GetEle("frmmain").submit();
		}
}
function submitData() {
    history.go(-1);
}
function closePrtDlgARfsh(){
	window.parent.closeWinAFrsh();
}
 </script>
</BODY></HTML>
