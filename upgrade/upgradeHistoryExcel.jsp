<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.file.Prop" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<head>
</head>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String sql = request.getParameter("sql");
RecordSet.executeSql(sql);
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
//表头
er.addStringValue("ID", "Header");
er.addStringValue(SystemEnv.getHtmlLabelName(25458,user.getLanguage())+SystemEnv.getHtmlLabelName(15486,user.getLanguage()), "Header");
er.addStringValue(SystemEnv.getHtmlLabelName(125604,user.getLanguage()), "Header");
er.addStringValue(SystemEnv.getHtmlLabelName(17530,user.getLanguage())+SystemEnv.getHtmlLabelName(33368,user.getLanguage()), "Header");
er.addStringValue(SystemEnv.getHtmlLabelName(724,user.getLanguage()), "Header");
er.addStringValue(SystemEnv.getHtmlLabelName(21663,user.getLanguage()), "Header");
er.addStringValue(SystemEnv.getHtmlLabelName(15502,user.getLanguage()), "Header");

while(RecordSet.next()) {
	er = es.newExcelRow();
	er.addStringValue(Util.null2String(RecordSet.getString("id")), "Border");
	er.addStringValue(Util.null2String(RecordSet.getString("label")), "Border");
	er.addStringValue(Util.null2String(RecordSet.getString("vesionNo")), "Border");
	er.addStringValue(Util.null2String(RecordSet.getString("content")), "Border");
	er.addStringValue(Util.null2String(RecordSet.getString("configcontent")), "Border");
	er.addStringValue(Util.null2String(RecordSet.getString("operationdate")), "Border");
	er.addStringValue(Util.null2String(RecordSet.getString("operationtime")), "Border");
}
ExcelFile.setFilename("upgradeHistory");
ExcelFile.addSheet(SystemEnv.getHtmlLabelName(33728,user.getLanguage()), es);
%>
<iframe name="ExcelOut" id="ExcelOut" src="/weaver/weaver.file.ExcelOut" style="display:none" ></iframe>
</html>