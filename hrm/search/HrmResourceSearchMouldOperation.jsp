<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util,weaver.docs.docs.CustomFieldManager" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String opera=Util.null2String(request.getParameter("opera"));

int id=Util.getIntValue(request.getParameter("mouldid"),0);

String mouldname=Util.fromScreen(request.getParameter("mouldname"),user.getLanguage());
int userid=user.getUID();

String resourceid     =Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());
String resourcename   =Util.fromScreen(request.getParameter("resourcename"),user.getLanguage());
String jobtitle       =Util.fromScreen(request.getParameter("jobtitle"),user.getLanguage());
String activitydesc   =Util.fromScreen(request.getParameter("activitydesc"),user.getLanguage());
String jobgroup       =Util.fromScreen(request.getParameter("jobgroup"),user.getLanguage());
String jobactivity    =Util.fromScreen(request.getParameter("jobactivity"),user.getLanguage());
String costcenter     =Util.fromScreen(request.getParameter("costcenter"),user.getLanguage());
String competency     =Util.fromScreen(request.getParameter("competency"),user.getLanguage());
String resourcetype   =Util.fromScreen(request.getParameter("resourcetype"),user.getLanguage());
String status         =Util.fromScreen(request.getParameter("status"),user.getLanguage());
String subcompany1    =Util.fromScreen(request.getParameter("subcompany1"),user.getLanguage());
String subcompany2    =Util.fromScreen(request.getParameter("subcompany2"),user.getLanguage());
String subcompany3    =Util.fromScreen(request.getParameter("subcompany3"),user.getLanguage());
String subcompany4    =Util.fromScreen(request.getParameter("subcompany4"),user.getLanguage());
String department     =Util.fromScreen(request.getParameter("department"),user.getLanguage());
String location       =Util.fromScreen(request.getParameter("location"),user.getLanguage());
String manager        =Util.fromScreen(request.getParameter("manager"),user.getLanguage());
String assistant      =Util.fromScreen(request.getParameter("assistant"),user.getLanguage());
String roles          =Util.fromScreen(request.getParameter("roles"),user.getLanguage());
String seclevel       =Util.fromScreen(request.getParameter("seclevel"),user.getLanguage());
String seclevelTo     =Util.fromScreen(request.getParameter("seclevelTo"),user.getLanguage());
String joblevel       =Util.fromScreen(request.getParameter("joblevel"),user.getLanguage());
String joblevelTo     =Util.fromScreen(request.getParameter("joblevelTo"),user.getLanguage());
String workroom       =Util.fromScreen(request.getParameter("workroom"),user.getLanguage());
String telephone      =Util.fromScreen(request.getParameter("telephone"),user.getLanguage());
String startdate      =Util.fromScreen(request.getParameter("startdate"),user.getLanguage());
String startdateTo    =Util.fromScreen(request.getParameter("startdateTo"),user.getLanguage());
String enddate        =Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String enddateTo      =Util.fromScreen(request.getParameter("enddateTo"),user.getLanguage());
String contractdate   =Util.fromScreen(request.getParameter("contractdate"),user.getLanguage());
String contractdateTo =Util.fromScreen(request.getParameter("contractdateTo"),user.getLanguage());
String birthday       =Util.fromScreen(request.getParameter("birthday"),user.getLanguage());
String birthdayTo     =Util.fromScreen(request.getParameter("birthdayTo"),user.getLanguage());
String birthdayYear   =Util.fromScreen(request.getParameter("birthdayyear"),user.getLanguage());
String birthdayMonth  =Util.fromScreen(request.getParameter("birthdaymonth"),user.getLanguage());
String birthdayDay    =Util.fromScreen(request.getParameter("birthdayday"),user.getLanguage());
String age            =Util.fromScreen(request.getParameter("age"),user.getLanguage());
String ageTo          =Util.fromScreen(request.getParameter("ageTo"),user.getLanguage());
String sex            =Util.fromScreen(request.getParameter("sex"),user.getLanguage());
int  accounttype      =Util.getIntValue(request.getParameter("accounttype"),0);

