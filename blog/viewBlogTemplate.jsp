
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="MailMouldManager" class="weaver.email.MailMouldManager" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(71,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
</head>

<%
String operation=Util.null2String(request.getParameter("operation"));
int tempid=Util.getIntValue(request.getParameter("tempid"),0);

String tempName="";
String isUsed="1";
String tempContent="";

String sqlstr="select * from blog_template where id="+tempid;
RecordSet.execute(sqlstr);

if(RecordSet.next()){
	tempName=RecordSet.getString("tempName");
	isUsed=RecordSet.getString("isUsed");
	tempContent=RecordSet.getString("tempContent");
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="blog"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(64,user.getLanguage()) %>"/>
</jsp:include>


<div class="zDialog_div_content" style="height:490px;">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></wea:item>
		<wea:item><%=RecordSet.getString("tempName")%></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(18627,user.getLanguage())%></wea:item>
		<wea:item><%=RecordSet.getString("tempDesc")%></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
		<wea:item>
				<input tzCheckbox="true" type="checkbox" name="isUsed" <%if(isUsed.equals("1")){%>checked="checked"<%}%> value="1" disabled="disabled"/>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(20622,user.getLanguage())%></wea:item>
		<wea:item><%=RecordSet.getString("isSystem").equals("1")?SystemEnv.getHtmlLabelName(83158,user.getLanguage()):SystemEnv.getHtmlLabelName(83159,user.getLanguage())%></wea:item>
		
		
		
		<wea:item ><%=SystemEnv.getHtmlLabelName(18693,user.getLanguage())%></wea:item>
		<wea:item >
			<%=RecordSet.getString("tempContent") %>
		</wea:item>
	</wea:group>
</wea:layout>
</div>

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
</body>
</html>
