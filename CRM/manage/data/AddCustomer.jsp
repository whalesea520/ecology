
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

String type = Util.null2String(request.getParameter("type1"));
String name = Util.null2String(request.getParameter("name1"));
if(!user.getLogintype().equals("2")){//跳转到新客户卡片
	response.sendRedirect("/CRM/manage/customer/CustomerAdd.jsp?type1="+type+"&name1=" + URLEncoder.encode(name));
	return;
}
// check the "type" null value added by lupeng 2004-8-9. :)
/*Added by Charoes Huang On June 21,2004*/
if(!type.equals("") && isPerUser(type)){
	response.sendRedirect("AddPerCustomer.jsp?type1="+type+"&name1=" + new String(name.getBytes("UTF-8") , "ISO8859_1"));
	
	return;
}

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
<script language=javascript >
function checkSubmit(obj){
	window.onbeforeunload=null;
	if(check_form(weaver,"Name,Abbrev,Address1,Language,Type,Description,Size,Source,Sector,Manager,Department,Title,FirstName,JobTitle,Email,seclevel,CreditAmount,CreditTime,City,CustomerStatus,Phone")){
		var source = $G("Source").value;
		
		if(source==1 || source==18){//如果为电话开拓则开拓人员为必填
			if(check_form(weaver,"exploiterIds")){
				obj.disabled = true;
				weaver.submit();
			}
		}
		<%if(!user.getLogintype().equals("2")){%>//如果为代理商伙伴类则中介机构为必填
			else if(source==22 || source==23 || source==24 || source==25 || source==26 || source==27){
				if(check_form(weaver,"Agent")){
					obj.disabled = true;
					weaver.submit();
				}
			}
		<%}%>
		else{
		
			obj.disabled = true; // added by 徐蔚绛 for td:1553 on 2005-03-22
			weaver.submit();
		}
	}
}
function protectCus(){
	if(!checkDataChange())//added by cyril on 2008-06-12 for TD:8828
		event.returnValue="<%=SystemEnv.getHtmlLabelName(18675,user.getLanguage())%>";
}
function mailValid() {
	var emailStr = document.all("CEmail").value;
	emailStr = emailStr.replace(" ","");
	if (!checkEmail(emailStr)) {
		alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage())%>");
		document.all("CEmail").focus();
		return;
	}
}
function checktext(){
	if(document.all("introduction").value.length>100){
		document.all("introduction").value=document.all("introduction").value.substring(0,99);
		alert('最大长度为100');
		return;
	
	}


}
</script>

</HEAD>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(136,user.getLanguage());
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

