
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
String showTop = Util.null2String(request.getParameter("showTop"));
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(571,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());
%>
<head>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
</head>
<script language="javascript">
var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);

function saveInfo(){
	
	if(check_form(weaver,'totalspace')){
		 jQuery.post("MailMaintOperation.jsp",jQuery("form").serialize(),function(){
		 	parentWin.closeDialog();
		 });
	}
	
}

jQuery(function(){
	checkinput("totalspace","totalspaceimage");
});
</script>

<%
	String id = Util.null2String(request.getParameter("id"));
	rs.execute("select lastname ,totalspace  from hrmresource where id = "+id);
	String lastname = "";
	String totalspace = "100";
	while(rs.next()){
		lastname = rs.getString("lastname");
		totalspace = rs.getString("totalspace");
	}

%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCFromPage="mailOption";//屏蔽右键菜单时使用
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveInfo(),_self} " ;    
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="mail"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(34246,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="saveInfo()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="菜单" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form method="post" action="MailMaintOperation.jsp" name="weaver">
<input type="hidden" name="method" value = "editMailSpace">
<input type="hidden" name="id" value = "<%=id %>">
<wea:layout attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></wea:item>
		<wea:item><%=lastname %></wea:item>
		
		<wea:item>邮箱空间</wea:item>
		<wea:item>
			<wea:required id="totalspaceimage" required="true">
				<INPUT class="InputStyle" maxLength=10 size=5 name="totalspace" onKeyPress="ItemCount_KeyPress()" 
					onchange='checknumber("totalspace");checkinput("totalspace","totalspaceimage")' value="<%=totalspace %>" style="width: 150px;">
			</wea:required>
		</wea:item>
	</wea:group>
</wea:layout>
</form>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
</body>
