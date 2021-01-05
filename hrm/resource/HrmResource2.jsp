<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="RewardsTypeComInfo" class="weaver.hrm.tools.RewardsTypeComInfo" scope="page"/>

<% if(!(user.getLogintype()).equals("1")) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
char separator = Util.getSeparator() ;

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
<BUTTON class=Btn id=button1 
accessKey=P onclick='location.href="HrmResource1.jsp?id=<%=id%>"' 
name=button1><U>P</U>-<%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></BUTTON>
<BUTTON class=Btn id=button1 
accessKey=R onclick='location.href="HrmResource.jsp?id=<%=id%>"' 
name=button1><U>R</U>-<%=SystemEnv.getHtmlLabelName(1290, user.getLanguage())%></BUTTON>
</DIV>
<INPUT id=BCValidate type=hidden value=0 
name=BCValidate>
<table class=Form>
    <tbody> 
    <tr> 
      <td valign=top> 
        <table width="100%">
          <colgroup> <col width=10%> <col width=23%> <col width=10%> <col width=23%> 
          <col width=10%> <col width=24%><tbody> 
        <TR class=Separator> 
    <TD class=Sep1 colSpan=4></TD>
  </TR>    
		  <%
boolean hasFF = true;
RecordSet.executeProc("Base_FreeField_Select","hr");
if(RecordSet.getCounts()<=0)
	hasFF = false;
else
	RecordSet.first();
	
if(hasFF)
{
    %>
	<TR>
    <%
	int i =1;
	if(RecordSet.getString(i*2+21).equals("1")) {
		 %>
       
          <TD><%=Util.toScreen(RecordSet.getString(i*2+20),user.getLanguage())%></TD>
          <TD class=Field >
		  <%=Util.toScreen(textfield[i-1],user.getLanguage())%>
		  </TD>
        
		<%}
	i=2;
	if(RecordSet.getString(i*2+21).equals("1")) {
		 %>
       
          <TD><%=Util.toScreen(RecordSet.getString(i*2+20),user.getLanguage())%></TD>
          <TD class=Field>
		 <%=Util.toScreen(textfield[i-1],user.getLanguage())%>
		  </TD>
        
		<%}
	
    %>
	</TR>
    <%
}
%>
 <TR class=Section> 
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(1910,user.getLanguage())%></TH>
  </TR>
  <TR class=Separator> 
    <TD class=Sep1 colSpan=4></TD>
  </TR>
  <%
RecordSet.executeProc("HrmResourceOtherInfo_SByType",id+separator+"1");

while(RecordSet.next()){
String inforemark = RecordSet.getString("inforemark");
%>
<TR>
	<td ><%=Util.toScreen(inforemark,user.getLanguage())%></td>
 </TR>
<%}
%>
  
 <TR class=Section> 
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(1911,user.getLanguage())%></TH>
  </TR>
  <TR class=Separator> 
    <TD class=Sep1 colSpan=4></TD>
  </TR>
    <%
RecordSet.executeProc("HrmResourceOtherInfo_SByType",id+separator+"2");

while(RecordSet.next()){
String inforemark = RecordSet.getString("inforemark");
%>
<TR>
	<td ><%=Util.toScreen(inforemark,user.getLanguage())%></td>
 </TR>
<%}
%>
     </tbody> 
        </table>
      
	  </td>
    </tr>
    </tbody> 
 </table>
 <TABLE class=ListShort>
  <TBODY> 
  <TR class=Section> 
    <TH colSpan=5><%=SystemEnv.getHtmlLabelName(1912,user.getLanguage())%></TH>
  </TR>
  <TR class=Separator> 
    <TD class=Sep1 colSpan=5></TD>
  </TR>
  <TR class=Header> 
    <TD width="20%"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
    <TD width="10%"><%=SystemEnv.getHtmlLabelName(1913,user.getLanguage())%></TD>
    <TD width="30%"><%=SystemEnv.getHtmlLabelName(1914,user.getLanguage())%></TD>
	<TD width="20%"><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></TD>
	<TD width="20%"><%=SystemEnv.getHtmlLabelName(1916,user.getLanguage())%></TD>
  </TR>
<%
int i=0;
RecordSet.executeProc("HrmFamilyInfo_SbyResourceID",id);

while(RecordSet.next()){
String member = RecordSet.getString("member");
String title = RecordSet.getString("title");
String company = RecordSet.getString("company");
String jobtitle = RecordSet.getString("jobtitle");
String address = RecordSet.getString("address");
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
	<td><%=Util.toScreen(member,user.getLanguage())%></td>
    <td><%=Util.toScreen(title,user.getLanguage())%></td>
    <td><%=Util.toScreen(company,user.getLanguage())%></td>
    <td><%=Util.toScreen(jobtitle,user.getLanguage())%></td>
	<td><%=Util.toScreen(address,user.getLanguage())%></td>
</TR>
<%}
%>
  </TBODY> 
</TABLE>
<TABLE class=ListShort>
  <TBODY> 
  <TR class=Section> 
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(1917,user.getLanguage())%></TH>
  </TR>
  <TR class=Separator> 
    <TD class=Sep1 colSpan=3></TD>
  </TR>
  <TR class=Header> 
    <TD width="20%"><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TD>
    <TD width="40%"><%=SystemEnv.getHtmlLabelName(341,user.getLanguage())%></TD>
	<TD width="40%"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TD>
  </TR>
