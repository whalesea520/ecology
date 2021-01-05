<%@ page import="java.util.*" %><%@ 
page import="wscheck.CheckEnvironment" %><%@ 
page language="java" contentType="text/html; charset=UTF-8" %><%@ 
page import="weaver.hrm.*" %><%@ 
page import="weaver.file.*,wscheck.*,weaver.general.*,java.io.*,java.util.zip.*" %><%@ 
page import="weaver.file.Prop" %>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<head>
</head>

<%
	User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
CheckEnvironment ce = new CheckEnvironment();
Map fileMap = (Map)session.getAttribute("CompareEnvironmentMap");
String sourcePath =  Util.null2String(request.getParameter("sourcePath"));
String targetPath =  Util.null2String(request.getParameter("targetPath"));
String systemInfo = "源路径："+sourcePath+"   目标路径："+targetPath;
// create Excel
ExcelSheet es = new ExcelSheet();
ExcelRow topHead = es.newExcelRow();
ExcelRow erHead = es.newExcelRow();

ExcelFile.init();
es.addColumnwidth(1500);
es.addColumnwidth(10000);
es.addColumnwidth(5500);
es.addColumnwidth(4500);
es.addColumnwidth(4900);
String excelName ="环境对比结果";


ExcelStyle estTop = ExcelFile.newExcelStyle("TopInfo");
estTop.setGroundcolor(ExcelStyle.WeaverLightGroundcolor);
estTop.setFontcolor(ExcelStyle.WeaverHeaderFontcolor);
estTop.setFontbold(ExcelStyle.WeaverHeaderFontbold);
estTop.setAlign(ExcelStyle.ALIGN_LEFT);

ExcelStyle est = ExcelFile.newExcelStyle("Header");
est.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor1);
est.setFontcolor(ExcelStyle.WeaverHeaderFontcolor);
est.setFontbold(ExcelStyle.WeaverHeaderFontbold);
est.setAlign(ExcelStyle.ALIGN_LEFT);

ExcelStyle estDark = ExcelFile.newExcelStyle("dark");
estDark.setGroundcolor(ExcelStyle.WeaverDarkGroundcolor);
estDark.setFontcolor(ExcelStyle.WeaverHeaderFontcolor);
estDark.setAlign(ExcelStyle.ALIGN_LEFT);

ExcelStyle estLight = ExcelFile.newExcelStyle("light");
estLight.setGroundcolor(ExcelStyle.WeaverLightGroundcolor);
estLight.setFontcolor(ExcelStyle.WeaverHeaderFontbold);
estLight.setAlign(ExcelStyle.ALIGN_LEFT);

ExcelStyle estRed = ExcelFile.newExcelStyle("red");
estRed.setGroundcolor(ExcelStyle.WeaverLightGroundcolor);
estRed.setFontcolor(ExcelStyle.RED_Color);
estRed.setAlign(ExcelStyle.ALIGN_LEFT);

ExcelStyle estGreen = ExcelFile.newExcelStyle("green");
estGreen.setGroundcolor(ExcelStyle.WeaverLightGroundcolor);
estGreen.setFontcolor(ExcelStyle.GREEN_Color);
estGreen.setAlign(ExcelStyle.ALIGN_LEFT);

ExcelStyle estBlue = ExcelFile.newExcelStyle("blue");
estBlue.setGroundcolor(ExcelStyle.WeaverLightGroundcolor);
estBlue.setFontcolor(ExcelStyle.BLUE_Color);
estBlue.setAlign(ExcelStyle.ALIGN_LEFT);
String styleName = "";
topHead.addStringValue(systemInfo, "TopInfo", 5);
erHead.addStringValue("序号", "Header");
erHead.addStringValue("文件路径", "Header");
erHead.addStringValue("对比结果说明", "Header");
erHead.addStringValue("源环境最后修改日期", "Header");
erHead.addStringValue("目标环境最后修改日期", "Header");

