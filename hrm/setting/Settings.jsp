
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
								 weaver.general.GCONST,
                 weaver.hrm.settings.ChgPasswdReminder,
                 weaver.hrm.settings.RemindSettings,java.io.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
ChgPasswdReminder reminder=new ChgPasswdReminder();
RemindSettings settings=reminder.getRemindSettings();
String valid=settings.getValid();
String remindperiod=settings.getRemindperiod();
String birthremindperiod=settings.getBirthremindperiod();
String birthvalid=settings.getBirthvalid();
String congratulation=settings.getCongratulation();
String remindmode=settings.getBirthremindmode();

String needusb=settings.getNeedusb();
String usbType = settings.getUsbType();
String firmcode=settings.getFirmcode();
String usercode=settings.getUsercode();
String relogin=settings.getRelogin();
//System.out.println("s usbType = " + usbType);
//add by sean.yang 2006-02-09 for TD3609
int needvalidate=settings.getNeedvalidate();
int validatetype=settings.getValidatetype();
int validatenum=settings.getValidatenum();

int minpasslen=settings.getMinPasslen();
//dynapass
int needdynapass=settings.getNeeddynapass();
int dynapasslen=settings.getDynapasslen(); 
String dypadcon=settings.getDypadcon(); 

String needdactylogram = settings.getNeedDactylogram(); 
String canmodifydactylogram = settings.getCanModifyDactylogram();

String needusbnetwork = settings.getNeedusbnetwork();//是否启用usb网段策略

boolean canedit = HrmUserVarify.checkUserRight("OtherSettings:Edit", user) ;

String imagefilename = "/images/hdSystem_wev8.gif";

String titlename = SystemEnv.getHtmlLabelName(17563,user.getLanguage()) ;
String needhelp="";

String PasswordChangeReminder = Util.null2String(settings.getPasswordChangeReminder());
if("".equals(PasswordChangeReminder)){
	PasswordChangeReminder = "0";
}
String ChangePasswordDays = settings.getChangePasswordDays();
String DaysToRemind = settings.getDaysToRemind();

//密码锁定
String openPasswordLock = Util.null2String(settings.getOpenPasswordLock());
//锁定密码错误次数
String sumPasswordLock = Util.null2String(settings.getSumPasswordLock());
//密码复杂度
String passwordComplexity = Util.null2String(settings.getPasswordComplexity());


