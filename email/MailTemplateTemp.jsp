
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hrm" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="dept" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="comp" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="job" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page"/>
<%
User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;
String templateType = Util.null2String(request.getParameter("templateType"));
String userId = Util.null2String(request.getParameter("userId"));
String hrmName = "", hrmDepartment = "", hrmSubcompany = "", hrmCompany = "", hrmPost = "", hrmAddress = "";
String hrmOffice = "", hrmTelOffice = "", hrmMobile = "", hrmTelOther = "", hrmFax = "", hrmMail = "";
String templateSubject = "", templateContent = "";
String sql = "";

//=================== Sender ===================
hrmName = hrm.getResourcename(userId);
hrmDepartment = dept.getDepartmentname(hrm.getDepartmentID(userId));
hrmSubcompany = comp.getSubCompanyname(dept.getSubcompanyid1(hrm.getDepartmentID(userId)));
hrmCompany = "";
hrmPost = job.getJobTitlesname(hrm.getJobTitle(userId));
hrmAddress = "";
hrmOffice = "";
hrmTelOffice = hrm.getTelephone(userId);
hrmMobile = hrm.getMobile(userId);
hrmTelOther = "";
hrmFax = "";
hrmMail = hrm.getEmail(userId);

if(templateType.equals("0")){
	sql = "SELECT templateSubject, templateContent FROM MailTemplate WHERE id="+Util.getIntValue(request.getParameter("id"))+"";
}else{
	sql = "SELECT mouldSubject AS templateSubject, mouldtext AS templateContent FROM DocMailMould WHERE id="+Util.getIntValue(request.getParameter("id"))+"";
}
rs.executeSql(sql);
if(rs.next()){
	templateSubject = rs.getString("templateSubject");
	templateContent = rs.getString("templateContent").replaceAll("<script>","&lt;script&gt;").replaceAll("</script>","&lt;/script&gt;");

	int oldpicnum = 0;
	int pos = templateContent.indexOf("<IMG alt=");
	while(pos!=-1){
		String tempStr = templateContent.substring(0, pos+9);
		tempStr += "docimages_" + oldpicnum;
		int srcPos = templateContent.indexOf(" src=", pos+9);
		tempStr += templateContent.substring(srcPos);
		templateContent = tempStr;

		pos = templateContent.indexOf("?fileid=",pos);
		if(pos==-1) continue;
		int endpos = templateContent.indexOf("\"",pos);
		String tmpid = templateContent.substring(pos+8,endpos);
		int startpos = templateContent.lastIndexOf("\"",pos);
		String servername = request.getHeader("host");
		String tmpcontent = templateContent.substring(0,startpos+1);
		tmpcontent += "http://"+servername;
		tmpcontent += templateContent.substring(startpos+1);
		templateContent = tmpcontent;
		pos = templateContent.indexOf("<IMG alt=",endpos);
		oldpicnum += 1;
	}

	//=================== Macro Replace ===================
	rs.executeSql("select * from HrmResource where id="+userId);
	if(rs.next()) { 
		templateContent = Util.replace(templateContent, "\\$HRM_Loginid", rs.getString("loginid"), 0, true);
		templateContent = Util.replace(templateContent, "\\$HRM_Name", rs.getString("lastname"), 0, true);
		templateContent = Util.replace(templateContent, "\\$HRM_Title", rs.getString("titleid"), 0, true);
		templateContent = Util.replace(templateContent, "\\$HRM_Birthday", rs.getString("birthday"), 0, true);
		templateContent = Util.replace(templateContent, "\\$HRM_Telephone", rs.getString("telephone"), 0, true);
		templateContent = Util.replace(templateContent, "\\$HRM_Mobile", rs.getString("mobile"), 0, true);
		templateContent = Util.replace(templateContent, "\\$HRM_Email", rs.getString("email"), 0, true);
		templateContent = Util.replace(templateContent, "\\$HRM_Startdate", rs.getString("startdate"), 0, true);
		templateContent = Util.replace(templateContent, "\\$HRM_Enddate", rs.getString("enddate"), 0, true);
		templateContent = Util.replace(templateContent, "\\$HRM_Contractdate", rs.getString("contractdate"), 0, true);
		templateContent = Util.replace(templateContent, "\\$HRM_Jobtitle", JobTitlesComInfo.getJobTitlesname(rs.getString("jobtitle")), 0, true);
		templateContent = Util.replace(templateContent, "\\$HRM_Jobgroup", rs.getString("jobgroup"), 0, true);
		templateContent = Util.replace(templateContent, "\\$HRM_Jobactivitydesc", rs.getString("jobactivitydesc"), 0, true);
		templateContent = Util.replace(templateContent, "\\$HRM_Jobactivity", Util.toScreen(JobActivitiesComInfo.getJobActivitiesname(JobTitlesComInfo.getJobactivityid(rs.getString("jobactivity"))),user.getLanguage()), 0, true);
		templateContent = Util.replace(templateContent, "\\$HRM_Joblevel", rs.getString("joblevel"), 0, true);
		templateContent = Util.replace(templateContent, "\\$HRM_Seclevel", rs.getString("seclevel"), 0, true);
		templateContent = Util.replace(templateContent, "\\$HRM_Department", hrmDepartment, 0, true); 
		templateContent = Util.replace(templateContent, "\\$HRM_Costcenter", rs.getString("costcenterid"), 0, true);
		templateContent = Util.replace(templateContent, "\\$HRM_Manager", hrm.getResourcename(rs.getString("managerid")), 0, true);
		templateContent = Util.replace(templateContent, "\\$HRM_Assistant", hrm.getResourcename(rs.getString("assistantid")), 0, true);
  
	}
	out.println("@@@"+templateSubject+"@@@"+templateContent);
}
%>