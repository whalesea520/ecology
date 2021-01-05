<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="com.weaver.file.FileOperation"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<head>
</head>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

HashMap<String,String> files = FileOperation.getErrorfiles();
Iterator<Map.Entry<String,String>> it  = files.entrySet().iterator();

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
er.addStringValue(SystemEnv.getHtmlLabelName(18493,user.getLanguage()), "Header");
int num = 0;
while(it.hasNext()) {
	Map.Entry<String,String> map = it.next();
	String filename = map.getValue();
	er = es.newExcelRow();
	er.addStringValue(Util.null2String(++num), "Border");
	er.addStringValue(Util.null2String(filename), "Border");
}
ExcelFile.setFilename("errorFilesExcel");
ExcelFile.addSheet(SystemEnv.getHtmlLabelName(33728,user.getLanguage()), es);
%>
<iframe name="ExcelOut" id="ExcelOut" src="/weaver/weaver.file.ExcelOut" style="display:none" ></iframe>
</html>