<FORM id=weaver name= weaver action="/CRM/data/CustomerOperation.jsp" method=post onsubmit='return check_form(this,"Name,Abbrev,Address1,Language,Type,Description,Size,Source,Sector,Manager,Department,Title,FirstName,JobTitle,Email,seclevel,CreditAmount,CreditTime")' enctype="multipart/form-data">
<input type="hidden" name="method" value="add">

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
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="Name" onchange='checkinput("Name","Nameimage")' STYLE="width:300" value="<%=name%>"><SPAN id=Nameimage><%if(name.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></SPAN>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <!--add CRM CODE by lupeng 2004.03.30-->
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(17080,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="crmcode" STYLE="width:95%"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%>（<%=SystemEnv.getHtmlLabelName(642,user.getLanguage())%>）</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="Abbrev" onchange='checkinput("Abbrev","Abbrevimage")' STYLE="width:95%"><SPAN id=Abbrevimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>1</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=120 name="Address1" onchange='checkinput("Address1","Address1image")' STYLE="width:95%"><SPAN id=Address1image><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>2&nbsp;</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=120 name="Address2" STYLE="width:95%"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%>3&nbsp;</TD>
          <TD class=Field><INPUT class=InputStyle maxLength=120 name="Address3" STYLE="width:95%"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>

        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=10 name="Zipcode" STYLE="width:45%"><SPAN STYLE="width:5%"></SPAN>
		  	
		  	<INPUT id=CityCode class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp" type=hidden name=City _required="yes">                    
            
            <SPAN STYLE="width:1%"></SPAN></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>      
				 <TR>
          <TD><%=SystemEnv.getHtmlLabelName(25223,user.getLanguage())%></TD>
          <TD class=Field>
          	<INPUT id=citytwoCode class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/hrm/city/CityTwoBrowser.jsp" type=hidden name=citytwoCode>        
          	<!--BUTTON class=Browser id=SelectcitytwoID onclick="onShowCityTwoID()"></BUTTON> 
              <SPAN id=citytwoidspan STYLE="width:34%"><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
              <INPUT id=citytwoCode type=hidden name=citytwoCode -->          
            <SPAN STYLE="width:5%"></SPAN></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>  
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(643,user.getLanguage())%></TD>
          <td class=Field id=txtLocation>
          	<INPUT id=CountryCode class="wuiBrowser" _displayText="<%=Util.toScreen(CountryComInfo.getCountryname(""+user.getCountryid()),user.getLanguage())%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp" type=hidden name=Country value="<%=user.getCountryid()%>">               
            
            <SPAN STYLE="width:5%"></SPAN>
			<!--BUTTON class=Browser id=SelectProvinceID onclick="onShowProvinceID()"></BUTTON> 
              <SPAN id=provinceidspan STYLE="width:39%"></SPAN>
              <INPUT id=ProvinceCode type=hidden name=Province>          
            <SPAN STYLE="width:1%"></SPAN></TD -->
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>        
             
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></TD>
          <td class=Field id=txtLocation>
              <INPUT type=hidden class="wuiBrowser" _displayText="<%=Util.toScreen(LanguageComInfo.getLanguagename(""+user.getLanguage()),user.getLanguage())%>" _required="yes"  _url="/systeminfo/BrowserMain.jsp?url=/systeminfo/language/LanguageBrowser.jsp" name=Language value="<%=user.getLanguage()%>">        </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>             
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(494,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="Phone" STYLE="width:45%" onchange='checkinput("Phone","PhoneImage")'><SPAN id=PhoneImage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN><SPAN STYLE="width:5%"></SPAN><INPUT class=InputStyle maxLength=50 name="Fax" STYLE="width:45%"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>            
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></TD>
          <TD class=Field>
		  <INPUT maxLength=150 class=InputStyle name="Email" onblur='checkinput_email("Email","Emailimage")' STYLE="width:95%">
		  <SPAN id=Emailimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
		  </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>      
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(76,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=150 name="Website" value="http://" STYLE="width:95%"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>        
        
           <!-- 介绍 -->
	         <TR>
	           <TD><%=SystemEnv.getHtmlLabelName(634,user.getLanguage())%></TD>
	            <TD class=Field>
	              <textarea class=inputstyle  name ="introduction" wrap="virtual"   wrap="hard" cols=20  id="introduction" STYLE="width:330;" onKeyPress="checktext();"></textarea>
	            </TD>
	        </TR>
	        <tr style="height: 1px"><td class=Line colspan=2></td></tr>     
           <!-- /介绍 -->
        </TBODY>
	  </TABLE>

	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(462,user.getLanguage())%></TD>
          
           <td class=Field id=txtLocation>
              <INPUT type=hidden class="wuiBrowser" _required="yes" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContacterTitleBrowser.jsp" name=Title>        </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 name="FirstName" onchange='checkinput("FirstName","FirstNameimage")' STYLE="width:95%"><SPAN id=FirstNameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(640,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 name="JobTitle" onchange='checkinput("JobTitle","JobTitleimage")' STYLE="width:95%"><SPAN id=JobTitleimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <!-- 增加联系人项目角色、意向判断、关注点字段开始 QC16057-->
        <TR>
          <TD>项目角色</TD>
          <TD class=Field>
          	<INPUT class=InputStyle maxLength=100 style="width:95%" name="projectrole" />
          </TD>
        </TR>
        <tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD>意向判断</TD>
          <TD class=Field>
          	<select name="attitude">
          		<option value=""></option>
          		<option value="支持我方">支持我方</option>
          		<option value="未表态">未表态</option>
          		<option value="未反对">未反对</option>
          		<option value="反对">反对</option>
          	</select>
          </TD>
        </TR>
        <tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD>关注点</TD>
          <TD class=Field>
          	<INPUT class=InputStyle maxLength="200" style="width:95%" name="attention" />
          </TD>
        </TR>
        <tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <!-- 增加联系人项目角色、意向判断、关注点字段结束 -->
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=150 name="CEmail" onblur='mailValid()' STYLE="width:95%"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(420,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=20 name="PhoneOffice" STYLE="width:95%"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(619,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=20 name="PhoneHome" STYLE="width:95%"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=20 name="Mobile" STYLE="width:95%"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
		 <TD><%=SystemEnv.getHtmlLabelName(25101,user.getLanguage())%><!-- IM号码--></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 size=30 name="imcode"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        
        <TR>
		 <TD><%=SystemEnv.getHtmlLabelName(25102,user.getLanguage())%><!-- 状态 --></TD>
          <TD class=Field>
          	<select name="status">
          		<option value="1"><%=SystemEnv.getHtmlLabelName(2246,user.getLanguage())%><!-- 有效 --></option>
          		<option value="0"><%=SystemEnv.getHtmlLabelName(6091,user.getLanguage())%><!-- 离职 --></option>
          		<option value="2"><%=SystemEnv.getHtmlLabelName(463,user.getLanguage())%><!-- 未知 --></option>
          	</select>
          </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        
        <TR>
		 <TD><%=SystemEnv.getHtmlLabelName(25103,user.getLanguage())%><!-- 是否需要联系 --></TD>
          <TD class=Field>
          	<select name="isneedcontact">
          		<option value="1"><%=SystemEnv.getHtmlLabelName(25104,user.getLanguage())%><!-- 是 --></option>
          		<option value="0"><%=SystemEnv.getHtmlLabelName(25105,user.getLanguage())%><!-- 否 --></option>
          	</select>
          </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
           <TD><%=SystemEnv.getHtmlLabelName(15707,user.getLanguage())%></TD>
            <TD class=Field>
              <input class=inputstyle maxLength=20 type="file" STYLE="width:95%" name="photoid">
            </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        </TBODY>
	  </TABLE>

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
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
          <TD class=Field>
          <INPUT type=hidden class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp" name="CustomerStatus" value="" _required="yes"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
          
          <td class=Field id=txtLocation>
              <INPUT type=hidden class="wuiBrowser" _required="yes" _displayText="<%if (type!="") {%><%=Util.toScreen(CustomerTypeComInfo.getCustomerTypename(type),user.getLanguage())%><%}else {%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerTypeBrowser.jsp" name=Type value="<%=type%>">        </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
          
          <td class=Field id=txtLocation>
              <INPUT class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerDescBrowser.jsp" _required="yes" type=hidden name=Description>        </TD>
         </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>        
      
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(576,user.getLanguage())%></TD>
          <TD class=Field>
          <INPUT class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerSizeBrowser.jsp" _required="yes" type=hidden name=Size></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr> 
            
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(645,user.getLanguage())%></TD>
          <TD class=Field>
          <INPUT class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContactWayBrowser.jsp" _required="yes" type="hidden" name="Source" _callBack="changeSource"></td>

              
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(575,user.getLanguage())%></TD>
          <TD class=Field>
          <INPUT class="wuiBrowser" _url="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/SectorInfoBrowser.jsp" _required="yes" type=hidden name=Sector>


              </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>  
<%if(!user.getLogintype().equals("2")) {%>		
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></TD>
          <TD class=Field>
          <INPUT class="wuiBrowser" _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>" _required="yes" _displayText="<%=user.getUsername()%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" type=hidden name=Manager value="<%=user.getUID()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>         
        <!--TR>
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
          <TD class=Field>
          <button class=Browser id=SelectDeparment onClick="onShowDepartment()"></button> 
              <span id=departmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+user.getUserDepartment()),user.getLanguage())%></span> 
              <input class=InputStyle id=departmentid type=hidden name=Department value="<%=user.getUserDepartment()%>"></TD>
        </TR -->        
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(132,user.getLanguage())%></TD>
          <TD class=Field>
           <input class=wuiBrowser _displayTemplate="<A href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}'>#b{name}</A>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type in (3,4,11,12,13,14,15,16,17,18,20,21,25)" type=hidden id=Agent name=Agent></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>     
<%} else {%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></TD>
          <TD class=Field>
          <span             id=manageridspan><%=Util.toScreen(ResourceComInfo.getResourcename(user.getManagerid()),user.getLanguage())%></span> 
              <INPUT class=InputStyle type=hidden name=Manager value="<%=user.getManagerid()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>    
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
          <TD class=Field>
              <span id=departmentspan><%=Util.toScreen(DepartmentComInfo.getDepartmentname(""+user.getUserDepartment()),user.getLanguage())%></span> 
              <input class=InputStyle id=departmentid type=hidden name=Department value="<%=user.getUserDepartment()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>      
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(132,user.getLanguage())%></TD>
          <TD class=Field>
              <span id=Agentspan><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+user.getUID()),user.getLanguage())%></span> 
              <input class=InputStyle type=hidden name=Agent value="<%=user.getUID()%>"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>   

<%}%>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(25171,user.getLanguage())%><!-- 开拓人员 --></TD>
          <TD class=Field>
          	<INPUT class="wuiBrowser" _displayTemplate="<A href='javaScript:openhrm(#b{id})' onclick='pointerXY(event)'>#b{name}</A>" 
          	 _displayText="" _param="resourceids" id="exploiterIds"
          	 _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" type="hidden" name="exploiterIds" value="">
          	 <!--
          	<button class=Browser id=SelectExploiter onClick="onShowMultiHrmResource('exploiterIds','exploiterSpan',false)"></button> 
              <span  id=exploiterSpan name=exploiterSpan></span> 
              <input type=hidden name=exploiterIds id=exploiterIds-->
          </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(24976,user.getLanguage())%><!-- 客服负责人 --></TD>
          <TD class=Field>
          	<INPUT class="wuiBrowser" _displayTemplate="<A href='javaScript:openhrm(#b{id})' onclick='pointerXY(event)'>#b{name}</A>" 
          	 _displayText="" _param="resourceids" id="principalIds"
          	 _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" type="hidden" name="principalIds" value="">
          	<!--button class=Browser id=SelectPrincipal onClick="onShowMultiHrmResource('principalIds','principalSpan',false)"></button> 
              <span  id=principalSpan name=principalSpan></span> 
              <input type=hidden name=principalIds id=principalIds-->
          </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(591,user.getLanguage())%></TD>
          <TD class=Field>
              <input class="wuiBrowser" type=hidden _displayTemplate="<A href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}'>#b{name}</A>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" name=Parent>

          </TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>      
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TD>
          <TD class=Field>
          <INPUT class=wuiBrowser _displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}'>#b{name}</a>" _url="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp" type=hidden name=Document></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr> 
		
		 <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6069,user.getLanguage())%></TD>
          <TD class=Field>
          <INPUT class=wuiBrowser _displayTemplate="<a href='/docs/docs/DocDsp.jsp?id=#b{id}'>#b{name}</a>" _url="/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp" type=hidden name=introductionDocid></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>  

	<%if(!user.getLogintype().equals("2")){%>
        <TR>
		  <TD><%=SystemEnv.getHtmlLabelName(120,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></TD>
		  <TD class=Field> <INPUT class=InputStyle maxLength=3 size=5 	name=seclevel onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("seclevel");checkinput("seclevel","seclevelimage")' value="0">
		   <SPAN id=seclevelimage></SPAN>
		  </TD>
	    </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>	
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

        <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colspan = 2><%=SystemEnv.getHtmlLabelName(15125,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing style="height: 1px">
          <TD class=Line1 colSpan=2></TD></TR>
<%if(!user.getLogintype().equals("2")){%>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6097,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=11 size=20 name="CreditAmount" onchange='checkinput("CreditAmount","CreditAmountimage");checkdecimal_length("CreditAmount",8)' onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("CreditAmount")' value = "<%=CreditAmount%>"><SPAN id=CreditAmountimage></SPAN></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6098,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=3 size=20 name="CreditTime" onchange='checkinput("CreditTime","CreditTimeimage")' onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("CreditTime")' value = "<%=CreditTime%>"><SPAN id=CreditTimeimage></SPAN></TD>
         </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>    

<%}else{%>
		<INPUT type=hidden class=InputStyle name="CreditAmount"  value = "<%=CreditAmount%>">
		<INPUT type=hidden class=InputStyle name="CreditTime"  value = "<%=CreditTime%>">
<%}%>
         <TR>
          <TD><%=SystemEnv.getHtmlLabelName(17084,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=200 size=20 name="bankname"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(571,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=50 size=20 name="accountname"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(17085,user.getLanguage())%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=200 size=20 name="accounts" onKeyPress="ItemCount_KeyPress()"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
    </TABLE>
	  <TABLE class=ViewForm>
        <COLGROUP>
		<COL width="30%">
  		<COL width="70%">
        <TBODY>
        <TR class=Title>
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(570,user.getLanguage())%></TH>
          </TR>
        <TR class=Spacing style="height: 1px">
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
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+11).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+10)%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=30 onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("nff0<%=i%>")' name="nff0<%=i%>" value="0.0" STYLE="width:95%"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
	for(int i=1;i<=5;i++)
	{
		if(RecordSetFF.getString(i*2+21).equals("1"))
		{%>
        <TR>
          <TD><%=RecordSetFF.getString(i*2+20)%></TD>
          <TD class=Field><INPUT class=InputStyle maxLength=100 name="tff0<%=i%>" STYLE="width:95%"></TD>
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
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
        </TR><tr style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}
	}
}
%>
        </TBODY>
	  </TABLE>	  

	</TD>
  </TR>
  </TBODY>
</TABLE>





<SCRIPT language="javascript"  type='text/javascript' src="/js/ArrayList_wev8.js"></SCRIPT>
<script type="text/javascript">
function onShowResource(inputname,spanname) {
    tmpids = document.all(inputname).value;
    if(tmpids!="-1"){ 
     url="/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids;
    }else{
     url="/hrm/resource/MutiResourceBrowser.jsp";
    }
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
    try {
        jsid = new VBArray(id).toArray();
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0" && jsid[1]!="") {
            document.all(spanname).innerHTML = jsid[1].substring(1);
            document.all(inputname).value = jsid[0].substring(1);
        } else {
            document.all(spanname).innerHTML = "";
            document.all(inputname).value = "";
        }
    }
}

var baseIndex = 5;
function addBaseInfoRow(){
	//var spaceRow = baseInfoTable.insertRow(); 
	//spaceRow.className="Line";  
	//var spaceCell = spaceRow.insertCell();
	//spaceCell.colSpan = 8;

	var oRow;      
	oRow = baseInfoTable.insertRow();     
    oRow.className="DataLight";  
    for (var i = 1; i <= 8; i++) {
    	oCell = oRow.insertCell();
 		oCell.align = "left";
        
    	var oDiv = document.createElement("div");
     	var sHtml=""; 
     	switch (i){               
        	case 1:  
            	//oCell.style.backgroundColor="#e7e7e7";
            	sHtml="<input type=\"checkbox\" id=\"baseCheck\"><input type=\"hidden\" name=\"baseIndex\" value=\""+baseIndex+"\" />"; 
            	break ;
             case 2:  	                    
                 sHtml="<input name=\"projectName"+baseIndex+"\" class=InputStyle style='width:98%' maxLength=50 />";                   
                 break ;
			 case 3:  	
                 sHtml="<select size=\"1\" name=\"hasBuild"+baseIndex+"\" class=InputStyle><option></option><option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option></select>";  
                 break ;
             case 4:  						
                 sHtml="<input name=\"company"+baseIndex+"\" class=InputStyle style='width:98%' maxLength=50 />"; 
                 break ;
             case 5:  						
                 sHtml="<input name=\"cost"+baseIndex+"\" class=InputStyle style='width:98%' maxLength=25 />"; 
                 break ;
             case 6:  						
                 sHtml="<input name=\"situation"+baseIndex+"\" class=InputStyle style='width:98%' maxLength=250 />"; 
                 break ;
             case 7:  						
                 sHtml="<input name=\"evaluate"+baseIndex+"\" class=InputStyle style='width:98%' maxLength=250 />"; 
                 break ;
             case 8:  						
                 sHtml="<select size=\"1\" name=\"ifPartners"+baseIndex+"\" class=InputStyle><option></option><option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option></select>";  
                 break ;
             default:
                 sHtml=" ";                
                 break ;
         }        
         oDiv.innerHTML = sHtml;
		 oCell.appendChild(oDiv);              
     }
     baseIndex++;
}

var demandIndex = 3;
function addDemandRow(){ 
	//var spaceRow = demandTable.insertRow(); 
	//spaceRow.className="Line";  
	//var spaceCell = spaceRow.insertCell();
	//spaceCell.colSpan = 4;

	var oRow;      
	oRow = demandTable.insertRow();     
    oRow.className="DataLight";  

        for (var i = 1; i <= 4; i++) {
            oCell = oRow.insertCell();
    		oCell.align = "left";
           
            var oDiv = document.createElement("div");
            var sHtml=""; 
            switch (i){               
               case 1:  
                    //oCell.style.backgroundColor="#e7e7e7";
                    sHtml="<input type=\"checkbox\" id=\"demandCheck\" value=''><input type=\"hidden\" name=\"demandIndex\" value=\""+demandIndex+"\" />"; 
                    break ;
                case 2:  	                    
                    sHtml="<input name=\"description"+demandIndex+"\" class=InputStyle style='width:98%' maxLength=250/>";                   
                    break ;
				case 3:  	
                 	sHtml="<select size=\"1\" name=\"ifKeydemand"+demandIndex+"\" class=InputStyle><option></option><option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option></select>";  
                    break ;
                case 4:  						
                 	sHtml="<select size=\"1\" name=\"ifHelpus"+demandIndex+"\" class=InputStyle><option></option><option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option></select>";  
                    break ;
                default:
                    sHtml=" ";                
                    break ;
            }        
            oDiv.innerHTML = sHtml;
			oCell.appendChild(oDiv);              
        }
        demandIndex++;
}

var importantIndex = 7;
function addImportantRow(){
	//var spaceRow = importantTable.insertRow(); 
	//spaceRow.className="Line";  
	//var spaceCell = spaceRow.insertCell();
	//spaceCell.colSpan = 9;

	var oRow;      
	oRow = importantTable.insertRow();     
    oRow.className="DataLight";  
    for (var i = 1; i <= 9; i++) {
    	oCell = oRow.insertCell();
 		oCell.align = "left";
        
    	var oDiv = document.createElement("div");
     	var sHtml=""; 
     	switch (i){               
        	case 1:  
            	//oCell.style.backgroundColor="#e7e7e7";
            	sHtml="<input type=\"checkbox\" id=\"importantCheck\"><input type=\"hidden\" name=\"importantIndex\" value=\""+importantIndex+"\" />"; 
            	break ;
             case 2:  	                    
                 sHtml="<input name=\"role"+importantIndex+"\" class=InputStyle style='width:98%' maxLength=50 />";                   
                 break ;
			 case 3:  	
                 sHtml="<input name=\"name"+importantIndex+"\" class=InputStyle style='width:98%' maxLength=50 />"; 
                 break ;
             case 4:  						
                 sHtml="<input name=\"department"+importantIndex+"\" class=InputStyle style='width:98%' maxLength=50 />"; 
                 break ;
             case 5:  						
                 sHtml="<input name=\"post"+importantIndex+"\" class=InputStyle style='width:98%' maxLength=50 />"; 
                 break ;
             case 6:  						
                 sHtml="<input name=\"telephone"+importantIndex+"\" class=InputStyle style='width:98%' maxLength=50 />"; 
                 break ;
             case 7:  						
                 sHtml="<input name=\"mobile"+importantIndex+"\" class=InputStyle style='width:98%' maxLength=50 />"; 
                 break ;
             case 8:  						
                 sHtml="<select size=\"1\" name=\"ifAgree"+importantIndex+"\" class=InputStyle><option></option><option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option><option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option></select>";  
                 break ;
             case 9:  						
                 sHtml="<input name=\"point"+importantIndex+"\" class=InputStyle style='width:98%' maxLength=50/>"; 
                 break ;
             default:
                 sHtml=" ";                
                 break ;
         }        
         oDiv.innerHTML = sHtml;
	     oCell.appendChild(oDiv);              
     }
     importantIndex++;
}

var competitorIndex = 3;
function addCompetitorRow(){ 
	//var spaceRow = competitorTable.insertRow(); 
	//spaceRow.className="Line";  
	//var spaceCell = spaceRow.insertCell();
	//spaceCell.colSpan = 4;

	var oRow;      
	oRow = competitorTable.insertRow();     
    oRow.className="DataLight";  

        for (var i = 1; i <= 4; i++) {
            oCell = oRow.insertCell();
    		oCell.align = "left";
           
            var oDiv = document.createElement("div");
            var sHtml=""; 
            switch (i){               
               case 1:  
                    //oCell.style.backgroundColor="#e7e7e7";
                    sHtml="<input type=\"checkbox\" id=\"competitorCheck\" value=''><input type=\"hidden\" name=\"competitorIndex\" value=\""+competitorIndex+"\" />"; 
                    break ;
                case 2:  	                    
                    sHtml="<input name=\"oppName"+competitorIndex+"\" class=InputStyle style='width:98%' maxLength=50/>";                   
                    break ;
				case 3:  	
                    sHtml="<input name=\"oppAdvantage"+competitorIndex+"\" class=InputStyle style='width:98%' maxLength=50/>";                   
                    break ;
                case 4:  						
                    sHtml="<input name=\"oppDisadvantage"+competitorIndex+"\" class=InputStyle style='width:98%' maxLength=50/>";                   
                    break ;
                default:
                    sHtml=" ";                
                    break ;
            }        
            oDiv.innerHTML = sHtml;
			oCell.appendChild(oDiv);              
        }
        competitorIndex++;
}


function deleteRow(tableId,rowId,chkAllObj){
		var message="确定要删除？";
        if(!confirm(message)) return  ;
        try { 
            var taskItems = document.getElementsByName(rowId);
			var delList = new ArrayList();
			var len = taskItems.length;
			for (var i=0;i<len;i++)	{
				if (taskItems[i].checked){
					document.getElementById(tableId).deleteRow(i+1);
					//document.getElementById(tableId).deleteRow(2*i+1);
					len=len-1;
					i=i-1;
				}		
			}
            document.getElementById(chkAllObj).checked = false ;
        } catch(ex){}
}

function onCheckAll(obj,checkId){
    var taskItems = document.getElementsByName(checkId);
    for (var i=0;i<taskItems.length;i++){
        taskItems[i].checked= obj.checked ;
    }
}

 function onHiddenImgClick(divObj,imgObj){
     if (imgObj.objStatus=="show"){
        divObj.style.display='none' ;       
        imgObj.src="/images/down_wev8.jpg";
		if(readCookie("languageidweaver")==8){
			imgObj.title="click then expand";
		}
		else if(readCookie("languageidweaver")==9){ 
			imgObj.title="點擊展開"; 
		}
		else {
			imgObj.title="点击展开";
		}	       
        imgObj.objStatus="hidden";
     } else {        
        divObj.style.display='' ;    
        imgObj.src="/images/up_wev8.jpg";
		if(readCookie("languageidweaver")==8){
			imgObj.title="click then hidden";
		}
		else if(readCookie("languageidweaver")==9){ 
			imgObj.title="點擊隱藏"; 
		}
		else {
			imgObj.title="点击隐藏";
		}        
        imgObj.objStatus="show";
     }
 }
 function onShowDiv(id){
		var spanId = id+"Span";
		if(document.getElementById(id).style.display == ""){
			document.getElementById(id).style.display = "none";
			document.all(spanId).outerHTML = "<span id='"+spanId+"' style='font-size: 10'>▲</span>";
		}else{
			document.getElementById(id).style.display = "";
			document.all(spanId).outerHTML = "<span id='"+spanId+"' style='font-size: 10'>▼</span>";
		}
}
</script>
<br>
<table class=ViewForm>
<!--
	<thead>  
		<tr class="title">
			<th>
				<a href="#" onclick="onShowDiv('divInfoList')" style="text-decoration: none;background-color: #E4E4E4;color: black">
					客户跟进关键信息表<span id="divInfoListSpan" style="font-size: 10">▼</span>
				</a>
			</th>
			 <th style="text-align:right">
				<img src="\images\up_wev8.jpg" style="cursor:hand" onclick="onHiddenImgClick(divInfoList,this)" title="<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%>" objStatus="show">
			</th> 
	    </tr>
		<tr class=spacing>
	        <td class=line1></td>
	    </tr>
		<tr class=spacing>
	        <td></td>
	    </tr>
		<tr class=spacing>
	        <td></td>
	    </tr>
		<tr class=spacing>
	        <td></td>
	    </tr>
	</thead>
-->
  <TBODY>
  <TR>
	<TD vAlign=top>
	<div id="divInfoList" style="display:none">
		<TABLE  CLASS="viewForm"  valign="top">
            <TR CLASS="title">
                <TH  WIDTH="80%" style="color: #003F7D">客户基础信息表</TH>
                <TD WIDTH="20%">
                    <div align="right">
                        <span id="divAddAndDel">
                            <a  style="cursor:hand" onclick="addBaseInfoRow()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>&nbsp;
                            <a  style="cursor:hand" onclick="deleteRow('baseInfoTable','baseCheck','baseChkAllObj')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>&nbsp;  
                        </span>
                    <div>
                </TD>
             </TR>
		    <TR style="height: 1px"><TD CLASS="line1" colspan="2"></TD></TR>                
		 </TABLE>
		<TABLE class=ViewForm>
			<TBODY>
				<TR>
					<td width="15%">客户方预算</td>
					<td class=Field width="35%">
						<select name="budget">
							<option value=""></option>
							<option value="10万以下">10万以下</option>
							<option value="10-20万">10-20万</option>
							<option value="20-30万">20-30万</option>
							<option value="30-50万">30-50万</option>
							<option value="50-100万">50-100万</option>
							<option value="100万以上">100万以上</option>
						</select>
					</td>
					<td width="2%"></td>
					<td  width="15%">客户希望上线时间</td>
					<TD class=Field width="35%">
						<BUTTON class=Calendar onclick="gettheDate('expectedDate','expectedDateSpan')"></BUTTON> 
					    <SPAN id="expectedDateSpan" ></SPAN> 
					    <input type="hidden" name="expectedDate" id="expectedDate">
					</TD>
				</TR>
			</TBODY>
		</TABLE>    
         <TABLE CLASS="ListStyle" valign="top" cellspacing=1 id="baseInfoTable">
             <colgroup>
             <col width="3%">
             <col width="15%">
             <col width="8%">
             <col width="15%">
             <col width="10%">
             <col width="15%">                       
             <col width="20%">                       
             <col width="14%">                       
             <TR class="Header">
             	 <TH><input type="checkbox" onclick="javaScript:onCheckAll(this,'baseCheck')" id="baseChkAllObj"></TH>
                 <TH>项目名称</TH>
                 <TH>是否建设</TH>
                 <TH>供应商厂商</TH>
                 <TH>投入费用</TH>
                 <TH>目前运行情况</TH>
                 <TH>客户方内部评价</TH>
                 <TH>是否是我们的合作伙伴</TH>
             </TR>
             <tr class="DataLight">
             	<td><input type="checkbox" id="baseCheck"></td>
             	<td>OA系统</td>
             	<input type="hidden" name="baseIndex" value="0" />
             	<input type="hidden" name="projectName0" value="OA系统" />
             	<td>
             		<select size="1" name="hasBuild0" class=InputStyle>
             			<option></option>
             			<option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
             			<option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
					</select>
             	</td>
             	<td><input name="company0" class=InputStyle style="width:98%" maxLength=50/></td>
             	<td><input name="cost0" class=InputStyle style="width:98%" maxLength=25/></td>
             	<td><input name="situation0" class=InputStyle style="width:98%" maxLength=250/></td>
             	<td><input name="evaluate0" class=InputStyle style="width:98%" maxLength=250/></td>
             	<td>
             		<select size="1" name="ifPartners0" class=InputStyle>
             			<option></option>
             			<option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
             			<option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
					</select>
             	</td>
             </tr>
             <tr class="DataLight">
             	<td><input type="checkbox" id="baseCheck"></td>
             	<td>ERP系统</td>
             	<input type="hidden" name="baseIndex" value="1" />
             	<input type="hidden" name="projectName1" value="ERP系统" />
             	<td>
             		<select size="1" name="hasBuild1" class=InputStyle>
             			<option></option>
             			<option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
             			<option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
					</select>
             	</td>
             	<td><input name="company1" class=InputStyle style="width:98%" maxLength=50/></td>
             	<td><input name="cost1" class=InputStyle style="width:98%" maxLength=25/></td>
             	<td><input name="situation1" class=InputStyle style="width:98%" maxLength=250/></td>
             	<td><input name="evaluate1" class=InputStyle style="width:98%" maxLength=250/></td>
             	<td>
             		<select size="1" name="ifPartners1" class=InputStyle>
             			<option></option>
             			<option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
             			<option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
					</select>
             	</td>
             </tr>                        
             <tr class="DataLight">
             	<td><input type="checkbox" id="baseCheck"></td>
             	<td>财务系统</td>
             	<input type="hidden" name="baseIndex" value="2" />
             	<input type="hidden" name="projectName2" value="财务系统" />
             	<td>
             		<select size="1" name="hasBuild2" class=InputStyle>
             			<option></option>
             			<option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
             			<option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
					</select>
             	</td>
             	<td><input name="company2" class=InputStyle style="width:98%" maxLength=50/></td>
             	<td><input name="cost2" class=InputStyle style="width:98%" maxLength=25/></td>
             	<td><input name="situation2" class=InputStyle style="width:98%" maxLength=250/></td>
             	<td><input name="evaluate2" class=InputStyle style="width:98%" maxLength=250/></td>
             	<td>
             		<select size="1" name="ifPartners0" class=InputStyle>
             			<option></option>
             			<option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
             			<option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
					</select>
             	</td>
             </tr>                        
             <tr class="DataLight">
             	<td><input type="checkbox" id="baseCheck"></td>
             	<td>HR系统</td>
             	<input type="hidden" name="baseIndex" value="3" />
             	<input type="hidden" name="projectName3" value="HR系统" />
             	<td>
             		<select size="1" name="hasBuild3" class=InputStyle>
             			<option></option>
             			<option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
             			<option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
					</select>
             	</td>
             	<td><input name="company3" class=InputStyle style="width:98%" maxLength=50/></td>
             	<td><input name="cost3" class=InputStyle style="width:98%" maxLength=25/></td>
             	<td><input name="situation3" class=InputStyle style="width:98%" maxLength=250/></td>
             	<td><input name="evaluate3" class=InputStyle style="width:98%" maxLength=250/></td>
             	<td>
             		<select size="1" name="ifPartners3" class=InputStyle>
             			<option></option>
             			<option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
             			<option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
					</select>
             	</td>
             </tr>                        
             <tr class="DataLight">
             	<td><input type="checkbox" id="baseCheck"></td>
             	<td>PDM系统</td>
             	<input type="hidden" name="baseIndex" value="4" />
             	<input type="hidden" name="projectName4" value="PDM系统" />
             	<td> 
             		<select size="1" name="hasBuild4" class=InputStyle>
             			<option></option>
             			<option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
             			<option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
					</select>
             	</td>
             	<td><input name="company4" class=InputStyle style="width:98%" maxLength=50/></td>
             	<td><input name="cost4" class=InputStyle style="width:98%" maxLength=25/></td>
             	<td><input name="situation4" class=InputStyle style="width:98%" maxLength=250/></td>
             	<td><input name="evaluate4" class=InputStyle style="width:98%" maxLength=250/></td>
             	<td>
             		<select size="1" name="ifPartners4" class=InputStyle>
             			<option></option>
             			<option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
             			<option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
					</select>
             	</td>
             </tr>                        
         </TABLE>
       <TABLE  CLASS="viewForm"  valign="top">
           <TR style="height: 1px"><TD CLASS="line1" colspan="2"></TD></TR>                
        </TABLE>
        <br/>
        <TABLE  CLASS="viewForm"  valign="top">
            <TR CLASS="title">
                <TH  WIDTH="80%" style="color: #003F7D">客户需求信息表</TH>
                <TD WIDTH="20%">
                    <div align="right">
                        <span id="divAddAndDel">
                            <a  style="cursor:hand" onclick="addDemandRow()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>&nbsp;
                            <a  style="cursor:hand" onclick="deleteRow('demandTable','demandCheck','demandChkAllObj')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>&nbsp;  
                        </span>
                    <div>
                </TD>
             </TR>
            <TR style="height: 1px">
            <TD CLASS="line1" colspan="2"></TD></TR>                
         </TABLE>
            <TABLE CLASS="ListStyle" valign="top" cellspacing=1 id="demandTable">
                <colgroup>
                <col width="3%">
                <col width="60%">
                <col width="16%">
                <col width="16%">                       
                <TR class="Header">
                    <TH><input type="checkbox" onclick="javaScript:onCheckAll(this,'demandCheck')" id="demandChkAllObj"></TH>
                    <TH>需求描述</TH>
                    <TH>是否为客户关键需求</TH>
                    <TH>是否对我们有利</TH>     
                </TR>
                <tr>
                	<td>
						<input type="checkbox" id="demandCheck" value=''><input type="hidden" name="demandIndex" value="0" />
	                </td>
	                <td> 
	                	<input name="description0" class=InputStyle style="width:98%" maxLength=250 value=""/>
	                </td>
	                <td>
	             		<select size="1" name="ifKeydemand0" class=InputStyle>
	             			<option></option>
	             			<option value=1>
	             				<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
	             			</option>
	             			<option value=0>
	             				<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
	             			</option>
						</select>
	                </td>
	                <td>
	             		<select size="1" name="ifHelpus0" class=InputStyle>
	             			<option></option>
	             			<option value=1>
	             				<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
	             			</option>
	             			<option value=0>
	             				<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
	             			</option>
						</select>
	                </td>
                </tr>
                <tr>
                	<td>
						<input type="checkbox" id="demandCheck" value=''><input type="hidden" name="demandIndex" value="1" />
	                </td>
	                <td> 
	                	<input name="description1" class=InputStyle style="width:98%" maxLength=250 value=""/>
	                </td>
	                <td>
	             		<select size="1" name="ifKeydemand1" class=InputStyle>
	             			<option></option>
	             			<option value=1>
	             				<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
	             			</option>
	             			<option value=0>
	             				<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
	             			</option>
						</select>
	                </td>
	                <td>
	             		<select size="1" name="ifHelpus1" class=InputStyle>
	             			<option></option>
	             			<option value=1>
	             				<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
	             			</option>
	             			<option value=0>
	             				<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
	             			</option>
						</select>
	                </td>
                </tr>
                <tr>
                	<td>
						<input type="checkbox" id="demandCheck" value=''><input type="hidden" name="demandIndex" value="2" />
	                </td>
	                <td> 
	                	<input name="description2" class=InputStyle style="width:98%" maxLength=250 value=""/>
	                </td>
	                <td>
	             		<select size="1" name="ifKeydemand2" class=InputStyle>
	             			<option></option>
	             			<option value=1>
	             				<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
	             			</option>
	             			<option value=0>
	             				<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
	             			</option>
						</select>
	                </td>
	                <td>
	             		<select size="1" name="ifHelpus2" class=InputStyle>
	             			<option></option>
	             			<option value=1>
	             				<%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%>
	             			</option>
	             			<option value=0>
	             				<%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
	             			</option>
						</select>
	                </td>
                </tr>
            </TABLE>
	       <TABLE  CLASS="viewForm"  valign="top">
	           <TR style="height: 1px"><TD CLASS="line1" colspan="2"></TD></TR>                
	        </TABLE>
        <br/>
        <TABLE  CLASS="viewForm"  valign="top">
            <TR CLASS="title">
                <TH  WIDTH="80%" style="color: #003F7D">关键人信息</TH>
                <TD WIDTH="20%">
                    <div align="right">
                        <span id="divAddAndDel">
                            <a  style="cursor:hand" onclick="addImportantRow()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>&nbsp;
                            <a  style="cursor:hand" onclick="deleteRow('importantTable','importantCheck','importantChkAllObj')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>&nbsp;  
                        </span>
                    <div>
                </TD>
             </TR>
            <TR style="height: 1px"><TD CLASS="line1" colspan="2"></TD></TR>                
         </TABLE>
            <TABLE CLASS="ListStyle" valign="top" cellspacing=1 id="importantTable">
                <colgroup>
                <col width="3%">
                <col width="15%">
                <col width="11%">
                <col width="12%">
                <col width="12%">
                <col width="11%">                       
                <col width="11%">                       
                <col width="10%">                       
                <col width="15%">                      
                <TR class="Header">
                    <TH><input type="checkbox" onclick="javaScript:onCheckAll(this,'importantCheck')" id="importantChkAllObj"></TH>
                    <TH>项目中的角色</TH>
                    <TH>人名</TH>
                    <TH>部门</TH>
                    <TH>职务</TH>
                    <TH>办公电话</TH>
                    <TH>手机</TH>
                    <TH>是否已加入我们</TH>
                    <TH>他们每一个人的关注点</TH>     
                </TR>
                <tr class="DataLight">
					<td><input type="checkbox" id="importantCheck"></td>                
                	<td>项目决策者</td>
	             	<input type="hidden" name="importantIndex" value="0" />
	             	<input type="hidden" name="role0" value="项目决策者" />
                	<td><input name="name0" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="department0" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="post0" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="telephone0" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="mobile0" class=InputStyle style="width:98%" maxLength=50/></td>
	                <td>
	             		<select size="1" name="ifAgree0" class=InputStyle>
	             			<option></option>
	             			<option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
	             			<option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
						</select>
	                </td>
                	<td><input name="point0" class=InputStyle style="width:98%" maxLength=50/></td>
                </tr>
                <tr class="DataLight">
					<td><input type="checkbox" id="importantCheck"></td>                
                	<td>项目负责人</td>
	             	<input type="hidden" name="importantIndex" value="1" />
	             	<input type="hidden" name="role1" value="项目负责人" />
                	<td><input name="name1" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="department1" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="post1" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="telephone1" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="mobile1" class=InputStyle style="width:98%" maxLength=50/></td>
	                <td>
	             		<select size="1" name="ifAgree01" class=InputStyle>
	             			<option></option>
	             			<option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
	             			<option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
						</select>
	                </td>
                	<td><input name="point1" class=InputStyle style="width:98%" maxLength=50/></td>
                </tr>                        
                <tr class="DataLight">
					<td><input type="checkbox" id="importantCheck"></td>                
                	<td>项目联系人</td>
	             	<input type="hidden" name="importantIndex" value="2" />
	             	<input type="hidden" name="role2" value="项目联系人" />
                	<td><input name="name2" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="department2" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="post2" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="telephone2" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="mobile2" class=InputStyle style="width:98%" maxLength=50/></td>
	                <td>
	             		<select size="1" name="ifAgree2" class=InputStyle>
	             			<option></option>
	             			<option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
	             			<option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
						</select>
	                </td>
                	<td><input name="point2" class=InputStyle style="width:98%" maxLength=50/></td>
                </tr>                        
                <tr class="DataLight">
					<td><input type="checkbox" id="importantCheck"></td>                
                	<td>会影响其他人的影响者</td>
	             	<input type="hidden" name="importantIndex" value="3" />
	             	<input type="hidden" name="role3" value="会影响其他人的影响者" />
                	<td><input name="name3" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="department3" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="post03" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="telephone3" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="mobile3" class=InputStyle style="width:98%" maxLength=50/></td>
	                <td>
	             		<select size="1" name="ifAgree3" class=InputStyle>
	             			<option></option>
	             			<option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
	             			<option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
						</select>
	                </td>
                	<td><input name="point3" class=InputStyle style="width:98%" maxLength=50/></td>
                </tr>                        
                <tr class="DataLight">
					<td><input type="checkbox" id="importantCheck"></td>                
                	<td>会反对竞争对手的反对者</td>
	             	<input type="hidden" name="importantIndex" value="4" />
	             	<input type="hidden" name="role4" value="会反对竞争对手的反对者" />
                	<td><input name="name4" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="department4" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="post4" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="telephone4" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="mobile4" class=InputStyle style="width:98%" maxLength=50/></td>
	                <td>
	             		<select size="1" name="ifAgree4" class=InputStyle>
	             			<option></option>
	             			<option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
	             			<option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
						</select>
	                </td>
                	<td><input name="point4" class=InputStyle style="width:98%" maxLength=50/></td>
                </tr>                        
                <tr class="DataLight">
					<td><input type="checkbox" id="importantCheck"></td>                
                	<td>会反对我们的反对者</td>
	             	<input type="hidden" name="importantIndex" value="5" />
	             	<input type="hidden" name="role5" value="会反对我们的反对者" />
                	<td><input name="name5" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="department5" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="post5" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="telephone5" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="mobile5" class=InputStyle style="width:98%" maxLength=50/></td>
	                <td>
	             		<select size="1" name="ifAgree5" class=InputStyle>
	             			<option></option>
	             			<option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
	             			<option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
						</select>
	                </td>
                	<td><input name="point5" class=InputStyle style="width:98%" maxLength=50/></td>
                </tr>                        
                <tr class="DataLight">
					<td><input type="checkbox" id="importantCheck"></td>                
                	<td>会支持我们的支持者</td>
	             	<input type="hidden" name="importantIndex" value="6" />
	             	<input type="hidden" name="role6" value="会支持我们的支持者" />
                	<td><input name="name6" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="department6" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="post6" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="telephone6" class=InputStyle style="width:98%" maxLength=50/></td>
                	<td><input name="mobile6" class=InputStyle style="width:98%" maxLength=50/></td>
	                <td>
	             		<select size="1" name="ifAgree6" class=InputStyle>
	             			<option></option>
	             			<option value=1><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
	             			<option value=0><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
						</select>
	                </td>
                	<td><input name="point6" class=InputStyle style="width:98%" maxLength=50/></td>
                </tr>                        
            </TABLE>
          <TABLE  CLASS="viewForm"  valign="top">
              <TR style="height: 1px"><TD CLASS="line1" colspan="2"></TD></TR>                
           </TABLE>
           <br/>
	       <TABLE  CLASS="viewForm"  valign="top">
	           <TR CLASS="title">
	               <TH  WIDTH="80%" style="color: #003F7D">竞争对手动态跟进</TH>
	               <TD WIDTH="20%">
	                   <div align="right">
	                       <span id="divAddAndDel">
	                           <a  style="cursor:hand" onclick="addCompetitorRow()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a>&nbsp;
	                           <a  style="cursor:hand" onclick="deleteRow('competitorTable','competitorCheck','competitorChkAllObj')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>&nbsp;  
	                       </span>
	                   <div>
	               </TD>
	            </TR>
	           <TR><TD CLASS="line1" colspan="2"></TD></TR>                
	        </TABLE>
	           <TABLE CLASS="ListStyle" valign="top" cellspacing=1 id="competitorTable" >
	               <colgroup>
	               <col width="3%">
	               <col width="18%">
	               <col width="39%">
	               <col width="40%">                       
	               <TR class="Header">
	                   <TH><input type="checkbox" onclick="javaScript:onCheckAll(this,'competitorCheck')" id="competitorChkAllObj"></TH>
	                   <TH>对手名称</TH>
	                   <TH>竞争对手优势</TH>
	                   <TH>竞争对手劣势</TH>     
	               </TR>
	                <tr>
	                	<td>
							<input type="checkbox" id="competitorCheck" value=''><input type="hidden" name="competitorIndex" value="0" />
		                </td>
		                <td>
		                	<input name="oppName0" class=InputStyle style="width:98%" maxLength=50 value=""/>
		                </td>
		                <td>
		                	<input name="oppAdvantage0" class=InputStyle style="width:98%" maxLength=50 value=""/>
		                </td>
		                <td>
		                	<input name="oppDisadvantage0" class=InputStyle style="width:98%" maxLength=50 value=""/>
		                </td>
	                </tr>   
	                <tr style="background-color: #e7e7e7">
	                	<td>
							<input type="checkbox" id="competitorCheck" value=''><input type="hidden" name="competitorIndex" value="1" />
		                </td>
		                <td>
		                	<input name="oppName1" class=InputStyle style="width:98%" maxLength=50 value=""/>
		                </td>
		                <td>
		                	<input name="oppAdvantage1" class=InputStyle style="width:98%" maxLength=50 value=""/>
		                </td>
		                <td>
		                	<input name="oppDisadvantage1" class=InputStyle style="width:98%" maxLength=50 value=""/>
		                </td>
	                </tr>   
	                <tr style="background-color: #e7e7e7">
	                	<td>
							<input type="checkbox" id="competitorCheck" value=''><input type="hidden" name="competitorIndex" value="2" />
		                </td>
		                <td>
		                	<input name="oppName2" class=InputStyle style="width:98%" maxLength=50 value=""/>
		                </td>
		                <td>
		                	<input name="oppAdvantage2" class=InputStyle style="width:98%" maxLength=50 value=""/>
		                </td>
		                <td>
		                	<input name="oppDisadvantage2" class=InputStyle style="width:98%" maxLength=50 value=""/>
		                </td>
	                </tr>   
	           </TABLE>
	         <TABLE  CLASS="viewForm"  valign="top">
	             <TR style="height: 1px"><TD CLASS="line1" colspan="2"></TD></TR>                
	          </TABLE>
	          <br/>
	      </div>    
	</TD>
</TR>
</TBODY>
</TABLE>
</FORM>
<script>
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function getCity(cityid){
  
    var ajax=ajaxinit();
	
    ajax.open("POST", "getCity.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("cityid="+cityid);
    //获取执行状态
    //alert(ajax.readyState);
	//alert(ajax.status);
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState==4&&ajax.status == 200) {
            try{
			var citynames=ajax.responseText;
			citynames=citynames.replace(/^\s*|\s*$/,'');
            cityidspan.innerHTML = citynames.substr(citynames.indexOf("----")+4);
            weaver.City.value=citynames.substr(0,citynames.indexOf("----"));
            }catch(e){}
      
        } 
    } 
}
//增加选择客户来源时如果为电话开拓，则开拓人员为必填，如果为代理商报备等，则中介机构为必填
function changeSource(){
	
	var value = $G("Source").value;
	if(value==1 || value==18){//电话开拓
		if($G("exploiterIds").value==""){
			$G("exploiterIdsSpan").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			jQuery("#exploiterIds").attr("_required","yes");
		}
	}else{
		if($G("exploiterIds").value==""){
			$G("exploiterIdsSpan").innerHTML="";
			jQuery("#exploiterIds").attr("_required","no");
		}
	}
	<%if(!user.getLogintype().equals("2")){%>
	if(value==22 || value==23 || value==24 || value==25 || value==26 || value==27){
		if($G("Agent").value==""){
			$G("AgentSpan").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			jQuery("#Agent").attr("_required","yes");
		}
	}else{
		if($G("Agent").value==""){
			$G("AgentSpan").innerHTML="";
			jQuery("#Agent").attr("_required","no");
		}
	}
	<%}%>
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
</BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<!-- added by cyril on 2008-06-12 for td8828-->
<script language=javascript src="/js/checkData_wev8.js"></script>
<!-- end by cyril on 2008-06-12 for td8828-->
</HTML>
