<%@page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="EmailEncoder" class="weaver.email.EmailEncoder" scope="page" />

<%
    String showTop = Util.null2String(request.getParameter("showTop"));
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = "" + SystemEnv.getHtmlLabelName(571,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
    String sendneedSSL = "0";
    boolean isStartTls = false;
    String getneedSSL = "0";
    int mailAccountId = Util.getIntValue(request.getParameter("id"));
    String accountName="", accountMailAddress="", accountId="", accountPassword="", popServer="", smtpServer="", needCheck="", needSave="",autoreceive="";
    int serverType=1, popServerPort=25, smtpServerPort=110;
    String encryption="";
    String timingDateReceive = "";
    String receiveScope = "";
    rs.executeSql("SELECT * FROM MailAccount WHERE id="+mailAccountId+"");
    if(rs.next()){
    	accountName = rs.getString("accountName");
    	accountMailAddress = rs.getString("accountMailAddress");
    	accountId = rs.getString("accountId");
    	accountPassword = rs.getString("accountPassword");
    	serverType = rs.getInt("serverType");
    	popServer = rs.getString("popServer");
    	//解决第一次邮箱配置，显示-1的情况
    	popServerPort = Util.getIntValue(rs.getInt("popServerPort")+"", 25);
    	smtpServer = rs.getString("smtpServer");
    	//解决第一次邮箱配置，显示-1的情况
    	smtpServerPort = Util.getIntValue(rs.getInt("smtpServerPort")+"",110);
    	needCheck = rs.getString("needCheck");
    	needSave = rs.getString("needSave");
    	sendneedSSL =  rs.getString("sendneedSSL");
    	getneedSSL =  rs.getString("getneedSSL");
    	autoreceive = rs.getString("autoreceive");
    	encryption = Util.null2String(rs.getString("encryption"));
    	receiveScope = Util.null2String(rs.getString("receiveScope"));//1为最近一个月，2为最近三个月，3为最近半年，4为最近一年，5为全部
    	receiveScope = "".equals(receiveScope)?"5":receiveScope;
    	isStartTls = "1".equals(rs.getString("isStartTls"));
    }
    if(encryption.equals("1"))  {
        accountPassword = EmailEncoder.DecoderPassword(accountPassword);
    }
%>
<head>
<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
    <script type="text/javascript" src="/js/weaver_wev8.js"></script>
    <script type="text/javascript" src="/js/prototype_wev8.js"></script>
    <link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
    <script type="text/javascript" src="/js/dojo_wev8.js"></script>
    <script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>  
    <script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>
    
    <!-- 
    <link type="text/css" rel="stylesheet" href="/js/checkbox/jquery.tzCheckbox_wev8.css" />
	<script language="javascript" src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
     -->
    <link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
    <script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
</head>

<script language="javascript">
    function Mtrim(str){ //删除左右两端的空格
		return str.replace(/(^\s*)|(\s*$)/g, "");
	}
	
    var diag = null;
    function MailAccountSubmit(){
    	if(check_form(fMailAccount,'accountName,accountMailAddress,accountId,accountPassword,popServer,popServerPort,smtpServer,smtpServerPort')){
    		if(!checkEmail(Mtrim(dojo.byId("fMailAccount").accountMailAddress.value))){
    			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage())%>");//邮件地址格式错误
    			dojo.byId("fMailAccount").accountMailAddress.focus();
    			return false;
    		}
    		var serverType = jQuery("select[name='serverType']").val();
    	 	diag = new window.top.Dialog();
    	 	diag.currentWindow = window;
    	 	diag.Width = 450;
    		diag.Height = 320;
    		diag.Title = '<%=SystemEnv.getHtmlLabelNames("20869,22011",user.getLanguage())%>';
    		diag.ShowButtonRow=false;
    		diag.URL = "/email/MailAccountCheckInfo.jsp?"+jQuery("#fMailAccount").serialize()+"&"+new Date().getTime();
    		diag.show();
    		jQuery("body").trigger("click");
    	}
    }
 
    jQuery(function(){
        jQuery("input[name='accountPassword']").val("<%=accountPassword%>");
    
     	jQuery("input[type=checkbox]").each(function(){
    		  if(jQuery(this).attr("tzCheckbox")=="true"){
    		   	jQuery(this).tzCheckbox({labels:['','']});
    		  }
    	 });
    	
    	checkinput("accountName","accountNameSpan");
    	checkinput("accountMailAddress","accountMailAddressSpan");
    	checkinput("accountId","accountIdSpan");
    	checkinput("accountPassword","accountPasswordSpan"); 
    	checkinput("popServer","popServerSpan");
    	checkinput("popServerPort","popServerPortSpan");
    	checkinput("smtpServer","smtpServerSpan");
    	checkinput("smtpServerPort","smtpServerPortSpan");
    });

    function changesendSSL() {
    	var check = true;
    	if(jQuery("#sendneedSSL").is(":checked")) {
    		check = false;
        }
        disOrEnableSwitchPage("#isStartTls", check);
    	setsmtpServerPort(check);
    }
    
    function changereciveSSL() {
    	var check = true;
    	if(jQuery("#getneedSSL").is(":checked"))
    		check = false;
    	setpopServerPort(check);
    }
    
    function setsmtpServerPort(sendneedSSLcheck) {
    	if(sendneedSSLcheck) 
    	 	jQuery("#smtpServerPort").val("465");
    	else
    	 	jQuery("#smtpServerPort").val("25");
    }
    
    function setpopServerPort(getneedSSLcheck) {
    	var serverType = jQuery("select[name='serverType']").val();
    	if(getneedSSLcheck) {
    		if(serverType == "1") {
    			jQuery("#popServerPort").val("995");
            } else if(serverType == "2") {
                jQuery("#popServerPort").val("993");
            }
    	}else {
    		if(serverType == "1") {
                jQuery("#popServerPort").val("110");
            } else if(serverType == "2") {
                jQuery("#popServerPort").val("143");
            }
    	}
    }
    
    function onchangeserverType(){
    	setsmtpServerPort(jQuery("#sendneedSSL").is(":checked"));
    	setpopServerPort(jQuery("#getneedSSL").is(":checked"));
    }
    
    function closeDialog(){
    	if(diag){
    		diag.close();
    	}
    	parent.getParentWindow(window).closeDialog();
    }
    
    function changeIsStartTls(obj) {
        //disOrEnableSwitchPage("#sendneedSSL", !jQuery("#isStartTls").is(":checked"));
    }
    
    // jquery.jnice_wev8.js中的var disOrEnableSwitch = function(disabled){方法
    // 不知道为什么放里面不行，单独抽出来放在页面使用
    function disOrEnableSwitchPage(objId, disabled){
        if(disabled==true||disabled==false){
            jQuery(objId).attr("disabled",disabled);
        }
        if(disabled){
            //jQuery(objId).next("span.tzCheckBox").attr("title",'已禁用').attr('disabled',true);
            var checkbox = jQuery(objId).next("span.tzCheckBox");
            checkbox.removeClass("tzCheckBox ").addClass("tzCheckBox_disabled ");
            checkbox.children("span.tzCBPart").removeClass("tzCBPart").addClass("tzCBPart_disabled");
        }else{
            //jQuery(objId).next("span.tzCheckBox").removeAttr("title").removeAttr('disabled');
            var checkbox = jQuery(objId).next("span.tzCheckBox_disabled");
            checkbox.removeClass("tzCheckBox_disabled ").removeAttr('disabled').addClass("tzCheckBox");
            checkbox.children("span.tzCBPart_disabled").removeClass("tzCBPart_disabled").addClass("tzCBPart");
        }
    }