<%
RecordSet.executeProc("HrmRewardsRecord_SByResourceID",id);
i=0;
while(RecordSet.next()){
String rewardsdate = RecordSet.getString("rewardsdate");
String rewardstype = RecordSet.getString("rewardstype");
String remark = RecordSet.getString("remark");
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
	<td><%=Util.toScreen(rewardsdate,user.getLanguage())%></td>
    <td> <%=Util.toScreen(RewardsTypeComInfo.getRewardsTypename(rewardstype),user.getLanguage())%></td>
	<td><%=Util.toScreen(remark,user.getLanguage())%></td>
 </TR>
<%}
%>
  </TBODY> 
</TABLE>
<TABLE class=ListShort>
  <TBODY> 
  <TR class=Section> 
    <TH colSpan=7><%=SystemEnv.getHtmlLabelName(1918,user.getLanguage())%></TH>
  </TR>
  <TR class=Separator> 
    <TD class=Sep1 colSpan=7></TD>
  </TR>
  <TR class=Header> 
    <TD width="20%"><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
    <TD width="8%"><%=SystemEnv.getHtmlLabelName(1893,user.getLanguage())%></TD>
    <TD width="8%"><%=SystemEnv.getHtmlLabelName(1894,user.getLanguage())%></TD>
    <TD width="8%"><%=SystemEnv.getHtmlLabelName(1895,user.getLanguage())%></TD>
    <TD width="8%"><%=SystemEnv.getHtmlLabelName(1896,user.getLanguage())%></TD>
    <TD width="8%"><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></TD>
    <TD width="40%"><%=SystemEnv.getHtmlLabelName(1897,user.getLanguage())%></TD>
  </TR>
<%
i=0;
RecordSet.executeProc("HrmWelfare_SelectByResourceId",id);

while(RecordSet.next()){
String datefrom = RecordSet.getString("datefrom");
String dateto = RecordSet.getString("dateto");
String basesalary = RecordSet.getString("basesalary");
String homesub = RecordSet.getString("homesub");
String vehiclesub = RecordSet.getString("vehiclesub");
String mealsub = RecordSet.getString("mealsub");
String othersub = RecordSet.getString("othersub");
String adjustreason = RecordSet.getString("adjustreason");
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
	<td><%=datefrom%>-<%=dateto%></td>
    <td><%=basesalary%></td>
    <td><%=homesub%></td>
    <td><%=vehiclesub%></td>
    <td><%=mealsub%></td>
    <td><%=othersub%></td>
    <td><%=adjustreason%></td>
    </TR>
<%}
%>
  </TBODY> 
</TABLE>
<TABLE class=ListShort>
  <TBODY> 
  <TR class=Section> 
    <TH colSpan=8><%=SystemEnv.getHtmlLabelName(1505,user.getLanguage())%></TH>
  </TR>
  <TR class=Separator> 
    <TD class=Sep1 colSpan=8></TD>
  </TR>
  <TR class=Header> 
    <TD width="20%"><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></TD>
    <TD width="11%"><%=SystemEnv.getHtmlLabelName(1919,user.getLanguage())%></TD>
    <TD width="11%"><%=SystemEnv.getHtmlLabelName(1920,user.getLanguage())%></TD>
    <TD width="11%"><%=SystemEnv.getHtmlLabelName(1921,user.getLanguage())%></TD>
	<TD width="11%"><%=SystemEnv.getHtmlLabelName(1922,user.getLanguage())%></TD>
	<TD width="12%"><%=SystemEnv.getHtmlLabelName(1923,user.getLanguage())%></TD>
	<TD width="12%"><%=SystemEnv.getHtmlLabelName(1924,user.getLanguage())%></TD>
	<TD width="12%"><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></TD>
  </TR>
<%
i=0;
RecordSet.executeProc("HrmAbsense1_SelectByResourceId",id);

while(RecordSet.next()){
String datefrom = RecordSet.getString("startdate");
String dateto = RecordSet.getString("enddate");
//与中文字串比较,用fromScreen2
String absensetype = Util.fromScreen2(RecordSet.getString("workflowname"),user.getLanguage());
int absenseday = (int)(RecordSet.getFloat("absenseday"));

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
	<TD width="20%"><%=Util.toScreen(datefrom,user.getLanguage())%>-<%=Util.toScreen(dateto,user.getLanguage())%></TD>
    <TD width="10%"><%if(absensetype.equals("病假")) {%><%=absenseday%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%}%></TD>
    <TD width="10%"><%if(absensetype.equals("事假")) {%><%=absenseday%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%}%></TD>
    <TD width="10%"><%if(absensetype.equals("产假")) {%><%=absenseday%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%}%></TD>
	<TD width="10%"><%if(absensetype.equals("婚丧假")) {%><%=absenseday%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%}%></TD>
	<TD width="10%"><%if(absensetype.equals("休假")) {%><%=absenseday%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%}%></TD>
	<TD width="10%"><%if(absensetype.equals("缺勤")) {%><%=absenseday%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%}%></TD>
	<TD width="10%"><%if(absensetype.equals("其它")) {%><%=absenseday%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%}%></TD>
</TR>
<%}
%>
  </TBODY> 
</TABLE>
</HTML>
