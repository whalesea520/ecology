<%@ page import="weaver.general.Util,weaver.docs.docs.CustomFieldManager" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<%
String userid = Util.null2String(request.getParameter("userid"));
String returnurl = Util.null2String(request.getParameter("returnurl"));
char separator = Util.getSeparator() ;
RecordSet.executeProc("HrmResRpDefine_Delete",userid);
String para = "";

int workcode     = Util.getIntValue(request.getParameter("workcode"),0);
para = userid+separator+ "workcode"+separator+workcode+separator+ SystemEnv.getHtmlLabelName(714,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int lastname= Util.getIntValue(request.getParameter("lastname"),0);
para = userid+separator+ "lastname"+separator+lastname+separator+ SystemEnv.getHtmlLabelName(413,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int sex         = Util.getIntValue(request.getParameter("sex"),0);
para = userid+separator+ "sex"+separator+sex+separator+ SystemEnv.getHtmlLabelName(416,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int departmentid  = Util.getIntValue(request.getParameter("departmentid"),0);
para = userid+separator+ "departmentid"+separator+departmentid+separator+ SystemEnv.getHtmlLabelName(124,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int subcompanyid1  = Util.getIntValue(request.getParameter("subcompanyid1"),0);
para = userid+separator+ "subcompanyid1"+separator+subcompanyid1+separator+ SystemEnv.getHtmlLabelName(141,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int costcenterid  = Util.getIntValue(request.getParameter("costcenterid"),0);
para = userid+separator+ "costcenterid"+separator+costcenterid+separator+ SystemEnv.getHtmlLabelName(515,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int status      = Util.getIntValue(request.getParameter("status"),0);
para = userid+separator+ "status"+separator+status+separator+ SystemEnv.getHtmlLabelName(602,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int jobtitle    = Util.getIntValue(request.getParameter("jobtitle"),0);
para = userid+separator+ "jobtitle"+separator+jobtitle+separator+ SystemEnv.getHtmlLabelName(6086,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int jobgroup    = Util.getIntValue(request.getParameter("jobgroup"),0);
para = userid+separator+ "jobgroup"+separator+jobgroup+separator+ SystemEnv.getHtmlLabelName(805,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int jobactivity = Util.getIntValue(request.getParameter("jobactivity"),0);
para = userid+separator+ "jobactivity"+separator+jobactivity+separator+ SystemEnv.getHtmlLabelName(1915,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int jobcall     = Util.getIntValue(request.getParameter("jobcall"),0);
para = userid+separator+ "jobcall"+separator+jobcall+separator+ SystemEnv.getHtmlLabelName(806,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int joblevel    = Util.getIntValue(request.getParameter("joblevel"),0);
para = userid+separator+ "joblevel"+separator+joblevel+separator+ SystemEnv.getHtmlLabelName(1909,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int managerid     = Util.getIntValue(request.getParameter("managerid"),0);
para = userid+separator+ "managerid"+separator+managerid+separator+ SystemEnv.getHtmlLabelName(15709,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int assistantid   = Util.getIntValue(request.getParameter("assistantid"),0);
para = userid+separator+ "assistantid"+separator+assistantid+separator+ SystemEnv.getHtmlLabelName(441,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int locationid    = Util.getIntValue(request.getParameter("locationid"),0);
para = userid+separator+ "locationid"+separator+locationid+separator+ SystemEnv.getHtmlLabelName(15712,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int workroom    = Util.getIntValue(request.getParameter("workroom"),0);
para = userid+separator+ "workroom"+separator+workroom+separator+ SystemEnv.getHtmlLabelName(420,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int telephone   = Util.getIntValue(request.getParameter("telephone"),0);
para = userid+separator+ "telephone"+separator+telephone+separator+ SystemEnv.getHtmlLabelName(421,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int mobile     = Util.getIntValue(request.getParameter("mobile"),0);
para = userid+separator+ "mobile"+separator+mobile+separator+ SystemEnv.getHtmlLabelName(422,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int mobilecall     = Util.getIntValue(request.getParameter("mobilecall"),0);
para = userid+separator+ "mobilecall"+separator+mobilecall+separator+ SystemEnv.getHtmlLabelName(15714,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int fax     = Util.getIntValue(request.getParameter("fax"),0);
para = userid+separator+ "fax"+separator+fax+separator+ SystemEnv.getHtmlLabelName(494,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int email     = Util.getIntValue(request.getParameter("email"),0);
para = userid+separator+ "email"+separator+email+separator+ SystemEnv.getHtmlLabelName(477,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);


int birthday    = Util.getIntValue(request.getParameter("birthday"),0);
para = userid+separator+ "birthday"+separator+birthday+separator+ SystemEnv.getHtmlLabelName(464,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int age         = Util.getIntValue(request.getParameter("age"),0);
para = userid+separator+ "age"+separator+age+separator+ SystemEnv.getHtmlLabelName(671,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int folk     = Util.getIntValue(request.getParameter("folk"),0);
para = userid+separator+ "folk"+separator+folk+separator+ SystemEnv.getHtmlLabelName(1886,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int nativeplace     = Util.getIntValue(request.getParameter("nativeplace"),0);
para = userid+separator+ "nativeplace"+separator+nativeplace+separator+ SystemEnv.getHtmlLabelName(1840,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int regresidentplace     = Util.getIntValue(request.getParameter("regresidentplace"),0);
para = userid+separator+ "regresidentplace"+separator+regresidentplace+separator+ SystemEnv.getHtmlLabelName(15683,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int maritalstatus     = Util.getIntValue(request.getParameter("maritalstatus"),0);
para = userid+separator+ "maritalstatus"+separator+maritalstatus+separator+ SystemEnv.getHtmlLabelName(469,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int certificatenum     = Util.getIntValue(request.getParameter("certificatenum"),0);
para = userid+separator+ "certificatenum"+separator+certificatenum+separator+ SystemEnv.getHtmlLabelName(1887,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int tempresidentnumber     = Util.getIntValue(request.getParameter("tempresidentnumber"),0);
para = userid+separator+ "tempresidentnumber"+separator+tempresidentnumber+separator+ SystemEnv.getHtmlLabelName(15685,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int residentplace     = Util.getIntValue(request.getParameter("residentplace"),0);
para = userid+separator+ "residentplace"+separator+residentplace+separator+ SystemEnv.getHtmlLabelName(1829,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int homeaddress     = Util.getIntValue(request.getParameter("homeaddress"),0);
para = userid+separator+ "homeaddress"+separator+homeaddress+separator+ SystemEnv.getHtmlLabelName(16015,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int healthinfo     = Util.getIntValue(request.getParameter("healthinfo"),0);
para = userid+separator+ "healthinfo"+separator+healthinfo+separator+ SystemEnv.getHtmlLabelName(1827,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int height     = Util.getIntValue(request.getParameter("height"),0);
para = userid+separator+ "height"+separator+height+separator+ SystemEnv.getHtmlLabelName(1826,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int weight     = Util.getIntValue(request.getParameter("weight"),0);
para = userid+separator+ "weight"+separator+weight+separator+ SystemEnv.getHtmlLabelName(15674,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int educationlevel     = Util.getIntValue(request.getParameter("educationlevel"),0);
para = userid+separator+ "educationlevel"+separator+educationlevel+separator+ SystemEnv.getHtmlLabelName(818,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int degree     = Util.getIntValue(request.getParameter("degree"),0);
para = userid+separator+ "degree"+separator+degree+separator+ SystemEnv.getHtmlLabelName(1833,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int usekind     = Util.getIntValue(request.getParameter("usekind"),0);
para = userid+separator+ "usekind"+separator+usekind+separator+ SystemEnv.getHtmlLabelName(804,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int policy     = Util.getIntValue(request.getParameter("policy"),0);
para = userid+separator+ "policy"+separator+policy+separator+ SystemEnv.getHtmlLabelName(1837,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int bememberdate     = Util.getIntValue(request.getParameter("bememberdate"),0);
para = userid+separator+ "bememberdate"+separator+bememberdate+separator+ SystemEnv.getHtmlLabelName(1834,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int bepartydate     = Util.getIntValue(request.getParameter("bepartydate"),0);
para = userid+separator+ "bepartydate"+separator+bepartydate+separator+ SystemEnv.getHtmlLabelName(1835,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int roles       = Util.getIntValue(request.getParameter("roles"),0);
para = userid+separator+ "roles"+separator+roles+separator+ SystemEnv.getHtmlLabelName(122,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int islabouunion     = Util.getIntValue(request.getParameter("islabouunion"),0);
para = userid+separator+ "islabouunion"+separator+islabouunion+separator+ SystemEnv.getHtmlLabelName(15684,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int startdate   = Util.getIntValue(request.getParameter("startdate"),0);
para = userid+separator+ "startdate"+separator+startdate+separator+ SystemEnv.getHtmlLabelName(1970,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int enddate     = Util.getIntValue(request.getParameter("enddate"),0);
para = userid+separator+ "enddate"+separator+enddate+separator+ SystemEnv.getHtmlLabelName(15236,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int probationenddate = Util.getIntValue(request.getParameter("probationenddate"),0);
para = userid+separator+ "probationenddate"+separator+probationenddate+separator+ SystemEnv.getHtmlLabelName(15778,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);


int bankid1     = Util.getIntValue(request.getParameter("bankid1"),0);
para = userid+separator+ "bankid1"+separator+bankid1+separator+ SystemEnv.getHtmlLabelName(15812,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int accountid1     = Util.getIntValue(request.getParameter("accountid1"),0);
para = userid+separator+ "accountid1"+separator+accountid1+separator+ SystemEnv.getHtmlLabelName(16016,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int accumfundaccount     = Util.getIntValue(request.getParameter("accumfundaccount"),0);
para = userid+separator+ "accumfundaccount"+separator+accumfundaccount+separator+ SystemEnv.getHtmlLabelName(1939,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);


int loginid     = Util.getIntValue(request.getParameter("loginid"),0);
para = userid+separator+ "loginid"+separator+loginid+separator+ SystemEnv.getHtmlLabelName(16017,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

int seclevel    = Util.getIntValue(request.getParameter("seclevel"),0);
para = userid+separator+ "seclevel"+separator+seclevel+separator+ SystemEnv.getHtmlLabelName(683,user.getLanguage()) ;
RecordSet.executeProc("HrmResRpDefine_Insert",para);

String dff01use = "";
String dff02use = "";
String dff03use = "";
String dff04use = "";
String dff05use = "";
String tff01use = "";
String tff02use = "";
String tff03use = "";
String tff04use = "";
String tff05use = "";
String nff01use = "";
String nff02use = "";
String nff03use = "";
String nff04use = "";
String nff05use = "";
String bff01use = "";
String bff02use = "";
String bff03use = "";
String bff04use = "";
String bff05use = "";

boolean hasFF = true;
rs2.executeProc("Base_FreeField_Select","hr");
if(rs2.getCounts()<=0){
	hasFF = false;
}else{
	rs2.first();
	dff01use=rs2.getString("dff01use");
	dff02use=rs2.getString("dff02use");
	dff03use=rs2.getString("dff03use");
	dff04use=rs2.getString("dff04use");
	dff05use=rs2.getString("dff05use");
	tff01use=rs2.getString("tff01use");
	tff02use=rs2.getString("tff02use");
	tff03use=rs2.getString("tff03use");
	tff04use=rs2.getString("tff04use");
	tff05use=rs2.getString("tff05use");
	bff01use=rs2.getString("bff01use");
	bff02use=rs2.getString("bff02use");
	bff03use=rs2.getString("bff03use");
	bff04use=rs2.getString("bff04use");
	bff05use=rs2.getString("bff05use");
	nff01use=rs2.getString("nff01use");
	nff02use=rs2.getString("nff02use");
	nff03use=rs2.getString("nff03use");
	nff04use=rs2.getString("nff04use");
	nff05use=rs2.getString("nff05use");
}
if(hasFF){
	if(dff01use.equals("1")){
		int dff01name    = Util.getIntValue(request.getParameter("dff01name"),0);
		para = userid+separator+ "datefield1"+separator+dff01name+separator + rs2.getString("dff01name") ;
		RecordSet.executeProc("HrmResRpDefine_Insert",para);
	}
	if(dff02use.equals("1")){
		int dff02name    = Util.getIntValue(request.getParameter("dff02name"),0);
		para = userid+separator+ "datefield2"+separator+dff02name+separator + rs2.getString("dff02name") ;
		RecordSet.executeProc("HrmResRpDefine_Insert",para);
	}
	if(dff03use.equals("1")){
		int dff03name    = Util.getIntValue(request.getParameter("dff03name"),0);
		para = userid+separator+ "datefield3"+separator+dff03name+separator + rs2.getString("dff03name") ;
		RecordSet.executeProc("HrmResRpDefine_Insert",para);
	}
	if(dff04use.equals("1")){
		int dff04name    = Util.getIntValue(request.getParameter("dff04name"),0);
		para = userid+separator+ "datefield4"+separator+dff04name+separator + rs2.getString("dff04name") ;
		RecordSet.executeProc("HrmResRpDefine_Insert",para);
	}
	if(dff05use.equals("1")){
		int dff05name    = Util.getIntValue(request.getParameter("dff05name"),0);
		para = userid+separator+ "datefield5"+separator+dff05name+separator + rs2.getString("dff05name") ;
		RecordSet.executeProc("HrmResRpDefine_Insert",para);
	}
	if(tff01use.equals("1")){
		int tff01name    = Util.getIntValue(request.getParameter("tff01name"),0);
		para = userid+separator+ "textfield1"+separator+tff01name+separator + rs2.getString("tff01name") ;
		RecordSet.executeProc("HrmResRpDefine_Insert",para);
	}
	if(tff02use.equals("1")){
		int tff02name    = Util.getIntValue(request.getParameter("tff02name"),0);
		para = userid+separator+ "textfield2"+separator+tff02name+separator + rs2.getString("tff02name") ;
		RecordSet.executeProc("HrmResRpDefine_Insert",para);
	}
	if(tff03use.equals("1")){
		int tff03name    = Util.getIntValue(request.getParameter("tff03name"),0);
		para = userid+separator+ "textfield3"+separator+tff03name+separator + rs2.getString("tff03name") ;
		RecordSet.executeProc("HrmResRpDefine_Insert",para);
	}
	if(tff04use.equals("1")){
		int tff04name    = Util.getIntValue(request.getParameter("tff04name"),0);
		para = userid+separator+ "textfield4"+separator+tff04name+separator + rs2.getString("tff04name") ;
		RecordSet.executeProc("HrmResRpDefine_Insert",para);
	}
	if(tff05use.equals("1")){
		int tff05name    = Util.getIntValue(request.getParameter("tff05name"),0);
		para = userid+separator+ "textfield5"+separator+tff05name+separator + rs2.getString("tff05name") ;
		RecordSet.executeProc("HrmResRpDefine_Insert",para);
	}
	if(bff01use.equals("1")){
		int bff01name    = Util.getIntValue(request.getParameter("bff01name"),0);
		para = userid+separator+ "tinyintfield1"+separator+bff01name+separator + rs2.getString("bff01name") ;
		RecordSet.executeProc("HrmResRpDefine_Insert",para);
	}
	if(bff02use.equals("1")){
		int bff02name    = Util.getIntValue(request.getParameter("bff02name"),0);
		para = userid+separator+ "tinyintfield2"+separator+bff02name+separator + rs2.getString("bff02name") ;
		RecordSet.executeProc("HrmResRpDefine_Insert",para);
	}
	if(bff03use.equals("1")){
		int bff03name    = Util.getIntValue(request.getParameter("bff03name"),0);
		para = userid+separator+ "tinyintfield3"+separator+bff03name+separator + rs2.getString("bff03name") ;
		RecordSet.executeProc("HrmResRpDefine_Insert",para);
	}
	if(bff04use.equals("1")){
		int bff04name    = Util.getIntValue(request.getParameter("bff04name"),0);
		para = userid+separator+ "tinyintfield4"+separator+bff04name+separator + rs2.getString("bff04name") ;
		RecordSet.executeProc("HrmResRpDefine_Insert",para);
	}
	if(bff05use.equals("1")){
		int bff05name    = Util.getIntValue(request.getParameter("bff05name"),0);
		para = userid+separator+ "tinyintfield5"+separator+bff05name+separator + rs2.getString("bff05name") ;
		RecordSet.executeProc("HrmResRpDefine_Insert",para);
	}
	if(nff01use.equals("1")){
		int nff01name    = Util.getIntValue(request.getParameter("nff01name"),0);
		para = userid+separator+ "numberfield1"+separator+nff01name+separator + rs2.getString("nff01name") ;
		RecordSet.executeProc("HrmResRpDefine_Insert",para);
	}
	if(nff02use.equals("1")){
		int nff02name    = Util.getIntValue(request.getParameter("nff02name"),0);
		para = userid+separator+ "numberfield2"+separator+nff02name+separator + rs2.getString("nff02name") ;
		RecordSet.executeProc("HrmResRpDefine_Insert",para);
	}
	if(nff03use.equals("1")){
		int nff03name    = Util.getIntValue(request.getParameter("nff03name"),0);
		para = userid+separator+ "numberfield3"+separator+nff03name+separator + rs2.getString("nff03name") ;
		RecordSet.executeProc("HrmResRpDefine_Insert",para);
	}
	if(nff04use.equals("1")){
		int nff04name    = Util.getIntValue(request.getParameter("nff04name"),0);
		para = userid+separator+ "numberfield4"+separator+nff04name+separator + rs2.getString("nff04name") ;
		RecordSet.executeProc("HrmResRpDefine_Insert",para);
	}
	if(nff05use.equals("1")){
		int nff05name    = Util.getIntValue(request.getParameter("nff05name"),0);
		para = userid+separator+ "numberfield5"+separator+nff05name+separator + rs2.getString("nff05name") ;
		RecordSet.executeProc("HrmResRpDefine_Insert",para);
	}
}

Enumeration en =request.getParameterNames();
CustomFieldManager cfm = new CustomFieldManager("HrmCustomFieldByInfoType",1);
while(en.hasMoreElements()){
    String paramName=(String)en.nextElement();
    if(paramName.indexOf("field")>-1) {
     cfm.getCustomFields(Util.getIntValue(paramName.substring(5),0));
        cfm.next();
       // System.out.println(paramName+":"+cfm.getLable());   
     para = userid+separator+ paramName+separator+Util.getIntValue(request.getParameter(paramName),0)+separator+ cfm.getLable() ;
     RecordSet.executeProc("HrmResRpDefine_Insert",para);
    }
}

	
response.sendRedirect("/hrm/report/resource/HrmRpResource.jsp");


%>