String resourceidfrom     =Util.fromScreen(request.getParameter("resourceidfrom"),user.getLanguage());
String resourceidto       =Util.fromScreen(request.getParameter("resourceidto"),user.getLanguage());
String workcode           =Util.fromScreen(request.getParameter("workcode"),user.getLanguage());
String jobcall            =Util.fromScreen(request.getParameter("jobcall"),user.getLanguage());
String mobile             =Util.fromScreen(request.getParameter("mobile"),user.getLanguage());
String mobilecall         =Util.fromScreen(request.getParameter("mobilecall"),user.getLanguage());
String fax                =Util.fromScreen(request.getParameter("fax"),user.getLanguage());
String email              =Util.fromScreen(request.getParameter("email"),user.getLanguage());
String folk               =Util.fromScreen(request.getParameter("folk"),user.getLanguage());
String nativeplace        =Util.fromScreen(request.getParameter("nativeplace"),user.getLanguage());
String regresidentplace   =Util.fromScreen(request.getParameter("regresidentplace"),user.getLanguage());
String maritalstatus      =Util.fromScreen(request.getParameter("maritalstatus"),user.getLanguage());
String certificatenum     =Util.fromScreen(request.getParameter("certificatenum"),user.getLanguage());
String tempresidentnumber =Util.fromScreen(request.getParameter("tempresidentnumber"),user.getLanguage());
String residentplace      =Util.fromScreen(request.getParameter("residentplace"),user.getLanguage());
String homeaddress        =Util.fromScreen(request.getParameter("homeaddress"),user.getLanguage());
String healthinfo         =Util.fromScreen(request.getParameter("healthinfo"),user.getLanguage());
String heightfrom         =Util.fromScreen(request.getParameter("heightfrom"),user.getLanguage());
String heightto           =Util.fromScreen(request.getParameter("heightto"),user.getLanguage());
String weightfrom         =Util.fromScreen(request.getParameter("weightfrom"),user.getLanguage());
String weightto           =Util.fromScreen(request.getParameter("weightto"),user.getLanguage());
String educationlevel     =Util.fromScreen(request.getParameter("educationlevel"),user.getLanguage());
String educationlevelTo     =Util.fromScreen(request.getParameter("educationlevelto"),user.getLanguage());
String degree             =Util.fromScreen(request.getParameter("degree"),user.getLanguage());
String usekind            =Util.fromScreen(request.getParameter("usekind"),user.getLanguage());
String policy             =Util.fromScreen(request.getParameter("policy"),user.getLanguage());
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

String groupid        =Util.fromScreen(request.getParameter("groupid"),user.getLanguage());
String groupVaild        =Util.fromScreen(request.getParameter("groupVaild"),user.getLanguage());
//自定义字段
String dff01name     =Util.fromScreen(request.getParameter("dff01name"),user.getLanguage());
String dff01nameto     =Util.fromScreen(request.getParameter("dff01nameto"),user.getLanguage());
String dff02name     =Util.fromScreen(request.getParameter("dff02name"),user.getLanguage());
String dff02nameto     =Util.fromScreen(request.getParameter("dff02nameto"),user.getLanguage());
String dff03name     =Util.fromScreen(request.getParameter("dff03name"),user.getLanguage());
String dff03nameto     =Util.fromScreen(request.getParameter("dff03nameto"),user.getLanguage());
String dff04name     =Util.fromScreen(request.getParameter("dff04name"),user.getLanguage());
String dff04nameto     =Util.fromScreen(request.getParameter("dff04nameto"),user.getLanguage());
String dff05name     =Util.fromScreen(request.getParameter("dff05name"),user.getLanguage());
String dff05nameto     =Util.fromScreen(request.getParameter("dff05nameto"),user.getLanguage());
String nff01name     =Util.fromScreen(request.getParameter("nff01name"),user.getLanguage());
String nff01nameto     =Util.fromScreen(request.getParameter("nff01nameto"),user.getLanguage());
String nff02name     =Util.fromScreen(request.getParameter("nff02name"),user.getLanguage());
String nff02nameto     =Util.fromScreen(request.getParameter("nff02nameto"),user.getLanguage());
String nff03name     =Util.fromScreen(request.getParameter("nff03name"),user.getLanguage());
String nff03nameto     =Util.fromScreen(request.getParameter("nff03nameto"),user.getLanguage());
String nff04name     =Util.fromScreen(request.getParameter("nff04name"),user.getLanguage());
String nff04nameto     =Util.fromScreen(request.getParameter("nff04nameto"),user.getLanguage());
String nff05name     =Util.fromScreen(request.getParameter("nff05name"),user.getLanguage());
String nff05nameto     =Util.fromScreen(request.getParameter("nff05nameto"),user.getLanguage());
String tff01name     =Util.fromScreen(request.getParameter("tff01name"),user.getLanguage());
String tff02name     =Util.fromScreen(request.getParameter("tff02name"),user.getLanguage());
String tff03name     =Util.fromScreen(request.getParameter("tff03name"),user.getLanguage());
String tff04name     =Util.fromScreen(request.getParameter("tff04name"),user.getLanguage());
String tff05name     =Util.fromScreen(request.getParameter("tff05name"),user.getLanguage());
String bff01name     =Util.fromScreen(request.getParameter("bff01name"),user.getLanguage());
String bff02name     =Util.fromScreen(request.getParameter("bff02name"),user.getLanguage());
String bff03name     =Util.fromScreen(request.getParameter("bff03name"),user.getLanguage());
String bff04name     =Util.fromScreen(request.getParameter("bff04name"),user.getLanguage());
String bff05name     =Util.fromScreen(request.getParameter("bff05name"),user.getLanguage());

