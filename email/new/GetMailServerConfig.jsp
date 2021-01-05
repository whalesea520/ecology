<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@include file="/page/maint/common/initNoCache.jsp"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String email = Util.null2String(request.getParameter("accountMailAddress")).trim();
String domain ="";
int index = email.indexOf("@");
if(index!=-1){
	domain =email.substring(index+1); 
}
rs.execute("select * from webmail_domain where domain='"+domain.toLowerCase()+"'");
String IS_POP = "1";
String POP_SERVER = "";
String POP_PORT = "110";
String SMTP_SERVER = "";
String SMTP_PORT = "25";
String IS_SMTP_AUTH = "1";
String IS_SSL_POP = "0";
String IS_SSL_SMTP = "0";
String NEED_SAVE = "1";
String AUTO_RECEIVE = "1";
String RECEIVE_SCOPT = "1";
String IS_START_TLS = "0";
out.clear();
if(rs.next()){
	IS_POP = rs.getString("IS_POP");
	POP_SERVER = rs.getString("POP_SERVER");
	POP_PORT = rs.getString("POP_PORT");
	SMTP_SERVER = rs.getString("SMTP_SERVER");
	SMTP_PORT = rs.getString("SMTP_PORT");
	IS_SMTP_AUTH = rs.getString("IS_SMTP_AUTH");
	IS_SSL_POP = rs.getString("IS_SSL_POP");
	IS_SSL_SMTP = rs.getString("IS_SSL_SMTP");
	NEED_SAVE = rs.getString("NEED_SAVE");
	if("".equals(NEED_SAVE)){
        NEED_SAVE = "1";
    }
	AUTO_RECEIVE = rs.getString("AUTO_RECEIVE");
	RECEIVE_SCOPT = rs.getString("RECEIVE_SCOPT");
	IS_START_TLS = Util.null2o(rs.getString("IS_START_TLS"));
}
%>
<wea:layout attributes="{'expandAllGroup':'true','cw1':'30%','cw2':'70%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(19806,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(2058,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="serverType" onchange="setPortMsg()" style="width:100px;">
				<option value="1" <% if(IS_POP.equals("1")){out.print("selected");} %>>POP3</option>
				<option value="2"  <% if(!IS_POP.equals("1")){out.print("selected");} %>>IMAP</option>
			</select>
		</wea:item>
		
		
		<wea:item><%=SystemEnv.getHtmlLabelName(18526,user.getLanguage())+SystemEnv.getHtmlLabelName(2058,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="popServerSpan" required="true">
				<input type="text" name="popServer" value="<%=POP_SERVER %>" class="inputstyle" 
					 maxlength="100" onchange="checkinput('popServer','popServerSpan')" style="width:30%"/>
			</wea:required>
			
			&nbsp;&nbsp;SSL:	
			<input type="checkbox" tzCheckbox="true"  id="getneedSSL" name="getneedSSL" value="1"  onchange="changereciveSSL(this)"
				<%if(IS_SSL_POP.equals("1")){out.print("checked");} %> class="inputstyle" />
			
			&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(24723,user.getLanguage())%>:
			<wea:required id="popServerPortSpan" required="true">
				<input type="text" size="4"  id="popServerPort" name="popServerPort" class="inputstyle" value="<%=POP_PORT %>"  
					onchange="checkinput('popServerPort','popServerPortSpan')" style="width:10%"/>
			</wea:required>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(2083,user.getLanguage())+SystemEnv.getHtmlLabelName(2058,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="smtpServerSpan" required="true">
				<input type="text" name="smtpServer" class="inputstyle" value="<%=SMTP_SERVER%>" 
					 maxlength="100" onchange="checkinput('smtpServer','smtpServerSpan')" style="width:30%"/>
			</wea:required>
			
		    &nbsp;&nbsp;SSL:	
			<input type="checkbox" tzCheckbox="true" id="sendneedSSL" name="sendneedSSL" value="1" onchange="changesendSSL(this)"
				<%if(IS_SSL_SMTP.equals("1")){out.print("checked");} %> class="inputstyle" />
			
			&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(24724,user.getLanguage())%>:
			<wea:required id="smtpServerPortSpan" required="true">
				<input type="text" size="4" name="smtpServerPort" id="smtpServerPort" class="inputstyle" value="<%=SMTP_PORT%>"  
					onchange="checkinput('smtpServerPort','smtpServerPortSpan')" style="width:10%"/>
			</wea:required>
		</wea:item>
        
        <wea:item></wea:item>
        <wea:item>
            <input type="checkbox" tzCheckbox="true" class="InputStyle" id="isStartTls" name="isStartTls" value="1" onchange="changeIsStartTls(this)"
                <% if("1".equals(IS_SSL_SMTP)) { %>disabled="disabled"<% } %> <% if("1".equals(IS_START_TLS)) { %>checked="checked"<% } %> />
            <%=SystemEnv.getHtmlLabelName(129992,user.getLanguage())%><!-- 如果服务器支持，就使用STARTTLS加密传输 -->
        </wea:item>
			
		<wea:item><%=SystemEnv.getHtmlLabelName(15039,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="needCheck" value="1" 
				<%if(IS_SMTP_AUTH.equals("1")){out.print("checked");} %> class="inputstyle" />
		</wea:item>
	
		<wea:item><%=SystemEnv.getHtmlLabelName(19807,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="needSave" value="1" 
				<%if(NEED_SAVE.equals("1")){out.print("checked");} %> class="inputstyle" />
		</wea:item>
	
		<wea:item><%=SystemEnv.getHtmlLabelName(24310 ,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" tzCheckbox="true" name="autoreceive" value="1" 
				<%if(AUTO_RECEIVE.equals("1")){out.print("checked");} %> class="inputstyle" />
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(32168 ,user.getLanguage())%></wea:item>
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


	

