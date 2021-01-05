<%@ page import="weaver.general.Util,java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.templetecheck.CheckUtil" %>
<%@ page import="weaver.templetecheck.ConfigOperation" %>
<%@ page import="weaver.templetecheck.CheckConfigFile" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.file.Prop" %>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<head>
</head>
<%!
public ExcelSheet getDetailExcel(HttpServletRequest request,HttpServletResponse response,User user,ExcelSheet es,ExcelRow erHead,Map map){
	if(es == null){
		es = new ExcelSheet();
		erHead = es.newExcelRow();
	}
	
	CheckConfigFile ccf = new CheckConfigFile();
	//Map<String,String> map = new HashMap<String,String>();
// 	String filetype = Util.null2String(request.getParameter("filetype"));
// 	String ids = Util.null2String(request.getParameter("ids"));
// 	String status = Util.null2String(request.getParameter("status"));
// 	String filename  = Util.null2String(request.getParameter("filename"));
// 	String attrname  = Util.null2String(request.getParameter("attrname"));
// 	String attrvalue = Util.null2String(request.getParameter("attrvalue"));
	String filetype = Util.null2String(map.get("filetype"));
	String ids = Util.null2String(map.get("ids"));
	String status = Util.null2String(request.getParameter("status"));
	String filename  = Util.null2String(map.get("filename"));
	String attrname  = Util.null2String(map.get("attrname"));
	String attrvalue = Util.null2String(map.get("attrvalue"));

if(filetype.equals("1")){
		es.addColumnwidth(4000);
		es.addColumnwidth(6000);
		es.addColumnwidth(4000);
		es.addColumnwidth(10000);
		es.addColumnwidth(10000);
		es.addColumnwidth(40000);
		erHead.addStringValue("文件类型", "Header");
		erHead.addStringValue("文件路径", "Header");
		erHead.addStringValue("属性名", "Header");
		erHead.addStringValue("标准配置", "Header");
		erHead.addStringValue("本地配置", "Header");
		erHead.addStringValue("配置状态", "Header");
	}else if(filetype.equals("2")){
		es.addColumnwidth(4000);
		es.addColumnwidth(6000);
		es.addColumnwidth(18000);
		es.addColumnwidth(4000);
		erHead.addStringValue("文件类型", "Header");
		erHead.addStringValue("文件路径", "Header");
		erHead.addStringValue("标准配置", "Header");
		erHead.addStringValue("配置状态", "Header");
	}
	//		topHead.addStringValue(systemInfo, "TopInfo", 5);
	es.addExcelRow(erHead);
	List<Map<String,String>> list = ccf.getMatchResult(user,map,request,response);
	int rowindex = 1;
	String styleName = "";
	if (null != list && list.size() > 0) {
		for(Map<String,String> m:list){
			if (rowindex % 2 == 0) {
				styleName = "light";
			} else {
				styleName = "dark";
			}
			ExcelRow er = es.newExcelRow();
			er.addStringValue(m.get("filetype"), styleName);
			er.addStringValue(m.get("filepath"), styleName);
			if(filetype.equals("1")){
				er.addStringValue(m.get("attrname"), styleName);
			}
			er.addStringValue(m.get("attrvalue"), styleName);
			if(filetype.equals("1")){
				er.addStringValue(m.get("localvalue"), styleName);
			}
			er.addStringValue(m.get("statusname"), styleName);
			es.addExcelRow(er);
			rowindex++;
		}
	}
	return es;
}

