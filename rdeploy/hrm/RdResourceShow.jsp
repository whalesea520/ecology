<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobtitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="RdeployHrmSetting" class="weaver.rdeploy.hrm.RdeployHrmSetting" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

String id = Util.null2String(request.getParameter("id"));

String adminId = Util.null2String(RdeployHrmSetting.getSettingInfo("admin"));
//String adminId = "64228";
//String onoff = "2";
boolean canRe =false;
if(adminId.equals(id)){
  canRe=true;
}

String language = Util.null2String(request.getParameter("language"));
String type = Util.null2String(request.getParameter("type"));

String messageUrl = ResourceComInfo.getMessagerUrls(id);
String name = ResourceComInfo.getLastname(id);
String sex = ResourceComInfo.getSexs(id);
String depId = ResourceComInfo.getDepartmentID(id);
String jobId = ResourceComInfo.getJobTitle(id);
String managerId = ResourceComInfo.getManagerID(id);
String mobile = ResourceComInfo.getMobile(id);
String phone = ResourceComInfo.getTelephone(id);
String email = ResourceComInfo.getEmail(id);
String status = ResourceComInfo.getStatus(id);
String states = ResourceComInfo.getStatusName(status,language);
if("7".equals(status)){
    int language_ = Util.getIntValue(language);
    states = SystemEnv.getHtmlLabelName(1232,language_);
}
String other ="";
RecordSet.executeSql("select lastlogindate from HrmResource where id = "+id);
RecordSet.next();
String lastlogindate = RecordSet.getString(1).trim();

out.print("{\"messageUrl\":\""+messageUrl+"\",\"name\":\""+name+"\",\"sex\":\""
        +sex+"\",\"depName\":\""+DepartmentComInfo.getDepartmentname(depId)+"\",\"jobName\":\""
        +JobtitlesComInfo.getJobTitlesname(jobId)+"\",\"managerName\":\""
        +ResourceComInfo.getLastname(managerId)+"\",\"mobile\":\""+mobile+"\",\"phone\":\""+phone+"\",\"email\":\""
        +email+"\",\"states\":\""+states+"\",\"status\":\""+status+"\",\"type\":\""+type+"\",\"isadmin\":"+canRe+",\"lastlogindate\":\""+lastlogindate+"\""+other+"}");
%>
