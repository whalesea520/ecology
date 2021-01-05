<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="HrmSearchComInfo" class="weaver.hrm.search.HrmSearchComInfo" scope="session" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String resourceid     =Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());
String resourcename   =Util.fromScreen2(request.getParameter("resourcename"),user.getLanguage());
String jobtitle       =Util.fromScreen(request.getParameter("jobtitle"),user.getLanguage());
String activitydesc   =Util.fromScreen2(request.getParameter("activitydesc"),user.getLanguage());
String jobgroup       =Util.fromScreen(request.getParameter("jobgroup"),user.getLanguage());
String jobactivity    =Util.fromScreen(request.getParameter("jobactivity"),user.getLanguage());
String costcenter     =Util.fromScreen(request.getParameter("costcenter"),user.getLanguage());
String competency     =Util.fromScreen(request.getParameter("competency"),user.getLanguage());
String resourcetype   =Util.fromScreen(request.getParameter("resourcetype"),user.getLanguage());
String status         =Util.fromScreen(request.getParameter("status"),user.getLanguage());
String subcompany1    =Util.fromScreen(request.getParameter("subcompany1"),user.getLanguage());
String department     =Util.fromScreen(request.getParameter("department"),user.getLanguage());
String location       =Util.fromScreen(request.getParameter("location"),user.getLanguage());
String manager        =Util.fromScreen(request.getParameter("manager"),user.getLanguage());
String assistant      =Util.fromScreen(request.getParameter("assistant"),user.getLanguage());
String roles          =Util.fromScreen(request.getParameter("roles"),user.getLanguage());
String seclevel       =Util.fromScreen(request.getParameter("seclevel"),user.getLanguage());
String seclevelTo     =Util.fromScreen(request.getParameter("seclevelTo"),user.getLanguage());
String joblevel       =Util.fromScreen(request.getParameter("joblevel"),user.getLanguage());
String joblevelTo     =Util.fromScreen(request.getParameter("joblevelTo"),user.getLanguage());
String workroom       =Util.fromScreen2(request.getParameter("workroom"),user.getLanguage());
String telephone      =Util.fromScreen(request.getParameter("telephone"),user.getLanguage());
String startdate      =Util.fromScreen(request.getParameter("startdate"),user.getLanguage());
String startdateTo    =Util.fromScreen(request.getParameter("startdateTo"),user.getLanguage());
String enddate        =Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String enddateTo      =Util.fromScreen(request.getParameter("enddateTo"),user.getLanguage());
String contractdate   =Util.fromScreen(request.getParameter("contractdate"),user.getLanguage());
String contractdateTo =Util.fromScreen(request.getParameter("contractdateTo"),user.getLanguage());
String birthday       =Util.fromScreen(request.getParameter("birthday"),user.getLanguage());
String birthdayTo     =Util.fromScreen(request.getParameter("birthdayTo"),user.getLanguage());
String birthdayYear     =Util.fromScreen(request.getParameter("birthdayyear"),user.getLanguage());
String birthdayMonth     =Util.fromScreen(request.getParameter("birthdaymonth"),user.getLanguage());
String birthdayDay     =Util.fromScreen(request.getParameter("birthdayday"),user.getLanguage());
String age            =Util.fromScreen(request.getParameter("age"),user.getLanguage());
String ageTo          =Util.fromScreen(request.getParameter("ageTo"),user.getLanguage());
String sex            =Util.fromScreen(request.getParameter("sex"),user.getLanguage());

