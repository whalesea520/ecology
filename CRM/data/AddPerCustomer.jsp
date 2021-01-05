
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.conn.*" %>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetFF" class="weaver.conn.RecordSet" scope="page" />

<%!
/**
 * @Date June 21,2004
 * @Author Charoes Huang
 * @Description 检测是否是个人用户的添加
 */
	private boolean isPerUser(String type){
		RecordSet rs = new RecordSet();
		String sqlStr ="Select * From CRM_CustomerType WHERE ID = "+type+" and candelete='n' and canedit='n' and fullname='个人用户'";
		rs.executeSql(sqlStr);
		if(rs.next()){
			return true;
		}
		return false;
	}
%>

<%
boolean hasFF = true;
RecordSetFF.executeProc("Base_FreeField_Select","c1");
if(RecordSetFF.getCounts()<=0)
	hasFF = false;
else
	RecordSetFF.first();
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%--
<script language=javascript >
function checkSubmit(){
    if(check_form(weaver,"Name,Abbrev,Address1,Type,Description,Size,Source,Sector,Manager,Department,Title,FirstName,JobTitle,Email,seclevel,CreditAmount,CreditTime")){
        weaver.submit();
    }
}
</script>
--%>
<script language=javascript >

function checkSubmit(obj){
	window.onbeforeunload=null;
	if(check_form(weaver,"Name,Phone")){
		obj.disabled = true; // added by 徐蔚绛 for td:1553 on 2005-03-22
		weaver.submit();
	}
}
function protectCus(){
	event.returnValue="<%=SystemEnv.getHtmlLabelName(18675,user.getLanguage())%>";
}
</script>
</HEAD>

<%
String type = Util.null2String(request.getParameter("type1"));
String name = Util.fromScreen2(Util.null2String(request.getParameter("name1")),user.getLanguage());

// check the "type" null value added by lupeng 2004-8-9. :)
/*Added by Charoes Huang On June 21,2004*/
//if(!type.equals("") && isPerUser(type)){
	//response.sendRedirect("AddPerCustomer.jsp?type1="+type+"&name1="+name);
	//return;
//}

%>

<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17706,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY onbeforeunload="protectCus()">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location='/CRM/data/AddCustomerExist.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>

<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<FORM id=weaver name= weaver action="/CRM/data/CustomerPerOperation.jsp" method=post onsubmit='return check_form(this,"Name,Phone")'>
<input type="hidden" name="method" value="addPer">

