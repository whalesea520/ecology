
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.email.EmailEncoder"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
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
    var diag = null;
    function clearMailAccount(){
        window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23820,user.getLanguage())%>",function(){ 
            jQuery("#accountPassword").val('');
            jQuery("#accountId").val('');
            jQuery("#accountMailAddress").val('');
            jQuery("#accountPassword").val('');
            jQuery("#smtpServer").val('');
            jQuery("#sendneedSSL").val('0');
            jQuery("#needCheck").val('1');
            jQuery("#smtpServerPort").val('25');
            jQuery("#mailAccountName").val('');
            
            jQuery("#sendneedSSL").parent().find('.tzCheckBox').removeClass('checked');
            jQuery("#needCheck").parent().find('.tzCheckBox').addClass('checked');
            
            jQuery("#isStartTls").trigger("checkbox", false);
            jQuery("#isStartTls").parent().find('.tzCheckBox').removeClass('checked');
            disOrEnableSwitchPage("#isStartTls", false);
            saveInfo();
        });
    }
    
    function checkMailAccount(){
        if(check_form(weaver,'smtpServer,smtpServerPort,accountMailAddress,accountId,accountPassword')){
            var emailStr = jQuery("input[name='accountMailAddress']").val();
            if (!checkEmail(emailStr)) {
                window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage())%>",function(){
                    jQuery("input[name='accountMailAddress']").focus();
                });
                return;
            }
            
            var info = jQuery("form").serialize();
            diag = new window.top.Dialog();
            diag.currentWindow = window;
            diag.Width = 450;
            diag.Height = 200;
            diag.Title = "<%=SystemEnv.getHtmlLabelName(125375,user.getLanguage())%>"; //邮箱检测
            diag.ShowButtonRow=false;   
            diag.URL = "/email/MailAccountCheckInfo.jsp?"+info+"&"+new Date().getTime();
            diag.show();
            jQuery("body").trigger("click");
        }
    }
    
    function saveInfo(){
        jQuery.post("MailMaintOperation.jsp",jQuery("form").serialize(),function(){
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22619,user.getLanguage())%>",function(){
                if(diag){
                    diag.close();
                }
            });
        }); 
    }
    
    function mailValid() {
        var emailStr = jQuery("input[name='accountMailAddress']").val();
        if (!checkEmail(emailStr)) {
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage())%>");
            jQuery("input[name='accountMailAddress']").focus();
            return;
        }
    }
    
    jQuery(function(){
        checkinput('smtpServer','smtpServerSpan');
        checkinput('smtpServerPort','smtpServerPortSpan');
        checkinput('accountMailAddress','accountMailAddressSpan');
        checkinput('accountId','accountIdSpan');
        checkinput('accountPassword','accountPasswordSpan');
    });
    
    function changesendSSL() {
        var check = true;
        if(jQuery("#sendneedSSL").is(":checked")) {
            check = false;
        }
        disOrEnableSwitchPage("#isStartTls", check);
    }
    
    function changeisStartTls() {
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
</head>

<%
    
    String method = Util.null2String(request.getParameter("method"));
    String defmailserver = null;
    String needSSL = null;
    String defneedauth = "1";
    String defmailfrom = null;
    String defmailuser = null;
    String defmailpassword = null;
    String smtpServerPort = "25";
    String mailAccountName = "";
    String isStartTls = "0";
    rs.execute("select * from SystemSet");
    while(rs.next()){
        defmailserver = Util.null2String(rs.getString("defmailserver"));
        needSSL = Util.null2String(rs.getString("needSSL"));
        defneedauth = Util.null2String(rs.getString("defneedauth"),"1");
        defmailfrom = Util.null2String(rs.getString("defmailfrom"));
        defmailuser = Util.null2String(rs.getString("defmailuser"));
        defmailpassword = Util.null2String(rs.getString("defmailpassword"));
        smtpServerPort = Util.null2String(rs.getString("smtpServerPort"),"25");
        mailAccountName = Util.null2String(rs.getString("mailAccountName"));
        isStartTls = Util.null2o(rs.getString("mailIsStartTls"));
        
        String encryption = Util.null2String(rs.getString("encryption"));
        if(encryption.equals("1")) {
            defmailpassword = EmailEncoder.DecoderPassword(defmailpassword);
        }
    }
    smtpServerPort = (smtpServerPort == null || "".equals(smtpServerPort)) ? "25" : smtpServerPort;
    defneedauth = (defneedauth == null || "".equals(defneedauth)) ? "1" : defneedauth;
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCFromPage="mailOption";//屏蔽右键菜单时使用
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkMailAccount(),_self} " ; 
RCMenuHeight += RCMenuHeightStep; 
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<wea:layout attributes="{layoutTableId:topTitle}">
    <wea:group context="" attributes="{groupDisplay:none}">
        <wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
            <input class="e8_btn_top middle" onclick="clearMailAccount()" type="button" value="<%=SystemEnv.getHtmlLabelName(15504,user.getLanguage()) %>"/>
            <input class="e8_btn_top middle" onclick="checkMailAccount()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
            <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
        </wea:item>
    </wea:group>
</wea:layout>

