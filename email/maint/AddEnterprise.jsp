
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
String showTop = Util.null2String(request.getParameter("showTop"));
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(571,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());
%>
<head>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
</head>
<%
String DOMAIN = "";
String POP_SERVER = "";
String SMTP_SERVER = "";
String IS_SMTP_AUTH = "1";
String POP_PORT = "";
String SMTP_PORT = "";
String IS_SSL_POP = "";
String IS_SSL_SMTP = "";
String IS_POP = "1";
String NEED_SAVE = "0";
String AUTO_RECEIVE = "0";
String RECEIVE_SCOPT = "1";
String IS_START_TLS = "0";
String DOMAIN_ID = Util.null2String(request.getParameter("DOMAIN_ID"));
if(!"".equals(DOMAIN_ID)) {
	rs.execute("SELECT * FROM webmail_domain WHERE DOMAIN_ID="+DOMAIN_ID);
	while(rs.next()){
		DOMAIN = rs.getString("DOMAIN");
		POP_SERVER = rs.getString("POP_SERVER");
		SMTP_SERVER = rs.getString("SMTP_SERVER");
		IS_SMTP_AUTH = rs.getString("IS_SMTP_AUTH");
		POP_PORT = rs.getString("POP_PORT");
		SMTP_PORT = rs.getString("SMTP_PORT");
		IS_SSL_POP =  rs.getString("IS_SSL_POP");
		IS_SSL_SMTP =  rs.getString("IS_SSL_SMTP");
		IS_POP =  rs.getString("IS_POP");
		NEED_SAVE = rs.getString("NEED_SAVE");
		AUTO_RECEIVE = rs.getString("AUTO_RECEIVE");
		RECEIVE_SCOPT = rs.getString("RECEIVE_SCOPT");
		IS_START_TLS = Util.null2o(rs.getString("IS_START_TLS"));
	}
}
%>
<script language="javascript">
var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);