int scopeId = 1;
CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",scopeId);
cfm.getCustomFields();
cfm.getCustomData(Util.getIntValue("0",0));
ArrayList fieldValueList = new ArrayList();
ArrayList fieldNameList = new ArrayList();
while(cfm.next()){
	String fieldname = "column_"+cfm.getId();
	String fieldvalue = Util.fromScreen(request.getParameter(fieldname),user.getLanguage());
	if(!"".equals(fieldvalue)){
		
		fieldNameList.add(fieldname);
		fieldValueList.add(fieldvalue);
	}
}



char separator = Util.getSeparator() ;

if(opera.equals("insert")){

String para = mouldname    + separator + userid        + separator + resourceid   + separator +
              resourcename + separator + jobtitle      + separator + activitydesc + separator +
              jobgroup     + separator + jobactivity   + separator + costcenter   + separator +
              competency   + separator + resourcetype  + separator + status       + separator +
              subcompany1  + separator + department    + separator + location     + separator +
              manager      + separator + assistant     + separator + roles        + separator +
              seclevel     + separator + joblevel      + separator + workroom     + separator +
              telephone    + separator + startdate     + separator + enddate      + separator +
              contractdate + separator + birthday      + separator + sex          + separator +
              seclevelTo   + separator + joblevelTo    + separator + startdateTo  + separator +
              enddateTo    + separator + contractdateTo+ separator + birthdayTo   + separator +
              age                + separator + ageTo            + separator + resourceidfrom + separator +
              resourceidto       + separator + workcode         + separator + jobcall        + separator +
              mobile             + separator + mobilecall       + separator + fax            + separator +
              email              + separator + folk             + separator + nativeplace    + separator +
              regresidentplace   + separator + maritalstatus    + separator + certificatenum + separator +
              tempresidentnumber + separator + residentplace    + separator + homeaddress    + separator +
              healthinfo         + separator + heightfrom       + separator + heightto       + separator +
              weightfrom         + separator + weightto         + separator + educationlevel + separator +
              degree             + separator + usekind          + separator + policy         + separator +
              bememberdatefrom   + separator + bememberdateto   + separator + bepartydatefrom+ separator +
              bepartydateto      + separator + islabouunion     + separator + bankid1        + separator +
              accountid1         + separator + accumfundaccount + separator + loginid        + separator +
              systemlanguage     + separator + birthdayYear     + separator + birthdayMonth  + separator +
              birthdayDay        + separator + educationlevelTo + separator + accounttype;
	RecordSet.executeProc("HrmSearchMould_Insert",para);
	if(RecordSet.next()){
		id = RecordSet.getInt(1);
	}
  	RecordSet.executeSql("UPDATE HrmSearchMould set groupid='"+groupid+"',groupVaild='"+groupVaild+"' where id = "+id);
  	
	para = ""+id;
  para += separator+dff01name + separator+ dff02name + separator+  dff03name + separator+  dff04name + separator+ dff05name + separator+ dff01nameto + separator+ dff02nameto + separator+ dff03nameto + separator+ dff04nameto + separator+ dff05nameto + separator+ nff01name + separator+ nff02name +separator+ nff03name + separator+ nff04name + separator+ nff05name + separator+ nff01nameto + separator+ nff02nameto + separator+ nff03nameto + separator+ nff04nameto + separator+ nff05nameto + separator+ tff01name + separator+ tff02name + separator+tff03name+separator+tff04name+separator+tff05name+ separator+ bff01name + separator+ bff02name + separator+ bff03name + separator+ bff04name + separator+ bff05name;
  rs.executeProc("HrmSearchMouldDefine_Update",para);
  for(int i=0;i<fieldNameList.size();i++){
  	rs.executeSql("UPDATE HrmSearchMould set "+fieldNameList.get(i)+" = "+"'"+fieldValueList.get(i)+"' where id = "+id);
  }
	response.sendRedirect("HrmResourceSearch.jsp?cmd=changeMould&mouldid="+id);
}