<form method="post" action="MailMaintOperation.jsp" name="weaver">
<input type="hidden" name="operation" value="systemset">
<input type="hidden" name="method" value="systemset">
<wea:layout attributes="{'expandAllGroup':'true'}">
    <wea:group context="<%=SystemEnv.getHtmlLabelName(17632,user.getLanguage())%>"><!-- 参数设置 -->
        <wea:item><%=SystemEnv.getHtmlLabelNames("2083,2058",user.getLanguage())%></wea:item>
        <wea:item>
            <wea:required id="smtpServerSpan" required="true">
                <input  name=smtpServer  id="smtpServer" value="<%=defmailserver %>" maxlength="50" style="width :30%" 
                    onchange="checkinput('smtpServer','smtpServerSpan')" class="InputStyle">
            </wea:required>
            
            &nbsp;&nbsp;
            SSL:
            <input type="checkbox" tzCheckbox="true" name="sendneedSSL" id="sendneedSSL" value="1" class="inputstyle" onchange="changesendSSL(this)"
                <%if(needSSL.equals("1"))out.println("checked=checked");%>/>
                
            &nbsp;&nbsp;
            <%=SystemEnv.getHtmlLabelName(24724,user.getLanguage())%>:
            <wea:required id="smtpServerPortSpan" required="true">
                <input type="text" style="width:10%" name="smtpServerPort" id="smtpServerPort"
                     onchange="checkinput('smtpServerPort','smtpServerPortSpan')" class="inputstyle" value="<%=smtpServerPort %>" onBlur='checknumber("smtpServerPort")' />
            </wea:required>
        </wea:item>
        
        <wea:item></wea:item>
        <wea:item>
            <input type="checkbox" tzCheckbox="true" class="InputStyle" id="isStartTls" name="isStartTls" value="1" onchange="changeisStartTls(this)"
                <% if("1".equals(needSSL)) { %>disabled="disabled"<% } %> <% if("1".equals(isStartTls)) { %>checked="checked"<% } %> />
            <%=SystemEnv.getHtmlLabelName(129992,user.getLanguage())%><!-- 如果服务器支持，就使用STARTTLS加密传输 -->
        </wea:item>
        
        <wea:item><%=SystemEnv.getHtmlLabelName(15039,user.getLanguage())%></wea:item>
        <wea:item>
            <input type="checkbox" tzCheckbox="true" name=needCheck id="needCheck" value="1" 
                <% if(defneedauth.equals("1")) {%>checked<%}%>>
        </wea:item>
        
        <wea:item><%=SystemEnv.getHtmlLabelName(129891,user.getLanguage())%></wea:item>
        <wea:item>
            <wea:required id="mailAccountNameSpan">
                <input  name="mailAccountName" id="mailAccountName"  value="<%=Util.toScreenToEdit(mailAccountName, user.getLanguage())%>" 
                    maxlength="50" style="width :30%" class="InputStyle" >
            </wea:required>
        </wea:item>
        
        <wea:item><%=SystemEnv.getHtmlLabelName(19805,user.getLanguage())%></wea:item>
        <wea:item>
            <wea:required id="accountMailAddressSpan" required="true">
                <input  name="accountMailAddress" id="accountMailAddress"  value="<%=Util.toScreenToEdit(defmailfrom,user.getLanguage())%>" 
                    onchange="checkinput('accountMailAddress','accountMailAddressSpan')" maxlength="50" style="width :30%" class="InputStyle" >
            </wea:required>
        </wea:item>
        
        <wea:item><%=SystemEnv.getHtmlLabelNames("20869,412",user.getLanguage())%></wea:item>
        <wea:item>
            <wea:required id="accountIdSpan" required="true">
                <input type="text" name="accountId" id="accountId" value="<%=Util.toScreenToEdit(defmailuser,user.getLanguage())%>" 
                    onchange="checkinput('accountId','accountIdSpan')" maxlength="50" style="width :30%" class="InputStyle">
            </wea:required>
        </wea:item>
        
        <wea:item><%=SystemEnv.getHtmlLabelNames("20869,409",user.getLanguage())%></wea:item>
        <wea:item>
            <wea:required id="accountPasswordSpan" required="true">
                <input type="password" name="accountPassword" id="accountPassword"  value="<%=Util.toScreenToEdit(defmailpassword,user.getLanguage())%>" 
                    onchange="checkinput('accountPassword','accountPasswordSpan')" maxlength="50" style="width :30%" class="InputStyle">
            </wea:required>
        </wea:item>
    </wea:group>
</wea:layout>
</form>
<div style="margin-top: 20px">
<span style="color: red;font-size: 14px;font-weight:bold;margin-left: 20px;"><%=SystemEnv.getHtmlLabelName(558,user.getLanguage()) %>：</span>
<ul>
    <li class="mail_hint_li" >* <%=SystemEnv.getHtmlLabelName(125584,user.getLanguage()) %></li>
    <li class="mail_hint_li" >* <%=SystemEnv.getHtmlLabelName(125586,user.getLanguage()) %></li>
</ul>
</div>
</body>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>  
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>
 <style>
.mail_hint_li{margin: 5px 2px 5px 10px;color:red}
</style>