function saveInfo(){
	if(check_form(weaver,'DOMAIN')){
		 jQuery.post("MailMaintOperation.jsp",jQuery("form").serialize(),function(){
		 	parentWin.closeDialog();
		 });
	}
}

 
 jQuery(function(){
 	jQuery("input[type=checkbox]").each(function(){
		  if(jQuery(this).attr("tzCheckbox")=="true"){
		   	jQuery(this).tzCheckbox({labels:['','']});
		  }
	 });
	
	checkinput('DOMAIN','DOMAINSPAN');
	checkinput('POP_SERVER','POP_SERVERSPAN');
	checkinput('POP_PORT','POP_PORTSPAN');
	checkinput('SMTP_SERVER','SMTP_SERVERSPAN');
	checkinput('SMTP_PORT','SMTP_PORTSPAN');
 });
 
    function changesendSSL() {
        disOrEnableSwitchPage("#IS_START_TLS", !jQuery("#IS_SSL_SMTP").is(":checked"));
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveInfo(),_self} " ;    
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="mail"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(34164,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="saveInfo()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form method="post" action="MailMaintOperation.jsp" name="weaver">
<input type="hidden" name="method" value = "addEnterprise"/>
<input type="hidden" name="DOMAIN_ID" value="<%=DOMAIN_ID%>" />
<wea:layout attributes="{'expandAllGroup':'true','cw1':'30%','cw2':'70%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelNames("34164,82755",user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="DOMAINSPAN" required="true">
				<input type="text" name="DOMAIN" class="inputstyle" maxlength="50" 
					value="<%=DOMAIN%>" onchange="checkinput('DOMAIN','DOMAINSPAN')" style="width:40%"/>
			</wea:required>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="IS_POP">
				<option value="1" <%if(IS_POP.equals("1"))out.println("selected=selected");%>>POP3</option>
				<option value="2" <%if(!IS_POP.equals("1"))out.println("selected=selected");%>>IMAP</option>
			</select>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(18526,user.getLanguage())+SystemEnv.getHtmlLabelName(2058,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="POP_SERVERSPAN" required="true">
				<input type="text" name="POP_SERVER" class="inputstyle" maxlength="50" 
					value="<%=POP_SERVER%>"  onchange="checkinput('POP_SERVER','POP_SERVERSPAN')" style="width:30%"/>
			</wea:required>
			&nbsp;&nbsp;SSL:	
			<input type="checkbox" tzCheckbox="true" name="IS_SSL_POP" value="1" class="inputstyle" 
				<%if(IS_SSL_POP.equals("1"))out.println("checked=checked");%>/>
			
			&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(24723,user.getLanguage())%>:
			<wea:required id="POP_PORTSPAN" required="true">	
				<input type="text" name="POP_PORT" class="inputstyle" maxlength="50" 
					value="<%=POP_PORT%>"  onKeyPress="ItemPlusCount_KeyPress()" onBlur="checknumber('POP_PORT')" 
					onchange="checkinput('POP_PORT','POP_PORTSPAN')" style="width:10%"/>
			</wea:required>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(2083,user.getLanguage())+SystemEnv.getHtmlLabelName(2058,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="SMTP_SERVERSPAN" required="true">
				<input type="text" name="SMTP_SERVER" class="inputstyle" maxlength="50" 
					value="<%=SMTP_SERVER%>"  onchange="checkinput('SMTP_SERVER','SMTP_SERVERSPAN')"  style="width:30%"/>
			</wea:required>
			&nbsp;&nbsp;SSL:	
			<input type="checkbox" tzCheckbox="true" id="IS_SSL_SMTP" name="IS_SSL_SMTP" value="1" class="inputstyle" onchange="changesendSSL(this)" 
				<%if(IS_SSL_SMTP.equals("1"))out.println("checked=checked");%>/>
				
			&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(24724,user.getLanguage())%>:
			<wea:required id="SMTP_PORTSPAN" required="true">
				<input type="text" name="SMTP_PORT" class="inputstyle" maxlength="50" 
					value="<%=SMTP_PORT%>"  onKeyPress="ItemPlusCount_KeyPress()" onBlur="checknumber('SMTP_PORT')" 
					onchange="checkinput('SMTP_PORT','SMTP_PORTSPAN')" style="width:10%"/>
			</wea:required>
		</wea:item>
        
        <wea:item></wea:item>
        <wea:item>
            <input type="checkbox" tzCheckbox="true" class="InputStyle" id="IS_START_TLS" name="IS_START_TLS" value="1" onchange="changeIsStartTls(this)"
                <% if("1".equals(IS_SSL_SMTP)) { %>disabled="disabled"<% } %> <% if("1".equals(IS_START_TLS)) { %>checked="checked"<% } %> />
            <%=SystemEnv.getHtmlLabelName(129992,user.getLanguage())%><!-- 如果服务器支持，就使用STARTTLS加密传输 -->
        </wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(15039,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="IS_SMTP_AUTH" value="1" class="inputstyle" 
				<%if(IS_SMTP_AUTH.equals("1"))out.println("checked=checked");%> />
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(19807,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="NEED_SAVE" value="1" class="inputstyle" 
				<%if(NEED_SAVE.equals("1"))out.println("checked=checked");%> />
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(24310,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="AUTO_RECEIVE" value="1" class="inputstyle" 
				<%if(AUTO_RECEIVE.equals("1"))out.println("checked=checked");%>/>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(32168,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="receiveScope" id="receiveScope" style="width:100px;">
				<option value="1" <%if(RECEIVE_SCOPT.equals("1")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(24515 ,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(24490 ,user.getLanguage())%></option>
				<option value="2" <%if(RECEIVE_SCOPT.equals("2")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(24515 ,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(24491 ,user.getLanguage())%></option>
				<option value="3" <%if(RECEIVE_SCOPT.equals("3")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(24515 ,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(20729 ,user.getLanguage())%></option>
				<option value="4" <%if(RECEIVE_SCOPT.equals("4")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(24515 ,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(25201 ,user.getLanguage())%></option>
				<option value="5" <%if(RECEIVE_SCOPT.equals("5")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(332 ,user.getLanguage())%></option>
			</select>
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
