
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String titlename = "" + SystemEnv.getHtmlLabelName(571,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());
%>


<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />

<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script type="text/javascript">
	function saveInfo(){
		 jQuery.post("MailMaintOperation.jsp",jQuery("form").serialize(),function(){
		 	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22619,user.getLanguage())%>");
		 });	
	}
	
	function showEmlDetail(obj){
		if(!jQuery(obj).is(":checked"))
		 	showGroup("emldetail");
		else
		 	hideGroup("emldetail");
	}
</script>
</head>

<%
	int emlPeriod = 30;
	String emlpath = "1";
	int isEml = 1;
	String attributes = "{samePair:'emldetail',itemAreaDisplay:'none',groupOperDisplay:'none'}";
	rs.execute("select * from MailConfigureInfo");
	while(rs.next()){
		isEml = rs.getInt("isEml");
		emlpath = Util.null2String(rs.getString("emlpath"),"1");
		emlPeriod = rs.getInt("emlPeriod");
	}
	if(isEml == 1)
		attributes = "{samePair:'emldetail',groupOperDisplay:'none'}";
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCFromPage="mailOption";//屏蔽右键菜单时使用
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveInfo(),_self} " ;    
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="saveInfo()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="菜单" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form method="post" action="MailMaintOperation.jsp" name="weaver">
<input type="hidden" name="method" value="emlsetting">
<wea:layout attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%>EML</wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="isEml" id="isEml" value="1" class="inputstyle" 
				<%if(isEml == 1)out.println("checked=checked");%> onchange="showEmlDetail(this)"/>
		</wea:item>

	</wea:group>
	
	
	<wea:group context="" attributes='<%=attributes %>'>
		<wea:item>EML<%=SystemEnv.getHtmlLabelNames("30986,32520",user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="emlpathSpan" >
				<input  name="emlpath"  id="emlpath" value="<%=emlpath %>" maxlength="50" style="width :300px" 
					onchange="checkinput('smtpServer','smtpServerSpan')" class="InputStyle"><img title="设置文件目录路径不能含有中文，不填写将默认存放在系统程序目录filesystem下！" src="/email/images/help_mail_wev8.png" align="absMiddle" />
			</wea:required>
		</wea:item>
		<wea:item>EML<%=SystemEnv.getHtmlLabelNames("30986,31726",user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="emlPeriodSpan" required="true">
				<input  name="emlPeriod"  id="emlPeriod" value="<%=emlPeriod %>" maxlength="50" style="width :50px" 
					onchange="checkinput('smtpServer','smtpServerSpan')" class="InputStyle">
			</wea:required>/天
		</wea:item>
	</wea:group>
</wea:layout>
</form>
</body>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>  
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>