es.addExcelRow(erHead);
int rowindex = 1;
if (null != fileMap && fileMap.size() > 0) {
	Set keyset = fileMap.keySet();
	for (Iterator it = keyset.iterator(); it.hasNext();) {
// 		if (rowindex % 2 == 0) {
// 			styleName = "light";
// 		} else {
// 			styleName = "dark";
// 		}
		String realfilepath = "";
		String filename = Util.null2String((String)it.next()).trim();
		String[] values = Util.null2String((String)fileMap.get(filename)).trim().split("[+]");
		String lastModifieddate_source="";
		String lastModifieddate_target="";
		String operatetype="";
		if(values.length==3){
			operatetype=values[0];
			lastModifieddate_source = values[1];
			lastModifieddate_target = values[2];
		}else{continue;}
	
		if(filename.startsWith("/")) {
			filename = filename.substring(1,filename.length());
		}
		styleName = operatetype.equals("2")?"red":operatetype.equals("1")?"green":"blue";
		if(operatetype.equals("1")||operatetype.equals("2")){
			realfilepath = ("\\".equals(""+File.separatorChar))?sourcePath+(filename.replaceAll("/","\\\\")):sourcePath+filename;
		}else if(operatetype.equals("0")){
			realfilepath =("\\".equals(""+File.separatorChar))? targetPath+(filename.replaceAll("/","\\\\")):targetPath+filename;
		}
		
		ExcelRow er = es.newExcelRow();
		er.addStringValue(String.valueOf(rowindex), "light");
		er.addStringValue(realfilepath, styleName);
		if (operatetype.equals("0")) {
			er.addStringValue("源环境不存在该文件", styleName);
		} else if (operatetype.equals("1")) {
			er.addStringValue("目标环境不存在该文件", styleName);
		} else if (operatetype.equals("2")) {
			er.addStringValue("目标与源环境文件不一致", styleName);
		}

		er.addStringValue(lastModifieddate_source, styleName);
		er.addStringValue(lastModifieddate_target, styleName);
		es.addExcelRow(er);
		rowindex++;
	}
	ExcelFile.setFilename(excelName);
	ExcelFile.addSheet("对比结果", es);
	
//114环境必须使用一下注释的这种写文件到本地，然后流下载，ecology环境用src="/weaver/weaver.file.ExcelOut" 这种方式，
//本来希望两个环境代码同步，但是一直报编码问题,暂时先这样解决
	
// 	String filepath="";
// 	try {
// 		filepath = ce.toFile(ExcelFile, excelName);
// 	} catch (Exception ex) {
// 		ex.printStackTrace();
// 	}
// 	File excelfile = new File(filepath);
	
// 	if (excelfile.exists()) {
// 		// 检查文件是否存在
// 		File obj = new File(filepath);
// 		response.reset();
// 		String fileName = excelfile.getName();
// 		// 写流文件到前端浏览器
// 		ServletOutputStream outs = response.getOutputStream();
// 		response.setHeader("Content-disposition", "attachment;filename=" + java.net.URLEncoder.encode(fileName, "GBK"));
// 		response.setContentType("application/x-download");
// 		BufferedInputStream bis = null;
// 		BufferedOutputStream bos = null;
// 		try {
// 			bis = new BufferedInputStream(new FileInputStream(filepath));
// 			bos = new BufferedOutputStream(outs);
// 			byte[] buff = new byte[2048];
// 			int bytesRead;
// 			while (-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
// 				bos.write(buff, 0, bytesRead);
// 			}
// 			bos.flush();
// 		} catch (IOException e) {
// 			throw e;
// 		} finally {
// 			if (bis != null)
// 				bis.close();
// 			if (bos != null)
// 				bos.close();
// 		}
// 	}
}
%>
<iframe name="ExcelOut" id="ExcelOut" src="/weaver/weaver.file.ExcelOut" style="display:none" ></iframe>
</html>