%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="HrmSettingOperation.jsp">
 <table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="0" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

			  <TABLE class=ViewForm>
				<COLGROUP> <COL width="20%"> <COL width="80%"><TBODY>
				<TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(18710,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing style="height:2px">
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				<tr>
				  <td width="21%"><%=SystemEnv.getHtmlLabelName(18711,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>)</td>
				  <td width="79%" class=Field>
					<% if(canedit) { %>
					<input accesskey=Z name=remindperiod  value="<%=remindperiod%>" maxlength="50" style="width :50%" onKeyPress="ItemPlusCount_KeyPress()" onBlur='checkcount1(this)' class="InputStyle">
					<% } else {%>
					<%=Util.toScreen(remindperiod,user.getLanguage())%>
					<%}%>
				  </td>
				</tr>
				
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(6078,user.getLanguage())%></td>
				  <td class=Field>
					<input type="checkbox" name=valid  value="1" <% if(valid.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
                                </TBODY>
		          </TABLE>
        <br>
			   <TABLE class=ViewForm>
				<COLGROUP> <COL width="20%"> <COL width="80%"><TBODY>
				<TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(20170,user.getLanguage())%></TH>
				</TR> 
				<TR class=Spacing style="height:2px">
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				<tr>
				  <td width="21%"><%=SystemEnv.getHtmlLabelName(20171,user.getLanguage())%></td>
				  <td width="79%" class=Field>
				  <%if(canedit){ %>
					<input  name=minpasslen value="<%=minpasslen%>"  maxlength="50" style="width :50%" onKeyPress="ItemPlusCount_KeyPress()" onBlur='checkcount1(this)' class="InputStyle">
					<%}else{ %>
						<%=Util.toScreen(minpasslen+"",user.getLanguage())%>
					<%} %>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				<tr id="passwordComplexityTr"> 
                  <td width="21%"><%=SystemEnv.getHtmlLabelName(24078,user.getLanguage())%></td>
                  <td width="79%" class=Field>
                  	<input type="radio" name="passwordComplexity" value=0 <%="0".equals(passwordComplexity)?"checked":""%> <% if(!canedit) { %>disabled<%}%>><%=SystemEnv.getHtmlLabelName(24079,user.getLanguage())%>
                    <br>
                    <input type="radio" name="passwordComplexity" value=1 <%="1".equals(passwordComplexity)?"checked":""%> <% if(!canedit) { %>disabled<%}%>><%=SystemEnv.getHtmlLabelName(24080,user.getLanguage())%>
                    <br>
                    <input type="radio" name="passwordComplexity" value=2 <%="2".equals(passwordComplexity)?"checked":""%> <% if(!canedit) { %>disabled<%}%>><%=SystemEnv.getHtmlLabelName(24081,user.getLanguage())%>
                  </td>
                </tr>
                <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				</tbody>
                           </table>      
        <br>
        		<TABLE class=ViewForm>
				<COLGROUP> <COL width="20%"> <COL width="80%"><TBODY>
				<TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(23985,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing style="height:2px">
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				<tr>
				  <td width="21%"><%=SystemEnv.getHtmlLabelName(23852,user.getLanguage())+SystemEnv.getHtmlLabelName(23986,user.getLanguage())%></td>
				  <td width="79%" class=Field>
				  	<%if(canedit){ %>
					<input  name=ChangePasswordDays value="<%=ChangePasswordDays%>"  maxlength="50" style="width :50%" onKeyPress="ItemPlusCount_KeyPress()" onBlur='checkcount1(this)' class="InputStyle">
					<%}else{ %>
						<%=Util.toScreen(ChangePasswordDays,user.getLanguage())%>
					<%} %>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td width="21%"><%=SystemEnv.getHtmlLabelName(15792,user.getLanguage())%></td>
				  <td width="79%" class=Field>
				  <%if(canedit){ %>
					<input  name=DaysToRemind value="<%=DaysToRemind%>"  maxlength="50" style="width :50%" onKeyPress="ItemPlusCount_KeyPress()" onBlur='checkcount1(this)' class="InputStyle">
					<%}else{ %>
						<%=Util.toScreen(DaysToRemind,user.getLanguage())%>
					<%} %>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td width="21%"><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%></td>
				  <td width="79%" class=Field>
					<input type="checkbox" name=PasswordChangeReminder  value="1" <% if("1".equals(PasswordChangeReminder)) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				</tbody>
                           </table>      
        <br>
		<TABLE class=ViewForm>
                <COLGROUP> <COL width="20%"> <COL width="80%">
				<TBODY>
                <TR class=Title>
                  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(24075,user.getLanguage())%></TH>
                </TR>
                <TR class=Spacing style="height:2px">
                  <TD class=Line1 colSpan=2></TD>
                </TR>
                <tr>
                  <td width="21%"><%=SystemEnv.getHtmlLabelName(24076,user.getLanguage())%></td>
                  <td width="79%" class=Field>
                    <input type="checkbox" name="openPasswordLock" value="<%=openPasswordLock %>" <%if("1".equals(openPasswordLock)){ %>checked<%} %> <% if(!canedit) { %>disabled<%}%> onclick="setOpenPasswordLock(this);">
                  </td>
                </tr>
				<tr style="height:1px"><td class=Line colspan=2></td></tr>
				<%
				String PasswordLockInfo = "";
				if(!"1".equals(openPasswordLock))
					PasswordLockInfo = "none";
				%>
				<tr id="sumPasswordLockTr" style='display:<%=PasswordLockInfo %>;'>
                  <td width="21%"><%=SystemEnv.getHtmlLabelName(24077,user.getLanguage())%></td>
                  <td width="79%" class=Field>
                  <%if(canedit){ %>
                    <input type="text" class="InputStyle" size=10 maxlength=8 name="sumPasswordLock" value="<%=sumPasswordLock %>"  onKeyPress="ItemPlusCount_KeyPress()"  onBlur='checknumber("sumPasswordLock")'>
                    <%}else{ %>
						<%=Util.toScreen(sumPasswordLock,user.getLanguage())%>
					<%} %>
                  </td>
                </tr>
				<tr id="sumPasswordLockLine" style='height:1px;display:<%=PasswordLockInfo %>;'><td class=Line colspan=2></td></tr>
			
				<tr id="passwordComplexityLine" style="height:1px"><td class=Line colspan=2></td></tr>
				<TR>
					<TD colspan=2></TD>
				</TR>
				</TBODY>
		</td>
		</tr>
		</TABLE>
		</br>
		            <TABLE class=ViewForm>
				<COLGROUP> <COL width="20%"> <COL width="80%"><TBODY>
				<TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(18712,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing style="height:2px">
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				<tr>
				  <td class=Field colSpan=2><%=SystemEnv.getHtmlLabelName(18714,user.getLanguage())%></td>
				  
			        </tr>
			        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
			        <tr>
				  <td width="21%"><%=SystemEnv.getHtmlLabelName(15792,user.getLanguage())%></td>
				  <td width="79%" class=Field>
					<% if(canedit) { %>
					<input accesskey=Z name=birthremindperiod  value="<%=birthremindperiod%>" maxlength="50" style="width :50%" onKeyPress="ItemPlusCount_KeyPress()" onBlur='checkcount1(this)' class="InputStyle">
					<% } else {%>
					<%=Util.toScreen(birthremindperiod,user.getLanguage())%>
					<%}%>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td class=Field colSpan=2><%=SystemEnv.getHtmlLabelName(18715,user.getLanguage())%></td>
				  
			        </tr>
			        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(18352,user.getLanguage())%></td>
				  <td class=Field>
					<% if(canedit) { %>
					<input accesskey=Z name=congratulation  value="<%=congratulation%>" maxlength="90" style="width :90%" class="InputStyle">
					<% } else {%>
					<%=Util.toScreen(congratulation,user.getLanguage())%>
					<%}%>
				  </td>
				</tr>
					<TR><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(18713,user.getLanguage())%></td>
				  <td class=Field>
					
					<input type=radio accesskey=Z name=remindmode  value="1" <% if(remindmode.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>><%=SystemEnv.getHtmlLabelName(18716,user.getLanguage())%>
					<input type=radio accesskey=Z name=remindmode  value="0" <% if(remindmode.equals("0")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>><%=SystemEnv.getHtmlLabelName(18717,user.getLanguage())%>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(6078,user.getLanguage())%></td>
				  <td class=Field>
					<input type="checkbox" name=birthvalid  value="1" <% if(birthvalid.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				
				</TBODY>
			  </TABLE>
			  
			  <br>
			   <TABLE class=ViewForm>
				<COLGROUP> <COL width="20%"> <COL width="80%"><TBODY>
				<TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(18718,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing style="height:2px">
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				<tr>
				  <td width="21%"><%=SystemEnv.getHtmlLabelName(18719,user.getLanguage())%></td>
				  <td width="79%" class=Field>
					<input type="checkbox" name=relogin  value="1"  <% if(relogin.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				</tbody>
                           </table>
			  
			  <br>
			   <TABLE class=ViewForm>
				<COLGROUP> <COL width="20%"> <COL width="80%"><TBODY>
				<TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(18721,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing style="height:2px">
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				<tr>
				  <td width="21%"><%=SystemEnv.getHtmlLabelName(18722,user.getLanguage())%></td>
				  <td width="79%" class=Field>
					<input type="checkbox" id="needusb" name="needusb"  value="1" onclick='change(this)' <% if(needusb.equals("1")) {%>checked<%}%> <% if(!canedit||needdynapass==1) { %>disabled<%}%>>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				</tbody>
				</table>
				<div id='usbnetwork' style='visibility:hidden'>
				 <TABLE class=ViewForm>
					<COLGROUP> <COL width="20%"> <COL width="80%"><TBODY>				
					<tr>
						<td width="21%"><%=SystemEnv.getHtmlLabelName(24642,user.getLanguage())%></td>
						<td width="79%" class=Field>
							<input type="checkbox" name=needusbnetwork  value="1"  <% if(needusbnetwork.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
						</td>
					</tr>						
					<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				 </table>
			   </div>
				<div id=usbtypediv style='visibility:hidden'>
				<TABLE class=ViewForm>
				<COLGROUP> <COL width="20%"> <COL width="80%"><TBODY>				
				<tr>
					<td width="21%">USB <%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
					<td width="79%" class=Field>
						<select name=usbType onChange="usbTypeChange()" <% if(!canedit) { %>disabled<%}%>>
							<option value="1" <%if("1".equals(usbType)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(21588,user.getLanguage())%></option>
							<option value="2" <%if("2".equals(usbType)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(21589,user.getLanguage())%></option>
							<option value="3" <%if("3".equals(usbType)){%>selected<%}%> ><%=SystemEnv.getHtmlLabelName(32896, user.getLanguage())%></option>
						</select>
					</td>
				</tr>
				<TR><TD class=Line colSpan=2></TD></TR>
				</table>
				</div>
				<div id=usbsetting style='visibility:hidden'>
				<TABLE class=ViewForm>
				<COLGROUP> <COL width="20%"> <COL width="80%"><TBODY>
				<tr>
				  <td width="21%"><%=SystemEnv.getHtmlLabelName(18723,user.getLanguage())%></td>
				  <td width="79%" class=Field>
					<% if(canedit) { %>
					<input accesskey=Z name=firmcode  value="<%=firmcode%>" maxlength="50" style="width :50%" onKeyPress="ItemPlusCount_KeyPress()" onBlur='checkcount1(this)' class="InputStyle">
					<% } else {%>
					<%=Util.toScreen(firmcode,user.getLanguage())%>
					<%}%>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(18724,user.getLanguage())%></td>
				  <td class=Field>
					<% if(canedit) { %>
					<input accesskey=Z name=usercode  value="<%=usercode%>" maxlength="50" style="width :50%" onKeyPress="ItemPlusCount_KeyPress()" onBlur='checkcount1(this)' class="InputStyle">
					<% } else {%>
					<%=Util.toScreen(usercode,user.getLanguage())%>
					<%}%>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				<tbody>
				
		           </TABLE>
		           </div>			   
		           <script>
					if(frmMain.needusb.checked==true){
						usbtypediv.style.visibility='visible';
						usbnetwork.style.visibility='visible';
						if(frmMain.usbType.value==1){
							usbsetting.style.visibility='visible';
						}
					}
				   function usbTypeChange(){
						if(frmMain.usbType.value==1){
							usbsetting.style.visibility='visible';
						}else{
							usbsetting.style.visibility='hidden';
						}
				   }
		           </script>
              <br>
			   <TABLE class=ViewForm>
				<COLGROUP> <COL width="20%"> <COL width="80%"><TBODY>
				<TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(20278,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing style="height:2px">
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				<tr>
				  <td width="21%"><%=SystemEnv.getHtmlLabelName(20279,user.getLanguage())%></td>
				  <td width="79%" class=Field>
					<input type="checkbox" id="needdynapass" name="needdynapass"  value="1" onclick='change1(this)' <% if(needdynapass==1) {%>checked<%}%> <% if(!canedit||needusb.equals("1")) { %>disabled<%}%>>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				</tbody>
				</table>
				<div id=dynapasssetting style='visibility:hidden'>
				<TABLE class=ViewForm>
				<COLGROUP> <COL width="20%"> <COL width="80%"><TBODY>

				<tr>
				  <td width="21%"><%=SystemEnv.getHtmlLabelName(20280,user.getLanguage())%></td>
				  <td width="79%" class=Field>
					<% if(canedit) { %>
					<input accesskey=Z name=dynapasslen  value="<%=dynapasslen%>" maxlength="1" style="width :50%" onKeyPress="ItemPlusCount_KeyPress()" onBlur='checkcount1(this)' class="InputStyle">
					<% } else {%>
					<%=dynapasslen%>
					<%}%>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td width="21%"><%=SystemEnv.getHtmlLabelName(21993,user.getLanguage())%></td>
				  <td width="79%" class=Field>
					<% if(canedit) { %>
					<input type=radio accesskey=Z name=dypadcon  value="0" <% if(dypadcon.equals("0")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>><%=SystemEnv.getHtmlLabelName(607,user.getLanguage())%>
					<input type=radio accesskey=Z name=dypadcon  value="1" <% if(dypadcon.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>><%=SystemEnv.getHtmlLabelName(18729,user.getLanguage())%>
					<input type=radio accesskey=Z name=dypadcon  value="2" <% if(dypadcon.equals("2")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>><%=SystemEnv.getHtmlLabelName(21994,user.getLanguage())%>
					<% } else {
						if(dypadcon.equals("0")){
							out.print(SystemEnv.getHtmlLabelName(607,user.getLanguage()));
						}else if(dypadcon.equals("1")){
							out.print(SystemEnv.getHtmlLabelName(18729,user.getLanguage()));
						}else if(dypadcon.equals("2")){
							out.print(SystemEnv.getHtmlLabelName(21994,user.getLanguage()));
						}
					}%>
				  </td>
				</tr>


				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				<tbody>

		           </TABLE>
		           </div>
		           <script>
		           if(frmMain.needdynapass.checked==true){

		           dynapasssetting.style.visibility='visible'
		           }
		           </script>
              
                   <br>
			   <TABLE class=ViewForm>
				<COLGROUP> <COL width="20%"> <COL width="80%"><TBODY>
				<TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(18725,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing style="height:2px">
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				<tr>
				  <td width="21%"><%=SystemEnv.getHtmlLabelName(18726,user.getLanguage())%></td>
				  <td width="79%" class=Field>
					<input type="checkbox" name=needvalidate  value="1" onclick='change2(this)' <% if(needvalidate==1) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				</tbody>
				</table>
				<div id=validatediv style='visibility:hidden'>
				<TABLE class=ViewForm>
				<COLGROUP> <COL width="20%"> <COL width="80%"><TBODY>		
				
				<tr>
				  <td width="21%"><%=SystemEnv.getHtmlLabelName(18727,user.getLanguage())%></td>
				  <td width="79%" class=Field>
					<select name=validatetype <% if(!canedit) { %>disabled<%}%>>
                    <option value="0" <%if(validatetype==0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(607,user.getLanguage())%></option>
                    <option value="1" <%if(validatetype==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18729,user.getLanguage())%></option>
                    <option value="2" <%if(validatetype==2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18730,user.getLanguage())%></option>
                    </select>    
				  </td>
				</tr>
				
                                <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				
				<tr>
				  <td><%=SystemEnv.getHtmlLabelName(18728,user.getLanguage())%></td>
				  <td class=Field>
					<select name=validatenum <% if(!canedit) { %>disabled<%}%>>
                    <option value="4" <%if(validatenum==4) {%>selected<%}%>>4 <%=SystemEnv.getHtmlLabelName(17081,user.getLanguage())%></option>
                    <option value="5" <%if(validatenum==5) {%>selected<%}%>>5 <%=SystemEnv.getHtmlLabelName(17081,user.getLanguage())%></option>
                    <option value="6" <%if(validatenum==6) {%>selected<%}%>>6 <%=SystemEnv.getHtmlLabelName(17081,user.getLanguage())%></option>
                    </select>  
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				<tbody>	 </TABLE>
		           </div> 
                   <script>
		           if(frmMain.needvalidate.checked==true){
		           
		           validatediv.style.visibility='visible'
		           }
		           </script>
		           <%if(GCONST.getONDACTYLOGRAM()){%>
			   <TABLE class=ViewForm>
				<COLGROUP> <COL width="20%"> <COL width="80%"><TBODY>
				<TR class=Title>
				  <TH colSpan=2><%=SystemEnv.getHtmlLabelName(22058,user.getLanguage())%></TH>
				</TR>
				<TR class=Spacing style="height:2px">
				  <TD class=Line1 colSpan=2></TD>
				</TR>
				<tr>
				  <td width="21%"><%=SystemEnv.getHtmlLabelName(22062,user.getLanguage())%></td>
				  <td width="79%" class=Field>
					<input type="checkbox" name=needdactylogram  value="<%=needdactylogram%>" onclick="if(this.checked){this.value='1'}else{this.value='0'}" <% if(needdactylogram.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				<tr>
				  <td width="21%"><%=SystemEnv.getHtmlLabelName(22063,user.getLanguage())%></td>
				  <td width="79%" class=Field>
					<input type="checkbox" name=canmodifydactylogram  value="<%=canmodifydactylogram%>" onclick="if(this.checked){this.value='1'}else{this.value='0'}" <% if(canmodifydactylogram.equals("1")) {%>checked<%}%> <% if(!canedit) { %>disabled<%}%>>
				  </td>
				</tr>
				<TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
				<%}%>
				</tbody>
				</table>
	</td>
	<td></td>
</tr>
<tr>
	<td height="0" colspan="3"></td>
</tr>
</table>

  </FORM>
</BODY>
<script language="javascript">
function onSubmit()
{
	if(document.frmMain.openPasswordLock.checked == true){
		var sumPasswordLock = document.frmMain.sumPasswordLock.value;
		if(sumPasswordLock == null || sumPasswordLock == '' || sumPasswordLock == '0'){
			window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(24082,user.getLanguage())%>0!');
			return;
		}
	}
	if(document.getElementById("dynapasslen") && document.getElementById("dynapasslen").value > 8){
		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(26018,user.getLanguage())%>');
		document.getElementById("dynapasslen").focus();
		return;
	}
	frmMain.submit();
}
function change(obj){
	if(obj.checked==true){
		usbtypediv.style.visibility="visible";
		usbnetwork.style.visibility="visible";
		document.getElementById("needdynapass").checked = false;
		document.getElementById("needdynapass").disabled = true;
		dynapasssetting.style.visibility="hidden";
	}else{
		usbtypediv.style.visibility="hidden";
		usbnetwork.style.visibility="hidden";
		document.getElementById("needdynapass").disabled = false;
	}
	if(frmMain.usbType.value==1 && obj.checked==true){
		usbsetting.style.visibility="visible";
	}else{
		usbsetting.style.visibility="hidden";
	}
 }
function change1(obj){
	if(obj.checked==true){
		dynapasssetting.style.visibility="visible";
		document.getElementById("needusb").checked = false;
		document.getElementById("needusb").disabled = true;
		usbtypediv.style.visibility="hidden";
		usbnetwork.style.visibility="hidden";
	}else{
		dynapasssetting.style.visibility="hidden";
		document.getElementById("needusb").disabled = false;
	}
}
 function change2(obj){
 if(obj.checked==true){
 validatediv.style.visibility='visible'
 }else
 validatediv.style.visibility='hidden'
 }
 function setOpenPasswordLock(o)
 {
 	var sumPasswordLockTr = document.getElementById("sumPasswordLockTr");
 	var sumPasswordLockLine = document.getElementById("sumPasswordLockLine");
 	
 	if(o.checked)
 	{
 		o.value=1;
 		if(sumPasswordLockTr&&sumPasswordLockLine)
 		{
 			sumPasswordLockTr.style.display="";
 			sumPasswordLockLine.style.display="";
 		}
 	}
 	else
 	{
 		o.value=0;
 		if(sumPasswordLockTr&&sumPasswordLockLine)
 		{
 			sumPasswordLockTr.style.display="none";
 			sumPasswordLockLine.style.display="none";
 		}
 	}
 }
</script>
</HTML>
