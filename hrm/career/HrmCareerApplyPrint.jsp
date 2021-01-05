
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<!-- modified by wcd 2014-07-04 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CareerInviteComInfo" class="weaver.hrm.career.CareerInviteComInfo" scope="page"/>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="CareerApplyComInfo" class="weaver.hrm.career.HrmCareerApplyComInfo" scope="page"/>
<jsp:useBean id="EduLevelComInfo" class="weaver.hrm.job.EducationLevelComInfo" scope="session" />
<jsp:useBean id="SpecialityComInfo" class="weaver.hrm.job.SpecialityComInfo" scope="page" />
<HTML><HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javaScript">
var dialog = parent.getDialog(this);
function imgSet(obj) {			
	var imgHeight = obj.height;
	if(imgHeight>=250)obj.height = 250;
}
function printit(obj){
	rightMenu.style.display="none";
  document.body.focus();
  window.print();
	//rightMenu.style.display="";
}
</script>


<SCRIPT>
function window.onafterprint(){
	rightMenu.style.display="";
	//alert("打印后事件");
} 
</script>
</HEAD>
<%!
/**
 * Add by Charoes ,remove the zero behind a Two Digit precision Decimal .
 * @param s
 * @return
 */
private String trimZero(String s){
	int index = s.indexOf(".");
	if(index !=-1){
		String temp = s.substring(index+1);
		if(temp.equals("00"))
			s = s.substring(0,index);
		else{
			if(temp.substring(temp.length()-1).equals("0") ){
				s = s.substring(0,s.length()-1)      ;
			}
		}
	}
	return s;
}
%>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1932,user.getLanguage());
String needfav ="1";
String needhelp ="";

int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String isDialog = Util.null2String(request.getParameter("isdialog"));
String applyid = Util.null2String(request.getParameter("applyid"));
rs.executeProc("HrmCareerApply_SelectById",applyid);
rs.next();

String inviteid = Util.null2String(rs.getString("careerinviteid"));
String jobtitle = Util.null2String(rs.getString("jobtitle"));
String ischeck = Util.null2String(rs.getString("ischeck"));
String ishire = Util.null2String(rs.getString("ishire"));
int picture = rs.getInt("picture");
String pictureshowname = "";
if(picture>0){
    rs1.executeSql("select imagefilename from ImageFile where imagefileid="+picture);
    if(rs1.next()){
        pictureshowname=rs1.getString("imagefilename");
    }
}

String firstname = Util.toScreen(rs.getString("firstname"),user.getLanguage()) ;			/*名*/
String lastname = Util.toScreen(rs.getString("lastname"),user.getLanguage()) ;			/*姓*/
String titleid= Util.toScreen(rs.getString("titleid"),user.getLanguage()) ;				/*称呼*/
String sex = Util.toScreen(rs.getString("sex"),user.getLanguage()) ;
String nationality = Util.toScreen(rs.getString("nationality"),user.getLanguage()) ;		/*国籍*/
String defaultlanguage = Util.toScreen(rs.getString("defaultlanguage"),user.getLanguage()) ;	/*口语语言*/
String marrydate = Util.toScreen(rs.getString("marrydate"),user.getLanguage()) ;			/*结婚日期*/
String email = Util.toScreen(rs.getString("email"),user.getLanguage()) ;				/*电邮*/
String homepostcode = Util.toScreen(rs.getString("homepostcode"),user.getLanguage()) ;/*家庭邮编*/
String homephone = Util.toScreen(rs.getString("homephone"),user.getLanguage()) ;				/*家庭电话*/
String certificatecategory = Util.toScreen(rs.getString("certificatecategory"),user.getLanguage()) ;/**/
String bedemocracydate = Util.toScreen(rs.getString("bedemocracydate"),user.getLanguage()) ;		/*民主日期*/
String homepage = Util.toScreen(rs.getString("homepage"),user.getLanguage()) ;						/*个人主页*/
String train = Util.toScreen(rs.getString("train"),user.getLanguage()) ;							/*培训及持有证书*/
String numberid = Util.toScreen(rs.getString("numberid"),user.getLanguage()) ;							/*培训及持有证书*/

