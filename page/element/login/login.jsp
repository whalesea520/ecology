<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@ page import="weaver.hrm.settings.BirthdayReminder" %>

<%@ include file="common.jsp" %>


<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>

<%
	
	RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");

	String needusb=settings.getNeedusb();
	String usbType = settings.getUsbType();
	String firmcode=settings.getFirmcode();
	String usercode=settings.getUsercode();
	String widthValue = (String)valueList.get(nameList.indexOf("width"));
	String heightValue = (String)valueList.get(nameList.indexOf("height"));
	String actionpageValue = (String)valueList.get(nameList.indexOf("actionpage"));
	String userparamname = (String)valueList.get(nameList.indexOf("userparamname"));
	String userparampass = (String)valueList.get(nameList.indexOf("userparampass"));
	if(null==actionpageValue||"".equals(actionpageValue))
	{
		actionpageValue = "/login/VerifyLogin.jsp";
	}
	if(null==userparamname||"".equals(userparamname))
	{
		userparamname = "loginid";
	}
	if(null==userparampass||"".equals(userparampass))
	{
		userparampass = "userpassword";
	}
	if(settings==null)
	{
	    BirthdayReminder birth_reminder = new BirthdayReminder();
	    settings=birth_reminder.getRemindSettings();
	    if(settings==null)
	    {
	        out.println("Cann't create connetion to database,please check your database.");
	        return;
	    }
	    application.setAttribute("hrmsettings",settings);
	}
	int needvalidate=settings.getNeedvalidate();//0: 否,1: 是
	
%>
<style>
	#loginelement_<%=eid%> {
		MARGIN: 0px; BACKGROUND-COLOR: #ffffff
	}
	#frmLogin_<%=eid%> {
		DISPLAY: inline
	}
	#frmLogin_<%=eid%> INPUT {
		FONT-SIZE: 12px; FONT-FAMILY: Verdana;width:80px;
	}
	#frmLogin_<%=eid%> INPUT.text {
		BORDER-RIGHT: #bdbdbd 1px solid; PADDING-RIGHT: 1px; BORDER-TOP: #bdbdbd 1px solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; BORDER-LEFT: #bdbdbd 1px solid; COLOR: #999999; PADDING-TOP: 1px; BORDER-BOTTOM: #bdbdbd 1px solid; HEIGHT: 20px; BACKGROUND-COLOR: #f9f9f9;width:80px;
	}
	#frmLogin_<%=eid%> img {
		width:80px;
	}
	
	#frmLogin_<%=eid%> .left {
		width:50px;
	}

</style>

<%if(needusb!=null&&needusb.equals("1")){%>
	<%if("1".equals(usbType)){%>
	<script language="JavaScript">
		function checkusb(){ 
		  try{
			rnd=Math.round(Math.random()*1000000000)
			frmLogin_<%=eid%>.rnd.value=rnd
			wk = new ActiveXObject("WIBUKEY.WIBUKEY")
			MyAuthLib=new ActiveXObject("WkAuthLib.WkAuth")
			wk.FirmCode = <%=firmcode%>
			wk.UserCode = <%=usercode%>
			wk.UsedSubsystems = 1
			wk.AccessSubSystem() 
			if(wk.LastErrorCode==17){      
			  frmLogin_<%=eid%>.serial.value='0'
			  return      
			}      
		   if(wk.LastErrorCode>0){
			  throw new Error(wk.LastErrorCode)
			  }    
			wk.UsedWibuBox.MoveFirst()
			MyAuthLib.Data=wk.UsedWibuBox.SerialText     
			MyAuthLib.FirmCode = <%=firmcode%>
			MyAuthLib.UserCode = <%=usercode%>
			MyAuthLib.SelectionCode= rnd
			MyAuthLib.EncryptWk()
			frmLogin_<%=eid%>.serial.value= MyAuthLib.Data   
			}catch(err){
			  frmLogin_<%=eid%>.serial.value= '1'      
			  return      
			}        
		 }
		 </script>
	<%}else{%>
		<script language="JavaScript">
		
			function checkusb(){
				try{
					rnd = Math.round(Math.random()*1000000000);
					frmLogin_<%=eid%>.rnd.value=rnd
					var returnstr = getUserPIN(htactx_<%=eid%>);
					//alert(returnstr)
					if(returnstr != undefined){
						frmLogin_<%=eid%>.username.value= returnstr;
						//alert(returnstr)
						//alert(tusername);
						//alert(tserial);
						//alert(getRandomKey(rnd))
						var randomKey = getRandomKey(rnd,frmLogin_<%=eid%>,htactx_<%=eid%>)
						frmLogin_<%=eid%>.serial.value= randomKey;
					}else{
						frmLogin_<%=eid%>.serial.value= '0';
					}
				}catch(err){
					frmLogin_<%=eid%>.serial.value= '0';
					frmLogin_<%=eid%>.username.value= '';
					return;
				}
			}
		</script>
		<OBJECT id=htactx_<%=eid%> name=htactx_<%=eid%> 
classid=clsid:FB4EE423-43A4-4AA9-BDE9-4335A6D3C74E codebase="HTActX.cab#version=1,0,0,1" style="HEIGHT: 0px; WIDTH: 0px"></OBJECT>
		
	<%}%>
 <%}%>

