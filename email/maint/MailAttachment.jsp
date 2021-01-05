<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.email.po.Mailconfigureinfo"%>
<%@page import="weaver.email.MailReciveStatusUtils"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
    String showTop = Util.null2String(request.getParameter("showTop"));
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = "" + SystemEnv.getHtmlLabelName(571,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());
%>

<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>

<script type="text/javascript">
	function saveInfo(){
		 var totalAttachmentSize=$("#totalAttachmentSize").val();
		 var perAttachmentSize=$("#perAttachmentSize").val();
		 var attachmentCount=$("#attachmentCount").val();
		 
		 if(attachmentCount=="" || attachmentCount == "0") { 
		 	window.top.Dialog.alert("附件总数不能为空或者0");
		 	return;
		 }
		 
		 if(totalAttachmentSize=="" || totalAttachmentSize == "0") {
		 	totalAttachmentSize=0;
		 	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(124832,user.getLanguage())%>0");
		 	return;
		 }
		 if(perAttachmentSize=="" || perAttachmentSize == "0"){
		 	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(124833,user.getLanguage())%>0");
		 	return;
		 }
		 		 
		if(parseInt(totalAttachmentSize) > 300){
		 	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(124834,user.getLanguage())%>300");
		 	return;
		 }	
		 
		 if(parseInt(perAttachmentSize) > 300){
		 	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(124835,user.getLanguage())%>300");
		 	return;
		 }	
		 
		 if(parseInt(totalAttachmentSize)<parseInt(perAttachmentSize)){
		 	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(124836,user.getLanguage())%>");
		 	return;
		 }
		 
		 
		 jQuery.post("MailMaintOperation.jsp",jQuery("form").serialize(),function(flag){
		 	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22619,user.getLanguage())%>");
		 	window.location.reload();
		 });	
	}
	
</script>
</head>

<%
    Mailconfigureinfo mailconfigureinfo = MailReciveStatusUtils.getMailconfigureinfoFromCache();
	String filePath = mailconfigureinfo.getFilePath();
	String totalAttachmentSize = "" + mailconfigureinfo.getTotalAttachmentSize();
	String perAttachmentSize = "" + mailconfigureinfo.getPerAttachmentSize();
	String attachmentCount = "" + mailconfigureinfo.getAttachmentCount();
    
	if(filePath == null || "".equals(filePath)) {
	    filePath = GCONST.getRootPath() + "filesystem" + File.separatorChar;
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
    <wea:layout attributes="{layoutTableId:topTitle}">
    	<wea:group context="" attributes="{groupDisplay:none}">
    		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
    			<input class="e8_btn_top middle" onclick="saveInfo()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
    			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
    		</wea:item>
    	</wea:group>
    </wea:layout>
    
    <form method="post" action="MailMaintOperation.jsp" name="weaver">
        <input type="hidden" name="method" value="mailAttachment">
        <wea:layout attributes="{'expandAllGroup':'true'}">
        	<wea:group context='<%=SystemEnv.getHtmlLabelName(156,user.getLanguage())+SystemEnv.getHtmlLabelName(16447,user.getLanguage())%>'>
        		<wea:item><%=SystemEnv.getHtmlLabelName(20450,user.getLanguage())%></wea:item>
        		<wea:item>
        			<input  name="filePath"  value="<%=filePath%>" maxlength="50"
        				 style="width :30%" class="InputStyle"><span>（<%=SystemEnv.getHtmlLabelName(21835,user.getLanguage())%>）</span>					
        		</wea:item>
        	</wea:group>
        	
        	<wea:group context='<%=SystemEnv.getHtmlLabelName(124840,user.getLanguage())%>'>
        		<wea:item><%=SystemEnv.getHtmlLabelName(124838,user.getLanguage())%></wea:item>
        		<wea:item>
        			<wea:required id="totalAttachmentSizeSpan" >
        				<input  name="totalAttachmentSize" id="totalAttachmentSize"  value="<%=totalAttachmentSize%>" style="width :60px;"
        					onchange="checkinput('totalAttachmentSize','totalAttachmentSizeSpan')" maxlength="50" size=5 onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)' class="InputStyle">
        				M&nbsp;&nbsp;(<%=SystemEnv.getHtmlLabelName(124837,user.getLanguage())%>300)
        			</wea:required>
        		</wea:item>
        		
        		<wea:item><%=SystemEnv.getHtmlLabelName(124839,user.getLanguage())%></wea:item>
        		<wea:item>
        			<wea:required id="perAttachmentSizeSpan" >
        			<input  name="perAttachmentSize" id="perAttachmentSize" value="<%=perAttachmentSize%>" style="width :60px;"
        				onchange="checkinput('perAttachmentSize','perAttachmentSizeSpan')" maxlength="50" size=5 onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)' class="InputStyle">
        			M&nbsp;&nbsp;(<%=SystemEnv.getHtmlLabelName(124837,user.getLanguage())%>300)
        			</wea:required>
        		</wea:item>
        		
        		<wea:item><%=SystemEnv.getHtmlLabelName(795,user.getLanguage())%></wea:item>
        		<wea:item>
        			<wea:required id="attachmentCountSpan" >
        			<input  name="attachmentCount" id="attachmentCount" value="<%=attachmentCount%>" style="width :60px;"
        				onchange="checkinput('attachmentCount','attachmentCountSpan')" maxlength="50" size=5 onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this)' class="InputStyle">
        			<%=SystemEnv.getHtmlLabelName(83077,user.getLanguage())%>&nbsp;&nbsp;
        			</wea:required>
        		</wea:item>
        		
        	</wea:group>
        </wea:layout>
    </form>
</body>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>  
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>