//个人资料
String birthday = Util.toScreen(rs.getString("birthday"),user.getLanguage()) ;			/*生日*/
String folk = Util.toScreen(rs.getString("folk"),user.getLanguage()) ;
String nativeplace = Util.toScreen(rs.getString("nativeplace"),user.getLanguage()) ;/*籍贯*/
String regresidentplace = Util.toScreen(rs.getString("regresidentplace"),user.getLanguage()) ;		/*户口所在地*/
String certificatenum = Util.toScreen(rs.getString("certificatenum"),user.getLanguage()) ;			/*证件号码*/
String maritalstatus = Util.toScreen(rs.getString("maritalstatus"),user.getLanguage()) ;
String policy = Util.toScreen(rs.getString("policy"),user.getLanguage()) ;							/*政治面貌*/
String bememberdate = Util.toScreen(rs.getString("bememberdate"),user.getLanguage()) ;				/*入团日期*/
String bepartydate = Util.toScreen(rs.getString("bepartydate"),user.getLanguage()) ;				/*入党日期*/
String islabouunion = Util.toScreen(rs.getString("islabouunion"),user.getLanguage()) ;
String educationlevel = Util.toScreen(rs.getString("educationlevel"),user.getLanguage()) ;			/*学历*/
String degree = Util.toScreen(rs.getString("degree"),user.getLanguage()) ;							/*学位*/
String healthinfo = Util.toScreen(rs.getString("healthinfo"),user.getLanguage()) ;					/*健康状况*/
String height = Util.toScreen(rs.getString("height"),user.getLanguage()) ;							/*身高*/
String weight = Util.toScreen(rs.getString("weight"),user.getLanguage()) ;
String residentplace = Util.toScreen(rs.getString("residentplace"),user.getLanguage()) ;			/*现居住地*/
String homeaddress = Util.toScreen(rs.getString("homeaddress"),user.getLanguage()) ;				/*家庭地址*/
String tempresidentnumber = Util.toScreen(rs.getString("tempresidentnumber"),user.getLanguage()) ; 


rs.executeProc("HrmCareerApplyOtherInfo_SByApp",applyid);
rs.next();

String contactor = Util.toScreen(rs.getString("contactor"),user.getLanguage()) ;							/*联系人*/
String category = Util.toScreen(rs.getString("category"),user.getLanguage()) ;						/*应聘者类别*/
String major = Util.toScreen(rs.getString("major"),user.getLanguage()) ;						/*专业*/
String salarynow = Util.toScreen(rs.getString("salarynow"),user.getLanguage()) ;				/*当前年薪*/
String worktime = Util.toScreen(rs.getString("worktime"),user.getLanguage()) ;				/*工作年限*/
String salaryneed = Util.toScreen(rs.getString("salaryneed"),user.getLanguage()) ;				/*年薪低限*/
String reason = Util.toScreen(rs.getString("reason"),user.getLanguage()) ;							/**/
String otherrequest = Util.toScreen(rs.getString("otherrequest"),user.getLanguage()) ;		/**/
String selfcomment = Util.toScreen(rs.getString("selfcomment"),user.getLanguage()) ;		/*自荐书*/
String currencyid = Util.toScreen(rs.getString("currencyid"),user.getLanguage()) ;				/*币种*/


String informman = "" ;
String principalid = "" ;
String planid = "" ;
if( !inviteid.equals("")) {
    rs.executeSql("select a.* from HrmCareerPlan a , HrmCareerInvite b where a.id = b.careerplanid and b.id = "+inviteid);
    while(rs.next()){
      principalid = Util.null2String(rs.getString("principalid"));
      informman = Util.null2String(rs.getString("informmanid"));
      planid = Util.null2String(rs.getString("id"));
    }
}