<center>
<TABLE id="loginelement_<%=eid%>" cellSpacing=0 cellPadding=0 width=100% align=center border=0 height=<%=heightValue %>>
	<TBODY>
		<TR>
			<TD vAlign=top width=100% style="FONT: 9pt Verdana; COLOR: #333333">
				<center>
				<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0 style='table-layout:fixed'>
					<TBODY>
						<TR>
							<TD width='100%' align=middle style="FONT: 9pt Verdana; COLOR: #333333">
								<FORM name=frmLogin_<%=eid%> id="frmLogin_<%=eid%>" action=<%=actionpageValue %> method=post target=<%if("2".equals(linkmode)){ %>_blank<%}else{ %>_parent<%} %>>
									<INPUT type=hidden value=/login/Login.jsp?logintype=1 name=loginfile>
									<INPUT type=hidden name="logintype" value="1">
									<input type=hidden name="gopage" value="">
									<INPUT type=hidden name="rnd" > 
									<INPUT type=hidden name="serial">
		 							<INPUT type=hidden name="username">
									<center>
									<TABLE cellSpacing=1 cellPadding=4 width=<%=widthValue %> height=<%=heightValue %> align=center>
										<TBODY>
											<TR>
												<TD style="color:#FF0000;font-size:9pt" align=center>
													<span class="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
													<span  id="messageSpan_<%=eid%>"></span>
												</TD>
											</TR>
											<TR>
												<TD style="FONT: 9pt Verdana; COLOR: #333333" align=center>
													<span class="left"><%=SystemEnv.getHtmlLabelName(2072,7)%>:</span>
													<INPUT class=text type=text size=12 name=<%=userparamname %> id="<%=userparamname %>">
												</TD>
											</TR>
											<TR>
												<TD style="FONT: 9pt Verdana; COLOR: #333333" align=center>
													<span class="left">&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(409,7)%>:</span>
													<INPUT class=text type=password size=12 name=<%=userparampass %> id="<%=userparampass %>" <%if(needvalidate!=1){%>onkeyup="if(window.event.keyCode==13) checkall('<%=eid %>','<%=userparamname %>','<%=userparampass %>','<%=needvalidate %>','<%=needusb %>');"<%} %>>
												</TD>
											</TR>
											<%if(needvalidate==1){%>
											<TR>
												<TD style="FONT: 9pt Verdana; COLOR: #333333" align=center>
													<span class="left"><%=SystemEnv.getHtmlLabelName(22910,7)%>:</span>
													<input id="validatecode" name="validatecode" type="text"
														 value="<%=SystemEnv.getHtmlLabelName(22909,7)%>" onfocus="changeMsg('<%=eid %>',0)" onblur="changeMsg('<%=eid %>',1);" onkeyup="if(window.event.keyCode==13) checkall('<%=eid %>','<%=userparamname %>','<%=userparampass %>','<%=needvalidate %>','<%=needusb %>');">											
												</TD>
											</TR>
											<TR>
												<TD style="FONT: 9pt Verdana; COLOR: #333333" align=center>
													<span class="left">&nbsp;</span>
													<a href="javascript:changeCode()">
														<img border=0 id='imgCode' align='absmiddle'
															src='/weaver/weaver.file.MakeValidateCode'
															style="">
													</a>
													<script>
												  	 var seriesnum_=0;
												  	 function changeCode(){
												  	 	seriesnum_++;
												  		setTimeout('$("#imgCode").attr("src", "/weaver/weaver.file.MakeValidateCode?seriesnum_="+seriesnum_)',50); 
												  	 }
												  	</script>
												</TD>
											</TR>
											<%} %>
											<TR>
												<TD style="FONT: 9pt Verdana; COLOR: #333333" align=center>
													<button type="button" id="submitbutton_<%=eid %>" onclick="checkall('<%=eid %>','<%=userparamname %>','<%=userparampass %>','<%=needvalidate %>','<%=needusb %>');" style="BORDER-RIGHT: #bdbdbd 1px solid; BORDER-TOP: #bdbdbd 1px solid; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#E7E7E7); BORDER-LEFT: #bdbdbd 1px solid; CURSOR: hand; BORDER-BOTTOM: #bdbdbd 1px solid;width:70px;height:20px;">
													 <%=SystemEnv.getHtmlLabelName(674,7)%>
													</button>
													&nbsp;
													<button id="resetbutton_<%=eid %>" type="reset" style="BORDER-RIGHT: #bdbdbd 1px solid; BORDER-TOP: #bdbdbd 1px solid; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#E7E7E7); BORDER-LEFT: #bdbdbd 1px solid; CURSOR: hand; BORDER-BOTTOM: #bdbdbd 1px solid;width:70px;height:20px;">
													 <%=SystemEnv.getHtmlLabelName(2022,7)%>
													</button>
												</TD>
											</TR>
										</TBODY>
									</TABLE>
									</center>
								</FORM>
							
							</TD>
						</TR>
					</TBODY>
				</TABLE>
				</center>
			</TD>
		</TR>
	</TBODY>
</TABLE>
</center>
