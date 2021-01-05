
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%
	String flag = Util.null2String(request.getParameter("flag"));
	String ContacterID = Util.null2String(request.getParameter("ContacterID"));
	String log = Util.null2String(request.getParameter("log"));
	RecordSet.executeProc("CRM_CustomerContacter_SByID", ContacterID);
	if (RecordSet.getCounts() <= 0) {
		response.sendRedirect("/CRM/data/EditContacter.jsp?ContacterID="
				+ ContacterID + "&flag=true");
		return;
	}
	RecordSet.first();
	String CustomerID = RecordSet.getString(2);
	String photoid = Util.null2String(RecordSet.getString("contacterimageid"));

	RecordSetC.executeProc("CRM_CustomerInfo_SelectByID", CustomerID);
	if (RecordSetC.getCounts() <= 0) {
		response.sendRedirect("/CRM/data/EditContacter.jsp?ContacterID="+ ContacterID + "&flag=true");
		return;
	}
	RecordSetC.first();

	boolean hasFF = true;
	RecordSetFF.executeProc("Base_FreeField_Select", "c2");
	if (RecordSetFF.getCounts() <= 0)
		hasFF = false;
	else
		RecordSetFF.first();

	/*权限判断－－Begin*/

	String useridcheck = "" + user.getUID();
	String customerDepartment = "" + RecordSetC.getString("department");
	boolean canedit = false;
	boolean isCustomerSelf = false;

	//String ViewSql = "select * from CrmShareDetail where crmid="
	//		+ CustomerID + " and usertype=1 and userid="
	//		+ user.getUID();

	//RecordSetV.executeSql(ViewSql);

	//if (RecordSetV.next()) {
	//	if (RecordSetV.getString("sharelevel").equals("2")
	//	|| RecordSetV.getString("sharelevel").equals("3")
	//	|| RecordSetV.getString("sharelevel").equals("4")) {
	//		canedit = true;
	//	}
	//}

int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
if(sharelevel>1) canedit = true;

	if (user.getLogintype().equals("2")
			&& CustomerID.equals(useridcheck)) {
		isCustomerSelf = true;
	}

	if (useridcheck.equals(RecordSetC.getString("agent"))) {
		canedit = true;
	}

	if (RecordSetC.getInt("status") == 7
			|| RecordSetC.getInt("status") == 8) {
		canedit = false;
	}

	/*权限判断－－End*/

	if (!canedit && !isCustomerSelf) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>


<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
		<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
		<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
	</HEAD>
	<%
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(93, user
			.getLanguage())
			+ SystemEnv.getHtmlLabelName(572, user.getLanguage())
			+ " - "
			+ SystemEnv.getHtmlLabelName(136, user.getLanguage())
			+ ":<a href='/CRM/data/ViewCustomer.jsp?log="
			+ log
			+ "&CustomerID="
			+ RecordSetC.getString("id")
			+ "'>"
			+ Util.toScreen(RecordSetC.getString("name"), user
			.getLanguage()) + "</a>";
	String needfav = "1";
	String needhelp = "";
	%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<% if(flag.equals("no")) {%>
	<DIV>
		<font color=red size=2>
		<%=SystemEnv.getHtmlLabelName(21575,user.getLanguage())%>
		</font>
	</DIV>
<%}%>
<DIV style="display:none">
	<BUTTON class=btnReset accessKey=R  id=myfun2  type=reset><U>R</U>-<%=SystemEnv.getHtmlLabelName(589,user.getLanguage())%></BUTTON>
	<BUTTON class=Btn accessKey=C  id=myfun3  onclick='doCancel()'><U>C</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
	<BUTTON type="button" class=BtnDelete id=Delete accessKey=D name=button1 onclick="doDel()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
</DIV>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(589,user.getLanguage())+",javascript:document.weaver.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:doCancel(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver name="weaver" action="/CRM/data/ContacterOperation.jsp" method=post onsubmit='return check_form(this,"Title,FirstName,JobTitle,Manager")'
	enctype="multipart/form-data">
<input type="hidden" name="method" value="edit">
<input type="hidden" name="log" value="<%=log%>">
<input type="hidden" name="ContacterID" value="<%=ContacterID%>">