String resourceidfrom     =Util.fromScreen(request.getParameter("resourceidfrom"),user.getLanguage());
String resourceidto       =Util.fromScreen(request.getParameter("resourceidto"),user.getLanguage());
String workcode           =Util.fromScreen(request.getParameter("workcode"),user.getLanguage());
String jobcall            =Util.fromScreen(request.getParameter("jobcall"),user.getLanguage());
String mobile             =Util.fromScreen(request.getParameter("mobile"),user.getLanguage());
String mobilecall         =Util.fromScreen(request.getParameter("mobilecall"),user.getLanguage());
String fax                =Util.fromScreen(request.getParameter("fax"),user.getLanguage());
String email              =Util.fromScreen(request.getParameter("email"),user.getLanguage());
String folk               =Util.fromScreen2(request.getParameter("folk"),user.getLanguage());
String nativeplace        =Util.fromScreen2(request.getParameter("nativeplace"),user.getLanguage());
String regresidentplace   =Util.fromScreen2(request.getParameter("regresidentplace"),user.getLanguage());
String maritalstatus      =Util.fromScreen(request.getParameter("maritalstatus"),user.getLanguage());
String certificatenum     =Util.fromScreen(request.getParameter("certificatenum"),user.getLanguage());
String tempresidentnumber =Util.fromScreen(request.getParameter("tempresidentnumber"),user.getLanguage());
String residentplace      =Util.fromScreen2(request.getParameter("residentplace"),user.getLanguage());
String homeaddress        =Util.fromScreen2(request.getParameter("homeaddress"),user.getLanguage());
String healthinfo         =Util.fromScreen(request.getParameter("healthinfo"),user.getLanguage());
String heightfrom         =Util.fromScreen(request.getParameter("heightfrom"),user.getLanguage());
String heightto           =Util.fromScreen(request.getParameter("heightto"),user.getLanguage());
String weightfrom         =Util.fromScreen(request.getParameter("weightfrom"),user.getLanguage());
String weightto           =Util.fromScreen(request.getParameter("weightto"),user.getLanguage());
String educationlevel     =Util.fromScreen(request.getParameter("educationlevel"),user.getLanguage());
String educationlevelTo     =Util.fromScreen(request.getParameter("educationlevelto"),user.getLanguage());
String degree             =Util.fromScreen2(request.getParameter("degree"),user.getLanguage());
String usekind            =Util.fromScreen(request.getParameter("usekind"),user.getLanguage());
String policy             =Util.fromScreen2(request.getParameter("policy"),user.getLanguage());
String bememberdatefrom   =Util.fromScreen(request.getParameter("bememberdatefrom"),user.getLanguage());
String bememberdateto     =Util.fromScreen(request.getParameter("bememberdateto"),user.getLanguage());
String bepartydatefrom    =Util.fromScreen(request.getParameter("bepartydatefrom"),user.getLanguage());
String bepartydateto      =Util.fromScreen(request.getParameter("bepartydateto"),user.getLanguage());
String islabouunion       =Util.fromScreen(request.getParameter("islabouunion"),user.getLanguage());
String bankid1            =Util.fromScreen(request.getParameter("bankid1"),user.getLanguage());
String accountid1         =Util.fromScreen(request.getParameter("accountid1"),user.getLanguage());
String accumfundaccount   =Util.fromScreen(request.getParameter("accumfundaccount"),user.getLanguage());
String loginid            =Util.fromScreen(request.getParameter("loginid"),user.getLanguage());
String systemlanguage     =Util.fromScreen(request.getParameter("systemlanguage"),user.getLanguage());

//自定义字段Begin
/*日期型Begin*/
String dff01name = Util.fromScreen(request.getParameter("dff01name"),user.getLanguage());
String dff02name = Util.fromScreen(request.getParameter("dff02name"),user.getLanguage());
String dff03name = Util.fromScreen(request.getParameter("dff03name"),user.getLanguage());
String dff04name = Util.fromScreen(request.getParameter("dff04name"),user.getLanguage());
String dff05name = Util.fromScreen(request.getParameter("dff05name"),user.getLanguage());
String dff01nameto = Util.fromScreen(request.getParameter("dff01nameto"),user.getLanguage());
String dff02nameto = Util.fromScreen(request.getParameter("dff02nameto"),user.getLanguage());
String dff03nameto = Util.fromScreen(request.getParameter("dff03nameto"),user.getLanguage()); 
String dff04nameto = Util.fromScreen(request.getParameter("dff04nameto"),user.getLanguage());
String dff05nameto = Util.fromScreen(request.getParameter("dff05nameto"),user.getLanguage());
/*日期型End*/
/*数字型Begin*/
String nff01name = Util.fromScreen(request.getParameter("nff01name"),user.getLanguage());
String nff02name = Util.fromScreen(request.getParameter("nff02name"),user.getLanguage());
String nff03name = Util.fromScreen(request.getParameter("nff03name"),user.getLanguage());
String nff04name = Util.fromScreen(request.getParameter("nff04name"),user.getLanguage());
String nff05name = Util.fromScreen(request.getParameter("nff05name"),user.getLanguage());
String nff01nameto = Util.fromScreen(request.getParameter("nff01nameto"),user.getLanguage());
String nff02nameto = Util.fromScreen(request.getParameter("nff02nameto"),user.getLanguage());
String nff03nameto = Util.fromScreen(request.getParameter("nff03nameto"),user.getLanguage());
String nff04nameto = Util.fromScreen(request.getParameter("nff04nameto"),user.getLanguage());
String nff05nameto = Util.fromScreen(request.getParameter("nff05nameto"),user.getLanguage());
/*数字型End*/
/*文本型Begin*/
String tff01name = Util.fromScreen(request.getParameter("tff01name"),user.getLanguage());
String tff02name = Util.fromScreen(request.getParameter("tff02name"),user.getLanguage());
String tff03name = Util.fromScreen(request.getParameter("tff03name"),user.getLanguage());
String tff04name = Util.fromScreen(request.getParameter("tff04name"),user.getLanguage());
String tff05name = Util.fromScreen(request.getParameter("tff05name"),user.getLanguage());
/*文本型End*/
/*booleanBegin*/
String bff01name = Util.fromScreen(request.getParameter("bff01name"),user.getLanguage());
String bff02name = Util.fromScreen(request.getParameter("bff02name"),user.getLanguage());
String bff03name = Util.fromScreen(request.getParameter("bff03name"),user.getLanguage());
String bff04name = Util.fromScreen(request.getParameter("bff04name"),user.getLanguage());
String bff05name = Util.fromScreen(request.getParameter("bff05name"),user.getLanguage());
/*booleanEnd*/
//自定义字段End


