<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>

<% if(!(user.getLogintype()).equals("1")) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String id = Util.null2String(request.getParameter("id"));

RecordSet.executeProc("HrmResource_SelectByID",id);
RecordSet.next();
String lastname = Util.toScreenToEdit(RecordSet.getString("lastname"),user.getLanguage()) ;			/*姓*/
String sex = Util.toScreenToEdit(RecordSet.getString("sex"),user.getLanguage()) ;
/*
性别:
0:男性
1:女性
2:未知
*/
String birthday = Util.toScreenToEdit(RecordSet.getString("birthday"),user.getLanguage()) ;			/*生日*/
String birthplace = Util.toScreenToEdit(RecordSet.getString("birthplace"),user.getLanguage()) ;		/*出生地*/
String maritalstatus = Util.toScreenToEdit(RecordSet.getString("maritalstatus"),user.getLanguage()) ;
/*
婚姻状况:
0:未婚
1:已婚
2:离异
3:同居
*/
String homeaddress = Util.toScreenToEdit(RecordSet.getString("homeaddress"),user.getLanguage()) ;				/*家庭地址*/
String homepostcode = Util.toScreenToEdit(RecordSet.getString("homepostcode"),user.getLanguage()) ;				/*家庭邮编*/
String homephone = Util.toScreenToEdit(RecordSet.getString("homephone"),user.getLanguage()) ;				/*家庭电话*/
String residentplace = Util.toScreenToEdit(RecordSet.getString("residentplace"),user.getLanguage()) ;		/*现在地址*/
String residentpostcode = Util.toScreenToEdit(RecordSet.getString("residentpostcode"),user.getLanguage()) ;	/*现在邮编*/
String residentphone = Util.toScreenToEdit(RecordSet.getString("residentphone"),user.getLanguage()) ;		/*现在电话*/
String certificatenum = Util.toScreenToEdit(RecordSet.getString("certificatenum"),user.getLanguage()) ;			/*证件号码*/
String folk = Util.toScreenToEdit(RecordSet.getString("folk"),user.getLanguage()) ;				/*民族*/
String policy = Util.toScreenToEdit(RecordSet.getString("policy"),user.getLanguage()) ;							/*政治面貌*/
/*自定义字段*/
String textfield[] = new String[5] ;
for(int k=1 ; k<6;k++) textfield[k-1] = RecordSet.getString("textfield"+k) ;

String userid=""+user.getUID();