if(opera.equals("update")){
//String para = ""+id+separator+userid + separator + resourceid + separator + resourcename + separator + jobtitle   + separator + activitydesc + separator + jobgroup   + separator + jobactivity + separator + costcenter + separator + competency + separator + resourcetype + separator + status       + separator + subcompany1 + separator + subcompany2 + separator + subcompany3 + separator + subcompany4 + separator + department + separator + location   + separator + manager    + separator + assistant  + separator + roles      + separator + seclevel  + separator + joblevel  + separator + workroom     + separator + telephone    + separator + startdate  + separator + enddate    + separator + contractdate + separator + birthday   + separator + sex+ separator + seclevelTo+ separator + joblevelTo+ separator + startdateTo+ separator + enddateTo+ separator + contractdateTo+ separator + birthdayTo+ separator + age+ separator + ageTo;

String para = ""+id        + separator + userid        + separator + resourceid   + separator +
              resourcename + separator + jobtitle      + separator + activitydesc + separator +
              jobgroup     + separator + jobactivity   + separator + costcenter   + separator +
              competency   + separator + resourcetype  + separator + status       + separator +
              subcompany1  + separator + department    + separator + location     + separator +
              manager      + separator + assistant     + separator + roles        + separator +
              seclevel     + separator + joblevel      + separator + workroom     + separator +
              telephone    + separator + startdate     + separator + enddate      + separator +
              contractdate + separator + birthday      + separator + sex          + separator +
              seclevelTo   + separator + joblevelTo    + separator + startdateTo  + separator +
              enddateTo    + separator + contractdateTo+ separator + birthdayTo   + separator +
              age                + separator + ageTo            + separator + resourceidfrom + separator +
              resourceidto       + separator + workcode         + separator + jobcall        + separator +
              mobile             + separator + mobilecall       + separator + fax            + separator +
              email              + separator + folk             + separator + nativeplace    + separator +
              regresidentplace   + separator + maritalstatus    + separator + certificatenum + separator +
              tempresidentnumber + separator + residentplace    + separator + homeaddress    + separator +
              healthinfo         + separator + heightfrom       + separator + heightto       + separator +
              weightfrom         + separator + weightto         + separator + educationlevel + separator +
              degree             + separator + usekind          + separator + policy         + separator +
              bememberdatefrom   + separator + bememberdateto   + separator + bepartydatefrom+ separator +
              bepartydateto      + separator + islabouunion     + separator + bankid1        + separator +
              accountid1         + separator + accumfundaccount + separator + loginid        + separator +
              systemlanguage     + separator + birthdayYear     + separator + birthdayMonth  + separator +
              birthdayDay        + separator + educationlevelTo + separator + accounttype;

	RecordSet.executeProc("HrmSearchMould_Update",para);
	
  	RecordSet.executeSql("UPDATE HrmSearchMould set groupid='"+groupid+"',groupVaild='"+groupVaild+"' where id = "+id);
  	
	para = ""+id;
        para += separator+dff01name + separator+ dff02name + separator+  dff03name + separator+  dff04name + separator+ dff05name + separator+ dff01nameto + separator+ dff02nameto + separator+ dff03nameto + separator+ dff04nameto + separator+ dff05nameto + separator+ nff01name + separator+ nff02name +separator+ nff03name + separator+ nff04name + separator+ nff05name + separator+ nff01nameto + separator+ nff02nameto + separator+ nff03nameto + separator+ nff04nameto + separator+ nff05nameto + separator+ tff01name + separator+ tff02name + separator+tff03name+separator+tff04name+separator+tff05name+ separator+ bff01name + separator+ bff02name + separator+ bff03name + separator+ bff04name + separator+ bff05name;
        rs.executeProc("HrmSearchMouldDefine_Update",para);
response.sendRedirect("HrmResourceSearch.jsp?mouldid="+id);

}
if(opera.equals("delete")){
String para = ""+id;
	RecordSet.executeProc("HrmSearchMould_Delete",para);
	response.sendRedirect("HrmResourceSearch.jsp?cmd=changeMould&mouldid=0");
}

%>