Enumeration en =request.getParameterNames();
Map customFieldMap=new HashMap();
while(en.hasMoreElements()){
    String paramName=(String)en.nextElement();
    if(paramName.indexOf("customfield")>-1) {
     customFieldMap.put(paramName.substring(11),Util.fromScreen2(request.getParameter(paramName),user.getLanguage()));
    }
}


String orderby = Util.fromScreen(request.getParameter("orderby"),user.getLanguage());
boolean isoracle=RecordSet.getDBType().equals("oracle");

String from = Util.fromScreen(request.getParameter("from"),user.getLanguage());

HrmSearchComInfo.resetSearchInfo();
HrmSearchComInfo.setCustomFieldPersonal(customFieldMap);
HrmSearchComInfo.setResourceid(resourceid);
HrmSearchComInfo.setResourcename(resourcename);
HrmSearchComInfo.setJobtitle(jobtitle);
HrmSearchComInfo.setActivitydesc(activitydesc);
HrmSearchComInfo.setJobgroup(jobgroup);
HrmSearchComInfo.setJobactivity(jobactivity);
HrmSearchComInfo.setCostcenter(costcenter);
HrmSearchComInfo.setCompetency(competency);
HrmSearchComInfo.setResourcetype(resourcetype);
HrmSearchComInfo.setStatus(status);
HrmSearchComInfo.setSubcompany1(subcompany1);
HrmSearchComInfo.setDepartment(department);
HrmSearchComInfo.setLocation(location);
HrmSearchComInfo.setManager(manager);
HrmSearchComInfo.setAssistant(assistant);
HrmSearchComInfo.setRoles(roles);
HrmSearchComInfo.setSeclevel(seclevel);
HrmSearchComInfo.setSeclevelTo(seclevelTo);
HrmSearchComInfo.setJoblevel(joblevel);
HrmSearchComInfo.setJoblevelTo(joblevelTo);
HrmSearchComInfo.setWorkroom(workroom);
HrmSearchComInfo.setTelephone(telephone);
HrmSearchComInfo.setStartdate(startdate);
HrmSearchComInfo.setStartdateTo(startdateTo);
HrmSearchComInfo.setEnddate(enddate);
HrmSearchComInfo.setEnddateTo(enddateTo);
HrmSearchComInfo.setContractdate(contractdate);
HrmSearchComInfo.setContractdateTo(contractdateTo);
HrmSearchComInfo.setBirthday(birthday);
HrmSearchComInfo.setBirthdayYear(birthdayYear);
HrmSearchComInfo.setBirthdayMonth(birthdayMonth);
HrmSearchComInfo.setBirthdayDay(birthdayDay);
HrmSearchComInfo.setBirthdayTo(birthdayTo);
HrmSearchComInfo.setAge(age);
HrmSearchComInfo.setAgeTo(ageTo);
HrmSearchComInfo.setSex(sex);