<wea:layout attributes="{'expandAllGroup':'true','cw1':'60%','cw2':'40%'}">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true'}">
			<wea:layout attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(61, user.getLanguage())+SystemEnv.getHtmlLabelName(87, user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(462, user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser viewType="0" name="Title" 
					         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContacterTitleBrowser.jsp"
					         browserValue='<%=Util.toScreenToEdit(RecordSet.getString("title"), user.getLanguage())%>' 
					         browserSpanValue = '<%=Util.toScreen(ContacterTitleComInfo.getContacterTitlename(RecordSet.getString("title")), user.getLanguage()) %>'
					         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='2'
					         completeUrl="/data.jsp?type=59"  ></brow:browser> 
					</wea:item>
					
					<wea:item><%=SystemEnv.getHtmlLabelName(413, user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="FirstNameimage" required="true">
							<INPUT class=InputStyle maxLength=50 size=14 name="FirstName"  onblur='checkinput("FirstName","FirstNameimage")'
								value="<%=Util.toScreenToEdit(RecordSet.getString("firstname"),user.getLanguage())%>">
						</wea:required>
					</wea:item>
					
					<wea:item><%=SystemEnv.getHtmlLabelName(475, user.getLanguage())%></wea:item>
					<wea:item>
						<INPUT class=InputStyle maxLength=50 size=14 
							name="LastName"
							value="<%=Util.toScreenToEdit(RecordSet.getString("lastName"), user.getLanguage())%>">
					</wea:item>
					
					<wea:item><%=SystemEnv.getHtmlLabelName(640, user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="JobTitleimage" required="true">
							<INPUT class=InputStyle maxLength=100 size=30
								name="JobTitle"
								onchange='checkinput("JobTitle","JobTitleimage")'
								value="<%=Util.toScreenToEdit(RecordSet.getString("jobtitle"), user.getLanguage())%>">
						</wea:required>
					</wea:item>
					
					<wea:item><%=SystemEnv.getHtmlLabelName(477, user.getLanguage())%></wea:item>
					<wea:item>
						<INPUT class=InputStyle maxLength=150 size=30
							name="CEmail" onblur="mailValid()"
							value="<%=Util.toScreenToEdit(RecordSet.getString("email"), user.getLanguage())%>">
					</wea:item>
					
					<wea:item><%=SystemEnv.getHtmlLabelName(420, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(421, user.getLanguage())%></wea:item>
					<wea:item>
						<INPUT class=InputStyle maxLength=20 size=30
							name="PhoneOffice"
							value="<%=Util.toScreenToEdit(RecordSet.getString("phoneoffice"),user.getLanguage())%>">
					</wea:item>
					
					<wea:item><%=SystemEnv.getHtmlLabelName(619, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(421, user.getLanguage())%></wea:item>
					<wea:item>
						<INPUT class=InputStyle maxLength=20 size=30
							name="PhoneHome"
							value="<%=Util.toScreenToEdit(RecordSet.getString("phonehome"),user.getLanguage())%>">
					</wea:item>
					
					<wea:item><%=SystemEnv.getHtmlLabelName(620, user.getLanguage())%></wea:item>
					<wea:item>
						<INPUT class=InputStyle maxLength=20 size=30
							name="Mobile"
							value="<%=Util.toScreenToEdit(RecordSet.getString("mobilephone"),user.getLanguage())%>">
					</wea:item>
					
					<wea:item><%=SystemEnv.getHtmlLabelName(494, user.getLanguage())%></wea:item>
					<wea:item>
						<INPUT class=InputStyle maxLength=20 size=30
							name="CFax"
							value="<%=Util.toScreenToEdit(RecordSet.getString("fax"), user.getLanguage())%>">
					</wea:item>
					
					<wea:item><%=SystemEnv.getHtmlLabelName(6066, user.getLanguage())%></wea:item>
					<wea:item>
						<INPUT class=InputStyle maxLength=100 size=30
							name="interest"
							value="<%=Util.toScreenToEdit(RecordSet.getString("interest"), user.getLanguage())%>">
					</wea:item>
					
					<wea:item><%=SystemEnv.getHtmlLabelName(6067, user.getLanguage())%></wea:item>
					<wea:item>
						<INPUT class=InputStyle maxLength=100 size=30
							name="hobby"
							value="<%=Util.toScreenToEdit(RecordSet.getString("hobby"), user.getLanguage())%>">
					</wea:item>
					
					<wea:item><%=SystemEnv.getHtmlLabelName(572, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(596, user.getLanguage())%></wea:item>
					<wea:item>
						<INPUT class=InputStyle maxLength=100 size=30
							name="managerstr"
							value="<%=Util.toScreenToEdit(RecordSet.getString("managerstr"),user.getLanguage())%>">
					</wea:item>
					
					<wea:item><%=SystemEnv.getHtmlLabelName(442, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(460, user.getLanguage())%></wea:item>
					<wea:item>
						<INPUT class=InputStyle maxLength=100 size=30
							name="subordinate"
							value="<%=Util.toScreenToEdit(RecordSet.getString("subordinate"),user.getLanguage())%>">
					</wea:item>
					
					<wea:item><%=SystemEnv.getHtmlLabelName(6068, user.getLanguage())%></wea:item>
					<wea:item>
						<INPUT class=InputStyle maxLength=100 size=30
							name="strongsuit"
							value="<%=Util.toScreenToEdit(RecordSet.getString("strongsuit"),user.getLanguage())%>">
					</wea:item>
					
					<wea:item><%=SystemEnv.getHtmlLabelName(1884, user.getLanguage())%></wea:item>
					<wea:item>
						<button type="button" class=Calendar id=selectbirthday
							onClick="getbirthday()"></button>
						<span id=birthdayspan><%=Util.toScreenToEdit(RecordSet.getString("birthday"), user.getLanguage())%> </span>
						<INPUT type="hidden" class=InputStyle
							name="birthday"
							value="<%=Util.toScreenToEdit(RecordSet.getString("birthday"), user.getLanguage())%>">
					</wea:item>
					
					<wea:item><%=SystemEnv.getHtmlLabelName(17534, user.getLanguage())%></wea:item>
					<wea:item>
						<%=SystemEnv.getHtmlLabelName(17548, user.getLanguage())%>
						<INPUT class=InputStyle maxLength=2 size=5
							name="birthdaynotifydays"
							onKeyPress="ItemCount_KeyPress()"
							onBlur='checknumber("birthdaynotifydays")'
							value="<%=Util.toScreenToEdit(RecordSet.getString("birthdaynotifydays"), user.getLanguage())%>">
						<%=SystemEnv.getHtmlLabelName(1925, user.getLanguage())%>
					</wea:item>
					
					<wea:item><%=SystemEnv.getHtmlLabelName(1967, user.getLanguage())%></wea:item>
					<wea:item>
						<INPUT class=InputStyle maxLength=100 size=30
							name="home"
							value="<%=Util.toScreenToEdit(RecordSet.getString("home"), user.getLanguage())%>">
					</wea:item>
					
					<wea:item><%=SystemEnv.getHtmlLabelName(1518, user.getLanguage())%></wea:item>
					<wea:item>
						<INPUT class=InputStyle maxLength=100 size=30
							name="school"
							value="<%=Util.toScreenToEdit(RecordSet.getString("school"), user.getLanguage())%>">
					</wea:item>
					
					<wea:item><%=SystemEnv.getHtmlLabelName(803, user.getLanguage())%></wea:item>
					<wea:item>
						<INPUT class=InputStyle maxLength=100 size=30
							name="speciality"
							value="<%=Util.toScreenToEdit(RecordSet.getString("speciality"),user.getLanguage())%>">
					</wea:item>
					
					<wea:item><%=SystemEnv.getHtmlLabelName(1840, user.getLanguage())%></wea:item>
					<wea:item>
						<INPUT class=InputStyle maxLength=100 size=30
							name="nativeplace"
							value="<%=Util.toScreenToEdit(RecordSet.getString("nativeplace"),user.getLanguage())%>">
					</wea:item>
					
					<wea:item><%=SystemEnv.getHtmlLabelName(1887, user.getLanguage())%></wea:item>
					<wea:item>
						<INPUT class=InputStyle maxLength=100 size=30
							name="IDCard" onKeyPress="ItemCount_KeyPress()"
							onBlur='checknumber("IDCard")'
							value="<%=Util.toScreenToEdit(RecordSet.getString("IDCard"), user.getLanguage())%>">
					</wea:item>
					
					<wea:item><%=SystemEnv.getHtmlLabelName(812, user.getLanguage())%></wea:item>
					<wea:item>
						<TEXTAREA class=InputStyle NAME=experience ROWS=3
							STYLE="width:60%">
							<%=Util.toScreenToEdit(RecordSet.getString("experience"),user.getLanguage())%>
						</TEXTAREA>
					</wea:item>
					
					<wea:item><%=SystemEnv.getHtmlLabelName(231, user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser viewType="0" name="Language" 
					         browserUrl="/systeminfo/BrowserMain.jsp?url=/systeminfo/language/LanguageBrowser.jsp"
					         browserValue='<%=Util.toScreenToEdit(RecordSet.getString("language"), user.getLanguage())%>' 
					         browserSpanValue = '<%=Util.toScreen(LanguageComInfo.getLanguagename(RecordSet.getString("language")), user.getLanguage())%>'
					         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='2'
					         completeUrl="/data.jsp?type=-99998"></brow:browser> 
					</wea:item>
					
					<%if (!user.getLogintype().equals("2")) {%>
					<wea:item><%=SystemEnv.getHtmlLabelName(572, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(144, user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser viewType="0" name="Manager" 
					         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					         browserValue='<%=RecordSet.getString("manager")%>' 
					         browserSpanValue = '<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("manager")), user.getLanguage())%>'
					         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='2'
					         completeUrl="/data.jsp"></brow:browser> 
					</wea:item>
					
					<%} else {%>
					<wea:item><%=SystemEnv.getHtmlLabelName(572, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(144, user.getLanguage())%></wea:item>
					<wea:item>
						<span id=manageridspan></span>
						<INPUT class=InputStyle type=hidden name=Manager
							value=<%=Util.toScreenToEdit(RecordSet.getString("manager"),user.getLanguage())%>>
					</wea:item>
					<%}%>
					
					<wea:item><%=SystemEnv.getHtmlLabelName(1262, user.getLanguage())%></wea:item>
					<wea:item>
						<INPUT type=checkbox  tzCheckbox="true" name="Main" value="1"
							<%if(RecordSet.getString("main").equals("1")){%>
						checked disabled <%}%>>
					</wea:item>
				</wea:group>
				
				<wea:group context='<%=SystemEnv.getHtmlLabelName(570, user.getLanguage())%>'>
					<%
					if (hasFF) {
						for (int i = 1; i <= 5; i++) {
							if (RecordSetFF.getString(i * 2 + 1).equals("1")) {
					%>
								<wea:item><%=Util.toScreen(RecordSetFF.getString(i * 2),user.getLanguage())%></wea:item>
								<wea:item>
									<BUTTON class=Calendar onclick="getCrmDate(<%=i%>)"></BUTTON>
									<SPAN id=datespan<%=i%>><%=RecordSet.getString("datefield" + i)%>
									</SPAN>
									<input type="hidden" name="dff0<%=i%>" id="dff0<%=i%>" value="<%=RecordSet.getString("datefield" + i)%>">
								</wea:item>
					<%
							}
						}
						
						for (int i = 1; i <= 5; i++) {
							if (RecordSetFF.getString(i * 2 + 11).equals("1")) {
					%>
								<wea:item><%=Util.toScreen(RecordSetFF.getString(i * 2 + 10), user.getLanguage())%></wea:item>
								<wea:item>
									<INPUT class=InputStyle maxLength=30 size=30
										name="nff0<%=i%>"
										value="<%=RecordSet.getString("numberfield" + i)%>">
								</wea:item>
					<%
							}
						}
						
						for (int i = 1; i <= 5; i++) {
							if (RecordSetFF.getString(i * 2 + 21).equals("1")) {
					%>
								<wea:item><%=Util.toScreen(RecordSetFF.getString(i * 2 + 20), user.getLanguage())%></wea:item>
								<wea:item>
									<INPUT class=InputStyle maxLength=100 size=30
										name="tff0<%=i%>"
										value="<%=Util.toScreenToEdit(RecordSet.getString("textfield" + i), user.getLanguage())%>">
								</wea:item>
					<%
							}
						}
						
						for (int i = 1; i <= 5; i++) {
							if (RecordSetFF.getString(i * 2 + 31).equals("1")) {
					%>
								<wea:item><%=Util.toScreen(RecordSetFF.getString(i * 2 + 30), user.getLanguage())%></wea:item>
								<wea:item>
									<INPUT type=checkbox name="bff0<%=i%>" value="1" <%if(RecordSet.getString("tinyintfield"+i).equals("1")){%>
									checked <%}%>>
								</wea:item>
					<%
							}
						}
					}
					%>
				</wea:group>
			</wea:layout>
		</wea:item>
		
		<wea:item>
			<wea:layout>
				<wea:group context='<%=SystemEnv.getHtmlLabelName(15707,user.getLanguage())%>'>
					<%if(!photoid.equals("0")&&!photoid.equals("") ){%>
						<wea:item>
							<img border=0 width="450" height="480" src="/weaver/weaver.file.FileDownload?fileid=<%=photoid%>">
						</wea:item>
							<input class=inputstyle type=hidden name=oldresourceimage value="<%=photoid%>">
							<input class=inputstyle type="hidden" name=contacterids value="<%=ContacterID%>">
						<wea:item>
							<BUTTON class=btnDelete accessKey=D
								onClick="delpic()">
								<U>D</U>-
								<%=SystemEnv.getHtmlLabelName(16075,user.getLanguage())%>
							</BUTTON>
						</wea:item>
					<%}else{%>
						<wea:item><%=SystemEnv.getHtmlLabelName(15707,user.getLanguage())%></wea:item>
						<wea:item>
							<input class=inputstyle type=file name=photoid value="<%=photoid%>">
						</wea:item>
						<wea:item>(<%=SystemEnv.getHtmlLabelName(21130,user.getLanguage())%>:400*450)</wea:item>
					<%}%>
				</wea:group>	
			</wea:layout>			
		</wea:item>
	</wea:group>
</wea:layout>

<wea:layout attributes="{'expandAllGroup':'true','cw1':'12%','cw2':'88%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(454, user.getLanguage())%>'>
		<wea:item attributes="{'colspan':'2'}">
			<TEXTAREA class=InputStyle NAME=Remark ROWS=3 STYLE="width:100%"><%=RecordSet.getString("remark")%></TEXTAREA>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(454, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(58, user.getLanguage())%></wea:item>
		<wea:item >
			<brow:browser viewType="0" name="RemarkDoc" 
		         browserUrl="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
		         browserValue='<%=RecordSet.getString("remarkDoc")%>' 
		         browserSpanValue = '<%=DocComInfo.getDocname(RecordSet.getString("remarkDoc"))%>'
		         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		         completeUrl="/data.jsp?type=9"></brow:browser> 
		</wea:item>
	</wea:group>
</wea:layout>

<script>

jQuery(function(){
	checkinput("FirstName","FirstNameimage");
	checkinput("JobTitle","JobTitleimage");
});

function onDelete(){
	window.onbeforeunload=null;
	weaver.method.value="delete";
	weaver.submit();
}
function doDel(){
	if(isdel()){onDelete();}
}
function delpic(){
      if(confirm("<%=SystemEnv.getHtmlLabelName(27748,user.getLanguage())%>")){
      window.onbeforeunload=null;
	  weaver.method.value = "delpic";
	  weaver.submit();
     }
  }
</script>


<SCRIPT type="text/javascript">
//added by lupeng 2004.06.04.
function mailValid() {
	var emailStr = document.all("CEmail").value;
	emailStr = emailStr.replace(" ","");
	if (!checkEmail(emailStr)) {
		alert("<%=SystemEnv.getHtmlLabelName(18779, user.getLanguage())%>");
		document.all("CEmail").focus();
		document.all("CEmail").value="";
		return;
	}
}

function doCancel(){
	document.location.href="/CRM/data/ViewContacter.jsp?log=<%=log%>&ContacterID=<%=ContacterID%>&canedit=true"
}

function onSave(obj){
	if(check_form(document.weaver,'Title,FirstName,JobTitle')){
		window.onbeforeunload=null;
		obj.disabled=true;
	    weaver.submit();
	}
}
function protectContacter(){
	if(!checkDataChange())//added by cyril on 2008-06-13 for TD:8828
		event.returnValue="<%=SystemEnv.getHtmlLabelName(19004, user.getLanguage())%>";
}
</SCRIPT>
	</BODY>
	<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
	<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
	<!-- added by cyril on 2008-06-13 for TD:8828 -->
	<script language=javascript src="/js/checkData_wev8.js"></script>
	<!-- end by cyril on 2008-06-13 for TD:8828 -->
</HTML>