if(!userid.equals(id)&&!HrmUserVarify.checkUserRight("HrmResource:ViewAll",user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = lastname;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",/hrm/resource/HrmResource2.jsp?id="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/resource/HrmResource.jsp?id="+id+",_self} " ;
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

<TR><TD 
style="FONT-WEIGHT: bold; COLOR: red"></TD></TR>
<DIV class=Btnbar>
<!--
<BUTTON class=BtnEdit id=button1 accessKey=E 
onclick='location.href="HrmResourceEdit.jsp?id=<%=id%>"' 
name=button1><U>E</U>-<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></BUTTON>
<BUTTON class=Btn id=button1 
accessKey=W 
onclick='location.href="HrmResourceWorkResume.jsp?resourceid=<%=id%>"'
name=button1><U>W</U>-<%=SystemEnv.getHtmlLabelName(812,user.getLanguage())%></BUTTON>
<BUTTON class=Btn id=button1 
accessKey=D 
onclick='location.href="HrmResourceEducationInfo.jsp?resourceid=<%=id%>"'
name=button1><U>D</U>-<%=SystemEnv.getHtmlLabelName(1898,user.getLanguage())%></BUTTON>
<BUTTON class=Btn id=button1 
accessKey=F 
onclick='location.href="HrmResourceFamilyInfo.jsp?resourceid=<%=id%>"'
name=button1><U>F</U>-<%=SystemEnv.getHtmlLabelName(814,user.getLanguage())%></BUTTON>
<BUTTON class=Btn id=button1 
accessKey=R 
onclick='location.href="HrmResourceRewardsRecord.jsp?resourceid=<%=id%>"'
name=button1><U>R</U>-<%=SystemEnv.getHtmlLabelName(817,user.getLanguage())%></BUTTON>
<BUTTON class=Btn id=button1 
accessKey=O onclick='location.href="HrmResourceOtherInfo.jsp?resourceid=<%=id%>"' 
name=button1><U>O</U>-<%=SystemEnv.getHtmlLabelName(410,user.getLanguage())%></BUTTON>
<BUTTON class=Btn id=button1 
accessKey=Z onclick='location.href="HrmResourceCertification.jsp?resourceid=<%=id%>"' 
name=button1><U>Z</U>-<%=SystemEnv.getHtmlLabelName(1502,user.getLanguage())%></BUTTON>
<BUTTON class=Btn id=button1 
accessKey=J onclick='location.href="HrmResourceWorkResumeIn.jsp?resourceid=<%=id%>"' 
name=button1><U>J</U>-<%=SystemEnv.getHtmlLabelName(1503,user.getLanguage())%></BUTTON>
<BUTTON class=Btn id=button1 
accessKey=X onclick='location.href="HrmResourceWelfare.jsp?resourceid=<%=id%>"' 
name=button1><U>X</U>-<%=SystemEnv.getHtmlLabelName(1504,user.getLanguage())%></BUTTON>
<BUTTON class=Btn id=button1 
accessKey=A onclick='location.href="HrmResourceAbsense1.jsp?resourceid=<%=id%>"' 
name=button1><U>A</U>-<%=SystemEnv.getHtmlLabelName(1505,user.getLanguage())%></BUTTON>
-->
<INPUT id=BCValidate type=hidden value=0 
name=BCValidate>
<table class=viewForm>
  <tbody> 
  <tr> 
    <td valign=top> 
      <table width="100%">
        <colgroup> 
        <col width=10%> 
        <col width=23%> 
        <col width=10%> 
        <col width=23%> 
        <col width=10%> 
        <col width=24%>
        <tbody> 
        <tr class=title> 
          <th colspan=6><%=SystemEnv.getHtmlLabelName(411,user.getLanguage())%></th>
        </tr>
        <tr class=spacing> 
          <td class=line1 colspan=6></td>
        </tr>
        <tr> 
          <td><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td>
          <td class=Field> <%=lastname%></td>
          <td><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></td>
          <td class=Field> 
              <% if(sex.equals("0")) {%><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%><%}%>
              <% if(sex.equals("1")) {%><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%><%}%>
              <% if(sex.equals("2")) {%><%=SystemEnv.getHtmlLabelName(463,user.getLanguage())%><%}%>
          </td>
          <td><%=SystemEnv.getHtmlLabelName(1884,user.getLanguage())%></td>
          <td class=Field><%=birthday%></td>
        </tr>
        <TR><TD class=Line colSpan=6></TD></TR> 
        <tr> 
          <td><%=SystemEnv.getHtmlLabelName(1885,user.getLanguage())%></td>
          <td class=Field><%=birthplace%></td>
          <td><%=SystemEnv.getHtmlLabelName(1886,user.getLanguage())%></td>
          <td class=Field><%=folk%></td>
          <td><%=SystemEnv.getHtmlLabelName(469,user.getLanguage())%></td>
          <td class=Field> 
             <% if(maritalstatus.equals("0")) {%><%=SystemEnv.getHtmlLabelName(470,user.getLanguage())%><%}%>
             <% if(maritalstatus.equals("1")) {%><%=SystemEnv.getHtmlLabelName(471,user.getLanguage())%><%}%>
             <% if(maritalstatus.equals("2")) {%><%=SystemEnv.getHtmlLabelName(472,user.getLanguage())%><%}%>
             <% if(maritalstatus.equals("3")) {%><%=SystemEnv.getHtmlLabelName(473,user.getLanguage())%><%}%>
           </td>
        </tr>
         <TR><TD class=Line colSpan=6></TD></TR> 
         <tr> 
          <td><%=SystemEnv.getHtmlLabelName(1829,user.getLanguage())%></td>
          <td class=Field><%=residentplace%></td>
          <td><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></td>
          <td class=Field><%=residentphone%></td>
          <td><%=SystemEnv.getHtmlLabelName(1899,user.getLanguage())%></td>
          <td class=Field><%=residentpostcode%></td>
        </tr>
         <TR><TD class=Line colSpan=6></TD></TR> 
        <tr> 
          <td><%=SystemEnv.getHtmlLabelName(1900,user.getLanguage())%></td>
          <td class=Field><%=homeaddress%></td>
          <td><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></td>
          <td class=Field><%=homephone%></td>
          <td><%=SystemEnv.getHtmlLabelName(1899,user.getLanguage())%></td>
          <td class=Field><%=homepostcode%></td>
        </tr>
         <TR><TD class=Line colSpan=6></TD></TR> 
		<tr> 
          <td><%=SystemEnv.getHtmlLabelName(1887,user.getLanguage())%></td>
          <td class=Field colspan=3><%=certificatenum%></td>
          <td><%=SystemEnv.getHtmlLabelName(1901,user.getLanguage())%></td>
          <td class=Field><%=policy%></td>
        </tr>
        </tbody> 
      </table>
    </td>
  </tr>
  </tbody> 
</table>
<TABLE class=ListStyle cellspacing=1>
  <TBODY> 
  <TR class=Header> 
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(1902,user.getLanguage())%></TH>
  </TR>
   <TR class=Header> 
    <TD width="20%"><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
    <TD width="40%"><%=SystemEnv.getHtmlLabelName(1903,user.getLanguage())%></TD>  
	<TD width="20%"><%=SystemEnv.getHtmlLabelName(1904,user.getLanguage())%></TD>
	<TD width="20%"><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></TD>
  </TR>
  <TR class=Line><TD colspan="4" ></TD></TR> 
<%
int i=0;
RecordSet.executeProc("HrmEducationInfo_SByResourceID",id);

while(RecordSet.next()){
String startdate = RecordSet.getString("startdate");
String enddate = RecordSet.getString("enddate");
String school = RecordSet.getString("school");
String speciality = RecordSet.getString("speciality");
String educationlevel = RecordSet.getString("educationlevel");
if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%
}
%>
	<td><%=Util.toScreen(startdate,user.getLanguage())%>-<%=Util.toScreen(enddate,user.getLanguage())%></td>
    <td><%=Util.toScreen(school,user.getLanguage())%></td>
    <td><%=Util.toScreen(speciality,user.getLanguage())%></td>
    <td>
	 <%if (educationlevel.equals("0")) {%><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%><%}%>
     <%if (educationlevel.equals("1")) {%><%=SystemEnv.getHtmlLabelName(819,user.getLanguage())%><%}%>
	 <%if (educationlevel.equals("2")) {%><%=SystemEnv.getHtmlLabelName(764,user.getLanguage())%><%}%>
     <%if (educationlevel.equals("3")) {%><%=SystemEnv.getHtmlLabelName(820,user.getLanguage())%><%}%>
     <%if (educationlevel.equals("4")) {%><%=SystemEnv.getHtmlLabelName(765,user.getLanguage())%><%}%>
     <%if (educationlevel.equals("5")) {%><%=SystemEnv.getHtmlLabelName(766,user.getLanguage())%><%}%>
     <%if (educationlevel.equals("6")) {%><%=SystemEnv.getHtmlLabelName(767,user.getLanguage())%><%}%>
     <%if (educationlevel.equals("7")) {%><%=SystemEnv.getHtmlLabelName(768,user.getLanguage())%><%}%>
     <%if (educationlevel.equals("8")) {%><%=SystemEnv.getHtmlLabelName(769,user.getLanguage())%><%}%>
	</td>
</TR>
<%}
%>
  </TBODY> 
