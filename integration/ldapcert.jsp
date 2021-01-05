
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.ldap.onlineImportCert.InstallCert" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>

<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />

<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>

<STYLE>
PRE {
	FONT-SIZE: 12pt;
}
</STYLE>
</head>
<%
if(!HrmUserVarify.checkUserRight("intergration:ldapsetting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = "LDAP"+SystemEnv.getHtmlLabelName(26267,user.getLanguage());//集成
String needfav ="1";
String needhelp ="";

String operator = Util.null2String(request.getParameter("operator"));

String host = Util.null2String(request.getParameter("host"));
int port = Util.getIntValue(request.getParameter("port"),636);

File file = new File("jssecacerts");
if (file.isFile() == false) {
	char SEP = File.separatorChar;
	File dir = new File(System.getProperty("java.home") + SEP + "lib" + SEP + "security");
	file = new File(dir, "jssecacerts");
	if (file.isFile() == false) {
		file = new File(dir, "cacerts");
	}
}
String certpath = file.getAbsolutePath().replaceAll("\\\\","/");
String certpwd = Util.null2String(request.getParameter("certpwd"));

String result = "";
String importResult = "";
if(operator.equals("installcert")){
	certpath = Util.null2String(request.getParameter("certpath"));
	try{
		InstallCert ic = new InstallCert(host,port,certpath,certpwd);
		result = ic.installcert();
	}catch(Exception e){
		result = SystemEnv.getHtmlLabelName(132184,user.getLanguage())+e.getMessage();
	}
	if(result.indexOf("Added certificate to keystore 'jssecacerts' using alias")>0){
		importResult = "ok";
	}
}

operator = "";
%>

<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(131959,user.getLanguage())+",javascript:installcert(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td><br></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onSubmit()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(25496 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onSubmitAndTest()"/>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>
<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="ldapcert.jsp">
<input type="hidden" id="operator" name="operator" value="<%=operator%>">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
	  <wea:item>LDAP IP</wea:item>
	  <wea:item>
	  	<wea:required id="hostimage" required="true" value='<%=host %>'>
	  	<input class="inputstyle" style='width:240px!important;' type=text size=50 maxLength="100" id="host" name="host" value="<%=host%>" onchange='checkinput("host","hostimage")'>
	  	</wea:required>
	  </wea:item>
	  <wea:item>LDAP Port</wea:item>
	  <wea:item>
	  	<wea:required id="portimage" required="true" value='<%=port+"" %>'>
	  	<input class="inputstyle" style='width:240px!important;' type=text size=50 maxLength="100" id="port" name="port" value="<%=port%>" onchange='checkinput("port","portimage")'>
	  	</wea:required>
	  </wea:item>
	 
	  <wea:item><%=SystemEnv.getHtmlLabelName(81795,user.getLanguage())%>
	  </wea:item><!-- 证书路径 -->
	  <wea:item>
	  	<input class="inputstyle" style='width:240px!important;' type=text size=50 maxLength="100" id="certpath" name="certpath" value="<%=certpath %>" onchange='checkinput("certpath","certpathimage")'>
	  	<span style="color:red">(<%=SystemEnv.getHtmlLabelName(21760,user.getLanguage())%>)</span>
	  </wea:item>
	  
	  <wea:item><%=SystemEnv.getHtmlLabelName(81796,user.getLanguage())%>
	  </wea:item><!-- 证书密码 -->
	  <wea:item>
	  	<input class="inputstyle" style='width:240px!important;' type=password size=50 maxLength="100" id="certpwd" name="certpwd" value="changeit" readOnly='readOnly' onchange='checkinput("certpwd","certpwdimage")'></input>
	  	<span style="color:red">(<%=SystemEnv.getHtmlLabelName(132183,user.getLanguage()) %>：changeit)</span>
	  </wea:item>
	  
	  
	  <wea:item><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%>
	  </wea:item>
	  <wea:item>
		&nbsp;&nbsp;<input  type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(131959,user.getLanguage()) %>" onclick="installcert()"></input>
	  </wea:item>
	  
	  
	</wea:group>
	<%if(!result.equals("")){%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(82341,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
	  <wea:item><%=SystemEnv.getHtmlLabelName(356,user.getLanguage())%></wea:item>
	  <wea:item>
		<%="<code><pre>"+result+"</pre></code>"%>
	  </wea:item>
	</wea:group>
	<%}%>
</wea:layout>
<br>

  </FORM>
</BODY>

<script language="javascript">
	if('ok' == '<%=importResult%>'){
		alert("<%=SystemEnv.getHtmlLabelName(132185,user.getLanguage())%>");
		
		//window.opener.location.href = window.opener.location.href;
  		//window.close();
  		//ldaps://192.168.0.44:636
  		window.opener.document.frmMain.ldapserverurl2.value = 'ldaps://'+document.frmMain.host.value+':636';
  		window.opener.document.frmMain.keystorepath.value = document.frmMain.certpath.value;
  		window.opener.document.frmMain.keystorepassword.value = document.frmMain.certpwd.value;
  		
  		window.opener.checkinput('ldapserverurl2','ldapserverurlimage2');
  		window.opener.checkinput('keystorepath','keystorepathimage');
  		window.opener.checkinput('keystorepassword','keystorepasswordimage');
	}
function installcert(){
	if(check_form(frmMain,"host,certpath,certpwd")){
		frmMain.operator.value = "installcert";
		frmMain.submit();
    } 
    
    
}
</script>

</HTML>
