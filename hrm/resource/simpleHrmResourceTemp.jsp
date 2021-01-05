
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.hrm.HrmUserVarify" %><%@ page import="weaver.hrm.*" %><%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="AppDetachComInfo" class="weaver.hrm.appdetach.AppDetachComInfo" scope="page"/>
<jsp:useBean id="PluginUserCheck" class="weaver.license.PluginUserCheck" scope="page" />
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = (User)request.getSession(true).getAttribute("weaver_user@bean") ;

if(user==null) return;
String id = request.getParameter("userid");
String ip = HrmUserVarify.getOnlineUserIp(id);

if(AppDetachComInfo.checkUserAppDetach(id, "1", user)==0) {
	out.print("$$$noright");
	return;
}

if("".equals(ip)) 
{
	ip = ",";
}

RecordSet.executeProc("HrmResource_SelectByID",id);
RecordSet.next();
String workcode = Util.toScreen(RecordSet.getString("workcode"),user.getLanguage()) ;			/*姓名*/
String lastname = Util.toScreen(RecordSet.getString("lastname"),user.getLanguage()) ;			/*姓名*/
String sex = Util.toScreen(RecordSet.getString("sex"),user.getLanguage()) ;
String departmentid = Util.toScreen(RecordSet.getString("departmentid"),user.getLanguage()) ;		/*所属部门*/
String subcompanyid1 = Util.toScreen(RecordSet.getString("subcompanyid1"),user.getLanguage()) ;		/*所属分部*/
String jobtitle = Util.toScreen(RecordSet.getString("jobtitle"),user.getLanguage()) ;		/*所属分部*/
String status = Util.toScreen(RecordSet.getString("status"),user.getLanguage()) ;		/*所属分部*/
String locationid = Util.toScreen(RecordSet.getString("locationid"),user.getLanguage()) ;		/*办公地点*/
locationid = Util.toScreen(LocationComInfo.getLocationname(locationid),user.getLanguage());
departmentid=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage());
subcompanyid1=Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcompanyid1),user.getLanguage());
if(jobtitle.length()>0)jobtitle=Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitle),user.getLanguage());
if(status.equals("0")){
	status = SystemEnv.getHtmlLabelName(15710,user.getLanguage());
}else if(status.equals("1")){
	status = SystemEnv.getHtmlLabelName(15711,user.getLanguage());
}else if(status.equals("2")){
	status = SystemEnv.getHtmlLabelName(480,user.getLanguage());
}else if(status.equals("3")){
	status = SystemEnv.getHtmlLabelName(15844,user.getLanguage());
}else if(status.equals("4")){
	status = SystemEnv.getHtmlLabelName(6094,user.getLanguage());
}else if(status.equals("5")){
	status = SystemEnv.getHtmlLabelName(6091,user.getLanguage());
}else if(status.equals("6")){
	status = SystemEnv.getHtmlLabelName(6092,user.getLanguage());
}else if(status.equals("7")){
	status = SystemEnv.getHtmlLabelName(2245,user.getLanguage());
}else if(status.equals("10")){
	status = SystemEnv.getHtmlLabelName(1831,user.getLanguage());
}

if("0".equals(sex))
{
	sex = "Mr.";
}
else if("1".equals(sex))
{
	sex="Ms.";	
}
String jobactivitydesc = Util.toScreen(RecordSet.getString("jobactivitydesc"),user.getLanguage()) ;	/*职责描述*/
String telephone = Util.toScreen(RecordSet.getString("telephone"),user.getLanguage()) ;			/*办公电话*/
//String mobile = Util.toScreen(RecordSet.getString("mobile"),user.getLanguage()) ;			/*移动电话*/
String mobile = ResourceComInfo.getMobileShow(id, user) ;			/*移动电话*/

String email = Util.toScreen(RecordSet.getString("email"),user.getLanguage()) ;				/*电邮*/

String resourceimageid = Util.getFileidOut(RecordSet.getString("resourceimageid")) ;	/*照片id 由SequenceIndex表得到，和使用它的表相关联*/
String managerid = Util.toScreen(RecordSet.getString("managerid"),user.getLanguage()) ;			/*直接上级*/
managerid=Util.toScreen(ResourceComInfo.getResourcename(managerid),user.getLanguage());
if("".equals(lastname)||null==lastname)
{
	String sql = "select * from HrmResourceManager where id="+id;	
	RecordSet.execute(sql);
	RecordSet.next();
	lastname = Util.toScreen(RecordSet.getString("lastname"),user.getLanguage()) ;
	sex = "Mr.";
}
if("".equals(workcode))
{
	workcode = ",";
}
if("".equals(lastname))
{
	lastname = ",";
}
if("".equals(sex))
{
	sex = ",";
}
if("".equals(mobile))
{
	mobile = ",";
}
if("".equals(telephone))
{
	telephone = ",";
}
if("".equals(email))
{
	email = ",";
}
if("".equals(departmentid))
{
	departmentid = ",";
}
if("".equals(subcompanyid1))
{
	subcompanyid1 = ",";
}
if("".equals(jobtitle))
{
	jobtitle = ",";
}
if("".equals(status))
{
	status = ",";
}
if("".equals(locationid))
{
	locationid = ",";
}
if("".equals(jobactivitydesc))
{
	jobactivitydesc = ",";
}

String messager = "";
if((PluginUserCheck.getPluginAllUserId("messager").indexOf(id)!=-1)&&Util.getIntValue(id)!=user.getUID()){
	//messager = "messager";
}

if(managerid.length()==0){
	managerid = ",";
}

if(resourceimageid.length()==0) {
	resourceimageid = ",";
}

//System.out.println("resourceimageid : "+resourceimageid);
out.print("$$$ip="+ip+"$$$"+lastname+"$$$"+sex+"$$$"+mobile+"$$$"+telephone+"$$$"+email+"$$$"+departmentid+"$$$"+managerid+"$$$imageid="+resourceimageid+"$$$"+subcompanyid1+"$$$"+jobtitle+"$$$"+status+"$$$"+locationid+"$$$"+workcode);
%>