%>
<%
	User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
	String from =Util.null2String(request.getParameter("from"));
	CheckConfigFile checkConfigFile = new CheckConfigFile();
	String fileName = "";
	

	ExcelSheet es = new ExcelSheet();
	ExcelRow erHead = es.newExcelRow();
	ExcelFile.init();
	
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
	estLight.setFontcolor(ExcelStyle.WeaverHeaderFontcolor);
	estLight.setAlign(ExcelStyle.ALIGN_LEFT);
	
	
	if(from!=null&&from.equals("ConfigManager")){
		fileName = "配置文件信息列表";
		Map<String,String> map = new HashMap<String,String>();
		String kbversion = Util.null2String(request.getParameter("kbversion"));
		String filename = Util.null2String(request.getParameter("filename"));
		String fileinfo = Util.null2String(request.getParameter("fileinfo"));
		String sysversion  = Util.null2String(request.getParameter("sysversion"));
		map.put("kbversion",kbversion);
		map.put("sysversion",sysversion);
		map.put("filename",filename);
		map.put("fileinfo",fileinfo);
		
		es.addColumnwidth(4000);
		es.addColumnwidth(6000);
		es.addColumnwidth(3000);
		es.addColumnwidth(6000);
		es.addColumnwidth(8000);
		es.addColumnwidth(4000);
		es.addColumnwidth(3000);
		es.addColumnwidth(18000);
		//		topHead.addStringValue(systemInfo, "TopInfo", 5);
		erHead.addStringValue("版本号", "Header");
		erHead.addStringValue("文件名称", "Header");
		erHead.addStringValue("QC号", "Header");
		erHead.addStringValue("文件路径", "Header");
		erHead.addStringValue("功能说明", "Header");
		erHead.addStringValue("系统版本号", "Header");
		erHead.addStringValue("是否正确配置", "Header");
		erHead.addStringValue("配置项设置", "Header");
		es.addExcelRow(erHead);
		ConfigOperation configOperation = new ConfigOperation();
		List<Map<String,String>> list = configOperation.getConfigFileList(user,map,request,response);
		int rowindex = 1;
		String styleName = "";
		List<ExcelSheet> eslist = new ArrayList<ExcelSheet>();
		List<String> filenames = new ArrayList<String>();
		if (null != list && list.size() > 0) {
			
			for (Map<String,String> m:list) {
// 				if (rowindex % 2 == 0) {
					styleName = "light";
// 				} else {
// 					styleName = "dark";
// 				}
				String id = Util.null2String(m.get("id"));
				ExcelRow er = es.newExcelRow();
				
				er.addStringValue(m.get("kbversion"), styleName);
				er.addStringValue(m.get("filename"), styleName);
				er.addStringValue(m.get("qcnumber"), styleName);
				er.addStringValue(m.get("filepath"), styleName);
				er.addStringValue(m.get("fileinfo"), styleName);
				er.addStringValue(m.get("sysversion"), styleName);
				er.addStringValue(m.get("isconfiged"), styleName);
			
				//获取明细sheet
				Map<String,String> map1  = new HashMap<String,String>();
				map1.put("filetype",m.get("filetype"));
				map1.put("ids",id);
				ExcelSheet esDetail = getDetailExcel(request,response,user,null,null,map1);
				filenames.add(m.get("filename")+"明细_"+rowindex);
				eslist.add(esDetail);
				
				er.addStringValue("见Sheet:"+m.get("filename")+"明细_"+rowindex, styleName);
				es.addExcelRow(er);
				rowindex++;
			}
			ExcelFile.addSheet(fileName, es);
			int sheetIndex = 2;
			for( int i=0;i<eslist.size();i++){
				ExcelFile.addSheet(filenames.get(i), eslist.get(i));
				sheetIndex++;
			}
		}
	}
	
	if(from!=null&&from.equals("CheckConfigResult")){
		Map<String,String> map = new HashMap<String,String>();
		String filetype = Util.null2String(request.getParameter("filetype"));
		String ids = Util.null2String(request.getParameter("ids"));
		String status = Util.null2String(request.getParameter("status"));
		String filename  = Util.null2String(request.getParameter("filename"));
		String attrname  = Util.null2String(request.getParameter("attrname"));
		String attrvalue = Util.null2String(request.getParameter("attrvalue"));
		map.put("filetype",filetype);
		map.put("ids",ids);
		map.put("status",status);
		map.put("filename",filename);
		map.put("attrname",attrname);
		map.put("attrvalue",attrvalue);
		if(filetype.equals("1")){
			fileName = "Properties文件检测结果列表";
			es.addColumnwidth(4000);
			es.addColumnwidth(6000);
			es.addColumnwidth(4000);
			es.addColumnwidth(10000);
			es.addColumnwidth(10000);
			es.addColumnwidth(40000);
			erHead.addStringValue("文件类型", "Header");
			erHead.addStringValue("文件路径", "Header");
			erHead.addStringValue("属性名", "Header");
			erHead.addStringValue("标准配置", "Header");
			erHead.addStringValue("本地配置", "Header");
			erHead.addStringValue("配置状态", "Header");
		}else if(filetype.equals("2")){
			fileName = "Xml文件检测结果列表";
			es.addColumnwidth(4000);
			es.addColumnwidth(6000);
			es.addColumnwidth(18000);
			es.addColumnwidth(4000);
			erHead.addStringValue("文件类型", "Header");
			erHead.addStringValue("文件路径", "Header");
			erHead.addStringValue("标准配置", "Header");
			erHead.addStringValue("配置状态", "Header");
		}
		//		topHead.addStringValue(systemInfo, "TopInfo", 5);
		es.addExcelRow(erHead);
		List<Map<String,String>> list = checkConfigFile.getMatchResult(user,map,request,response);
		int rowindex = 1;
		String styleName = "";
		if (null != list && list.size() > 0) {
			for(Map<String,String> m:list){
				if (rowindex % 2 == 0) {
					styleName = "light";
				} else {
					styleName = "dark";
				}
				ExcelRow er = es.newExcelRow();
				er.addStringValue(m.get("filetype"), styleName);
				er.addStringValue(m.get("filepath"), styleName);
				if(filetype.equals("1")){
					er.addStringValue(m.get("attrname"), styleName);
				}
				er.addStringValue(m.get("attrvalue"), styleName);
				if(filetype.equals("1")){
					er.addStringValue(m.get("localvalue"), styleName);
				}
				er.addStringValue(m.get("statusname"), styleName);
				es.addExcelRow(er);
				rowindex++;
			}
		}
		ExcelFile.setFilename(fileName);
		ExcelFile.addSheet(fileName, es);
	}

	
%>
<iframe name="ExcelOut" id="ExcelOut" src="/weaver/weaver.file.ExcelOut" style="display:none" ></iframe>
</html>