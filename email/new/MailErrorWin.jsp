
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	String solution = Util.null2String(request.getParameter("solution"), "");
	String errorString = Util.null2String(request.getParameter("errorString"), "");
	String mailaccid = Util.null2String(request.getParameter("mailaccid"), "0");
	
	String accountName="";
	String accountId = "";
	String accountPassword = "";
	String serverType = "";
	String popServer = "";
	String popServerPort = "";
	String smtpServer = "";
	String smtpServerPort = "";
	String needCheck = "";
	String getneedSSL = "";
	String sendneedSSL = "";
	rs.execute("select accountId, accountPassword, serverType, popServer, popServerPort, smtpServer, smtpServerPort, needCheck, getneedSSL, sendneedSSL from MailAccount where id = "+mailaccid);
	if(rs.next()) {
		accountName = Util.null2String(rs.getString("accountName"),"");
		accountId = Util.null2String(rs.getString("accountId"),"");
		accountPassword = Util.null2String(rs.getString("accountPassword"),"");
		serverType = Util.null2String(rs.getString("serverType"),"");
		popServer = Util.null2String(rs.getString("popServer"),"");
		popServerPort = Util.null2String(rs.getString("popServerPort"),"");
		smtpServer = Util.null2String(rs.getString("smtpServer"),"");
		smtpServerPort = Util.null2String(rs.getString("smtpServerPort"),"");
		needCheck = Util.null2String(rs.getString("needCheck"),"");
		getneedSSL =Util.null2String(rs.getString("getneedSSL"),"");
		sendneedSSL = Util.null2String(rs.getString("sendneedSSL"),"");
		
		
	}
	
%>


<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/js/prototype_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
</head>


<body>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="mail"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(25700,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
		</wea:item>
	</wea:group>
</wea:layout>

<form method="post" action="MailAccountOperation.jsp" id="fMailAccount" name="fMailAccount">
<input type="hidden" name="operation" value="systemset" />
<input type="hidden" name="accountMailAddress" value="<%=accountName %>" />
<input type="hidden" name="accountId" value="<%=accountId %>" />
<input type="hidden" name="accountPassword" value="<%=accountPassword %>" />
<input type="hidden" name="serverType" value="<%=serverType %>" />
<input type="hidden" name="popServer" value="<%=popServer %>" />
<input type="hidden" name="popServerPort" value="<%=popServerPort %>" />
<input type="hidden" name="smtpServer" value="<%=smtpServer %>" />
<input type="hidden" name="smtpServerPort" value="<%=smtpServerPort %>" />
<input type="hidden" name="needCheck" value="<%=needCheck %>" />
<input type="hidden" name="getneedSSL" value="<%=getneedSSL %>" />
<input type="hidden" name="sendneedSSL" value="<%=sendneedSSL %>" />
<wea:layout attributes="{'expandAllGroup':'true','cw1':'10%','cw2':'90%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(24647,user.getLanguage()) %>'>
		<wea:item></wea:item>
		<wea:item><%=solution %></wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(82875,user.getLanguage()) %>'>
		<wea:item></wea:item>
		<wea:item><div style="color: red"><%=errorString %><div></wea:item>
	</wea:group>
</wea:layout>
</form>
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

<script language="javascript">

 
 	var diag = null;
	function closeDialog(){
		if(diag){
			diag.close();
		}
		parent.getParentWindow(window).closeDialog();
	}
	
	function MailAccountSubmit(){
	    diag = new window.top.Dialog();
		diag.currentWindow = window;
		var url = "/email/MailAccountEdit.jsp?id=<%=mailaccid%>";
		diag.Title = "<%=SystemEnv.getHtmlLabelNames("93,23845,87",user.getLanguage()) %>";
		diag.Width = 600;
		diag.Height = 530;
		diag.Drag = true;
		diag.URL = url;
		diag.show();
	 	
	}


</script>
</body>