</script>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
    RCFromPage="mailOption";//屏蔽右键菜单时使用
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:MailAccountSubmit(),_self} " ;    
    RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="mail"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("23845,87",user.getLanguage())%>'/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="MailAccountSubmit()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form method="post" action="MailAccountOperation.jsp" id="fMailAccount">
    <input type="hidden" name="operation" value="update" />
    <input type="hidden" name="id" value="<%=mailAccountId%>" />
    <wea:layout attributes="{'expandAllGroup':'true','cw1':'30%','cw2':'70%'}">
    	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
    		<wea:item><%=SystemEnv.getHtmlLabelName(19804,user.getLanguage())%></wea:item>
    		<wea:item>
    			<wea:required id="accountNameSpan" required="true">
    				<input type="text" name="accountName" class="inputstyle" maxlength="50" 
    					value="<%=accountName%>" onchange="checkinput('accountName','accountNameSpan')" style="width:40%"/>
    			</wea:required>
    		</wea:item>
    		
    		<wea:item><%=SystemEnv.getHtmlLabelName(19805,user.getLanguage())%></wea:item>
    		<wea:item>
    			<wea:required id="accountMailAddressSpan" required="true">
                    <% if(mailAccountId > 0) { %>
                    <input type="hidden" name="accountMailAddress" class="inputstyle" maxlength="50" value="<%=accountMailAddress%>" style="width:40%"/>
                    <span style="line-height: 22px; height: 22px; width: 40%; font-size: 10pt;" ><%=accountMailAddress %></span>
                    <% } else { %>
    				<input type="text" name="accountMailAddress" class="inputstyle" maxlength="50" 
    					value="<%=accountMailAddress%>" onchange="checkinput('accountMailAddress','accountMailAddressSpan')" style="width:40%"/>
                    <% } %>
    			</wea:required>
    		</wea:item>
    		
    		<wea:item><%=SystemEnv.getHtmlLabelNames("20869,412",user.getLanguage())%></wea:item>
    		<wea:item>
    			<wea:required id="accountIdSpan" required="true">
    				<input type="text" name="accountId" class="inputstyle" maxlength="50" 
    					value="<%=accountId%>" onchange="checkinput('accountId','accountIdSpan')" style="width:40%"/>
    			</wea:required>
    		</wea:item>
    		
    		<wea:item><%=SystemEnv.getHtmlLabelNames("20869,409",user.getLanguage())%></wea:item>
    		<wea:item>
    			<wea:required id="accountPasswordSpan" required="true">
    				<input type="password" name="accountPassword" class="inputstyle" maxlength="50" 
    					onchange="checkinput('accountPassword','accountPasswordSpan')" style="width:40%"/>
    			</wea:required>
    		</wea:item>
    	</wea:group>
    	
    	<wea:group context='<%=SystemEnv.getHtmlLabelName(19806,user.getLanguage())%>'>
    		<wea:item><%=SystemEnv.getHtmlLabelName(2058,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
    		<wea:item>
    			<select name="serverType" style="width: 100px;" onchange="onchangeserverType(this)">
    			<option value="1" <%if(serverType==1)out.println("selected=selected");%>>POP3</option>
    			<option value="2" <%if(serverType==2)out.println("selected=selected");%>>IMAP</option></select>
    		</wea:item>
    		
    		<wea:item><%=SystemEnv.getHtmlLabelName(18526,user.getLanguage())+SystemEnv.getHtmlLabelName(2058,user.getLanguage())%></wea:item>
    		<wea:item>
    			<wea:required id="popServerSpan" required="true">
    				<input type="text" name="popServer" class="inputstyle"  maxlength="100" 
    					value="<%=popServer%>" onchange="checkinput('popServer','popServerSpan')" style="width:30%"/>
    			</wea:required>
    			
    			    &nbsp;&nbsp;SSL:	
    			<input type="checkbox" tzCheckbox="true" id="getneedSSL" name="getneedSSL" value="1" class="inputstyle" onchange="changereciveSSL(this)"
    				<%if(getneedSSL.equals("1"))out.println("checked=checked");%> />
    			
    			&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(24723,user.getLanguage())%>:
    			<wea:required id="popServerPortSpan" required="true">
    				<input type="text" name="popServerPort" id="popServerPort" class="inputstyle" value="<%=popServerPort%>" 
    					onchange="checkinput('popServerPort','popServerPortSpan')" style="width:10%"/>
    			</wea:required>
    		</wea:item>
    		
    		
    		<wea:item><%=SystemEnv.getHtmlLabelName(2083,user.getLanguage())+SystemEnv.getHtmlLabelName(2058,user.getLanguage())%></wea:item>
    		<wea:item>
    			<wea:required id="smtpServerSpan" required="true">
    				<input type="text" name="smtpServer" class="inputstyle"  maxlength="100" 
    					value="<%=smtpServer%>" onchange="checkinput('smtpServer','smtpServerSpan')" style="width:30%"/>
    			</wea:required>
    			
    				&nbsp;&nbsp;SSL:	
    			<input type="checkbox" tzCheckbox="true" id="sendneedSSL" name="sendneedSSL" value="1" class="inputstyle" onchange="changesendSSL(this)"
    				<% if("1".equals(sendneedSSL)) { %>checked="checked"<% } %> />
    			
    			&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(24724,user.getLanguage())%>:
    			<wea:required id="smtpServerPortSpan"  required="true">
    				<input type="text" name="smtpServerPort" id="smtpServerPort" class="inputstyle" 
    					value="<%=smtpServerPort%>" onchange="checkinput('smtpServerPort','smtpServerPortSpan')" style="width:10%"/>
    			</wea:required>
    		</wea:item>
            
            <wea:item></wea:item>
            <wea:item>
                <input type="checkbox" tzCheckbox="true" class="InputStyle" id="isStartTls" name="isStartTls" value="1" onchange="changeIsStartTls(this)"
                    <% if("1".equals(sendneedSSL)) { %>disabled="disabled"<% } %> <% if(isStartTls) { %>checked="checked"<% } %> />
                <%=SystemEnv.getHtmlLabelName(129992,user.getLanguage())%><!-- 如果服务器支持，就使用STARTTLS加密传输 -->
            </wea:item>
    		
    		<wea:item><%=SystemEnv.getHtmlLabelName(15039,user.getLanguage())%></wea:item>
    		<wea:item>
    			<input type="checkbox" tzCheckbox="true" name="needCheck" value="1" class="inputstyle" <% if("1".equals(needCheck)) { %>checked="checked"<% } %> />
    		</wea:item>
    		
    		<wea:item><%=SystemEnv.getHtmlLabelName(19807,user.getLanguage())%></wea:item>
    		<wea:item>
    			<input type="checkbox" tzCheckbox="true" name="needSave" value="1" class="inputstyle" <% if("1".equals(needSave)) { %>checked="checked"<% } %> />
    		</wea:item>
    		
    		<wea:item><%=SystemEnv.getHtmlLabelName(24310 ,user.getLanguage())%></wea:item>
    		<wea:item>
    			<input type="checkbox" tzCheckbox="true" name="autoreceive" value="1" class="inputstyle" <% if("1".equals(autoreceive)) { %>checked="checked"<% } %> />
    		</wea:item>
    
    		<wea:item><%=SystemEnv.getHtmlLabelName(32168 ,user.getLanguage())%></wea:item>
    		<wea:item>
    			<select name="receiveScope" id="receiveScope" style="width:100px;">
    				<option value="1" <%if(receiveScope.equals("1")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(24515 ,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(24490 ,user.getLanguage())%></option>
    				<option value="2" <%if(receiveScope.equals("2")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(24515 ,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(24491 ,user.getLanguage())%></option>
    				<option value="3" <%if(receiveScope.equals("3")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(24515 ,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(20729 ,user.getLanguage())%></option>
    				<option value="4" <%if(receiveScope.equals("4")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(24515 ,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(25201 ,user.getLanguage())%></option>
    				<option value="5" <%if(receiveScope.equals("5")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(332 ,user.getLanguage())%></option>
    			</select>
    		</wea:item>
    	
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