HrmSearchComInfo.setResourceidfrom(resourceidfrom);
HrmSearchComInfo.setResourceidto(resourceidto);
HrmSearchComInfo.setWorkcode(workcode);
HrmSearchComInfo.setJobcall(jobcall);
HrmSearchComInfo.setMobile(mobile);
HrmSearchComInfo.setMobilecall(mobilecall);
HrmSearchComInfo.setFax(fax);
HrmSearchComInfo.setEmail(email);
HrmSearchComInfo.setFolk(folk);
HrmSearchComInfo.setNativeplace(nativeplace);
HrmSearchComInfo.setRegresidentplace(regresidentplace);
HrmSearchComInfo.setMaritalstatus(maritalstatus);
HrmSearchComInfo.setCertificatenum(certificatenum);
HrmSearchComInfo.setTempresidentnumber(tempresidentnumber);
HrmSearchComInfo.setResidentplace(residentplace);
HrmSearchComInfo.setHomeaddress(homeaddress);
HrmSearchComInfo.setHealthinfo(healthinfo);
HrmSearchComInfo.setHeightfrom(heightfrom);
HrmSearchComInfo.setHeightto(heightto);
HrmSearchComInfo.setWeightfrom(weightfrom);
HrmSearchComInfo.setWeightto(weightto);
HrmSearchComInfo.setEducationlevel(educationlevel);
HrmSearchComInfo.setEducationlevelTo(educationlevelTo);
HrmSearchComInfo.setDegree(degree);
HrmSearchComInfo.setUsekind(usekind);
HrmSearchComInfo.setPolicy(policy);
HrmSearchComInfo.setBememberdatefrom(bememberdatefrom);
HrmSearchComInfo.setBememberdateto(bememberdateto);
HrmSearchComInfo.setBepartydatefrom(bepartydatefrom);
HrmSearchComInfo.setBepartydateto(bepartydateto);
HrmSearchComInfo.setIslabouunion(islabouunion);
HrmSearchComInfo.setBankid1(bankid1);
HrmSearchComInfo.setAccountid1(accountid1);
HrmSearchComInfo.setAccumfundaccount(accumfundaccount);
HrmSearchComInfo.setLoginid(loginid);
HrmSearchComInfo.setSystemlanguage(systemlanguage);
HrmSearchComInfo.setDff01name(dff01name);
HrmSearchComInfo.setDff02name(dff02name);
HrmSearchComInfo.setDff03name(dff03name);
HrmSearchComInfo.setDff04name(dff04name);
HrmSearchComInfo.setDff05name(dff05name);
HrmSearchComInfo.setDff01nameto(dff01nameto);
HrmSearchComInfo.setDff02nameto(dff02nameto);
HrmSearchComInfo.setDff03nameto(dff03nameto);
HrmSearchComInfo.setDff04nameto(dff04nameto);
HrmSearchComInfo.setDff05nameto(dff05nameto);
HrmSearchComInfo.setNff01name(nff01name);
HrmSearchComInfo.setNff02name(nff02name);
HrmSearchComInfo.setNff03name(nff03name);
HrmSearchComInfo.setNff04name(nff04name);
HrmSearchComInfo.setNff05name(nff05name);
HrmSearchComInfo.setNff01nameto(nff01nameto);
HrmSearchComInfo.setNff02nameto(nff02nameto);
HrmSearchComInfo.setNff03nameto(nff03nameto);
HrmSearchComInfo.setNff04nameto(nff04nameto);
HrmSearchComInfo.setNff05nameto(nff05nameto);
HrmSearchComInfo.setTff01name(tff01name);
HrmSearchComInfo.setTff02name(tff02name);
HrmSearchComInfo.setTff03name(tff03name);
HrmSearchComInfo.setTff04name(tff04name);
HrmSearchComInfo.setTff05name(tff05name);
HrmSearchComInfo.setBff01name(bff01name);
HrmSearchComInfo.setBff02name(bff02name);
HrmSearchComInfo.setBff03name(bff03name);
HrmSearchComInfo.setBff04name(bff04name);
HrmSearchComInfo.setBff05name(bff05name);

HrmSearchComInfo.setIsoracle(isoracle);

if(!orderby.equals("")){
	HrmSearchComInfo.setOrderby(orderby);
}
else{
	HrmSearchComInfo.setOrderby("hrmresource.id");
}

response.sendRedirect("HrmRpResourceResult.jsp");    
%>