<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="49%">
  <COL width=10>
  <COL width="49%">
  <TBODY>
  <TR>

	<TD vAlign=top>
	
	<TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=2></TD></TR>
        
        <%--Modified by xwj for td1552 on 2005-03-22
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(412,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="PortalLoginID" onchange='checkinput("PortalLoginID","PortalLoginIDimage")' STYLE="width:95%">
		  <SPAN id=PortalLoginIDimage></SPAN></TD>
        </TR><tr><td class=Line colspan=2></td></tr>--%>
        
     <%--Modified by xwj for td1552 on 2005-03-22
	  <TR> 
		 <TD><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></TD>
          <TD class=Field><INPUT onchange='checkinput("PortalPassword","PortalPasswordimage")' class=InputStyle maxLength=50 name="PortalPassword" STYLE="width:95%">
		  <SPAN id=PortalPasswordimage></SPAN></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
     --%>        
        
	   <%--????--%>
	  
		<%--??--%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="Name" onchange='checkinput("Name","Nameimage")' STYLE="width:95%" value="<%=name%>" onkeydown="if(event.keyCode==222){return false;}">
		  <SPAN id=Nameimage><%if("".equals(name)) {%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN></TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>
		<%--??--%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></TD>
		  <TD class="Field">
		  <Select name="Sex">
			<option value="0"><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%></option>
			<option value="1"><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%></option>
		  </Select></TD>
		  
		</TR>
		<%--????--%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(1887,user.getLanguage())%></TD>
		  <TD class="Field">
			<INPUT maxLength=150 class=InputStyle name="IDCardNo"  onKeyPress="ItemCount_KeyPress()" <%--onchange='checkinput("IDCardNo","IDCardNoimage")'--%> STYLE="width:95%"  >
			 <SPAN id=IDCardNoimage></SPAN>
		  </TD>
		</TR>
		<tr style="height:1px"><td class=Line colspan=2></td></tr>
		<%--??--%>
		<TD><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TD>
          <TD class=Field><BUTTON type="button" class=Browser id=SelectCityID onclick="onShowCityID()"></BUTTON> 
              <SPAN id=cityidspan STYLE="width:39%"></SPAN>
              <INPUT id=CityCode type=hidden name=City>          
            <SPAN STYLE="width:1%"></SPAN></TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>    
       <%--????--%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="Phone" onKeyPress="ItemPhone_KeyPress()" onBlur='<%--checknumber("Phone");--%>checkinput("Phone","Phoneimage")' STYLE="width:45%"><SPAN id=Phoneimage STYLE="width:5%"><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>  
	    <%--??--%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="Address1" <%--onchange='checkinput("Address1","Address1image")'--%> STYLE="width:95%"><SPAN id=Address1image></SPAN></TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>        
         <TR>
          <TD><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></TD>
          <TD class=Field>
		  <INPUT maxLength=150 class=InputStyle name="Email" onblur='checkinput_email_only("Email","Emailimage",false)' STYLE="width:95%">
		  <SPAN id=Emailimage></SPAN>
		  </TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>   
           
     
        </TBODY>
	  </TABLE>
	
	<%-- xwj for td1552 on 2005-03-22
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="Name" onchange='checkinput("Name","Nameimage")' STYLE="width:95%" value='<%=Util.toScreen(name,user.getLanguage(),"0")%>'><SPAN id=Nameimage><%if(name=="") {%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <!--add CRM CODE by lupeng 2004.03.30-->
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(17080,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="crmcode" STYLE="width:95%"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(642,user.getLanguage())%>）</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="Abbrev" onchange='checkinput("Abbrev","Abbrevimage")' STYLE="width:95%"><SPAN id=Abbrevimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
        </TR><tr><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>1</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="Address1" onchange='checkinput("Address1","Address1image")' STYLE="width:95%"><SPAN id=Address1image><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
        </TR><tr><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>2&nbsp;</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="Address2" STYLE="width:95%"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>3&nbsp;</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="Address3" STYLE="width:95%"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=10 name="Zipcode" STYLE="width:45%"><SPAN STYLE="width:5%"></SPAN>
		  <BUTTON class=Browser id=SelectCityID onclick="onShowCityID()"></BUTTON> 
              <SPAN id=cityidspan STYLE="width:39%"></SPAN>
              <INPUT id=CityCode type=hidden name=City>          
            <SPAN STYLE="width:1%"></SPAN></TD>
        </TR><tr><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(643,user.getLanguage())%></TD>
          <td class=Field id=txtLocation>
          <BUTTON class=Browser id=SelectCountryID onclick="onShowCountryID()"></BUTTON> 
              <SPAN id=countryidspan STYLE="width:34%"><%=Util.toScreen(CountryComInfo.getCountryname(""+user.getCountryid()),user.getLanguage())%></SPAN>
              <INPUT id=CountryCode type=hidden name=Country value="<%=user.getCountryid()%>">          
            <SPAN STYLE="width:5%"></SPAN>
			<!--BUTTON class=Browser id=SelectProvinceID onclick="onShowProvinceID()"></BUTTON> 
              <SPAN id=provinceidspan STYLE="width:39%"></SPAN>
              <INPUT id=ProvinceCode type=hidden name=Province>          
            <SPAN STYLE="width:1%"></SPAN></TD -->
        </TR><tr><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(644,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="County" STYLE="width:95%"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></TD>
          <td class=Field id=txtLocation><BUTTON class=Browser onclick="onShowLanguageID()"></BUTTON> 
              <SPAN id=languageidspan><%=Util.toScreen(LanguageComInfo.getLanguagename(""+user.getLanguage()),user.getLanguage())%></SPAN> 
              <INPUT type=hidden name=Language value="<%=user.getLanguage()%>">        </TD>
        </TR><tr><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="Phone" STYLE="width:45%"><SPAN STYLE="width:5%"></SPAN><INPUT class=InputStyle maxLength=50 name="Fax" STYLE="width:45%"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></TD>
          <TD class=Field>
		  <INPUT maxLength=150 class=InputStyle name="Email" onblur='checkinput_email("Email","Emailimage")' STYLE="width:95%">
		  <SPAN id=Emailimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
		  </TD>
        </TR><tr><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(76,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=150 name="Website" value="http://" STYLE="width:95%"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>        
        </TBODY>
	  </TABLE>
--%>

  <%--------- begin--------
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(462,user.getLanguage())%></TD>
          
           <td class=Field id=txtLocation><BUTTON class=Browser onclick="onShowTitleID()"></BUTTON> 
              <SPAN id=Titlespan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN> 
              <INPUT type=hidden name=Title>        </TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="FirstName" onchange='checkinput("FirstName","FirstNameimage")' STYLE="width:95%"><SPAN id=FirstNameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(640,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 name="JobTitle" onchange='checkinput("JobTitle","JobTitleimage")' STYLE="width:95%"><SPAN id=JobTitleimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=150 name="CEmail" STYLE="width:95%"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=20 name="PhoneOffice" STYLE="width:95%"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(619,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=20 name="PhoneHome" STYLE="width:95%"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=20 name="Mobile" STYLE="width:95%"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        </TBODY>
	  </TABLE>
--------- end---------%>

	</TD>

    <TD></TD>
    
	<TD vAlign=top>
      
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(574,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
          <TD class=Field><BUTTON type="button" class=Browser onclick="onShowStatusID()"></BUTTON>
          <SPAN id=Statusspan>
          </SPAN>
          <INPUT type=hidden name="CustomerStatus" value="1"></TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
          
          <td class=Field id=txtLocation><%--<BUTTON class=Browser onclick="onShowTypeID()"></BUTTON>--%>
              <SPAN id=Typespan><%=Util.toScreen(CustomerTypeComInfo.getCustomerTypename(type),user.getLanguage())%></SPAN>
              <INPUT type=hidden name=Type value="<%=type%>"></TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>
        
        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          
          <td class=Field id=txtLocation><BUTTON type="button" class=Browser onclick="onShowDescriptionID()"></BUTTON> 
              <SPAN id=Descriptionspan></SPAN> 
              <INPUT type=hidden name=Description>  </TD>
         </TR><tr style="height:1px"><td class=Line colspan=2></td></tr> 
          
               
      <%-- xwj for td1552 on 2005-03-22
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(576,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Browser onclick="onShowSizeID()"></BUTTON> 
              <SPAN id=Sizespan><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN> 
              <INPUT type=hidden name=Size></TD>
        </TR><tr><td class=Line colspan=2></td></tr>        
        --%>
        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(645,user.getLanguage())%></TD>
          <TD class=Field id=txtLocation>
          <BUTTON type="button" class=Browser onclick="onShowSourceID()"></BUTTON> 
              <SPAN id=Sourcespan></SPAN> 
              <INPUT type=hidden name=Source></td>
              
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>        
        
       
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON type="button" class=Browser onclick="onShowSectorID()"></BUTTON> 
              <SPAN id=Sectorspan></SPAN> 
              <INPUT type=hidden name=Sector>
              </TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>  
       
        
<%if(!user.getLogintype().equals("3")) {%>		
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON type="button" class=Browser id=SelectManagerID onClick="onShowManagerID()"></BUTTON> <span 
            id=manageridspan><%=user.getUsername()%></span> 
              <INPUT class=InputStyle type=hidden name=Manager value="<%=user.getUID()%>">
              <input type=hidden name=Agent value="<%=user.getUID()%>">
           </TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>        
       
        <%-- xwj for td1552 on 2005-03-22
        <!--TR>
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
          <TD class=Field>
          <button class=Browser id=SelectDeparment onClick="onShowDepartment()"></button> 
              <span class=InputStyle id=departmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+user.getUserDepartment()),user.getLanguage())%></span> 
              <input id=departmentid type=hidden name=Department value="<%=user.getUserDepartment()%>"></TD>
        </TR -->        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(132,user.getLanguage())%></TD>
          <TD class=Field>
           <button class=Browser id=SelectDeparment onClick="onShowAgent()"></button> 
              <span class=InputStyle id=Agentspan></span> 
              <input type=hidden name=Agent></TD>
        </TR><tr><td class=Line colspan=2></td></tr> 
        --%>
            
<%} else {%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></TD>
          <TD class=Field>
          <span             id=manageridspan><%=Util.toScreen(ResourceComInfo.getResourcename(user.getManagerid()),user.getLanguage())%></span> 
              <INPUT class=InputStyle type=hidden name=Manager value="<%=user.getManagerid()%>"></TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>
                
       <%-- xwj for td1552 on 2005-03-22
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
          <TD class=Field>
              <span class=InputStyle id=departmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+user.getUserDepartment()),user.getLanguage())%></span> 
              <input id=departmentid type=hidden name=Department value="<%=user.getUserDepartment()%>"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>        
        
        
        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(132,user.getLanguage())%></TD>
          <TD class=Field>
              <span class=InputStyle id=Agentspan><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+user.getUID()),user.getLanguage())%></span> 
              <input type=hidden name=Agent value="<%=user.getUID()%>"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>
        --%>
           

<%}%>
       
      <%--xwj for td1552 on 2005-03-22
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(591,user.getLanguage())%></TD>
          <TD class=Field><button class=Browser id=SelectDeparment onClick="onShowParent()"></button> 
              <span class=InputStyle id=Parentspan></span> 
              <input type=hidden name=Parent>
          </TD>
        </TR><tr><td class=Line colspan=2></td></tr>        
       
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Browser onclick="showDoc()"></BUTTON>      
      <SPAN ID=Documentname></SPAN>
        <INPUT class=InputStyle type=hidden name=Document></TD>
        </TR><tr><td class=Line colspan=2></td></tr> 
		
		
		 <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6069,user.getLanguage())%></TD>
          <TD class=Field>
          <BUTTON class=Browser onclick="showRemarkdocName()"></BUTTON>      
      <SPAN ID=introductionDocname></SPAN>
        <INPUT class=InputStyle type=hidden name=introductionDocid></TD>
        </TR><tr><td class=Line colspan=2></td></tr>  
    --%>

	<%if(!user.getLogintype().equals("2")){%>
        <TR>
		  <TD><%=SystemEnv.getHtmlLabelName(120,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></TD>
		  <TD class=Field> <INPUT class=InputStyle maxLength=3 size=5 	name=seclevel onKeyPress="ItemCount_KeyPress()" <%--onBlur='checknumber("seclevel");checkinput("seclevel","seclevelimage")'--%> value="0">
		   <SPAN id=seclevelimage></SPAN>
		  </TD>
	    </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>		
	<%}else{%>
		 <INPUT type=hidden	name=seclevel value="0">
	<%}%>
<!--        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=5 size=5 name="Photo"></TD>
        </TR><tr><td class=Line colspan=2></td></tr>        
-->        </TBODY>
	  </TABLE>
	  
	  
		 <%
		String sqlStr = "select * from CRM_CustomerCredit";
		String CreditAmount = "" ;
		String CreditTime = "";
		RecordSet.executeSql(sqlStr);
		if (RecordSet.next()) {
			CreditAmount = RecordSet.getString("CreditAmount");
			CreditTime = RecordSet.getString("CreditTime");
		}
		%>

        <%-- begin--%>
        <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colspan = 2><%=SystemEnv.getHtmlLabelName(15125,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=2></TD></TR>
<%if(!user.getLogintype().equals("2")){%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6097,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=11 size=20 name="CreditAmount" onchange='<%--checkinput("CreditAmount","CreditAmountimage");--%>checkdecimal_length("CreditAmount",8)' onKeyPress="ItemNum_KeyPress()" <%--onBlur='checknumber("CreditAmount")'--%> value = "<%=CreditAmount%>"><SPAN id=CreditAmountimage></SPAN></TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6098,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=3 size=20 name="CreditTime" <%--onchange='checkinput("CreditTime","CreditTimeimage")'--%> onKeyPress="ItemCount_KeyPress()" <%--onBlur='checknumber("CreditTime")'--%> value = "<%=CreditTime%>"><SPAN id=CreditTimeimage></SPAN></TD>
         </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>       

<%}else{%>
		<INPUT type=hidden class=InputStyle name="CreditAmount"  value = "<%=CreditAmount%>">
		<INPUT type=hidden class=InputStyle name="CreditTime"  value = "<%=CreditTime%>">
<%}%>
         <TR>
          <TD><%=SystemEnv.getHtmlLabelName(17084,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=200 size=20 name="bankname"></TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(571,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=20 size=20 name="accountname"></TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(17085,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=200 size=20 name="accounts" onKeyPress="ItemCount_KeyPress()"></TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>
    </TABLE>
   <%-- end--%>
    
    
<%-- begin--%>
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing>
          <TD class=Line1 colSpan=2></TD></TR>
<%
if(hasFF)
{
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+1).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2)%></TD>
          <TD class=Field>
          <BUTTON type="button" class=Calendar onclick="getCrmDate(<%=i%>)"></BUTTON>  
              <SPAN id=datespan<%=i%> ></SPAN> 
              <input type="hidden" name="dff0<%=i%>" id="dff0<%=i%>">
          </TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+11).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+10)%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=30 name="nff0<%=i%>" value="0.0" STYLE="width:95%"></TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+21).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+20)%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 name="tff0<%=i%>" STYLE="width:95%"></TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+31).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+30)%></TD>
          <TD class=Field>
          <INPUT type=checkbox  name="bff0<%=i%>" value="1"></TD>
        </TR><tr style="height:1px"><td class=Line colspan=2></td></tr>
		<%}
	}
}
%>
        </TBODY>
	  </TABLE>	  
