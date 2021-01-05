
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CareerInviteComInfo" class="weaver.hrm.career.CareerInviteComInfo" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="HrmCareerApplyComInfo" class="weaver.hrm.career.HrmCareerApplyComInfo" scope="session"/>
<jsp:useBean id="EduLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="session" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%String method=Util.null2String(request.getParameter("method"));
if(method.equals("empty"))
{
	HrmCareerApplyComInfo.resetSearchInfo();//清空数据
}
%>
<%
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+" : "+SystemEnv.getHtmlLabelName(16251,user.getLanguage());
String needfav ="1";
String needhelp ="";
String subCompanyId = "";
if(detachable==1){
	subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
	if(subCompanyId ==null || subCompanyId.equals("")){
		subCompanyId =HrmCareerApplyComInfo.getSubCompanyId();
	}
}
if(subCompanyId.equals("") && detachable==1 && method.equals(""))
{
   String s="<TABLE class=viewform><colgroup><col width='10'><col width=''><TR class=Title><TH colspan='2'>"+SystemEnv.getHtmlLabelName(19010,user.getLanguage())+"</TH></TR><TR class=spacing><TD class=line1 colspan='2'></TD></TR><TR><TD></TD><TD><li>";
    if(user.getLanguage()==8){s+="click left subcompanys tree,set the subcompany's salary item</li></TD></TR></TABLE>";}
    else{s+=""+SystemEnv.getHtmlLabelName(21921,user.getLanguage())+"</li></TD></TR></TABLE>";}
    out.println(s);
    return;
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(HrmUserVarify.checkUserRight("HrmCareerApplyAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/career/HrmCareerApplyAdd.jsp?subCompanyId="+subCompanyId+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(589,user.getLanguage())+",/hrm/career/HrmCareerApply.jsp?method="+"empty"+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(366,user.getLanguage())+",/hrm/career/HrmCareerInvite.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(HrmUserVarify.checkUserRight("HrmCareerApplyAdd:Add", user)){
    if(RecordSet.getDBType().equals("db2")){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where int(operateitem) ="+59+",_self} " ;
        
    }
    else{
        RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem ="+59+",_self} " ;
        
    }
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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
<DIV>
<FORM NAME=frmain action="HrmCareerApplyOperation1.jsp" method=post>
<input class=inputstyle type=hidden name=subCompanyId value="<%=subCompanyId%>">
<TABLE class=ViewForm>
    <COLGROUP> 
    <col width="20%"> 
    <col width="30%"> 
    <col width="20%"> 
    <col width="30%"> 
    <tbody> 
    <tr> 
      <th align=left colspan=6><%=SystemEnv.getHtmlLabelName(1869,user.getLanguage())%></th>
    </tr>
    <tr class=Spacing style="height:2px"> 
      <td class=Line1 colspan=6></td>
    </tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td>
      <TD class=Field ><INPUT class=inputstyle maxlength=10 size=10 name="Name"  value="<%=HrmCareerApplyComInfo.getName()%>">
      </TD> 
      <TD><%=SystemEnv.getHtmlLabelName(366,user.getLanguage())%></TD>
      <TD class=Field>

          <input class="wuiBrowser" id=careerinvite type=hidden name=careerinvite value=""
		  _url="/systeminfo/BrowserMain.jsp?url=/hrm/career/CareerInviteBrowser.jsp">              
      </TD>
   </tr>
   <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
   <tr>
   <td><%=SystemEnv.getHtmlLabelName(15671,user.getLanguage())%></td>
      <td class=field>     
 
        <INPUT class="wuiBrowser" id=jobtitle type=hidden name=jobtitle value="<%=HrmCareerApplyComInfo.getJobTitle()%>"
		_url="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp"
		_displayText="<%=JobTitlesComInfo.getJobTitlesname(HrmCareerApplyComInfo.getJobTitle())%>">     
     </td>
     <td><%=SystemEnv.getHtmlLabelName(1855,user.getLanguage())%></td>
     <td class=field>
       <BUTTON class=calendar type="button" id=SelectDate onclick=getfromDate()></BUTTON>
       <SPAN id=fromdatespan style="FONT-SIZE: x-small"><%=HrmCareerApplyComInfo.getFromDate()%></SPAN>
       <input type="hidden" name="FromDate" value=<%=HrmCareerApplyComInfo.getFromDate()%>>－<BUTTON class=calendar type="button" id=SelectDate onclick=getendDate()></BUTTON>
       <SPAN id=enddatespan style="FONT-SIZE: x-small"><%=HrmCareerApplyComInfo.getEndDate()%></SPAN>
       <input type="hidden" name="EndDate" value=<%=HrmCareerApplyComInfo.getEndDate()%>>  
     </td>  
   </tr>
   <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
   <tr>
     <td><%=SystemEnv.getHtmlLabelName(671,user.getLanguage())%></td>
     <td class=Field> 
       <input class=inputstyle maxlength=10 size=5 name=CareerAgeFrom onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=HrmCareerApplyComInfo.getAgeFrom()==0?"":HrmCareerApplyComInfo.getAgeFrom()+""%>">-
       <input class=inputstyle maxlength=10  size=5 name=CareerAgeTo onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=HrmCareerApplyComInfo.getAgeTo()==0?"":HrmCareerApplyComInfo.getAgeTo()+""%>">
     </td>
     <td><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></td>
     <TD class=field>

      <INPUT class="wuiBrowser" type=hidden name=EducationLevel 
	  _url="/systeminfo/BrowserMain.jsp?url=/hrm/educationlevel/EduLevelBrowser.jsp"
	  _displayText="<%=EduLevelComInfo.getEducationLevelname(HrmCareerApplyComInfo.getEducationLevel())%>">
     </TD>  
   </tr>
   <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
   <tr>
     <TD><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></TD>
     <TD class=Field> 
       <select class=inputstyle id=Sex name=Sex>  
         <option value=0 selected><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%></option>
         <option value=1 selected><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%></option>         
         <option value="" selected></option>
       </select>
     </TD>
     <td><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></td>
     <td class=Field> 
       <select class=inputstyle id=Category name=Category>		    
         <option value="0" selected><%=SystemEnv.getHtmlLabelName(134,user.getLanguage())%></option>
         <option value="1" selected><%=SystemEnv.getHtmlLabelName(1830,user.getLanguage())%></option>
         <option value="2" selected><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%></option>
         <option value="3" selected><%=SystemEnv.getHtmlLabelName(1832,user.getLanguage())%></option>
	 <option value="" selected></option>
       </select>
     </td>
   </tr>
   <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
   <tr>
     <TD><%=SystemEnv.getHtmlLabelName(469,user.getLanguage())%></TD>
     <TD class=Field> 
       <SELECT class=inputstyle id=MaritalStatus name=MaritalStatus>			   
         <OPTION value=0 selected><%=SystemEnv.getHtmlLabelName(470,user.getLanguage())%></OPTION>
         <OPTION value=1 selected><%=SystemEnv.getHtmlLabelName(471,user.getLanguage())%></OPTION>
         <OPTION value=2 selected><%=SystemEnv.getHtmlLabelName(472,user.getLanguage())%> </OPTION>
 <!--        <OPTION value=3 selected><%=SystemEnv.getHtmlLabelName(473,user.getLanguage())%></OPTION>-->
         <OPTION value=""selected></OPTION>			   
       </SELECT>
     </TD>
     <td><%=SystemEnv.getHtmlLabelName(1843,user.getLanguage())%></td>
     <td class=Field> 
       <input class=inputstyle maxlength=10 size=7 name=SalaryNowFrom onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=HrmCareerApplyComInfo.getSalaryNowFrom()%>">-
       <input class=inputstyle maxlength=10  size=7 name=SalaryNowTo onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=HrmCareerApplyComInfo.getSalaryNowTo()%>">
     </td>     
   </tr>
   <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
   <tr>
     <td><%=SystemEnv.getHtmlLabelName(1828,user.getLanguage())%></td>
     <td class=Field> 
      <input class=inputstyle maxlength=25 size=25 name=RegResidentPlace value="<%=HrmCareerApplyComInfo.getRegResidentPlace()%>">
     </td>   
     <td><%=SystemEnv.getHtmlLabelName(1844,user.getLanguage())%></td>
     <td class=Field> 
      <input class=inputstyle maxlength=10 size=5 name=WorkTimeFrom onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("WorkTimeFrom")' value="<%=HrmCareerApplyComInfo.getWorkTimeFrom()%>">-<input class=inputstyle       maxlength=10  size=5 name=WorkTimeTo onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("WorkTimeTo")' value="<%=HrmCareerApplyComInfo.getWorkTimeTo()%>"> 
     </td>
   </tr>
   <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
   <tr>
     <TD><%=SystemEnv.getHtmlLabelName(803,user.getLanguage())%></TD>
     <TD class=Field>
       <input class=inputstyle maxlength=15 size=15 name=Major value="<%=HrmCareerApplyComInfo.getMajor()%>">
     </TD>
     <td><%=SystemEnv.getHtmlLabelName(1845,user.getLanguage())%></td>
     <td class=Field>
       <input class=inputstyle maxlength=10 size=5 name=SalaryNeedFrom onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=HrmCareerApplyComInfo.getSalaryNeedFrom()%>">-
       <input class=inputstyle maxlength=10  size=5 name=SalaryNeedTo onKeyPress="ItemCount_KeyPress()" onBlur='checknumber1(this)' value="<%=HrmCareerApplyComInfo.getSalaryNeedTo()%>">
     </td>
   </tr> 
   <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
   <tr>
     <td><%=SystemEnv.getHtmlLabelName(17370,user.getLanguage())%></td>
     <td class=Field> <input class=inputstyle maxlength=25 size=25 name=oldjob value="<%=HrmCareerApplyComInfo.getOldJob()%>">
     </td>   
     <td></td>
   </tr>
   <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 


<tr> 
    <th align=left colspan=6><%=SystemEnv.getHtmlLabelName(1889,user.getLanguage())%></th>
</tr>
 <TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
<tr>   
      <TD><%=SystemEnv.getHtmlLabelName(1833,user.getLanguage())%></TD>
      <TD class=Field>
      <input class=inputstyle maxlength=25 size=25 name=Degree value="<%=HrmCareerApplyComInfo.getDegree()%>">
	  <TD><%=SystemEnv.getHtmlLabelName(1870,user.getLanguage())%></TD>
      <TD class=Field>
      <input class=inputstyle maxlength=25 size=25 name=School value="<%=HrmCareerApplyComInfo.getSchool()%>">
	  </TD>
</tr>
<TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
<tr>
      <TD><%=SystemEnv.getHtmlLabelName(1871,user.getLanguage())%></TD>
      <TD class=Field>
      <input class=inputstyle maxlength=25 size=25 name=Company value="<%=HrmCareerApplyComInfo.getCompany()%>">
	  </TD>      
    <TD><%=SystemEnv.getHtmlLabelName(1837,user.getLanguage())%></TD>
      <TD class=Field>
      <input class=inputstyle maxlength=25 size=25 name=Policy >
	</TD>
</tr>
<TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
<tr>
    <TD><%=SystemEnv.getHtmlLabelName(1840,user.getLanguage())%></TD>
      <TD class=Field>
      <input class=inputstyle maxlength=25 size=25 name=NativePlace value="<%=HrmCareerApplyComInfo.getNativePlace()%>">
	  </TD>
	  <TD><%=SystemEnv.getHtmlLabelName(1829,user.getLanguage())%></TD>
      <TD class=Field>
      <input class=inputstyle maxlength=25 size=25 name=ResidentPlace value="<%=HrmCareerApplyComInfo.getResidentPlace()%>">
	 </TD>
</tr>
<TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
<tr>
<!--      <TD>国籍</TD>
            <TD class=Field><BUTTON class=Browser id=SelectNationality onclick="onShowNationality()"></BUTTON> 
             <SPAN class=inputstyle id=nationalityspan>
			 <%=CountryComInfo.getCountrydesc(HrmCareerApplyComInfo.getNationality())%></SPAN> 
             <INPUT class=inputstyle id=nationality type=hidden name=Nationality value="<%=HrmCareerApplyComInfo.getNationality()%>">
            </TD>
-->        
          <td><%=SystemEnv.getHtmlLabelName(15674,user.getLanguage())%></td>
    <td class=Field> 
    <input class=inputstyle maxlength=10  size=5 name=WeightFrom onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("WeightFrom")'  value="<%=HrmCareerApplyComInfo.getWeightFrom()%>">-
    <input class=inputstyle maxlength=10 size=5 name=WeightTo	onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("WeightTo")' value="<%=HrmCareerApplyComInfo.getWeightTo()%>">
    </td>    
	  <td><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></td>
            <td class=Field>
              <input class=inputstyle id=DefaultLanguage type=text name=DefaultLanguage  value="<%=HrmCareerApplyComInfo.getDefaultLanguage()%>">
            </td>
</tr>
<TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
<tr>
	  <TD><%=SystemEnv.getHtmlLabelName(1502,user.getLanguage())%></TD>
      <TD class=Field>
      <input class=inputstyle maxlength=30 size=30 name=Train value="<%=HrmCareerApplyComInfo.getTrain()%>">
	 </TD>

	  <td><%=SystemEnv.getHtmlLabelName(1826,user.getLanguage())%></td>
    <td class=Field> 
    <input class=inputstyle maxlength=10  size=5 name=HeightFrom onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("HeightFrom")'  value="<%=HrmCareerApplyComInfo.getHeightFrom()%>">-<input class=inputstyle maxlength=10 size=5 name=HeightTo
	onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("HeightTo")' value="<%=HrmCareerApplyComInfo.getHeightTo()%>">
    </td>
</tr>
<TR style="height:1px"><TD class=Line colSpan=6></TD></TR> 
 </TABLE>
 </FORM>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>

<SCRIPT language="javascript">
function OnSubmit(){
		document.frmain.submit();
}
function submitData() {
 frmain.submit();
}
</script>
<script language=vbs>
sub onShowNationality()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/country/CountryBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	nationalityspan.innerHtml = id(1)
	frmain.nationality.value=id(0)
	else 
	nationalityspan.innerHtml = ""
	frmain.nationality.value=""//vlale为空
	end if
	end if
end sub

sub onShowDefaultLanguage()
	id = window.showModalDialog("/systeminfo/language/LanguageBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	defaultlanguagespan.innerHtml = id(1)
	frmain.defaultlanguage.value=id(0)
	else
	defaultlanguagespan.innerHtml = ""
	frmain.defaultlanguage.value=""
	end if
	end if
end sub

sub onShowJobtitle()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	jobtitlespan.innerHtml = id(1)
	frmain.jobtitle.value=id(0)
	else 
	jobtitlespan.innerHtml = ""
	frmain.jobtitle.value=""
	end if
	end if
end sub  
sub onShowEduLevel(inputspan,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/educationlevel/EduLevelBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	inputspan.innerHtml = id(1)
	inputname.value=id(0)
	else 
	inputspan.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub

sub onShowCareerInvite(spanname, inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/career/CareerInviteBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	//careerinvitespan.innerHtml = id(3)
	inputname.value=id(0)
	spanname.innerHtml = id(1)
	else 
	inputname.value=""
	spanname.innerHtml = ""
	end if
	end if	
end sub

</script>
 </BODY>
 <SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
 </HTML>