</TABLE>
<TABLE class=ListStyle cellspacing=1>
  <TBODY> 
  <TR class=Header> 
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(1502,user.getLanguage())%></TH>
  </TR>
   <TR class=Header> 
    <TD width="20%"><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
    <TD width="40%"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
    <TD width="40%"><%=SystemEnv.getHtmlLabelName(1905,user.getLanguage())%></TD>
  </TR>
   <TR class=Line><TD colspan="3" ></TD></TR> 
<%
RecordSet.executeProc("HrmCertification_SByResource",id);
i=0;
while(RecordSet.next()){
String datefrom = RecordSet.getString("datefrom");
String dateto = RecordSet.getString("dateto");
String certname = RecordSet.getString("certname");
String awardfrom = RecordSet.getString("awardfrom");
if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%
}
%>
	<td>
	<%=Util.toScreen(datefrom,user.getLanguage())%>-<%=Util.toScreen(dateto,user.getLanguage())%>
	</td>
    <td><%=Util.toScreen(certname,user.getLanguage())%></td>
    <td><%=Util.toScreen(awardfrom,user.getLanguage())%></td>
</TR>
<%}
%>
  </TBODY> 
</TABLE>
<TABLE class=ListStyle cellspacing=1>
  <TBODY> 
  <TR class=header> 
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(1906,user.getLanguage())%></TH>
    </TR>
  <TR class=Header> 
    <TD width="20%"><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
    <TD width="40%"><%=SystemEnv.getHtmlLabelName(1851,user.getLanguage())%></TD>
	<TD width="40%"><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></TD>
  </TR>
   <TR class=Line><TD colspan="3" ></TD></TR> 