<%-- end--%>

	</TD>
  </TR>
  </TBODY>
</TABLE>
</FORM>
<script type="text/javascript">
function onShowCityID(){
	 datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp");
	 if(datas){
		 if(datas.id!=""){
			 $GetEle("cityidspan").innerHTML = datas.name;
			 $GetEle("City").value=datas.id;
		 }else{
			 $GetEle("cityidspan").innerHTML = "";
			 $GetEle("City").value="";
		 }
	 }
}
function onShowDescriptionID(){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerDescBrowser.jsp");
	 if(datas){
		 if(datas.id!=""){
			 $GetEle("Descriptionspan").innerHTML = datas.name;
			 $GetEle("Description").value=datas.id;
		 }else{
			 $GetEle("Descriptionspan").innerHTML = "";
			 $GetEle("Description").value="";
		 }
	 }
}
function onShowSourceID(){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContactWayBrowser.jsp");
	 if(datas){
		 if(datas.id!=""){
			 $GetEle("Sourcespan").innerHTML = datas.name;
			 $GetEle("Source").value=datas.id;
		 }else{
	 		 $GetEle("Sourcespan").innerHTML = "";
			 $GetEle("Source").value="";
		 }
	 }
}
function onShowSectorID(){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/SectorInfoBrowser.jsp");
	 if(datas){
		 if(datas.id!=""){
			 $GetEle("Sectorspan").innerHTML = datas.name;
			 $GetEle("Sector").value=datas.id;
		 }else{
	 		 $GetEle("Sectorspan").innerHTML = "";
			 $GetEle("Sector").value="";
		 }
	 }
}
function onShowManagerID(){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	 if(datas){
		 if(datas.id!=""){
			 $GetEle("manageridspan").innerHTML = "<A href='/hrm/resource/HrmResource.jsp?id="+datas.id+"'>"+datas.name+"</A>";
			 $GetEle("Manager").value=datas.id;
		 }else{
	 		 $GetEle("manageridspan").innerHTML = "";
			 $GetEle("Manager").value="";
		 }
	 }
}
function onShowStatusID(){
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp");
	 if(datas){
		 if(datas.id!=""){
			 $GetEle("Statusspan").innerHTML = datas.name;
			 $GetEle("CustomerStatus").value=datas.id;
		 }else{
	 		 $GetEle("Statusspan").innerHTML = "";
			 $GetEle("CustomerStatus").value="";
		 }
	 }
}
</script>
		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</BODY>
</HTML>
