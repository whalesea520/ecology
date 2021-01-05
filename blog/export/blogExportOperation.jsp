
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>  
<%@page import="weaver.file.ExcelStyle"%> 
<%@ page import="weaver.general.Util,
                 weaver.file.ExcelSheet,
                 weaver.file.ExcelRow" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>

<%
String sql = "";
try{
	String department = Util.null2String(request.getParameter("department"));
	String subdepartment = Util.null2String(request.getParameter("subdepartment"));
	String userid = Util.null2String(request.getParameter("userid"));
	String fromdate = Util.null2String(request.getParameter("fromdate"));
	String enddate = Util.null2String(request.getParameter("enddate"));
	
	sql = "select userid , createdate, createtime ,content from blog_discuss where 1=1 ";
	if(!"".equals(department)){
		sql += " and userid in ( SELECT id FROM HrmResource WHERE departmentid = "+department+")"; 
	}
	
	if(!"".equals(subdepartment)){
		sql += " and userid in ( SELECT id FROM HrmResource WHERE subcompanyid1 in ("+subdepartment+"))";
	}
	
	if(!"".equals(userid)){
		sql += " and userid in ("+userid+")";
	}
	
	if(!"".equals(fromdate)){
		sql += " and createdate >= '"+fromdate+"'";
	}
	
	if(!"".equals(enddate)){
		sql += " and createdate <= '"+enddate+"'";
	}
	
	sql +=" order by createdate desc ,createtime desc";
	
	RecordSet.execute(sql);
	
	ExcelFile.init() ;
	ExcelSheet es = new ExcelSheet();
		
		
	ExcelStyle excelStyle = ExcelFile.newExcelStyle("Header");
	excelStyle.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor);
	excelStyle.setFontcolor(ExcelStyle.WeaverHeaderFontcolor);
	excelStyle.setFontbold(ExcelStyle.WeaverHeaderFontbold);
	excelStyle.setAlign(ExcelStyle.WeaverHeaderAlign);
	excelStyle.setCellBorder(ExcelStyle.WeaverBorderThin);
	
	//设置标题
	ExcelRow title = es.newExcelRow();
	title.addStringValue(SystemEnv.getHtmlLabelName(413,user.getLanguage()), "Header");
	es.addColumnwidth(5000);
	
	title.addStringValue(SystemEnv.getHtmlLabelName(124,user.getLanguage()), "Header");
	es.addColumnwidth(5000);
	
	title.addStringValue(SystemEnv.getHtmlLabelName(141,user.getLanguage()), "Header");
	es.addColumnwidth(5000);
	
	title.addStringValue(SystemEnv.getHtmlLabelName(97,user.getLanguage()), "Header");
	es.addColumnwidth(5000);
	
	title.addStringValue(SystemEnv.getHtmlLabelName(345,user.getLanguage()), "Header");
	es.addColumnwidth(5000);
	while(RecordSet.next()){
		ExcelRow er = es.newExcelRow();
		String blogid=RecordSet.getString("userid");
		String name = ResourceComInfo.getResourcename(RecordSet.getString("userid"));
		String deptName=DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(blogid));
		String subName=SubCompanyComInfo.getSubCompanyname(ResourceComInfo.getSubCompanyID(blogid));
		String time = RecordSet.getString("createdate")+" "+RecordSet.getString("createtime");
		String content = RecordSet.getString("content");
		content = content.replaceAll("<[^>].*?>","").replaceAll("&nbsp;","").replaceAll("\n","").replaceAll("\t","");
		
		
		er.addStringValue(name);
		er.addStringValue(deptName);
		er.addStringValue(subName);
		er.addStringValue(time);
		er.addStringValue(content);
	}
	
	
	ExcelFile.setFilename(SystemEnv.getHtmlLabelName(26759,user.getLanguage())) ;
	ExcelFile.addSheet(SystemEnv.getHtmlLabelName(26759,user.getLanguage()), es) ;
}catch(Exception e){
	new BaseBean().writeLog(sql);
	new BaseBean().writeLog(e);
}
%>

<script language="javascript">
    window.location="/weaver/weaver.file.ExcelOut";
</script>