<%
RecordSet.executeProc("HrmWorkResume_SByResourceID",id);
i=0;
while(RecordSet.next()){
String startdate = RecordSet.getString("startdate");
String enddate = RecordSet.getString("enddate");
String company = RecordSet.getString("company");
String jobtitle = RecordSet.getString("jobtitle");
if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%
}
%>
	<td><%=Util.toScreen(startdate,user.getLanguage())%>-<%=Util.toScreen(enddate,user.getLanguage())%></td>
    <td><%=Util.toScreen(company,user.getLanguage())%></td>
    <td><%=Util.toScreen(jobtitle,user.getLanguage())%></td>
</TR>
<%}
%>
  </TBODY> 
</TABLE>
<TABLE class=ListStyle cellspacing=1>
  <TBODY> 
  <TR class=header> 
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(1907,user.getLanguage())%></TH>
  </TR>
    <TR class=Header> 
    <TD width="20%"><%=SystemEnv.getHtmlLabelName(1908,user.getLanguage())%></TD>
    <TD width="20%"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
    <TD width="20%"><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%></TD>
    <TD width="40%"><%=SystemEnv.getHtmlLabelName(1909,user.getLanguage())%></TD>
  </TR>
   <TR class=Line><TD colspan="4" ></TD></TR> 
<%
i=0;
RecordSet.executeProc("HrmWorkResumeIn_SByResourceID",id);

while(RecordSet.next()){
String datefrom = RecordSet.getString("datefrom");
String dateto = RecordSet.getString("dateto");
String departmentid = RecordSet.getString("departmentid");
String jobtitle = RecordSet.getString("jobtitle");
String joblevel = RecordSet.getString("joblevel");
if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%
}
%>
	<td>
	<%=Util.toScreen(datefrom,user.getLanguage())%>-<%=Util.toScreen(dateto,user.getLanguage())%>
	</td>
    <td><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></td>
    <td><%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitle),user.getLanguage())%></td>
    <td><%=joblevel%></td>
</TR>
<%}
%>
  </TBODY> 
</TABLE>
</form>
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
</HTML>