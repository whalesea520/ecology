<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="weaver.common.util.taglib.ShowColUtil"%>
<%@ page import="weaver.general.PageIdConst"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="AccountType" class="weaver.general.AccountType" scope="page" />
<jsp:useBean id="HrmTransMethod" class="weaver.hrm.HrmTransMethod" scope="page" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

List<String[]> lsCol = null;
if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user)){
	lsCol = ShowColUtil.getUserColList(PageIdConst.HRM_ResourceSearchResultByManager,user);
}else{
	lsCol = ShowColUtil.getUserColList(PageIdConst.HRM_ResourceSearchResult,user);
}
if(lsCol==null) return;

//String strSql = Util.null2String(request.getParameter("sql"));
String strSql = Util.null2String((String)request.getSession().getAttribute("HrmResourceSearchResultExcelSql")); 
//RecordSet.writeLog("================================================"+strSql);
RecordSet.executeSql(strSql);
ExcelFile.init();
ExcelSheet es = new ExcelSheet();
ExcelStyle excelStyle = ExcelFile.newExcelStyle("Border");
excelStyle.setCellBorder(ExcelStyle.WeaverBorderThin);
ExcelStyle excelStyle1 = ExcelFile.newExcelStyle("Header");
excelStyle1.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor);
excelStyle1.setFontcolor(ExcelStyle.WeaverHeaderFontcolor);
excelStyle1.setFontbold(ExcelStyle.WeaverHeaderFontbold);
excelStyle1.setAlign(ExcelStyle.WeaverHeaderAlign);
excelStyle1.setCellBorder(ExcelStyle.WeaverBorderThin);
ExcelRow er = es.newExcelRow();

for(String[] col:lsCol){
	//去除是否在线
	if(col[1].equals("547"))continue;
	er.addStringValue(SystemEnv.getHtmlLabelNames(col[1],user.getLanguage()), "Header");
}

while(RecordSet.next()){
	er = es.newExcelRow();
	for(String col[]:lsCol){
		if(col[1].equals("547"))continue;
		String fieldname = col[0];
		if(fieldname.equals("id")){
			er.addStringValue(ResourceComInfo.isOnline(Util.null2String(RecordSet.getString(fieldname))), "Border");
		}else if(fieldname.equals("accounttype")){
			er.addStringValue(AccountType.getAccountType(Util.null2String(RecordSet.getString(fieldname))), "Border");
		}else if(fieldname.equals("sex")){
			er.addStringValue(ResourceComInfo.getSexName(Util.null2String(RecordSet.getString(fieldname))), "Border");
		}else if(fieldname.equals("subcompanyid1")){
			er.addStringValue(SubCompanyComInfo.getSubCompanyname(Util.null2String(RecordSet.getString(fieldname))), "Border");
		}else if(fieldname.equals("departmentid")){
			er.addStringValue(DepartmentComInfo.getDepartmentname(Util.null2String(RecordSet.getString(fieldname))), "Border");
		}else if(fieldname.equals("managerid")){
			er.addStringValue(ResourceComInfo.getResourcename(Util.null2String(RecordSet.getString(fieldname))), "Border");
		}else if(fieldname.equals("jobtitle")){
			er.addStringValue(JobTitlesComInfo.getJobTitlesname(Util.null2String(RecordSet.getString(fieldname))), "Border");
		}else if(fieldname.equals("mobile")){
			er.addStringValue(ResourceComInfo.getMobileShow(Util.null2String(RecordSet.getString("id")),""+user.getUID()), "Border");
		}else if(fieldname.equals("status")){
			er.addStringValue(ResourceComInfo.getStatusName(Util.null2String(RecordSet.getString(fieldname)),""+user.getLanguage()), "Border");
		}else if(fieldname.equals("jobactivity")){
			er.addStringValue(JobActivitiesComInfo.getJobActivitiesname(JobTitlesComInfo.getJobactivityid(Util.null2String(RecordSet.getString("Jobtitle")))), "Border");
		}else if(fieldname.equals("seclevel")){
			er.addStringValue(Util.null2String(RecordSet.getString("seclevel")), "Border");
		}else{
			er.addStringValue(HrmTransMethod.getDefineContent(Util.null2String(RecordSet.getString(fieldname)),fieldname+":"+user.getLanguage()), "Border");
		}
	}
}
ExcelFile.setFilename(SystemEnv.getHtmlLabelName(15929,user.getLanguage()));
ExcelFile.addSheet(SystemEnv.getHtmlLabelName(15929,user.getLanguage()), es);
%>
<iframe name="ExcelOut" id="ExcelOut" src="/weaver/weaver.file.ExcelOut" style="display:none" ></iframe>