boolean isInformer = (Util.getIntValue(informman)==user.getUID());
boolean isPrincipal = (Util.getIntValue(principalid)==user.getUID());
boolean isAssessor = CareerApplyComInfo.isAssessor(applyid,user.getUID());
boolean isTester = CareerApplyComInfo.isTester(applyid,user.getUID());
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(257,user.getLanguage())+",javascript:printit(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver action="feedbackOperation.jsp" method=post>
<table width="639" border="2px" cellspacing="0" cellpadding="0" style="border-collapse:collapse;">
	<colgroup>
	<col width="9%">
	<col width="6%">
	<col width="3%">
	<col width="20%">
	<col width="6%">
	<col width="6%">
	<col width="6%">
	<col width="6%">
	<col width="3%">
	<col width="9%">
	<col width="9%">
	<col width="17%">
  <tr>
    <td colspan="10" width="74%" height="22"><b><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></b></td>
    <td colspan="2" rowspan="7" width="26%" align="center" valign="top">
			<%if(picture>0){%>
			<img width="145" src="/weaver/weaver.file.FileDownload?fileid=<%=picture%>&download=1" onload="imgSet(this)">
			<%}%>
    </td>
  </tr>
  <tr height="22">
    <td colspan="3" width="18%"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></td>
    <td colspan="7" width="56%"><%=lastname%></td>
  </tr>
  <tr height="22">
		<td colspan="3"><%=SystemEnv.getHtmlLabelName(416,user.getLanguage())%></td>
    <td colspan="7">
			<% if(sex.equals("0")) {%><%=SystemEnv.getHtmlLabelName(417,user.getLanguage())%><%}%>
			<% if(sex.equals("1")) {%><%=SystemEnv.getHtmlLabelName(418,user.getLanguage())%><%}%>
			<% if(sex.equals("2")) {%><%=SystemEnv.getHtmlLabelName(463,user.getLanguage())%><%}%>
    </td>
  </tr>
  <tr height="22">
		<td colspan="3"><%=SystemEnv.getHtmlLabelName(15675,user.getLanguage())%></td>
    <td colspan="7">
			<% if(category.equals("0")) {%><%=SystemEnv.getHtmlLabelName(134,user.getLanguage())%><%}%>
			<% if(category.equals("1")) {%><%=SystemEnv.getHtmlLabelName(1830,user.getLanguage())%><%}%>
			<% if(category.equals("2")) {%><%=SystemEnv.getHtmlLabelName(1831,user.getLanguage())%><%}%>
			<% if(category.equals("3")) {%><%=SystemEnv.getHtmlLabelName(1832,user.getLanguage())%><%}%>
    </td>
  </tr>
  <tr height="22">
		<td colspan="3"><%=SystemEnv.getHtmlLabelName(15692,user.getLanguage())%></td>
    <td colspan="7"><%=CareerInviteComInfo.getCareerInvitedate(inviteid)%></td>
  </tr>
  <tr height="22">
		<td colspan="3"><%=SystemEnv.getHtmlLabelName(15671,user.getLanguage())%></td>
    <td colspan="7"><%=JobTitlesComInfo.getJobTitlesname(jobtitle)%></td>
  </tr>
  <tr height="*">
		<td colspan="10">&nbsp;</td>
  </tr>
  <tr height="22">
    <td colspan="12" width="100%"><b><%=SystemEnv.getHtmlLabelName(1842,user.getLanguage())%></b></td>
  </tr>
  <tr height="22">
    <td colspan="2" width="15%"><%=SystemEnv.getHtmlLabelName(1843,user.getLanguage())%></td>
    <td colspan="4" width="35%"><%=salarynow%></td>
    <td colspan="3" width="15%"><%=SystemEnv.getHtmlLabelName(1844,user.getLanguage())%></td>
    <td colspan="3" width="35%"><%=worktime%></td>
  </tr>
  <tr height="22">
    <td colspan="2"><%=SystemEnv.getHtmlLabelName(1845,user.getLanguage())%></td>
    <td colspan="4"><%=salaryneed%></td>
    <td colspan="3"><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></td>
    <td colspan="3"><%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%></td>
  </tr>

  <tr height="22">
    <td colspan="2"><%=SystemEnv.getHtmlLabelName(1846,user.getLanguage())%></td>
    <td colspan="10"><%=reason%></td>
  </tr>
  <tr height="22">
    <td colspan="2"><%=SystemEnv.getHtmlLabelName(1847,user.getLanguage())%></td>
    <td colspan="10"><%=otherrequest%></td>
  </tr>
  <tr height="22">
    <td colspan="12"><b><%=SystemEnv.getHtmlLabelName(569,user.getLanguage())%></b></td>
  </tr>
  <tr height="22">
    <td colspan="2"><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></td>
    <td colspan="4"><%=contactor%></td>
    <td colspan="3"><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></td>
    <td colspan="3"><%=email%></td>
  </tr>
  <tr height="22">
    <td colspan="2"><%=SystemEnv.getHtmlLabelName(479,user.getLanguage())%></td>
    <td colspan="4"><%=homepostcode%></td>
    <td colspan="3"><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())%></td>
    <td colspan="3"><%=homephone%></td>
  </tr>
  <tr height="22">
    <td colspan="2"><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></td>
    <td colspan="4"><%=homeaddress%></td>
    <td colspan="3"><%=SystemEnv.getHtmlLabelName(1848,user.getLanguage())%></td>
    <td colspan="3"><%=homepage%></td>
  </tr>
  <tr height="22">
    <td colspan="2"><%=SystemEnv.getHtmlLabelName(1849,user.getLanguage())%></td>
    <td colspan="10"><%=selfcomment%></td>
  </tr>
  <tr height="22">
		<td colspan="12"><b><%=SystemEnv.getHtmlLabelName(15687,user.getLanguage())%></b></td>
  </tr>
  <tr height="22">
    <td colspan="2"><%=SystemEnv.getHtmlLabelName(464,user.getLanguage())%></td>
    <td colspan="4"><%=birthday%></td>
    <td colspan="3"><%=SystemEnv.getHtmlLabelName(1886,user.getLanguage())%></td>
    <td colspan="3"><%=folk%></td>
  </tr>
  <tr height="22">
    <td colspan="2"><%=SystemEnv.getHtmlLabelName(1840,user.getLanguage())%></td>
    <td colspan="4"><%=nativeplace%></td>
    <td colspan="3"><%=SystemEnv.getHtmlLabelName(15683,user.getLanguage())%></td>
    <td colspan="3"><%=regresidentplace%></td>
  </tr>
  <tr height="22">
    <td colspan="2"><%=SystemEnv.getHtmlLabelName(1887,user.getLanguage())%></td>
    <td colspan="4"><%=certificatenum%></td>
    <td colspan="3"><%=SystemEnv.getHtmlLabelName(469,user.getLanguage())%></td>
    <td colspan="3">
			<%if(maritalstatus.equals("0")){%><%=SystemEnv.getHtmlLabelName(470,user.getLanguage())%> <%}%>
			<%if(maritalstatus.equals("1")){%><%=SystemEnv.getHtmlLabelName(471,user.getLanguage())%> <%}%>
			<%if(maritalstatus.equals("2")){%><%=SystemEnv.getHtmlLabelName(472,user.getLanguage())%> <%}%>
		</td>
  </tr>
  <tr height="22">
    <td colspan="2"><%=SystemEnv.getHtmlLabelName(1837,user.getLanguage())%></td>
    <td colspan="4"><%=policy%></td>
    <td colspan="3"><%=SystemEnv.getHtmlLabelName(1834,user.getLanguage())%></td>
    <td colspan="3"><%=bememberdate%></td>
  </tr>
  <tr height="22">
    <td colspan="2"><%=SystemEnv.getHtmlLabelName(1835,user.getLanguage())%></td>
    <td colspan="4"><%=bepartydate%></td>
    <td colspan="3"><%=SystemEnv.getHtmlLabelName(15684,user.getLanguage())%></td>
    <td colspan="3">
			<%if(islabouunion.equals("1")){%><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%><%}%>
			<%if(islabouunion.equals("0")){%><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%><%}%>
    </td>
  </tr>
  <tr height="22">
    <td colspan="2"><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></td>
    <td colspan="4"><%=EduLevelComInfo.getEducationLevelname(educationlevel)%></td>
    <td colspan="3"><%=SystemEnv.getHtmlLabelName(1833,user.getLanguage())%></td>
    <td colspan="3"><%=degree%></td>
  </tr>
  <tr height="22">
    <td colspan="2"><%=SystemEnv.getHtmlLabelName(1827,user.getLanguage())%></td>
    <td colspan="4">
			<%if(healthinfo.equals("0")){%><%=SystemEnv.getHtmlLabelName(824,user.getLanguage())%><%}%>
			<%if(healthinfo.equals("1")){%><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%><%}%>
			<%if(healthinfo.equals("2")){%><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%><%}%>
			<%if(healthinfo.equals("3")){%><%=SystemEnv.getHtmlLabelName(825,user.getLanguage())%><%}%>
    </td>
    <td colspan="3"><%=SystemEnv.getHtmlLabelName(1826,user.getLanguage())%></td>
    <td colspan="3"><%=trimZero(height)%></td>
  </tr>
  <tr height="22">
    <td colspan="2"><%=SystemEnv.getHtmlLabelName(15674,user.getLanguage())%></td>
    <td colspan="4"><%=trimZero(weight)%></td>
    <td colspan="3"><%=SystemEnv.getHtmlLabelName(1829,user.getLanguage())%></td>
    <td colspan="3"><%=residentplace%></td>
  </tr>
  <tr height="22">
    <td colspan="2"><%=SystemEnv.getHtmlLabelName(15685,user.getLanguage())%></td>
    <td colspan="4"><%=tempresidentnumber%></td>
    <td colspan="3">&nbsp;</td>
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr height="22">
		<td colspan="12" width="100%"><b><%=SystemEnv.getHtmlLabelName(814,user.getLanguage())%></b></td>
  </tr>
  <tr height="22">
    <td width="9%"><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></td>
    <td colspan="2" width="9%"><%=SystemEnv.getHtmlLabelName(1944,user.getLanguage())%></td>
    <td colspan="3" width="32%"><%=SystemEnv.getHtmlLabelName(1914,user.getLanguage())%></td>
    <td colspan="4" width="24%"><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></td>
    <td colspan="2" width="26%"><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></td>
  </tr>
	<%
	String sql = "select * from HrmFamilyInfo where resourceid = "+applyid+" order by ID";  
	rs.executeSql(sql);
	while(rs.next()){
		String member = Util.null2String(rs.getString("member"));
		String title = Util.null2String(rs.getString("title"));
		String company = Util.null2String(rs.getString("company"));
		String jobtitle2 = Util.null2String(rs.getString("jobtitle"));
		String address = Util.null2String(rs.getString("address"));
	%>
  <tr height="22">
    <td><%=member%></td>
    <td colspan="2"><%=title%></td>
    <td colspan="3"><%=company%></td>
    <td colspan="4"><%=jobtitle2%></td>
    <td colspan="2"><%=address%></td>
  </tr>
  <%}%>
  <tr height="22">
		<td colspan="12"><b><%=SystemEnv.getHtmlLabelName(815,user.getLanguage())%></b></td>
  </tr>
  <tr height="22">
    <td colspan="3"><%=SystemEnv.getHtmlLabelName(231,user.getLanguage())%></td>
    <td colspan="3"><%=SystemEnv.getHtmlLabelName(15715,user.getLanguage())%></td>
    <td colspan="6"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
  </tr>
  <%
	sql = "select * from HrmLanguageAbility where resourceid = "+applyid+" order by ID";
	rs.executeSql(sql);
	while(rs.next()){
		String language = Util.null2String(rs.getString("language"));
		String level = Util.null2String(rs.getString("level_n"));
		String memo = Util.null2String(rs.getString("memo"));
  %>
  <tr height="22">
    <td colspan="3"><%=language%></td>
    <td colspan="3">
			<%if (level.equals("0")) {%><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%><%}%>
			<%if (level.equals("1")) {%><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%><%}%>
			<%if (level.equals("2")) {%><%=SystemEnv.getHtmlLabelName(822,user.getLanguage())%><%}%>
			<%if (level.equals("3")) {%><%=SystemEnv.getHtmlLabelName(823,user.getLanguage())%><%}%>
    </td>
    <td colspan="6"><%=memo%></td>
  </tr>
  <%}%>
  <tr height="22">
		<td colspan="12" width="100%"><b><%=SystemEnv.getHtmlLabelName(813,user.getLanguage())%></b></td>
  </tr>
  <tr height="22">
    <td colspan="3" width="18%"><%=SystemEnv.getHtmlLabelName(1903,user.getLanguage())%></td>
    <td colspan="3" width="32%"><%=SystemEnv.getHtmlLabelName(803,user.getLanguage())%></td>
    <td colspan="2" width="12%"><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
    <td colspan="2" width="12%"><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
    <td width="9%"><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%></td>
    <td width="17%"><%=SystemEnv.getHtmlLabelName(1942,user.getLanguage())%></td>
  </tr>
	<%
	sql = "select * from HrmEducationInfo where resourceid = "+applyid+" order by ID";
	rs.executeSql(sql);
	while(rs.next()){
		String startdate = Util.null2String(rs.getString("startdate"));
		String enddate = Util.null2String(rs.getString("enddate"));
		String school = Util.null2String(rs.getString("school"));
		String speciality = Util.null2String(rs.getString("speciality"));
		String educationlevel2 = Util.null2String(rs.getString("educationlevel"));
		String studydesc = Util.null2String(rs.getString("studydesc"));
	%>
  <tr height="22">
    <td colspan="3"><%=school%></td>
    <td colspan="3"><%=SpecialityComInfo.getSpecialityname(speciality)%></td>
    <td colspan="2"><%=startdate%></td>
    <td colspan="2"><%=enddate%></td>
    <td><%=EduLevelComInfo.getEducationLevelname(educationlevel)%></td>
    <td><%=studydesc%></td>
  </tr>
  <%}%>
  <tr height="22">
		<td colspan="12"><b><%=SystemEnv.getHtmlLabelName(15716,user.getLanguage())%></b></td>
  </tr>
  <tr height="22">
    <td colspan="3"><%=SystemEnv.getHtmlLabelName(1976,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(1915,user.getLanguage())%></td>
    <td colspan="2"><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
    <td colspan="2"><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
    <td colspan="3"><%=SystemEnv.getHtmlLabelName(1977,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(15676,user.getLanguage())%></td>
  </tr>
	<%
	sql = "select * from HrmWorkResume where resourceid = "+applyid+" order by ID";
	rs.executeSql(sql);
	while(rs.next()){
		String startdate = Util.null2String(rs.getString("startdate"));
		String enddate = Util.null2String(rs.getString("enddate"));
		String company = Util.null2String(rs.getString("company"));
		String jobtitle2 = Util.null2String(rs.getString("jobtitle"));
		String leavereason = Util.null2String(rs.getString("leavereason"));
		String workdesc = Util.null2String(rs.getString("workdesc"));
	%>
  <tr height="22">
    <td colspan="3"><%=company%></td>
    <td><%=jobtitle2%></td>
    <td colspan="2"><%=startdate%></td>
    <td colspan="2"><%=enddate%></td>
    <td colspan="3"><%=workdesc%></td>
    <td><%=leavereason%></td>
  </tr>
  <%}%>
  <tr height="22">
		<td colspan="12"><b><%=SystemEnv.getHtmlLabelName(15717,user.getLanguage())%></b></td>
  </tr>
  <tr height="22">
    <td colspan="3"><%=SystemEnv.getHtmlLabelName(15678,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(1974,user.getLanguage())%></td>
    <td colspan="2"><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
    <td colspan="2"><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
    <td colspan="4"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
  </tr>
	<%
	sql = "select * from HrmTrainBeforeWork where resourceid = "+applyid+" order by ID";
	rs.executeSql(sql);
	while(rs.next()){
		String startdate = Util.null2String(rs.getString("trainstartdate"));
		String enddate = Util.null2String(rs.getString("trainenddate"));
		String trainname = Util.null2String(rs.getString("trainname"));
		String trainresource = Util.null2String(rs.getString("trainresource"));	
		String trainmemo = Util.null2String(rs.getString("trainmemo"));
	%>
  <tr height="22">
    <td colspan="3"><%=trainname%></td>
    <td><%=trainresource%></td>
    <td colspan="2"><%=startdate%></td>
    <td colspan="2"><%=enddate%></td>
    <td colspan="4"><%=trainmemo%></td>
  </tr>
  <%}%>
  <tr height="22">
		<td colspan="12"><b><%=SystemEnv.getHtmlLabelName(1502,user.getLanguage())%></b></td>
  </tr>
  <tr height="22">
    <td colspan="4"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
    <td colspan="2"><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
    <td colspan="2"><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
    <td colspan="4"><%=SystemEnv.getHtmlLabelName(15681,user.getLanguage())%></td>
  </tr>
	<%
	sql = "select * from HrmCertification where resourceid = "+applyid+" order by ID";
	rs.executeSql(sql);
	while(rs.next()){
		String startdate = Util.null2String(rs.getString("datefrom"));
		String enddate = Util.null2String(rs.getString("dateto"));
		String cername = Util.null2String(rs.getString("certname"));
		String cerresource = Util.null2String(rs.getString("awardfrom"));  
	%>
  <tr height="22">
    <td colspan="4"><%=cername%></td>
		<td colspan="2"><%=startdate%></td>
    <td colspan="2"><%=enddate%></td>
    <td colspan="4"><%=cerresource%></td>
  </tr>
  <%}%>
  <tr height="22">
		<td colspan="12"><b><%=SystemEnv.getHtmlLabelName(15718,user.getLanguage())%></b></td>
  </tr>
  <tr height="22">
		<td colspan="6"><%=SystemEnv.getHtmlLabelName(15666,user.getLanguage())%></td>
    <td colspan="2"><%=SystemEnv.getHtmlLabelName(1962,user.getLanguage())%></td>
    <td colspan="4"><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></td>
  </tr>
	<%
	sql = "select * from HrmRewardBeforeWork where resourceid = "+applyid+" order by ID";
	rs.executeSql(sql);
	while(rs.next()){
		String rewarddate = Util.null2String(rs.getString("rewarddate"));
		String rewardname = Util.null2String(rs.getString("rewardname"));
		String rewardmemo = Util.null2String(rs.getString("rewardmemo"));
	%>
  <tr height="22">
		<td colspan="6"><%=rewardname%></td>
    <td colspan="2"><%=rewarddate%></td>
    <td colspan="4"><%=rewardmemo%></td>
  </tr>
  <%}%>
</table>
</FORM>
</BODY>
</HTML>